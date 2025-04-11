<script setup>

import {ref} from "vue";
import {useStore} from "vuex";
const store =useStore();

import DeleteModal from "../../../../MiniComponent/DataTableComponents/DeleteModal.vue";

const props = defineProps({
	//  Representing the table data passed to the component
	data : { type : Object, required : true },
	// Representing the function to be called on update action
	onUpdate : { type: Function, default : () => {} },
	// Representing the function to be called on clone action
	onClone : { type: Function, default : () => {} }
})

// Reactive reference to manage the visibility of the delete modal
const showDeleteModal = ref(false);

/**
 * Function to handle delete action
 */
const onDelete = () => {

	showDeleteModal.value = !props.data.is_default;
}

/**
 * Function to handle close action of the delete modal
 */
const onClose = () => {

	showDeleteModal.value = false;

	store.dispatch('unsetValidationError');
}

/**
 * Function to handle edit action
 */
const doEdit = () => {

	props.onUpdate(props.data)
}

/**
 * Function to handle clone action
 */
const doClone = () => {

	props.onClone(props.data)
}
</script>

<template>

	<div class="form-table-actions">
		
		<router-link v-if="data.view_api" class="btn btn-light table_btn" :to="'/new/forms/'+data.category+'/'+data.id+'/edit'" v-tooltip="trans('edit')">

			<i class="fas fa-edit"></i>
		</router-link>
		
		<button v-if="data.update_api" type="button" class="btn btn-light table_btn" v-tooltip="trans('settings')" @click="doEdit">
			
			<i class="fas fa-cog"></i>
		</button>

		<button v-if="data.clone_api" type="button" class="btn btn-light table_btn" v-tooltip="trans('clone')" @click="doClone">

			<i class="far fa-clone"></i>
		</button>

		<span v-tooltip="data.is_default ? trans('default_form_is_not_deletable') : trans('delete')">

			<button v-if="data.delete_api" class="btn btn-light table_btn" @click="onDelete"
					:disabled="data.is_default">

				<i class="fas fa-trash"></i>
			</button>
		</span>

		<transition name="modal">

			<DeleteModal v-if="showDeleteModal" :onClose="onClose" :showModal="showDeleteModal" :deleteUrl="data.delete_api"
				 alertComponentName="form-builder-index" modal-message="are_you_sure_you_want_to_delete" :replace="true"
				:replace-endpoint="'/from/forms/'+data.category+'?&ids[0]='+data.id" title="assign_to_form">

			</DeleteModal>
		</transition>
	</div>
</template>

<style scoped>

</style>