<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>
	
			<h4 class="modal-title">{{lang('delete')}}</h4>
		</template>

		<template #fields>
			
			<span v-if="!loading">{{lang('are_you_sure_you_want_to_delete')}}</span>

			<div class="row" v-if="loading">

				<reuse-loader :duration="4000"></reuse-loader>
			</div>
		</template>

		<template #controls>
			
			<button type="button" id="submit_btn"  @click = "onSubmit" class="btn btn-secondary" :disabled="isDisabled">
			
				<i class="fas fa-trash"></i> {{lang('delete')}}
			</button>
		</template>
	</modal>
</template>

<script>

import {errorHandler, successHandler} from "../../../helpers/responseHandler";

import axios from 'axios'

	export default {

		name:'kb-delete-modal',

		description:'Kb delete modal Component',

		props:{

			showModal : { type : Boolean, default : false },

			onClose : { type : Function },

			apiUrl : { type : String , default : ''},

			alert : { type : String , default : ''},
			
			redirectUrl : { type : String , default : ''},

			updateKb : { type : Function, default : ()=>{}}
		},

		data(){
			
			return {

				isDisabled:false,

				loading:false,

				containerStyle:{ width:'500px' },
			} 
		},

		methods:{

			onSubmit(){
			
				this.loading = true
			
				this.isDisabled = true
			
				axios.delete(this.apiUrl).then(res=>{

					this.updateKb();
						
					this.loading = false;
				
					this.isDisabled = true

					successHandler(res,this.alert);

					window.emitter.emit('updateCommentsList');
			
					this.onClose();
					
					if(this.redirectUrl){

						setTimeout(()=>{

							return this.$router.push({path:this.redirectUrl})
						},3000)
					}
		
				}).catch(err => {
					
					this.loading = false

					this.onClose()

					errorHandler(err,this.alert)
				})
			},
		}
	};
</script>