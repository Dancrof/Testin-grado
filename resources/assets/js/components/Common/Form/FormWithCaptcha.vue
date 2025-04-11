<template>
	
	<div id="form-with-recaptcha">
		
		<slot name="fields"></slot>


    <div :class="recaptchaContainerClass" v-if="loading">
      <recaptcha-field :key="'captcha'+counter" v-captcha="page" :verifyCaptcha="getCaptcha" name="captcha">

      </recaptcha-field>
    </div>

    <div class="row" v-if="loading">

			<div class="d-grid gap-2">
			
				<button :id="btn_id" :class="btnClass" @click="onSubmit()" :style="btnStyle" :disabled="disableSubmit" type="button">

					<i :class="iconClass"> </i> {{trans(btnName)}}
				</button>
			</div>
		</div>

		<slot name="actions"></slot>
	</div>
</template>

<script>
	
	import RecaptchaField from "../../FormFields/RecaptchaField.vue";

    export default {

		name : 'form-with-captcha',

		description : 'Form with Recaptcha Component',

		props : {

			btn_id : { type : String, default : ''},
			 
			btnClass : { type : String, default : 'btn btn-custom' },

			btnName : { type : String, default : 'save' },

			btnStyle : { type : Object, default : ()=>{} },

			inputStyle: { type : Object, default: () =>{} },

			layout: { type : Object, default: () =>{} },

			iconClass : { type : String, default : 'fa fa-save' },

			formSubmit : { type : Function },

			page : { type : String, default : '' },

			componentName : { type : String, default : '' },

      recaptchaContainerClass: { type : String, default : '' },

      disableSubmit: {type: Boolean, default: false},

      loading: {type: Boolean, default: true}

		},

		data() {

			return {

				captchaKey : '',

				counter : 0
			}
		},

		created() {

			window.emitter.on('login-failure', this.updateCaptcha);

      window.emitter.on('reset-captcha', this.updateCaptcha);

			window.emitter.on('forComment',this.updateCaptcha);
		},

		methods : {

			updateCaptcha() {

				this.counter += 1;
			},

			getCaptcha(key) {

				this.captchaKey = key;
			},

			onSubmit() {

				if(this.page && this.recaptchaApplyfor.includes(this.page)){

					if(this.captchaKey){

						this.formSubmit('g-recaptcha-response',this.captchaKey)
					
					} else {

						this.$store.dispatch('setAlert',{
							type:'danger',message:'Invalid ReCaptcha', component_name : this.componentName
						})
					}
				} else {

					this.formSubmit()
				}
			}
		},

		components : {

			'recaptcha-field' :RecaptchaField
		}
	};
</script>

<style>

.modal-body #form-with-recaptcha{
  /* whenever this component is called within a model, model has some padding,
  which cuts the corner of this component. So reducing its width to 98% and making it center align */
  margin-left: 1em;
  margin-right: 1em;
}

.oauth-login-btn{
  color: rgb(255, 255, 255);
  background-color: rgb(9, 159, 220);
}

.oauth-login-btn{
  font-weight: bold;
}

</style>