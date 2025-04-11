<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle"
		modalBodyClass="widget-card-div">

		<template #title>

			<h4 class="modal-title">{{lang(modalMode)}}</h4>
        </template>

        <template #alert>

            <alert componentName="Widget-Modal"/>
        </template>

		<template #fields>

			<div v-if="modalMode === 'edit'" v-focus-first-input>
				
				<text-field :label="lang('title')" :onChange="onChange" :placehold="lang('enter_a_value')" :value="title" type="text" name="title"
					classname="col-sm-12" >
						
				</text-field>
		 

				<tiny-editor :value="value" type="text" id="widget-modal-editor" :onChange="onChange" name="value"
					label="Value" classname="col-sm-12" width="100%" :height="300">
						
				</tiny-editor>
			</div>
			
			<div v-if="modalMode === 'view'" class="widget-view">
				
				<div v-if="value" v-focus-first-input>
					
					<text-field :label="lang('title')" :onChange="onChange" :placehold="lang('enter_a_value')" :value="title" type="text" name="title"
						classname="col-sm-12"  :disabled="true">
						
					</text-field>

          <label for="value" class="widget-value ps-2"> {{trans('value')}} </label>
          <div class="widget-value ps-2">
            <span v-html="value"></span>
          </div>
				</div>
				
				<div v-if="!value" class="text-center">
					
					<span>{{trans('no_data_found')}}</span>
				</div>
			</div>	
		</template>
						
		<template #controls>

			<button v-if="modalMode === 'edit'" type="button" id="submit_btn" @click="onSubmit()" class="btn btn-primary">

				<i class="fas fa-sync" aria-hidden="true"></i> {{lang('update')}}
			</button>				
		</template>
	</modal>
</template>

<script type="text/javascript">

    import { successHandler, errorHandler } from "../../../../helpers/responseHandler";

    import axios from 'axios';

    import TextField from "../../../MiniComponent/FormField/TextField.vue";

	export default {
		
		name : 'Widget-Modal',

		description : 'Widget Modal component',

		props:{

			data : { type : Object, required : true },

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

			/**
		 	* Mode of the modal, edit/view
		 	*/
			modalMode : { type: String , required : true },
		},

		data:()=>{
			
			return {
				
				containerStyle:{ width:'700px' },

				title:"",

				value:"",

				loading:false,
			}
		},

		beforeMount(){
			
			this.title=this.data.title
			
			this.value=this.data.value
		},

		methods:{

			onChange(value, name){
				
				this[name] = value;
		 	},

			onSubmit() {
				
				this.loading = true;
				
				let params = this.getSubmitParams();
				
				axios.post('api/update-widget/' + this.data.id, params).then(res => {
					
					this.loading = false;
					
					this.onClose();
					
					successHandler(res, 'dataTableModal');
					
					window.emitter.emit('refreshData');

				}).catch(err => {
					
					this.loading = false;
					
					errorHandler(err, 'Widget-Modal');
				});
			},

			getSubmitParams(){
				 
				let params = { title: this.title, value: this.value }
				
				return params;
			},
		},
		
		components:{
			
			'text-field': TextField
		}
	};
</script>

<style scoped>
	
	.widget-card-div { max-height: 470px; overflow-y: auto;overflow-x: hidden; }

  .widget-view{
    overflow: auto;
    word-break: break-all;
    min-height: 150px;
    max-height: 400px;
  }
</style>

<style>

.widget-value p {
	margin-bottom: 0rem !important;
}
</style>