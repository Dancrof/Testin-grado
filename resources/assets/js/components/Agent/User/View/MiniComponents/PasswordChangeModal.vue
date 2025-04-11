<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>

			<h4 class="modal-title">{{lang('change_password')}}</h4>

		</template>

		<template #fields>

			<div class="row" v-if="!loading">

				<div class="col-sm-12 form-group" id="register">

					<label>{{lang('new_password')}}</label><span class="text-danger"> *</span>

					<button class="btn btn-sm btn-light float-end" id="random" @click="getRandomPass()">

						<i class="fas fa-key">&nbsp;&nbsp;</i>{{lang('password_generator')}}
					</button>

					<div class="input-group mb-3" v-focus-first-input>
						<input type="password" :class="class_name" name="change_password" id="changepassword1" v-model="password"
									 @keyup="keyUp(password)" @keyup.enter="triggerEvent">
            <a id="basic-addon" class="input-group-text" @click="mouseoverPass()">
              <i id="eyeIcons" class="fas fa-eye-slash"></i>
            </a>
					</div>


					<div class="pass-status">

						<span :class="text_class" id="demo">{{lang(statusText)}}</span>

						<div v-if="bar_class" class="progress progress-sm">

							<div class="progress-bar progress-bar-striped" :class="bar_class" role="progressbar" :style="styleObj">

							</div>
						</div>
					</div>
				</div>
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

	import { passwordLengthValidation } from "../../../../../helpers/extraLogics";

	import axios from 'axios'

	export default {

		name : 'password-modal',

		description : 'Password Modal component',

		props:{

			showModal : { type : Boolean, default : false},

			userId : { type : [String, Number], default : '' },

			onClose : { type : Function},
		},

		data(){

			return {

				isDisabled:false,

				containerStyle:{ width:'800px' },

				loading:false,

				password  : '',

				class_name : 'form-control',

				text_class : '',

				statusText : '',

				styleObj : {},

				bar_class : '',
			}
		},

		methods:{

      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },

			mouseoverPass() {
				var x = document.getElementById("changepassword1");
				if (x.type === "password") {
					x.type = "text";
					document.getElementById("eyeIcons").classList.remove("fa-eye-slash");
					document.getElementById("eyeIcons").classList.add("fa-eye");
				} else {
					x.type = "password";
					document.getElementById("eyeIcons").classList.remove("fa-eye");
					document.getElementById("eyeIcons").classList.add("fa-eye-slash");
				}
			},

			keyUp(password){

				this.statusText = this.checkStrLength(password);
			},

			checkStrLength(password) {

        let message = passwordLengthValidation(password);

        if (message=== 'null'){

            message = "Please enter a password";

            this.class_name = 'form-control is-invalid';

            this.text_class = 'text-danger';

            this.bar_class	= 'bg-danger';

            this.styleObj = { 'width': '0%' };

        } else if(message === 'too_short' || message === 'your_password_must_be_8_character'){

					this.class_name = 'form-control is-invalid';

					this.text_class = 'text-danger';

					this.bar_class	= 'bg-danger';

					this.styleObj = { 'width': password.length < 7 ? password.length/0.6+'%' : '25%' };

				} else if(message === 'weak'){

          message = 'your_password_must_be_8_character';

					this.class_name = 'form-control is-invalid';

					this.text_class = 'text-danger';

					this.bar_class	= 'bg-danger';

					this.styleObj = { 'width': '50%' };

				} else {

					this.class_name = 'form-control is-valid';

					this.text_class = 'text-success';

					this.bar_class	= 'bg-success';

					this.styleObj = { 'width': '100%' };

				}

				return message;
			},

			getRandomPass(){

				this.class_name = 'form-control';

				this.text_class = '';

				this.bar_class	= '';

				this.statusText = '';

				this.styleObj = {};

				axios.get('/get/random/password').then(res=>{

					this.password = res.data.data;

				}).catch(error=>{

					this.password = ''
				})
			},

			onSubmit(){
				
				if (this.password.length < 8) {

					this.class_name = 'form-control is-invalid'

					this.text_class = 'text-danger';

					this.bar_class	= 'bg-danger';

					this.styleObj = { 'width': this.password.length/0.6+'%' };

					return this.statusText = 'your_password_must_be_8_character';

				} else if (this.password.match(/^(?=\S*[a-z])(?=\S*[A-Z])(?=\S*\d)(?=\S*[^\w\s])\S{8,}/)) {

					this.loading = true;

					this.isDisabled = true;

					const data = {};

					data['change_password'] = this.password;

					axios.post('/changepassword/'+this.userId,data).then(res=>{

						successHandler(res,'user-view')

						this.afterSuccess();

					}).catch(error=>{

						errorHandler(error,'user-view')

						this.afterResponse();
					})
				}
			},

			afterSuccess(){

				this.afterResponse();

				window.emitter.emit('refreshUserData');
			},

			afterResponse(){

				this.loading = false;

				this.isDisabled = false;

				this.onClose();
			},
		}
	};
</script>

<style scoped>

	#random{
		margin-bottom: 8px;
	}

	.form-control.is-valid, .form-control.is-warning, .form-control.is-invalid {
		background-image: none !important;
	}

  .input-group-text{
    cursor: pointer;
  }
</style>
