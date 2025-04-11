<script setup>

import {onBeforeMount, ref} from "vue";

import {MULTIPLE_PROPERTY_HELPER} from "../../../../../../../helpers/extraLogics";
import _ from 'lodash-core';
import ToolTip from "../../../../../../MiniComponent/ToolTip.vue";

/**
 * Props for the component.
 * @prop {Object} formFieldData - The form field data object.
 * @prop {Function} updateApiInfo - Function to update the API information.
 */
const props = defineProps({

	formFieldData: { type: Object, required: true },

	updateApiInfo: { type: Function, required: true }
})

// Ref for the API information object.
const apiInfoObj = ref(null);

/**
 * Hook that runs before the component is mounted.
 * Converts the API information string to an object.
 */
onBeforeMount(()=>{

	apiInfoObj.value = MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(props.formFieldData.api_info)
})

/**
 * Debounced method triggered on change.
 * Converts the API information object to a string and calls the update function.
 */
const onChange = _.debounce(() => {
	props.updateApiInfo(MULTIPLE_PROPERTY_HELPER.convertObjectOfPropertiesToString(apiInfoObj.value));
}, 350);

</script>

<template>

	<div class="row">

		<div class="col-md-12 form-group mb-3">

			<label for="apiendpoint">{{lang('api_endpoint')}}</label>

			<ToolTip :message="lang('api_endpoint')" size="small"></ToolTip>

			<div class="input-group" style="width: 100%">

				<input type="text" class="form-control" id="apiendpoint" v-model.trim="apiInfoObj.url" @input="onChange()" placeholder="https://testapi.com/my/api/path">
			</div>
		</div>

		<div class="col-md-12 form-group mb-3">

			<label for="apiendpoint">{{lang('property_to_map')}}</label>

			<ToolTip :message="lang('this_property_will_get_saved_when_user_submit_the_form')" size="small"></ToolTip>

			<div class="input-group" style="width: 100%">

				<input type="text" class="form-control" id="apiendpoint" v-model.trim="apiInfoObj.key" @input="onChange()" placeholder="id">
			</div>
		</div>
	</div>
</template>