<template>

	<Modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle"
	       :modalBodyClass="field.apply_model_category === 'vendor' ? 'vendor_fields' : ''">
		
		<template #title>
			
			<h4 class="modal-title">{{lang('add')}}&nbsp;{{lang(field.title)}}</h4>
		
		</template>
		
		<template #fields>
			
			<div v-if="!loading">
				
				<VendorCreateEdit v-if="field.apply_model_category === 'vendor'" from="modal" ref="addVendor" :onComplete="onCompleted"
                    alertName="contract-create-edit">
				
				</VendorCreateEdit>
				
				<ContractTypeCreateEdit v-if="field.apply_model_category === 'contract_type'" from="modal" ref="addContractType" :onComplete="onCompleted"
                    alertName="contract-create-edit">
				
				</ContractTypeCreateEdit>
			</div>
			
			<div v-if="loading" class="row">
				
				<ReuseLoader :animation-duration="4000" color="#1d78ff" :size="60"></ReuseLoader>
			</div>
		</template>
		
		<template #controls>
			
			<button type="button" id="submit_btn" @click = "onSubmit()" class="btn btn-primary" :disabled="isDisabled">
				
				<i class="fa fa-check"></i> {{lang('proceed')}}
			</button>
		</template>
	</Modal>
</template>

<script>

import {findObjectByKey, MULTIPLE_PROPERTY_HELPER} from "../../../helpers/extraLogics";
import axios from 'axios'
import VendorCreateEdit
	from "../../../../../../app/Plugins/ServiceDesk/views/js/components/Admin/Vendor/VendorCreateEdit.vue";
import ContractTypeCreateEdit
	from "../../../../../../app/Plugins/ServiceDesk/views/js/components/Admin/ContractType/ContractTypeCreateEdit.vue";
import Modal from "../Modal.vue";
import ReuseLoader from "../../Client/Pages/ReusableComponents/Loader.vue";

export default {
	
	name : 'add-new-modal',
	
	description : 'Add new Vendor, ContractType Modal component',
	
	props:{
		
		showModal : { type : Boolean, default : false },
		
		field : { type : Object , default : ()=>{}},
		
		onClose : { type : Function },
		
		createdValue : { type : Function },
	},
	
	data(){
		
		return {
			
			isDisabled:false,
			
			containerStyle : { width : '900px' },
			
			loading : false
		}
	},
	
	methods:{
		
		onSubmit(){
			
			if(this.field.apply_model_category === 'vendor') {
				
				this.$refs.addVendor.onSubmit();
				
			} else if(this.field.apply_model_category === 'contract_type') {
				
				this.$refs.addContractType.onSubmit();
			}
		},
		
		onCompleted(value,name){
			
			this.getNewValue(value,name)
			
			this.onClose();
		},
		
		getNewValue(value,name){
			
			let apiUrl = MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.field.api_info).url;
			
			if(apiUrl) {
				
				axios.get(apiUrl + '?search-query='+value).then(res=>{
					
					let obj = findObjectByKey(res.data.data[name], 'name',value);

					this.createdValue(obj,this.field.key);
				})
			}
		}
	},
	
	components:{
		VendorCreateEdit,
		ContractTypeCreateEdit,
		Modal,
		ReuseLoader
	}
};
</script>

<style>

.vendor_fields {
	max-height: 300px;
	overflow-y: auto;
	overflow-x: hidden;
}
</style>