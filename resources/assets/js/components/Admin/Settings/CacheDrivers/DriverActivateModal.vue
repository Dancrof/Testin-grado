<template>
  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

    <template #title>
      <!-- Title section -->
      <h4 class="modal-title">{{trans('activate')}}</h4>
    </template>
    <!-- Fields/content section -->
    <template #fields>

      <div v-if="!loading">

        <span>{{trans('are_you_sure')}}</span>
      </div>

      <div v-if="loading" class="row" >

        <reuse-loader :animation-duration="4000" :size="60"/>
      </div>
    </template>
    <!-- Controls section -->
    <template #controls>

      <button  type="button" @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">

        <i class="fas fa-check"></i> {{trans('activate')}}
      </button>
    </template>
  </modal>
</template>

<script>

import {errorHandler,successHandler} from "../../../../helpers/responseHandler";

import axios from 'axios'
export default {
  name: "DriverActivateModal",

  props : {

    showModal : { type : Boolean, default : false },
    // Driver identifier
    driver : { type : [String, Number], default : '' },
    // Function to close the modal
    onClose : { type : Function },
  },

  data(){

    return {

      isDisabled:false,

      containerStyle:{ width:'600px' },

      loading:false,
    }
  },

  methods:{

    onSubmit(){

      this.loading = true

      this.isDisabled = true // Disable the button while submitting

      axios.post('api/post/cache-driver',{
        'default': this.driver
      }).then(res=>{

        window.emitter.emit('DriverIndexrefreshData');  // Emit an event for data refresh

        successHandler(res,'dataTableModal')

        this.loading = false;

        this.isDisabled = false;

        this.onClose(); // Close the modal

      }).catch(err => {

        this.loading = false;

        this.isDisabled = false;

        errorHandler(err,'dataTableModal');

        this.onClose(); // Close the modal
      })
    }
  }
}
</script>