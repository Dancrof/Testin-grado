<template>

	<div>
    <modal v-if="loginModal" :showModal="loginModal" :showbuttonName="buttonName"  :onClose="onClose" :containerStyle="{}"
       :handleEnter="onProceed">

      <template #title>
        <h4>{{lang('session_limit_reached_title')}}</h4>
      </template>
      <template #fields>
        <p class="alert alert-warning"><i class="fas fa-warning"></i>&nbsp;{{errorMessage}}</p>

      </template>

      <template #controls>
        <button type="button" @click = "onProceed" class="btn btn-primary"><i class="fa fa-save"></i> {{lang('proceed')}}</button>
      </template>

    </modal>

		<div v-if="!pageLoad" class="col-md-6 offset-md-3 form-helper">

			<div class="login-box" style="width:auto;" valign="center">

				<div class="form-border">

					<h3 class="login_title" slot="title" >{{ lang('login_to_start_your_session') }}</h3>

					<form-with-captcha btnClass="login-button btn btn-custom btn-block btn-flat mt-2"
						:btnStyle="buttonStyle" btnName="login" iconClass="" :formSubmit="onSubmit" page="login_page"
						:componentName="componentName" btn_id="default-login-button">

                        <template #fields>

                            <div class="row">

                                <div class="col-sm-12" v-focus-first-input>

                                    <text-field :layout="layout" :inputStyle="inputStyle"  :labelStyle="labelStyle" :label="lang('username')" :value="user_name"
                                                type="text" name="user_name" :keyupListener="triggerEvent" :onChange="onChange" defaultKey="user_name"
                                                :placehold="lang('email_username_placeholder')" classname="" :required="true" id="login_form_user_name">

                                    </text-field>

                                    <text-field :labelStyle="labelStyle" :layout="layout" :inputStyle="inputStyle"  :label="lang('password')" :value="password"
                                                type="password" name="password" :keyupListener="triggerEvent" :onChange="onChange"
                                                :placehold="lang('password')" classname="" :required="true" id="login_form_password">

                                    </text-field>

                                    <div :class="[ 'pull-left',{float1 : locale === 'ar'}]" id="remember_me">

                                        <input type="checkbox" v-model="remember" name="remember" id="login_form_remeber"> {{ lang('remember') }}
                                    </div>
                                </div>

                                <div v-if="loading" id="login_loader">

                                    <custom-loader :duration="4000" :color="layout.portal.client_header_color" :size="60"/>
                                </div>
                            </div>
                        </template>

                        <template #actions>

                            <div class="form-group">

                                <div id="default-login">

                                    <router-link to="/password/email" id="default-forgot-password" :style="linkStyle"
                                                 :class="{float1 : locale === 'ar'}">{{ lang('forgot_password') }}?
                                    </router-link>
                                </div>

                              <div class="d-grid">

                                <div id="login-box">{{loginBoxVisible()}}</div>
                              </div>

                              <div class="d-grid">

                                <button v-if="allow_register == 1" id="default-register-button"
                                        class="btn btn-custom btn-block btn-flat" @click="onRegister" :style="buttonStyle" :disabled="isDisabled">
                                  {{ lang('create_an_account') }}
                                </button><br>
                              </div>

                                <div class="d-grid" v-for="data in providerData && providerData.saml_meta_settings && providerData.saml_meta_settings.directory_settings">
                                  <button class="btn btn-custom btn-block btn-flat" :style="buttonStyle"
                                          @click="oneLoginRedirect(data)" id="OneLogin">{{data.login_button_label}} login</button>
                                </div>

                                <div v-if="providerData.basic_auth_providers">

                                  <div class="d-grid" v-for="data in providerData.basic_auth_providers">
                                    <button class="btn btn-custom btn-block btn-flat " :style="buttonStyle"
                                            @click="thirdpartyLogin('third_party_basic', data)" id="OneLogin">{{data}} login</button>
                                  </div>
                                </div>

                                <div v-if="!loading" v-for="provider in providerData.providers" :style="socialLoginBoxStyle">

                                  <ul class="list-unstyled" :class="{padd : locale === 'ar'}" style="width: 100%;">

                                    <li class="d-grid" :id="'social-'+provider">

                                      <button  :class="['btn btn-block btn-flat', providerClass(provider), 'btn-' + (provider === 'linkedin-openid' ? 'linkedin' : provider)]"   @click="socialRedirect(provider)" :id="'client_signin_provider-'+provider">

                                        <span :class="'fab fa-'+(provider === 'linkedin-openid' ? 'linkedin' : provider)"></span> {{ lang('sign_in_with') }} {{ provider === 'linkedin-openid' ? 'LinkedIn' : provider }}

                                      </button>
                                    </li>
                                  </ul>
                                </div>
                            </div>
                        </template>
					</form-with-captcha>
				</div>
			</div>
		</div>

		<div v-if="pageLoad">

			<custom-loader :duration="4000" :color="layout.portal.client_header_color" :size="60"/>
		</div>
	</div>
</template>

<script>

	import { errorHandler } from '../../../../../helpers/responseHandler'
	import { validateLoginSettings } from "../../../../../helpers/validator/loginRules";

	import axios from 'axios'
    import TextField from "../../../../MiniComponent/FormField/TextField.vue";
    import FormWithCaptcha from "../../../../Common/Form/FormWithCaptcha.vue";

	export default {

		name:'login-component',

		description:'Login fields component',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},

		},

		data () {

			return {
			
				isDisabled:false,

				base: this.auth.system_url,

				providerData:[],

				user_name: '',

				password: '',

				redirectUrl:'',

				buttonStyle: {
					
					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				inputStyle : {

					borderColor : this.layout.portal.client_input_field_color

				},

				linkStyle : { color : this.layout.portal.client_header_color },

				loads:'',

				loading:false,

				pageLoad : false,

				allow_register : this.layout.user_registration.status,

				locale : this.layout.language,

				redirectPath:'',

				componentName : 'page-login',

				labelStyle:{ display:'none' },

				remember: true,

				socialLoginBoxStyle: {},

        loginModal:false,

        errorMessage:'',

        proceed: 'proceed',

        reject: 'reject',

        buttonName:this.trans('cancel')
			}
		},

		beforeMount() {

			this.$Progress.start();
			
			this.loading=true;

			this.pageLoad = true;
			
			axios.get('api/active-providers').then(response => {
			
				this.providerData = response.data.data;

				this.loading=false;

				this.pageLoad = false;
			
				this.$Progress.finish();

			}).catch(error=>{
				
				this.loading=false;

				this.pageLoad = false;
				
				this.$Progress.fail();
			});

			// listen to an event, whenever that is fired witha value, change the value of `loading` acccordingly
			// this gives an external event a power to change the loading value by emitting and event
			window.emitter.on("login-box-loader", (loading) => {
				this.loading = loading;
			});

      },

		methods : {

      /**
       * For any external script to be able to inject some javascript on loginBox visiblity
       * @return {undefined}
       */
      loginBoxVisible() {
        window.emitter.emit('login-box-mounted', {providerData: this.providerData, 'login_type': 'login'});
      },

      /**
       * Redirects to register page
       * @return {undefined}
       */
      onRegister() {
        this.$router.push('/auth/register');
      },

      /**
       * populates the states corresponding to 'name' with 'value'
       * @param  {string} value
       * @param  {[type]} name
       * @return {void}
       */
      onChange(value, name) {
        this[name] = value;
      },

      /**
       * checks if the given form is valid
       * @return {Boolean} true if form is valid, else false
       */
      isValid() {
        const {errors, isValid} = validateLoginSettings(this.$data);

        return isValid;
      },

      socialRedirect(provider) {

        window.location.href = this.base + '/social/login/redirect/' + provider;
      },

      oneLoginRedirect(data) {

        window.location.href = data.login_url
      },

      /**
       * sending ajax call for login
       */
      onSubmit(key, value, thirdPartyData) {

        if (this.isValid()) {

          this.$Progress.start();

          this.isDisabled = true;

          this.loading = true;

          const params = {email: this.user_name, password: this.password, remember: this.remember}

          params[key] = value;

          // If thirdPartyData is provided, add it to the params as 'third_party_basic'
          if (thirdPartyData) {
            params['third_party_basic'] = thirdPartyData;
          }

          // emitting event that login has been initialised so that plugins can respond to it
          // currently ldap plugin is using it to insert one extra parameter to the request
          // as ldap = true
          window.emitter.emit('login-data-submitting', params);

          axios.post('login', params).then(
              res => {

                this.redirectUrl = res.data.data.redirect_url;

                this.isDisabled = true;

                this.isLoginDisabled = true;

                this.loading = false;

                this.redirectPath = localStorage.getItem('redirectPath');

                // redirect to 2fa page if redirect url is
                if (this.redirectUrl == 'verify-2fa') {
                  this.$Progress.finish();
                  this.$router.push({
                    name: 'Verify2FA',
                    params: {pp: JSON.stringify(res.data.data.PPAuth), remember: this.remember}
                  });
                } else if (this.redirectPath && this.redirectPath.includes('/rating/')) {
                  window.location.href = this.redirectPath;
                }
                // check's first redirect path is there and then check if it is package path is there or not
                else if (this.redirectPath && this.redirectPath.includes('package/')) {
                  window.location.href = this.base + this.redirectPath;
                } else if (this.redirectPath === '/mytickets') {
                  window.location.href = this.base + '/mytickets';
                } else if (this.redirectPath === '/create-ticket') {
                  window.location.href = this.base + '/create-ticket';
                } else {

                  this.$store.dispatch('setEmail', res.data.data.email);

                  if (this.redirectUrl == '/') {

                    window.location.href = this.base;

                  } else if (this.redirectUrl.includes('verify-email')) {

                    this.$Progress.finish();

                    this.$router.push({path: '/verify-email', name: 'EmailVerify'});

                  } else {

                    this.redirect('/' + this.redirectUrl);
                  }
                }

                window.emitter.emit('login-success', res);

              }).catch(error => {

            if (error.response) {
              this.errorMessage = error.response.data?.message || 'An unknown error occurred.';

              if (error.response.status === 403) {
                this.loginModal = true;
              }

              if (error.response.data?.message?.['g-recaptcha-response']) {
                this.$store.dispatch('setAlert', {
                  type: 'danger',
                  message: 'Invalid ReCaptcha',
                  component_name: this.componentName
                });
              }
            } else {
              this.errorMessage = error.message || 'Network error occurred.';
            }
            this.isDisabled = false;

            this.loading = false;

            errorHandler(error, this.componentName);

            this.$Progress.fail();

            window.emitter.emit('login-failure', error);
          })
        }
      },

      /**
       * calling validateForm method when press enter while filling login credentials in input fields
       * @return {Void}
       */
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter

	        event.target.blur();
          window.emitter.emit('logging-in-with-enter-key');

          // if default button is visble then press it
          let defaultLogin = document.getElementById('default-login-button');
          if (defaultLogin.style.display != 'none') {
            defaultLogin.click();
          }
        }
      },
      thirdpartyLogin(thirdPartyData, value) {

        // Register the event listener before triggering the click
        window.emitter.on("login-data-submitting", (params) => {
          if (thirdPartyData) {
            params['third_party_basic'] = value;
          }
        });

        // Trigger the default login button click
        document.getElementById('default-login-button').click();
      },

      providerClass(data) {
        const specificProviders = ['facebook', 'google', 'github', 'twitter', 'linkedin-openid', 'bitbucket'];
        return specificProviders.includes(data) ? 'btn-social' : 'non-social-btn';
      },

      onProceed() {
        this.onSubmitForLogin('proceed');
      },

      onClose() {
        this.loginModal = false
        this.onSubmitForLogin('reject');
      },
      onSubmitForLogin(action) {
        this.loginModal = false;
        const url = action === 'proceed' ? '/login/proceed' : '/login/reject';

        axios
            .post(url)
            .then(response => {
              if (action === 'proceed') {
                if(response.data.data.redirect_url == 'verify-2fa'){
                  this.$router.push({ path:'/verify-2fa',name: 'Verify2FA', params : { pp:JSON.stringify(response.data.data.PPAuth), remember : true}});
                } else {
                  window.location.href = this.basePath() +'/' + response.data.data.redirect_url
                }
              }
            })
            .catch(error => {
              console.log(error);
            })
            .finally(() => {
              this.loginModal = false;
            });
      },
    },

      components:{

			"text-field": TextField,

			"form-with-captcha": FormWithCaptcha
		},
	};
</script>

<style scoped>

	#login_loader{
		margin: auto !important;
		margin-bottom: 20px !important;
	}

	#default-login-button{
		margin-top: 5px;
		margin-bottom: 3px;
	}

	#batan{
		color: #fff !important;
		background-color: #009aba !important;
		border-color: #00c0ef !important;
	}

	#remember_me {
		margin-bottom: 10px;
	}

	#default-register-button{
		margin-top: 20px;
	}

	#default-login{
		text-align : left;
		margin-bottom: 10px;
	}

  #OneLogin{
    margin-top: 5px;
    margin-bottom: 10px;
  }
	
	.log_nav_align{
		direction: rtl;
	}

	.social_log{
		line-height: 5px;
	}

	.form-helper {
		margin-bottom: 50px !important;
		display: inline-block;
	}

	.login_title {
		margin-top:0px;margin-bottom: 21px;text-align: center;
	}

	.btn-social:hover {
		background-color: #fff !important;
		color: black !important;
		font-weight: 600;
	}

  .non-social-btn{
    padding: 4px 5px;
    background-color: #fff;
    color: #666;
    border-color: #ccc;
    border-radius: 1em;
  }

  .non-social-btn:hover {
    background-color: #fff !important;
    color: black !important;
    font-weight: 600;
  }
</style>