<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #alert>

			<alert componentName="user-delete"/>
		</template>

		<template #title>

			<h4>{{lang('delete')}}</h4>
		</template>

		<template #fields>

			<template v-if="!loading">

				<div class="user-del">

					<b id="bold">{{lang('what_should_happen_to_tickets_owned_by')}} {{userData.user_name ? userData.user_name : userData.email }}?</b><br>

					<radio-button :options="reqOptions" :label="lang('Options')" name="condition" :value="condition"
								  :onChange="onChange" classname="form-group col-xs-12" :labelStyle="labelStyle">

					</radio-button>

					<dynamic-select v-if="condition == 'change_owner'"  :multiple="false" name="assign"
									:label="lang('select_owner')" classname="col-xs-12" :value="assign" :onChange="onChange"
									apiEndpoint="/api/dependency/users?meta=true" :required="true" :clearable="assign ? true : false"
									strlength="50" :labelStyle="labelStyle">

					</dynamic-select>
				</div>
			</template>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>
		</template>

		<template #controls>

			<button type="button" @click="onSubmit" class="btn btn-secondary" :disabled="isDisabled">

				<i class="fas fa-trash"></i> {{lang('delete')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

	import { validateUserDeleteSettings } from "../../../../../helpers/validator/userDeleteRules";

	import axios from 'axios'
	import RadioButton from "../../../../MiniComponent/FormField/RadioButton.vue";
	import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";
	
	export default {
		
		name : 'user-delete-modal',
	
		description : 'User Delete Modal component',
	
		props:{
	
			showModal:{type:Boolean,default:false},
	
			userData : { type : Object, default : ()=>{} },
	
			onClose:{type: Function}
		},
	
		data(){
	
			return {
	
				isDisabled:false,
	
				containerStyle : { width:'600px' },
				
				loading:false,
				
				labelStyle : { display:'none' },
								
				data : {},

				condition : 'nothing',

				assign : '',
				
				reqOptions:[
				
					{ name : 'do_nothing' , value : 'nothing' },

					{ name : 'delete_permanently' , value : 'delete' },
				
					{ name : 'change_requester' , value : 'change_owner'}
				]
			}
		},

		methods:{
		
			onChange(value,name){
		
				this[name]=value;

				this.assign = this.condition == 'change_owner' ? this.assign : '';
			},
			
			isValid(){
				
				const {errors, isValid} = validateUserDeleteSettings(this.$data);
		
				return isValid
			},
			
			onSubmit(){
				
				if(this.isValid()){
					
					this.loading = true
			
					this.isDisabled = true

					this.data['action_on_owned_tickets'] = this.condition;
					
					if(this.assign){

						this.data['set_owner_to'] = this.assign.id;
					}

					axios.delete('/api/account/delete/'+this.userData.id,{ data : this.data }).then(res=>{
					
						window.emitter.emit('refreshUserData', 'delete-modal');
						
						successHandler(res,'user-view')
					
						this.loading = false;
			
						this.isDisabled = false;
						
						this.onClose();
			
					}).catch(err => {
			
						this.loading = false;
					
						this.isDisabled = false;
			
						errorHandler(err,'user-delete');
		
					})
				}
			}
		},
		
		components:{
			
			'radio-button': RadioButton,
			
			'dynamic-select': DynamicSelect,
		}
	};
</script>