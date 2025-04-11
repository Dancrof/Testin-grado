<template>
	<faveo-box :title="lang('cron_logs')">

		<template #headerMenu>

			<div class="card-tools" style="cursor:pointer">

				<span><i class="fas fa-sync-alt" aria-hidden="true" v-tooltip="lang('refresh')" @click="refreshTable()"></i></span>
			</div>
		</template>

		<div class="row">
			<logs-table
				id="cron_logs_title"
				v-if="!options.length"
				:columns="columns"
				:options="options"
				:apiUrl="apiUrl"
				componentTitle="cronLogs">
			</logs-table>
		</div>
	</faveo-box>
</template>

<script>

	import moment from 'moment'

	import { useStore } from 'vuex';

	import {computed} from "vue";

	import LogStatus from "./ReusableComponent/LogStatus.vue";

	import LogsTable from "./ReusableComponent/LogsTable.vue";

	export default {

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime)
			}
		},

		props : {

			category : { type : Object, default : ()=>{} },

			status : { type : String, default : '' },

			created_at : { type : [String,Date], default : '' }
		},

		data() {

			return {

				apiUrl : '/api/logs/cron',

				columns: ["command", "description", 'duration', "created_at", "status"],

				options : {},

				moment : moment
			}
		},

		beforeMount(){

			let date = this.created_at ? moment(this.created_at).format('YYYY-MM-DD') : '';

			this.apiUrl = '/api/logs/cron?command='+this.category.command+'&status='+this.status+'&created_at='+date;

			const self = this;

			this.options = {

				headings: {

					duration: this.trans("duration_in_seconds"),

					command: this.trans("command"),

					description: this.trans("description"),

					created_at: this.trans("created_at"),

					status: this.trans('status'),
				},

				columnsClasses : {

					command : 'cron-command',

					description : 'cron-desc',

					duration : 'cron-duration',

					created_at : 'cron-created',

					status: 'cron-status'
				},

				texts: { filter: '', limit: '' },

				sortIcon: {

					base : 'glyphicon',

					up: 'glyphicon-chevron-down',

					down: 'glyphicon-chevron-up'
				},

				templates: {

					created_at(h, row) {

						return self.formattedTime(row.created_at)
					},

					status : (f,row)=>{

						return self.h(LogStatus,{ data : row })
					},
				},

				sortable:  ["command", "description", 'duration', "created_at", "status"],

				filterable:  ['category', 'start_time', 'end_time', 'message', 'created_at'],

				pagination:{chunk:5,nav: 'fixed',edge:true},

				requestAdapter(data) {

					return {

						sort_field: data.orderBy,

						sort_order: data.ascending ? 'desc' : 'asc',

						'search-query':data.query.trim(),

						page:data.page,

						limit:data.limit,

					}
				},
				responseAdapter({data}) {
					return {

						data: data.data.data,

						count: data.data.total

					}
				},
			}
		},

		methods : {

			refreshTable() {

				window.emitter.emit('cronLogsrefreshData');
			}
		},

		components : {

			'logs-table': LogsTable
		}
	};
</script>

<style>

	.cron-command,.cron-desc,.cron-duration,.cron-created,.cron-status{
		max-width: 250px; word-break: break-all;
	}

	#cron_logs_title .VueTables .table-responsive {
		overflow-x: auto;
	}

	#cron_logs_title .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>