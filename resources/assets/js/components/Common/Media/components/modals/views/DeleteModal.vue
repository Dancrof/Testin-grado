<template>
	<div className="modal-content fm-modal-delete">
		<div className="modal-header">
			<h5 className="modal-title">{{ lang1.modal.delete.title }}</h5>
      <button type="button" aria-label="Close" data-bs-dismiss="modal" v-on:click="hideModal"
              :class="['btn-close mb-3', { 'ms-auto': lang1 !== 'ar', 'me-auto': lang1 === 'ar' }]">
      </button>
		</div>
		<div className="modal-body">
			<div v-if="selectedItems.length">
				<selected-file-list/>
			</div>
			<div v-else>
				<span className="text-danger">{{ lang1.modal.delete.noSelected }}</span>
			</div>
		</div>
		<div className="modal-footer">
			<button className="btn btn-secondary" type="button" v-on:click="deleteItems">{{ lang1.modal.delete.title }}
			</button>
			<button className="btn btn-light" type="button" v-on:click="hideModal">{{ lang1.btn.cancel }}</button>
		</div>
	</div>
</template>

<script>
import SelectedFileList from '../additions/SelectedFileList.vue';
import modal from '../mixins/modal';
import translate from '../../../mixins/translate';
import EventBus from "../../../emitter";

export default {
	name: 'Delete',
	mixins: [modal, translate],
	components: {SelectedFileList},
	computed: {
		/**
		 * Files and folders for deleting
		 * @returns {*}
		 */
		selectedItems() {
			return this.$store.getters['fm/selectedItems'];
		},
	},
	methods: {
		emitRefreshEvent() {
			EventBus.emit(`refresh-file-list-fm`);
		},

		/**
		 * Delete selected directories and files
		 */
		deleteItems() {
			// create items list for delete
			const items = this.selectedItems.map((item) => ({
				path: item.path,
				type: item.type,
			}));

			this.$store.dispatch('fm/delete', items).then(() => {
				EventBus.emit('refreshFiles');
				this.emitRefreshEvent();
				this.hideModal();
			});
		},
	},
};
</script>
