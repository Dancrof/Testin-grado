<script setup>

import {onBeforeMount, ref, computed} from "vue";
import _ from 'lodash-core';

import Alert from "../../../MiniComponent/Alert.vue";
import CustomLoader from "../../../MiniComponent/Loader.vue";

import {useStore} from "vuex";
const store = useStore();

import {useRoute, useRouter} from "vue-router";
const router = useRouter();
const route = useRoute();

import axios from "axios";
import {boolean} from "../../../../helpers/extraLogics";
import {errorHandler, successHandler} from "../../../../helpers/responseHandler";
import {validateFormGroup} from "../../../../helpers/validator/formGroupRules";
import Menu from "./Builder/Menu.vue";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
import globalMixin from "../../../../mixins/globalMixin";
import Sections from "./Builder/Sections.vue";
import FieldSettings from "./Builder/FieldSettings.vue";
import Modal from "../../../Common/Modal.vue";
import ToolTip from "../../../MiniComponent/ToolTip.vue";
const { basePathVersion } = globalMixin.methods;

let props = defineProps({
	// Object containing authentication information
	auth: { type: Object, default: () => ({}) },
	// Mode of the form (e.g., 'create', 'edit')
	formMode: { type: String, default: '' },
	// Object containing form name information
	formNameObj: { type: Object, default: () => ({}) },
	// Object containing checkbox form information
	formCheckbox: { type: Object, default: () => ({}) },
	// Array containing linker form information
	formLinker: { type: Array, default: () => [] },
	// API endpoint for editing form data
	editFormApi: { type: String, default: '' },
	// API endpoint for posting form data
	postFromApi: { type: String, default: '' },
	// Type of form category
	formCategoryType: { type: String, default: '' },
	// Heading for the page containing the form
	pageHeading: { type: String, default: 'form' },
	// ID of the form being edited
	editFormId: { type: [String,Number], default : ''},
	// Key for the response of the edited form
	editResponseKey: { type: String, default : ''},
	// Module name for routing
	routeModuleName: { type: String, default : ''},
});

// Reference to the active form category type
const activeFormCategoryType = ref('');
// Boolean indicating whether to show loader
const showLoader = ref(true);
// Boolean indicating whether the menu has loaded
const hasMenuLoaded = ref(false);
// Boolean indicating whether form fields have loaded
const hasFormFieldsLoaded = ref(false);
// Boolean indicating whether it's a create form
const isCreateForm = ref(false);
// Boolean indicating whether it's an edit form
const isEditForm = ref(false);
// Reference to the selected menu type (e.g., fields)
const selectedType = ref('fields');
// Reference to the form name object
let localFormNameObj = ref({});
// Reference to the form checkbox object
let localFormCheckbox = ref({});
// Reference to the form linker array
let localFormLinker = ref([]);

// Boolean indicating whether to show the delete modal
const showDeleteModal = ref(false);
// Reference to the type of data to delete
const deleteType = ref('');
// Reference to the data to delete
const deleteData = ref('');
// Reference to the ID of the data to delete
const deleteId = ref('');

onBeforeMount(()=>{
	// Set local form name object to the value of props.formNameObj
	localFormNameObj.value = props.formNameObj;
	// Set local form checkbox object to the value of props.formCheckbox
	localFormCheckbox.value = props.formCheckbox;
	// Set local form linker array to the value of props.formLinker
	localFormLinker.value = props.formLinker;

	// If the form mode is 'create'
	if (props.formMode === 'create') {
		// Set the value of the local form name object to an empty string
		localFormNameObj.value.value = "";
		// Set the value of the local form checkbox object to false
		localFormCheckbox.value.value = false;
		// Update the local form linker array, setting all values to empty strings
		localFormLinker.value = localFormLinker.value.map(obj => {

			return {...obj, value: ''}
		});
	}
	// Call a function to set initial values
	setInitialValue();
});

/**
 * Initializes the form with initial values based on form mode.
 */
const setInitialValue = () => {

	if (props.formMode === 'create') {

		isCreateForm.value = true;

		hasFormFieldsLoaded.value = true;

		localFormNameObj.value.value = "";
		localFormCheckbox.value.value = 0;

		localFormLinker.value.forEach((element, index) => {
			element.value = '';
		});

		showLoader.value = false;

	} else if (props.formMode === 'edit') {

		isEditForm.value = true;

		showLoader.value = false;
	}

	activeFormCategoryType.value = props.formCategoryType;

	getMenuJson();

	assignFormFields();
}

/**
 * Fetches the menu JSON data based on the active form category type.
 */
const getMenuJson = () => {

	axios.get('api/get-form-menu/' + activeFormCategoryType.value).then(res => {

		store.commit('updateFormMenu', res.data.data);

		hasMenuLoaded.value = true;
	});
}

/**
 * Assigns form fields data from the server response.
 */
const assignFormFields = () => {

	getFormDataFromServer().then((resp) => {

		if (isEditForm.value) {

			localFormNameObj.value.value = resp.data.data[props.editResponseKey][localFormNameObj.value.id] ? resp.data.data[props.editResponseKey][localFormNameObj.value.id] : '';

			localFormCheckbox.value.value = resp.data.data[props.editResponseKey][localFormCheckbox.value.id] ? resp.data.data[props.editResponseKey][localFormCheckbox.value.id] : '';

			localFormLinker.value.forEach(element => {

				element.value = resp.data.data[props.editResponseKey][element.id] ? resp.data.data[props.editResponseKey][element.id] : '';
			});
		}

		hasFormFieldsLoaded.value = true;
	})
}

/**
 * Retrieves form data from the server based on the form category type.
 * @returns {Promise} A promise that resolves with the server response.
 */
const getFormDataFromServer = () => {

	showLoader.value = true;

	store.commit('updateFormCategoryType', activeFormCategoryType.value);

	let apiEndpoint = '/field-manager-section';

	let params = { category: props.formCategoryType, page: 'config' };

	if (isEditForm.value) {

		apiEndpoint = props.editFormApi;

		params.config = false;
	}

	return axios.get(apiEndpoint , { params }).then((response) => {

		store.commit('updateFormSections', props.formMode === 'create' ? response.data.data : response.data.data[props.editResponseKey].nodes);

		showLoader.value = false;

		return response

	}).catch((error) => {

		showLoader.value = false;

		errorHandler(error, 'form-builder-main');
	})
}

/**
 * Saves the form if the form name is valid.
 */
const onSaveForm = async () => {

	if (isValidFormName()) {

		const formBuilderData = store.getters.getFormSections;

		assignSortOrder(formBuilderData);

		await saveForm(formBuilderData);
	}
}

/**
 * Checks if the form name is valid.
 * @returns {boolean} True if the form name is valid, false otherwise.
 */
const isValidFormName = () => {

	if(isCreateForm.value || isEditForm.value){

		const { errors, isValid } = validateFormGroup(props);

		return isValid;

	} else {

		return true;
	}
}

/**
 * Assigns sort order to form categories and fields recursively.
 * @param {array} array - The array containing form categories and fields.
 */
const assignSortOrder = (array) => {

	for (let i = 0; i < array.length; i++) {

		const category = array[i];

		// Assign sort order for categories
		category.sort_order = i;

		// Assign sort order for form fields
		if (category.form_fields && typeof category.form_fields === 'object') {

			Object.keys(category.form_fields).forEach(key => {

				const formFields = category.form_fields[key];

				for (let j = 0; j < formFields.length; j++) {

					formFields[j].sort_order = j;
				}

				// Recursively assign sort order for nested form fields
				assignSortOrder(formFields);
			});
		} else {

			Object.keys(array[i]).forEach(key => {

				if (boolean(array[i][key]) && Array.isArray(array[i][key])) {

					assignSortOrder(array[i][key]);
				}
			})
		}
	}
};

/**
 * Saves form data.
 * @param {array} formBuilderData - The data representing the form structure.
 */
const saveForm = async (formBuilderData) => {

	try {

		showLoader.value = true;

		const filteredData = formBuilderData.filter(obj => {

			if (obj.data_type === 'section') {

				const firstEmpty = obj.form_fields.first ? obj.form_fields.first.length === 0 : false;

				const secondEmpty = obj.form_fields.second ? obj.form_fields.second.length === 0 : false;

				return !((firstEmpty && secondEmpty) || (firstEmpty && !obj.form_fields.second) || (!obj.form_fields.first && secondEmpty));
			}

			return true;
		});

		const api = getApiEndpoint();

		const resp = await postFormData(api, filteredData);

		handleSuccess(resp);

	} catch (error) {

		handleFailure(error);
	}
}

/**
 * Determines the API endpoint based on form mode.
 * @returns {string} The API endpoint.
 */
const getApiEndpoint = () => {

	return isCreateForm.value || isEditForm.value ? props.postFromApi : 'post/form-fields';
}

/**
 * Posts form data to the server.
 * @param {string} api - The API endpoint to post the data.
 * @param {array} formBuilderData - The flattened form data to post.
 * @returns {Promise} A promise representing the server response.
 */
const postFormData = async (api, formBuilderData) => {

	let filetered = flattenFormFields(formBuilderData);

	return await axios.post(api, getSaveFormParams(filetered));
}

/**
 * Flattens form fields data.
 * @param {array} fields - The array containing form fields data.
 * @returns {array} The flattened form fields data.
 */
const flattenFormFields = (fields) => {

	for (let i = 0; i < fields.length; i++) {

		if (fields[i].form_fields && typeof fields[i].form_fields === 'object' && !Array.isArray(fields[i].form_fields)) {

			const firstFields = fields[i].form_fields.first || [];
			const secondFields = fields[i].form_fields.second || [];

			// Add "column" key to each object in "first" array
			firstFields.forEach(field => {
				field.column = 'first';
			});

			// Add "column" key to each object in "second" array
			secondFields.forEach(field => {
				field.column = 'second';
			});

			//
			fields[i].form_fields = firstFields.concat(secondFields);

			fields[i].form_fields.forEach(element => {

				if(boolean(element.options)) {

					element.options.forEach(element => {

						flattenFormFields(element.nodes ? element.nodes : [])
					})
				}
			});
		} else {

			if(boolean(fields[i].options)) {

				fields[i].options.forEach(element => {

					flattenFormFields(element.nodes ? element.nodes : [])
				})
			}
		}
	}

	return fields
};

/**
 * Constructs parameters for saving form data.
 * @param {array} formBuilderData - The data representing the form structure.
 * @returns {object} The parameters for saving form data.
 */
const getSaveFormParams = (formBuilderData) => {

	let params = {};

	params['category'] = props.formCategoryType;
	params['id'] = route.params.id;
	params['is_clone'] = 1;
	params['is_delete'] = 0;

	params['form_sections'] = formBuilderData;

	if (isCreateForm.value || isEditForm.value) {

		params[localFormNameObj.value.submitFormParamKey] = localFormNameObj.value.value;
		params[localFormCheckbox.value.submitFormParamKey] = localFormCheckbox.value.value;

		localFormLinker.value.forEach(element => {

			params[element.submitFormParamKey] = element.value ? element.value.id : '';
		});
	}

	if (isEditForm.value) {

		params['id'] = props.editFormId;
	}

	return params;
}

/**
 * Handles success response from saving form data.
 * @param {object} resp - The response object from the server.
 */
const handleSuccess = (resp) => {

	successHandler(resp, 'form-builder-main');

	if (isCreateForm.value || isEditForm.value) {

		handleSuccessForCreateOrEdit();

	} else {

		handleSuccessForOther();
	}
}

/**
 * Handles success response for create or edit forms.
 */
const handleSuccessForCreateOrEdit = () => {

	showLoader.value = false;

	if(props.formMode === 'create') {

		setTimeout(() => {

			router.push({ name: props.routeModuleName });

		}, 3000);

	} else {

		handleSuccessForOther();
	}
}

/**
 * Handles success response for other cases.
 */
const handleSuccessForOther = () => {

	getFormDataFromServer().then(() => {

		showLoader.value = false;
	});
}

/**
 * Handles failure response from saving form data.
 * @param {object} error - The error object.
 */
const handleFailure = (error) => {

	showLoader.value = false;

	errorHandler(error, 'form-builder-main');
}

let showSettingModal = ref(false);

let selectedFormFieldObject = ref(null);

/**
 * Closes the setting div.
 */
const onEditClose = () => {

	showSettingModal.value = false;

	selectedFormFieldObject.value = null;
}

/**
 * Opens the setting div for field editing.
 * @param {object} data - The data representing the selected form field.
 */
const onFieldEdit = ({data}) => {

	showSettingModal.value = false;

	selectedFormFieldObject.value = data;

	setTimeout(()=>{

		showSettingModal.value = true;
	},0)
}

/**
 * Computed property to get and set form sections from the store.
 */
const formSectionsStoreValue = computed({
	get() {
		return store.getters.getFormSections;
	},
	set(value) {
		store.dispatch('updateFormSections', value);
	}
});

/**
 * Applies settings changes to the form sections.
 * @param {object} changedValue - The changed value object containing the updated settings.
 */
const applySettingsChanges = async (changedValue) => {

	const data = store.getters.getFormSections;

	const isResolved = await assignNewValue(data, changedValue.form_identifier, changedValue);

	if(isResolved) {

		await store.dispatch('updateFormSections', data);
	}

	onEditClose();
	
	window.emitter.emit('updateNestedObjects');
}

/**
 * Assigns a new value to the specified form section or field.
 * @param {array} array - The array containing form sections or fields.
 * @param {string} affectedId - The identifier of the form section or field to be affected.
 * @param {object} newObj - The new object containing updated settings.
 * @returns {Promise<boolean>} A promise resolving to true once the value is assigned.
 */
const assignNewValue = (array, affectedId, newObj) => {

	let idx = _.findIndex(array, (element) => element.form_identifier === affectedId);

	if(idx !== -1) {

		array[idx] = newObj;

	} else {

		for (let i = 0; i < array.length; i++) {

			if (array[i].form_fields && typeof array[i].form_fields === 'object') {

				Object.keys(array[i].form_fields).forEach(key => {

					assignNewValue(array[i].form_fields[key], affectedId, newObj);
				});
			} else {

				if(boolean(array[i].options)) {

					array[i].options.forEach(element => {

						assignNewValue(element.nodes ? element.nodes : [], affectedId, newObj)
					})
				}
			}
		}
	}

	return new Promise(resolve => {

		resolve(true);
	});
}

/**
 * Sets up data for element removal and opens the delete modal.
 * @param {object} obj - The object containing data about the element to be removed.
 */
const onRemoveElement = (obj) => {
	showDeleteModal.value = true;
	deleteType.value = obj['reference_type'];
	deleteData.value = obj['fieldData'];
	deleteId.value = obj['reference_id'];
}

/**
 * Initiates the deletion process.
 */
const doDelete = () => {

	showDeleteModal.value = false;

	if(isDeleteFromDB(deleteData.value)) {

		deleteElementFormDB(deleteData.value.id, deleteId.value, deleteType.value, deleteData.value);

	} else {

		deleteElementLocally(deleteData.value.form_identifier, deleteData.value);
	}
}

/**
 * Deletes the element locally.
 * @param {string} form_identifier - The identifier of the form section or field to be deleted.
 */
const deleteElementLocally = (form_identifier, fieldVal) => {

	const data = store.getters.getFormSections;

	const isResolved = removeAt(data, form_identifier)

	if(isResolved) {

		store.dispatch('updateFormFields', data);
		
		window.emitter.emit('updateNestedObjects');
		
		window.emitter.emit('updateMenuCount', { field: fieldVal, from: 'local' })
	}
}

/**
 * Deletes the element from the database.
 * @param {string} id - The ID of the element to be deleted.
 * @param {string} reference_id - The reference ID of the element.
 * @param {string} reference_type - The reference type of the element.
 */
const deleteElementFormDB = (id, reference_id, reference_type, fieldVal) => {

	showLoader.value = true;

	let api = deleteData.value.data_type === 'section' ? '/remove/form-sections/' + id : '/remove/form-fields/' + id;

	if (reference_id) {

		api = 'api/unlink-form-group/' + reference_type + '/' + reference_id;
	}

	axios.delete(api).then(resp => {

		successHandler(resp, 'form-builder-main');
		
		hasFormFieldsLoaded.value = false;
		
		getFormDataFromServer().then(() => {
			
			hasFormFieldsLoaded.value = true;
		})
		
		window.emitter.emit('updateNestedObjects');
		
		window.emitter.emit('updateMenuCount', { field: fieldVal, from: 'db' })
		
		showLoader.value = false;

	}).catch(error => {

		showLoader.value = false;

		errorHandler(error, 'form-builder-main');
	});
}

/**
 * Checks if the element needs to be deleted from the database.
 * @param {object} fieldData - The data of the field to be deleted.
 * @returns {boolean} True if the element needs to be deleted from the database, false otherwise.
 */
const isDeleteFromDB = (fieldData) => {

	if(fieldData.type === 'group') {

		return typeof fieldData.groupid === 'undefined';
	}

	return fieldData.id.toString().length < 13;
}

/**
 * Removes an element from the array based on the form identifier.
 * @param {array} array - The array containing form sections or fields.
 * @param {string} form_identifier - The identifier of the form section or field to be removed.
 * @returns {Promise<boolean>} A promise resolving to true once the element is removed.
 */
const removeAt = (array, form_identifier) => {

	let idx = _.findIndex(array, (element) => element.form_identifier === form_identifier);

	if(idx !== -1) {

		array.splice(idx, 1);

	} else {

		for (let i = 0; i < array.length; i++) {

			if (array[i].form_fields && typeof array[i].form_fields === 'object') {

				Object.keys(array[i].form_fields).forEach(key => {

					removeAt(array[i].form_fields[key],form_identifier)
				});

			} else {

				if(boolean(array[i].options)) {

					array[i].options.forEach(element => {

						removeAt(element.nodes ? element.nodes : [],form_identifier)
					})
				}
			}
		}
	}

	return Promise.resolve(true);
}

const onLangRemoved = () =>{

	hasFormFieldsLoaded.value = false;

	getFormDataFromServer().then(() => {

		hasFormFieldsLoaded.value = true;
	})

	showLoader.value = false;

	onEditClose();
};

window.emitter.on('formFieldSettingsApplied', applySettingsChanges);
window.emitter.on('onRemoveElement', onRemoveElement);
window.emitter.on('getFormDataFromServer', getFormDataFromServer);
window.emitter.on('onEditElement', onFieldEdit);

window.emitter.on('formLangRemoved',onEditClose);
window.emitter.on('formLangRemovedInDb',onLangRemoved);

</script>

<template>

<div class="col-sm-12">

	<Alert component-name="form-builder-main"></Alert>

	<div class="card card-light shadow-none">

		<div class="card-header sticky-top menu-border sticky-top-menu">

			<CustomLoader v-if="showLoader"></CustomLoader>

			<h3 v-if="hasFormFieldsLoaded && hasMenuLoaded" class="card-title">{{ trans(pageHeading) }}</h3>

			<div class="card-tools" v-if="hasFormFieldsLoaded && hasMenuLoaded">

				<button class="btn btn-primary form-save-btn float-end form_save_btn" @click="onSaveForm()">

					<i class="fas fa-save"></i> {{ trans('save') }}
				</button>
			</div>
		</div>

		<div class="card-body p-0 pt-2 bg-light">

			<div class="row">

				<div class="col-sm-3">

					<div class="card sticky-top sticky-fields">

						<div class="card-body p-2">

							<div class="row">

								<div v-if="hasMenuLoaded" class="col-12">

									<ul class="nav nav-tabs" role="tablist">

										<li class="nav-item">

											<a class="nav-link" href="javascript:;" :class="selectedType === 'fields' ? 'active fw-bold' : ''" data-bs-toggle="pill" role="tab">
												{{ trans('formfields') }}
											</a>
										</li>
									</ul>

									<Menu :key="selectedType" :type="selectedType"></Menu>
								</div>
							</div>
						</div>
					</div>
				</div>

				<template v-if="hasFormFieldsLoaded && hasMenuLoaded">

					<div class="col-sm-9">

						<div v-if="isCreateForm || isEditForm" class="card">

							<div class="card-body row">

								<TextField :id="localFormNameObj.id" :classname="localFormNameObj.className" :label="trans(localFormNameObj.label)" :value="localFormNameObj.value" type="text" :name="localFormNameObj.id" :onChange="(value) => localFormNameObj.value = value" :placehold="trans(localFormNameObj.placeholder)" :required="true"/>

								<DynamicSelect v-for="item in localFormLinker" :key="item.id" :id="item.id" :name="item.submitFormParamKey" :classname="item.className" :apiEndpoint="item.apiEndpoint" :label="trans(item.label)" :value="item.value" :required="false" :multiple="item.multiple"  :onChange="(value) => item.value = value"/>

								<div v-if="localFormCheckbox && localFormCheckbox.id" class="form-group col-md-12" id="text">

									<label class="label_align1">

										<input class="checkbox_align" type="checkbox" :name="localFormCheckbox.id" @change="e => localFormCheckbox.value = e.target.checked  === true" :checked="localFormCheckbox.value === true" >&nbsp;{{lang(localFormCheckbox.label)}}

										<span class="ms-3"><ToolTip :message="lang(localFormCheckbox.hint)" size="small"></ToolTip></span>
									</label>
								</div>
							</div>
						</div>

						<div class="card">

							<div class="card-body p-2">

								<Sections :sections="formSectionsStoreValue" :auth="auth" :isFormGroup="isCreateForm || isEditForm">

								</Sections>

								<div v-if="!formSectionsStoreValue.length"  class="row no-drag-form-card">

									<div class="text-center pt-4 no-drag-fields">

										<img :src="basePathVersion()+'/themes/default/common/images/drag.png'" alt="form-no-drag"
											 class="no-drag-img">

										<h5>{{ trans('drag_elements_here') }}</h5>

										<p>{{ trans('drag_an_element_from_the_left') }}</p>
									</div>
								</div>
							</div>
						</div>
					</div>

<!--					<div v-if="showSettingModal" class="col-sm-3">-->

						<FieldSettings v-if="showSettingModal" :fieldData="selectedFormFieldObject" :isShowSettingModal="showSettingModal" :onCloseSettingModal="onEditClose" :auth="auth">

						</FieldSettings>
<!--					</div>-->
				</template>
			</div>
		</div>
	</div>

	<transition name="modal">

		<Modal v-if="showDeleteModal" :showModal="true" :onClose="() => showDeleteModal = false" :containerStyle="{width:'400px'}">

			<template #title>

				<h4 class="modal-title">{{trans('delete')}}</h4>
			</template>

			<template #fields>

				<span>{{trans('are_you_sure_you_want_to_delete')}}</span>
			</template>

			<template #controls>
				<button id="approval-action-confirm" type="button" @click = "doDelete()" class="btn btn-secondary">
					<i class="fas fa-trash-alt" aria-hidden="true"></i>&nbsp;{{trans('confirm')}}
				</button>
			</template>
		</Modal>
	</transition>
</div>
</template>

<style scoped>

.menu-border {
	border: 1px solid #ddd;
	border-bottom-left-radius: 0.25rem;
	border-bottom-right-radius: 0.25rem;
}

.sticky-top-menu { position: sticky !important; top :45px !important; }

.sticky-fields { position: sticky !important; top :100px !important; }

.sticky-forms { position: sticky !important; top :100px !important; }

.btn-light:not(:disabled):not(.disabled).active {
	background-color: #c0c3c4;
	border-color: #c0c3c4;
}

.field-btn { margin-right: 0px !important; cursor: pointer !important;}

.form-category-menu {
	border: 1px dashed #c0c3c4;
	border-radius: 0.25rem;
}

.no-drag-form-card { min-height: 170px; }

.no-drag-fields {
	position: absolute !important;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	opacity: 0.3;
}

.no-drag-img { width: 60px; height: 60px; }

.form_save_btn { margin: -5px 4px -12px 10px; padding: 4px 8px}

.checkbox_align {
	width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden;
}
</style>