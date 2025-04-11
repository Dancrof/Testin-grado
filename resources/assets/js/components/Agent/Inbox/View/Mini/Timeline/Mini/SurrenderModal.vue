<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="divStyle">

		<template #title>
	
			<h4 class="modal-title">{{lang('surrender')}}</h4>
		</template>

		<template #fields>

			<span>{{ lang('are_you_sure_you_want_to_surrender_this_ticket') }}?</span>

			<div class="row" v-if="loading">

				<reuse-loader :duration="4000" :size="60"></reuse-loader>

			</div>
		</template>

		<template #controls>
			
			<button type="button"  @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">
			
				<i class="fas fa-sync-alt"></i> {{lang('update')}}
			</button>
		</template>
	</modal>
</template>

<script>

	import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";

	import axios from 'axios'

	export default {

		name:'surrender-modal',

		description:'Surrender modal Component',

		props:{

			showModal : { type : Boolean, default : false },

			onClose : { type : Function },

			ticketId : { type : [String, Number], default : '' },

			reloadDetails : { type : Function }
		},

		data(){
			
			return {

				isDisabled:false,

				loading:false,

				divStyle : { width : '500px' }
			} 
		},

		methods:{

			onSubmit(){
				
				this.loading = true;

				this.isDisabled = true;

				axios.get('/ticket/surrender/'+this.ticketId).then(res=>{

					this.reloadDetails('surrender');

					successHandler(res,'timeline');

					this.loading = false;

					this.isDisabled = false;

					this.onClose();

				}).catch(err=>{

					errorHandler(err,'timeline');

					this.loading = false;

					this.isDisabled = false;

					this.onClose();
				})
			},
		}
	};
</script>

<style scoped>
	
</style>