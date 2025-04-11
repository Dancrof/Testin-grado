<template>

	<faveo-box :title="lang('exception_logs')">

		<template #headerMenu>

			<div class="card-tools" style="cursor:pointer">
				<span><i class="fas fa-sync-alt" aria-hidden="true" v-tooltip="lang('refresh')" @click="refreshTable()"></i></span>
			</div>
		</template>

		<div class="row exception-log-table">
			<logs-table
				id="exception_logs_title"
				v-if="!options.length"
				:columns="columns"
				:options="options"
				:apiUrl="apiUrl"
				componentTitle="exceptionLogs">
			</logs-table>
		</div>
	</faveo-box>
</template>

<script>

	import {useStore} from 'vuex';
	import moment from 'moment';
	import {computed} from "vue";
	import LogsTrace from "./ReusableComponent/LogsTrace.vue";
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

			created_at : { type : [String,Date], default : '' }
		},

		data() {

			return {

				apiUrl : '/api/logs/exception' ,

				columns: ['category', 'file', 'line', 'message', 'trace', 'created_at'],

				options : {},

				moment : moment,
			}
		},

		beforeMount(){

			let date = this.created_at ? moment(this.created_at).format('YYYY-MM-DD') : '';

			this.apiUrl = '/api/logs/exception?category_id='+this.category.id+'&created_at='+date;

			const self = this;

			this.options = {

				headings: {

          category: this.lang('category'),

          file: this.lang('file'),

          line: this.lang('line'),

          message: this.lang('message'),

          trace: this.lang('trace'),

          created_at: this.lang('created-at')
				},

				columnsClasses : {

					category: 'log-category',

					file: 'log-file',

					line:'log-line',

					trace: 'log-trace',

					message: 'log-message',

					created_at: 'log-created'
				},

				sortIcon: {

					base : 'glyphicon',

					up: 'glyphicon-chevron-down',

					down: 'glyphicon-chevron-up'
				},

				texts: { filter: '', limit: '' },

				templates: {

					category(h,row){

						return row.category.name
					},

					created_at(h, row) {

						return self.formattedTime(row.created_at)
					},

					trace: (f,row)=>{
						return self.h(LogsTrace,{ data : row })
					},
				},

				sortable:  ['category', 'file', 'line', 'trace', 'message', 'created_at'],

				filterable:  ['category', 'file', 'line', 'trace', 'message', 'created_at'],

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

		methods: {

			refreshTable() {

				window.emitter.emit('exceptionLogsrefreshData');
			},
		},

		components : {

			'logs-table': LogsTable
		}
	};
</script>

<style>

	.log-category,.log-file,.log-trace,.log-line,.log-created,.log-message
	{ max-width: 250px; word-break: break-all;}

	.exception-log-table #logs_table .VueTables .table-responsive {
		overflow-x: auto;
	}

	.exception-log-table #logs_table .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}

</style>