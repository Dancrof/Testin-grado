<template>
	<faveo-box :title="lang('mail_logs')">

		<template #headerMenu>

			<div class="card-tools" style="cursor:pointer" id="mail_logs_table">
				<span><i class="fas fa-sync-alt" aria-hidden="true" v-tooltip="lang('refresh')" @click="refreshTable()"></i></span>
			</div>
		</template>

		<div class="row">
			<dynamic-select :label="lang('sender')"
				id="sender-select-box"
				:multiple="true"
				name="sender_mails"
				:required="false"
				:prePopulate="false"
				classname="col-sm-6"
				apiEndpoint="/api/dependency/users?meta=true&supplements=true"
				:value="sender_mails"
				:onChange="onChange">
			</dynamic-select>

			<dynamic-select :label="lang('receiver')"
				id="reciever-select-box"
				:multiple="true"
				name="reciever_mails"
				:required="false"
				:prePopulate="false"
				classname="col-sm-6"
				apiEndpoint="/api/dependency/users?meta=true&supplements=true"
				:value="reciever_mails"
				:onChange="onChange">
			</dynamic-select>
		</div>

		<div class="row mail-log-table">
			<logs-table
				id="mail_logs_table"
				v-if="!options.length"
				:sender_mails="sender_mails"
				:reciever_mails="reciever_mails"
				:columns="columns"
				:options="options"
				:apiUrl="apiUrl"
				componentTitle="mailLogs">
			</logs-table>
		</div>

		<transition name="modal">

			<mail-retry-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :data="data">

			</mail-retry-modal>
		</transition>
	</faveo-box>
</template>

<script>

	import { useStore } from 'vuex';
	import {computed} from "vue";

	import MailHover from "./ReusableComponent/MailHover.vue";

	import RefereeIdComponent from "./ReusableComponent/RefereeIdComponent.vue";

	import MailSubject from "./ReusableComponent/MailSubject.vue";

	import LogStatus from "./ReusableComponent/LogStatus.vue";

	import moment from 'moment';
	import LogsTable from "./ReusableComponent/LogsTable.vue";
	import DynamicSelect
		from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DynamicSelect.vue";
	import DateTimePicker
		from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DateTimePicker.vue";

	import MailRetryModal from "./Child/MailRetryModal.vue";

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

				apiUrl : '/api/logs/mail' ,

				columns: ['category', 'sender_mail', 'reciever_mail', "collaborators", 'subject', 'referee_id', 'referee_type', 'created_at', 'updated_at','status', 'action'],

				options : {},

				reciever_mails : [],

				sender_mails : [],

				moment : moment,

				showModal : false,

				data : {}
			}
		},

		beforeMount(){
			
			let date = this.created_at ? moment(this.created_at).format('YYYY-MM-DD') : '';

			this.apiUrl = '/api/logs/mail?category_id='+this.category.id+'&status='+this.status+'&created_at='+date;

			const self = this;

			this.options = {

				headings: {

          category: this.trans('category'),

          subject : this.trans('subject'),

          sender_mail: this.trans('sender_mail'),

          reciever_mail: this.trans('reciever_mail'),

          collaborators: this.trans('collaborators'),

          referee_id : this.trans('referee_id'),

          referee_type : this.trans('referee_type'),

          created_at: this.trans('created-at'),

          updated_at: this.trans('updated-at'),

          status: this.trans('status'),
				},

				perPageValues : [10,25,50,100,200,500,1000,2000],

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},

				headingTooltips:{
				    category:'Category'
				},

				columnsClasses : {

					category: 'mail-category',

					subject : 'mail-subject',

					sender_mail: 'mail-sender',

					reciever_mail: 'mail-receiver',

					referee_id: 'mail-refree',

					referee_type: 'mail-refree-type',

					created_at: 'mail-created',

					updated_at: 'mail-updated',

					status: 'log-status'
				},

				texts: { filter: '', limit: '' },

				templates: {

					category(h,row){

						return row.category.name
					},

					created_at(h, row) {

						return self.formattedTime(row.created_at);
					},

					updated_at(h, row) {

						return self.formattedTime(row.updated_at);
					},

					sender_mail : (f,row)=>{
						return self.h(MailHover,{ data : row, objectKey:'sender_mail'})
					},

					reciever_mail : (f,row)=>{
						return self.h(MailHover,{ data : row, objectKey:'reciever_mail'})
					},

					referee_id : (f,row)=>{
						return self.h(RefereeIdComponent,{ data : row})
					},

					status : (f,row)=>{
						return self.h(LogStatus,{ data : row})
					},

					subject: (f,row)=>{
						return self.h(MailSubject,{ data : row})
					},

					collaborators: (f,row)=>{
						return self.h(MailHover,{ data : row, objectKey:'collaborators'})
					},

					action: function(createElement, row) {

						let i = self.h('i', {
							'class' : 'fas fa-redo'
						});

						return self.h('button', {

							class : 'btn btn-light btn-sm',

							disabled : !row.is_retry,

							title : this.trans('retry_log'),
							onClick(event) {
								self.onClick(row)
							}
						}, [i]);
					},
				},

				sortable:  ['category', 'referee_id', 'referee_type', 'sender_mail', 'reciever_mail', 'subject', 'source', 'created_at', 'updated_at','status'],

				filterable:  ['category', 'referee_id', 'referee_type', 'sender_mail', 'reciever_mail', 'subject', 'source', 'created_at'],

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

				orderBy: { ascending: true }
			}
		},

		methods : {

			onChange(value,name){

				this[name] = value;

			},

			refreshTable() {
				window.emitter.emit('mailLogsrefreshData');
			},

			onClick(data){

				this.data = data;

				this.showModal = true
			},

			onClose(){
				this.showModal = false;
				this.$store.dispatch('unsetValidationError');
			}

		},

		components : {

			'logs-table': LogsTable,

			'dynamic-select': DynamicSelect,

			'mail-retry-modal': MailRetryModal
		}
	};
</script>

<style>

	.log-status{
		word-break: break-all;
	}

	.mail-category,.mail-subject,.mail-sender,.mail-receiver,.mail-refree-type,.mail-created,.mail-refree,.mail-updated,.log-status
	{ max-width: 250px; word-break: break-all;}

	.mail-log-table #logs_table .VueTables .table-responsive {
		overflow-x: auto;
	}

	.mail-log-table #logs_table .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>
