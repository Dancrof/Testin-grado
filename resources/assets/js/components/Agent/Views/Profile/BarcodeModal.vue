<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle" :showIconCloseBtn="shouldHideCloseButtons" :showCloseBtn="false">

		<template #title>

			<h4 class="modal-title">{{lang('setup_authenticator')}}</h4>
		</template>

		<template #fields>

			<template v-if="!loading">

				<div :class="{bar_row : from === 'client'}">

					<div class="text-center" v-if="passwordVerified">

						<template v-if="recoveryCopied">

							<template v-if="showBarcode && !showPasscode">

								<ul class="col-sm-offset-3 offset-sm-2 text-start">

									<li>{{lang('get_authenticator_app')}}</li>

                  <li>{{lang('app_select')}} <b>{{lang('set_up_account')}}</b></li>

									<li>{{lang('choose')}} <b>{{lang('scan_a_barcode')}}</b></li>
								</ul>

								<div class="col-sm-offset-4" id="barcode_scan">

									<svg v-html="factorData.image"></svg>
								</div>

								<a href="javascript:;" id="scan" @click="keyCode()" :style="linkStyle">{{lang('cant_scan')}}</a>

							</template>

							<template v-if="showKeycode && !showBarcode && !showPasscode">

								<div class="row">

									<div class="col-sm-8 col-sm-offset-2 offset-sm-2 text-start">

										<ul>

											<li>{{lang('tap')}} <b>{{lang('menu')}}</b>, {{lang('then')}} <b>{{lang('set_up_account')}}</b></li>

											<li>{{lang('tap')}} <b>{{lang('enter_provided_key')}}</b></li>

											<li>{{lang('enter_you_email_and_key')}}</li>

										</ul>
									</div>

									<div class="col-sm-8 col-sm-offset-2 offset-sm-2" id="secret_key">

										<input type="text" :value="factorData.secret"  :keyuplistener="triggerEvent" class="form-control" readonly>
									</div>

									<div class="col-sm-8 col-sm-offset-2 offset-sm-2 text-start">
                      <ul class="col-sm-offset-3 offset-sm-2 text-left">
                        <li>{{ lang('get_authenticator_app') }}</li><li>{{ lang('app_select') }} <b>{{ lang('set_up_account') }}</b></li><li>{{ lang('scan_a_barcode') }}</li><li>{{ lang('make_sure_time_based') }} <b>{{ lang('time_based') }}</b> {{ lang('add') }} <b>{{ lang('to_finish') }}</b>.</li>
                      </ul>
									</div>

								</div>

								<a href="javascript:;" id="scan" @click="keyCodeReverse()" :style="linkStyle">{{lang('scan_barcode')}}</a>

							</template>

							<template v-if="showPasscode && !showBarcode">

								<div class="row" v-if="!codeVerified" :class="{flex_row : from === 'client'}" v-focus-first-input>

									<text-field :label="lang('enter_the_code_you_see_in_the_app')" :value="pass_code" type="text" name="pass_code" id="pass"
												placehold="Enter Passcode..." :keyupListener="triggerEvent" :onChange="onChange" classname="col-sm-12 text-start" :inputStyle="inputStyle">

									</text-field>
								</div>

								<span v-if="codeVerified">

										{{lang('you_are_all_set_from_now_on_you_will_use_authenticator_to_sign_in_to_your_account')}}
								</span>
							</template>
						</template>

						<template v-else>

							<div class="text-start">

								<p>{{lang('recovery_codes_are_used')}}
								</p>

								<div :class="from === 'client' ? '' : 'row'" class="mx-1">

									<div class="card card-light px-0">

										<div class="card-header">

											<h3 class="card-title">{{ trans('recovery_codes') }}</h3>

											<div class="card-tools">

												<a :href="basePath()+'/2fa/downloadRecoveryCode'" v-tooltip="trans('download')" class="btn btn-tool"
												   target="_blank" @click="downloadCodes">

													<i class="fas fa-download"></i>
												</a>

												<button @click.prevent="copyToClipboard" v-tooltip="trans('copy')" class="btn btn-tool">

													<i :class="copied ? 'fas fa-check' : 'fas fa-clipboard'"></i>
												</button>
											</div>
										</div>

										<div class="card-body">

											<div class="row">

												<template v-for="code in recoveryCode">

													<div class="col-sm-6 text-center"><p>{{ code }}</p></div>
												</template>
											</div>
										</div>
									</div>
								</div>

								<p>{{lang('treat_your_recover_codes')}} <a href="https://lastpass.com" target="_blank">Lastpass</a>, <a href="https://1Password.com" target="_blank">{{lang('1password')}}</a>, {{lang('keeper_or')}} <a href="https://keepersecurity.com.com" target="_blank">{{lang('keeper')}}</a>.
								</p>

							</div>
						</template>
					</div>

					<template v-if="showPasswordVerify && !passwordVerified">

						<text-field :label="lang('to_continue_first_verify')" :value="password" type="password" name="password"
									placehold="Enter Password..."  :keyupListener="triggerEvent"  :onChange="onChange" classname="col-sm-12" :inputStyle="inputStyle" :autofocus="true">

						</text-field>
					</template>
				</div>
			</template>

			<div v-if="loading" class="row" >

				<reuse-loader :animation-duration="4000" :size="60" :color="color"/>
			</div>

			<div class="row" v-if="verifyLoader">

				<custom-loader :duration="4000" :color="color"></custom-loader>

			</div>
		</template>

		<template #controls>

			<template v-if="!passwordVerified && !codeVerified">

				<button type="button" class="btn" :disabled="password ? false : true" @click="validatePass()" :keyupListener="triggerEvent" :style="buttonStyle"
						:class="[{'btn-primary pull-right float-end': from !== 'client'}, {'btn-custom text-capitalize  pull-right float-end': from === 'client'}]">

					<i class="fas fa-check"> </i> {{lang('validate')}}
				</button>
			</template>

			<template v-if="passwordVerified">

				<template v-if="recoveryCopied">

					<button v-if="showBarcode || showKeycode && !showPasscode" class="btn" @click="passCode()"
							:style="buttonStyle" :class="[{'btn-primary pull-right float-end': from !== 'client'},{'btn-custom  pull-right float-end': from === 'client'}]">

						{{lang('next')}} &nbsp;&nbsp;<i class="fas fa-arrow-right"> </i>
					</button>

					<button v-if="showPasscode && !codeVerified" class="btn" @click="barCode()"
							:style="{buttonStyle : from !== 'client'}" :class="[{'btn-light pull-right float-end': from !== 'client'},{'btn-light text_uppercase  pull-right float-end': from === 'client'}]">

						<i class="fas fa-arrow-left"> </i>&nbsp;&nbsp;{{lang('previous')}}

					</button>

          <button v-if="showPasscode && !codeVerified" type="button" class="btn ms-auto" :disabled="pass_code ? false : true" @click="validatePassCode()" :keyupListener="triggerEvent" :style="buttonStyle"
                  :class="[{'btn-primary  pull-right float-end': from !== 'client'}, {'btn-custom  pull-right float-end': from === 'client'}]">

            <i class="fas fa-check"> </i> {{lang('verify')}}

          </button>

				</template>

				<template v-else>

					<button class="btn" :style="buttonStyle" :disabled="copied || downloaded ? false : true" @click="afterCopy"
							:class="[{'btn-primary pull-right float-end': from !== 'client'},{'btn-custom  pull-right float-end': from === 'client'}]">

						{{lang('next')}} &nbsp;&nbsp;<i class="fas fa-arrow-right"> </i>
					</button>
				</template>
			</template>

			<button v-if="codeVerified" class="btn btn-custom" @click="onDone()" :style="buttonStyle"
					:class="[{'btn-primary float-end': from !== 'client'},{'btn-custom float-end': from === 'client'}]">
				<i class="fas fa-check"> </i> {{lang('done')}}</button>
		</template>
	</modal>
</template>

<script>
import axios from 'axios'
import { validateBarcode } from "../../../../helpers/validator/barcodeValidation";
import copy from 'clipboard-copy';
import TextField from "../../../MiniComponent/FormField/TextField.vue";
export default {
	name : 'barcode-modal',
	description : 'BarCode Modal component',
	props:{
		showModal:{type:Boolean,default:false},
    two_factor:{type:Boolean,default:false},
		onClose:{type: Function},
		color : { type : String, default : '#1d78ff'},
		buttonStyle : { type : Object, default : ()=> {}},
		inputStyle : { type : Object, default : ()=> {}},
		linkStyle : { type : Object, default : ()=> {}},
		from : { type : String, default : ''}
	},
	data(){
		return {
			isDisabled:true,
			containerStyle:{ width:'600px' },
			loading:false,
			showBarcode : true,
			btnName : 'next',
			passwordVerified : false,
			password : '',
			labelStyle : { visibility : 'hidden' },
			remember : true,
			verifyLoader : false,
			showPasscode : false,
			showKeycode : false,
			pass_code : '',
			factorData : '',
			codeVerified : false,
			showPasswordVerify : false,
			recoveryCopied : false,
			recoveryCode : '',
			copied : false,
			downloaded : false
		}
	},
  computed: {
    shouldHideCloseButtons() {
      return this.two_factor || this.from === 'client';
    }
  },
  beforeMount() {
		this.getRequiredPass();
	},
	methods:{
		getUserData(){
			return true;
		},
		getRequiredPass() {
			this.loading = true;
			axios.get('/show/verify-password').then(res=>{
				this.passwordVerified = true;
				this.getRecoveryCode();
			}).catch(err=>{
				this.showPasswordVerify = true;
				this.loading = false;
			})
		},
		getRecoveryCode() {
			this.loading = true;
			axios.post('/2fa-recovery-code').then(res=>{
				this.recoveryCode = res.data.data.code;
				this.loading = false;
			}).catch(err=>{
				this.loading = false;
			})
		},
		printRecovery() {
			var winPrint = window.open('', '', 'left=0,top=0,width=800,height=600,toolbar=0,scrollbars=0,status=0');
			winPrint.document.write(this.recoveryCode);
			winPrint.document.close();
			winPrint.focus();
			winPrint.print();
			//Setting timeout to avoid conflict created by extensions which crashes the window before printing
			setTimeout(function(){
				winPrint.close();
			}, 5)
		},
		copyToClipboard() {
			copy(this.recoveryCode);
			this.copied = true;
			this.showCopyIconAfterCopying();
		},
		showCopyIconAfterCopying() {
			//for showing copy icon after 5 seconds.
			setTimeout(() => {
				this.copied = false;
			}, 5000)
		},
		downloadCodes() {
			this.downloaded = true;
			setTimeout(() => {
				this.downloaded = false;
			}, 5000)
		},
		afterCopy() {
			this.recoveryCopied = true;
			this.getBarCode()
		},
		isValid() {
			const { errors, isValid } = validateBarcode(this.$data);
			return isValid;
		},
		getBarCode(){
			this.loading = true;
			axios.post('/2fa/enable').then(res=>{
				this.factorData = res.data.data;
				this.loading = false;
			}).catch(err=>{
				this.loading = false;
			})
		},
		onChange(value, name) {
			this[name] = value;
		},
		validatePass(){
			this.verifyLoader=true;
			const data = {}
			data['password'] = this.password;
			axios.post('/verify/password', data).then(res=>{
				this.passwordVerified = true;
				this.verifyLoader = false;
				this.getRecoveryCode();
			}).catch(err=>{
				this.passwordVerified = false;
				this.verifyLoader = false;
				this.$store.dispatch('setValidationError', {'password' : 'This field is Required.'})
			})
		},
		passCode(){
			this.showBarcode = false;
			this.showPasscode = true;
		},
		barCode() {
			this.showPasscode = false;
			this.showBarcode = true;
			this.pass_code = "";
		},
		keyCode() {
			this.showBarcode = false;
			this.showPasscode = false;
			this.showKeycode = true;
		},
		keyCodeReverse(){
			this.showBarcode = true;
			this.showPasscode = false;
			this.showKeycode = false;
		},
		validatePassCode(){
			if (this.isValid()) {
				this.verifyLoader = true;
				const data= {}
				data['totp'] = this.pass_code;
				axios.post('/2fa/setupValidate', data).then(res=>{
					window.emitter.emit('updateEditData',true);
					this.codeVerified = true;
					this.verifyLoader = false;
				}).catch(err=>{
					this.verifyLoader = false;
					this.$store.dispatch('setValidationError', {'pass_code' : 'Wrong code. Try again'})
				})
			}
		},
		triggerEvent(event) {
			var key = event.which || event.keyCode;
			if (key === 13) { // 13 is key code
				if(!this.passwordVerified){
					this.validatePass();
				}
				if(document.getElementById("pass").value !== "")
				{
					this.validatePassCode();
				}
			}
		},
		onDone(){
			this.onClose('2faDone');
		}
	},
	components:{

		'text-field': TextField
	}
};
</script>

<style type="text/css">
#H5{
	margin-left:16px;
}
#scan{
	text-decoration: underline !important;
}
.bar_row{
	display: flow-root !important;
}
#secret_key{
	margin-bottom: 15px;
}
.flex_row{
	display: flex;
}
.flex_btn{
	margin-top: 30px !important;
}
.bg-btn { background: #e9ecef;width: 36px; }
.bcg-btn { background: #e9ecef; }
.prnt_reco { margin-left: -2px; }
#barcode_scan{margin-left: 150px;}
.text_uppercase {text-transform: uppercase}
</style>