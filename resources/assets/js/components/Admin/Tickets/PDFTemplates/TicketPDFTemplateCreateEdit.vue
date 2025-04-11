<template>

    <div class="col-sm-12">

        <div class="row" v-if="!hasDataPopulated || loading">

            <custom-loader :duration="4000"></custom-loader>
        </div>

        <alert componentName="ticket-pdf-template"/>

        <div class="card card-light" v-if="hasDataPopulated">

            <div class="card-header">

                <h3 class="card-title">{{trans(title)}}</h3>
            </div>

            <div class="card-body">

                <div class="row">

                    <div class="col-md-12">

                        <div class="card card-light">

                            <div class="card-header">

                                <h3 class="card-title">{{trans('list-of-available-shot-codes')}}</h3>
                            </div>

                            <div class="card-body col-md-12">

                                <div class="row" v-if="shortCodesLoader">

                                    <reuse-loader :animation-duration="4000" :size="60"/>
                                </div>

                                <div v-else>

                                    <div class="alert alert-info alert-dismissable">

                                        <i class="fas  fa-info-circle"></i>&nbsp;

                                        <span>{{trans('template-short-code-tips')}}</span>

                                        <button type="button" class="btn-close float-end" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>

                                    <ul class="list-inline" v-if="shortcodes.length">

                                        <li v-for="item in shortcodes" class="list-inline-item" style="width: 23%">

                                            <span v-tooltip.right="{ content : trans(item.desc_lang_key), html : true}" data-placement="right">{{item.shortcode}}</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">

                  <text-field :autofocus="true"  :label="trans('name')" :value="name" type="text" name="name" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6" :required="true" />

                  <number-field  :hint="trans('maximum_logs_tooltip_for_pdf')" :label="trans('maximum_logs')" :value="maximum_logs" type="text" name="maximum_logs" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6" :required="true" />

                </div>

                <div class="row">
                    <tiny-editor-with-validation id="ticket-template-editor" :value="template" type="text" :onChange="onChange" name="template" :label="lang('template')" :required="true" classname="col-sm-12 width55" :lang="'en'" :convertURLs="false">

                    </tiny-editor-with-validation>

                </div>
            </div>

            <div class="card-footer">

                <button class="btn btn-primary" id="submit_btn" @click="onSubmit()">

                    <i :class="iconClass"></i> {{trans(btnName)}}
                </button>
            </div>
        </div>
    </div>
</template>

<script>

import axios from 'axios'

import { successHandler, errorHandler } from "../../../../helpers/responseHandler";

import  { getIdFromUrl } from "../../../../helpers/extraLogics";

import { validateTicketPdfTemplateSettings } from "../../../../helpers/validator/ticketPdfTemplateSettings";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import NumberField from "../../../MiniComponent/FormField/NumberField.vue";

export default {

    data(){

        return {

            title : 'create_ticket_pdf_template',

            iconClass : 'fas fa-save',

            btnName : 'save',

            hasDataPopulated : false,

            loading : false,

            ticket_pdf_template_id : '',

            shortCodesLoader : false,

            shortcodes : [],

            name : '',

            template: '',

            maximum_logs : 50,
        }
    },

    beforeMount(){

        const path = window.location.pathname

        this.getValues(path);

        this.getShortCodes();
    },

    methods :{

        getShortCodes() {

            this.shortCodesLoader = true

            axios.get('/api/getTicketSetting/pdfShortCodes').then(res=>{

                this.shortCodesLoader = false;

                this.shortcodes = res.data.data;

            }).catch(error=>{

                this.shortCodesLoader = false;

                errorHandler(error,'ticket-pdf-template');
            });
        },

        getValues(path){

            const ticketPdfId = getIdFromUrl(path)

            if(path.indexOf('edit') >= 0){

                if(!this.from){

                    this.title = 'edit_ticket_pdf_template'

                    this.iconClass = 'fas fa-sync'

                    this.btnName = 'update'

                    this.hasDataPopulated = false

                    this.getInitialValues(ticketPdfId)
                } else {

                    this.loading = false;

                    this.hasDataPopulated = true;
                }
            } else {

                this.loading = false;

                this.hasDataPopulated = true;
            }
        },

        getInitialValues(id){

            this.loading = true

            axios.get('/api/get/individualPdfTemplates/'+id).then(res=>{

                this.loading = false;

                this.hasDataPopulated = true;

                this.name = res.data.data.name;

                this.maximum_logs = res.data.data.maximum_logs;

                this.template = res.data.data.template;

                this.ticket_pdf_template_id = res.data.data.id;

            }).catch(error=>{

                this.loading = false;

                this.hasDataPopulated = true;

                errorHandler(error,'ticket-pdf-template');
            });
        },

        isValid() {

            const { errors, isValid } = validateTicketPdfTemplateSettings(this.$data);

            return isValid;
        },

        onChange(value, name) {

            this[name] = value;
        },

        onSubmit(){

            if(this.isValid()){

                this.loading = true

                let data = {};

                if(this.ticket_pdf_template_id){

                    data['id'] = this.ticket_pdf_template_id;
                }

                data['name'] = this.name;

                data['maximum_logs'] = this.maximum_logs;

                data['template'] = this.template;

                axios.post('/api/store/ticket-pdf-template', data).then(res => {

                    this.loading = false

                    successHandler(res,'ticket-pdf-template')

                    if(!this.ticket_pdf_template_id){

                        setTimeout(()=>{

                            this.$router.push({ name : 'Ticket PDF Templates Index' })
                        },3000);

                    } else {

                        this.getInitialValues(this.ticket_pdf_template_id)
                    }
                }).catch(err => {

                    this.loading = false

                    errorHandler(err,'ticket-pdf-template')
                });
            }
        },
    },

    components : {
      'number-field' : NumberField,

      "text-field": TextField
    }
};
</script>

<style scoped>

</style>