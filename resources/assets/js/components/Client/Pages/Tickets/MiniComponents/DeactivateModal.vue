<template>
	
	<div> 
	
		<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
		
			<template #title>
				
				<h4>{{lang('deactivate')}}</h4>
			</template>
			
			<template #fields>
				<div v-if="!loading">

					<p id="H5" :class="{margin: lang_locale == 'ar'}">{{lang('are_you_sure_you_want_to_deactive_this_user')}}
					</p>
				</div>

				<div v-if="loading" class="row">

					<loader :animation-duration="4000" :size="60" :color="layout.portal.client_header_color"/>
				</div>
			</template>
						
				<template #controls>

					<button type="button" @click="onSubmit" class="btn btn-secondary float-end" :disabled="isDisabled" :class="{left: lang_locale == 'ar'}" :style="buttonStyle" id="client_deactive_action">

						<i class="fas fa-trash"></i> {{lang('deactivate')}}
					</button>
				</template>
		</modal>
	</div>
</template>

<script>
	
	import {errorHandler, successHandler} from '../../../../../helpers/responseHandler'
    import Modal from "../../../../Common/Modal.vue";
    import Loader from "../../../ClientPanelLayoutComponents/ReusableComponents/Loader.vue";

	export default {
		
		name : 'deactivate-modal',

		description : 'Deactivate Modal component',

		props:{
	
			showModal:{type:Boolean,default:false},

			deleteUrl:{type:String},

			onClose:{type: Function},

			layout : { type : Object, default : ()=>{}},
		},

		data(){

			return {

				isDisabled:false,

				containerStyle:{
					width:'600px'
				},

				buttonStyle: {
				
					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				loading:false,

				lang_locale : this.layout.language,	
			}
		},

		methods:{

		onSubmit(){
			
			this.$Progress.start();

			this.loading = true
			
			this.isDisabled = true
			
			axios.get(this.deleteUrl).then(res=>{
				
				window.emitter.emit('refreshData')

				successHandler(res,'organization');
			
				this.onClose();
			
				this.loading = false;
			
				this.isDisabled = false;

				this.$Progress.finish();

			}).catch(err => {
				
				this.loading = false;
			
				this.isDisabled = false

				errorHandler(err,'organization')

				this.$Progress.fail();
			})
		},
	},

	components:{

		'modal':Modal,

		'loader':Loader,
	}
};
</script>

<style type="text/css" scoped>

#H5{
	margin-left:16px; 
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