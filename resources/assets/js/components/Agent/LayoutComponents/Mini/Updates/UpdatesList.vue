<template>

  <!-- Main container -->
	<div class="col-sm-12">

    <div v-if="updateLoading" >
      <!-- Loader displayed while updates are being fetched -->
      <custom-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
    </div>

    <!-- Alert component for displaying alerts -->
		<alert componentName="SystemUpdates"></alert>

    <!-- Card for displaying application updates -->
		<div v-if="updatesData.length && latest != current" class="card card-light">

      <!-- Card header -->
      <div class="card-header">
        <h3 class="card-title">{{trans('application_updates')}}</h3>

        <!-- Card tools (refresh button) -->
        <div class="card-tools">

          <!-- Refresh button, disabled while data is being fetched -->
          <a v-if="!hasDataPopulated || loading"  class="btn btn-tool cursor-none" :class="!hasDataPopulated || loading ? 'rotating': ''" data-card-widget="refresh"
             v-tooltip="lang('refresh')">

            <i class="fas fa-sync-alt"></i>
          </a>
        </div>
      </div>

      <!-- Card body -->
      <div class="card-body">
        <div v-if="hasDataPopulated">

          <!-- Displayed if there is a new version available -->
          <template v-if="latest != current">

            <template v-if="updatesData.length">

              <div v-if="updateStatus == 'fails'" class="alert alert-warning">

                <!-- Warning message -->
                <i class="icon fas fa-exclamation-triangle"></i> {{trans(updateMsg)}}&nbsp;

                <!-- Link to renew the license, only displayed if whiteLabel is false -->
                <a :href="'https://billing.faveohelpdesk.com'" v-if = "!whiteLabel">{{trans('click-here-to-renew')}}</a>
              </div>

              <!-- If the update status is not 'fails', display an info message -->
              <div v-else class="error-page">

                <div class="error-content">

                  <h3 class="text-success custom-text-bg-success fw_500">

                    <i class="fas fa-info-circle"> </i>  {{trans(updateMsg)}}
                  </h3>
                </div>
              </div><br>

              <!-- If the update status is not 'fails', display the current and latest versions -->
              <template v-if="updateStatus != 'fails'">

                <div class="row center_align">

                  <!-- Card for displaying the current version -->
                  <div class="card bg-secondary text-white col-sm-3 prl-0 current_card">

                    <div class="card-header border_bottom_w">

                      <h4 class="text-center">{{trans('current_version')}}</h4>

                    </div>

                    <div class="card-body text-center">

                      <b class="fs-30">{{current}}</b>
                    </div>
                  </div>

                  <!-- Card for displaying the latest version -->
                  <div class="card bg-info custom-bg-info col-sm-3 prl-0 latest_card">

                    <div class="card-header border_bottom_w">

                      <h4 class="text-center">{{trans('latest_version')}}</h4>

                    </div>

                    <div class="card-body text-center">

                      <b class="fs-30">{{latest}}</b>
                    </div>
                  </div>
                </div>

                <!-- Button for triggering the update -->
                <div class="row center_align me-1">

                  <button type="button" class="btn btn-light upd_btn" @click="showModal = true">

                    <i class="fas fa-sync"></i> {{trans('update')}}
                  </button>

                  <button v-if="!whiteLabel" type="button" class="btn btn-light upd_btn" @click="showDetailsModal(latest_version, 'product_list')">

                    <i class="fas fa-circle-info text-muted"></i> {{trans('info')}}
                  </button>
                </div>

                <!-- Container for the 'Recent Versions' text -->
                <div class="row center_align text-center pt-3">
                  <p class="bg-transparent text-info text-primary text-sm cursor-pointer" @click="recentVersions()">
                    {{trans('recent_versions')}} <i class="fa fa-caret-down"></i>
                  </p>
                </div>
                <br>

              </template>

              <!-- Transition effect named 'fade' for the contained elements -->
              <transition name="fade">

                <!-- Display the version details if 'showVersion' is true -->
              <div v-if="showVersion" class="row">

                <div class="col-12 col-md-12 col-lg-12">

                  <div class="row">

                    <div class="col-12">

                      <!-- Loop through each 'update' in 'updatesData' -->
                      <template v-for="update in updatesData">

                        <!-- Display the update details if it's not private -->
                        <template  v-if="!update.is_private">

                          <div class="post clearfix">

                            <div class="user-block mb-1">

                              <i class="img-circle img-bordered img-tag-bordered fas fa-tag tag_align"></i>

                              <span class="username">

                                <!-- Display the version of the update -->
					                          		<a href="javascript:;">{{trans('version')}} {{update.version}}</a>
                                        <span v-if="!whiteLabel">
                                          <a v-tooltip="trans('Plugin_details')" href="javascript:;" @click="showDetailsModal(latest_version, 'product_list')" >
                                              <i class="fas fa-info-circle fa-sm text-muted ms-1"></i>
                                          </a>
                                        </span>

					                          		<span v-if="update.is_restricted" class="badge text-bg-warning restricted" v-tooltip="trans('update_restricted')">

																{{trans('restricted')}}
															</span>
					                        	</span>

                              <!-- Display the release date of the update -->
                              <span class="description">{{trans('released_on')}} - {{formattedTime(update.created_at)}}</span>
                            </div>
                            <!-- If 'whiteLabel' is false, display the update description -->
                            <p v-if="!whiteLabel" v-html="update.description" class="ml-3-1"></p>
                          </div>
                        </template>
                      </template>
                    </div>
                  </div>
                </div>
              </div>

            </transition>
            </template>
          </template>

          <template v-else>

            <span>{{trans('no_update_available')}}</span>
          </template>
        </div>
      </div>
		</div>

    <!-- Display the plugin updates section if updates are available -->
    <template v-if="pluginsDetails.length">

      <!-- Card for displaying plugin updates -->
      <div class="card card-light">

        <!-- Card header -->
        <div class="card-header">

          <h3 class="card-title">{{trans('plugin_updates')}}</h3>

          <!-- Card tools (refresh button) -->
          <div class="card-tools">

            <a v-if="!hasDataPopulated || loading"  class="btn btn-tool cursor-none" :class="!hasDataPopulated || loading ? 'rotating': ''"
               data-card-widget="refresh" v-tooltip="trans('refresh')">

              <i class="fas fa-sync-alt"></i>
            </a>
          </div>
        </div>

        <div class="card-body">

          <div v-if="hasDataPopulated">

            <template v-if="pluginsDetails.length">

              <div class="row pb-3 ps-2">
                <div class="col-md-12">

                  <!-- Pagination component for the plugin updates -->
                  <per-page v-if="perpage" :perpage="perpage" v-on:ticketCount="handlePageCount"> </per-page>

                    <!-- Button for triggering the update of all selected plugins -->
                    <button v-if="selectedPlugin.length" @click="updateAllPlugin()" class="btn btn-light ms-2">
                      <i class="fas fa-sync-alt"></i> {{trans('update_plugin')}}

                    </button>

                </div>
              </div>


              <div class="col-md-12 col-sm-12 col-12">

                <table id="example1" class="table table-bordered dataTable no-footer">

                  <thead>

                  <tr>

                    <th class="sorting_disabled">

                      <div class="d-flex">

                        <div class="form-check">

                          <!-- Checkbox for selecting/deselecting all plugins. -->
                          <input type="checkbox" class="form-check-input focus-remove" id="customSwitch1" v-model="selectAll" @click="toggleSelectAll()">

                          <label class="form-check-label" for="customSwitch1"></label>
                        </div>
                        <!-- Text for selecting/deselecting all plugins. -->
                        <p @click="toggleSelectAll()" class="px-3 cursor-pointer">{{trans(selectedPlugin.length === pluginsDetails.length ? 'deselect_all' : 'select_all')}}</p>
                      </div>
                    </th>
                  </tr>
                  </thead>
                  <tbody>

                  <!-- Loop through each plugin in 'pluginsDetails' -->
                  <tr v-for="plugin in pluginsDetails">

                    <td class="pb-0">

                      <div class="row ps-2">

                        <div class="px-1 col-lg-1 col-sm-2 d-flex">

                          <!-- Checkbox for selecting the plugin -->
                          <div class="form-check">

                            <input type="checkbox" class="form-check-input focus-remove" id="customSwitch3" v-model="selectedPlugin" :value="plugin.path" :disabled="plugin.is_update !== 1">

                            <label class="form-check-label" for="customSwitch3"></label>
                          </div>
                          <!-- Container for the plugin icon -->
                          <div class="ps-3 plugin-icon-container">

                            <div class="fa-stack fa-1x resize-icon">

                              <i class="fa-2x text-secondary" :class="plugin.icon  ? plugin.icon : 'fas fa-plug'"></i>
                            </div>
                          </div>
                        </div>


                        <div class="col-lg-9 col-sm-8">

                          <!-- Display the plugin name -->
                         <span class="plugin-name text-secondary"><b>{{plugin.display_name}}</b></span>

                          <!-- Display the plugin description -->
                          <p class="text-sm text-secondary mb-0">{{plugin.description}}</p>

                          <!-- Display the current version of the plugin -->
                          <p class="text-secondary text-sm" :class="{'mb-3': plugin.is_update === 1, 'mb-0': plugin.is_update === 0}" >{{trans('current_version')}}&nbsp;<b>{{'v'+plugin.version + " "}}</b>

                            <!-- If 'whiteLabel' is false, display the author's website -->
                            <span  v-if="!whiteLabel"> | {{trans('by')}}

                              <a :href="'https://'+plugin.website" target="_blank">{{'Faveo'}}</a>
                            </span>

                            <span v-if="!whiteLabel">{{' | '}}</span>
                            <!-- Link to show the plugin details -->
                            <a v-if="!whiteLabel" href="javascript:;" @click="showDetailsModal(plugin, 'plugin_list')" >{{trans('Plugin_details')}}</a>
                          </p>

                          <!-- Display the latest version of the plugin -->
                            <p v-if="plugin.is_update === 1" class="text-secondary text-sm m-0">{{trans('new_version')}} <b>{{plugin.latest_version}}</b> {{trans('available')}}</p>

                          <!-- Button to trigger the plugin update -->
                            <button v-if="plugin.is_update === 1" type="button" class="btn btn-light p-1 mt-1 mb-1" @click="updatePlugin(plugin)">

                              <i class="fas fa-sync-alt"></i>&nbsp;{{trans('update_now')}}
                            </button>
                        </div>
                      </div>
                    </td>
                  </tr>
                  </tbody>
                </table>
              </div>
            </template>
            <template v-else>

              <span>{{trans('no_plugin_update_available')}}</span>
            </template>

            <div v-if="!loading">

              <div class="mailbox-controls">

                <div v-if="pluginsDetails.length" class="row">

                  <div class="col-sm-6 pad-top-18">

                    <template v-if="pluginAdditionalData.total == 1">
                      {{trans('one_record')}}
                    </template>
                    <template v-if="pluginAdditionalData.total > 1 && pluginAdditionalData.total <= 10">
                      {{ pluginAdditionalData.total }} {{trans('records')}}
                    </template>
                    <template v-if="pluginAdditionalData.total > 10">
                      {{trans('showing')}} {{ pluginAdditionalData.from }} to {{ pluginAdditionalData.to }} of {{ pluginAdditionalData.total }} {{trans('records')}}
                    </template>

                  </div>

                  <div class="col-sm-6">

                    <div class="float-end mr-2">

                      <simple-pagination :prev_page="prev_page" :next_page="next_page"
                                         :onPagination="pageChanged">

                      </simple-pagination>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <!-- Transition effect named 'modal' for the contained elements -->
		<transition name="modal">

      <!-- Display the 'system-update-modal' component if 'showModal' is true -->
			<system-update-modal  v-if="showModal" :onClose="onClose" :showModal="showModal"
				:space="space" :path="backup_path">

			</system-update-modal>
		</transition>

    <!-- Display the 'PluginDetailModal' component if 'showDetails' is true -->
    <PluginDetailModal v-if="showDetails" :data="releaseDetails" :show-modal="showDetails" :from="page_type"
                       :onClose="onDetailsClose" :whiteLabel="whiteLabel" alertComponentName="SystemUpdates"></PluginDetailModal>

    <!-- Display the 'PluginUpdateModal' component if 'showUpdateModal' is true -->
    <PluginUpdateModal v-if="showUpdateModal" :data="updateDetails" from="update_list" :show-modal="showUpdateModal"
                       :containerStyle="{width:'800px'}" :onClose="closeUpdateModal"></PluginUpdateModal>
	</div>
</template>

<script>

import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";
	import axios from 'axios'
    import { computed }  from 'vue';
    import { useStore } from 'vuex';
    import UpdateModal from "./UpdateModal.vue";
import PluginDetailModal from "../../../../Admin/Plugins/pluginDetailModal.vue";
import PluginUpdateModal from "../../../../Admin/Plugins/PluginUpdateModal.vue";
import SimplePagination from "../../../../Common/SimplePagination.vue";
import TicketPerPage from "../../../Inbox/View/Mini/Table/TicketPerPage.vue";

	export default {

        name : 'updates-list',

        setup() {

            const store = useStore();

            return {
                // getter
                formattedTime: computed(() => store.getters.formattedTime)
            };
        },

        props : {

          // Prop for checking if the label is white
          whiteLabel : {type : Boolean, default : false},
        },

		data () {

			return {

				loading : true,

				hasDataPopulated : false,

				updatesData : [],

				pageLoad : false,

				current : '',

				latest : '' ,

				space : '',

				backup_path : '',

				showModal : false,

				updateStatus : 'success',

				updateMsg : 'an_update_is_available',

				whiteLabel: false,

        UpdateAvailable: true,

        pluginsDetails: [],

        selectedPlugin: [],

        showVersion: false,

        showDetails: false,

        pluginInfo: [],

        selectAll: false,

        isLoading: false,

        releaseDetails: {},

        showUpdateModal: false,

        showLoader: false,

        updateLoading: false,

        updateDetails: {},

        next_page: '',

        prev_page: '',

        perpage: 50,

        paramsObj: {},

        pluginAdditionalData: {},

        updateError: false,

        noPluginData: false,

        page_type: '',

        latest_version:{}
			}
		},

		beforeMount() {

      // Fetch release updates and check for plugin updates before the component is mounted
			this.getUpdates();

      let params = {
        page: 1,
        limit: 50
      }

      this.checkPluginUpdate(params);
		},

    created(){

      window.emitter.on('refreshUpdateList',this.checkPluginUpdate)
    },

		methods : {

      redirectToDashboard() {
        setTimeout(() => {
          this.redirect('/panel/dashboard');
        }, 2000);
      },

     // fetches the updates
			getUpdates() {

				axios.get('/api/check-updates').then(res=>{

          //Success Handler part

					 this.latest = res.data.message.latest;

					this.current = res.data.message.current;

					this.space = res.data.message.filesystem_space;

					this.backup_path = res.data.message.backup_path;

					this.updatesData = res.data.message.version.reverse();

					this.loading = false;

					this.hasDataPopulated = true;

          this.updateStatus = res.data.data.status;

          this.updateMsg = res.data.data.message;

					this.whiteLabel = res.data.message.white_label;

          this.updateError = false;

          this.latest_version = {
            version : this.latest,
          }

        }).catch(err=>{

          // On error, stop loading and handle the error

					this.loading = false;

					this.hasDataPopulated = true;

					let message = err.response.data.message;

					if (message == this.lang('already_on_latest_version')) {
						this.$store.dispatch('setAlert', {
							type: 'success',
							message: message,
							component_name: 'SystemUpdates'
						});
					} else {
						errorHandler(err,'SystemUpdates');
					}

          this.updateError = true; // Set the error flag
          if (this.updateError && this.noPluginData) {
            this.redirectToDashboard();
          }
				})
			},

			onClose () {

        // Close the modal
				this.showModal = false;
			},

      checkPluginUpdate(params){

        this.updateLoading = true;

            axios.get('/getplugin?',{ params } ).then(res=>{

              this.updateLoading = false;
              // On Success, handles the success
              this.pluginsDetails = res.data.data.plugin.filter(plugin => plugin.is_update === 1);

              this.pluginAdditionalData = res.data.data;

              this.perpage = res.data.data.per_page;

              this.next_page = res.data.data.next_page_url;

              this.prev_page = res.data.data.prev_page_url;

              this.noPluginData = this.pluginsDetails.length === 0; // Set the no data flag

              if (this.updateError && this.noPluginData) {
                this.redirectToDashboard();
              }

            }).catch(err=>{
              // On error, handle the error
                errorHandler(err,'SystemUpdates');

                this.updateLoading = false;
            })
      },

      recentVersions(){
        // Toggle the visibility of recent versions
        this.showVersion = !this.showVersion;
      },

      // Show's the details modal
      showDetailsModal (data, type) {

        this.releaseDetails = data;

        this.page_type = type;

        this.showDetails = true;
      },

      // Close's the details modal
      onDetailsClose () {

        this.showDetails = false;
      },

      // Close's the update modal
      closeUpdateModal() {
        this.showUpdateModal = false;
      },

      // Update's all selected plugins
      updateAllPlugin(){

        this.updateLoading = true;

        axios.post('plugin/all/update',{plugin : this.selectedPlugin}).then(res=>{

          this.updateLoading = false;
          successHandler(res, 'SystemUpdates');

          this.checkPluginUpdate();

          this.selectedPlugin = [];
        }).catch(err=>{
          this.updateLoading = false;
          errorHandler(err,'SystemUpdates');
          this.selectedPlugin = [];
        })
      },

      // Update's a specific plugin
      updatePlugin(plugin){

        this.updateDetails = plugin;
        this.showUpdateModal = true;
      },

      // Toggle's the selection of all plugins
      toggleSelectAll() {
        this.selectAll = !this.selectAll;
        if (this.selectAll) {
          this.selectedPlugin = this.pluginsDetails
              .filter(plugin => plugin.is_update === 1)
              .map(plugin => plugin.path);
        } else {
          this.selectedPlugin = [];
        }
      },

      pageChanged(direction) {

        let page = ''
        if (direction === 'next' && this.next_page) {
          page = this.getPageNumberFromUrl(this.next_page);
        }

        if (direction === 'previous' && this.prev_page) {
          page = this.getPageNumberFromUrl(this.prev_page);
        }

        this.paramsObj['page'] = page;

        this.checkPluginUpdate(this.paramsObj);
      },

      getPageNumberFromUrl(url) {
        const regex = /[?&]page=(\d+)/;
        const match = url.match(regex);
        return match ? parseInt(match[1]) : null;
      },

      handlePageCount(count) {

        this.paramsObj['page'] = 1;

        this.paramsObj['limit'] = count;

       this.checkPluginUpdate(this.paramsObj);
      },

		},

    watch:{
      // Watch for changes in the selected plugins
      selectedPlugin() {
        // Display the update button if a plugin is selected
        this.selectAll = this.selectedPlugin.length === this.pluginsDetails.length;
      }
    },

		components : {
      'per-page' : TicketPerPage,
      'simple-pagination' : SimplePagination,
      'PluginUpdateModal' : PluginUpdateModal,
      'PluginDetailModal' : PluginDetailModal,
			'system-update-modal' : UpdateModal
		}
	};
</script>

<style scoped>

	.center_align {
		justify-content: center;
	}

	.fs-30{
		font-size: 30px;
	}

	.prl-0 { padding-left: 0; padding-right: 0; }

  .error-content {
    display: flex !important;
    justify-content: center !important;
  }

	.restricted { font-size : 10px !important; position: relative; bottom: 2px; }

	.tag_align {
		 position: absolute;padding: 10px !important;
	}

	.ml-3-1 { margin-left: 3.1rem!important; }

	.latest_card{border-bottom-left-radius: 0px;border-top-left-radius: 0px;}

	.current_card{border-bottom-right-radius: 0px;border-top-right-radius: 0px;}

	.border_bottom_w{ border-bottom-color: white !important; padding: .35rem !important; }

  .upd_btn {
    border: 1px solid grey !important;
    width: auto !important;
    display: inline-block !important;
  }

  .fw_500 { font-weight: 500 !important; }

  .post {
    border-bottom: 1px solid #adb5bd;
    color: #666;
    margin-bottom: 15px;
    padding-bottom: 15px;
  }

  .post .user-block {
    margin-bottom: 15px;
    width: 100%;
  }

  .img-tag-bordered {
    border: 3px solid #adb5bd !important;
  }

  .cursor-pointer{
    cursor: pointer;
  }

  @keyframes rotate {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  /* Apply the rotation animation when the button has a class of "rotating" */
  .btn-tool.rotating i {
    animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
  }

  .cursor-none{
    cursor: not-allowed !important;
  }

  .fade-enter-from, .fade-leave-to {
    opacity: 0;
  }
  .fade-enter-to, .fade-leave-from {
    opacity: 1;
  }
  .fade-enter-active, .fade-leave-active {
    transition: opacity .5s;
  }

  .resize-icon{
    width: 60px !important;
    font-size: 25px !important;
  }

  .plugin-icon-container{
    display: flex;
    padding-top: 10px;
  }

  .plugin-name{
    font-size: 18px;
  }

  .pad-top-18 { padding-top: 18px;padding-bottom: 18px; }

  .focus-remove{
    cursor: pointer !important;
  }

  .focus-remove:focus {
    box-shadow: none !important;
  }

  .custom-bg-info{
    background-color: #17a2b8!important;
  }

  .custom-text-bg-success{
    color: #218838 !important;
  }

</style>