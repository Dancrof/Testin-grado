<script setup>

import {ref} from "vue";

import {useRouter} from "vue-router";
const router = useRouter();

import globalMixin from "../../../../../../mixins/globalMixin";
import FormElementActions from "./FormElementActions.vue";
const { basePathVersion } = globalMixin.methods;

/**
 * Props for the component.
 * @prop {Object} fieldData - The field data object.
 * @prop {Boolean} isChild - Flag indicating if it's a child field.
 * @prop {Object} auth - Authentication data.
 */
const props = defineProps({

	fieldData: { type: Object, required: true },

	isChild: { type: Boolean, default: () => false },

	sectionDeletable: { type: Boolean, default: () => false },

	auth : { type: Object, default : () => {}}
})

const imageUrl = ref('/themes/default/client/images/enterarrow.png');
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

/**
 * Function to navigate to edit form field.
 */
const onEditFormField = () => {

	router.push({ path : this.fieldData.edit_url });
}
</script>

<template>

	<div class="row form-field" @mouseenter="onHover(fieldData)" @mouseleave="hoveringField = ''">

		<div class="col-md-4 form-field-label">

			<img width="16" height="16" id="enter-arrow" v-if="isChild" :src="basePathVersion() + imageUrl" alt="">

			<input type="text" readonly :value="fieldData.name">
		</div>

		<div class="col-sm-8">

			<input class="form-control" type="text" :placeholder="lang('this_is_form_group')" disabled />
		</div>

		<div class="form-action-btn-div" style="display: flex;" v-if="hoveringField === fieldData.id">

			<span class="space-filler"></span>

			<div class="form-field-actions-btn">

				<FormElementActions :on-edit-form-field="onEditFormField" :element-data="fieldData" :sectionDeletable="sectionDeletable"/>
			</div>
		</div>
	</div>
</template>

<style lang="css" scoped>
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
		top: 8px;
	}
	.form-field { position: relative; }
</style>