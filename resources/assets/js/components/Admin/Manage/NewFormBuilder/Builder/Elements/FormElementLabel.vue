<script setup>

import {computed, onBeforeMount, ref} from "vue";

import globalMixin from "../../../../../../mixins/globalMixin";
const { basePathVersion } = globalMixin.methods;

/**
 * Component properties:
 * - elementData: Object - The data of the element.
 * - isChild: Boolean - Indicates if the component is a child element.
 * - isSection: Boolean - Indicates if the component is a section.
 * - auth: Object - Authentication information.
 */
const props = defineProps({

	elementData: { type: Object, required: true },

	isChild: { type: Boolean, default: () => false },

	isSection : { type : Boolean, default : false },

	auth : { type: Object, default : () => {}},
	
	labelFieldClass: { type: String, default: '' }
})

const imageUrl = ref('/themes/default/client/images/enterarrow.png');

/**
 * Computed property to get the unique key of the element.
 */
const getUniqueKey = computed(()=>{

	return props.elementData.key + '_' + props.elementData.id;
})

const onEnter = () => {

// 	Need to define
}

const seletedLang = ref('');

onBeforeMount(() => {

	seletedLang.value = props.auth && props.auth.user_data && props.auth.user_data.user_language ? props.auth.user_data.user_language : 'en';
})

/**
 * Function to get the index of a label in a given array of labels.
 * @param {Array} value - Array of labels
 * @returns {Number} - Index of the label in the array
 */
const getLabelIndex = (value) => {

	if(value.findIndex(obj => obj.language === seletedLang.value) === -1) {

		return 0
	} else {

		return value.findIndex(obj => obj.language === seletedLang.value)
	}
}

</script>

<template>

	<div :class="isSection ? 'card-title card-form-label' : 'form-field-label'">

<!--		<span v-if="isSection" class="handle ui-sortable-handle drag-handle mr-1">-->
<!--			<i class="fas fa-ellipsis-v mr-1"></i>-->
<!--			<i class="fas fa-ellipsis-v"></i>-->
<!--		</span>-->
<!--		-->
		<img v-if="isChild" id="enter-arrow" width="16" height="16" :src="basePathVersion() + imageUrl" alt="" />

		<ValidationProvider :name="getUniqueKey" rules="required" v-model.trim="elementData.labels[getLabelIndex(elementData.labels)].label">

			<template v-slot="{ field, errorMessage, meta, classes }">

				<input type="text" :name="getUniqueKey" v-model.trim="elementData.labels[getLabelIndex(elementData.labels)].label" :class="errorMessage ? 'field-danger ' + labelFieldClass : '' + labelFieldClass" @keyup.enter="onEnter()"
					v-tooltip="elementData.labels[getLabelIndex(elementData.labels)].label.length > 25 ? elementData.labels[getLabelIndex(elementData.labels)].label : ''"/>

				<div :class="isChild ? 'ml_28' : 'ml_13'">

					<small v-show="errorMessage"><span class="error-block is-danger">{{errorMessage}}</span></small>
				</div>
			</template>
		</ValidationProvider>
	</div>
</template>

<style scoped>
	.card-form-label input {
		font-weight: 600;
		/*width: 500px;*/
		outline: none;
		border: none;
		/*transition: 0.5s;
		-webkit-transition: 0.5s;*/
		background: none;
		font-size: 14px;
	}
	.form-field-label input {
		font-weight: 500;
		width: 85%;
		outline: none;
		border: none;
		/*transition: 0.5s;
		-webkit-transition: 0.5s;*/
		background: none;
		text-align: right;
	}

	.card-form-label input:focus, .form-field-label input:focus {
		border: 1px solid #4e555b40!important;
		background: #fff !important;
	}
	
	.card-form-label input:hover, .form-field-label input:hover {
		border: 1px solid #eee;
		background: #fff !important;
	}
	
	.field-danger {
		border: 1px solid #d73925 !important;
	}
	.ml_13 { margin-left: 13px; }
	.ml_28 { margin-left: 28px; }
</style>