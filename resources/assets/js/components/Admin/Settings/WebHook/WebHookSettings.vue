<template>

    <div class="col-sm-12">

        <alert componentName="web-hook-settings" />

        <faveo-box :title="trans('webhook_configurations')">

            <template #headerTooltip>

                <tool-tip :message="trans('webhook_update_tooltip')" size="small"></tool-tip>
            </template>

            <custom-loader v-if="isLoading"></custom-loader>
          
            <label for="sources"> {{trans('web_hook_sources')}} </label>
            <span class="text-danger">*</span>

            <tool-tip :message="trans('the_message_or_payload_will_be_sent_to_the_source')" size="small"></tool-tip>
            <br>

            <div class="row">

                <div v-for="item in checkbox_data" :key="item.id" class="col-auto">

                    <checkbox :name="item.id" :value="item.is_checked" :label="item.value" class="checkbox-label"
                              :title="item.name" :onChange="onChange" :id="item.key"></checkbox>

                </div>
            </div>

            <div class="row" v-if="hasDataPopulated" v-focus-first-input>

                <text-field id="web_hook" :label="trans('web_hook_url')" type="text" name="web_hook" :value="web_hook" :keyupListener="triggerEvent"
                    classname="col-sm-12" :onChange="onChange" :required="true" :hint="trans('enter_url_to_send_ticket_details')" placehold="https://www.example.com">

                </text-field>
            </div>

            <template #actions>

                <div class="card-footer">

                    <button class="btn btn-primary" type="button" :disabled="isLoading" @click="onSubmit">

                        <i class="fas fa-save"></i> {{ trans('submit')}}
                    </button>
                </div>
            </template>
        </faveo-box>
    </div>
</template>

<script>

    import axios from 'axios';

    import { errorHandler, successHandler } from "../../../../helpers/responseHandler";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import ToolTip from "../../../MiniComponent/ToolTip.vue";
    import Checkbox from "../../../MiniComponent/FormField/Checkbox.vue";
    import { validateWebhookData } from "../../../../helpers/validator/webHookSettings";

    export default {

        name: 'web-hook-settings',

        data () {

            return {

                web_hook: null,

                sources:[],

                checkbox_data:null,

                isLoading: true,

                hasDataPopulated : false
            }
        },

        beforeMount() {

            this.getValues();
        },

        methods: {

            getValues() {

                axios.get('/api/admin/get-webhook').then(response => {

                    this.isLoading = false;

                    this.web_hook = response.data.data.web_hook ? response.data.data.web_hook : '';
                    // assigning the sources value to checkbox_data.
                    this.checkbox_data = response.data.data.sources;

                    this.hasDataPopulated = true;
                    // Filter and map checked sources
                    this.sources = this.checkbox_data

                        .filter(item => item.is_checked)

                        .map(item => item.id);

                }).catch(error => {

                    this.hasDataPopulated = true;

                    this.isLoading = false;

                    errorHandler(error, 'web-hook-settings');
                })
            },

          isValid() {

            const { errors, isValid } = validateWebhookData(this.$data);

            if (!isValid) {

              return false;
            }
            return isValid;
          },

            onSubmit() {

              if(this.isValid()){

                this.isLoading = true;

                const data = {};

                data['web_hook'] = this.web_hook;
                //passing the payload as sources.
                data['sources'] = this.sources;

                axios.post('/api/admin/save-webhook', data ).then(response => {

                  this.isLoading = false;

                  successHandler(response, 'web-hook-settings');

                  this.$store.dispatch('unsetValidationError');

                  this.getValues();

                }).catch(error => {

                  this.isLoading = false;

                  errorHandler(error, 'web-hook-settings');
                })
              }

            },

            onChange(value, name) {

              this[name] = value;

              // If the name is not already in the sources list, add it.
              // If the value is empty or false:
              // Check if the name is in the sources list and remove it.

              if(name !== 'web_hook'){
                value ? !this.sources.includes(name) && this.sources.push(name) : this.sources.splice(this.sources.indexOf(name), 1);
              }
            },

          triggerEvent(event) {
            var key = event.which || event.keyCode;
            if (key === 13) { // 13 is enter
              this.onSubmit();
            }
          },
        },

        components: {
            'Checkbox': Checkbox,

            'text-field': TextField,

            "tool-tip": ToolTip,
        }
    };
</script>
<style>

.checkbox-label label{
    font-weight: 400 !important;
}

</style>
