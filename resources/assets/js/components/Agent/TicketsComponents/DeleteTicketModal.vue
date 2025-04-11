<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>

			<h4 class="modal-title">{{lang('delete_ticekt_forever')}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading">

				<span>{{lang('are_you_sure_you_want_to_delete')}}</span>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" color="#1d78ff" :size="size" />
			</div>
		</template>

		<template #controls>

			<button type="button" @click="onSubmit()" class="btn btn-secondary" :disabled="isDisabled">

				<i class="fas fa-trash"></i> {{lang('delete')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import axios from 'axios'

	import {errorHandler,successHandler} from "../../../helpers/responseHandler";

	export default {
		
		name : 'delete-ticket-modal',

		description : 'Delete ticket Modal component',

		props:{
			
			showModal:{type:Boolean,default:false},

			ticketIds : { type : Array },

			onClose:{type: Function},

			componentTitle : { type : String, default :'UserTickets'},

			reloadTickets : { type : Function }
		},

		data:()=>({
			
			isDisabled:false,

			containerStyle:{ width:'600px' },

			loading:false,

			size: 60,
		}),

		methods:{

		onSubmit(){

			this.loading = true
			
			this.isDisabled = true

			const obj = { 

				'ticket-ids' : this.ticketIds
			}

			axios.post('api/ticket/delete-forever',obj).then(res=>{
				
				this.loading = false;
				
				this.isDisabled = true
				
				this.reloadTickets();
				
				successHandler(res,this.componentTitle);
				
				this.onClose();
				
			}).catch(err => {
				
				this.loading = false;
				
				this.isDisabled = false
				
				errorHandler(err,this.componentTitle)
			})
		},
	}
};
</script>