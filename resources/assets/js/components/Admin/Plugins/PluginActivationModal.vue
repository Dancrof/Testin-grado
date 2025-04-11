<template>

  <!-- Modal that shows when showModal is true -->
  <modal v-if="showModal" :showModal="true" :onClose="onClose" :containerStyle="containerStyle">

    <template #title>

      <!-- Modal title, changes based on the status of the plugin -->
      <h4 class="modal-title">{{lang(details.status ? 'deactivate': 'active')}}</h4>
    </template>

    <template #fields>

      <!-- Modal body, changes based on the status of the plugin -->

        <p v-if="!details.status" v-html="lang('Click_to_activate_plugin')+[details.display_name]"></p>
        <p v-else v-html="lang('Click_to_deactivate_plugin')+[details.display_name]"></p>

      <!-- Show loader when loading is true -->
      <div v-if="loading" slot="fields" >

        <loader :animation-duration="4000" color="#1d78ff" :size="60"/>
      </div>
    </template>

    <!-- Modal controls, button to activate/deactivate the plugin -->
    <template #controls>

      <button type="button" @click = "onSubmit(details.path)" :class="details.status ? 'btn btn-danger' : 'btn btn-primary'">

        <i class="fa fa-gear" aria-hidden="true"></i>

        {{lang(details.status ? 'deactivate': 'activate')}}
      </button>
    </template>
  </modal>
</template>

<script setup>

import {ref} from "vue";
import axios from "axios";
import {errorHandler, successHandler} from "../../../helpers/responseHandler";

// Defining props for the component
const props = defineProps({
  details: { type: Object, required: true },
  showModal: { type: Boolean, required: true },
  onClose: { type: Function },
  containerStyle: { type: Object, default: {width:'500px'} }
});

const loading = ref(false);

// Handle's the submission of the form
const onSubmit = (name) => {

  loading.value = true;

  axios.post('plugin/status/'+name)
      .then((res) => {
        successHandler(res,'dataTableModal');
        loading.value = false;
        setTimeout(()=>{
          // Emit events to refresh data and update side navigation
          window.emitter.emit('refreshData');
          window.emitter.emit('updateSideNav');
        },10);

        if(!props.details.status){
          location.reload();
        }
      })
      .catch((err) => {
        // Handle error response
        loading.value = false;
        props.onClose();
        errorHandler(err,'dataTableModal');
      })
};

</script>

<style scoped>

</style>