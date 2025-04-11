<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
	
		<template #title>

			<h4 class="modal-title">{{ title == 'email_verified' ? lang('email_verify') : lang('mobile-verify') }}</h4>
		</template>
		
		<template #fields>

			<div v-if="!loading" class="row" v-focus-first-input>

				<text-field v-if="title === 'email_verified'" :label="lang('email')" :value="email" type="email" name="email"
							:onChange="onChange" classname="col-sm-12" :required="true">

				</text-field>

				<phoneWithCountryCode v-if="title === 'mobile_verified'" id="mobile" classname="col-sm-12" name="mobile"
									  :onChange="onChange" :value="mobile" :countryCode="country_code" @countCode="getCountCode"
									  :required="true" :countryIso="iso" @countIso="getCountIso" @validPhoneNumber="checkValidity"
                     fieldType="FIXED_LINE_OR_MOBILE">

				</phoneWithCountryCode>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>
		</template>

		<template #controls>

			<button  type="button" @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">

				<i class="fas fa-check"></i> {{lang('update_and_verify')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

	import { validateUserStatusSettings } from "../../../../../helpers/validator/userStatusRules";

	import axios from 'axios'
	import TextField from "../../../../MiniComponent/FormField/TextField.vue";
	import PhoneWithCountryCode from "../../../../MiniComponent/FormField/PhoneWithCountryCode.vue";

	export default {
		
		name : 'user-modal',

		description : 'User Modal component',

		props:{
	
			showModal:{type:Boolean,default:false},

			userData:{type: [Object, String], default: ''},

			onClose:{type: Function},

			title : { type : String, default : ''},

		},

		data(){

			return {

				isDisabled:false,

				containerStyle:{ width:'600px' },

				mobile : this.userData.mobile === 'Not available' ? '' : this.userData.mobile,

				email : this.userData.email,

				country_code: this.userData.country_code === '' || this.userData.country_code === 0 ? 91 : 
											this.userData.country_code,

				loading:false,

				modal : this.title,

				data : {},

				iso : this.userData.iso,

        isPhoneValid: true
			}
		},

		methods:{

			getCountCode(value){

        this.country_code = value;
      },

      getCountIso(value){
          	
          	this.iso = value;
        	},

      onChange(value, name) {

	      this[name] = value;
	    },

	    isValid(){

				const {errors, isValid} = validateUserStatusSettings(this.$data);
				
				if(!isValid){
					
					return false
				}
				
				return true
			},

      checkValidity(name, value) {
        this.isPhoneValid = value;
      },

			onSubmit(){
				
				if(this.isValid() && this.isPhoneValid){

					this.loading = true
					
					this.isDisabled = true

					this.data['id'] = this.userData.id;

					if(this.modal === 'email_verified'){

						this.data['email'] = this.email;
					}

					if(this.modal === 'mobile_verified'){

						this.data['country_code'] = this.country_code;

						this.data['iso'] = this.iso;

						this.data['mobile'] = this.mobile;
					}

					axios.post('/manual-verify',this.data).then(res=>{

						window.emitter.emit('refreshMailAndMobile');
							
						successHandler(res,'user-view')
						
						this.loading = false;

						this.isDisabled = false;
							
						this.onClose();

					}).catch(err => {

						this.loading = false;
						
						this.isDisabled = false;

						errorHandler(err,'user-view');

						this.onClose();
					})
				}
			}
		},

	components:{

		'text-field': TextField,

		'phoneWithCountryCode': PhoneWithCountryCode,
	}
};
</script>