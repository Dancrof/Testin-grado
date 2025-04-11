<template>
	
		<div :class="{forgot_align : language === 'ar'}">

			<meta-component :dynamic_title="lang('password-email-title')" :dynamic_description="lang('password-email-description')" :layout="layout" >
				
			</meta-component>

			<div  id="content" class="site-content col-md-12">
			
				<alert componentName="password"/>

				<widget-component :layout="layout" :auth="auth"></widget-component>

        <div class="col-md-6 offset-md-3 form-helper">

          <div class="login-box" style="width:auto;" valign="center">

            <div class="form-border">

              <h3 class="login_title" slot="title">{{ lang('forgot_your_password') }}</h3>

              <slot name="fields"></slot>

              <slot name="controls"></slot>

              <slot name="links"></slot>

              <form-with-captcha btn-class="login-button btn btn-custom btn-block btn-flat mt-2" :btn-style="buttonStyle"
                                 btnName="reset_password" iconClass="fa fa-save" :formSubmit="onSubmit" page="forget_password"
                                 componentName="password" btn_id="forgot_pass_action" :loading="true" >

                <template #title>

                  <h3 id="h3">{{ lang(title) }}</h3>

                </template>


                <template #fields>

                  <div v-if="loading">

                    <loader :animation-duration="4000" :color="layout.portal.client_header_color" :size="50"/>
                  </div>

                  <div :class="{ align1 : language === 'ar'}" v-focus-first-input>

                    <text-field v-if="!loading" :label="lang('forgot_your_password')" :labelStyle="labelStyle" :value="email_address" id="forgot_pass_email" :inputStyle="inputStyle"
                                type="email" name="email_address" :keyupListener="triggerEvent" :onChange="onChange" :placehold="lang('email')" classname="" :required="true">

                    </text-field>
                  </div>
                </template>

                <template #actions>

                  <div v-if="!loading" class="row">

                    <div class="col-xs-6 col-sm-6 col-md-8" :class="{align1 : language === 'ar'}">

                      <router-link to="/auth/login" :style="linkStyle" id="forgot_to_login">{{ lang('i_know_my_password') }}</router-link>
                    </div>


                  </div>
                </template>

                <div class="col-xs-6 col-sm-6 col-md-4 float-end" :class="{left : language === 'ar'}">

                  <button class="btn btn-custom btn-block btn-flat" @click="onSubmit()" :style="buttonStyle" id="forgot_pass_action">
                    {{ lang('send') }}

                  </button>
                </div>
              </form-with-captcha>

            </div>
          </div>
        </div>
			</div>         
		</div>
</template>

<script>

	import {errorHandler, successHandler} from '../../../../helpers/responseHandler'

	import { validateResetPasswordSettings } from "../../../../helpers/validator/passwordResetRules";

	import axios from 'axios'

  import FormHelper from "../ReusableComponents/FormHelper.vue";
  import TextField from "../../../MiniComponent/FormField/TextField.vue";
  import WidgetBoxComponent from "../../ClientPanelLayoutComponents/WidgetBoxComponent.vue";
  import FormWithCaptcha from "../../../Common/Form/FormWithCaptcha.vue";

	export default {

		name : 'forgot-password',

		description : 'Forgot password component',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}}
		},

		data() {
			return {
			
				title:'forgot_password',
				
				loading:false,
				
		    email_address: "", 
				
				buttonStyle: {
					
					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				inputStyle : {
					borderColor : this.layout.portal.client_input_field_color
				},

				linkStyle : { color : this.layout.portal.client_header_color },

        labelStyle: {display:'none'},
				
				language : this.layout.language,

        isCaptchaValidated : false,
			}
		},

    created() {
      window.emitter.on('recaptcha-validated', ()=>{
        this.isCaptchaValidated = true;
      })
    },

    beforeMount(){

			if(!Array.isArray(this.auth.user_data)){
				this.$router.push({name:'Home'})
			}
		},

		methods: {

    	onChange(value, name) {

      	this[name] = value;
    	},

    	isValid() {

      	const { errors, isValid } = validateResetPasswordSettings(this.$data);

      	if (!isValid) {

        	return false;
      	}
      	return true;
    	},

    	onSubmit() {
        if (!this.shouldProceed()) {
          this.$store.dispatch('setAlert',{
            type:'danger', message:'Invalid ReCaptcha', component_name : 'password'
          })
          return;
        }

      	if (this.isValid()) {
      	
      		this.$Progress.start();
					
					this.isDisabled=true;
					
					this.loading=true;
					
					const data = 'email=' + this.email_address;
					
					axios.post('api/password/email',data).then(response =>{
					
						this.$Progress.finish();
						
						this.initialState();
						
						successHandler(response,'password');
						
						setTimeout(()=>{
							
							this.$router.push({ path:'/auth/login',name: 'Login'});
						},7000)
					
					}).catch(error=>{
					
						this.$Progress.fail();
					
						this.initialState();
						
						errorHandler(error,'password')
					})

          this.isDisabled = true;
	      }
	    },

	    initialState(){
	    		
	    	window.scrollTo(0, 0);
					
				this.isDisabled=false;
					
				this.loading=false;
	    },
				
			triggerEvent(event) {
				
				var key = event.which || event.keyCode;
				
				if (key === 13) {

					this.onSubmit()
				}
			},

      shouldProceed() {

        if (this.recaptchaApplyfor && this.recaptchaApplyfor.includes('forget_password')) {
          return this.isCaptchaValidated
        }

        return true;
      }
    },

		components:{
			'form-helper': FormHelper,
			
			"text-field": TextField,

			'widget-component': WidgetBoxComponent,

      "form-with-captcha": FormWithCaptcha
		}
	};
</script>

<style scoped>
	#h3 {
		margin-top: 0px;
		margin-bottom: 20px;
	}
	#wbox{
		margin-right:-5px !important;
	}
	.wid {
		margin-top: 2em !important;
		margin-bottom: 1.5em !important;
	}
	.forgot_align{
		direction: rtl;
	}
  .login_title{
    margin-bottom: 21px;
  }
</style>