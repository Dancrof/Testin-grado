<template>
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle"
		modalBodyClass="widget-card-div">

		<template #title>
			<h4 class="modal-title">{{lang('ratings_auto_request')}}</h4>
		</template>

		<template #alert>
			<alert componentName="rating-modal"/>
		</template>

		<template #fields>

			<div v-if="!loading" id="department-status" class="row">
				<dynamic-select :label="trans('select_status')" :multiple="true" name="statuses" :prePopulate="true" 
			classname="col-sm-12" apiEndpoint="/api/dependency/statuses" :value="statuses" :onChange="onChange" 
			:required="false" :hint="trans('rating_status_tooltip')">
				</dynamic-select>
			</div>
			<reuse-loader v-else></reuse-loader>
			
		</template>
						
		<template #controls>
			<button type="button" id="submit_btn" @click="onSubmit()" class="btn btn-primary" :disabled="isStatusesEmpty">
				<i class="fas fa-sync" aria-hidden="true"></i> {{lang('update')}}
			</button>				
		</template>
	</modal>
</template>

<script>
	
	import {errorHandler,successHandler} from "../../../../helpers/responseHandler";

	import axios from 'axios';
	import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {
		
		name : 'rating-auto-request-modal',

		description : 'Rating Auto Request component',

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
		},

		data:()=>{
			
			return {
				
				containerStyle:{ width:'700px', height:'250px' },

				loading:false,

				statuses : []
			}
		},

		beforeMount(){
			this.getInitialValues();
		},

    computed: {
      isStatusesEmpty() {
        return this.statuses.length === 0;
      }
    },

		methods:{

			onChange(value, name){
				
				this[name] = value;
		 	},

		 	getInitialValues()
		 	{
		 		this.loading = true;
		 		axios.get('api/auto-rating-requests').then(res => {
		 			this.loading = false;
          this.statuses = res.data && res.data.data ? res.data.data : [];
		 		}).catch(err => {
					this.loading = false;
					
					errorHandler(err, 'rating-modal');
				});
		 	},

			onSubmit() {
				
				this.loading = true;
				const data = {};
				if(this.statuses.length > 0 ) {
            		data['statuses'] = this.statuses.map(a => a.id);
         		}
				axios.patch('api/auto-rating-requests', data).then(res => {
					
					this.loading = false;
					
					this.onClose();
					
					successHandler(res, 'dataTableModal');
					
					window.emitter.emit('refreshData');

				}).catch(err => {
					
					this.loading = false;
					
					errorHandler(err, 'rating-modal');
				});
			},
		},
		
		components:{
			"dynamic-select": DynamicSelect,
		}
	};
</script>

<style scoped>
	
	.widget-card-div { max-height: 470px; overflow-y: auto;overflow-x: hidden; }
</style>