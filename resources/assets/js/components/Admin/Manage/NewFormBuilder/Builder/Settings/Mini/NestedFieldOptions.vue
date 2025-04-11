<script setup>

import {nextTick, onBeforeMount, ref, watch} from "vue";

/**
 * Props for the component.
 * @prop {Number} optionIndex - The index of the option.
 * @prop {String} value - The value of the option.
 */
const props = defineProps({

	optionIndex: { type: Number, required: true },

	value: { type: String, required: true }
})

// Ref for tracking whether the component is in edit mode.
const isEditMode = ref(false);
// Ref for the edited value of the option.
const editedValue = ref(props.value);
// Ref for the input element reference.
const inputRef = ref(null);

/**
 * Watcher for changes in the value prop.
 */
watch(() => props.value, (newValue) => {
	editedValue.value = newValue;
});

/**
 * Emit event definitions.
 */
const emit = defineEmits(['on-delete','on-update']);

/**
 * Method to set the input element reference.
 * @param {HTMLElement} el - The input element reference.
 */
const setInputRef = (el) => {

	inputRef.value = el;
};

/**
 * Method triggered on double click to enter edit mode.
 */
const onDoubleClick = () => {

	isEditMode.value = true;

	nextTick(() => {

		inputRef.value.focus();
	});
};

/**
 * Method to delete the option.
 */
const onDelete = () => {

	emit('on-delete', props.optionIndex)
}

/**
 * Method to cancel the edit mode.
 */
const onCancelEdit = () => {

	isEditMode.value = false;
}

/**
 * Method to update the value of the option.
 */
const updateValue = () => {

	isEditMode.value = false;

	if(editedValue.value === '') {

		editedValue.value = props.value;
	}

	emit('on-update', { newValue: editedValue.value, index: props.optionIndex });
}
</script>

<template>

	<div class="option-box">

		<span class="handle ui-sortable-handle drag-handle">
			<i class="fas fa-ellipsis-v"></i>
			<i class="fas fa-ellipsis-v"></i>
		</span>

		<span class="text m-1" @dblclick="onDoubleClick()" v-show="!isEditMode">{{ value }}</span>
		
		<input class="ms-1" v-show="isEditMode" :ref="setInputRef" v-model.trim="editedValue" @keyup.enter="updateValue()">
		
		<div class="tools float-end">

			<i class="fa fa-times fa__fb text-danger" id="delete-option" aria-hidden="true" @click="isEditMode ? onCancelEdit() : onDelete()" v-tooltip="isEditMode ? lang('cancel') : lang('delete')"></i>
		</div>
	</div>
	
	<small v-show="isEditMode" class="option_help">({{trans('press_enter_to_update')}})</small>
</template>

<style scoped>
	.fa__fb {
		color: darkgrey;
		cursor: pointer;
	}
	.option_help {color: orangered;margin-left: 4px;}
</style>