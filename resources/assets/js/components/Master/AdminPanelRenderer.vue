<template>

	<router-view v-if="!loading && !showModal" :auth="updatedAuth" :company="updatedCompany" :portal="updatedPortal" :whiteLabel="whiteLabel" :tag="tag" :version="version"
				 :dummyInstall="dummyInstall" :isMailConfigured="isMailConfigured" :key="counter" :isUpdatedVersion = "isUpdatedVersion">

	</router-view>

	<transition name="modal"  v-if="showModal">

		<barcode-modal :onClose="onClose" :showModal="showModal">

		</barcode-modal>
	</transition>
</template>

<script>

import BarcodeModal from "../Agent/Views/Profile/BarcodeModal.vue";

import { scriptMixin } from "../../mixins/scriptMixin";

export default {

	name : 'admin-panel-renderer',

	props : {

		authInfo : { type : Object, default : ()=> {} },

		companyInfo : { type : Object, default : ()=> {} },

		portalInfo : { type : Object, default : ()=> {} },

		whiteLabel : { type : Boolean , default : false},

		tag : { type : String , default : ''},

		version : { type : String , default : ''},

		dummyInstall : { type : [Boolean, String, Number], default : '' },

		isMailConfigured : { type : [Boolean, String, Number], default : '' },
		
		is2faEnforced : { type : [Boolean, String, Number], default : '' },
		
		is2faEnabled : { type : [Boolean, String, Number], default : '' },

        isUpdatedVersion : {type : [Boolean, Number, String], default : false}
	},

	data () {

		return {

			updatedAuth : this.authInfo,

			loading : false,

			updatedPortal : this.portalInfo,

			updatedCompany : this.companyInfo,

			counter : 0,
			
			showModal : false,
			
			isFactorEnforce : this.is2faEnforced,
			
			isFactorEnable : this.is2faEnabled,
		}
	},

    mixins: [ scriptMixin ],

	watch : {

		$route(to, from){

            this.fireScripts(to.path,'adminlayout');

			if(!this.isFactorEnable && this.isFactorEnforce){
				
				this.showModal = true;
			}
			
			this.$store.dispatch('unsetAlert');

			this.$store.dispatch('unsetValidationError');
		}
	},
	
	beforeMount() {

        this.getScripts('adminlayout');

		if(this.isFactorEnforce && !this.isFactorEnable){
			
			this.showModal = true;
		}
	},
	
	created () {

		window.emitter.on('updateAgentProfile',this.updateProfile);

		window.emitter.on('companySettingsUpdated',this.updateCompany);
		
		window.emitter.on('securitySettingsUpdated',this.updateEnforce);
		
		window.emitter.on('updateEditData',this.updateFactor);
	},

	methods : {

		updateEnforce(value){
			
			this.isFactorEnforce = value
			
			if(this.isFactorEnforce && !this.isFactorEnable){
				
				this.$store.dispatch('unsetValidationError')
				
				this.showModal = true;
			}
		},
		
		updateFactor(value){
			
			this.isFactorEnable = value
			
			if(this.isFactorEnforce && !this.isFactorEnable){
				
				this.$store.dispatch('unsetValidationError')
				
				this.showModal = true;
			}
		},
		
		updateCompany() {

			axios.get('/api/admin/layout').then(res=>{

				this.updatedCompany = res.data.data.company;

				this.updatedPortal = res.data.data.portal;

				this.counter += 1;

			}).catch(err=>{

				this.loading = false;

			});
		},

		updateProfile(data) {

			Object.keys(this.updatedAuth.user_data).forEach(k => this.updatedAuth.user_data[k] = data[k] || this.updatedAuth.user_data[k]);
		},
		
		onClose(value){
			
			if((this.isFactorEnforce && this.isFactorEnable) || !this.isFactorEnforce || value === '2faDone'){
				
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
