<template>
	
	<div>
		
		<modal v-if="deletePopup" :showModal="deletePopup" :onClose="onCloseModal">
			
			<template #title>
				
				<h4>{{lang('delete')}}</h4>
			</template>
			
			<template #fields>
				
				<div class="container" v-if="!loading">
					
					<div class="row">
						
						<div class="col-sm-12">
							
							<span class="float-start">{{lang('are_you_sure_you_want_to_delete')}}</span>
						</div>
					</div>
				</div>

                <div v-if="loading" class="row">

                    <reuse-loader :duration="4000"></reuse-loader>
                </div>

            </template>

			<template #controls>
				
				<button type="button" @click = "onSubmitDelete()" class="btn btn-secondary">

					<i class="fas fa-trash" aria-hidden="true"></i> {{lang('submit')}}
				</button>
			</template>
		</modal>
	
		<div v-for="(field, index) in fieldsArr" v-bind:key="index" class="row">

				<div class="col-md-5">

					<div class="row">

						<div class="col-md-1 float-end" id="mt8">

						<span class="fas fa-trash faveo-trash" @click="removeField(field.id,index)">

						</span>

						</div>

						<span class="col-sm-2" id="mt8">{{beforeLabel}}</span>

						<number-field :label="lang('count')"
						              :value="field.reminder_delta"
						              :name="fieldGroup+'-count-'+index"
						              classname="col-sm-3"
						              :onChange="onChange"
						              type="number"
						              :required="true"
						              :labelStyle="labelStyle"
						              placeholder="n"
						>
						</number-field>

						<static-select :label="lang('option')" :elements="selectOptions"
						               :name="fieldGroup+'-option-'+index"
						               :onChange="onChange"
						               classname="col-sm-5"
						               :value="field.option"
						               :labelStyle="labelStyle" :hideEmptySelect="true">

						</static-select>

						<span class="col-sm-1 px-2 text-center" id="mt8">to</span>
					</div>
				</div>

				<dynamic-select :label="lang('type')"
					:value="field.reminder_receivers.agent_types"
					:onChange="onChange"
					:name="fieldGroup+'-type-'+index"
					apiEndpoint="/api/dependency/agent-types"
					:multiple="true" classname="col-sm-3"
					strlength="20"
					:placeholder="lang('select_agent_types')"
					:labelStyle="labelStyle">

				</dynamic-select>

				<dynamic-select :label="lang('agents')"
					:value="field.reminder_receivers.agents"
					:onChange="onChange"
					:name="fieldGroup+'-agent-'+index"
					apiEndpoint="/api/dependency/agents?meta=true"
					:multiple="true"
					classname="col-sm-4" strlength="25"
					:placeholder="lang('select_agents')"
					:labelStyle="labelStyle">

				</dynamic-select>
		</div>

			 <div class="">

          <a @click="addField" href="javascript:;">

          	<span><i class="fas fa-plus-circle" aria-hidden="true"></i> {{lang('add_new_rule')}}</span>
          </a>
      </div>
	</div>
</template>

<script>

import {errorHandler,successHandler} from "../../../../../helpers/responseHandler";
import StaticSelect from "../../../../MiniComponent/FormField/StaticSelect.vue";
import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";
import NumberField from "../../../../MiniComponent/FormField/NumberField.vue";

export default {

	name: 'dynamic-sla-field',

	description : 'Dynamic SLA field component',

	props : {

		fieldsArr : { type : Array, default : ()=>[]},

		fieldGroup : { type : String, default : ''},

		from : { type : String, default : ''},

		onFieldChange : { type : Function}
	},

	data () {

		return {
		
			blockRemoval: true,
		
			selectOptions: [{id: 'minute', name: 'Minute(s)'}, {id: 'hour', name: 'Hour(s)'},{id: 'day', name: 'Day(s)'}],

			labelStyle : { display : 'none' },

			loading : false,

			deletePopup: false,

			reminderId : '',

			index : '' 
		}
	},

	watch: {
	
		fieldsArr () {

			this.blockRemoval = this.fieldsArr.length <= 1
		}
	},

	computed : {

		beforeLabel() {

			if(this.fieldGroup === 'response' || this.fieldGroup === 'resolution'){

				return 'before'
			
			} else {

				return 'after'
			}
		}
	},

	methods: {
	
		addField () {

			this.fieldsArr.push({ 
				id : null,
				reminder_delta : '',
				option : 'minute',
				reminder_receivers: {
					agents : [],
					agent_types : [] 
				},
				type : this.fieldGroup
			})

			this.onFieldChange(this.fieldGroup,this.fieldsArr)
		},

		removeField (id,index) {

			if(id){

				this.deletePopup = true;

				this.reminderId = id;

				this.index = index;

			} else {
				
				this.fieldsArr.splice(index, 1)

				this.onFieldChange(this.fieldGroup,this.fieldsArr)
			}
		},

		onCloseModal() {
    
      this.deletePopup = false;
    },

    onSubmitDelete() {

    	this.loading = true;

			axios.delete('/api/delete-enforcer/reminder/'+this.reminderId+'/'+this.from).then(res=>{

				this.fieldsArr.splice(this.index, 1)
				
				this.onFieldChange(this.fieldGroup,this.fieldsArr)

				this.onCloseModal();

				successHandler(res, "sla");

			}).catch(error=>{

				errorHandler(error, "sla");

				this.loading = false;
			});
    },

		onChange(value,name){

			let nameArray = name.split('-')

			let index = nameArray[nameArray.length - 1]

			//field-count is the prefix that is given to the field
			if(name.includes(this.fieldGroup+'-count-')){
					
				this.fieldsArr[index].reminder_delta = value
			}

			//field-option- is the prefix that is given to the field
			if(name.includes(this.fieldGroup+'-option-')){
				
				this.fieldsArr[index].option = value
			}

			//field-type- is the prefix that is given to the field
			if(name.includes(this.fieldGroup+'-type-')){
					
				this.fieldsArr[index].reminder_receivers.agent_types = value
			}
				
			//field-agent- is the prefix that is given to field
			if(name.includes(this.fieldGroup+'-agent-')){
					
				this.fieldsArr[index].reminder_receivers.agents = value
			}

			this.onFieldChange(this.fieldGroup,this.fieldsArr)
		}
	},

	components : {

		"number-field": NumberField,
			
		"dynamic-select": DynamicSelect,
			
		"static-select": StaticSelect
	}
};
</script>

<style scoped>
	
	.resolution-approaches{

		top: 6px !important;

		cursor: pointer;
	}

	.glyphicon-plus{

		cursor: pointer;
	}

	#mt8{
		margin-top: 8px;
	}

	.d_flex{
		display: flex;
	}
</style>