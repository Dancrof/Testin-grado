<template>

	<div class="inbox-approval">

		<approval-progress :ticketId="id" :actions="actions" alertName="timeline" :key="'approval'+counter"/>
	</div>
</template>

<script>

	import ApprovalProgress from "../../../../../../Admin/ApprovalWorkflow/ApprovalProgress.vue";

	export default {

		props: {
			
			id: { type: [String, Number], required: true },

			actions : { type : Object, default : ()=>{} },
		},

		data() {

			return {

				counter : 0,
			}
		},

		created() {

			window.emitter.on('approvalWorkflowApplied',this.updateData)
		},

		methods : { 

			updateData() {

				this.counter += 1;
			}
		},

		components: {
			
			'approval-progress': ApprovalProgress,
		}
	};
</script>