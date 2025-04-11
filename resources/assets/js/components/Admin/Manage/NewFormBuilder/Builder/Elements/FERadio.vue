<script setup>

import {onBeforeMount, ref} from "vue";
import FormElementLabel from "./FormElementLabel.vue";
import FormElementActions from "./FormElementActions.vue";
import Fields from "../Fields.vue";

/**
 * Props for the component.
 * @prop {Object} fieldData - The field data object.
 * @prop {Function} onEditFormField - Function to handle editing form field.
 * @prop {Function} onChildClick - Function to handle click on child field.
 * @prop {Boolean} isChild - Flag indicating if it's a child field.
 * @prop {Object} auth - Authentication data.
 */
const props = defineProps({

	fieldData: { type: Object, required: true },

	onEditFormField: { type: Function, required: true },

	onChildClick: { type: Function, required: true },

	isChild: { type: Boolean, default: () => false },

	sectionDeletable: { type: Boolean, default: () => false },

	auth : { type: Object, default : () => {}}
})

// Ref for the selected option
const selectedOption = ref(null);
// Ref for the hovering field.
const hoveringField = ref('');
// Ref for the selected language.
const seletedLang = ref('');

/**
 * Function triggered when hovering over a field.
 * Updates the hovering field.
 * @param {Object} value - The hovered field object.
 */
const onHover = (value) => {

	hoveringField.value = value.id
}

/**
 * Lifecycle hook before mounting the component.
 * Sets the selected language based on authentication data.
 */
onBeforeMount(()=>{
	
	updateNestedValues();
	
	seletedLang.value = props.auth && props.auth.user_data && props.auth.user_data.user_language ? props.auth.user_data.user_language : 'en';
});

/**
 * Function to get the index of a label for the selected language.
 * @param {Array} value - The array of label objects.
 * @returns {number} - The index of the label for the selected language.
 */
const getLabelIndex = (value) => {

	if(value.findIndex(obj => obj.language === seletedLang.value) === -1) {

		return 0
	} else {

		return value.findIndex(obj => obj.language === seletedLang.value)
	}
}

const onRadioChange = (event) => {
	
	event.target.checked = true;
}

const isParentField = ref(false);

/** Determines if nested fields should be shown based on selected option. */
const showNestedFields = (option, selectedOptionVal) => {
	
	if(typeof selectedOptionVal === 'undefined') {
		
		selectedOptionVal = selectedOption.value;
	}
	
	if(selectedOptionVal && selectedOptionVal.id === option.id && option.nodes && option.nodes.length) {
		
		isParentField.value = true;
	}
	
	return selectedOptionVal && selectedOptionVal.id === option.id;
}


const tempData = props.fieldData

let loopCount = 0;
let maxDepth = 0;

function processNodes(nodes, nestedLevel, depth = 1) {
	// Update maxDepth if the current depth is greater
	if (depth > maxDepth) {
		maxDepth = depth;
	}
	
	nodes.forEach(node => {
		// Increment loop count for each node processed
		loopCount++;
		
		// Check if depth is greater than or equal to 3
		if (nestedLevel && depth >= nestedLevel) {
			if (node.options) {
				node.options.forEach(option => {
					option.extraKey = "extraValue"; // Add the extra key here
				});
			}
		}
		
		// If the node has options, recursively process them
		if (node.options && node.options.length > 0) {
			node.options.forEach(option => {
				if (option.nodes && option.nodes.length > 0) {
					processNodes(option.nodes, node.nested_level, depth + 1);
				}
			});
		}
	});
}

const updateNestedValues = () => {
	
	if(tempData.options) {
		tempData.options.forEach(option => {
			if (option.nodes && option.nodes.length > 0) {
				processNodes(option.nodes, tempData.nested_level);
			}
		});
	}
}
window.emitter.on('updateNestedObjects',updateNestedValues);

</script>

<template>

	<div class="fe-radio" :class="isParentField ? 'parent_field' : ''">
		
		<div class="fe-radio item-group form-field-element pe-2" @mouseenter="onHover(fieldData)" @mouseleave="hoveringField = ''">
			
			<div class="row form-field">
				
				<div class="col-md-4 drag-handle">
					
					<FormElementLabel :element-data="fieldData" :is-child="isChild" :auth="auth"></FormElementLabel>
				</div>
				
				<div class="col-sm-5 drag-handle">
					
					<div v-if="fieldData.options.length > 0">
						
						<div class="radio" v-for="radio in fieldData.options" :key="radio.id">
							
							<label :for="'radio_' + radio.id + fieldData.id">
								
								<input type="radio" :name="fieldData.id" :id="'radio_' + radio.id + fieldData.id" v-model="selectedOption" :value="radio" class="radio-align" @change="onRadioChange">
								
								<span v-tooltip="radio.labels[getLabelIndex(radio.labels)].label" class="ms-1">{{ getSubString(radio.labels[getLabelIndex(radio.labels)].label,20) }}</span>
							</label>
						</div>
					</div>
					
					<div v-else>
						
						<label for="radio_preview" style="color:#9a9a9a;">
							
							<input disabled type="radio" name="radio_preview" id="radio_preview" class="radio-align">
							Add option
						</label>
					</div>
				</div>
				
				<div class="col-sm-3">
					
					<FormElementActions v-if="hoveringField === fieldData.id" :on-edit-form-field="onEditFormField" :on-child-click="onChildClick" :selected-option="selectedOption" :element-data="fieldData" :sectionDeletable="sectionDeletable"/>
				
				</div>
			</div>
		</div>
		
		<template v-if="fieldData.options && fieldData.options.length !== 0">
			
			<template v-for="option in fieldData.options" :key="option.id">
				
				<Fields v-if="showNestedFields(option)" :list="option.nodes" :isChild="true"
				        :keyVal="option.id" :sectionDeletable="sectionDeletable"/>
			</template>
		</template>
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
		top: 2px;
	}
	.form-field { position: relative; }

	.radio-align {
		vertical-align: bottom;
		position: relative;
		top: -3px;
    margin-right: 5px;
		cursor: pointer;
	}
</style>