0<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
		
		<template #title>
			
			<h4 class="modal-title">{{lang('merge-ticket')}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading" id="merge_content">

				<div class="row">

                    <dynamic-select :api-parameters="getApiParameters" optionLabel="title"
                        :label="lang('select-pparent-ticket')"
                        name="parentTicket"  classname="col-sm-6" :hint="trans('parent_ticket_tooltip')" api-endpoint="/api/agent/tickets/get-merge-tickets"
                        :value="parentTicket" :onChange="onChange" strlength="25" :required="true">

                    </dynamic-select>

<!--          disables the child ticket field if the parent ticket is not selected-->

                    <dynamic-select :api-parameters="getApiParameters" optionLabel="title"
                                    :label="lang('select_tickets')" :multiple="true" :hint="trans('selected_tickets_tooltip')"
                                    name="childTicket"  classname="col-sm-6" :api-endpoint="'/api/agent/tickets/get-merge-tickets?parent_ticket_id='+ parentTicketId"
                                    :value="childTicket" :onChange="onChange" strlength="30" :required="true" :disabled="childTicketDisabled">

                    </dynamic-select>
				</div>

        <div class="row">

          <text-field :label="lang('subject')" :value="title" type="text" name="title"
                      :onChange="onChange" classname="col-sm-6" :required="true" :placehold="lang('enter_a_value')">
          </text-field>
        </div>

				<div class="row">

					<text-field :label="lang('merge-reason')" :value="merge_reason" type="textarea" name="merge_reason"
								:onChange="onChange" classname="col-sm-12" :placehold="lang('enter_a_value')">
					</text-field>
				</div>

        <div class="row">

          <div class="col-sm-6">

            <checkbox id="mergerTickets_CC" name="mergerTickets_CC" :value="mergerTickets_CC" :label="trans('tickets_recipients_to_cc')"
                      :onChange="onChange" classname="col-sm-12">
            </checkbox>
          </div>
        </div>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" color="#1d78ff" :size="size"/>
			</div>
		</template>

		<template #controls>
			<button type="button" id="submit_btn" @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">

				<i class="fas fa-check"></i> {{lang('proceed')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import {validateTimelineMergeSettings} from "../../../../../../../helpers/validator/timelineMergeSettingRules";

	import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";

	import axios from 'axios'
	import TextField from "../../../../../../MiniComponent/FormField/TextField.vue";
	import StaticSelect from "../../../../../../MiniComponent/FormField/StaticSelect.vue";
	import DynamicSelect from "../../../../../../MiniComponent/FormField/DynamicSelect.vue";
  import Checkbox from "../../../../../../MiniComponent/FormField/Checkbox.vue";

	export default {
		
		name : 'timeline-merge-modal',

		description : 'Timeline merge ticket Modal component',

		props:{

			showModal:{type:Boolean,default:false},

			ticket : { type : Object, default : {} },

			onClose:{type: Function},

			componentTitle : { type : String, default :'timeline'},

			reloadTickets : { type : Function }
		},

		data:()=>({
			
			isDisabled:false,

			loading:false,

			size: 60,

			merge_reason : '',

			title : '',

			parent_tickets : '',

			parentTicket : '',

      parentTicketId : '',

			childTicket : '',

      childTicketDisabled : true,

      mergerTickets_CC: false
		}),

    beforeMount() {

      // Set the parent ticket details initially;
      let parentTicketDetails = {
        ticket_id : this.ticket.id,
        title : '#'+this.ticket.ticket_number +'(' + this.ticket.title + ')',
        name : this.ticket.title
      }

      this.onChange( parentTicketDetails, 'parentTicket');
    },

		computed : {

            getApiParameters(){

                return { 'ticket-id' : this.ticket.id };
            },

      containerStyle() {

        return { width: '900px', maxWidth: '900px !important' };
      }
		},

		methods:{
			
			isValid(){
				
				const {errors, isValid} = validateTimelineMergeSettings(this.$data)
				
				if(!isValid){
					
					return false
				}
				
				return true
			},

            onChange(value, name) {

                if(name === 'parentTicket') {

                  // Handles the fields based on the parent ticket
                  this.childTicketDisabled = !value;
                  this.childTicket = !value ? '' : this.childTicket;
                  this.title = value ? value.name : '';
                  this.parentTicket = value || '';
                  this.parentTicketId = value ? value.ticket_id : '';

                } else {

                    this[name] = value;
                }
            },
			
			onSubmit(){
			
				if(this.isValid()){
					
					this.loading = true
					
					this.isDisabled = true

					const data = {};

					data['title'] = this.title;
					
					data['p_id'] = this.parentTicketId;

					data['reason'] = this.merge_reason;
					
					data['_method'] = 'PATCH';
					
					data['t_id'] = this.childTicket.map(a => a.ticket_id);

          data['mergerTickets_CC'] = this.mergerTickets_CC;
					
					axios.post('/merge-tickets/'+this.ticket.id,data).then(res=>{

						this.loading = false;
						
						this.isDisabled = false;

						this.reloadTickets('timeline_merge');

						successHandler(res,this.componentTitle);
						
						this.onClose();
					
					}).catch(err => {
						
						this.loading = false;
						
						this.isDisabled = false
						
						errorHandler(err,this.componentTitle)

						this.onClose();
					})
				}
			},
		},

		components:{
      'checkbox' : Checkbox,

			'text-field': TextField,
			
			"static-select": StaticSelect,

			"dynamic-select": DynamicSelect,
		}
	};
</script>

<style>
	
	#merge_content {
		max-height: 350px;
    	overflow-y: auto;
    	overflow-x: hidden;
		padding-right: 5px;
	}
</style>