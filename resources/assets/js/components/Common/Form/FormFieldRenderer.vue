<template>


  <!-- This component recieves one form-field at a time, so any one of the below component will get mounted at a time on basis of its type (;; for each form field there will be a seperate instance of this component) -->
    <div>


        <tiny-editor-with-validation v-if="formField.type ==='htmltextarea'" :id="formField.unique"
                                     :name="formField.unique"
                                     :label="formField.label" :value="selectedValue || ''" :hint="formField.description"
                                     :isInlineForm="isInlineForm" :onChange="onChange" :rules="validationRules"
                                     :required="isRequiredField" :mediaOption="formField.media_option"
                                     :attachments="attachments" from="ticket"
                                     :getAttach="getAttachments" :panel="panel"
                                     :tip-rule="formField.show_description_under_form_field">


        </tiny-editor-with-validation>


        <date-time-field v-if="formField.type === 'date'" type="datetime" :label="formField.label"
                         :value="selectedValue"
                         :id="formField.unique" :name="formField.unique" :onChange="onChange"
                         :required="isRequiredField"
                         format="MMMM DD YYYY HH:mm:ss" :clearable="true" :hint="formField.description"
                         :isInlineForm="isInlineForm"
                         :rules="validationRules" outputFormat="YYYY-MM-DD HH:mm:ss" from="form"
                         :tip-rule="formField.show_description_under_form_field">


        </date-time-field>


        <!-- Dynamic Select with options form api -->
        <dynamic-select v-if="(formField.type === 'api' || formField.type === 'multiselect') && !isMultipleRequester"
                        :id="formField.unique" :label="formField.label" :multiple="formField.type === 'multiselect'"
                        :name="formField.unique" :apiEndpoint="apiInfoUrl" :value="selectedValue" :onChange="onChange"
                        :required="isRequiredField"
                        :actionBtn="getActionButtonObj"
                        :apiParameters="apiParams()"
                        :isInlineForm="isInlineForm" :rules="validationRules" :hint="formField.description" :strlength="75"
                        :tip-rule="formField.show_description_under_form_field" :formIsFor="formType"
                        :fieldUniqueName="formField.unique"></dynamic-select>


        <file-upload v-if="formField.unique === 'requester' && isMultipleRequester && panel !== 'client'"
                     :label="formField.label" :value="selectedValue" :id="formField.unique" :name="formField.unique"
                     :onChange="onChange" :required="isRequiredField" accept=".csv,.xlxs" :isInlineForm="isInlineForm"
                     rules="required" :tip-rule="formField.show_description_under_form_field"></file-upload>

        <div class="d-flex justify-content-end">
          <div class="form-check checkbox multi-requester-checkbox pull-end me-1" v-if="showMultiRequesterCheckbox">

            <input type="checkbox" class="form-check-input"  v-model="isMultipleRequester" name="isMultipleRequester"
                   @change="clearSelectedValue()">
            <label class="control-label" > {{ trans('upload_multi_requester') }}</label>
          </div>
        </div>

        <!--     Dynamic select with static options-->
        <dynamic-select v-if="formField.type === 'select'" :id="formField.unique" :label="formField.label"
                        :multiple="false"
                        :name="formField.unique" :elements="dropdownOptions" :value="selectedValue" :onChange="onChange"
                        :required="isRequiredField" :optionLabel="optionLabel" :isInlineForm="isInlineForm"
                        :rules="validationRules"
                        :hint="formField.description" :strlength="75"
                        :tip-rule="formField.show_description_under_form_field"></dynamic-select>


        <dynamic-select v-if="formField.type === 'taggable'" :id="formField.unique" :label="formField.label"
                        :multiple="true" :taggable="true" :name="formField.unique" :elements="[]" :value="selectedValue"
                        :onChange="onChange" :required="isRequiredField" :optionLabel="optionLabel" :isInlineForm="isInlineForm"
                        :rules="validationRules" :hint="formField.description" :strlength="75"
                        :tip-rule="formField.show_description_under_form_field"></dynamic-select>


        <dynamic-select v-if="formField.type === 'taggable-api'"
                        :id="formField.unique" :label="formField.label"
                        :multiple="true" :taggable="true" :name="formField.unique"
                        :value="selectedValue" :onChange="onChange"
                        :required="isRequiredField"
                        :optionLabel="optionLabel"
                        :isInlineForm="isInlineForm" :rules="taggableApiDynamicSelectRules"
                        :hint="formField.description" :strlength="75"
                        :tip-rule="formField.show_description_under_form_field"
                        :apiEndpoint="apiInfoUrl"
        />

        <!--    Text filed to accept fields text, textarea, number, email, float -->
        <text-field
                v-if="formField.type === 'text' || formField.type === 'textarea' || formField.type === 'number' || formField.type === 'email' || formField.type === 'float'"
                :id="formField.unique" :label="formField.label" :type="formField.type" :name="formField.unique"
                :value="selectedValue" :onChange="onChange" :required="isRequiredField" :isInlineForm="isInlineForm"
                :rules="validationRules" :pattern="formField.pattern" :hint="formField.description"
                :validation-message="formField.validation_message"
                :tip-rule="formField.show_description_under_form_field" :autofocus="formField.auto_focus"
                :keypressEvt="keypressEvent" :pasteEvt="pasteEvent" :inputStyle="inputStyle"></text-field>


        <client-requester v-if="formField.type === 'client-panel-requester'" :id="formField.unique"
                          :label="formField.label"
                          :name="formField.unique" :value="selectedValue" :onChange="onChange"
                          :required="isRequiredField"
                          :isInlineForm="isInlineForm" :hint="formField.description" :rules="validationRules"
                          :actionBtn="getActionButtonObj" :autofocus="formField.auto_focus"
                          :tip-rule="formField.show_description_under_form_field" :inputStyle="inputStyle"></client-requester>


        <radio-field v-if="formField.type === 'radio'" :name="formField.unique" :label="formField.label"
                     :hint="formField.description" :required="isRequiredField" :options="formField.options"
                     :value="selectedValue" :onChange="onChange" :isInlineForm="isInlineForm" :rules="validationRules"
                     :tip-rule="formField.show_description_under_form_field"></radio-field>


        <checkbox-field v-if="formField.type === 'checkbox'" :name="formField.unique" :label="formField.label"
                        :hint="formField.description" :required="isRequiredField" :options="formField.options"
                        :value="selectedValue" :onChange="onChange" :isInlineForm="isInlineForm" :rules="validationRules"
                        :tip-rule="formField.show_description_under_form_field"></checkbox-field>


        <template v-if="formField.type === 'file'">


            <file-upload v-if="showFileField" :label="formField.label" :value="selectedValue" :name="formField.unique"
                         :onChange="onChange" :required="isRequiredField" :id="formField.unique" accept=""
                         :isInlineForm="isInlineForm" :rules="validationRules" :hint="formField.description"
                         :multiple="formField.unique!=='organisation_logo' "
                         :tip-rule="formField.show_description_under_form_field"
                         v-bind="formField.unique !== 'organisation_logo' ? { sizeModules: sizeModules } : {}" :formType="formType"
            ></file-upload>


            <custom-loader v-if="!showFileField"></custom-loader>
        </template>
        <template v-if="formField.type === 'image'">


            <assetimage-upload v-if="showFileField" :label="formField.label" :value="selectedValue" :name="formField.unique"
                               :onChange="onChange" :required="isRequiredField" :id="formField.unique"
                               accept="image/*" :isInlineForm="isInlineForm" :rules="validationRules" :hint="formField.description"
                               :tip-rule="formField.show_description_under_form_field"
            >


            </assetimage-upload>
            <custom-loader v-if="!showFileField"></custom-loader>
        </template>


        <template v-if="formField.type === 'custom'">
            <div id="faveo-app-extra-form-field">{{ customTypeFormFieldMounted() }}</div>
        </template>


        <div v-for="node in childNodes" :key="node.unique" class="form-field-wrapper">
            <form-field-renderer :form-field="node" :formUniqueKey="formUniqueKey" :input-style="inputStyle" :panel="panel"
                                 :scenario="scenario" :isInlineForm="isInlineForm" :apiKey="apiKey"></form-field-renderer>
        </div>


        <transition name="modal">
            <user-form-modal v-if="showCreateUserModal" :show="showCreateUserModal" :isInlineForm="isInlineForm"
                             :closeModal="closeModal" :updateNewRequester="onChange"
                             :panel="panel" :inputStyle="inputStyle" :btnStyle="btnStyle" :formId="formId" :apiKey="apiKey"></user-form-modal>
        </transition>
    </div>
</template>



<script>
import {MULTIPLE_PROPERTY_HELPER, boolean} from '../../../helpers/extraLogics';
import {getFormFieldValue} from '../../../helpers/formUtils';
import axios from 'axios';
import {mapGetters} from 'vuex';
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
import TextField from "../../MiniComponent/FormField/TextField.vue";
import RadioField from "./RadioField.vue";
import CheckboxField from "./CheckboxField.vue";
import fileUpload from "../../MiniComponent/FormField/fileUpload.vue";
import DateTimePicker from "../../MiniComponent/FormField/DateTimePicker.vue";
import UserFormModal from "./UserFormModal.vue";
import ClientRequester from "../../MiniComponent/FormField/ClientRequester.vue";
import assetimageUpload from "../../MiniComponent/FormField/assetimageUpload.vue";


export default {


    name: 'form-field-renderer',


    props: {


        // Form unique key to pick data from the Store
        formUniqueKey: {type: String, required: true},


        // Form field object
        formField: {type: Object, required: true},


        // One category may be present in differnet panels(admin/client/agent)
        panel: {type: String, default: 'agent'},


        // scenario will be the mode of the FaveoForm Category; may be create/edt/recur etc
        scenario: {type: String, require: true},


        // formType will be the category of the FaveoForm (ticket, user ...)
        formType : { type : String, default : ''},


        inputStyle : { type : Object, default : ()=>{}},


        btnStyle : { type : Object, default : ()=>{}},

        sizeModules: { type : String, default : ''},

        isInlineForm: { type: Boolean, default: true },

        formId: { type: String, default: '' },
        
        apiKey : { type : String, default : '' }
    },


    data() {
        return {


            // formField object as a child of another form field, we are updating this object in onChange fn
            childNodes: [],


            // For dynamic-select rendered with some static options, this array will have all the options
            dropdownOptions: [],


            // Checkbox value to switch between file-upload and dynamic-select to handle batch ticket
            isMultipleRequester: false,


            // selected value of the form field
            selectedValue: '',


            // if true one pop-up will appear to create new requester/user
            showCreateUserModal: false,


            attachments: [],


            taggableApiDynamicSelectRules: '',


            showFileField : false,


        }
    },


    beforeMount() {
        
        // If type is 'select' we will assign options to the `dropdownOptions`
        if (this.formField.type === 'select') {
            this.getSelectFieldOptions()
        }


    },


    mounted() {
        // Assign form-field value to the `selectedValue` -- used when scenario is edit
        this.selectedValue = getFormFieldValue(this.formField.value, this.formField.options, this.formField.default, this.formField.type, this.formField.unique);


        setTimeout(() => {


            this.showFileField = true;


        }, 2000)


        this.bindValuesFromUrl();


        this.renderNestedFormFieldsIfAny(this.selectedValue);


        // update form-value object with current selected value. In case of create it will be empty, in case of edit it may have some value
        this.updateFormValuesToStore();
    },


    computed: {


        ...mapGetters({getFaveoFormData: 'getFaveoFormData', isBatchTicketMode: 'getBatchTicketMode'}),


        /**
         * this will have url part of the api_info --used in case of <title = 'Api'>
         */
        apiInfoUrl() {


            let apiUrl = MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.formField.api_info).url;


            if (apiUrl == '/api/dependency/departments?meta=true' || apiUrl == '/api/dependency/help-topics?meta=true') {
                apiUrl = apiUrl + '&panel=' + this.panel;
            }


            return apiUrl


        },




        optionLabel() {
            return MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.formField.api_info).key || 'label';
        },




        // returns Boolean of required property
        isRequiredField() {
            return Boolean(this.formField.required);
        },




        /**
         * Provides validation string joined by pipes
         * https://logaretm.github.io/vee-validate/guide/basics.html
         */
        validationRules() {
            let validationObj = [];


            if (this.isRequiredField) {
                validationObj.push('required')
            }


            if (this.formField.type === 'email') {
                validationObj.push('email')
            }


            return validationObj.join('|')
        },




        /**
         * Provides an object for adding a button to the dynamic-select for other operations
         */
        getActionButtonObj() {


            if (this.formField.unique === 'requester') {
                // on client panel, user will be registering itself. But on agent panel, agent will be creating other users
                let text = this.panel === 'client' ? 'register' : 'create_user';
                window.emitter.emit("cropModalChanged", "");
                return {text: text, action: () => this.showCreateUserModal = true}
            } else {
                return null;
            }
        },


        showMultiRequesterCheckbox() {
            return this.formField.unique === 'requester' && this.isBatchTicketMode && this.panel === 'agent';
        }
    },




    methods: {

        apiParams() {
            
            if(this.getFaveoFormData[this.formUniqueKey] ) {
                
                if(this.apiKey) {

                    this.getFaveoFormData[this.formUniqueKey].formDataMap.set('api_key', this.apiKey);
                    
                }
                
                return this.getFaveoFormData[this.formUniqueKey].formDataMap;
                
            } else {
                
                return this.apiKey ? {api_key : this.apiKey} : {}
            }
        },
        
        keypressEvent(evt, name, type) {


            if (type == 'number') {


                evt = (evt) ? evt : window.event;


                var charCode = (evt.which) ? evt.which : evt.keyCode;


                if ((charCode > 31 && (charCode < 48 || charCode > 57))) {


                    evt.preventDefault();
                    ;


                }else {


                    return true;
                }
            }else if (type == 'float') {

              // if the type is float then the only integer or float value should be entered.

              evt = evt || window.event;

              var charCode = (evt.which) ? evt.which : evt.keyCode;

              // Allow digits and the decimal point (period)
              if ((charCode >= 48 && charCode <= 57) || charCode == 46) {

                return true;
              } else {

                evt.preventDefault();
              }
            }
        },


        pasteEvent(evt, name, type) {


            if (type == 'number') {


                evt = (evt) ? evt : window.event;


                if (evt.clipboardData.getData('Text').match(/[^\d]/)) {


                    evt.preventDefault();
                }


            }else if (type == 'float') {
              evt = evt || window.event;
              var clipboardData = evt.clipboardData || window.clipboardData;
              var pastedText = clipboardData.getData('Text');

              // Allow only if the pasted text contains digits and at most one decimal point
              if (!/^\d*\.\d*$/.test(pastedText)) {
                evt.preventDefault();
              }
            }
        },


        getAttachments(value) {
            
            this.attachments = value;
            
            this.$store.dispatch('setEditorAttachments', this.attachments)
        },


        isMail(element, index, array) {


            let emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,20}$/;


            return emailPattern.test(element.email ? element.email : element.name);
        },


        // triggered when any form-field value detects any change
        onChange(value, name) {

            if(name =='requester'){
                this.selectedValue= value.user_name;
            }

            if (name == 'help_topic_id' || name == 'department_id' || name == 'team_id') {


                window.emitter.emit('updateDynamicSelect')
            }

            if (this.formType == 'user') {


                if (name == 'organisation' || name == 'organisation_department') {

                    window.emitter.emit('updateDynamicSelect')
                }
            }

            if (name === 'adhoc_approvers_agent') {
                if (!value.length) {
                    this.taggableApiDynamicSelectRules = ''
                } else {
                    this.taggableApiDynamicSelectRules = value.every(this.isMail) ? '' : 'email'
                }
            }

            this.selectedValue = value ? value : ''
            this.updateFormValuesToStore()
            this.renderNestedFormFieldsIfAny(value)
        },


        // Update form value to the Store object for the corresponding faveoForm instance
        updateFormValuesToStore() {
            const formData = {
                id: this.formField.unique,
                isDefault: Boolean(this.formField.default),
                formUniqueKey: this.formUniqueKey,
                selectedValue: this.selectedValue || '',
                optionLabel: this.optionLabel
            }
            this.$store.dispatch('setFormData', formData)
        },


        // Render/mount nested form-fields if any
        renderNestedFormFieldsIfAny(value) {
            this.childNodes = []
            if (value) {
                if (Array.isArray(value)) { // In case of checkbox `value` will be an array
                    value.forEach(v => {
                        if (boolean(v.nodes)) {
                            this.childNodes.push(...v.nodes)
                        }
                    })
                } else if (boolean(value.nodes)) { // In other case value is the selected object
                    this.childNodes = value.nodes
                }
            }
        },


        getSelectFieldOptions() {
            if (boolean(this.apiInfoUrl)) {
                this.fetchOptionListForApiField();
            } else {
                this.dropdownOptions = this.formField.options;
            }
        },


        // Fetch option list -- specifically for 3rd party api config form-field
        fetchOptionListForApiField() {
            axios.get(this.apiInfoUrl)
                .then((response) => {
                    this.dropdownOptions = response.data;
                })
                .catch((error) => {
                    console.error(error);
                })
        },


        // clear the selected value to empty string
        clearSelectedValue() {
            this.selectedValue = ''
        },


        // triggered for a purpose to mount form-field of type = custom
        customTypeFormFieldMounted() {
            const data = {
                node: this.formField,
                showFilter: this.panel === "agent" || this.panel === "admin",
                formUniqueKey: this.formUniqueKey,
                scenario: this.scenario,
                category: this.formType
            };
            window.emitter.emit('custom-type-form-field-mounted', data);
        },


        /**
         * Binds value from url to the form field
         */
        bindValuesFromUrl() {
            // if the unique_id exists in the url, it should make an API call and populate that
            let urlParams = new URLSearchParams(window.location.search);


            let unique = this.formField.unique.replace('_id', '');


            if (urlParams.get(unique) && !this.selectedValue) {
	            
                if (this.formField.type === 'api') {
                    axios.get(this.apiInfoUrl, {
                        params: {
                            'strict-search': 1,
                            'search-query': urlParams.get(unique),
                            'paginate': 1
                        }
                    }).then(res => {
                        res.data.data.data[0] && (this.selectedValue = res.data.data.data[0]);
                    });
                }


                this.formField.type === 'client-panel-requester' && (this.selectedValue = urlParams.get(unique));
            }
        },

      closeModal(from){
        this.showCreateUserModal = false;

        if(this.panel=== 'client' && from !== 'user-form') {
          window.emitter.emit('updateTicketCategory', 'from_register');
        }
      }
    },


    beforeDestroy() {
        // Update form value object with deleting the specific property form the object -- valid in case if nested field get destroyed
        this.$store.dispatch('deleteFormDataByKey', {formUniqueKey: this.formUniqueKey, key: this.formField.unique})
    },


    components: {
        'dynamic-select': DynamicSelect,
        'text-field': TextField,
        'radio-field': RadioField,
        'checkbox-field': CheckboxField,
        'file-upload': fileUpload,
        'date-time-field': DateTimePicker,
        'user-form-modal': UserFormModal,
        'client-requester': ClientRequester,
        'assetimage-upload': assetimageUpload
    }

}
</script>


<style scoped>
.multi-requester-checkbox {
    margin-top: -15px;
}

.form-check-input{
  cursor: pointer !important;
}
</style>

