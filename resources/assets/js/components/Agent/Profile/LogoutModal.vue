<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
		
		<template #title>

			<h4 class="modal-title">{{trans('logout-from-all-devices')}}</h4>
		</template>

		<template #alert>
			
			<alert componentName="logout-modal"></alert>
		</template>
			
		<template #fields>

            <div v-focus-first-input>
                <text-field v-if="!loading" :label="trans('password')" :value="password" type="password" name="password" :required="true"
                            :placehold="lang('enter_password')" :onChange="onChange" :inputStyle="inputStyle">

                </text-field>
            </div>

			<div v-if="loading" class="row">
			
				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>	
		</template>

		<template #controls>

			<button class="btn" :class="[panel === 'client' ? 'btn-custom' : 'btn-primary']" @click="onSubmit()" :style="btnStyle">
				<i class="fas fa-check"> </i> {{trans('proceed')}}
			</button>
		</template>
	</modal>
</template>

<script>

	import axios from 'axios'

	import { errorHandler, successHandler } from '../../../helpers/responseHandler'
    import TextField from "../../MiniComponent/FormField/TextField.vue";
	
	export default {
		
		name : 'logout-modal',

		description : 'Logout Modal component',

		props:{
	
			showModal:{type:Boolean,default:false},

			onClose:{type: Function},

			userId : { type : [String, Number], default : ''},

			alertName : { type : String, default : 'edit_agent_profile'},

			btnStyle:{type: Object, default:()=>{}},

			inputStyle:{type: Object, default:()=>{}},

			panel: {type: String, default: 'agent'},
		},

		data(){

			return {

				isDisabled:true,

				containerStyle:{ width:'600px' },

				loading:false,

				password : '',
			}
		},

		methods:{

			onChange(value, name) {

				this[name] = value;
			},

			onSubmit(){

				if(this.password) {

					this.loading=true;

					let data = {};

					data['password'] = this.password;

					axios.post('/api/logoutFromAllDevice/'+this.userId,data).then(res=>{

						this.loading = false;
						
						successHandler(res,this.alertName);

						this.onClose();

					}).catch(err=>{

						this.loading = false;

						errorHandler(err,'logout-modal');

						this.$store.dispatch('unsetValidationError');
					})

				} else {

	      		this.$store.dispatch('setValidationError', {'password' : 'This field is required'})
	      	}
			}
		},

		components:{

			'text-field': TextField
		}
	};
</script>
