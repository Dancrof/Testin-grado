<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" 
		:containerStyle="containerStyle">
		
		<template #title>
			
			<h4 class="modal-title">{{lang(title)}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading">

				<div class="row" v-focus-first-input>

					<static-select :label="lang('payment_gateway')"
								   :elements="payment_gateway" name="gateway" :value="gateway"
								   classname="col-sm-12" :onChange="onChange" :required="true">
					</static-select>

					<text-field :label="lang('transaction_id')" :value="transaction_id"
								type="text" name="transaction_id" :onChange="onChange"
								:required="true" classname="col-sm-12">
					</text-field>

					<number-field :label="lang('amount')" :value="amount"
								  name="amount" classname="col-sm-12"
								  :onChange="onChange" type="number" :required="true">
					</number-field>

					<text-field :label="lang('comment')" :value="comment"
								type="textarea" name="comment" :onChange="onChange"
								:required="true" classname="col-sm-12">
					</text-field>
				</div>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" color="#1d78ff" :size="size"/>
			</div>

		</template>

		<template #controls>
			
			<button type="button" id="submit_btn" @click="onSubmit()" class="btn btn-primary" :disabled="isDisabled">
					
				<i class="fas fa-sync" aria-hidden="true"></i> {{lang('ok')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import {errorHandler, successHandler} from "../../../../../../../../../resources/assets/js/helpers/responseHandler";

	import { validateInvoicePaymentSettings } from "../../../../../helpers/validator/validateInvoicePaymentRules";

	import axios from 'axios'
	import TextField
		from "../../../../../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";
	import StaticSelect
		from "../../../../../../../../../resources/assets/js/components/MiniComponent/FormField/StaticSelect.vue";
	import NumberField
		from "../../../../../../../../../resources/assets/js/components/MiniComponent/FormField/NumberField.vue";

	export default {
		
		name : 'settings-modal',

		description : 'Settings Modal component',

		props:{
	
			showModal:{type:Boolean,default:false},

			onClose:{type: Function},

			title : { type : String , default :''},

			id : { type : [String, Number], default : '' }
		},

		data:()=>({

			isDisabled:false,

			containerStyle:{ width:'600px' },

			loading:false,

			size: 60,

			status : 0,

			transaction_id : '',
			
			amount : '',

			add_to_credit: false,

			payment_gateway : [],

			gateway :'',

			comment :''
		}),

		methods:{

		isValid(){
			
			const {errors, isValid} = validateInvoicePaymentSettings(this.$data)
			
			if(!isValid){
			
				return false
			}
			return true
		},

		onChange(value, name){
			
			this[name]= value;	
		},

		onSubmit(){

			if(this.isValid()){
				
				this.loading = true
			
				this.isDisabled = true
				
				let data = {};

				data['method'] = this.gateway;

				data['transactionId'] = this.transaction_id;
				
				data['invoice'] = this.id;

				data['amount'] = parseInt(this.amount);

				data['comment'] = this.comment;

				axios.post('/bill/package/add-payment',data).then(res=>{
			
					this.loading = false
			
					this.isDisabled = false
			
					successHandler(res,'invoice');
			
					window.emitter.emit('reloadInvoiceData');
					
					this.onClose();
				
				}).catch(err => {
				
					this.loading = false
				
					this.isDisabled = false
				
					errorHandler(err,'invoice');

					this.onClose();
				})
			}
		},
	},

	components:{
		
		'text-field': TextField,

		"static-select": StaticSelect,

		'number-field': NumberField,
	},

	beforeMount()
	{
		// get payment getway list object
     	axios.get('bill/get-gateways-list', {
        	params:{
          		"active": 1,
        	}
      	}).then(res => {
      		res.data.data.data.forEach(element => {
      			this.payment_gateway.push({'id': element.name, 'name': element.name})
        	});
      	}).catch(err => {
        	errorHandler(err,'invoice')
      	});
	}
};
</script>

<style type="text/css" scoped>
	.has-feedback .form-control {
		padding-right: 0px !important;
	}
	#H5{
		margin-left:16px; margin-bottom:18px !important;
	}
	.margin {
		margin-right: 16px !important;margin-left: 0px !important;
	}
	.label_align {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: normal !important; padding-top: 6px;
	}
	.checkbox_align {
		width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden;
	}
	#align{
		margin-left: 15px !important
	}
</style>