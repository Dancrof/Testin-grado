<template>

  <!-- Display a loader while the data is being fetched -->
  <div v-if="isLoading" >

    <custom-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
  </div>

  <!-- Display plugin name and activation status if 'from' prop is 'name' -->
  <template v-if="from === 'name'">

    <!-- Display plugin name -->
    <p class="mb-0">{{details.display_name}}</p>

    <!-- Display activation status if license status is 1 -->
    <div v-if="details.license_status === 1" class="text-xs">

      <span class="badge" :class="details.status ? 'text-bg-success' : 'text-bg-danger'"
            v-tooltip="lang(details.status ? 'click_to_deactivate' : 'click_to_activate')">

      <a href="javascript:;" class="plugin_tags" @click="showActivationModal()">
        {{lang(details.status ? 'activated' : 'deactivated')}}
      </a>
    </span>
    </div>

    <!-- Modal for plugin activation -->
    <PluginActivationModal v-if="activeModal" :details="details" :show-modal="showActivationModal"
                           :containerStyle="{width:'500px'}" :onClose="onActiveClose"></PluginActivationModal>
  </template>

  <!-- Display plugin description, version, and details link if 'from' prop is 'description' -->
  <template v-if="from === 'description'">

    <!-- Display plugin description -->
    <p class="mb-0">
      {{details.description}}
    </p>

    <!-- Display plugin version and details link -->
    <span class="text-muted">

      <a>{{lang('version') + ' ' + details.version}}</a> <span v-if="!whiteLabel && details.website">{{'|'+ lang('by')}}

      <a :href="'http://'+details.website" target="_blank">{{'Faveo'}}</a></span>

      <!-- Link to display plugin details -->
      <span v-if="!whiteLabel">{{' | '}}</span>
      <a v-if="!whiteLabel" href="javascript:;"  @click="showDetailsModal(details.path)">{{lang('Plugin_details')}}</a>

    </span>

    <!-- Display a warning message if there is a license message -->
    <div v-if="licenseMessage" class="update-warning p-2 mt-2">

    <span class="text-sm">

       <!-- Display an icon based on the license status -->
      <i :class="iconClass"></i>{{licenseMessage}}

      <!-- Display the plugin name -->
      <b>{{details.display_name}}</b>

      <template v-if="licenseAction">

         <!-- The link triggers the license action when clicked -->
        <a class="text-primary ps-1 pe-2" @click="licenseAction.action" href="javascript:;"><u>{{licenseAction.text}}</u> </a>
      </template>
    </span>
    </div>

    <!-- Display the PluginUpdateModal if showUpdateModal is true -->
    <PluginUpdateModal v-if="showUpdateModal" :data="pluginDetails" :show-modal="showUpdateModal" from="plugin_list"
                       :containerStyle="{width:'800px'}" :onClose="closeUpdateModal"></PluginUpdateModal>

    <!-- Display the PluginDetailModal if detailsModal is true -->
    <PluginDetailModal v-if="detailsModal" :data="details" :show-modal="detailsModal" from="plugin_list"
                       :onClose="onDetailsClose" :whiteLable="whiteLabel" alertComponentName="dataTableModal"></PluginDetailModal>

  </template>

</template>

<script setup>

import {ref, onBeforeMount, watch, computed} from "vue";
import {errorHandler, successHandler} from "../../../helpers/responseHandler";
import {lang} from '../../../helpers/extraLogics';
import axios from "axios";
import PluginDetailModal from "./pluginDetailModal.vue";
import PluginActivationModal from "./PluginActivationModal.vue";
import PluginUpdateModal from "./PluginUpdateModal.vue";

// Defining props for the component
const props = defineProps({
  data: { type: Object, default: {} },
  from: { type: String, default: '' },
  whiteLabel : { type : Boolean, default : false },
});

// Defining reactive variables
const details = ref({});
const detailsModal = ref(false);
const activeModal = ref(false);4
const showUpdateModal = ref(false);
const isLoading = ref(false);
const pluginDetails = ref({});

onBeforeMount(() => {
  // It sets the 'details' value to the 'data' prop
  details.value = props.data;
});

watch(() => props.data, (newVal) => {
  details.value = newVal;
});

// Open's the details modal
const showDetailsModal = () => {
  detailsModal.value = true;
};

// Open's the activation modal
const showActivationModal = () => {
  activeModal.value = true;
};

// Close's the details modal
const onDetailsClose = () => {
  detailsModal.value = false;
};

// Close's the activation modal
const onActiveClose = () => {
  activeModal.value = false;
};

// Close's the update modal
const closeUpdateModal = () => {
  showUpdateModal.value = false;
};

// Update's the plugin
const updatePlugin = (plugin) =>{
  pluginDetails.value = plugin;
  showUpdateModal.value = true;
};

// Computed property for the license message
const licenseMessage = computed(() => {
  // It returns a different message based on the 'license_status' value
  switch (details.value.license_status) {
    case 0:
      return lang('license_has_expired_for');
    case 1:
      if (details.value.is_update === 1) {
        return lang('there_is_a_new_version') + " " + details.value.latest_version + " " + lang('of');
      } else if (details.value.is_update === 2) {
        return lang('update_has_expired_new_version_available') + " " + details.value.latest_version + " " + lang('of');
      }else {
        return '';
      }
    case 2:
      return lang('license_not_activated_for');
    default:
      return '';
  }
});

// Computed property for the icon class
const iconClass = computed(() => {
  return details.value.license_status === 1 && details.value.is_update === 1 ? 'fas fa-refresh px-2' : 'fas fa-warning px-2';
});

// Computed property for the actions based on the license status
const licenseAction = computed(() => {
  if ((details.value.license_status === 0 || details.value.is_update === 2) && !props.whiteLabel) {
    return { action: () => window.open('https://billing.faveohelpdesk.com/my-orders', '_blank'), text: lang('renew') };
  } else if ((details.value.license_status === 1 && details.value.is_update === 1)) {
    return { action: () => updatePlugin(details.value), text: lang('update_now') };
  }
  return null;
});


</script>

<style scoped>

.plugin_tags {
  color: #fff;
}

.update-warning{
  background-color: #faf4bb;
  color: black;
  border-radius: 5px;
  max-width: 600px;
}

</style>