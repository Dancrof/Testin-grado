<script setup>

import {ref} from "vue";
import FormElementLabel from "./FormElementLabel.vue";
import FormElementActions from "./FormElementActions.vue";

/**
 * Props for the component.
 * @prop {Object} fieldData - The field data object.
 * @prop {Function} onEditFormField - Function to edit form field.
 * @prop {Boolean} isChild - Flag indicating if it's a child field.
 * @prop {Object} auth - Authentication data.
 */
const props = defineProps({

	fieldData: { type: Object, required: true },

	onEditFormField: { type: Function, required: true },

	isChild: { type: Boolean, default: () => false },

	sectionDeletable: { type: Boolean, default: () => false },

	auth : { type: Object, default : () => {}}
})

// Ref for the hovering field.
const hoveringField = ref('');

/**
 * Function triggered when hovering over a field.
 * Updates the hovering field.
 * @param {Object} value - The hovered field object.
 */
const onHover = (value) => {

	hoveringField.value = value.id
}
</script>

<template>

	<div class="item-group form-field-element px-2" @mouseenter="onHover(fieldData)" @mouseleave="hoveringField = ''">
		
		<div class="row form-field">
			
			<div class="col-md-4 mt_5 drag-handle">
				
				<FormElementLabel :element-data="fieldData" :is-child="isChild" :auth="auth"></FormElementLabel>
			</div>
			
			<div class="col-sm-5 drag-handle">

				<input :id="'short-text-input' + fieldData.id" class="form-control drag-handle" :type="'text'"
				       :placeholder="fieldData.labels[0].place_holder ? fieldData.labels[0].place_holder : trans('short_text')" disabled />
			
			</div>
			
			<div class="col-sm-3 mt_3">
				
				<FormElementActions v-if="hoveringField === fieldData.id" :on-edit-form-field="onEditFormField" :element-data="fieldData" :sectionDeletable="sectionDeletable"/>
			
			</div>
		</div>
	</div>
</template>

<style lang="css" scoped>
	.item-sub {
		margin: 0 0 0 1rem;
	}
	.space-filler {
		flex: 1 1 auto;
	}
	.form-field-actions-btn {
		visibility: hidden;
		margin-right: 2rem;
	}
	.form-action-btn-div {
		position: absolute;
		right: 0px;
		top: 8px;
	}
	.form-field { position: relative; }
</style>