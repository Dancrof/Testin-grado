<template>
  <transition v-if="showModal" name="modal">
    <div class="modal-mask" :class="{rtl : isRtlLayout}">
      <div class="modal-wrapper">
        <div class="modal-container">
          <div class="d-flex close-button">
            <button type="button" @click="onClose()" aria-label="Close" data-bs-dismiss="modal" :class="['btn-close mb-0 p-2', { 'ms-auto': appLanguage !== 'ar', 'me-auto': appLanguage === 'ar' }]">
            </button>
          </div>
          <div v-if="!loading" class="modal-body pt-0">
            <div class="row image-container">
              <div class="col-sm-12 bg-image px-1">

                <!-- Image URL based on the plugin details, and product details-->
                <img :src="imageUrl" @error="setDefaultImage" height="100" class="w-100" alt="pluginLogo">
                <h4 v-if="productDetails && productDetails.name" class="plugin-title">{{productDetails.display_name ? productDetails.display_name : productDetails.name }}</h4>
              </div>
            </div>
            <div class="row px-3 pt-3">
              <div class="col-md-12 p-0">
                <div class="card-outline row">
                  <div :class="releaseDetails ? 'col-md-8' : 'col-md-12'">
                    <ul class="nav nav-tabs updateDetails" role="tablist">
                      <li class="nav-item" v-for="(tab, index) in tabs" :key="index">
                        <a class="nav-link" :class="{ active: activeTab === index }" @click="selectTab(index)" href="javascript:;" role="tab">
                          <b>{{ lang(tab.label) }}</b>
                        </a>
                      </li>
                    </ul>
                    <!-- Tab Content -->
                    <div class="tab-content">
                      <div v-for="(tab, index) in tabs" :key="index" class="tab-pane fade" :class="{ 'show active': activeTab === index }" role="tabpanel">
                        <br />
                        <div v-html="tab.content"></div>
                      </div>
                    </div>
                  </div>
                  <div v-if="releaseDetails" class="col-md-4 p-3 version-details">
                    <p v-if="releaseDetails.version"><strong>{{lang('version')}}:</strong> {{releaseDetails.version}}</p>
                    <p v-if="releaseDetails.updated_at"><strong>{{lang('last_updated')}}:</strong> {{timeDiffForPast(releaseDetails.updated_at)}}</p>
                    <p v-if="releaseDetails.dependencies && releaseDetails.dependencies.extensions && releaseDetails.dependencies.extensions.required">
                      <strong>{{lang('extension_required')}}:</strong>
                      <span v-for="(item, index) in releaseDetails.dependencies.extensions.required" :key="index">
                            {{' '+item }}<span v-if="index < releaseDetails.dependencies.extensions.required.length - 1">,</span><span v-else>.</span>
                      </span>
                    </p>
                    <p v-if="releaseDetails.dependencies && releaseDetails.dependencies.extensions && releaseDetails.dependencies.extensions.optional">
                      <strong>{{lang('extension_optional')}}:</strong>
                      <span v-for="(item, index) in releaseDetails.dependencies.extensions.optional" :key="index">
                        {{' '+item }}<span v-if="index < releaseDetails.dependencies.extensions.optional.length - 1">,</span><span v-else>.</span>
                      </span>
                    </p>
                    <p v-if="releaseDetails.dependencies && releaseDetails.dependencies.min_php_version">
                      <strong>{{lang('minimum_php_version')}}:</strong> {{releaseDetails.dependencies.min_php_version}}
                    </p>
                    <p v-if="releaseDetails.dependencies">
                      <strong>{{lang('mySql_version')}}:</strong> <br>{{lang('min_size') + releaseDetails.dependencies.min_mysql_version[1]}} - {{ lang('max_size') + releaseDetails.dependencies.max_mysql_version[1]}}
                    </p>
                    <p v-if="releaseDetails.dependencies && releaseDetails.dependencies.min_mariadb_version">
                      <strong>{{lang('mariaDb_version')}}:</strong> <br> {{lang('min_size') + releaseDetails.dependencies.min_mariadb_version[1]}} - {{ lang('max_size') + releaseDetails.dependencies.max_mariadb_version[1]}}
                    </p>
                    <template v-if="releaseDetails.dependencies && releaseDetails.dependencies.plugin_dependencies">
                      <p class="mb-1"><strong>{{lang('plugin_dependencies')}}:</strong></p>
                      <template v-if="releaseDetails.dependencies.plugin_dependencies && releaseDetails.dependencies.plugin_dependencies.required_product && releaseDetails.dependencies.plugin_dependencies.required_product.length > 0">
                        <p v-if="hasProductDetails" class="mb-1"><strong>{{lang('required_product')}}:</strong></p>
                        <ul v-if="hasProductDetails">
                          <li v-for="item in releaseDetails.dependencies.plugin_dependencies.required_product" :key="item.name">
                            <template v-if="item.name"><strong>{{lang('name')}}:</strong> {{ item.name }}<br></template>
                            <template v-if="item.min_version"><strong>{{lang('min_version')}}:</strong> {{ item.min_version }}<br></template>
                            <template v-if="item.max_version"><strong>{{lang('max_version')}}:</strong> {{ item.max_version }}<br></template>
                          </li>
                        </ul>
                      </template>

                      <template v-if="releaseDetails.dependencies.plugin_dependencies && releaseDetails.dependencies.plugin_dependencies.plugin_required && releaseDetails.dependencies.plugin_dependencies.plugin_required.length > 0">
                        <p v-if="hasPluginDetails" class="mb-1"><strong>{{lang('required_plugins')}}:</strong></p>
                        <ul v-if="hasPluginDetails">
                          <li v-for="item in releaseDetails.dependencies.plugin_dependencies.plugin_required" :key="item.name">
                            <template v-if="item.name"><strong>{{lang('name')}}:</strong> {{ item.name }}<br></template>
                            <template v-if="item.min_version"><strong>{{lang('min_version')}}:</strong> {{ item.min_version }}<br></template>
                            <template v-if="item.max_version"><strong>{{lang('max_version')}}:</strong> {{ item.max_version }}<br></template>
                          </li>
                        </ul>
                      </template>

                      <template v-if="releaseDetails.dependencies?.plugin_dependencies?.plugin_optional?.length > 0 && hasOptionalPluginDetails">
                        <p class="mb-1"><strong>{{lang('plugin_optional')}}:</strong></p>
                        <ul>
                          <li v-for="item in releaseDetails.dependencies.plugin_dependencies.plugin_optional" :key="item.name">
                            <template v-if="item.name"><strong>{{lang('name')}}:</strong> {{ item.name }}<br></template>
                            <template v-if="item.min_version"><strong>{{lang('min_version')}}:</strong> {{ item.min_version }}<br></template>
                            <template v-if="item.max_version"><strong>{{lang('max_version')}}:</strong> {{ item.max_version }}<br></template>
                          </li>
                        </ul>
                      </template>
                    </template>
                    <p><a href="https://www.faveohelpdesk.com/" target="_blank">{{lang(whiteLabel ? 'about_helpdesk' : 'about_faveo_helpdesk')}}<i class="fa fa-angle-right px-1"></i></a></p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row" v-if="loading">
            <custom-loader :duration="4000"></custom-loader>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup>

import {ref, onBeforeMount, computed} from "vue";
import {errorHandler} from "../../../helpers/responseHandler";
import axios from "axios";
import {useStore} from 'vuex';
import globalMixin from "../../../mixins/globalMixin";
import {lang} from '../../../helpers/extraLogics'

const { basePathVersion } = globalMixin.methods;

// Defining props for the component
const props = defineProps({

  data:{ type: Object, required: true },
  showModal:{ type: Boolean, required: true },
  onClose:{ type: Function },
  alertComponentName : { type : String, required: true },
  whiteLabel : { type : Boolean, default : false },
  from: { type: String, default: '' }
})

// Reactive variables
const store = useStore();
const pluginDetails = ref({});
const loading = ref(false);
const details = ref({});
const alert = ref('');
const productDetails = ref({});
const releaseDetails = ref({});

const activeTab = ref(0);
const tabs = ref( []);

const defaultImageUrl = ref('/themes/default/common/images/plugin_banner/Plugin_1.png'); // Default image URL
const basePathWithVersion = ref(basePathVersion()); // Base path with version
const imageUrl = ref(getImageUrl()); // Image URL based on the plugin details, and product details

// Generates the URL for the image based on the plugin details and product details.
function getImageUrl() {
  return props.from === 'plugin_list'
      ? `${basePathWithVersion.value}/themes/default/common/images/plugin_banner/${props.data.path}.png`
      : props.whiteLabel
          ? `${basePathWithVersion.value}/themes/default/common/images/helpdesk_product.png`
          : `${basePathWithVersion.value}/themes/default/common/images/faveo_product.png`;
}

// Sets the default image URL when the original image fails to load.
function setDefaultImage(event) {
  event.target.src = basePathWithVersion.value + defaultImageUrl.value;
}

// Computed property for time difference
const timeDiffForPast = computed(()=>store.getters.timeDiffForPast);

// When the component is mounted, set the plugin details and get the plugin details
onBeforeMount(() => {
  details.value = props.data;
  alert.value = props.alertComponentName;
  getPluginDetails();
})

// Get's the plugin details
const getPluginDetails = () => {

  loading.value = true;

  // Determine the version to use based on whether it is an update or not
  let version = details.value.is_update === 1 ? details.value.latest_version : details.value.version;
  // Construct the API URL for fetching plugin details, prepending 'v' if necessary
  let pluginDetailsApiURL = `plugin/release?product_id=${details.value.id}&version=${version.startsWith('v') ? version : 'v' + version}`;
  // Construct the API URL for fetching product update details, prepending 'v' if necessary
  let productUpdateURL = `plugin/release?version=${details.value.version.startsWith('v') ? details.value.version : 'v' + details.value.version}`;

  let apiUrl = props.from === 'plugin_list'? pluginDetailsApiURL : productUpdateURL;

  axios.get(apiUrl)
      .then((res) => {
        // On successful response, set the release details and hide the loader
        pluginDetails.value = res.data.data;
        productDetails.value = pluginDetails.value.product;
        releaseDetails.value = pluginDetails.value.release;
        tabs.value = [
          {id: 'description', label: 'description', content:  (productDetails.value !== null && productDetails.value.product_description !== "") ? productDetails.value.product_description: lang('no_plugin_description')},
          {id: 'change_logs', label: props.from === 'plugin_list' ? 'change_log' : 'release_notes', content:  (releaseDetails.value !== null && releaseDetails.value.description !== '') ? releaseDetails.value.description: lang('no_release_details')},
        ];
        loading.value = false;
      })
      .catch((err) => {
        // On error response, display an error message
        loading.value = false;
        props.onClose();
        errorHandler(err,alert.value);
      })
};

const selectTab = (index) =>{
  activeTab.value = index;
};

// Computed properties to check if the plugin has plugin details or not
const hasPluginDetails = computed(() => {
  const pluginRequired = releaseDetails.value.dependencies.plugin_dependencies.plugin_required;
  return pluginRequired.some(plugin => plugin.name || plugin.min_version || plugin.max_version);
});

// Computed properties to check if the plugin has product details or not
const hasProductDetails = computed(() => {
  const requiredProduct = releaseDetails.value.dependencies.plugin_dependencies.required_product;
  return requiredProduct.some(product => product.name || product.min_version || product.max_version);
});

// Computed properties to check if the plugin has product details or not
const hasOptionalPluginDetails = computed(() => {
  const requiredProduct = releaseDetails.value.dependencies.plugin_dependencies.plugin_optional;
  return requiredProduct.some(product => product.name || product.min_version || product.max_version);
});

</script>

<style scoped>
#plugin_modal_close{
  padding: 10px;
}

.close-button {
  z-index: 1060; /* Ensure the close button is above the modal body */
  position: relative; /* Ensure it is positioned correctly */
}

.modal-container{
  max-height: 800px !important;
  min-height: 500px !important;
  width: 800px !important;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  margin: 0px auto;
  background-color: #fff;
  border-radius: 0.25rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.5s ease !important;
  color: #444 !important;
}

@media (max-width: 900px) {
  .modal-container {
    width: 600px !important;
    max-height: 800px !important;
    min-height: 500px !important;
    overflow-y: auto;
  }
}

@media (max-width: 600px) {
  .modal-container {
    width: 400px !important;
    max-height: 800px !important;
    min-height: 500px !important;
    overflow-y: auto;
  }
}

.version-details{
  background-color: #f4f4f4;
}

.updateDetails{
  background-color: #f4f4f4;
}

.image-container{
  width: 100%;
  text-align: center;
  margin-left: 0;
}

.plugin-title {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  margin-top: 10px;
}

</style>