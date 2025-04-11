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

				<cron-logs/>

				<mail-logs/>

				<exception-logs/>

			</faveo-box>

		<transition name="modal">
			<logs-modal v-if="showModal" title="delete_logs" :onClose="onClose" :showModal="showModal"/>
		</transition>

	</div>

</template>

<script>

	import ExceptionLogs from "./LogsTables/ExceptionLogs.vue";
	import CronLogs from "./LogsTables/CronLogs.vue";
	import MailLogs from "./LogsTables/MailLogs.vue";
	import LogsModal from "./LogsTables/ReusableComponent/LogsModal.vue";

	export default {

		name : 'system-logs',

		description : 'System logs component',

		data(){

			return {

				showModal : false,

			}

		},

		methods : {

			onChange(value,name){
				this[name] = value;
			},

			onClose(){

		        this.showModal = false;

		        this.$store.dispatch('unsetValidationError');
		    },

		},

		components : {

			'exception-logs': ExceptionLogs,

			'cron-logs': CronLogs,

			'mail-logs': MailLogs,

			'logs-modal': LogsModal
		}
	};

</script>