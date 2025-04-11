<template>

	<div class="col-sm-12">

		<div class="row" v-if="!hasDataPopulated || loading">

			<custom-loader :duration="4000"></custom-loader>	
		</div>

		<alert componentName="topic-create-edit"/>

		<faveo-box v-if="hasDataPopulated" :title="trans(page_title)">
		
			<div class="row" v-focus-first-input>

				<text-field :label="trans('topic')" :value="topic" 
					type="text" 
					name="topic" 
					:onChange="onChange" :placehold="lang('enter_a_value')"
					classname="col-sm-6" 
					:required="true"
					>
				</text-field>

				<radio-button :options="statusOptions" :label="trans('status')" name="status" :value="status"
					:onChange="onChange" classname="form-group col-sm-3">
									
				</radio-button>

				<radio-button :options="publicOptions" :label="trans('type')" name="type" :value="type"
					:onChange="onChange" classname="form-group col-sm-3" >
									
				</radio-button>
			</div>

			<div class="row">
				
				<dynamic-select :label="trans('linked_department')" :multiple="true" 
					name="linked_departments" classname="col-sm-6"
					apiEndpoint="/api/dependency/departments" 
					:value="linked_departments" :onChange="onChange" :strlength="35"
					:required="true">
				</dynamic-select>		

				<static-select :label="trans('default_department')" :elements="selectOptions" 
					name="department"  
					:onChange="onChange"
					:value="department" 
					classname="col-sm-6"
					:required="true" >

				</static-select>
			</div>

			<div v-if="showType" class="row">
				
				<dynamic-select :label="trans('type')" :multiple="true" 
					name="ticket_type" classname="col-sm-6"
					apiEndpoint="/api/dependency/types" 
					:value="ticket_type" :onChange="onChange" :strlength="35"
					:required="false">
				</dynamic-select>		
			</div>

			<div>

				<tiny-editor :value="internal_notes" :onChange="onChange" name="internal_notes" :label="trans('internal_notes')"
							 width="100%" :required="false" id="help-topic-editor" :lang="'en'">
						
				</tiny-editor>
			</div>

			<div class="row">
					
				<div class="col-md-12">
		
					<label class="label_align">
		
						<input class="checkbox_align" type="checkbox" 
							 name="default" v-model="sys_help_topic" :disabled="checkDisabled">
							 {{trans('make-default-helptopic')}}
					</label>
				</div>
			</div>

            <template #actions>

                <div class="card-footer">

                    <button id="submit_btn" class="btn btn-primary" @click="onSubmit()">

                        <i :class="iconClass"></i> {{trans(btnName)}}
                    </button>
                </div>
            </template>
		</faveo-box>
	</div>
</template>

<script>
	
	import axios from 'axios'

    import {successHandler,errorHandler} from "../../../../helpers/responseHandler";
	
	import  { getIdFromUrl } from '../../../../helpers/extraLogics';
	
	import { validateTopicSettings } from "../../../../helpers/validator/helptopicValidation.js";
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
	
	export default {
	
		name : 'helptopic-create-edit',
	
		description  : 'Helptopic create edit page',
	
		data(){
	
			return {
	
				page_title : 'create_help_topic',
	
				iconClass : 'fas fa-save',
	
				btnName : 'save',
	
				hasDataPopulated : false,
	
				loading : false,
	
				// essentials
				topic_id : '',
		
				topic : '',

				linked_departments : '',

				status : 1,

				statusOptions:[{name:'active',value:1},{name:'inactive',value:0}],

				type : 1,

				publicOptions:[{name:'public',value:1},{name:'private',value:0}],
	
				department : '',

				selectOptions: [],

				internal_notes : '',

				showType : false,

				ticket_type : [],

				sys_help_topic : 0,

				checkDisabled : false,
			}
		},
	
		beforeMount(){
	
			const path = window.location.pathname
			
			this.getValues(path);

			this.checkType();
		},
	
		methods : { 
			
			checkType() {

				axios.get('/api/admin/show-ticket-type-field').then(res=>{

					this.showType = res.data.data.showTicketTypeField.show_ticket_type_field;

					this.loading = false;
	
					this.hasDataPopulated = true;

				}).catch(err=>{

					this.loading = false;
	
					this.hasDataPopulated = true;
				});
			},

			getValues(path){
	
				const topicId = getIdFromUrl(path)
	
				if(path.indexOf('edit') >= 0){
	
					this.page_title = 'edit_help_topic'
	
					this.iconClass = 'fas fa-sync'
	
					this.btnName = 'update'
	
					this.hasDataPopulated = false
	
					this.getInitialValues(topicId)
				}
			},
	
			getInitialValues(id){
				
				this.loading = true
				
				axios.get('/api/admin/helptopic-details/'+id).then(res=>{
	
					this.loading = false;
	
					this.hasDataPopulated = true
	
					let topicData = res.data.data.topic;

					this.topic_id = topicData.id;
	
					this.updateStatesWithData(topicData);

					this.selectOptions = topicData.linked_departments;

					this.department = topicData.department.id;

					this.linked_departments = topicData.linked_departments;

					this.checkDisabled = topicData.sys_help_topic ? true : false;
				
				}).catch(error=>{
	
					this.loading = false;
		
					errorHandler(error,'topic-create-edit')
				});
			},
	
			updateStatesWithData(data){
	
				const self = this;
				
				const stateData = this.$data;
				
				Object.keys(data).map(key => {
					
					if (stateData.hasOwnProperty(key)) {
					
						self[key] = data[key];
					}
				});
			},
	
			isValid(){
	
				const { errors, isValid } = validateTopicSettings(this.$data);
				
				return isValid;
			},
			
			onChange(value, name) {

				this[name] = value;

				if(name == 'linked_departments') {

					if(value) {
						
						if(!value.map(a=>a.id).includes(this.department)){

							this.department = '';
						}						
						
						this.selectOptions = value;
					}
				}
			},
		
			onSubmit(){
						
				if(this.isValid()){
			
					this.loading = true 
		
					let data = {};
					
					if(this.topic_id){
					
						data['id'] = this.topic_id;
					}

					data['topic'] = this.topic;
					
					data['department'] = this.department;
					
					data['internal_notes'] = this.internal_notes;
					
					data['status'] = this.status ? 1 : 0;

					data['type'] = this.type ? 1 : 0;

					data['linked_departments'] = this.linked_departments.map(a => a.id);

					if(this.ticket_type.length){
						
						data['type_id'] = this.ticket_type.map(a => a.id);
					}
					
					data['sys_help_topic'] = this.sys_help_topic ? 1 : 0;

					axios.post('/api/admin/helptopic-create-update', data).then(res => {
					
						this.loading = false
						
						successHandler(res,'topic-create-edit')
						
						if(!this.topic_id){

							setTimeout(()=>{

								this.$router.push({ name : 'Helptopic Index' })
							},3000);

						} else {
						
							this.getInitialValues(this.topic_id)
						}
					}).catch(err => {
					
						this.loading = false
						
						errorHandler(err,'topic-create-edit')					
					});
				}
			}
		},
		components  : {

			"text-field": TextField,

			'dynamic-select': DynamicSelect,

			'static-select': StaticSelect,

			'radio-button': RadioButton
		}
	};
</script> 

<style scoped>
	.label_align {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: 500 !important; padding-top: 6px;
	}
	.checkbox_align {
		width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden; cursor: pointer;
	}
</style>