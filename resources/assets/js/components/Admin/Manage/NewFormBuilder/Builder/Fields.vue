<script setup>

import {ref, computed, onBeforeMount, onMounted} from "vue";

import draggable from 'vuedraggable';

import { useStore } from 'vuex';
const store = useStore();

import FESimpleFields from "./Elements/FESimpleFields.vue";
import FESelect from "./Elements/FESelect.vue";
import FECheckbox from "./Elements/FECheckbox.vue";
import FERadio from "./Elements/FERadio.vue";
import FEGroupField from "./Elements/FEGroupField.vue";
import FECustom from "./Elements/FECustom.vue";
import FESection from "./Elements/FESection.vue";
import FEMobile from "./Elements/FEMobile.vue";

/**
 * Props for the draggable item component.
 * - list: The list of items.
 * - isChild: Indicates if the item is a child element.
 * - keyVal: The key value of the item.
 * - dragGroupId: The drag group ID.
 * - onFieldEdit: Function to handle field editing.
 * - onEditClose: Function to handle closing field editing.
 * - auth: Authentication object.
 * - isFormGroup: Indicates if the item is a form group.
 */
const props = defineProps({

	list: { type: Array, default: null },

	isChild: { type: Boolean, default: () => false },

	keyVal : { type : [String, Number], default : '' },

	dragGroupId : { type : [String, Number], default : '' },

	onFieldEdit : { type : Function, default : ()=> {} },

	onEditClose : { type : Function, default : ()=> {} },

	auth : { type : Object, default : ()=>{} },

	isFormGroup: { type: Boolean, default : false },

	sectionDeletable: { type: Boolean, default : false },

	formType: { type: String, default: '' }
})

// Computed property to determine if dragging is disabled.
const isDisableDraging = computed(() => store.getters.isDisableDraging);
// Reference to indicate if a drag operation is in progress.
const isDragInProgress = ref(false);
// Reference to the menu items.
const menuItems = ref(null);
// Reference to the selected form field object.
const selectedFormFieldObject = ref(null);
// Reference to indicate if the field setting modal is visible.
const showSettingModal= ref(false);

onBeforeMount(()=>{

	menuItems.value = store.getters.getFormMenus;
});

onMounted(()=>{

	window.emitter.on('formFieldSettingsApplied', onCloseSettingModal);
	
	window.emitter.on('formFieldSettingsClosed', onCloseSettingModal);
});

/**
 * Computed property for drag options.
 */
const dragOptions = computed(() => {
	return {
		animation: 200,
		group: {
			put : props.isChild ? ["faveo-form-builder-" + (props.keyVal ? props.keyVal : Math.random())] : props.dragGroupId ? ["faveo-form-builder", props.dragGroupId] : ["faveo-form-builder"],
			name : props.isChild ? "faveo-form-builder-" + (props.keyVal ? props.keyVal : Math.random()) : props.dragGroupId ? props.dragGroupId : 'faveo-form-builder'
		},
		disabled: false,
		ghostClass: 'ghost'
	};
});

/**
 * Computed property for the original value.
 */
const originalValue = computed(() => {
	return props.value ? props.value : props.list;
});

/**
 * Function to handle drop event.
 */
const onDrop = () => {
	isDragInProgress.value = false;
}

/**
 * Function to get the class name based on the selected form field object.
 * @param {Object} value - The form field object.
 * @returns {string} - The class name.
 */
const getClass = (value = "") => {

	let classname = "";

	if (selectedFormFieldObject.value && value.id === selectedFormFieldObject.value.id) {

		classname += ' field-active ';

	}

	return classname;
}

const emit = defineEmits(['input']);

/**
 * Event emitter for drag change event.
 * @param {any} value - The value to emit.
 */
const dragChangeEventEmitter = (value) => {
	emit('input', value);
}

/**
 * Function to check if a field is a simple field.
 * @param {Object} field - The field object.
 * @returns {boolean} - Whether the field is a simple field or not.
 */
const isSimpleFields = (field) => {

	const simpleFields = ['text', 'number', 'decimal', 'date', 'email', 'file', 'image', 'textarea', 'htmltextarea', 'taggable'];

	return simpleFields.indexOf(field.data_type) > -1;
};

/**
 * Function to check if a select box should be disabled.
 * @param {Object} field - The field object.
 * @returns {boolean} - Whether the select box should be disabled or not.
 */
const isDisableSelectBox = (field) => {

	if(props.formType !== 'helpdesk') {

		return field.default === 1 && field.title !=='Change Type';
	}
	
	return field.default === 1 && field.title !=='Help Topic' && field.title !== 'Department';
}

/**
 * Function to handle click event on child element.
 * @param {number} childElementIndex - Index of the child element.
 * @param {Object} selectedOption - The selected option object.
 */
const onChildClick = (childElementIndex, selectedOption) => {

	let clonedMenuItem = JSON.parse(JSON.stringify(menuItems.value));

	const currentTimestamp = getCurrentTimestamp();

	clonedMenuItem[childElementIndex].form_identifier = currentTimestamp;

	clonedMenuItem[childElementIndex].id = currentTimestamp;

	if(Array.isArray(selectedOption)) {

		for (let i = 0; i < selectedOption.length; i++) {

			selectedOption[i].nodes.push(clonedMenuItem[childElementIndex]);
		}

	} else {

		selectedOption.nodes.push(clonedMenuItem[childElementIndex]);
	}
	
	window.emitter.emit('updateNestedObjects');
}

/**
 * Function to show the setting modal.
 * @param {Object} data - The data object.
 */
const onShowSettingModal = (data) => {

	selectedFormFieldObject.value = data;

	window.emitter.emit('onEditElement', {'data': data })
}

/**
 * Function to close the setting modal.
 */
const onCloseSettingModal = () => {

	selectedFormFieldObject.value = null;

	showSettingModal.value = false;

	props.onEditClose();
	
	getClass();
	
	window.emitter.emit('updateNestedObjects');
}

/**
 * Function to get the current timestamp.
 * @returns {number} - The current timestamp.
 */
const getCurrentTimestamp = () => {
	return new Date().getTime();
}
</script>

<template>

	<div class="main-div__formbuilder">

		<draggable v-bind="dragOptions" @end="onDrop" :component-data="{ tag: 'div', type: 'transition-group', name: !isDragInProgress ? 'flip-list' : null }"
		   	class="item-container" :list="originalValue" @start="isDragInProgress = true" handle=".drag-handle"
		   	@input="dragChangeEventEmitter" :empty-insert-threshold="230" :disabled="isDisableDraging" itemKey="id">

			<template #item="{element, index}">

				<FESection v-if="element.data_type === 'section'" :section-data="element" :key="index" :auth="auth" :on-edit-form-field="onShowSettingModal"></FESection>

				<div v-else :key="element.groupid || element.id" class="mb-1" :class="getClass(element)">

					<FESimpleFields v-if="isSimpleFields(element) || element.title === 'Api'" :field-data="element" :on-edit-form-field="onShowSettingModal" :isChild="isChild" :auth="auth" :sectionDeletable="sectionDeletable">

					</FESimpleFields>
					
					<FEMobile v-if="element.data_type === 'mobile'" :field-data="element" :on-edit-form-field="onShowSettingModal" :isChild="isChild" :auth="auth" :sectionDeletable="sectionDeletable">
					
					</FEMobile>

					<FESelect v-if="element.title !== 'Api' && (element.data_type === 'api' || element.data_type === 'select' || element.data_type === 'select2' || element.data_type === 'multiselect'|| element.data_type === 'taggable-api')" :field-data="element" :isDisabled="isDisableSelectBox(element)" :on-edit-form-field="onShowSettingModal" :on-child-click="onChildClick" :isChild="isChild" :auth="auth"
				          :sectionDeletable="sectionDeletable">

					</FESelect>

					<FECheckbox v-if="element.data_type === 'checkbox'" :field-data="element" :on-edit-form-field="onShowSettingModal" :on-child-click="onChildClick" :isChild="isChild" :auth="auth" :sectionDeletable="sectionDeletable"></FECheckbox>

					<FERadio v-if="element.data_type === 'radio'" :field-data="element" :on-edit-form-field="onShowSettingModal" :on-child-click="onChildClick" :isChild="isChild" :auth="auth" :sectionDeletable="sectionDeletable"></FERadio>

					<FEGroupField v-if="element.data_type === 'group'" :field-data="element" :isChild="isChild" :auth="auth" :sectionDeletable="sectionDeletable"></FEGroupField>

					<FECustom v-if="element.data_type === 'custom'" :field-data="element" :on-edit-form-field="onShowSettingModal" :isChild="isChild" :auth="auth" :sectionDeletable="sectionDeletable"></FECustom>
				</div>
			</template>
		</draggable>
	</div>
</template>

<style scoped>
	.column-2 {
		column-count: 2;
	}
	.item-container {
		background-color: #fff;
	}
	.dropdown-menu {
		left: -125px;
		top: -125px;
	}
	.item {
		margin: 0.3rem;
		padding: 1rem;
		border: solid #dedddd 1px;
	}
	
	.form-field-label > input {
		padding: 5px;
		border: 1px dashed #fff;
		text-align: right;
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
	.form-field:hover .form-field-actions-btn{
		visibility: visible;
	}
	.fb__icon {
		cursor: pointer;
		color: #545454;
	}

	.border-col {
		border: 1px dashed #c0c3c4;
		border-radius: 0.25rem;
		padding: 5px;
		min-height: 80px;
	}
</style>

<style lang="css">
	.form-field:hover .form-field-actions-btn{
		visibility: visible;
	}
</style>