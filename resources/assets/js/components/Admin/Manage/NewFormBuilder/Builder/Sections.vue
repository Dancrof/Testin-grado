<script setup>

import {ref, computed, onMounted} from "vue";

import draggable from 'vuedraggable';

import { useStore } from 'vuex';
import FESection from "./Elements/FESection.vue";
const store = useStore();

const props = defineProps({
	// Property representing an array of sections
	sections: { type: Array, default: null },
	// Property representing authentication data
	auth : { type : Object, default : ()=>{} },
	// Property indicating if the component is a form group
	isFormGroup: { type: Boolean, default : false },
	
	formType: { type: String, default: '' }
})

// Define a computed property to determine if dragging is disabled
const isDisableDraging = computed(() => store.getters.isDisableDraging);

// Define a reactive reference to track whether dragging is in progress
const isDragInProgress = ref(false);

// Define a computed property to generate drag options
const dragOptions = computed(() => {
	return {
		animation: 200,
		group: 'faveo-form-sections',
		disabled: false,
		ghostClass: 'ghost'
	};
});

// Retrieve and return the original value of the sections property
const originalValue = computed(() => {
	return props.sections;
});

/**
 * Function called when a drag operation is completed
 */
const onDrop = () => {
	isDragInProgress.value = false;
}

/**
 * Function called to show the setting modal with the provided data
 * @param {Object} data - The data to be used for the setting modal
 */
const onShowSettingModal = (data) => {
	
	window.emitter.emit('onEditElement', {'data': data })
}

</script>

<template>

<div class="main-div__formbuilder">

	<draggable v-bind="dragOptions" @end="onDrop" :component-data="{ tag: 'div', type: 'transition-group', name: !isDragInProgress ? 'flip-list' : null }"
	   	class="item-container" :list="originalValue" @start="isDragInProgress = true"
	   	:empty-insert-threshold="230" :disabled="isDisableDraging" itemKey="id" handle=".drag-handle">

		<template #item="{element, index}">

			<FESection :section-data="element" :key="index" :auth="auth" :on-edit-form-field="onShowSettingModal" :formType="formType">
			
			</FESection>
		</template>
	</draggable>
</div>
</template>