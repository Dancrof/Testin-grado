<template>
    <div>
        <time-period v-if="scenario === 'recur'" :recur_mode="recur_mode"></time-period>
        <ticket-template-name v-if="scenario === 'template'" :template_mode="template_mode"></ticket-template-name>

        <div class="row">
            <div v-for="formField in formFields" :key="formField.unique" :id="formField.unique" class="col-md-12">
                <form-field-renderer
                        :formId="formId"
                        :form-field="formField"
                        :formUniqueKey="formUniqueKey"
                        :panel="panel"
                        :scenario="scenario"
                        :formType="category"
                        :btn-style="btnStyle"
                        :input-style="inputStyle"
                        :isInlineForm="isInlineForm"
                        :sizeModules="sizeModules"
                        :apiKey="apiKey">
                </form-field-renderer>
            </div>
        </div>
    </div>
</template>

<script>

import FormFieldRenderer from "./FormFieldRenderer.vue";
import Loader from "../../MiniComponent/Loader.vue";
import TimePeriod from "../../Admin/Recurring/TimePeriod.vue";
import TicketTemplateName from "../../Admin/Tickets/Templates/TicketTemplateName.vue";
import {errorHandler} from "../../../helpers/responseHandler";
import {mapActions, mapGetters, mapState} from "vuex";


export default {
    name: 'old-form-renderer',

    props: {

        recur_mode: {type: String, default: ''},

        template_mode: {type: String, default: ''},

        // API Endpoint to fetch the form fields JSON
        fetchFormFieldApi: {type: String, required: true},

        // Form unique key to pick data from the Store
        formUniqueKey: {type: String, required: true},

        // category is for categorizing the FaveoForm; may be ticket, user, organization, etc
        category: {type: String, required: true},

        // scenario will be the mode of the FaveoForm Category; may be create/edt/recur etc
        scenario: {type: String, required: true},

        // One category may be present in differnet panels(admin/client/agent)
        panel: {type: String, required: true},

        // if it is a child form of a parent form (for eg. requester form in ticket form)
        isChildForm: {type: Boolean, default: false},

        disableEmail: {type: Boolean, default: false},

        inputStyle: {
            type: Object, default: () => {
            }
        },

        btnStyle: {
            type: Object, default: () => {
            }
        },

        isInlineForm: { type: Boolean, default: true },

        formId: { type: String, default: '' },
        
        apiKey : { type : String, default : '' }
    },
    data: () => {
        return {
            // Array of form field data
            formFields: [],
            // attachmentsArr:[]
        }
    },

    computed: {
        ...mapActions(['setAttachmentsData'],),
      ...mapGetters(['getCategory']),
      getApiParams() {
            return {category: this.category, scenario: this.scenario, panel: this.panel, api_key : this.apiKey}
        }
    },

    created() {
      this.getFormFields(this.getCategory);
      // window.emitter.on('updateTicketCategory', this.getFormFields)
    },
  watch: {
    getCategory(newCategory) {
      this.getFormFields(newCategory);
    },
  },
    methods: {

        getFormFields(category = null) {
           let params = this.getApiParams;

           if(category) {
             params.category = category === 'from_register' ? 'ticket' :  category;

             // Empty formFields if category is not 'from_register' - UserFormModal
             if (category !== 'from_register') {
               this.formFields = [];
             }
           }

            if (this.isChildForm) {
                this.$store.dispatch('startChildFormLoader');
            } else {
                this.$store.dispatch('startLoader', 'getFormFields');
            }

            axios.get(this.fetchFormFieldApi, {params:params})
                .then(response => {
                    this.formFields = response.data.data.form_fields;
                    this.sizeModules = response.data.data;
                    let attachmentsResponse = response.data.data.attachments;
                    this.$store.dispatch('setAttachmentsData', attachmentsResponse);

                    if(this.scenario != 'recur' && this.scenario != 'template'){

                        this.formFields[0]['auto_focus'] = true;
                    }

                    window.emitter.emit('storeCategoryId', response.data.data.category_id)

                    if (this.disableEmail) {

                        let objIndex = this.formFields.findIndex((obj => obj.unique === "email"));

                        this.formFields[objIndex].disabled = true

                    }

                    // Update the submitApiENdpoint for corresponding form insatnce to the store
                    this.$store.dispatch('updateSubmitApiEndpoint', {
                        formUniqueKey: this.formUniqueKey,
                        submitApiEndpoint: response.data.data.submit_endpoint
                    });

                    // Update recur data if any
                    const recurData = response.data.data.recur ?? { id: null, name: '', interval: '', delivery_on: '', start_date: '', end_date: '', execution_time: ''} ;
                    
                    if (recurData) {
                        this.$store.dispatch('setEditorAttachments', response.data.data.attachments ?? [])
                        for (const [key, value] of Object.entries(recurData)) {
                            this.$store.dispatch('updateRecurProperties', {key: key, value: value});
                        }
                    }
                    // Update template data if any
                    const templateData = response.data.data.template;

                    if (templateData) {

                        for (const [key, value] of Object.entries(templateData)) {

                            this.$store.dispatch('updateTemplateProperties', {key: key, value: value});
                        }
                    }

                    // Update batch ticket mode to the store
                    this.$store.dispatch('setBatchTicketMode', response.data.data.batch_ticket_status);

                })
                .catch(err => {
                    errorHandler(err, 'form-renderer');
                })
                .finally(() => {
                    if (this.isChildForm) {
                        this.$store.dispatch('stopChildFormLoader');
                    } else {
                        this.$store.dispatch('stopLoader', 'getFormFields');
                    }
                })
        },

    },

    components: {
        'form-field-renderer': FormFieldRenderer,
        'loader': Loader,
        'time-period': TimePeriod,
        'ticket-template-name': TicketTemplateName,
    }
}
</script>

<style scoped>
.form-field-wrapper {
    min-height: 91px;
}
</style>