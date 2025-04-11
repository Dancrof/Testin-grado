<template>

  <div class="col-sm-12">

    <alert componentName="form-builder-index"/>

    <div class="card card-light">

      <div class="card-header">
        <h3 id="contract-type-list" class="card-title">{{lang('list_of_form_categories')}}</h3>
        <div class="card-tools">
          <a href="javascript:;" class="btn-tool dropdown-toggle" data-bs-toggle="dropdown" v-tooltip="lang('create_form')">
            <i class="glyphicon glyphicon-plus"> </i>
          </a>
          <div class="dropdown-menu dropdown-menu-right" role="menu" v-show="showDrop">

            <a class="dropdown-item" @click="showModal = true">
              {{ lang('new_ticket_category') }}
            </a>
          </div>
        </div>
      </div>

      <div class="card-body">
        <data-table :url="apiUrl" :dataColumns="columns"
                    :option="options" scroll_to ="contract-type-list">
        </data-table>
      </div>

      <modal v-if="showModal"  :showModal="showModal" :onClose="onClose" componentTitle="dataTableTittle">
        <template #title>
          <h4 class="modal-title"> {{ lang('create_new_form_category') }}</h4>
        </template>

        <template #fields>
          <div class="row" v-focus-first-input>

            <text-field :label="lang('name')" :value="name" type="textfield" name="name"
                        :onChange="onChange" :required="true" classname="col-sm-12" @keyup.enter="onSubmit()">
            </text-field>
            <span><i class="fas fa-info-circle infoCheck" v-tooltip="lang('ticket-form-info')"></i></span>
          </div>
          <div v-if="nameError" class="error-block is-danger">{{ nameError }}</div>
        </template>
        <template #controls>
          <button type="button" id="submit_btn" @click="onSubmit()" class="btn btn-primary" :disabled="false">
            <i class="fas fa-save" aria-hidden="true"></i> {{lang('save')}}
          </button>
        </template>

      </modal>
    </div>
  </div>
</template>

<script>

import axios from "axios";
import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";
import {useStore} from "vuex";
import {computed} from "vue";
import DataTableActions from "../../../../../../../../app/Plugins/Calendar/views/js/components/MiniComponents/TaskTableActions.vue";
import Modal from "../../../../Common/Modal.vue";
import TextField from "../../../../MiniComponent/FormField/TextField.vue";
import {validateFormsIndex} from "../../../../../helpers/validator/FormsIndex";

export default {

  name : 'form-builder-index',

  components: { TextField, Modal, DataTableActions },

  setup() {

    const store = useStore();

    return {

      formattedTime : computed(()=> store.getters.formattedTime)
    }
  },
  props:{
    componentTitle : { type : String, default : ''}
  },

  data: () => ({

    columns: ['name', 'type', 'created_at', 'updated_at', 'action'],

    options: {},

    apiUrl:'/api/dependency/form-categories',

    showModal : false,

    loading : true,

    isDisabled : true,

    type : '',

    name : '',

    showDrop: false,

    nameError: '',

  }),

  beforeMount() {

    setTimeout(()=>{

      this.showDrop = true;

      },1000);

    const self = this;

    this.options = {

      headings : {
        'name' : this.trans('name'),

        'type' : this.trans('type'),

        'created_at' : this.trans('created_at'),

        'updated_at' : this.trans('updated_at'),
        
        'action' : this.trans('action')
      },

      sortIcon: {

        base : 'glyphicon',

        up: 'glyphicon-chevron-down',

        down: 'glyphicon-chevron-up'
      },

      texts: { filter: '', limit: '' },

      templates: {

        created_at(h,row){

          return self.formattedTime(row.created_at)
        },

        updated_at(h,row){
          return self.formattedTime(row.updated_at)
        },

        action: (f,row)=>{
          return self.h (DataTableActions,{data:row})
        }
      },

      sortable:  ['name', 'created_at', 'type'],

      filterable:  ['name', 'created_at', 'type'],

      pagination: { chunk : 5, nav : 'fixed', edge : true},

      requestAdapter(data) {

        return {

          'paginate' : 1,

          'sort-field' : data.orderBy ? data.orderBy : 'id',

          'sort-order' : !data.ascending ? 'desc' : 'asc',

          'search-query' : data.query.trim(),

          page : data.page,

          limit : data.limit,
        }
      },

      responseAdapter({data}) {

        return {

          data: data.data.data.map(data => {

            data.edit_url = 'forms/' + data.category + '/edit';

            data.componentTitle = 'dataTableTittle';

            data.alertComponentName = 'form-builder-index';

            return data;
          }),
          count: data.data.total
        }
      },
    }
  },

  methods : {
    containsSpecialChars(str) {
      const hasSpecialChars = /[!@#$%^&*()+\-=\[\]{};':"\\|,.<>\/?\s]/.test(str);

      if (hasSpecialChars) {
        this.handleNameError(this.lang('validation-error-message'));
      } else {

        this.handleNameError('');
      }

      return hasSpecialChars;
    },
    handleNameError(errorMessage) {
      this.nameError = errorMessage;
    },

    isValid() {

      const { errors, isValid } = validateFormsIndex(this.$data);

      return isValid
    },
    onClose() {

      this.showModal = false;

      this.nameError = '';

      this.type = '';

      this.name = '';
    },

    onChange(value, name) {

      this[name] = value;

      this.isDisabled = value !== '';
    },

    onSubmit() {
      if (this.isValid()) {

        if (this.containsSpecialChars(this.name)) {
          return;
        }
        this.loading = true

        this.isDisabled = true

        let data = {};

        data['name'] = this.name;

        axios.post('/form-category/create', data).then(res => {

          this.loading = false

          successHandler(res, 'form-builder-index');

          window.emitter.emit('refreshData');

          this.onClose();

        }).catch(err => {

          this.loading = false

          errorHandler(err, 'form-builder-index');

        })
      }
    }
    }

};
</script>
<style scoped>
.error-block{
 margin-top: -13px!important;
}
.dropdown-item{
  cursor: pointer;
}
.infoCheck{
  color: #0a8cce;
  position: absolute;
  left: 62px;
  top: 19px;
}
</style>