<script setup>

import {ref} from "vue";
import FormElementLabel from "./FormElementLabel.vue";
import FormElementActions from "./FormElementActions.vue";

/**
 * Component properties:
 * - fieldData: Object - The data of the field being edited.
 * - onEditFormField: Function - Function to handle editing of the form field.
 * - isChild: Boolean - Indicates if the component is a child component.
 * - auth: Object - Authentication information.
 */
const props = defineProps({
	
	fieldData: { type: Object, required: true },
	
	onEditFormField: { type: Function, required: true },
	
	isChild: { type: Boolean, default: () => false },

	sectionDeletable: { type: Boolean, default: () => false },

	auth : { type: Object, default : () => {}}
})

// Reactive variable for hovering field
const hoveringField = ref('');

/**
 * Function to handle hovering over a field
 * @param {Object} value - The value of the hovered field
 */
const onHover = (value) => {
	
	hoveringField.value = value.id
}
</script>

<template>

<div class="fe-mobile item-group form-field-element px-2" @mouseenter="onHover(fieldData)" @mouseleave="hoveringField = ''">
	
	<div class="row form-field">
		
		<div class="col-md-4 mt_5 drag-handle">
			
			<FormElementLabel :element-data="fieldData" :is-child="isChild" :auth="auth"></FormElementLabel>
		</div>
		
		<div class="col-sm-5 drag-handle">
			
			<input :id="'mobile-input' + fieldData.id" class="form-control drag-handle" :type="'text'" :placeholder="lang(fieldData.labels[0].place_holder || '9876543210')" disabled />
		</div>
		
		<div class="col-sm-3 mt_3">
			
			<FormElementActions v-if="hoveringField === fieldData.id" :on-edit-form-field="onEditFormField" :element-data="fieldData" :sectionDeletable="sectionDeletable"/>
			
		</div>
	</div>
</div>
</template>

<style lang="css" scoped>

.space-filler {
	flex: 1 1 auto;
}
.form-field-actions-btn {
	visibility: hidden;
	margin-right: 2rem;
}
.form-action-btn-div {
	position: absolute;
	right: 0;
	top: 8px;
}
.form-field { position: relative; }

</style>