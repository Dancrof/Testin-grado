<script setup>

import {computed, ref} from "vue";
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
 * Computed property to determine the placeholder for simple fields
 */
const getSimpleFieldPlaceholder = computed(() => {

	let placeholder;
	
	if(props.fieldData.labels[0].place_holder) {
		
		placeholder = props.fieldData.labels[0].place_holder;
	
	} else if(props.fieldData.data_type === 'number'){
	
		placeholder = 'integer';
	
	} else if(props.fieldData.data_type === 'decimal'){
	
		placeholder = 'decimal_number';
	
	} else if(props.fieldData.data_type === 'date'){
	
	placeholder = 'date';
	
	} else {
	
		placeholder = 'short_text';
	}

	switch (props.fieldData.title) {
		case 'Attachments':
			placeholder = 'attach files';
			break;
		case 'Asset Image':
			placeholder = 'asset_image';
			break;
		case 'Api':
			placeholder = 'api_endpoint';
			break;
	}

	if (['email'].includes(props.fieldData.data_type)) {

		placeholder = 'email@example.com';

	} else if (['textarea', 'htmltextarea'].includes(props.fieldData.data_type)) {

		placeholder = 'long_text';
	}

	return placeholder;
});

/**
 * Function to handle hovering over a field
 * @param {Object} value - The value of the hovered field
 */
const onHover = (value) => {

	hoveringField.value = value.id
}

/**
 * Function to check if the field is a simple field
 * @returns {Boolean} - Indicates whether the field is a simple field
 */
const isSimpleField = () => {

	const simpleFields = ['text', 'number', 'decimal', 'date', 'email', 'file', 'image', 'taggable'];

	return simpleFields.indexOf(props.fieldData.data_type) > -1;
}
</script>

<template>

	<div class="item-group form-field-element pe-2" @mouseenter="onHover(fieldData)" @mouseleave="hoveringField = ''">
		
		<div class="row form-field">
			
			<div class="col-md-4 mt_5 drag-handle">
				
				<FormElementLabel :element-data="fieldData" :is-child="isChild" :auth="auth" :labelFieldClass="hoveringField === fieldData.id ? 'field_label' : ''"></FormElementLabel>
			</div>
			
			<div class="col-sm-5 drag-handle">
				
				<input v-if="isSimpleField() || fieldData.title === 'Api'" :id="'short-text-input' + fieldData.id" class="form-control drag-handle" :type="'text'" :placeholder="lang(getSimpleFieldPlaceholder)" disabled />
				
				<textarea v-if="fieldData.data_type === 'textarea' || fieldData.data_type === 'htmltextarea'" :id="'long-text-input' + fieldData.id" class="form-control drag-handle" rows="1" :placeholder="lang(getSimpleFieldPlaceholder)" disabled />
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
	
	.mt_5 { margin-top: 5px; }
	
	.mt_3 { margin-top: 3px; }
</style>