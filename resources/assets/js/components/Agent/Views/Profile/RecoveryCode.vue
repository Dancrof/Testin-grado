<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>

			<h4 class="modal-title">{{trans('recovery_code')}}</h4>
		</template>

		<template #fields>

			<template v-if="!loading">

				<div v-if="!showPasswordVerify && passwordVerified">

					<p>Recovery code can be used only once. Make sure to generate a new one each time you use the code to login.</p>

					<div class="card card-light">

						<div class="card-header">

							<h3 class="card-title">{{ trans('recovery_codes') }}</h3>

							<div class="card-tools">

								<a :href="basePath()+'/2fa/downloadRecoveryCode'" v-tooltip="trans('download')" class="btn btn-tool"
								   target="_blank">

									<i class="fas fa-download"></i>
								</a>

								<button @click.prevent="copyToClipboard" v-tooltip="trans('copy')" class="btn btn-tool">

									<i :class="copied ? 'fas fa-check' : 'fas fa-clipboard'"></i>
								</button>

								<button class="btn btn-tool" @click="generateRecoveryCode" v-tooltip="trans('generate_new')">

									<i class="fas fa-list-ul"></i>
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

				<template v-if="showPasswordVerify && !passwordVerified">

					<text-field :label="lang('to_continue_first_verify')" :value="password" type="password" name="password" :autofocus="true"
							placehold="Enter Password..." :onChange="onChange" :inputStyle="inputStyle" classname="col-sm-12">

					</text-field>
				</template>
			</template>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" :size="60" :color="color"/>
			</div>

			<div class="row" v-if="verifyLoader">

				<custom-loader :duration="4000" :color="color"></custom-loader>

			</div>
		</template>

		<template v-if="!passwordVerified" #controls>

			<button type="button" :class="[{'btn-primary pull-right float-end': from !== 'client'},{'btn-custom  pull-right float-end': from === 'client'}]" :disabled="password ? false : true"
				@click="validatePass()" :style="buttonStyle">

				<i class="fas fa-check"> </i> {{trans('validate')}}
			</button>
		</template>
	</modal>
</template>

<script>

	import axios from 'axios'

	import copy from 'clipboard-copy';

	import TextField from '../../../../components/MiniComponent/FormField/TextField.vue';

	export default {

		name : 'recovery-modal',

		description : 'RecoveryCode Modal component',

		props:{

			showModal:{type:Boolean,default:false},

			onClose:{type: Function},

			color : { type : String, default : '#1d78ff'},

            buttonStyle : { type : Object, default : ()=> {}},

			inputStyle : { type : Object, default : ()=> {}},

			linkStyle : { type : Object, default : ()=> {}},

			from : { type : String, default : ''},

			containerStyle : { type : Object, default : () => {}}
		},

		data(){

			return {

				loading:false,

				verifyLoader : false,

				recoveryCode : '',

				copied : false,

				passwordVerified : false,

				password : '',

				showPasswordVerify : false
			}
		},

		beforeMount() {

			this.getRequiredPass();
		},

		methods:{

			onChange(value, name) {

				this[name] = value;
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

				axios.get('/get-recovery-code').then(res=>{

					this.recoveryCode = res.data.data.code;

					this.loading = false;

				}).catch(err=>{

					this.loading = false;
				})
			},

			generateRecoveryCode() {

				this.loading = true;

				axios.post('/2fa-recovery-code').then(res=>{

					this.recoveryCode = res.data.data.code;

					this.loading = false;

				}).catch(err=>{

					this.loading = false;
				})
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

			validatePass(){

				this.verifyLoader=true;

				const data = {}

				data['password'] = this.password;

				axios.post('/verify/password', data).then(res=>{

					this.passwordVerified = true;

					this.verifyLoader = false;

					this.showPasswordVerify = false;

					this.getRecoveryCode();

				}).catch(err=>{

					this.passwordVerified = false;

					this.verifyLoader = false;

					this.$store.dispatch('setValidationError', {'password' : 'Incorrect password.'})

				})
			},
		},

		components:{

			'text-field' : TextField,
		}
	};
</script>