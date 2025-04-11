<template>

  <router-view v-if="!showModal" :auth="updatedAuth" :company="companyInfo" :portal="portalInfo" :whiteLabel="whiteLabel" :tag="tag"
  	:version="version" :dummyInstall="dummyInstall" :isMailConfigured="isMailConfigured" :isFAEnforced="is2faEnforced"
  	:isFAEnabled="is2faEnabled" :isUpdatedVersion = "isUpdatedVersion">

  </router-view>

	<transition name="modal"  v-if="showModal">

		<barcode-modal :onClose="onClose" :showModal="showModal">

		</barcode-modal>
	</transition>
</template>

<script>
	
	import BarcodeModal from "./Views/Profile/BarcodeModal.vue";

    import { scriptMixin } from "../../mixins/scriptMixin";

	export default {

		props : {

			authInfo : { type : Object, default : ()=> {} },

			companyInfo : { type : Object, default : ()=> {} },

			portalInfo : { type : Object, default : ()=> {} },

			whiteLabel : { type : Boolean , default : false},

			tag : { type : String , default : ''},

			version : { type : String , default : ''},

			dummyInstall : { type : [Boolean, String], default : '' },

			isMailConfigured : { type : [Boolean, String], default : '' },

			is2faEnforced : { type : [Boolean, String], default : '' },

			is2faEnabled : { type : [Boolean, String], default : '' },

      isUpdatedVersion : {type : [Boolean, Number], default : false}
		},

		data () {

			return {

				updatedAuth : this.authInfo,

				updatedPortal : this.portalInfo,

				isFactorEnable : this.is2faEnabled,

				showModal : false,

                agentScripts : []

			}
		},

        mixins: [ scriptMixin ],

		watch : {
			
			$route(to, from){

                this.fireScripts(to.path,'agentlayout');

                if(this.is2faEnforced && !this.isFactorEnable){

                    this.showModal = true;
                }
        
                this.$store.dispatch('unsetAlert');

                this.$store.dispatch('unsetValidationError');
              }
		},

		beforeMount() {

            this.getScripts('agentlayout');

			if(this.is2faEnforced && !this.isFactorEnable){

				this.showModal = true;
			}
		},

		created () {

			window.emitter.on('updateAgentProfile',this.updateProfile)

			window.emitter.on('updateEditData',this.updateFactor);
		},

		methods : {

			updateFactor(value){

				this.isFactorEnable = value

				if(this.is2faEnforced && !this.isFactorEnable){

					this.$store.dispatch('unsetValidationError')

					this.showModal = true;
				}
			},

			updateProfile(data) {

				Object.keys(this.updatedAuth.user_data).forEach(k => this.updatedAuth.user_data[k] = data[k] || this.updatedAuth.user_data[k]);
			},

			onClose(value){
				
				if((this.is2faEnforced && this.isFactorEnable) || !this.is2faEnforced || value === '2faDone'){

					this.showModal = false;
				}

				this.$store.dispatch('unsetValidationError');
			},
		},

		components : {

			'barcode-modal' : BarcodeModal
		}
	};
</script>
