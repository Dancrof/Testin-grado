<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose"
	       :containerStyle="modal_title ? { width : '400px' } : containerStyle">

		<template #title>

      <h4 class="modal-title">{{ header ? header : (modal_title ? trans(modal_title) : trans('delete')) }}</h4>

    </template>

        <template #alert>

            <alert componentName="delete-modal"></alert>
        </template>

        <template #fields>

            <div v-if="!loading">

                <dynamic-select v-if="replace" :label="trans(title)" :multiple="false" name="replace_item" :required="true"  :value="replace_item" :showTooltipOnLabel="false"
                                :apiEndpoint="replaceEndpoint ? replaceEndpoint : '/api/dependency/'+dependency" :onChange="onChange" :clearable="replace_item ? true : false">

                </dynamic-select>

                <span v-else>{{ modal_title ? trans('are_you_sure') : trans(modalMessage)}}</span>

            </div>

            <div v-if="loading" slot="fields" >

                <loader :animation-duration="4000" color="#1d78ff" :size="60"/>
            </div>
        </template>

		<template #controls>

      <button type="button" @click="onClick" :class="modal_title ? 'btn btn-primary' : 'btn btn-secondary'" :disabled="isDisabled">
        <i :class="[buttonText ? '' : (modal_title ? 'fas fa-unlink' : 'fas fa-trash')]" aria-hidden="true" style="margin-right: 5px;"></i>{{ buttonText ? buttonText : (modal_title ? trans(modal_title) : trans('delete')) }}
      </button>

    </template>
	</modal>
</template>

<script>
	
	import axios from 'axios'

	import {errorHandler, successHandler} from '../../../helpers/responseHandler'

	import { validateDeleteModalSettings } from "../../../helpers/validator/deleteModalRules.js"

    import DynamicSelect from "../FormField/DynamicSelect.vue";

	export default {

		name : 'delete-modal',

		description : 'Delete Modal component',

		props:{

			showModal:{type:Boolean,default:false},

			replace : { type : Boolean, default : false },
			
			replaceEndpoint:  { type: String, default : '' },

			dependency : { type : String, default : '' },

			title : { type : String, default : '' },

			deleteUrl:{type:String},

			onClose:{type: Function},

			alertComponentName : { type : String, default : 'dataTableModal'},

			redirectUrl : { type : String, default : ''},

			componentTitle : { type : String, default : ''},

			from : { type : String, default : '' },

			modal_title : { type : String, default : '' },

      buttonText : { type : String, default : '' },

      header : { type : String, default : '' },

			modalMessage : { type : String, default : 'are_you_sure_you_want_to_delete_packages' }

		},

		data () {

			return {

				containerStyle : { width:'650px' },

				loading:false,

				isDisabled : false,

				labelStyle : { display:'none' },

				replace_item : '',

				apiUrl : this.deleteUrl
			}
		},

		methods:{

			onChange(value,name) {

				this[name] = value ? value : '';

				this.apiUrl = this.deleteUrl;
			},

			isValid(){
				
				const {errors, isValid} = validateDeleteModalSettings(this.$data);
				
				return isValid
			},

			onClick() {

				if(this.replace) {

					if(this.isValid()){

						this.apiUrl = this.apiUrl+'/'+this.replace_item.id;

						this.onSubmit();
					}
				} else {

					this.onSubmit();
				}
			},

			onSubmit(){
				
				this.loading = true

				this.isDisabled = true;

        if (this.from !== 'template'){

          axios.delete(this.apiUrl).then(res=>{

            successHandler(res,this.alertComponentName);

            if(this.componentTitle === 'todos-page') {
              window.emitter.emit('taskUpdated')
            }

            this.afterRespond();

          }).catch(err => {

            errorHandler(err,'delete-modal');

            if(this.componentTitle === 'canned-response-index'){

              setTimeout(()=>{

                window.emitter.emit(this.componentTitle+'refreshData');
              },2000)
            }

            this.loading = false;

            this.isDisabled = false;

          })
        }
        else{

          window.emitter.emit('updateConfirmation');

          this.loading = false;

          this.isDisabled = false;

          this.onClose();
        }
			},

			afterRespond(){

				window.emitter.emit(this.componentTitle+'refreshData');

				window.emitter.emit(this.componentTitle+'uncheckCheckbox');

        window.emitter.emit('updateAgentSidebar');
				
				window.emitter.emit('entryDeleted');
				
				if(this.redirectUrl){

					setTimeout(()=>{
						this.$router.push({ path : this.redirectUrl })
					},3000);
				}

				if(this.alertComponentName == 'timeline') {

					window.emitter.emit('actionDone','external');
				}

        if(this.alertComponentName == 'dashboard-page') {

          window.emitter.emit('taskUpdated');
        }

        if(this.alertComponentName == 'timeline') {

          window.emitter.emit('threadUpdated');
        }
				this.onClose();

				this.loading = false;

				this.isDisabled = false;
			}
		},

		components:{

			'dynamic-select':DynamicSelect
		}
	};
</script>
