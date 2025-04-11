<template>
  <div>
    <modal v-if="showTranslateModal" :show-modal="showTranslateModal" :onClose="onClose" :containerStyle="containerStyle">

      <template #title>
        <h4 class="modal-title">{{lang('create_translated_set')}}</h4>
      </template>
      <template #alert>
        <alert componentName="template-translation-set-create-modal"/>
      </template>

      <template #fields>
        <div v-if="!isLoading">
          <div class="row" v-focus-first-input>
            <text-field  :label="lang('name')" :value="name" type="text" name="name" :onChange="onChange" classname="col-sm-6" :required="true"/>
            <dynamic-select id="template_language" name="template_language" classname="col-sm-6" :elements="languages" :label="lang('template_language')" :required="true" :multiple="false"  :value="template_language" :onChange="onChange">
            </dynamic-select>
          </div>
          <div class="row">
            <dynamic-select id="department_id" name="department_id" classname="col-sm-6" apiEndpoint="/api/dependency/departments" :label="lang('department')" :hint="lang('select_template_department')" :value="department_id" :multiple="false"  :onChange="onChange">
            </dynamic-select>
          </div>
        </div>

        <div v-if="isLoading" class="row">
          <reuse-loader :animation-duration="4000" color="#1d78ff"/>
        </div>
      </template>

      <template #controls>
        <button type="button" class="btn btn-primary" @click="onSubmit">
          <i class="fas fa-save">&nbsp;</i>{{lang('submit')}}
        </button>
      </template>

    </modal>
  </div>
</template>
<script>
import axios from 'axios';
import {
  validateNotifyTemplateSet
} from "../../../../../../resources/assets/js/helpers/validator/notifyTemplateSetCreateRule";
import {errorHandler,successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
import TextField from "../../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";
import DynamicSelect
  from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DynamicSelect.vue";

export default {
  name : 'template-translation-set-create-modal',
  data() {
    return {
      isLoading: false,
      name:'',
      template_language:[],
      department_id:[],

      /**
       * width of the modal container
       * @type {Object}
       */
      containerStyle:{
        width:'800px',
      }
    }
  },

  props:{
    /**
     * status of the modal popup
     * @type {Object}
     */
    showTranslateModal:{type:Boolean,default:false},

    /**
     * The function which will be called as soon as user click on the close button
     * @type {Function}
     */
    onClose:{type: Function},

    /**
     * values for languages options
     * @type {Object}
     */
    languages:{ type : Array, required : true , default : ()=>[]}
  },

  methods: {
    onChange(value, name) {
      this[name] = value||'';
    },

    onSubmit() {
      if(this.isValidInputs()) {
        let locationURL = new URL(location.href);
        let workingURL  = locationURL.pathname.substring(0,locationURL.pathname.lastIndexOf('/'));
        let channel = workingURL.substring(workingURL.lastIndexOf('/')+1)
        let formDataObj = {
          name : this.name,
          channel_name : channel,
          department_id : this.department_id ? this.department_id.id : null,
          template_language : this.template_language.value,
        };
        this.isLoading = true;
        axios.post('notify/api/template-sets/create_translate', formDataObj).then(res => {
          this.isLoading = false;
          this.onClose();
          successHandler(res, 'template-set-list-index');
          window.emitter.emit('refreshData');
        }).catch(err => {
          errorHandler(err,'template-translation-set-create-modal');
          this.isLoading = false;
        });
      }
    },

    isValidInputs() {
      const {errors, isValid} = validateNotifyTemplateSet(this.$data);
      return isValid;
    },
  },

  components : {
    "dynamic-select": DynamicSelect,
    "text-field": TextField
  }
}
</script>