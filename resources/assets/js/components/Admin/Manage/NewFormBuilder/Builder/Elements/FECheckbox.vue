<script setup>

import {onBeforeMount, reactive, ref} from "vue";
import FormElementLabel from "./FormElementLabel.vue";
import FormElementActions from "./FormElementActions.vue";
import Fields from "../Fields.vue";

/**
 * Props for the component.
 * @prop {Object} fieldData - The field data object.
 * @prop {Function} onEditFormField - Function to edit form field.
 * @prop {Function} onChildClick - Function to handle click on child.
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

// Ref for the selected option.
const selectedOption = ref([]);
// Ref for the hovering field
const hoveringField = ref('');

const seletedLang = ref('');

onBeforeMount(()=>{
	
	updateNestedValues();
	
	seletedLang.value = props.auth && props.auth.user_data && props.auth.user_data.user_language ? props.auth.user_data.user_language : 'en';
});


/**
 * Function triggered when hovering over a field.
 * Updates the hovering field.
 * @param {Object} value - The hovered field object.
 */
const onHover = (value) => {

	hoveringField.value = value.id
}

const isParentField = ref(false);

/**
 * Function to determine if nested fields should be shown.
 * @param {Object} option - The option object.
 * @param {Array} selVal - The selected option value.
 * @returns {Boolean} - Indicates if nested fields should be shown.
 */
const showNestedFields = (option, selVal) => {

	if(typeof selVal === 'undefined') {

		selVal = selectedOption.value;
	}
	
	if(Boolean(selVal && selVal.id === option.id && option.nodes && option.nodes.length)) {
		
		isParentField.value = true;
	}
	
	return Boolean(selVal && selVal.id === option.id);
}

const onCheckChange = () => {
	
	hoveringField.value = '';
	
	onHover(props.fieldData);
}

const getLabelIndex = (value) => {
	
	if(value.findIndex(obj => obj.language === seletedLang.value) === -1) {
		
		return 0
	} else {
		
		return value.findIndex(obj => obj.language === seletedLang.value)
	}
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

	<div class="fe-checkbox" :class="isParentField ? 'parent_field' : ''">
		
		<div class="fe-checkbox item-group form-field-element px-2" @mouseenter="onHover(fieldData)" @mouseleave="hoveringField = ''">
			
			<div class="row form-field">
				
				<div class="col-md-4 drag-handle">
					
					<FormElementLabel :element-data="fieldData" :is-child="isChild" :auth="auth"></FormElementLabel>
				</div>
				
				<div class="col-sm-5 drag-handle">
					
					<div v-if="fieldData.options.length > 0">
						
						<div class="checkbox" v-for="(checkbox, index) in fieldData.options" :key="index">
							
							<label :for="'checkbox_' + checkbox.id + fieldData.id">
								
								<input type="checkbox" :id="'checkbox_' + checkbox.id + fieldData.id" :name="fieldData.id" :value="checkbox" v-model="selectedOption" class="check-align" @change="onCheckChange"
							       :disabled="fieldData.default">
								<span v-tooltip="checkbox.labels[getLabelIndex(checkbox.labels)].label" class="ms-1">{{ getSubString(checkbox.labels[getLabelIndex(checkbox.labels)].label,20) }}</span>
							</label>
						</div>
					</div>
					
					<div v-else>
						
						<label for="checkbox_preview" style="color:#9a9a9a;">
							
							<input disabled type="checkbox" name="checkbox_preview" id="checkbox_preview" class="check-align">
							Add option
						</label>
					</div>
				</div>
				
				<div class="col-sm-3">

					<FormElementActions v-if="hoveringField === fieldData.id" :on-edit-form-field="onEditFormField" :on-child-click="onChildClick" :selected-option="selectedOption" :element-data="fieldData"
						:sectionDeletable="sectionDeletable"/>
				
				</div>
			</div>
		</div>
		
		<template v-if="fieldData.options && fieldData.options.length !== 0">
			
			<template v-for="(selVal, index) in selectedOption" :key="index">
				
				<template v-for="option in fieldData.options" :key="option.id">
					
					<Fields v-if="showNestedFields(option, selVal)" :list="option.nodes" :isChild="true" :keyVal="option.id" :sectionDeletable="sectionDeletable"/>
				</template>
			</template>
		</template>
	</div>
</template>

<style scoped>

	.form-field-label > input {
		font-weight: 600;
		padding: 5px;
		width: 85%;
		border: 1px dashed #fff;
	}
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
	.check-align{
		vertical-align: bottom;
		position: relative;
		top: -3px;
    margin-right: 5px;
		cursor: pointer;
	}
</style>