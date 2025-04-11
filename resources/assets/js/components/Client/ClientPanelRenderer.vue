<template>
  
  <router-view v-if="!showModal" :auth="updatedAuth" :layout="layout" :isUpdatedVersion = "isUpdatedVersion" :whiteLabel="whiteLabel"></router-view>

  <transition name="modal"  v-if="showModal">
			
		<barcode-modal :onClose="onClose" :showModal="showModal" from="client" :color="layoutDetails.portal.client_header_color"
		               :buttonStyle="buttonStyle"  :linkStyle="linkStyle">
			
		</barcode-modal>
	</transition>
</template>

<script>

	import BarcodeModal from '../../components/Agent/Views/Profile/BarcodeModal.vue'
	import axios from "axios";
    import { scriptMixin} from "../../mixins/scriptMixin";

	export default {

		props : {

			layoutDetails : { type : Object, default : ()=> {}},

			authInfo : { type : [Object, Array], default : ()=> []},

			is2faEnforced : { type : [Boolean, String, Number], default : '' },

      isUpdatedVersion : {type : [Boolean, Number], default : false},

      whiteLabel : { type : Boolean , default : false},
		},

		data() {

			return {

				updatedAuth : this.authInfo,

				showModal : false,

				linkStyle : { color : this.layoutDetails.portal.client_header_color },

				buttonStyle : {

					borderColor : this.layoutDetails.portal.client_button_border_color,
					color : this.layoutDetails.portal.client_button_font_color + ' !important',
					backgroundColor : this.layoutDetails.portal.client_button_color
				},
			}
		},

        mixins: [ scriptMixin ],

		created () {

			window.emitter.on('updateProfileData',this.updateAuthData);

			window.emitter.on('updateEditData',this.updateUserDetails);
		},

		beforeMount(){

            this.getScripts('clientlayout');

			this.updateFactor();

			this.$store.dispatch('updateUserData',this.authInfo);
		},

		computed:{

			layout() {

				this.$store.dispatch('clientLayoutActions',this.layoutDetails);
				
				return this.layoutDetails
			}
		},

		watch : {
			
			$route(to, from){

                this.fireScripts(to.path);
        
	      this.updateFactor();

        this.$store.dispatch('unsetAlert')
      }
		},

		methods : {

			updateFactor(value){

				if(!Array.isArray(this.updatedAuth.user_data)){

					if(this.is2faEnforced && !this.updatedAuth.user_data.is_2fa_enabled){

						this.showModal = true;
					}
				}
			},

			updateAuthData(value) {

				this.updatedAuth = value;

				this.updateFactor()
			},

			onClose(value){

				if((this.is2faEnforced && this.updatedAuth.user_data.is_2fa_enabled) || !this.is2faEnforced || value === '2faDone'){

					this.showModal = false;
				}

				this.$store.dispatch('unsetValidationError');
			},

			updateUserDetails(){

				this.$Progress.start();

				axios.get('/api/get-auth-info').then(res=>{

					this.updatedAuth = res.data.data;

					this.updateFactor();

					this.$Progress.finish();

				}).catch(error=>{

					this.$Progress.fail();
				})
			}
		},

		components : {

			'barcode-modal' : BarcodeModal
		}
	};
</script>
