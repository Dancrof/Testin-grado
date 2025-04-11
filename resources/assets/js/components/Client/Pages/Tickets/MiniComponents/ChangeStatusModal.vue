<template>

  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

    <template #title>

      <h4 class="modal-title">{{lang('change_status')}}</h4>
    </template>

    <template #fields>

      <div v-if="!loading">

        <span v-if="ticketIds.length > 0">{{lang('change-status-confirmation') +status.name+ ' ?'}}</span>

        <span v-else>{{lang('select-ticket')}}</span>

      </div>

      <div v-if="loading" class="row">

        <reuse-loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
      </div>
    </template>

    <template #controls v-if="ticketIds.length > 0">

      <button id="client_status_action" type="button" @click="onSubmit()" class="btn btn-custom float-end" :disabled="isDisabled"
              :style="buttonStyle">

        <i class="fas fa-check" aria-hidden="true"></i> {{lang('proceed')}}
      </button>
    </template>
  </modal>
</template>

<script>

import {errorHandler, successHandler} from '../../../../../helpers/responseHandler'

import axios from 'axios'
import Modal from "../../../../Common/Modal.vue";
export default {

  name : 'change-status-modal',

  description : 'Change status Modal component',

  props:{

    showModal:{type:Boolean,default:false},

    ticketIds : { type : Array, default : ()=>[]},

    status : { type : Object, default : ()=>{}},

    onClose:{type: Function},

    layout : { type : Object, default : ()=>{}}
  },

  data(){

    return {

      panel: 'client',

      isDisabled:false,

      containerStyle:{ width:'500px'},

      loading:false,

      buttonStyle : {

        borderColor : this.layout.portal.client_button_border_color,
        color : this.layout.portal.client_button_font_color + ' !important',
        backgroundColor : this.layout.portal.client_button_color
      },
    }
  },

  methods:{

    onSubmit(){

      this.loading = true

      this.isDisabled = true

      this.$Progress.start();

      const data = {}

      data['panel'] = this.panel;

      axios.post('api/ticket/change-status/' +this.ticketIds+'/'+this.status.id, data).then(res=> {

        this.$Progress.finish();

        this.loading = false;

        this.isDisabled = true

        window.emitter.emit('refreshData');

        window.emitter.emit('updateTicketCount');

        window.emitter.emit('uncheckCheckbox')

        this.onClose();

        successHandler(res,'dataTableModal');

      }).catch(error=>{

        this.loading = false;

        this.isDisabled = false

        errorHandler(error,'dataTableModal')

        this.onClose();

        this.$Progress.fail();
      })
    },
  },

  components:{

    'modal':Modal
  }
};
</script>