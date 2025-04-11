<script setup>

import {computed, ref} from "vue";

import globalMixin from "../../../../../../mixins/globalMixin";
const { basePathVersion } = globalMixin.methods;

import FormElementLabel from "./FormElementLabel.vue";
import FormElementActions from "./FormElementActions.vue";
import Fields from "../Fields.vue";

/**
 * Props for the component.
 * @prop {Object} sectionData - The section data object.
 * @prop {Object} auth - Authentication data.
 * @prop {Function} onEditFormField - Function to handle editing form field.
 */
const props = defineProps({

	sectionData: { type: Object, required: true },

	auth : { type : Object, default : ()=>{} },

	onEditFormField: { type: Function, default: () => {} },
	
	formType: { type: String, default: '' }
})

const hoveringSection = ref('');

/**
 * Computed property to determine if there are no records in a section.
 */
const noRecordsInSection = computed(() => {

	const firstEmpty = props.sectionData.form_fields && props.sectionData.form_fields.first ? props.sectionData.form_fields.first.length === 0 : false;

	const secondEmpty = props.sectionData.form_fields && props.sectionData.form_fields.second ? props.sectionData.form_fields.second.length === 0 : false;

	switch (true) {
		case firstEmpty && secondEmpty:
			return "both";
		case firstEmpty && !props.sectionData.form_fields.second:
			return "first";
		case !props.sectionData.form_fields.first && secondEmpty:
			return "second";
		default:
			return null;
	}
});

/**
 * Function triggered when clicking on a column.
 * Updates the section data based on the column type and value.
 * @param {string} type - The type of column ('single' or 'double').
 * @param {Object} value - The section data object.
 */
const onColumnClick = (type,value) => {

	if(type === 'single') {

		if(value.form_fields.first && value.form_fields.second) {

			value.form_fields.first = [...value.form_fields.first, ...value.form_fields.second];

			value.form_fields.first.forEach(item => { item.column = 'first'; });

			delete value.form_fields.second;

		} else if(!value.form_fields.first && value.form_fields.second) {

			value.form_fields.second.forEach(item => { item.column = 'first'; });
		}
	}

	if (type === 'double') {

		if(!value.form_fields.second) {

			value.form_fields.second = [];
		}

		if(!value.form_fields.first) {

			value.form_fields.first = [];
		}
	}
}

/**
 * Function to handle hovering over a field
 * @param {Object} value - The value of the hovered field
 */
const onHover = (value) => {
	
	hoveringSection.value = value.id
}

const hoveringSectionHead = ref('');

/**
 * Function to handle hovering over a field head
 * @param {Object} value - The value of the hovered field
 */
const onHoverCardHead = (value) => {

	hoveringSectionHead.value = value.id
}

</script>

<template>

	<div class="mt-2 mb-2 section-card" @mouseenter="onHover(sectionData)" @mouseleave="hoveringSection = ''" :class="hoveringSection === sectionData.id ? 'card-light' : ''">

		<div class="card-header p-2 section-header" @mouseenter="onHoverCardHead(sectionData)" @mouseleave="hoveringSectionHead = ''">

			<div class="row">
				
				<div class="col-sm-4 drag-handle">
					
					<FormElementLabel :element-data="sectionData" :isSection="true" :auth="auth" :labelFieldClass="hoveringSection === sectionData.id ? 'section_label' : ''"></FormElementLabel>
					
				</div>
				
				<div class="col-sm-8 text-end drag-handle">
					
					<FormElementActions v-if="hoveringSectionHead === sectionData.id" :isSection="true" :element-data="sectionData" :on-column-click="onColumnClick"
					                    :on-edit-form-field="onEditFormField">
					
					</FormElementActions>
				</div>
			</div>
		</div>

		<div class="card-body pt-2 px-2 min-h-100">

			<template v-if="noRecordsInSection">

				<div class="text-center no-drag-fields">

					<img :src="basePathVersion()+'/themes/default/common/images/drag.png'" alt="form-no-drag"
						 class="no-drag-img">

					<p>{{ trans('drag_an_element_from_the_left') }}</p>
				</div>
			</template>
			
			<div class="row px-1">

				<template v-if="props.sectionData.form_fields.first && props.sectionData.form_fields.second">

					<div class="col-sm-6">

						<Fields :list="sectionData.form_fields.first" :keyVal="sectionData.id" :dragGroupId="'section-'+sectionData.id" :auth="auth" :formType="formType" :sectionDeletable="sectionData.is_deletable"></Fields>
					</div>

					<div class="col-sm-6">

						<Fields :list="sectionData.form_fields.second" :keyVal="sectionData.id" :dragGroupId="'section-'+sectionData.id" :auth="auth" :formType="formType" :sectionDeletable="sectionData.is_deletable"></Fields>
					</div>
				</template>

				<template v-if="props.sectionData.form_fields.first && !props.sectionData.form_fields.second">

					<div class="col-sm-6">

						<Fields :list="sectionData.form_fields.first" :keyVal="sectionData.id" :dragGroupId="'section-'+sectionData.id" :auth="auth" :formType="formType" :sectionDeletable="sectionData.is_deletable"></Fields>
					</div>
				</template>

				<template v-if="props.sectionData.form_fields.second && !props.sectionData.form_fields.first">

					<div class="col-sm-6">

						<Fields :list="sectionData.form_fields.second" :keyVal="sectionData.id" :dragGroupId="'section-'+sectionData.id" :auth="auth" :formType="formType" :sectionDeletable="sectionData.is_deletable"></Fields>
					</div>
				</template>
			</div>
		</div>
	</div>
</template>

<style scoped>

.no-drag-fields {opacity: 0.3;}

.no-drag-img { width: 60px; height: 60px; }

.min-h-100 { min-height: 100px !important; }

/*.section-card { cursor: move; }*/
</style>