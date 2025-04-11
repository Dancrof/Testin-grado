<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>
		
			<h4 class="modal-title">{{lang(title)}}</h4>
		
		</template>

		<template #alert>

			<alert componentName="org-assign-modal"></alert>

		</template>
		
		<template #fields>

			<!-- removing organization -->

			<div v-if="title === 'remove' && !loading">

				<span>{{lang('are_you_sure_you_want_to_remove')}}</span>

			</div>

			<!-- assign existing organization -->

			<div v-if="title === 'assign' && !loading" class="row">

				<dynamic-select :label="lang('organizations')" :multiple="true" name="organizations"
								classname="col-sm-12" apiEndpoint="/api/dependency/organizations" :value="organizations"
								:onChange="onChange" :required="true">

				</dynamic-select>

				<dynamic-select v-if="deptCondition" :label="lang('organization_department')" :multiple="true" name="org_dept"
								classname="col-sm-12" :apiEndpoint="org_dept_api" :value="org_dept"
								:onChange="onChange" :required="false">

				</dynamic-select>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>
		</template>
					
		<template #controls>

			<button type="button" id="submit_btn" @click = "onSubmit" :class="btnClass" :disabled="isDisabled">
				<i :class="iconClass"></i> {{lang(btnName)}}
			</button>
		</template>
	</modal>

</template>

<script>
	
	import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

	import {validateAssignOrgSettings} from "../../../../../helpers/validator/validateAssignOrgRules";

	import axios from 'axios'
	import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {
		
		name : 'org-modal',

		description : 'Organization Modal component',

		props:{

			showModal : { type : Boolean, default : false},

			title : { type : String, default : '' },

			orgId : { type : [String, Number], default : '' },

			userId : { type : [String, Number], default : '' },

			onClose : { type : Function},

			deptCondition : { type : [Boolean, Number]}
		},

		data(){
			
			return {

				isDisabled:false,

				containerStyle:{ width:'800px' },

				loading:false,
				
				organizations  : [],

				org_dept : [],

				org_dept_api : '',

				btnName : this.title === 'assign' ? 'assign' : 'remove',

				btnClass : this.title === 'assign' ? 'btn btn-primary' : 'btn btn-secondary',
				
				iconClass : this.title === 'assign' ? 'fas fa-hand-point-right' : 'fas fa-unlink',
			}
		},

		methods:{
			
			onSubmit(){
			
				if(this.title === 'assign'){
					
					if(this.isValid()){

						this.loading = true;

						this.isDisabled = true;

						const data = {};

						data['organisation'] = this.organizations.map(obj=>obj.id);

						if(this.org_dept.length){

							data['organisation_department'] = this.org_dept.map(obj=>obj.id);

							let relatedArr = [];

							for(let i in this.org_dept) {

								relatedArr.push(JSON.stringify({org_dept:this.org_dept[i].id,org_id:this.org_dept[i].org_id }))
							}

							data['related'] = relatedArr;

						} else {

							data['organisation_department'] = [];

							data['related'] = [];
						}

						axios.post('/api/user-org-assign/'+this.userId,data).then(res=>{

							successHandler(res,'org-assign-modal')

							this.afterSuccess();

						}).catch(error=>{

							errorHandler(error,'org-assign-modal')

							this.afterResponse();
						})
					}
				}else{
				
					this.loading = true;
					
					this.isDisabled = true;

					axios.delete('/api/remove-user-org/'+this.userId+'/'+this.orgId).then(res=>{
				
						successHandler(res,'user-view')
				
						this.afterSuccess();
					
					}).catch(error=>{
						
						errorHandler(error,'user-view')
						
						this.afterResponse();
					})
				}	
			},

			afterSuccess(){

				this.afterResponse();

				setTimeout(()=>{

					window.emitter.emit('refreshUserData','org_link');

					this.onClose();

				},3000);
			},

			afterResponse(){

				this.loading = false;

				this.isDisabled = false;

			},

			isValid(){
				
				const {errors, isValid} = validateAssignOrgSettings(this.$data);
				
				if(!isValid){
				
					return false
				}
				return true
			},

			onChange(value,name){
			
				this[name] = value;

				if(name === 'organizations') {

					this.org_dept = '';

					var ids = [];

					if(value.length > 0){

						for(var i in value){

							ids.push(value[i].id)
						}
						
						this.org_dept_api = '/org/department/search?org_id='+ids;
					}
				}
			}
		},

		components:{
		
			"dynamic-select": DynamicSelect,
		}
	};
</script>