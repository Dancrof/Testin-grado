<template>
	<div id="backup-details-container" class="col-sm-12">

		<!-- Datatable alert  -->
		<alert componentName="dataTableModal" />

		<!-- `this` component alert -->
		<alert componentName="system-backup-list" />

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title d-flex">
					
					<span class="mt-1">{{ lang('backup_storage_path')}}:</span> &nbsp;&nbsp;

					<div class="input-box__sbl">
						<input type="text" class="form-control border" v-model="storagePath" id="backup_storage_path"
							placeholder="path/to/store/system-backup">
					</div>
				</h3>

				<div class="card-tools">

					<button id="create-backup__sb" class="btn btn-tool" @click="perrformBackup()"
						:disabled="perrformBackupClicked" v-tooltip="lang('take_system_backup')">

						<span :class="perrformBackupClicked ? 'fas fa-spinner fa-spin' : 'fas fa-download'" aria-hidden="true"></span>
					</button>

					<button v-if="backupTriggeredSuccessfully" class="btn btn-tool" @click="refreshDatatable()" 
						v-tooltip="lang('refresh')">
						
						<i :class="refreshingDatatable ? 'fas fa-sync-alt fa-spin' : 'fas fa-sync-alt'" id="refresh-data-table__sbl"></i>
					</button>
				</div>
			</div>

			<div class="card-body" id="backup-list">
				<data-table :url="apiUrl" :dataColumns="columns" :option="options" />
			</div>
		</div>

	</div>
</template>

<script type="text/javascript">
	import axios from 'axios';
    import { errorHandler, successHandler } from "../../../../helpers/responseHandler";
    import {useStore} from 'vuex';
    import {computed} from "vue";
    import DownloadableRow from "./DownloadableRow.vue";
    import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

	export default {
		name: 'system-backup-list',
		description: 'System backup table component',
        setup() {

            const store = useStore();

            return {
                // getter
                formattedTime: computed(() => store.getters.formattedTime)
            };
        },
		data: () => {
			return {

			loadingSpeed: 4000,

			/** Refreshing datatable to get new element */
			refreshingDatatable: false,

			/** Loading status(for the first entry to the page) */
			isLoading: true,

			/** Take backup button clicked by user */
			perrformBackupClicked: false,

			/** Backup started successfully in background*/
			backupTriggeredSuccessfully: false,

			/**
			 * backup storage location
			 */
			storagePath: '',
		
			/**
			 * api url for ajax calls
			 * @type {String}
			 */
			apiUrl: 'api/backup/list',
			/**
			* columns required for datatable
			* @type {Array}
			*/
			columns: ['filename', 'db_name', 'created_at', 'version', 'action'],
			
			/**
			* Options required for datatable
			* @type {Object}
			*/
			options: {}
			}
		},

		beforeMount() {

			this.configureOptions();

			/** Get default/saved storage location path */
			axios.get('api/get-backup-path')
        .then(response => {
					this.storagePath = response.data.data.path;
				})
				.catch(error => {
					errorHandler(error, 'system-backup-list');
				})
				.finally(()=> {
					this.isLoading = false;
				})
		},

		methods: {

			// Configure datatable option properties
			configureOptions() {
				const that = this;
				this.options = {
					headings: {
            filename: this.trans('file_name'),
            db_name: this.trans('db_name'),
            created_at: this.trans('created-at'),
            version: this.trans('version'),
            action: this.trans('action')
					},
					texts: {
						'filter': '',
						'limit': ''
					},
					templates: {
                        filename: function(createElement, row, index, column) {

                            return that.h(DownloadableRow, {

                                data: row, index: index, column : column
                            })
                        },
                        db_name: function(createElement, row, index, column) {

                            return that.h(DownloadableRow, {

                                data: row, index: index, column : column
                            })
                        },
                        action: function(createElement, row) {

                            return that.h(DataTableActions, {

                                data: row,
                            })
                        },

						created_at(h, row) {
							return that.formattedTime(row.created_at)
						}
					},
					sortable: ['created_at', 'version'],
					pagination: {
						chunk: 5,
						nav: 'scroll'
					},
					requestAdapter(data) {
						return {
							'sort-field': data.orderBy ? data.orderBy : 'created_at',
							'sort-order': data.ascending ? 'desc' : 'asc',
							'search-query': data.query.trim(),
							'page': data.page,
							'limit': data.limit,
						}
					},
					responseAdapter({data}) {
						return {
								data: data.message.data.map(data => {
									data.delete_url = window.axios.defaults.baseURL + '/api/delete-backup/' + data.id ;
									return data;
								}),
								count: data.message.total
							}
						},

					orderBy: { column: 'created_at', ascending: true },
					}
			},

			/** Start backup in background */
			perrformBackup() {
				this.perrformBackupClicked = true
				axios.post('api/backup/take-system-backup', { path: this.storagePath })
        .then(res => {
					successHandler(res, 'system-backup-list');
					this.backupTriggeredSuccessfully = true;
        })
        .catch(err => {
          errorHandler(err, 'system-backup-list');
				})
				.finally(()=> {
					this.perrformBackupClicked = false;
				})
			},

			/** Emit event to refresh datatable */
			refreshDatatable() {
				this.refreshingDatatable = true;
				window.emitter.emit('refreshData');
				/** Spin loader for user exp */
				setTimeout(() => {
					this.refreshingDatatable = false;
				}, 500);
			}

		},
	};
</script>

<style type="text/css" scoped>
.right{
  float: right;
}
.input-box__sbl > input {
  border: 1px solid #fff;
}

.control-label {
	padding-top: 7px;
}

.form-horizontal .control-label {
	text-align: inherit;
	padding-left: 1.5rem;
}
.backup-table {
	padding: 0px;
}

#backup_storage_path {
	margin-bottom: -3px;
    margin-top: -3px;
    width: 500px !important;
}

</style>