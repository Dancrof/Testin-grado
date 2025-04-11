<template>
  <div class="col-sm-12">
    <alert componentName="form-builder-main" />
    <div class="card card-light">
      <div class="card-header">
        <custom-loader v-if="showLoader" />
        <h3 class="card-title">
          <span v-if="!isCreateFormGroup && !isEditFormGroup" class="text-capitalize"> {{trans('create')}}
    {{ activeFormCategoryType }} {{ (!isCreateFormGroup && !isEditFormGroup) ? trans('form') : trans('form-group') }}
         </span>
        </h3>

        <div class="card-tools">

          <button v-tooltip="trans('assign_organization')" v-if="!defaultCategories.includes(activeFormCategoryType)"  type="button" class="btn btn-tool btn-light form-save-btn" @click="showConfigModal()">

            <i class="fa-solid fa-sitemap"> </i> {{trans('assign')}}
          </button>

          <button class="btn btn-tool btn-light form-save-btn" @click="onSaveForm">
            <span class="fas fa-save"></span> {{ lang('save') }}
          </button>
        </div>
      </div>
      <modal v-if="showModal" :showModal="showModal" :onClose="onClose">
        <template #title>
          <h4 class="modal-title"> {{ lang('assign_organization') }}</h4>

        </template>
        <template #fields>
          <div class="alert alert-info">
            <li>{{lang('assign_org_form_caution_msg_1') }}</li>
            <li>{{lang('assign_org_form_caution_msg_2') }}</li>
          </div>
          <div class="row" v-focus-first-input>
            <dynamic-select
                :label="lang('organizations')"
                :multiple="true"
                name="organisation"
                :prePopulate="true"
                classname="col-sm-12"
                apiEndpoint="/api/dependency/organizations?having_form_categories=0"
                :value="organizations"
                :onChange="onChange"
            ></dynamic-select>
          </div>
        </template>
        <template #controls>
          <button type="button" id="submit_btn" @click="onSubmit" class="btn btn-primary" :disabled="false">
            <i class="fas fa-sync" aria-hidden="true"></i> {{ lang('submit') }}
          </button>
        </template>
      </modal>
      <div class="card-body" id="form-builder-body">
        <div class="row">
          <div class="col-md-4">
            <faveo-form-builder-menu class="card formFields" v-if="hasMenuLoaded" :form-group-list="formGroupList" />
          </div>
          <div class="col-md-8">
            <div class="card m-1 p-2">
              <div v-if="hasFormFieldsLoaded && hasMenuLoaded">
                <div class="row" v-if="isCreateFormGroup || isEditFormGroup" v-focus-first-input>
                  <text-field
                      :id="localFormNameObj.id"
                      :classname="localFormNameObj.className"
                      :label="lang(localFormNameObj.label)"
                      :value="localFormNameObj.value"
                      type="text"
                      :name="localFormNameObj.id"
                      :onChange="(value) => localFormNameObj.value = value"
                      :placehold="lang(localFormNameObj.placeholder)"
                      :required="true"
                  ></text-field>
                  <dynamic-select
                      v-for="item in localFormLinker"
                      :key="item.id"
                      :id="item.id"
                      :name="item.id"
                      :classname="item.className"
                      :apiEndpoint="item.apiEndpoint"
                      :label="lang(item.label)"
                      :value="item.value"
                      :required="false"
                      :multiple="true"
                      :onChange="(value) => item.value = value"
                  ></dynamic-select>
                </div>
                <div class="mt-2">
                  <draggable-form-field-item :value="formFieldsStoreValue" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <transition name="modal">
      <modal v-if="showDeleteModal" :showModal="true" :onClose="() => showDeleteModal = false" :containerStyle="{width:'400px'}">
        <template #title>
          <h4 class="modal-title">{{ lang('delete') }}</h4>
        </template>
        <template #fields>
          <span>{{ lang('are_you_sure_you_want_to_delete') }}</span>
        </template>
        <template #controls>
          <button id="approval-action-confirm" type="button" @click="doDelete" class="btn btn-secondary">
            <i class="fas fa-trash-alt" aria-hidden="true"></i>&nbsp;{{ lang('confirm') }}
          </button>
        </template>
      </modal>
    </transition>
  </div>
</template>

<script>
import _ from 'lodash-core';
import { errorHandler, successHandler} from "../../../../../helpers/responseHandler";
import { getIdFromUrl,boolean} from "../../../../../helpers/extraLogics";
import axios from 'axios';
import { validateFormGroup} from "../../../../../helpers/validator/formGroupRules";
import FormBuilderMenu from "../FormBuilderMenu.vue";
import TextField from "../../../../MiniComponent/FormField/TextField.vue";
import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";
import Modal from "../../../../Common/Modal.vue";
export default {

  name: 'form-builder-main',

  components: {
    'faveo-form-builder-menu': FormBuilderMenu,
    'text-field': TextField,
    'dynamic-select': DynamicSelect, Modal
  },

  props: {
    /**
     * Mode of a Form Group
     */
    groupMode : {
      type : String,
      default : ''
    },
    /**
     * Form name object
     *
     * example:- { id: 'name' , className: 'col-md-4', label: 'form_group_name', placeholder: 'name_your_form_group', value: '', submitFormParamKey: 'name' }
     */
    formNameObj: {
      type: Object,
      default: () => {}
    },

    /**
     * form linker object
     * used for linking form with some field element
     *
     * example:- [{ id: 'departments', className: 'col-md-4', apiEndpoint: '/api/dependency/departments?config=true', label: 'department', value: [], submitFormParamKey: 'department_ids' }]
     */
    formLinker: {
      type: Array,
      default: () => []
    },

    // Api endpoint for edit form group
    editFormGroupApi: {
      type: String,
      default: () => ''
    },

    // Api endpoint for posting form group
    postFromGroupApi: {
      type: String,
      default: () => ''
    },

    // form category type -- can be 'ticket', 'user', 'group', etc
    formCategoryType: {
      type: String,
      default: ''
    }

  },

  data: () => {
    return {
      pageHeading: 'create-form', // text to show on the page header
      hasMenuLoaded: false, // has form menu json loaded?
      hasFormFieldsLoaded: false, // has form fields loaded?
      showLoader: true, // show loader or not?
      formGroupList: [], // array of form groups if any
      isCreateFormGroup: false, // component will behave like create from if true
      isEditFormGroup: false, // component will behave like edit form if true
      formGroupId: null, // Id of form group -- used in case of edit form
      activeFormCategoryType: '', // may be `ticket` OR `user` OR `organisation`, etc
      formCategoryTypes: [],
      localFormNameObj: '',
      localFormLinker: '',

      showDeleteModal :false,
      deleteType : '',
      deleteData : '',
      deleteId : '',
      showModal: false,
      organizations : [],
      defaultCategories : ['ticket', 'organisation', 'user', 'asset', 'change', 'license']
    }
  },

  beforeMount() {
    this.localFormNameObj = this.formNameObj;
    this.localFormLinker = this.formLinker;
    this.activeFormCategoryType = this.formCategoryType;
    this.setInitialValue();

    if(this.groupMode == 'create') {
      this.localFormNameObj.value = "";
      this.localFormLinker = this.localFormLinker.map(obj => { return {...obj, value: []}});;
    }
  },

  computed: {
    formFieldsStoreValue: {
      get() {
        return this.$store.getters.getFormFields;
      },
      set(value) {
        this.$store.dispatch('updateFormFields', value);
      }
    }
  },

  created() {
    window.emitter.on('formFieldSettingsApplied', this.applySettingsChanges);
    window.emitter.on('onRemoveElement', this.onRemoveElement);
    window.emitter.on('getFormDataFromServer', this.getFormDataFromServer);
  },

  methods: {

    onClose() {

      this.showModal = false;

      this.type = '';

      this.name = '';
    },

    showConfigModal () {
      this.showModal = true;
      this.showLoader = true;
      this.fetchConfigData();
    },

    fetchConfigData () {
      this.showLoader=true;
      axios.get('/form-category/configs/'+this.activeFormCategoryType).then( (res) => {
        this.organizations = res.data.data.organizations;
        this.showLoader = false;
      })
    },


    /**
     * Set initial values
     * check if form create page
     * check if form edit page
     * get form group list if category is ticket
     * get form menu json
     */
    setInitialValue() {
      const currentRoute = this.getCurrentWindowLocation();
      if(!this.isCreateFormGroup && !this.isEditFormGroup) {
        this.getFormCategories();
      } else {
        this.getMenuJson();
        this.assignFormFields();
      }
    },

    getFormCategories() {
      this.setCategoryType()
      this.getFormDataBasisOnCategory();
    },

    setCategoryType() {
      let path = window.location.pathname;
      path = path.split('/')
      this.activeFormCategoryType = path[path.length - 2];
    },

    getFormDataBasisOnCategory() {
      this.getFormGroupList();
      this.getMenuJson();
      this.assignFormFields();
    },

    getCurrentWindowLocation() {
      return window.location.pathname;
    },

    // Fetch json of available types of form fields
    getMenuJson() {
      axios.get('api/get-form-menu/' + this.activeFormCategoryType)
          .then(resp => {
            this.$store.commit('updateFormMenu', resp.data.data);
            this.hasMenuLoaded = true;
          });
    },

    // fetch form-fields from server and assign it to component properties
    assignFormFields() {
      if (this.isCreateFormGroup) {
        this.$store.commit('updateFormFields', []);
      } else {
        this.getFormDataFromServer()
            .then((resp) => {
              if (this.isEditFormGroup) {
                this.localFormNameObj.value = resp.data.data[this.localFormNameObj.id] ? resp.data.data[this.localFormNameObj.id] : '';
                this.localFormLinker.forEach(element => {
                  element.value = resp.data.data[element.id] ? resp.data.data[element.id]: [];
                });
              }
              this.hasFormFieldsLoaded = true;
            })
      }
    },

    onTabClick(newTab) {
      if(this.activeFormCategoryType === newTab) {
        return;
      }
      this.activeFormCategoryType = newTab;
      this.getMenuJson();
      this.getFormGroupList();
      this.getFormDataFromServer();
    },

    // get form-fields from server
    getFormDataFromServer() {
      this.showLoader = true;
      this.$store.commit('updateFormCategoryType', this.activeFormCategoryType);
      let apiEndpoint = 'api/get-form-data';
      let params = {
        category: this.activeFormCategoryType,
        config: true
      };

      if (this.isEditFormGroup) {
        apiEndpoint = this.editFormGroupApi + '/' + this.formGroupId;
        params.config = false;
      }

      return axios.get(apiEndpoint , { params }).then((response) => {
        this.$store.commit('updateFormFields', response.data.data.form_fields);
        this.showLoader = false;
        return response
      }).catch((error) => {
        this.showLoader = false;
        errorHandler(error, 'form-builder-main');
      })
    },

    // If the case of create/edit form check form name is valid or not
    isValidFormName() {
      if(this.isCreateFormGroup || this.isEditFormGroup){
        const { errors, isValid } = validateFormGroup(this.$props);
        return isValid;
      } else {
        return true;
      }
    },

    // fetch form-groups from server
    getFormGroupList() {
      if (this.activeFormCategoryType === 'user' || this.activeFormCategoryType === 'organisation') {
        return;
      }
      this.showLoader = true;
      const supplementsValue = this.defaultCategories.includes(this.activeFormCategoryType)
          ? this.activeFormCategoryType
          : 'ticket';

      const parameters = { limit: 2000, supplements: supplementsValue };
      axios.get('api/dependency/form-groups', { params: parameters})
          .then(res => {
            this.formGroupList = res.data.data.form_groups.map(s => {
              return {
                id: s.id,
                title: s.name,
                name: s.name,
                type: 'group',
                edit_url: s.edit_url,
                is_deletable: 1
              }
            });
          })
          .catch(err => {
            console.error('Error in getting form group list ', err);
          }).finally(() => {
        this.showLoader = false;
      })
    },

    // Save button click event
    async onSaveForm() {
      if (this.isValidFormName()) {
        const formBuilderData = this.$store.getters.getFormFields;
        this.assignSortOrder(formBuilderData);
        this.saveForm(formBuilderData);
      }
    },

    /**
     * Assign sort_order to each field
     * `sort_order` will be the array index of the element in which the element presents
     */
    assignSortOrder(array) {
      for (let i = 0; i < array.length; i++) {
      array[i].sort_order = i;
      Object.keys(array[i]).forEach(key => {
      if (boolean(array[i][key]) && Array.isArray(array[i][key])) {
        this.assignSortOrder(array[i][key]);
      }
    });
     }
   },
    // make api call to save form fields in DB
    async saveForm(formBuilderData) {
      try {
        this.showLoader = true;
        const api = this.getApiEndpoint();
        const resp = await this.postFormData(api, formBuilderData);
        this.handleSuccess(resp);
      } catch (error) {
        this.handleFailure(error);
      }
    },

    getApiEndpoint() {
      return this.isCreateFormGroup || this.isEditFormGroup ? this.postFromGroupApi : 'api/post-form-data';
    },

    async postFormData(api, formBuilderData) {
      return await axios.post(api, this.getSaveFormParams(formBuilderData));
    },

    handleSuccess(resp) {
      successHandler(resp, 'form-builder-main');
      if (this.isCreateFormGroup || this.isEditFormGroup) {
        this.handleSuccessForCreateOrEdit();
      } else {
        this.handleSuccessForOther();
      }
    },

    handleSuccessForCreateOrEdit() {
      this.showLoader = false;
      setTimeout(() => {
        this.$router.push({ name: 'FormGroups Index' });
      }, 3000);
    },

    handleSuccessForOther() {
      this.getFormDataFromServer().then(() => {
        this.showLoader = false;
      });
    },

    handleFailure(error) {
      this.showLoader = false;
      errorHandler(error, 'form-builder-main');
    },


    // returns parameters for making api call to save form
    getSaveFormParams(formBuilderData) {
      let params = {};
      params['category'] = this.activeFormCategoryType;
      params['form-fields'] = formBuilderData;

      if (this.isCreateFormGroup || this.isEditFormGroup) {
        params[this.localFormNameObj.submitFormParamKey] = this.localFormNameObj.value;

        this.localFormLinker.forEach(element => {
          params[element.submitFormParamKey] = element.value.map(e => e.id);
        });
      }
      if (this.isEditFormGroup) {
        params['id'] = this.formGroupId;
      }
      return params;
    },

    // Remove element from db/local
    onRemoveElement(obj) {
      this.showDeleteModal = true;
      this.deleteType = obj['reference_type'];
      this.deleteData = obj['fieldData'];
      this.deleteId = obj['reference_id'];
    },

    doDelete() {
      this.showDeleteModal = false;
      if(this.isDeleteFromDB(this.deleteData)) {
        this.deleteElementFormDB(this.deleteData.id, this.deleteId, this.deleteType);
      } else {
        this.deleteElementLocally(this.deleteData.form_identifier);
      }
    },

    /**
     * Delete formfield locally if the successfully deleted from db
     */
    deleteElementLocally(form_identifier) {
      const data = this.$store.getters.getFormFields;
      const isResolved = this.removeAt(data, form_identifier)
      if(isResolved) {
        this.$store.dispatch('updateFormFields', data);
      }
    },

    // make api call to delete form field
    deleteElementFormDB(id, reference_id, reference_type) {
      this.showLoader = true;
      let api = 'api/delete-form-data/form-field/' + id;
      if (reference_id) { // if reference_id is truthy(condition for form-group)
        api = 'api/unlink-form-group/' + reference_type + '/' + reference_id;
      }
      axios.delete(api).then(resp => {
            successHandler(resp, 'form-builder-main');
            this.getFormDataFromServer();
            this.showLoader = false;
          })
          .catch(error => {
            this.showLoader = false;
            errorHandler(error, 'form-builder-main');
          });
    },

    // check whether formfield have to removed from db or locally
    isDeleteFromDB(fieldData) {
      /**
       * If group type, check for groupid
       * If it has `groupid` property that means it's being created locally not present in DB
       */
      if(fieldData.type === 'group') {
        return typeof fieldData.groupid === 'undefined';
      }
      /**
       * We are assigning timestamp to the id of newly dropped items
       * At this time, timestamp length will be greater or equal to 13
       * So, if it is less than 13, remove the element from db
       **/
      return fieldData.id.toString().length < 13;
    },

    // recursively find element which need to be removed and remove the element by it's ID -- considered `nodes` and `options` cases
    removeAt(array, form_identifier) {
      let idx = _.findIndex(array, (element) => element.form_identifier === form_identifier);
      if(idx !== -1) {
        array.splice(idx, 1);
      } else {
        for (let i = 0; i < array.length; i++) {
          if(boolean(array[i].options)) {
            this.removeAt(array[i].options, form_identifier);
          }
          if(boolean(array[i].nodes)) {
            this.removeAt(array[i].nodes, form_identifier);
          }
        }
      }
      return Promise.resolve(true);
    },
    onChange(value, name) {

      this[name] = value;

      if (value !== '') {
        this.isDisabled = false;
      }

    },
    onSubmit() {
      this.showLoader = true

      this.isDisabled = true

      let data = {};

      data['organization'] = this.organisation;

      axios.post('form-category/configs/' + this.activeFormCategoryType, data).then(res => {

        this.showLoader = false

        successHandler(res, 'form-builder-main');

        window.emitter.emit('refreshData');

        this.onClose()

      }).catch(err => {
        this.showLoader = false;
        errorHandler(err, 'form-builder-main');
        this.onClose()
      })
    },

    // Listen event emmited from form-setting component to change form fields properties
    async applySettingsChanges(changedValue) {
      const data = this.$store.getters.getFormFields;
      const isResolved = await this.assignNewValue(data, changedValue.form_identifier, changedValue);
      if(isResolved) {
        this.$store.dispatch('updateFormFields', data);
      }
    },

    // recursively finds the index of the property that has been altered and replace old object with new object -- considered `nodes` and `options` cases
    assignNewValue(array, affectedId, newObj) {
      let idx = _.findIndex(array, (element) => element.form_identifier === affectedId);
      if(idx !== -1) {
        array[idx] = newObj;
      } else {
        for (let i = 0; i < array.length; i++) {
          if(boolean(array[i].options)) {
            this.assignNewValue(array[i].options, affectedId, newObj);
          }
          if(boolean(array[i].nodes)) {
            this.assignNewValue(array[i].nodes, affectedId, newObj);
          }
        }
      }
      return new Promise(resolve => {
        resolve(true);
      });
    },

  }

}
</script>

<style lang="css" scoped>
.active {
  border-top: 2px solid #3c8dbc;
  border-right: 1px solid #dedede;
  border-bottom: 0px;
}
.setting-gear{
  cursor: pointer;
  margin-right: 10px;
}
.left-section,
.right-section {
  border: 1px solid #c0c3c4;
  padding: 10px;
}
.formFields{
  padding: 12px;
  margin-top: 4px!important;
}
</style>

