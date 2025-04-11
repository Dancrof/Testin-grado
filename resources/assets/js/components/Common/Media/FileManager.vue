<template>
    <div class="fm d-flex flex-column" v-bind:class="{ 'fm-full-screen': fullScreen }">
        <navbar-block />
        <div class="fm-body d-flex">
            <notification-block />
            <context-menu />
            <modal-block v-if="showModal" />
            <template v-if="windowsConfig === 1">
                <left-manager class="fm-content d-flex flex-column col" manager="left" :fromPage="settings.page ? settings.page : ''"/>
            </template>
            <template v-else-if="windowsConfig === 2">
                <folder-tree class="col-4 col-md-3" />
                <left-manager class="col-8 col-md-9" manager="left" :fromPage="settings.page ? settings.page : ''"/>
            </template>
            <template v-else-if="windowsConfig === 3">
                <left-manager :fromPage="settings.page ? settings.page : ''"
                    class="col-12 col-sm-6"
                    manager="left"
                    v-on:click.native="selectManager('left')"
                    v-on:contextmenu.native="selectManager('left')"
                >
                </left-manager>
                <right-manager :fromPage="settings.page ? settings.page : ''"
                    class="col-12 col-sm-6"
                    manager="right"
                    v-on:click.native="selectManager('right')"
                    v-on:contextmenu.native="selectManager('right')"
                >
                </right-manager>
            </template>
        </div>
        <info-block />
    </div>
</template>

<script>
/* eslint-disable import/no-duplicates, no-param-reassign */
import { mapState } from 'vuex';
// Axios
import HTTP from './http/axios';
import EventBus from './emitter';
// Components
import NavbarBlock from './components/blocks/NavbarBlock.vue';
import FolderTree from './components/tree/FolderTree.vue';
import LeftManager from './components/manager/Manager.vue';
import RightManager from './components/manager/Manager.vue';
import ModalBlock from './components/modals/ModalBlock.vue';
import InfoBlock from './components/blocks/InfoBlock.vue';
import ContextMenu from './components/blocks/ContextMenu.vue';
import NotificationBlock from './components/blocks/NotificationBlock.vue';
// Mixins
import translate from './mixins/translate';

/**
 * Cache object for the request object
 */
let requestObjectCache = null;

/**
 * Clear the request cache object after 500 miliseconds
 */
let clearRequestCache = function() {
	setTimeout(() => {
		requestObjectCache = null;
	}, 500);
}

export default {
    name: 'FileManager',
    mixins: [translate],
    components: {
        NavbarBlock,
        FolderTree,
        LeftManager,
        RightManager,
        ModalBlock,
        InfoBlock,
        ContextMenu,
        NotificationBlock,
    },
    props: {
        /**
         * LFM manual settings
         */
        settings: {
            type: Object,
            default() {
                return {};
            },
        },
    },
	created() {
		// manual settings
		this.$store.commit('fm/settings/manualSettings', this.settings);

		// initiate Axios
		this.$store.commit('fm/settings/initAxiosSettings');
		this.requestInterceptor();
		this.responseInterceptor();

		// initialize app settings
		this.$store.dispatch('fm/initializeApp');

		/**
		 * todo Keyboard event
		 */
		/*
		window.addEventListener('keyup', (event) => {
		  event.preventDefault();
		  event.stopPropagation();

		  EventBus.$emit('keyMonitor', event);
		});
		*/
	},
	destroyed() {
		// reset state
		this.$store.dispatch('fm/resetStateMinimal');
		this.$store.dispatch('fm/resetViewType');

		// delete events
		EventBus.all.clear();

		EventBus.off('contextMenu');
		EventBus.off('addNotification');
	},
	computed: {
		...mapState('fm', {
			windowsConfig: (state) => state.settings.windowsConfig,
			activeManager: (state) => state.settings.activeManager,
			showModal: (state) => state.modal.showModal,
			fullScreen: (state) => state.settings.fullScreen,

			// dateFilter() {
			//   return this.$store.state.fm.settings.dateFilter;
			// },
			//
			// typeFilter() {
			//   return this.$store.state.fm.settings.typeFilter;
			// },
			//
			// searchText() {
			//   return this.$store.state.fm.settings.searchText;
			// },
			//
			// showFilter() {
			//   return this.$store.state.fm.settings.toggleFilter
			// },
		}),
	},
	methods: {
		/**
		 * Add axios request interceptor
		 */
    requestInterceptor() {
      let requestObjectCache = null; // Initialize the request object cache

      HTTP.interceptors.request.use((request) => {
        // Check if request is a duplicate
        if (
            requestObjectCache === null ||
            JSON.stringify(request) !== requestObjectCache ||
            request.url.includes('http://') ||
            request.url.includes('https://')
        ) {
          requestObjectCache = JSON.stringify(request); // Update the request object cache
          clearRequestCache();
          request.baseURL = this.$store.getters['fm/settings/baseUrl'];
          request.headers = this.$store.getters['fm/settings/headers'];
          request.params = { ...request.params, type: this.settings.page };

          // Show loading spinner
          this.$store.commit('fm/messages/addLoading');

          return request;
        } else { // Reject the duplicate API call
          this.$store.commit('fm/messages/subtractLoading');
          return Promise.reject({
            duplicateRequestRejection: true,
            message: 'Request rejected because of a duplicate API call'
          });
        }
      }, (error) => {
        // Handle request interceptor errors
        this.$store.commit('fm/messages/subtractLoading');
        return Promise.reject(error);
      });
    },

		/**
		 * Add axios response interceptor
		 */
		responseInterceptor() {
			const self = this;
			HTTP.interceptors.response.use((response) => {
				// loading spinner -
				this.$store.commit('fm/messages/subtractLoading');

				// create notification, if find message text
				if (Object.prototype.hasOwnProperty.call(response.data, 'result')) {
					if (response.data.result.message) {
						const message = {
							status: response.data.result.status,
							message: Object.prototype.hasOwnProperty.call(this.lang1.response, response.data.result.message)
								? this.lang1.response[response.data.result.message]
								: response.data.result.message,
						};

						// show notification
						// EventBus.$emit('addNotification', message);

						// set action result
						// this.$store.commit('fm/messages/setActionResult', message);
						this.$store.dispatch('setAlert', {
							type: message.status,
							message: message.message,
							component_name: 'fileManagerModal'
						})
					}
				}

				return response;
			}, function (error) {

				if(error && error.response && error.response.status == 412) {
					self.$store.dispatch('setAlert', {
						type: 'danger',
						message: error.response.data.message,
						component_name: 'fileManagerModal'
					})
				}

				return Promise.reject(error);
			});
		},

		/**
		 * Select manager (when shown 2 file manager windows)
		 * @param managerName
		 */
		selectManager(managerName) {
			if (this.activeManager !== managerName) {
				this.$store.commit('fm/setActiveManager', managerName);
			}
		},

		updateSearchText(e) {
			this.$store.commit('fm/settings/setSearchText', e.target.value);
		},

		updateStateType(type) {
			this.$store.commit('fm/settings/setTypeFilter', type);
		},

		updateStateDate(date) {
			this.$store.commit('fm/settings/setDateFilter', date);
		},

		resetFilters() {
			this.$store.commit('fm/settings/resetSearchText');
			this.$store.commit('fm/settings/resetDateFilter');
			this.$store.commit('fm/settings/resetTypeFilter');
		},

		applyFilter() {
			const disk = this.$store.state.fm.left.selectedDisk;
			const dateFilter = this.$store.state.fm.settings.dateFilter;
			const typeFilter = this.$store.state.fm.settings.typeFilter;
			const searchText = this.$store.state.fm.settings.searchText;
			this.$store.dispatch('fm/getLoadContent', {
				manager: 'left',
				disk,
				path: '',
				dateFilter,
				typeFilter,
				searchText,
			});
		},
	},
};
</script>

<style lang="scss">
.fm {
	position: relative;
	height: 100%;
	padding: 1rem 1rem 0;
	background-color: white;

	&:-moz-full-screen {
		background-color: white;
	}

	&:-webkit-full-screen {
		background-color: white;
	}

	&:fullscreen {
		background-color: white;
	}

	.fm-body {
		display: flex;
		height: 100%;
		margin-right: -15px;
		margin-left: -15px;
		position: relative;
		padding-top: 1rem;
		padding-bottom: 1rem;
		border-top: 1px solid #6d757d;
		border-bottom: 1px solid #6d757d;
		overflow: auto;
	}

	.unselectable {
		-webkit-touch-callout: none;
		-webkit-user-select: none;
		-moz-user-select: none;
		-ms-user-select: none;
		user-select: none;
	}
}

.fm-error {
	color: white;
	background-color: #dc3545;
	border-color: #dc3545;
}

.fm-danger {
	color: #dc3545;
	background-color: white;
	border-color: #dc3545;
}

.fm-warning {
	color: #ffc107;
	background-color: white;
	border-color: #ffc107;
}

.fm-success {
	color: #28a745;
	background-color: white;
	border-color: #28a745;
}

.fm-info {
	color: #17a2b8;
	background-color: white;
	border-color: #17a2b8;
}

.fm.fm-full-screen {
	width: 100%;
	height: 100%;
	padding-bottom: 0;
}
</style>