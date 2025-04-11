<template>
 
	<div class="btn-group block">

		<a id="edit-button" @click="onClickEvent('edit')" href="javascript:;" v-tooltip="lang('edit')">
			<span title="Edit" class="btn btn-light table_btn" id="edit_btn"><i class="fa fa-edit"></i></span>
		</a>

		<a id="edit-button" @click="onClickEvent('view')" href="javascript:;" v-tooltip="lang('view')">
			<span title="Edit" class="btn btn-light table_btn" id="edit_btn"><i class="fa fa-eye"></i></span>
		</a>

		<transition  name="modal">
			<Widget-Modal v-if="showModal" :onClose="onClose" :modal-mode="modalMode" :showModal="showModal" :assetId="data.id" :data="data"></Widget-Modal>
		</transition>
	</div>

</template>

<script type="text/javascript">

	import WidgetModal from "./WidgetModal.vue";

    export default {

		name:"widget-table-actions",

		description: "Widget table edit componnet",

		data: () => {
			return {
				
				showModal: false
			}
		},
 
		props: {

			data : { type : Object, required : true },
		},

		methods: {
			onClickEvent(mode) {
				this.showModal = true; 
				this.modalMode = mode;
			},

			onClose() {
				this.showModal = false;
			},
			
		},

		components: {
			'Widget-Modal': WidgetModal
		}
	};

</script>

<style type="text/css" scoped>

	.block{
		display: block;
	}

	#edit-button , #view-button{
		margin-left: 2px;
		margin-right: 2px;
	}

	#down{
		display: inline;
	}

	#action-menu{

		right: 0;
		left: unset;
		top: auto;
	}
</style>
