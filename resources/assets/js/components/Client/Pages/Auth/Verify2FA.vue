<template>

	<transition name="page" mode="out-in">

		<div :class="{fa_align : language === 'ar'}">

			<div  id="content" class="site-content col-md-12 " >

				<alert componentName="2fa"/>

				<form-helper>

					<template #title>

						<h3 id="head3">{{ showRecovery ? lang('2_factor_auth') : lang('recovery_factor_auth') }}</h3>
					</template>

					<template #fields>
						<text-field :label="lang('enter_code')" :value="otp" id="2fa_otp" :autofocus="true"
									type="text" name="otp" :keyupListener="triggerEvent" :input-style="inputStyle" :onChange="onChange" classname="" :required="true">

						</text-field>

						<p>{{ showRecovery ? lang('2fa-message') : lang('recovery_factor_message') }}</p>

						<div v-if="loading">

							<custom-loader :animation-duration="4000" :color="layout.portal.client_header_color" :size="50"></custom-loader>
						</div>
					</template>

					<template #controls>

						<div class="row">

							<div class="col-sm-8" v-if="showRecovery">

                <div :class="{'float-end' : language === 'ar'}">
                  <span><b>Having problems?</b></span>

                  <p><a href="javascript:;" @click="showRecovery=false">Login using recovery code</a></p>
                </div>
							</div>

							<div class="col-sm-8" v-if="!showRecovery">
                <div :class="{'float-end' : language === 'ar'}">
                  <p><a href="javascript:;" @click="showRecovery=true">Login using Authenticator passcode</a></p>
                </div>
							</div>

							<div class="col-sm-4" :class="{left : language === 'ar'}">

                <div class="d-grid">

                  <button class="btn btn-custom btn-block btn-flat" :class="{'float-end' : language !== 'ar'}"  @click="onSubmit()" :style="buttonStyle" :disabled="otp ? false : true"
                          id="2fa_otp_verify">
                    <i class="fa fa-check"> </i> {{ lang('verify') }}

                  </button>

                </div>
							</div>
						</div>
					</template>
				</form-helper>
			</div>
		</div>
	</transition>
</template>

<script>

	import {errorHandler} from '../../../../helpers/responseHandler'

  import axios from 'axios'

    import FormHelper from "../ReusableComponents/FormHelper.vue";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import Loader from "../../../MiniComponent/Loader.vue";

	export default {

		name : 'verify-2fa',

		description : 'Two-factor Authentication component',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},

			pp : { type : [Object, String], default : ''},

			remember : { type : Boolean, default : false}
		},

		data() {
			return {

				loading:false,

		    	otp: "",
          p_auth : "",

				buttonStyle: {

					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				inputStyle : { borderColor : this.layout.portal.client_input_field_color},

				language : this.layout.language,

				isDisabled:false,

				showRecovery : true
			}
		},

		beforeMount(){

      let params = new URLSearchParams(window.location.search);
      let p_auth_value = params.get("PPAuth");
      if(p_auth_value) {
        let splitVal = p_auth_value.split(',');

        let objVal = {};

        objVal[splitVal[0]] = splitVal[1];

        this.p_auth =objVal;
      } else {
		  this.p_auth = this.pp ? JSON.parse(this.pp) : '';
      }

			if(!Array.isArray(this.auth.user_data)){

				this.$router.push({name:'Home'})

			} else if(!this.p_auth){

				this.$router.push({name:'Login'})
			}
		},

		watch : {

			showRecovery(newValue,oldValue){

				this.otp = '';

				this.$store.dispatch('unsetValidationError');

				this.$store.dispatch('unsetAlert');
			}
		},

		methods: {

    	onChange(value, name) {

      	this[name] = value;
    	},

    	onSubmit() {

    		if(!this.showRecovery) {

    			return this.verifyFactor();
    		}

      	this.$Progress.start();

			this.isDisabled=true;

			this.loading=true;

			const data = {};

			data['totp'] = this.otp;

			data['PPAuth'] = this.p_auth ? this.p_auth : '';

			data['remember'] = JSON.parse(this.remember);

			axios.post('/2fa/loginValidate',data).then(response =>{

				this.afterSuccess(response);

			}).catch(error=>{

				this.afterFailure(error)
			})
	   },

	   verifyFactor() {

          this.$Progress.start();

          this.isDisabled = true;

          this.loading = true;

          const data = {};

          data['rec_code'] = this.otp;

          axios.post('/verify-recovery-code', data).then(response => {

            this.afterSuccess(response);

          }).catch(error => {

            this.afterFailure(error)
          })

	   },

	   afterSuccess(response) {



          this.$Progress.finish();

          this.isDisabled = false;

          this.loading = false;

          this.redirectUrl = response.data.data.redirect_url;

          this.redirectPath = localStorage.getItem('redirectPath');

          this.redirectPath ? window.location.href = this.redirectPath === '/mytickets' ? `${this.auth.system_url}/mytickets`
            : this.redirectPath === '/create-ticket' ? `${this.auth.system_url}/create-ticket` : this.auth.system_url : this.redirect(this.redirectUrl);
	  },

	  afterFailure(error) {

	  		if(error.response.status === 422){

				setTimeout(()=>{

					this.$router.push({name:'Login'})
				},2000);
			} else {

				this.$store.dispatch('setValidationError', {'otp' : 'Wrong code. Try again'})
			}

			this.$Progress.fail();

			this.isDisabled=false;

			this.loading=false;

			errorHandler(error,'2fa');
	  },
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) // 13 is enter
        if(document.getElementById("2fa_otp").value !== "")
        {
          this.onSubmit();
        }
      },
	},

		components:{

			'form-helper': FormHelper,
			
			"text-field": TextField,

			'custom-loader' : Loader,
		}
	};
</script>

<style scoped>

	.fa_align{
		direction: rtl;
	}

	#head3{
		margin-top: 0px !important;
	}
</style>
