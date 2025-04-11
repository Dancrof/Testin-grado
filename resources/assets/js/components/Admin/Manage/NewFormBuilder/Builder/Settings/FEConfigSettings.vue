<script setup>

import {computed, watch, ref, onBeforeMount, onBeforeUnmount} from "vue";
import APIInfoBlock from "./Mini/APIInfoBlock.vue";

import {useStore} from "vuex";
import {useRoute} from "vue-router";
import globalMixin from "../../../../../../mixins/globalMixin";
const store = useStore();
const route = useRoute();
const disableRequiredEdit = ref(true);
const disableRequiredForAgent = ref(false);
const disableDisplayOnEdit = ref(false);
const disableDisplayForAgent = ref(false);

const { basePath } = globalMixin.methods;

const isEditVisibleAndNotDefault = computed(() => {
  // Check if 'is_edit_visible' is defined, otherwise default to 1 (true)
  const isEditVisible = props.formFieldData.is_edit_visible !== undefined ? props.formFieldData.is_edit_visible : 1;
  return isEditVisible;
});

onBeforeMount(() => {
  // If 'display_on_edit' is true, disable 'display_for_agent'
  if(props.formFieldData.display_on_edit){
    disableDisplayForAgent.value ? disableDisplayForAgent.value : disableDisplayForAgent.value = true;
  }

  // If 'required_on_edit' is true, disable 'required_for_agent'
  if(props.formFieldData.required_on_edit){
    disableRequiredForAgent.value = true;
  }
});

/**
 * Props for the component.
 * @prop {Object} formFieldData - The form field data object.
 */
const props = defineProps({
	formFieldData: { type: Object, required: true },
	from: { type: String, default : ''}
});

/**
 * Computed property to get the form category type from the store.
 */
const formCategoryType = computed(() => store.getters.getFormCategoryType);

watch(() => props.formFieldData.display_for_agent, (newVal) => {
  if (newVal === 1) {
    // If 'display_for_agent' is true, disable 'required_edit' and enable 'display_on_edit'
    disableRequiredEdit.value = !newVal;
    disableDisplayOnEdit.value = newVal;
  } else {
    // If 'display_for_agent' is false, reset related properties
    props.formFieldData.required_for_agent = false;
    props.formFieldData.required_on_edit = false;
    props.formFieldData.required_for_closure = false;
  }
});

watch(() => props.formFieldData.display_on_edit, (newVal) => {
  // Enable or disable 'display_for_agent' based on 'display_on_edit'
  disableDisplayForAgent.value = newVal;
  if (newVal !== 1) {
    // If 'display_on_edit' is false, reset related properties
    props.formFieldData.required_on_edit = false;
    props.formFieldData.required_for_closure = false;
  }
});

watch(() => props.formFieldData.required_for_agent, (newVal) => {
  if(newVal === 1){
    // If 'required_for_agent' is true, reset 'required_on_edit'
    props.formFieldData.required_on_edit = false;
  }
});

watch(() => props.formFieldData.required_on_edit, (newVal) => {
  // Enable or disable 'required_for_agent' based on 'required_on_edit'
  disableRequiredForAgent.value = newVal;
});


/**
 * Method to handle checkbox click event.
 * @param {string} key - The key of the property to update.
 */
const  onCheckboxClick = (key) => {

	props.formFieldData[key] = false;
}

/**
 * Method to update the API information.
 * @param {any} apiInfo - The new API information.
 */
const updateApiInfo = (apiInfo) => {

	props.formFieldData['api_info'] = apiInfo;
}
</script>

<template>

	<div class="pt-2 ps-2 pe-2 pb-0">

		<div class="row" v-if="formFieldData.is_configurable">

			<div v-if="formFieldData.is_agent_config" class="col-md-12 form-group">

				<label>{{trans('agent')}}</label>

				<div class="form-check">
          <!-- Checkbox for displaying the form field for agents -->
					<input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.display_for_agent" id="display-for-agent" @click="onCheckboxClick('required')" :disabled="(formFieldData.default && formFieldData.data_type === 'section') || disableDisplayForAgent">

					<label class="form-check-label" for="display-for-agent">{{trans('display_in_form')}}</label>
				</div>

				<div class="form-check" v-if="formFieldData.title !== 'Captcha' && formFieldData.data_type !== 'section'">
          <!-- Checkbox for making the form field required for agents -->
					<input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.required_for_agent" :disabled="(!formFieldData.display_for_agent && formFieldData.title !== 'Captcha') || disableRequiredForAgent" id="required-for-agent">

					<label class="form-check-label" for="required-for-agent">{{trans('required_when_submitting_the_form')}}</label>
				</div>

        <div class="form-check" v-if="formCategoryType === 'ticket' && formFieldData.title !== 'Captcha' && formFieldData.data_type !== 'section' && formFieldData.data_type !== 'file' && isEditVisibleAndNotDefault">
          <!-- Checkbox for displaying the form field on edit -->
          <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.display_on_edit" :disabled="formFieldData.title === 'Captcha' || formFieldData.display_for_agent" id="display_on_edit">

          <label class="form-check-label" for="display_on_edit">{{trans('display_on_edit')}}</label>
        </div>

        <div class="form-check" v-if="formCategoryType === 'ticket' && formFieldData.title !== 'Captcha' && formFieldData.data_type !== 'section' && formFieldData.data_type !== 'file' && isEditVisibleAndNotDefault">
          <!-- Checkbox for making the form field required on edit -->
          <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.required_on_edit" :disabled="(!formFieldData.display_on_edit && !formFieldData.display_for_agent) || formFieldData.required_for_agent" id="required_on_edit">

          <label class="form-check-label" for="required_on_edit">{{trans('required_on_edit')}}</label>
        </div>

        <div class="form-check" v-if="formCategoryType === 'ticket' && formFieldData.title !== 'Captcha' && formFieldData.data_type !== 'section' && formFieldData.data_type !== 'file' && isEditVisibleAndNotDefault">
          <!-- Checkbox for making the form field required for closure -->
          <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.required_for_closure" :disabled="!formFieldData.display_for_agent && !formFieldData.display_on_edit" id="required_for_closure">

          <label class="form-check-label" for="required_for_closure">{{trans('required_on_closure')}}</label>
        </div>

			</div>

			<div v-if="formFieldData.is_user_config" class="col-md-12 form-group mb-3">

				<label>{{trans('client')}}</label>

				<div class="form-check">

					<input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.display_for_user" id="display-for-client" @click="onCheckboxClick('required_for_user')" :disabled="formFieldData.default && formFieldData.data_type === 'section'">

					<label class="form-check-label" for="display-for-client">{{trans('display_in_form')}}</label>
				</div>

				<div class="form-check" v-if="formFieldData.title !== 'Captcha' && formFieldData.data_type !== 'section'">

					<input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.required_for_user" :disabled="!formFieldData.display_for_user && formFieldData.title !== 'Captcha'" id="required-for-client">

					<label class="form-check-label" for="required-for-client">{{trans('required_when_submitting_the_form')}}</label>
				</div>
			</div>
		</div>

		<APIInfoBlock v-if="formFieldData.title === 'Api'" :form-field-data="formFieldData" :update-api-info="updateApiInfo"></APIInfoBlock>

		<div class="row mb-3">

			<div class="col-md-12 form-group" v-if="!formFieldData.default && formFieldData.data_type !== 'section' && from !== 'ticket-fields-form'">

				<label for="shortcode">{{trans('shortcode')}}</label> <i class="fas fa-question-circle text-primary" v-tooltip="{ content : trans('ticket_custom_field_shortcode_value'), html : true}"></i>

				<input type="text" name="shortcode" id="shortcode" @keydown.space.prevent class="form-control" v-model="formFieldData.shortcode"/>
			</div>

			<div class="col-md-12 form-group" v-if="formFieldData.title ==='Captcha'" style="padding-top: 10px;">

				<p>
					<strong>{{trans('captcha_config_message')}} <a :href="basePath() + '/recaptcha'" target="_new" style="text-decoration:underline">{{trans('here')}}</a></strong>
				</p>
			</div>
		</div>

		<template v-if="formFieldData.title === 'Description' && formFieldData.title !== 'Captcha'">

			<div v-if="formCategoryType === 'ticket'" class="row">

				<div class="col-md-12 form-group">

					<div class="form-check">

						<input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" id="add-media-cb" v-model="formFieldData.media_option">

						<label for="add-media-cb">{{trans('can_agent_add_media')}}</label>
					</div>
				</div>
			</div>
		</template>

		<div v-if="formFieldData.data_type === 'mobile'" class="row">

			<div class="col-md-12 form-group">

				<div class="form-check">

					<input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.enable_extension" id="mobile-ext">

					<label class="form-check-label" for="mobile-ext">{{trans('enable_extension')}}</label>
				</div>
			</div>
		</div>

		<div v-if="formFieldData.data_type === 'date'" class="row">

			<div class="col-md-12 form-group">
				
				<div class="form-check">
					
					<input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.request_time_information" id="date-time">
					
					<label class="form-check-label" for="date-time">{{ trans('request_time_information') }}</label>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>

	.form-check-input {
    cursor: pointer !important;
    top: -7px !important;
  }

  .form-check-label{
    font-weight: normal !important;
  }
</style>