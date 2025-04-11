<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
	
		<template #title>
			<h4 class="modal-title">{{lang(title)}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading" class="row">
				{{trans('are_you_sure_you_want_to_change_the_status')}}
			</div>

			<div v-if="loading">
				<loader :animation-duration="4000" color="#1d78ff" :size="size"/>
			</div>
		</template>

		<template #controls>
			<button type="button" id="submit" @click="onSubmit()" :class="btnClass" :disabled="loading">
				<i :class="iconClass" aria-hidden="true"></i> {{lang(btnName)}}</button>
		</template>

	</modal>
</template>

<script>

	import {errorHandler, successHandler} from '../../../helpers/responseHandler'
	import axios from 'axios'
    import TextField from "../FormField/TextField.vue";

	export default {
		
		name : 'edit-modal',

		description : 'Edit Modal component',

		props:{
			
			/**
			 * status of the modal popup
			 * @type {Object}
			 */
			showModal:{type:Boolean,default:false},

			/**
			 * The function which will be called as soon as user click on the close button        
			 * @type {Function}
			*/
			onClose:{type: Function},

			data : { type : Object , default:()=>{}},

			apiUrl : { type : String , default :''},

			title : { type : String , default :''}
		},

		data:()=>({
			
			name :'',

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

			btnName : 'yes',

			btnClass : 'btn btn-primary',

			iconClass : 'fas fa-save'

		}),

		beforeMount() {
			if(this.title === 'edit'){
				this.btnName = 'update'
				this.iconClass = "fas fa-sync-alt"
			}
		},

		created(){
		// getting locale from localStorage
			this.lang_locale = localStorage.getItem('LANGUAGE');
			this.name = this.data.name
		},

		methods:{

		/**
		 * api calls happens here
		 * @return {Void} 
		 */
		onSubmit(){
				this.loading = true
				axios.patch(this.apiUrl,{ id: this.data.id,name:this.name}).then(res=>{
					this.loading = false
					successHandler(res,this.data.alertComponentName);
					window.emitter.emit('refreshData');
						this.onClose();
				}).catch(err => {
					this.loading = false
					errorHandler(err,this.data.alertComponentName)
				})
		},
	},

	components:{
		'text-field': TextField,
	}

};
</script>
