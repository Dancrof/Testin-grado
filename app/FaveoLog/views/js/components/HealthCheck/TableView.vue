<template>

	<div class="col-sm-12">

		<alert componentName="dataTableModal"/>

		<faveo-box :title="lang('logs')">

			<template #headerMenu>

				<div class="card-tools">
					<button type="button" class="btn btn-tool" @click="showModal = true" v-tooltip="lang('delete_logs')">
						<i class="fas fa-trash"></i>
					</button>
				</div>
			</template>

			<cron-logs v-if="logType == 'cron'" :category="category" :status="status" :created_at="created_at"/>

			<mail-logs v-if="logType == 'mail'" :category="category" :status="status" :created_at="created_at"/>

			<exception-logs v-if="logType == 'exception'" :category="category" :created_at="created_at"/>

		</faveo-box>

		<transition name="modal">
			<logs-modal v-if="showModal" title="delete_logs" :onClose="onClose" :showModal="showModal"/>
		</transition>

	</div>
</template>

<script>

	import MailLogs from "../LogsTables/MailLogs.vue";

	import ExceptionLogs from "../LogsTables/ExceptionLogs.vue";

	import CronLogs from "../LogsTables/CronLogs.vue";

	import LogsModal from "../LogsTables/ReusableComponent/LogsModal.vue";

	export default {

		name : 'healthcheck-table',

		props : {

			category : { type : Object, default : () => {} },

			logType : { type : String, default : '' },

			status : { type : String, default : '' },

			created_at : { type : [String,Date], default : '' }
		},

		data(){

			return {

				showModal : false,
			}
		},

		methods : {

			onClose(){

				this.showModal = false;
			},

		},


		components : {

			'mail-logs' : MailLogs,

			'exception-logs' : ExceptionLogs,

			'cron-logs' : CronLogs,

			'logs-modal' : LogsModal
		}
	}
</script>