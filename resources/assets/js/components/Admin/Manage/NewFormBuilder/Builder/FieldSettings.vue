<script setup>

import {onBeforeMount, ref, computed, onUnmounted} from "vue";

import {useStore} from "vuex";
const store = useStore();

import globalMixin from "../../../../../mixins/globalMixin";
const { basePathVersion } = globalMixin.methods;

import {lang} from "../../../../../helpers/extraLogics";
import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

import draggable from "vuedraggable";
import FEConfigSettings from "./Settings/FEConfigSettings.vue";
import FEFieldValidation from "./Settings/FEFieldValidation.vue";
import FEAddLanguage from "./Settings/FEAddLanguage.vue";
import NestedFieldOptions from "./Settings/Mini/NestedFieldOptions.vue";
import Modal from "../../../../Common/Modal.vue";
import Alert from "../../../../MiniComponent/Alert.vue";

/**
 * Component props:
 * - fieldData: The field data object. Required.
 * - isShowSettingModal: Boolean to control the visibility of the setting modal. Default is false.
 * - onCloseSettingModal: Function to handle closing the setting modal.
 * - title: The title of the setting modal. Default is an empty string.
 * - auth: The authentication object. Default is an empty function.
 * - showCloseBtn: Boolean to control the visibility of the close button. Default is true.
 * - fieldUpdate: Function to handle field update. Default is an empty function.
 * - from: The source of the modal. Default is an empty string.
 */
const props = defineProps({

	fieldData: { type: Object, required: true },

	isShowSettingModal: { type: Boolean, default: false },

	onCloseSettingModal: { type: Function },

	title: { type: String, default: '' },

	auth : { type : Object, default : ()=>{} },

	showCloseBtn : { type: Boolean, default: true },

	fieldUpdate: { type: Function, default: ()=> {} },

	from: { type: String, default: '' },
	
	settingBtnName : { type: String, default : 'apply' },
	
	showInModal: { type: Boolean, default: true }

});

/**
 * Reactive variables:
 * - isLoading: Boolean to indicate loading state.
 * - containerStyle: Object containing styles for the modal container.
 * - fieldSettingData: Ref to hold the field setting data.
 * - newOption: Ref to hold the value of a new option.
 * - currentTab: Ref to track the current tab.
 * - addOptionInputHelp: Ref to hold help text for adding options.
 * - seletedLang: Ref to hold the selected language.
 */
const isLoading = ref(false);
const containerStyle = ref({ width: '800px' });
const fieldSettingData = ref(null);
const newOption = ref('');
const currentTab = ref('');
const addOptionInputHelp = ref('');
const seletedLang = ref('');
const systemLang = ref('');

onBeforeMount(()=>{

	seletedLang.value = props.auth && props.auth.user_data && props.auth.user_data.user_language ? props.auth.user_data.user_language : 'en';

	systemLang.value = props.auth && props.auth.user_data && props.auth.user_data.user_language ? props.auth.user_data.user_language : 'en';

	fieldSettingData.value = props.fieldData;
});

/**
 * Function to get the index of the label based on the selected language.
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

/**
 * Function to set the selected language.
 * @param {string} value - The selected language value.
 */
const selectedLanguage = (value) => {

	seletedLang.value = value
}

/**
 * Computed property to determine which tabs to show in the setting modal.
 * @returns {Array} - The array of tabs to be displayed.
 */
const tabsToShow = computed(()=>{

	const MODAL_TABS = [
		{ id: 0, value: 'configuration', show: true, label: 'settings' },
		{ id: 1, value: 'addOption', show: true, label: 'addOption' },
		{ id: 2, value: 'validation', show: true, label: 'validation' },
		{ id: 3, value: 'language', show: true, label: 'configuration' }
	];
	if(isHideConfigurationTab()) {
		MODAL_TABS[0].show = false;
	}
	if(isHideAddOptionTab()) {
		MODAL_TABS[1].show = false;
	}
	if(isHideValidationTab()) {
		MODAL_TABS[2].show = false;
	}
	if(isHideLanguageTab()) {
		MODAL_TABS[3].show = false;
	}
	const validTabs = MODAL_TABS.filter((tabs) => tabs.show );
	currentTab.value = validTabs.length !== 0 ? validTabs[0].value : '';

	return validTabs
})

/**
 * Function to determine if a tab is visible based on its value.
 * @param {string} value - The value of the tab.
 * @returns {boolean} - True if the tab is visible, false otherwise.
 */
const isVisible = (value) => {

	return tabsToShow.value.some(obj => obj.value === value)
}

/**
 * Function to determine if the Language tab should be hidden.
 * @returns {boolean} - True if the Language tab should be hidden, false otherwise.
 */
const isHideLanguageTab = () => {

	return fieldSettingData.value.title === 'Captcha';
}

/**
 * Function to determine if the Configuration tab should be hidden.
 * @returns {boolean} - True if the Configuration tab should be hidden, false otherwise.
 */
const isHideConfigurationTab = () => {

	if(!fieldSettingData.value.is_configurable) {

		return true;
	}

	const mandatoryFields = ['First Name', 'Last Name', 'Requester'];

	return mandatoryFields.includes(fieldSettingData.value.title);
}

/**
 * Function to determine if the Validation tab should be hidden.
 * @returns {boolean} - True if the Validation tab should be hidden, false otherwise.
 */
const isHideValidationTab = () => {

	return !Boolean((fieldSettingData.value.data_type === 'text' || fieldSettingData.value.data_type === 'textarea' || fieldSettingData.value.data_type === 'htmltextarea') && !fieldSettingData.value.default);
}

/**
 * Function to determine if the Add Option tab should be hidden.
 * @returns {boolean} - True if the Add Option tab should be hidden, false otherwise.
 */
const isHideAddOptionTab = () => {

	const nestedTypes = ['select', 'radio', 'select2', 'checkbox', 'multiselect'];

	return !nestedTypes.includes(fieldSettingData.value.data_type) || fieldSettingData.value.default || fieldSettingData.value.title === 'Api'
}

/**
 * Updates the value of an option in the field setting data.
 * @param {Object} data - The data containing the new value and index of the option.
 */
const updateOptionValue = (data) => {

	if(isOptionAlreadyExist(data.newValue)) {

		return;
	}
	
	fieldSettingData.value.options[data.index].labels[getLabelIndex(fieldSettingData.value.options[data.index].labels)].label = data.newValue;

}

/**
 * Deletes an option from the field setting data.
 * @param {number} index - The index of the option to delete.
 */
const deleteOption = (index) => {

	if(fieldSettingData.value.options.length === 1) {

		store.dispatch('setAlert', { type: 'danger', message: lang('option_can_not_be_empty_alert_msg'), component_name: 'form-builder-setting-modal' });

		return;
	}

	const selectedId = fieldSettingData.value.options[index].id;
	const selectedOptionType = fieldSettingData.value.data_type;

	if(selectedId && selectedId.toString().length < 13) {

		let isConfirmed = confirm('Are you sure you want to delete?');

		if(isConfirmed) {

			isLoading.value = true;

			axios.delete('/remove/form-options/' + selectedId + '/' + selectedOptionType).then(resp => {

				// window.emitter.emit('getFormDataFromServer');

				fieldSettingData.value.options.splice(index, 1);

				successHandler(resp, 'form-builder-setting-modal');

			}).catch(resp => {

				errorHandler(resp, 'form-builder-setting-modal');

			}).finally(() => {

				isLoading.value = false;
			})
		}
	} else {

		fieldSettingData.value.options.splice(index, 1);
	}
}

/**
 * Adds a new option to the field setting data when the enter key is pressed.
 * @param {KeyboardEvent} event - The keyboard event object.
 */
const addNewOption = (event) => {

	if(!newOption.value){

		addOptionInputHelp.value = '';

		return;
	};

	addOptionInputHelp.value = 'Press enter to add';

	if(event.keyCode === 13) {

		addOptionInputHelp.value = '';

		if(isOptionAlreadyExist(newOption.value)) {

			newOption.value = '';

			return;
		}

		const data = getOptionDataObj();

		if(props.fieldData.data_type === 'checkbox'){

			data.checked = false;
		}

		if(Array.isArray(data)) {

			data.forEach((item)=> {

				setTimeout(()=>{

					item.id = new Date().getTime();

					item.form_identifier = new Date().getTime();

					fieldSettingData.value.options.push(item);
				},1)
			})
		} else {

			fieldSettingData.value.options.push(data);
		}

		newOption.value = '';
	}
}

/**
 * Constructs an option data object based on the new option value.
 * @returns {Object|Array} - The option data object or an array of option data objects.
 */
const getOptionDataObj = () => {

	if (newOption.value.indexOf(',') > -1) {

		let string = newOption.value.split(',');

		let updVal = [];

		for(let i in string) {

			updVal.push(updateOption(string[i]));
		}

		return updVal;

	} else {

		return updateOption(newOption.value)
	}
}

/**
 * Constructs an option data object with the provided value.
 * @param {string} value - The value of the option.
 * @returns {Object} - The constructed option data object.
 */
const updateOption = (value) => {

	const currentTimestamp = getCurrentTimestamp();

	let labels = [{id: null, language: seletedLang.value, label: value}];

	if(seletedLang.value !== systemLang.value) {

		labels.push({id: null, language: systemLang.value, label: value});
	}

	if(systemLang.value !== 'en') {

		labels.push({id: null, language: 'en', label: value});
	}

	return {

		id: currentTimestamp, // TimeStamp as id

		form_identifier: currentTimestamp,

		labels: labels,

		nodes: [],

		sort_order: 0
	}
}

/**
 * Checks if the new option label already exists in the field settings.
 * @param {string} newOptionLabel - The label of the new option to check.
 * @returns {boolean} - True if the option already exists, otherwise false.
 */
const isOptionAlreadyExist = (newOptionLabel) => {

	for (let i = 0; i < fieldSettingData.value.options.length; i++) {

		const labels = fieldSettingData.value.options[i].labels;

		for (let j = 0; j < labels.length; j++) {

			if(labels[j].language === seletedLang.value && labels[j].label.toLowerCase() === newOptionLabel.toLowerCase()) {

				store.dispatch('setAlert', { type: 'danger', message: `Option [${newOptionLabel}] already present.`, component_name: 'form-builder-setting-modal' });

				return true;
			}
		}
	}
	return false;
}

/**
 * Handles the change of the current tab.
 * @param {string} newTabValue - The value of the new tab.
 */
const onTabChange = (newTabValue) => {

	store.dispatch('unsetAlert');

	currentTab.value = newTabValue;
}

/**
 * Applies the changes made in the field settings modal.
 */
const onApply = () => {

	if(props.from === 'ticket-fields-form') {

		props.fieldUpdate(fieldSettingData.value);

	} else {

		window.emitter.emit('formFieldSettingsApplied', fieldSettingData.value);
	}
}

/**
 * Retrieves the current timestamp.
 * @returns {number} - The current timestamp.
 */
const getCurrentTimestamp = () => {

	return new Date().getTime();
}

const onSettingsClose = () => {

	props.onCloseSettingModal();
	
	window.emitter.emit('formFieldSettingsClosed', fieldSettingData.value);
}

const refreshData = ref(false);

window.emitter.on('refreshFieldSettings', (data) => {

	refreshData.value = data;
})

/**
 * Executes cleanup operations when the component is unmounted.
 */
onUnmounted(()=>{
	store.dispatch('unsetAlert')
})

</script>

<template>

	<div draggable="false">

		<template v-if="from === 'ticket-fields-form' && !showInModal">
			
			<div class="pb-2 pe-2 ps-2 pt-0">
				
				<ul v-if="tabsToShow.length" class="nav nav-tabs" role="tablist">
					
					<template v-for="tab in tabsToShow">
						
						<li v-if="tab.id !== 1 && tab.id !== 2" class="nav-item" :key="tab.id" :id="tab.id">
							
							<a class="nav-link" href="javascript:;" @click="onTabChange(tab.value)"
							   :class="currentTab === tab.value ? 'active font-weight-bold' : ''" data-bs-toggle="pill" role="tab">
								{{ trans(tab.label) }}
							</a>
						</li>
					</template>
				</ul>
				
				<div v-if="tabsToShow.length" class="mt-2">
					
					<template v-if="currentTab === 'configuration'">
						
						<FEConfigSettings :form-field-data="fieldSettingData" :from="from"></FEConfigSettings>
						
						<FEFieldValidation v-if="isVisible('validation')" :form-field-data="fieldSettingData"></FEFieldValidation>
					
					</template>
					
					<template v-if="currentTab === 'language'">

						<div class="pt-0 pb-2">

							<loader v-if="refreshData" :size="60" />

							<template v-if="!refreshData">

								<FEAddLanguage :form-field-data="fieldSettingData" :auth="auth" :selectedLanguage="selectedLanguage"></FEAddLanguage>

								<template v-if="isVisible('addOption')">
								
								<div class="row">
									
									<div class="col-sm-12 form-group mt-2">
										
										<label>{{lang('options')}}<small style="color: orangered;" v-if="addOptionInputHelp">({{addOptionInputHelp}})</small></label>
										
										<input ref="addOptionInput" type="text" :placeholder="lang('add_new_option')" class="form-control" v-model.trim="newOption" @keyup="addNewOption($event)">
										
										<loader v-if="isLoading" :size="20" />
										
										<draggable v-model="fieldSettingData.options" class="todo-list ui-sortable mt-2 h-200" handle=".drag-handle">
											
											<template #item="{ element,index }">
												
												<li :key="element.id">
													
													<NestedFieldOptions :option-index="index" :value="element.labels[getLabelIndex(element.labels)].label" @on-delete="deleteOption" @on-update="updateOptionValue"></NestedFieldOptions>
												</li>
											</template>
										</draggable>
									</div>
								</div>
							</template>
							</template>
						</div>
					</template>
				</div>
				
				<div v-else class="mt-2">
					
					<div class="alert alert-info" role="alert">{{ trans('this_field_is_not_editable') }}</div>
				</div>
			</div>
			
			<div v-if="tabsToShow.length" class="pe-2">
				
				<button class="btn btn-primary float-end" @click="onApply()">
					
					<i :class="settingBtnName === 'save' ? 'fas fa-save' : 'fas fa-check'"> </i> {{ lang(settingBtnName) }}
				</button>
			</div>
		</template>
		
		<template v-else>
			
			<Modal v-if="isShowSettingModal" :showModal="isShowSettingModal" :onClose="onSettingsClose"
			       :containerStyle="containerStyle" :showCloseBtn="showCloseBtn">
				
				<template #title>
					
					<h4 class="modal-title">{{trans('settings') + ' (' + fieldSettingData.labels[getLabelIndex(fieldSettingData.labels)].label + ')'}}</h4>
				</template>
				
				<template #alert>
					
					<Alert componentName="form-builder-setting-modal"></Alert>
				</template>
				
				<template #fields>
					
					<div class="setting_scroll_div pe-2">
						
						<ul v-if="tabsToShow.length" class="nav nav-tabs" role="tablist">
							
							<template v-for="tab in tabsToShow">
								
								<li v-if="tab.id !== 1 && tab.id !== 2" class="nav-item" :key="tab.id" :id="tab.id">
									
									<a class="nav-link" href="javascript:;" @click="onTabChange(tab.value)"
									   :class="currentTab === tab.value ? 'active font-weight-bold' : ''" data-bs-toggle="pill" role="tab">
										{{ trans(tab.label) }}
									</a>
								</li>
							</template>
						</ul>
						
						<div v-if="tabsToShow.length" class="mt-2">
							
							<template v-if="currentTab === 'configuration'">
								
								<FEConfigSettings :form-field-data="fieldSettingData" :from="from"></FEConfigSettings>
								
								<FEFieldValidation v-if="isVisible('validation')" :form-field-data="fieldSettingData"></FEFieldValidation>
							
							</template>
							
							<template v-if="currentTab === 'language'">
								
								<div class="pt-0 pb-2">

									<loader v-if="refreshData" :size="60" />

									<template v-if="!refreshData">

										<FEAddLanguage :form-field-data="fieldSettingData" :auth="auth" :selectedLanguage="selectedLanguage"></FEAddLanguage>

										<template v-if="isVisible('addOption')">

											<div class="row">

												<div class="col-sm-12 form-group mt-2">

													<label>{{lang('options')}}<small style="color: orangered;" v-if="addOptionInputHelp">({{addOptionInputHelp}})</small></label>

													<input ref="addOptionInput" type="text" :placeholder="lang('add_new_option')" class="form-control" v-model.trim="newOption" @keyup="addNewOption($event)">

													<loader v-if="isLoading" :size="20" />

													<draggable v-model="fieldSettingData.options" class="todo-list ui-sortable mt-2 h-200" handle=".drag-handle">

														<template #item="{ element,index }">

															<li :key="element.id">

																<NestedFieldOptions :option-index="index" :value="element.labels[getLabelIndex(element.labels)].label" @on-delete="deleteOption" @on-update="updateOptionValue"></NestedFieldOptions>
															</li>
														</template>
													</draggable>
												</div>
											</div>
										</template>
									</template>
								</div>
							</template>
						</div>
						
						<div v-else class="mt-2">
							
							<div class="alert alert-info" role="alert">{{ trans('this_field_is_not_editable') }}</div>
						</div>
					</div>
				</template>
				
				<template #controls>
					
					<button v-if="tabsToShow.length" class="btn btn-light float-end" @click="onApply()">
						
						<i :class="settingBtnName === 'save' ? 'fas fa-save' : 'fas fa-check'"> </i> {{ lang(settingBtnName) }}
					</button>
				</template>
			</Modal>
			
		</template>
	</div>
</template>

<style scoped>

	.sticky-settings { position: sticky !important; top :100px !important; z-index: 0; }

	.btn-light:not(:disabled):not(.disabled).active {
		background-color: #c0c3c4;
		border-color: #c0c3c4;
	}

	.field-btn { margin-right: 0px !important; }

	/*.field-settings-menu {
		border: 1px dashed #c0c3c4;
		border-radius: 0.25rem;
	}*/

	/*input {
		border: none;
	}*/

	.content {
		min-height: 20vh !important;
	}
	li {
		list-style-type: none;
	}

	.table {
		display: table;
		margin: 0 auto;
	}

	ul#horizontal-list {
		border: 1px solid #b5b5b5;
		/*min-width: 696px;*/
		list-style: none;
		padding-left: 0;
		/*max-height: 100px;*/
		overflow-y: auto;
		border-radius: 0.25rem;
	}

	ul#horizontal-list li {
		display: inline-flex;
	}
	.add-option {
		margin-right: 10px;
		margin-left: -3px;
	}
	.input-box-li {
		padding-left: 0.25rem;
		padding-top: 1rem;
		width: 100%;
	}
	.add-option-loader {
		padding-right: 1rem;
		padding-top: 1rem;
	}
	.li-child {
		padding-left: 1rem;
		padding-top: 1rem;
	}
	.h-200 { max-height: 200px; }
	
	.setting_scroll_div {
		max-height: 500px;
		overflow-y: auto;
		overflow-x: hidden;
	}
</style>