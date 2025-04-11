<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
		
		<template #title>

			<h4 class="modal-title">{{trans('activate')}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading">

				<span>{{trans('are_you_sure')}}</span>
			</div>

			<div v-if="loading" class="row" >

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>
		</template>

		<template #controls>

			<button  type="button" @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">

				<i class="fas fa-check"></i> {{trans('activate')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
	
	import axios from 'axios'
	
	export default {
		
		name : 'queue-activate-modal',
	
		props : {
	
			showModal : { type : Boolean, default : false },
	
			queueId : { type : [String, Number], default : '' },
	
			onClose : { type : Function },
		},

		data(){
		
			return {
		
				isDisabled:false,
		
				containerStyle:{ width:'600px' },
		
				loading:false,
			}
		},
		
		methods:{
		
			onSubmit(){
				
				this.loading = true
				
				this.isDisabled = true
		
				axios.post('/api/queue/'+this.queueId+'/activate').then(res=>{
					
					window.emitter.emit('QueueIndexrefreshData');
						
					successHandler(res,'dataTableModal')
					
					this.loading = false;
		
					this.isDisabled = false;
						
					this.onClose();
		
				}).catch(err => {
		
					this.loading = false;
					
					this.isDisabled = false;
		
					errorHandler(err,'dataTableModal');
		
					this.onClose();
				})
			}
		}
	};
</script>