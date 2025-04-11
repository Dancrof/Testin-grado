<template>
	<div> 
		<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
		
			<template #title>
				<h4>{{lang(title)}}</h4>
			</template>

			<template #fields>
				<div v-if="!loading">
					<h5 id="H5" :class="{margin: lang_locale == 'ar'}">{{lang('are_you_sure')}}</h5>
				</div>

				<div v-if="loading" class="row" slot="fields" >
					<reuse-loader :animation-duration="4000" color="#1d78ff" :size="size" :class="{spin: lang_locale == 'ar'}" />
				</div>
			</template>
						
			<template #controls>
				<button type="button" @click = "onSubmit" class="btn btn-primary" :disabled="isDisabled"><i class="fa fa-save"></i> {{lang('proceed')}}</button>
			</template>

		</modal>
	</div>
</template>

<script>
	
	import {errorHandler, successHandler} from "../../../../../../../../../resources/assets/js/helpers/responseHandler";

	export default {
		
		name : 'unpaid-modal',

		description : 'Unpaid Modal component',

		props:{
			
			/**
			 * status of the modal popup
			 * @type {Object}
			 */
			showModal:{type:Boolean,default:false},

			/**
			 * status of the delete popup modal
			 * @type {Object}
			 */
			title : { type : String , default : '' },

			id : { type : [Number, String], default : ''},

			/**
			 * The function which will be called as soon as user click on the close button        
			 * @type {Function}
			*/
			onClose:{type: Function},

			refreshPage:{type: Function},

		},

		data:()=>({
			
			
			/**
			 * buttons disabled state
			 * @type {Boolean}
			 */
			isDisabled:false,

			/**
			 * width of the modal container
			 * @type {Object}
			 */
			containerStyle:{
				width:'500px'
			},

			/**
			 * initial state of loader
			 * @type {Boolean}
			 */
			loading:false,

			/**
			 * size of the loader
			 * @type {Number}
			 */
			size: 60,

			/**
			 * for rtl support
			 * @type {String}
			*/
			lang_locale:'',

		}),

		created(){
		// getting locale from localStorage
			this.lang_locale = localStorage.getItem('LANGUAGE');
		},

		methods:{
		/**
		 * api calls happens here
		 * @return {Void} 
		 */
		onSubmit(){
		//for delete
			this.loading = true
			this.isDisabled = true

			const data = {};

			data['invoice_id'] = this.id;

			data['amount_paid'] = 0;

			axios.put('/invoice/update',data).then(res=>{
				
				this.loading = false;
				
				this.isDisabled = true;

				this.refreshPage();
				
				this.onClose();
				
				successHandler(res,'invoice');
				
			}).catch(err => {
				
				this.loading = false;
				
				this.isDisabled = true;

				errorHandler(err,'invoice')
			})
		},
	}

};
</script>

<style type="text/css">
.has-feedback .form-control {
	padding-right: 0px !important;
}
#H5{
	margin-left:16px; 
	/*margin-bottom:18px !important;*/
}
.fulfilling-bouncing-circle-spinner{
	margin: auto !important;
}
.margin {
	margin-right: 16px !important;margin-left: 0px !important;
}
.spin{
	left:0% !important;right: 43% !important;
 }
</style>