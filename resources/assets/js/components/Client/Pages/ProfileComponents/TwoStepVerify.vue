<template>
	
	<transition name="page" mode="out-in">

		<div id="content1" class="site-content col-md-12">

			<div class="row" :key="counter">

				<div class="col-sm-12" v-if="loading">
					
					<custom-loader :duration="4000" :color="layout.portal.client_header_color"></custom-loader>
				</div>

				<div class="col-sm-8 offset-md-2" v-if="!loading">

					<div id="form-border" class="comment-respond form-border">

						<h3 id="reply-title" class="comment-reply-title section-title">

							<i class="line" :style="lineStyle"></i>{{lang('2fa_setup')}}
						</h3> 

						<div class="row">

							<div class="col-sm-9">

								<span class="d_flex">
								
									<img class="img-responsive img-sm" :src="basePathVersion()+'/themes/default/common/images/authenticator.png'" alt="A"
										id="auth_img">&nbsp;
										{{two_factor ? lang('2-step_is_on_since') +formattedTime(authData.user_data.google2fa_activation_date)  : lang('authenticator_app')}}
								</span>
							</div>

							<div class="col-sm-3">
								
								<button v-if="!two_factor" type="button" class="btn btn-custom pull-right" :style="buttonStyle" @click="turnOnMethod"
                        :disabled="authData.is_otp_verification_enabled" v-tooltip="lang('google_2fa_tooltip_for_status_' + !authData.is_otp_verification_enabled)" id="two_step_on">

									<i class="fa fa-toggle-on"></i> {{lang('turn_on')}}

								</button>

								<button v-if="two_factor" type="button" class="btn btn-secondary pull-right" @click="turnOffMethod" id="two_step_off">

									<i class="fa fa-toggle-off"></i> {{lang('turn_off')}}

								</button>
							</div>

							<div v-if="two_factor" class="col-sm-12 mt-4">
								
								<button class="btn btn-custom" :style="buttonStyle" @click="showRecoveryMethod">

									<i class="fas fa-eye"></i> {{lang('view_recovery_code')}}
								</button>
							</div>
						</div>


            <div id="2step-boxes">{{twoStepBoxVisible()}}</div>
					</div>
				</div>
			</div>

			<transition name="modal">
				
				<barcode-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :color="layout.portal.client_header_color"
				:button-style="buttonStyle" :inputStyle="inputStyle" :linkStyle="linkStyle" from="client">
					
				</barcode-modal>
			</transition>

			<transition name="modal">
				
				<remove-modal v-if="removeModal" :onClose="onClose" :showModal="removeModal" alertName="edit_profile" 
					:color="layout.portal.client_header_color" :inputStyle="inputStyle" from="client" :buttonStyle="buttonStyle">
					
				</remove-modal>
			</transition>

			<transition name="modal">
					
				<recovery-modal v-if="showRecoveryModal" :onClose="onClose" :showModal="showRecoveryModal" from="client" :input-style="inputStyle" :buttonStyle="buttonStyle" :containerStyle="containerStyle">
					
				</recovery-modal>
			</transition>

		</div>
	</transition>
</template>

<script>
	
	import { mapGetters } from 'vuex';

	import BarcodeModal from '../../../../components/Agent/Views/Profile/BarcodeModal.vue'

	import RemoveVerification from '../../../../components/Agent/Views/Profile/RemoveVerification.vue'

	import RecoveryCode from '../../../../components/Agent/Views/Profile/RecoveryCode.vue'

	import Loader from '../../../../components/MiniComponent/Loader.vue'

	export default {

		name : 'two-step',

		description : 'Two step verifiction Setup page',

		props : {

			layout : { type : Object, default : ()=>{}},
			
			auth : { type : Object, default : ()=>{}},
		},

		data () {

			return {

				containerStyle:{ width:'800px' },

				two_factor : false,

				showModal : false,

				removeModal : false,

				loading : false,

				lineStyle : { borderColor : this.layout.portal.client_header_color },

				linkStyle : { color : this.layout.portal.client_header_color },

				buttonStyle : {

					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				inputStyle: {

					borderColor : this.layout.portal.client_input_field_color,
				},

				counter : 0,

				showRecoveryModal : false,
			}
		},

		beforeMount(){

			this.two_factor = this.authData.user_data.is_2fa_enabled;
		},

		created(){
			window.emitter.on('updateEditData', this.updateUserData);


      window.emitter.on('togglingSMS', (value) => {
        this.authData['is_otp_verification_enabled'] = value;
      });
		},

		computed : {

			authData() {

				return this.auth
			},

			...mapGetters(['formattedTime'])
		},

		methods : {

			turnOnMethod() {

				this.showModal = true;

				window.emitter.emit("cropModalChanged","");
			},

			turnOffMethod() {

				this.removeModal = true;

				window.emitter.emit("cropModalChanged","");
			},

			showRecoveryMethod() {

				this.showRecoveryModal = true;

				window.emitter.emit("cropModalChanged","");
			},

			updateUserData(value){

				this.two_factor = value;

				this.$store.dispatch('deleteUser');

				this.authData.user_data['is_2fa_enabled'] = value
						
				this.authData.user_data['google2fa_activation_date'] = new Date();

      		this.$store.dispatch('updateUserData',this.authData);

      		this.counter++;
      },

			onClose(){
				
				this.showModal = false;

				this.removeModal = false; 

				this.showRecoveryModal = false;

				this.$store.dispatch('unsetValidationError');

				window.emitter.emit("cropModalChanged",'form_border');
			},

			twoStepBoxVisible() {
				window.emitter.emit('2step-box-mounted',{'alert' : 'edit_profile', user:this.authData, layout: this.layout});
			}
		},

		components : {

			'barcode-modal' : BarcodeModal,

			'remove-modal' : RemoveVerification,

			'recovery-modal' : RecoveryCode,

			'custom-loader' : Loader,
		}
	};
</script>

<style scoped>
	
	#content1 {

		margin-top: 20px !important;
	}

	#form-border{
		background: transparent !important;
	}

	#auth_img{
		margin-top: -2px;
		width: 25px!important;
		height: 25px!important;
	}

	.d_flex{
		display: flex;
	}
</style>