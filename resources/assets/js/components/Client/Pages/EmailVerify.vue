<template>
	
	<div class="email-verify">

		<alert componentName="email"/>

		<div v-if="getVerifyEmail" :class="{verify_align : lang_locale === 'ar'}">

			<meta-component :dynamic_title="lang('verify-email-title')" :layout="layout"
				:dynamic_description="lang('verify-email-description')" >
				
			</meta-component>

			<div id="content" class="site-content col-md-12 " >
		
				<alert componentName="updateEmail"/>

        <verification-progress active="email-verify"></verification-progress>

				<form-helper v-if="!updateEmail">

					<template #title>

						<h4 v-if="!loading" class="box-title" align="center"><p>{{lang('hello')}}</p>

							<span id="message-resend" style="font-size: .8em; display: none;">

								{{lang('activation-link-message')}}
							</span>

								<span id="message" style="font-size: .8em">

								{{lang('activation_link_sent')}} {{email_address}}. {{lang('click_link_to_activate')}}
							</span>
						</h4>
					</template>

					<template #controls>

						<div v-if="!loading" align="center">

							<button class="btn btn-custom btn-block btn-flat" @click="resendLink" :style="buttonStyle" id="verify_mail_resend">
								{{lang('resend_activation_link') }}</button>

							<p id="or">or</p>

							<a id="update_email" :style="linkStyle" href="javascript:void(0)" @click="showField()">
								{{ lang('update-email-address') }}</a>
						</div>
					</template>

					<template #fields>

						<div v-if="loading">

							<loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="50"/>
						</div>
					</template>
				</form-helper>

				<!-- =============================================== -->

				<form-helper v-if="updateEmail">

					<template #title>

						<h3 id="h3">{{ lang(title) }}</h3>

						<p v-if="!loading">{{ trans('update-verification-message') }}</p>
					</template>

					<template #fields>

						<div :class="{align1 : lang_locale === 'ar'}" v-focus-first-input>
							<text-field v-if="!loading" :label="lang('new_email_address')" :value="email_address" :input-style="inputStyle" type="email" name="email_address" :onChange="onChange" :placehold="lang('enter_a_value')" classname="" :required="true" id="new_email_address"></text-field>

							<text-field v-if="!loading" :label="lang('current_password')" :value="password" :input-style="inputStyle" type="password" name="password" :keyupListener="triggerEvent" :onChange="onChange" :placehold="lang('enter_a_value')" classname="" :required="true" id="current_password"></text-field>
						</div>

						<div v-if="loading">

							<loader :animation-duration="4000" :color="layout.portal.client_header_color" :size="50"/>
						</div>
					</template>

					<template #controls>

						<div v-if="!loading" class="row">

							<div class="col-xs-6 col-sm-6 col-md-8" :class="{align1 : lang_locale === 'ar'}">

								<router-link to="/auth/login" :style="linkStyle" id="email_verify_login_link">{{ lang('account_activated') }}</router-link>
							</div>

							<div class="col-xs-6 col-sm-6 col-md-4 pull-right" :class="{left : lang_locale === 'ar'}">

								<button id="email_update_btn" class="btn btn-custom btn-block btn-flat" @click="onSubmit" :style="buttonStyle">{{ lang('update') }}</button>
							</div>
						</div>
					</template>
				</form-helper>
			</div>         
		</div>

	</div>
</template>

<script>

	import {errorHandler, successHandler} from '../../../helpers/responseHandler'

	import { validateResetPasswordSettings } from "../../../helpers/validator/passwordResetRules";

	import { mapGetters } from 'vuex'

	import axios from 'axios'
    import FormHelper from "./ReusableComponents/FormHelper.vue";
    import WidgetBoxComponent from "../ClientPanelLayoutComponents/WidgetBoxComponent.vue";
    import TextField from "../../MiniComponent/FormField/TextField.vue";
  import VerificationProgress from "../ClientPanelLayoutComponents/ProgressBar.vue";

	export default {

		name : 'verify-email',

		description : 'Email verification Component',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}}
		},

		data() {
			return {

				loading:false,
				
				buttonStyle: {
				
					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				inputStyle : { borderColor : this.layout.portal.client_input_field_color},

				linkStyle : {
					color : this.layout.portal.client_header_color 
				},

				lang_locale : this.layout.language,

				isDisabled:false,

				email_address : '',

				password : '',

				updateEmail : false,

				title : 'update_email',

        isEmailVerified : true,

        message : 'Verification Completed Successfully, Redirecting to Log In page',

        verificationCompleted : false,
			}
		},

		computed:{

			...mapGetters(['getVerifyEmail'])
		},

		beforeMount(){

			this.email_address = this.getVerifyEmail;

			if(!this.email_address){

				this.$store.dispatch('setAlert',{type:'danger',message:this.lang('no_account_email_contact_admin'), component_name : 'email'});

				setTimeout(()=>{

					this.$router.push('/auth/login/');
				},3000)
			}

      this.apiCallForVerificationCheck(true);

      this.setTimeIntervalForVerificationCheck()
		},

		methods: {
      setTimeIntervalForVerificationCheck () {
        setInterval(() => {
          this.apiCallForVerificationCheck()
          if (this.isEmailVerified) {
            // this.$store.dispatch('setAlert',{
            //   type : 'success', message : this.message, component_name : 'updateEmail'
            // })

            // this.verificationCompleted = true;

            this.$router.push('/verification-completed');

            // setTimeout(()=>{
            //   this.$router.push('/auth/login/');
            // },3000)
          }
        }, 3000);
      },

      apiCallForVerificationCheck(beforeMount = false) {
        axios.get('/api/email-verification-status?email=' + this.email_address).then(res => {
          this.isEmailVerified = res.data.data.is_verified;

        }).catch(error => {
          this.isEmailVerified = false;
        })
      },
			
	    onChange(value, name) {
	      
	      this[name] = value;
	    },

			showField(){
				this.updateEmail = true
			},

	    isValid() {
	      
	      const { errors, isValid } = validateResetPasswordSettings(this.$data);
	      
	      if (!isValid) {
	        
	        return false;
	      }
	      return true;
	    },

	    onSubmit() {
	      
	      if (this.isValid()) {
	      	
	      	this.$Progress.start();
					
					this.isDisabled=true;
					
					this.loading=true;
					
					const data = { oldEmail: this.getVerifyEmail, email_address: this.email_address, password: this.password }
					
					axios.post('api/update-email-verification',data).then(response =>{
					
						this.$Progress.finish();
						
						this.initialState();
						
						successHandler(response,'updateEmail');
						
						setTimeout(()=>{
							
							this.$router.push({ path:'/auth/login',name: 'Login'});
						},4000)
					}).catch(error=>{
						
					this.$Progress.fail();
						
					this.initialState();
						
					errorHandler(error,'updateEmail')
					})
	      }
	    },

	    initialState(){
	    		
	    	window.scrollTo(0, 0);
					
				this.isDisabled=false;
					
				this.loading=false;
	    },
			
			triggerEvent(event) {
					
				var key = event.which || event.keyCode;
					
				if (key === 13) { // 13 is enter
					this.onSubmit()
				}
			},

			resendLink(){
				
				this.$Progress.start();
					
				this.isDisabled=true;
					
				this.loading=true;
					
				const data = { email: this.getVerifyEmail }
					
				axios.post('api/send-email-verification-link',data).then(response =>{
						
					this.$Progress.finish();
						
					this.initialState();
						
					successHandler(response,'updateEmail');
						
					setTimeout(()=>{
							
						this.$router.push({ path:'/auth/login',name: 'Login'});
					},4000)
				}).catch(error=>{
					
					this.$Progress.fail();
						
					this.initialState();
						
					errorHandler(error,'updateEmail')
				})
			}
		},

		components:{
      VerificationProgress,

			'form-helper': FormHelper,

			'widget-component': WidgetBoxComponent,

			"text-field": TextField,
				
		},
	};
</script>
<style scoped>
#h3 {
	margin-top: 0px;
	margin-bottom: 20px;
}
#or{
	margin :auto !important;
}
.verify_align{
		direction: rtl;
	}
	#message{
		word-break: break-word;
	}
</style>