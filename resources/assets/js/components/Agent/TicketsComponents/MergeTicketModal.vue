<template>

  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

    <template #title>

      <h4 class="modal-title">{{lang('merge-ticket')}}</h4>
    </template>

    <template #fields>

      <div v-if="!loading">

        <div class="row">

            <dynamic-select :api-parameters="getApiParameters" optionLabel="title"
                :label="lang('select-pparent-ticket')" :hint="trans('parent_ticket_tooltip_merge')"  :required="true"
                name="parentTicket"  classname="col-sm-6" api-endpoint="/api/agent/tickets/get-merge-tickets"
                :value="parentTicket" :onChange="onChange" strlength="25">

            </dynamic-select>

          <text-field :label="lang('subject')" :value="title" type="text" name="title"
                      :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6" :required="true">
          </text-field>
        </div>

        <div class="row">

          <text-field :label="lang('merge-reason')" :value="merge_reason" type="textarea" name="merge_reason"
                      :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-12">
          </text-field>
        </div>

        <div class="row">

          <div class="col-sm-6">

            <checkbox id="mergerTickets_CC" name="mergerTickets_CC" :value="mergerTickets_CC" :label="trans('tickets_recipients_to_cc')"
                      :onChange="onChange" classname="col-sm-12">
            </checkbox>
          </div>
        </div>
      </div>

      <div v-if="loading" class="row">

        <reuse-loader :animation-duration="4000" color="#1d78ff" :size="size" :class="{spin: lang_locale == 'ar'}" />
      </div>
    </template>

    <template #controls>
      <button type="button" id="submit_btn" @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">

        <i class="fa fa-check"></i> {{lang('proceed')}}
      </button>
    </template>
  </modal>
</template>

<script>

import {validateMergeTicketSettings} from "../../../helpers/validator/mergeTicketSettingRules"

import {errorHandler,successHandler} from "../../../helpers/responseHandler";

import axios from 'axios'
import TextField from "../../MiniComponent/FormField/TextField.vue";
import StaticSelect from "../../MiniComponent/FormField/StaticSelect.vue";
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
import Checkbox from "../../MiniComponent/FormField/Checkbox.vue";

export default {

  name : 'merge-ticket-modal',

  description : 'Merge Ticket Modal component',

  props:{

    showModal:{type:Boolean,default:false},

    parent_tickets : { type : Array, default : ()=>[] },

    ticketIds : { type : Array, default : ()=>[] },

    onClose:{type: Function, default : ()=>{}},

    componentTitle : { type : String, default :'UserTickets'},

    reloadTickets : { type : Function, default: () => {} }
  },

  data:()=>({

    isDisabled:false,

    containerStyle:{
      width:'840px'
    },

    loading:false,

    size: 60,

    lang_locale:'',

    merge_reason : '',

    title : '',

    parentTicket : '',

    mergerTickets_CC : false,
  }),

  created(){

    this.lang_locale = localStorage.getItem('LANGUAGE');
  },

    computed : {

        getApiParameters(){

            return { 'ticket-ids': this.ticketIds };
        },
    },

  methods:{

    isValid(){

      const {errors, isValid} = validateMergeTicketSettings(this.$data)

      if(!isValid){

        return false
      }

      return true
    },

    onChange(value, name) {

        if(name === 'parentTicket') {

            this.title = value.name;

            this.parentTicket = value;

        } else {

            this[name] = value;
        }
    },

    onSubmit(){

      if(this.isValid()){

        this.loading = true

        this.isDisabled = true

        const p_id = this.parentTicket ? this.parentTicket.ticket_id : null;

        axios.post('/merge-tickets/'+this.ticketIds,{ p_id, title:this.title, reason:this.merge_reason, mergerTickets_CC : this.mergerTickets_CC, '_method':'PATCH' }).then(res=>{

          this.loading = false;

          this.isDisabled = true

          this.reloadTickets();

          successHandler(res,this.componentTitle);

          window.emitter.emit(this.componentTitle+'refreshData');

          window.emitter.emit(this.componentTitle+'uncheckCheckbox')

          window.emitter.emit('refreshUserReport')

          window.emitter.emit('refreshOrgReport')

          window.emitter.emit('closeTimelineView');

          this.onClose();

        }).catch(err => {

          this.loading = false;

          this.isDisabled = false

          errorHandler(err,this.componentTitle);

          this.onClose();
        })
      }
    },
  },

  components:{
    DynamicSelect,

    'text-field': TextField,

    "static-select": StaticSelect,

    'checkbox': Checkbox,
  }
};
</script>

<style scoped>

#mt_10 { margin-top: 15px; }
</style>