<template>

  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

    <template #title>

      <h4 class="modal-title">{{lang('change_status_confirmation') +' '+status.name+ '?'}}</h4>
    </template>

    <template #alert>
      <!-- Alert component for displaying messages related to the ticket change status modal -->
      <alert componentName="ticket-change-status-modal"/>
    </template>

    <template #fields>

        <div class="row" v-focus-first-input>

          <strong  v-if="label" class="ms-1 p-1">{{ lang(status.comment ? 'leave_comment_status_change_required' : 'leave_comment_status_change_optional') }}<span class="is-danger" v-if="status.comment">*</span></strong>

          <tiny-editor-with-validation id="commnetValue"
                                       name="commnetValue"
                                       :value="commnetValue"
                                       :label="lang(status.comment ? 'leave_comment_status_change_required' : 'leave_comment_status_change_optional')"
                                       :onChange="onChange"
                                       :required="status.comment ? true : false"
                                       :mediaOption="false"
                                       classname="col-sm-12">
          </tiny-editor-with-validation>
        </div>

        <div class="col-sm-12">

            <input class="checkbox_align" type="checkbox" v-model="checked">&nbsp;{{lang('post_comment_as_reply')}}
      </div>

        <custom-loader v-if="loading" :duration="4000" />

    </template>

    <template #controls>

      <button id="submit_btn" type="button" @click="validate()" class="btn btn-primary" :disabled="isDisabled">

        <i class="fa fa-check" aria-hidden="true"></i> {{lang('proceed')}}
      </button>
    </template>
  </modal>
</template>

<script type="text/javascript">

import {errorHandler,successHandler} from "../../../helpers/responseHandler";

import {validateChangeStatusSettings} from "../../../helpers/validator/changeStatusSettingsRules.js"

import axios from 'axios'
import TextField from "../../MiniComponent/FormField/TextField.vue";

export default {

  name : 'change-status-modal',

  description : 'Change status Modal component',

  props:{

    showModal:{type:Boolean,default:false},

    ticketIds : { type : Array, default : ()=>[]},

    status : { type : Object, default : ()=>{}},

    onClose:{type: Function, default : ()=>{}},

    componentTitle : { type : String, default :'UserTickets'},

    reloadTickets : { type : Function, default: () => {} },

    label: { type: Boolean, default: false },
  },

  data:()=>({

    isDisabled:false,

    containerStyle: {width: '800px'},

    loading:false,

    commnetValue : '',

    checked : false
  }),

  methods:{

    isValid(){

      const {errors, isValid} = validateChangeStatusSettings(this.$data);

      if(!isValid){

        return false
      }

      return true
    },

    validate() {

      if(this.status.comment){

        if(this.isValid()){

          this.onSubmit()
        }
      } else {
        this.onSubmit()
      }
    },

    onSubmit(){

      // Set loading and disable state to true to prevent multiple submissions
      this.loading = true

      this.isDisabled = true

      const uniqueKey = Date.now().toString(); // Generate a unique key based on the current timestamp

      // Make an API call to change the ticket status
      axios.post('/ticket/change-status/'+this.ticketIds+'/'+this.status.id,
          {
            'comment': this.commnetValue, // Include the comment value
            'as-reply': this.checked, // Include the reply status
            'uniqueKey': uniqueKey // Pass the unique key to the backend to prevent duplicate submissions
          }).then(res=>{

        // On success, reset loading and disable state
        this.loading = false;
        this.isDisabled = true;

        // Reload the tickets with the new status
        this.reloadTickets('status');

        // Handle success response
        successHandler(res,this.componentTitle);

        // Emit events to refresh data and uncheck checkboxes
        window.emitter.emit(this.componentTitle+'refreshData');

        window.emitter.emit(this.componentTitle+'uncheckCheckbox');

        window.emitter.emit('refreshUserReport')

        window.emitter.emit('refreshOrgReport')

        this.onClose(); // Close the modal

      }).catch(err => {

        // On error, reset loading and disable state
        this.loading = false;

        this.isDisabled = false

        // Handle specific error case for inbox or timeline components
        if((this.componentTitle === 'inbox' || this.componentTitle === 'timeline') && err.response.status === 302){

            this.onClose();

            window.emitter.emit('showEditTicketModal'+this.componentTitle, 'status');

            this.$store.dispatch('setAlert', {
              type: 'danger',
              message: err.response.data.message,
              component_name: 'faveo-form'
            })
        }else{
          // Handle general error response
          errorHandler(err,this.componentTitle);
          this.onClose();
        }
      })
    },

    onChange(value, name){

      this[name]= value;
    },
  },

  components:{

    'text-field': TextField,
  }
};
</script>

<style scoped>
.label_align1 {

  display: block; padding-left: 10px; text-indent: -15px; font-weight: 500 !important; padding-top: 0px;
}
.checkbox_align {
  display:inline !important;width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative;
  top: -4px; overflow: hidden;
}
</style>

<style>
#commnetValue .tox-tinymce:not(.tox-fullscreen){
  max-height: 300px!important;
}
</style>