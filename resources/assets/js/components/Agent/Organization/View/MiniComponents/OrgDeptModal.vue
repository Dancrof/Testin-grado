<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>

			<h4 class="modal-title">{{lang('organization_department')}}</h4>
		</template>

		<template #alert>

			<alert componentName="org-dept"></alert>
		</template>

		<template #fields>

			<div v-if="!loading">

				<div class="row" v-focus-first-input>

					<text-field :label="label" :value="org_deptname" type="text" name="org_deptname"
								:onChange="onChange" classname="col-sm-4" :required="true">

					</text-field>

					<dynamic-select :label="lang('business_hours')" :multiple="false" name="business_hours" strlength="15"

									classname="col-sm-4" apiEndpoint="/api/dependency/business-hours" :value="business_hours" :onChange="onChange"  :clearable="business_hours ? true : false">


					</dynamic-select>

					<dynamic-select :label="lang('organization_department_manager')" :multiple="false" name="manager"
									classname="col-sm-4" :apiEndpoint="'/search/organization/manager/'+orgId" :value="manager" strlength="15" :onChange="onChange" :clearable="manager ? true : false">

					</dynamic-select>
				</div>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" :size="60" />
			</div>

		</template>

		<template #controls>

			<button type="button" @click="onSubmit()" class="btn btn-primary" id="submit_btn" :disabled="isDisabled">

				<i class="fa fa-check"></i> {{lang('proceed')}}
			</button>
		</template>
	</modal>
</template>

<script>

	import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

	import {validateOrgDeptSettings} from "../../../../../helpers/validator/orgDepartmentRules";

	import axios from 'axios'
	import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";
	import TextField from "../../../../MiniComponent/FormField/TextField.vue";

	export default {

		name : 'org-dept-modal',

		description : 'Organization Department Modal component',

		props:{

			showModal:{type:Boolean,default:false},

			orgId : { type : [String,Number], default : '' },

			onClose:{type: Function},

			deptId : { type : [String, Number], default : ''},
		},

		data(){

			return {

				isDisabled:false,

				containerStyle:{ width:'800px' },

				loading:false,

				manager : '',

				org_deptname : '',

				business_hours : '',

        label : (this.trans('organization_department_name').length >= 31) ? this.trans('organization_department_name').substring(0,30).concat('...'):this.trans('organization_department_name'),
			}
		},

		beforeMount(){
			if(this.deptId){

				this.getInitialValues(this.deptId)
			}
		},

		methods:{

			getInitialValues(id){

				this.loading = true;

				axios.get('/api/org-department-list/'+id).then(res=>{

					this.loading = false;

					this.org_deptname = res.data.data.org_deptname;

					this.business_hours = res.data.data.business_hour;

					this.manager = res.data.data.manager;

				}).catch(error=>{

					this.loading = false;
				})
			},

			onChange(value, name){

				this[name]= value;

				if(value === null) {

					this[name] = ''
				}
			},

			isValid(){

				const {errors, isValid} = validateOrgDeptSettings(this.$data);

				if(!isValid){

					return false
				}
				return true
			},


			onSubmit(){

				if(this.isValid()){

					this.loading = true

					this.isDisabled = true

					const obj={};

					obj['org_deptname'] = this.org_deptname;

					obj['business_hours_id'] = this.business_hours ? this.business_hours.id : '';

					obj['org_dept_manager'] = this.manager ? this.manager.id : '';

					obj['org_id'] = this.orgId;

					if(this.deptId){

						obj['org_dept_id'] = this.deptId;
					}

					axios.post('/create-update-org-dept',obj).then(res=>{

						this.loading = false;

						this.isDisabled = true

						successHandler(res,'OrgDepartmentsdataTableModal');

						window.emitter.emit('OrgDepartmentsrefreshData');

						this.onClose();

					}).catch(err => {

						this.loading = false;

						this.isDisabled = false;

						errorHandler(err,'org-dept');
					})
				}
			},
		},

		components:{

			"dynamic-select": DynamicSelect,

			"text-field": TextField,
		}
	};
</script>

<style type="text/css">

	#alert_msg {
		margin: 0px 5px 30px 5px;
	}

	#alert_top{
		margin-top:20px
	}
</style>
