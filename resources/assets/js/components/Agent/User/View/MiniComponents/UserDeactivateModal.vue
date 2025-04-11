<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #alert>

			<alert componentName="user-deactivate"/>
		</template>

		<template #title>

			<h4 class="modal-title">{{lang('deactivate')}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading">

				<b>{{lang('what_should_happen_to_tickets_requested_by')}} <i>{{user.meta_name ? user.meta_name : user.email }}</i> ?
				</b>

				<br><br>

				<div class="row">

					<radio-button :options="reqOptions" :label="lang('Options')" name="req_condition" :value="req_condition"
						:onChange="onChange" classname="form-group col-sm-12" :labelStyle="labelStyle">

					</radio-button>

					<dynamic-select v-if="req_condition == 'change_owner'"  :multiple="false" name="req_assign"
						:label="lang('select_owner')" classname="col-sm-12" :value="req_assign" :onChange="onChange"
						:apiEndpoint= "userAPI" :required="true" :clearable="req_assign ? true : false"
						strlength="50" :labelStyle="labelStyle">

					</dynamic-select>
				</div>
			</div>

			<div v-if="role != 'user'">

				<b id="bold">{{lang('what_should_happen_to_tickets_assigned_to')}} <i>{{user.meta_name ? user.meta_name : user.email }}</i> ?</b>

				<br><br>

				<div class="row">

					<radio-button :options="radioOptions" :label="lang('Options')" name="condition" :value="condition"
						:onChange="onChange" classname="form-group col-sm-12" :labelStyle="labelStyle">

					</radio-button>

					<dynamic-select v-if="condition == 'change_assignee'" :label="lang('assign')" :multiple="false"
						:labelStyle="labelStyle" name="assign"  classname="col-sm-12" :apiEndpoint="userEndpoint" strlength="50"
						:value="assign" :onChange="onChange" :required="true" :clearable="assign ? true : false">

					</dynamic-select>
				</div>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>

		</template>

		<template #controls>

			<button type="button" @click="onSubmit" class="btn btn-secondary" :disabled="isDisabled">

				<i class="fas fa-trash"></i> {{lang('deactivate')}}
			</button>
		</template>
	</modal>
</template>

<script>

	import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

	import { validateDeactivateSettings } from "../../../../../helpers/validator/deactivateRules";

	import axios from 'axios'
	import RadioButton from "../../../../MiniComponent/FormField/RadioButton.vue";
	import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {

		name : 'deactivate-modal',

		description : 'Deactivate Modal component',

		props:{

			showModal:{type:Boolean,default:false},

			userId : { type : [String, Number], default : '' },

			onClose:{type: Function},

			role : { type : String , default : '' },

			user : { type : Object, default : ()=>{}}
		},

		data(){

			return {

				isDisabled:false,

				containerStyle : { width:'650px' },

				radioOptions:[

					{ name : 'unassign_all_open_tickets' , value : 'surrender' },

					{ name : 'change_assignee' , value : 'change_assignee'}
				],

				loading:false,

				condition : 'surrender',

				assign : '',

				labelStyle : { display:'none' },

				data : {},

				req_condition : 'close',

				req_assign : '',

				reqOptions:[

					{ name : 'close_all_open_tickets' , value : 'close' },

					{ name : 'change_requester' , value : 'change_owner'}
				],
        userAPI : this.role === 'user' ? '/api/dependency/users?meta=true&supplements=user-only'
            :'/api/dependency/users?deactivate_id='+this.userId+'&meta=true',
				userEndpoint : this.role === 'user' ? '/api/dependency/users?meta=true&supplements=user-only'
												: '/api/dependency/users?deactivate_id='+this.userId+'&meta=true&supplements=agent-admin-only',
			}
		},

		methods:{

			onChange(value,name){

				this[name]=value;

				this.req_assign = this.req_condition == 'close' ? '' : this.req_assign;

				this.assign = this.condition == 'surrender' ? '' : this.assign;
			},

			isValid(){

				const {errors, isValid} = validateDeactivateSettings(this.$data);

				if(!isValid){

					return false
				}

				return true
			},

			onSubmit(){

				if(this.isValid()){

					this.loading = true

					this.isDisabled = true

					this.data['action_on_owned_tickets'] = this.req_condition;

					if(this.req_assign){

						this.data['set_owner_to'] = this.req_assign.id;
					}

					this.data['action_on_assigned_tickets'] = this.condition;

					if(this.assign){

						this.data['set_assignee_to'] = this.assign.id;
					}

					axios.post('/api/account/deactivate/'+this.userId,this.data).then(res=>{

						window.emitter.emit('refreshUserData','deactivate');

						successHandler(res,'user-view')

						this.loading = false;

						this.isDisabled = false;

						this.onClose();

					}).catch(err => {

						this.loading = false;

						this.isDisabled = false;

						errorHandler(err,'user-deactivate');

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

<style scoped>
	.deactive{
		max-height: 250px;
		min-height: 75px;
		overflow-x: hidden;
		overflow-y: auto;
	}
</style>
