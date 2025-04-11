<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>
		
			<h4 class="modal-title">{{lang('role_change')}} {{role}} to {{role_to}}</h4>
		
		</template>

		<template #fields>

			<div v-if="role_to === 'user' && !loading">

				<span>{{lang('changing_role_to_user')}} <b>{{user.user_name ? user.user_name : user.email }}</b>. {{lang('do_you_want_to_proceed_to_change_their_role_to_user')}} </span>

			</div>

			<div v-if="!loading && role_to !== 'user'" class="row">

				<dynamic-select :label="lang('departments')" :multiple="true" name="departments"
								classname="col-sm-12" apiEndpoint="/api/dependency/departments" :value="departments"
								:onChange="onChange" :required="true">

				</dynamic-select>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>
		</template>

		<template #controls>

			<button type="button" id="submit_btn" @click = "onSubmit" class="btn btn-primary" :disabled="isDisabled">
					
				<i class="fas fa-check"></i> {{lang('proceed')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

	import {validateUserRoleSettings} from "../../../../../helpers/validator/validateUserRoleRules";

	import axios from 'axios'
	import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {
		
		name : 'org-modal',

		description : 'Organization Modal component',

		props:{

			role : { type : String, default : ''},

			role_to : { type : String, default : ''},
			
			showModal : { type : Boolean, default : false},

			userId : { type : [String, Number], default : '' },

			onClose : { type : Function},

			dept : { type : Array, default:()=>[]},

			user : { type : Object, default : ()=>{}}
		},

		data(){
			
			return {

				isDisabled:false,

				containerStyle:{ width:'800px' },

				loading:false,
				
				departments  : this.dept
			}
		},


		computed : {

			apiUrl(){

				return '/role-change-' + this.role_to + '/';
			}
		},

		methods:{
			
			onSubmit(){
			
				if( (this.role_to == 'user' || this.isValid() ) ){
				    this.changeRole();
				}
			},

			changeRole(){

				this.loading = true;

				this.isDisabled = true;

				const data = {};

				if(this.role_to !== "user"){

					var depts = [];
								
					for(var i in this.departments){
								
						depts.push(this.departments[i].id)						
					}
								
					data['primary_department'] = depts;
				}

				axios.post(this.apiUrl+this.userId,data).then(res=>{

					successHandler(res,'user-view')
						
					this.afterSuccess();

				}).catch(error=>{

					errorHandler(error,'user-view')
								
					this.afterResponse();
				})
			},

			afterSuccess(){

				this.afterResponse();

				window.emitter.emit('refreshUserData');

				window.emitter.emit('UserTicketsrefreshData');
				
				window.emitter.emit('UserTicketsuncheckCheckbox')

				window.emitter.emit('refreshUserReport')
			},

			afterResponse(){

				this.loading = false;

				this.isDisabled = false;
				
				this.onClose();
			},

			isValid(){
				
				const {errors, isValid} = validateUserRoleSettings(this.$data);
				
				if(!isValid){
				
					return false
				}
				return true
			},

			onChange(value,name){
			
				this[name] = value;
			}
		},

		components:{

			"dynamic-select": DynamicSelect,
		}
	};
</script>