<template>

	<div v-if="data">

		<span v-tooltip="data.status ? trans('activated') : trans('activate')">

			<button class="btn btn-sm btn-primary" @click="showModal = true" :disabled="data.status ? true : false">

				<i class="fas fa-check-circle"></i> {{trans('activate')}}
			</button>
		</span>

		<transition name="modal">

		 	<queue-activate-modal v-if="showModal" :onClose="onClose" :showModal="showModal"  :queueId="data.id">
		 		
		 	</queue-activate-modal>
		</transition>
	</div>

</template>

<script>

	import QueueActivate from "./QueueActivate.vue";

	export default {

		name:"queue-actions",

		description: "Queue table action component",

		props: {

			data : { type : Object, required : true },
		},

		data () {

			return {

				showModal : false
			}
		},

		methods : {

			onClose() {

				this.showModal = false;
			}
		},

		components : {

			'queue-activate-modal' : QueueActivate
		}
	};
</script>
