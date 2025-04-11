<template>

  <!-- Modal for plugin update -->
  <modal v-if="showModal" :showCloseBtn="confirmUpdate ? false : true" :showIconCloseBtn="false" :showModal="true" :showControls="confirmUpdate ? false : true" :onClose="onClose" :containerStyle="containerStyle">

    <!-- Modal title -->
    <template #title>
      <h3 class="modal-title">{{lang('plugin_update')}}</h3>
    </template>

    <!-- Alert section -->
    <template #alert>
      <alert componentName="plugin-update"></alert>
    </template>

    <template #fields>
      <!-- Information about the update process -->

      <div class="pb-4" v-if="confirmUpdate">
        <div>
          <h6>{{lang('plugin_update_in_process')}}</h6>
        </div>
        <!-- Loader displayed during the update process -->
        <div v-if="showLoader" class="loader-container">
          <i class="fas fa-spinner fa-pulse loader-icon"></i>
        </div>
      </div>

      <div v-else>
        <h6>{{lang('are_you_sure_want_to_update_plugin') + data.display_name + lang(' plugin?')}}</h6>
      </div>
    </template>


    <template v-if="!confirmUpdate" #controls>
      <!-- Button to confirm the update -->
      <button @click="confirmUpdate = true" class="btn btn-primary"><i class="fas fa-circle-up pe-1"></i>{{lang('update')}}</button>
    </template>

  </modal>

</template>

<script setup>

import {ref, watch} from "vue";
import {successHandler, errorHandler} from "../../../helpers/responseHandler";
import axios from "axios";
import { useStore } from 'vuex';

// Defining props for the component
const props = defineProps({
  data:{ type: Object, required: true },
  showModal:{ type: Boolean, required: true },
  onClose:{ type: Function },
  containerStyle:{ type: Object, default: {width:'800px'} },
  from: { type: String, default: '' }
})

// Initialize the store
const store = useStore();

// Reactive variables

const confirmUpdate = ref(false);

const showLoader = ref(false);

// Function to update the database when the component is mounted

watch(() => confirmUpdate.value, (newVal) => {
  if(newVal){
    updatePlugin(props.data);
  }
});


 // Updates the plugin and handles the update process.
const updatePlugin = async (plugin) => {
  // Show the loader during the update process
  showLoader.value = true;

  try {
    // Send a POST request to update the plugin
    const res = await axios.post('plugin/update', { plugin: plugin.path });

    // Handle the success response
    successHandler(res, 'plugin-update');

    // Emit an event to refresh data based on the source of the update
    props.from === 'plugin_list' ? window.emitter.emit('refreshData') : window.emitter.emit('refreshUpdateList');

    // Close the modal and reset the state after a delay
    await closeAndUpdateReset(3000);
  } catch (err) {
    // Dispatch an alert action in case of an error
    await store.dispatch('setAlert', {
      type: 'danger',
      duration: 10000,
      message: err.response.data.message,
      component_name: 'plugin-update'
    });

    // Close the modal and reset the state after a delay
    await closeAndUpdateReset(10000);
  }
};


 // Closes the modal and resets the state after a specified timeout.
const closeAndUpdateReset = (timeOut) => {
  return new Promise((resolve) => {
    setTimeout(() => {
      // Call the onClose function passed as a prop
      props.onClose();

      // Hide the loader and reset the confirmUpdate state
      showLoader.value = false;
      confirmUpdate.value = false;

      // Resolve the promise
      resolve();
    }, timeOut);
  });
};

</script>


<style scoped>

.loader-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 70px;
}

.loader-icon{
  font-size: 45px;
}

</style>