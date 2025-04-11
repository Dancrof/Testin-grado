<template>
	
	<div class="col-sm-12">
	
		<div class="row" v-if="!hasDataPopulated || loading">
	
			<custom-loader :duration="4000"></custom-loader>
		</div>

		<alert componentName="departments"/>

		<div class="card card-light" v-if="hasDataPopulated">

			<div class="card-header">
				
				<h3 class="card-title">{{trans(title)}}</h3>

				<div v-if="dept_id" class="card-tools">
						
					<router-link class="btn-tool" :to="'/department/'+dept_id" v-tooltip="trans('view')">
		
						<i class="fas fa-eye"> </i> 
					</router-link>
				</div>
			</div>
				
			<div class="card-body">
				
				<div class="row" v-focus-first-input>
				
					<text-field :label="trans('name')" :value="name" type="text" name="name" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6"
						:required="true">
					
					</text-field>

					<radio-button :options="radioOptions" :label="trans('type')" name="type_id" :value="type_id" 
						:onChange="onChange" classname="form-group col-sm-6" :hint="trans('department-type')" >
					
					</radio-button>
				</div>
					
				<div class="row">
					
					<dynamic-select :label="trans('managers')" :multiple="true" name="managers" :prePopulate="true"
						classname="col-sm-6" :apiEndpoint="agents_api" :value="managers" :onChange="onChange" 
						:required="false" :hint="trans('department-manager')">
					
					</dynamic-select>

					<dynamic-select :label="trans('business_hour')" :multiple="false" name="business_hour" :prePopulate="true"
						classname="col-sm-6" apiEndpoint="/api/dependency/business-hours" :value="business_hour" 
						:onChange="onChange" :required="false" :hint="trans('business-hour-desc')">
					
					</dynamic-select>
				</div>

				<div class="row">
		
					<dynamic-select :label="trans('outgoing_email')" :multiple="false" name="outgoing_email" :prePopulate="true"
						classname="col-sm-6" apiEndpoint="/api/dependency/system-emails" :value="outgoing_email" 
						:onChange="onChange" :required="false" :hint="trans('department-outgoin-mail')">
					
					</dynamic-select>

					<dynamic-select :label="trans('teams')" :multiple="true" name="teams" classname="col-sm-6" :value="teams" 
						apiEndpoint="/api/dependency/teams" :onChange="onChange" :required="false">
					
					</dynamic-select>
				</div>

				<div v-if="apiCalled" class="row">
					
					<div id="dept-container" class="col-sm-6">{{departmentBoxMounted()}}</div>
				</div>

				<div class="row">

					<tiny-editor :value="department_sign" type="text" :onChange="onChange" name="department_sign" :label="trans('department_signature')" classname="col-sm-12" :required="false" :lang="'en'" id="department-edit-editor">
						
					</tiny-editor>
				</div>

				<div class="form-group col-md-12" id="text">
		
					<label class="label_align1">
			
						<input class="checkbox_align" type="checkbox" name="default" v-model="is_default"
							:disabled="isDisabled">&nbsp;{{trans('make-default-department')}}
					</label>
				
					<tool-tip :message="trans('default-department')" size="medium"></tool-tip>
				</div>
			</div>

			<div class="card-footer">

				<button type="button" @click="onSubmit" :disabled="loading" class="btn btn-primary">
						
					<span :class="iconClass"></span>&nbsp;{{trans(btnName)}}
				</button>
			</div>
		</div>
	</div>
</template>

<script>

	import axios from "axios";

	import {errorHandler,successHandler} from "../../../../helpers/responseHandler";

	import { validateDeptSettings } from "../../../../helpers/validator/departmentCreateRules";

	import {getIdFromUrl} from '../../../../helpers/extraLogics';
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import ToolTip from "../../../MiniComponent/ToolTip.vue";

	export default {

		name: "departments",

		description: "departments create and edit page",

		data() {

			return  {

				name: "",

				managers : [], 

				business_hour : null,

				outgoing_email : null,

				department_sign : "",

				teams : [],

				is_default : 0,

				type_id : 1, 

				loading: false,

				hasDataPopulated: true,

				radioOptions:[{name:'public',value:1},{name:'private',value:0}],

				title :'create_department', 

				iconClass:'fas fa-save',

				btnName:'save',

				dept_id :'',

				isDisabled : false,

				deptData : {},

				agents_api : '/api/dependency/department-qualifiable-managers',

				apiCalled : false,
			}
		},

		beforeMount() {

			const path = window.location.pathname;
			
			this.getValues(path);
		},

		methods: {

			departmentBoxMounted(){
      	
        		window.emitter.emit('dept-box-mounted',this.deptData);
        	},

			getValues(path){

				const deptId = getIdFromUrl(path);

				if(path.indexOf('edit') >= 0){

					this.title = 'edit_department';
					
					this.iconClass = 'fas fa-sync'
					
					this.btnName = 'update'
					
					this.hasDataPopulated = false;
					
					this.getInitialValues(deptId);

					this.agents_api = '/api/dependency/department-qualifiable-managers?supplements='+deptId;

				} else {
					
					setTimeout(()=>{

						this.apiCalled = true;
      			},1000)
					
					this.loading = false;

					this.hasDataPopulated = true
				}
			},

			getInitialValues(deptId) {
				
				this.loading = true;			
				
				axios.get('/api/admin/edit-department/'+deptId).then(res => {
				
					this.loading = false;
					
					this.hasDataPopulated = true;

					this.dept_id  = deptId;

					this.deptData = res.data.data.department;

					this.apiCalled = true;

					this.isDisabled = this.deptData.is_default ? true : false;
				
					this.updateStatesWithData(res.data.data.department);

				}).catch(err => {

					this.loading = false;

					errorHandler(err)
					
				});
			},

			updateStatesWithData(data) {
				
				const self = this;
				
				const stateData = this.$data;
				
				Object.keys(data).map(key => {
					
					if (stateData.hasOwnProperty(key)) {
					
						self[key] = data[key];
					}
				});
			},

			isValid() {
				
				const { errors, isValid } = validateDeptSettings(this.$data);
				
				return isValid;
			},

			onSubmit() {
				
				if (this.isValid()) {

					this.loading = true;

					const data = {};

					if(this.dept_id != ''){
						
						data['id'] = this.dept_id
					}

					data['name'] = this.name

					data['department_sign'] = this.department_sign;

					if(this.managers.length > 0) {
						
						data['manager_ids'] = this.managers.map(a => a.id);
					}

					if(this.teams.length){
						
						data['team_ids'] = this.teams.map(obj=>obj.id);
				
					} else {
					
						data['team_ids'] = [];
					}
						
					data['business_hour_id'] = this.business_hour ? this.business_hour.id : '';
						
					data['outgoing_email_id'] = this.outgoing_email ? this.outgoing_email.id : '';
						
					data['type_id'] = this.type_id
					
					if(this.is_default) {
						
						data['is_default'] = this.is_default							
					}
					
					window.emitter.emit('dept-data-submitting', data);

					axios.post('/api/admin/create-update-department', data).then(res => {
						
						this.loading = false;
						
						successHandler(res,'departments');
						
						if(!this.dept_id){

							setTimeout(()=>{

                let id = res.data.data.id
								return this.$router.push('/department/'+id);
							},3000)

						}else {
								
							this.getInitialValues(this.dept_id);
						}
					}).catch(err => {
							
						this.loading = false;
							
						errorHandler(err,'departments');
					});
				} 
			},

			onChange(value, name) {
				
				this[name] = value;
			}
		},

		components: {
		
			"text-field": TextField,
		
			"dynamic-select": DynamicSelect,

			'radio-button': RadioButton,
		
			'tool-tip': ToolTip,
		}
	};	
</script>

<style scoped>

	.label_align1 {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: 500 !important; padding-top: 0px;
	}
	.checkbox_align {
		width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden; cursor: pointer;
	}
	#text{
			display: inline-flex;
			display: -webkit-inline-box;
	}
</style>