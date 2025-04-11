<script setup>

import {onBeforeMount, ref, watch} from "vue";
import FormElementLabel from "./FormElementLabel.vue";
import FormElementActions from "./FormElementActions.vue";
import Fields from "../Fields.vue";

import {MULTIPLE_PROPERTY_HELPER} from "../../../../../../helpers/extraLogics";

/**
 * Props for the component.
 * @prop {Object} fieldData - The field data object.
 * @prop {Boolean} isDisabled - Flag indicating if the component is disabled.
 * @prop {Function} onEditFormField - Function to handle editing form field.
 * @prop {Function} onChildClick - Function to handle click on child elements.
 * @prop {Boolean} isChild - Flag indicating if the component is a child.
 * @prop {Object} auth - Authentication data.
 */
const props = defineProps({

	fieldData: { type: Object, required: true },

	isDisabled: { type: Boolean, default: () => false },

	onEditFormField: { type: Function, required: true },

	onChildClick: { type: Function, required: true },

	isChild: { type: Boolean, default: () => false },

	sectionDeletable: { type: Boolean, default: () => false },

	auth : { type: Object, default : () => {}}
})

/** Selected option for the component. */
const selectedOption = ref('Select option');
/** Hovering field reference. */
const hoveringField = ref('');
/** Selected language reference. */
const seletedLang = ref('');

/** Initializes selected language on component mount. */
onBeforeMount(() => {

	seletedLang.value = props.auth && props.auth.user_data && props.auth.user_data.user_language ? props.auth.user_data.user_language : 'en';

	getDepartmentHelptopicOptions();
})

/** Handles hover event on field. */
const onHover = (value) => {

	hoveringField.value = value.id
}

/** Fetches options for Help Topic and Department fields. */
const getDepartmentHelptopicOptions = () => {

	if (props.fieldData.title === 'Help Topic' || props.fieldData.title === 'Department' || props.fieldData.title === 'Change Type') {

		selectedOption.value = 'Select option';

		const apiConfigObj = getApiConfigObj();

		const params = {'meta': true, 'limit': 'all', 'sort-order': 'asc', 'sort-field': 'id', 'config': true, 'mode': 'config'};

		axios.get(apiConfigObj.apiUrl, {params}).then(resp => {

			if(apiConfigObj.dataKay === 'data') {

				props.fieldData.options = resp.data.data[apiConfigObj.dataKay];

				return
			}

			props.fieldData.options = [];

			let newOptions = resp.data.data[apiConfigObj.dataKay];

			newOptions.map(data => {

				const tmpOption = {
					id: data.id,
					value: data.id,
					labels: [
						{
							id: null,
							language: 'en',
							label: apiConfigObj.dataKay === 'data' ? data.label : data.name
						}
					],
					nodes: data.nodes ? data.nodes : [],
					sort_order: 0
				}

				props.fieldData.options.push(tmpOption);
			});

      if(props.fieldData.options) {
        props.fieldData.options.forEach(option => {
          if (option.nodes && option.nodes.length > 0) {
            processNodes(option.nodes);
          }
        });
      }
		});
	}
}

/** Constructs API configuration object based on field type. */
const getApiConfigObj = () => {

	let apiConfigObj = {};

	let apiUrl = MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(props.fieldData.api_info).url;

	if(apiUrl) {

		apiConfigObj.apiUrl = apiUrl;

	} else if(!apiUrl && props.fieldData.api_info) {

		apiConfigObj.apiUrl = props.fieldData.api_info;
	}

	if (props.fieldData.title === 'Help Topic') {

		apiConfigObj.dataKay = 'help_topics';

	} else if (props.fieldData.title === 'Department') {

		apiConfigObj.dataKay = 'departments';

	} else if (props.fieldData.title === 'Change Type') {

		apiConfigObj.dataKay = 'change_types';

	} else {

		apiConfigObj.dataKay = 'data';
	}

	return apiConfigObj;
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

/** Watches for changes in field data and fetches options if none are available. */
watch(() => props.fieldData, (newValue, oldValue) => {

	if (props.fieldData.options && props.fieldData.options.length === 0) {

		getDepartmentHelptopicOptions();
	}
});

/** Retrieves the index of the label based on the selected language. */
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
				processNodes(option.nodes,tempData.nested_level);
			}
		});
	}
}

window.emitter.on('updateNestedObjects',updateNestedValues);

onBeforeMount(() => {

	updateNestedValues();
})
</script>

<template>

	<div class="fe-select" :class="isParentField ? 'parent_field' : ''">
		
		<div class="item-group form-field-element pe-2" @mouseenter="onHover(fieldData)" @mouseleave="hoveringField = ''">
			
			<div class="row form-field">
				
				<div class="col-md-4 mt_5 drag-handle">
					
					<FormElementLabel :element-data="fieldData" :is-child="isChild" :auth="auth" :labelFieldClass="hoveringField === fieldData.id ? 'field_label' : ''"></FormElementLabel>
				</div>
				
				<div class="col-sm-5 drag-handle">
					
					<select id="select-field-id" class="form-control" :class="isDisabled ? 'drag-handle' : ''" v-model="selectedOption" :disabled="isDisabled">
						
						<option selected>Select option</option>
						
						<option v-for="option in fieldData.options" :key="option.id" v-bind:value="option">

              {{option.labels[getLabelIndex(option.labels)]?.label}}
						</option>
					</select>
				</div>
				
				<div class="col-sm-3 mt_3">
					
					<FormElementActions v-if="hoveringField === fieldData.id" :on-edit-form-field="onEditFormField" :on-child-click="onChildClick" :selected-option="selectedOption" :element-data="fieldData" :sectionDeletable="sectionDeletable"/>
				
				</div>
			</div>
		</div>
		
		<template v-if="fieldData.options && fieldData.options.length !== 0">
			
			<template v-for="option in fieldData.options" :key="option.id">
				
				<Fields v-if="showNestedFields(option)" :list="option.nodes" :isChild="true" :keyVal="option.id" :sectionDeletable="sectionDeletable"/>
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
		top: 8px;
	}
	.form-field { position: relative; }
	
	.mt_5 { margin-top: 5px; }
	
	.mt_3 { margin-top: 3px; }
</style>