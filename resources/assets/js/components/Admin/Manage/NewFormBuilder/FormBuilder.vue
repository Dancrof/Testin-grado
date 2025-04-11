<script setup>

import {onBeforeMount, reactive, ref, computed} from "vue";
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
import Menu from "./Builder/Menu.vue";
import globalMixin from "../../../../mixins/globalMixin";
import Sections from "./Builder/Sections.vue";
import FieldSettings from "./Builder/FieldSettings.vue";
import Modal from "../../../Common/Modal.vue";
import StatusSwitch from "../../../MiniComponent/FormField/Switch.vue";
const { basePathVersion } = globalMixin.methods;

let props = defineProps({
	// The authentication object.
	auth: { type: Object, default: () => ({}) },
	// The type of form category.
	formCategoryType: { type: String, default: '' },
});

// Indicates the active form category type.
const activeFormCategoryType = ref('');
// Indicates whether to show a loader.
const showLoader = ref(true);
// Indicates whether the menu has been loaded.
const hasMenuLoaded = ref(false);
// Indicates whether form fields have been loaded.
const hasFormFieldsLoaded = ref(false);
// The heading of the page.
const pageHeading = ref('form');
// The selected menu type, e.g., 'fields'.
const selectedType = ref('fields');

// Indicates whether to show the delete modal.
const showDeleteModal = ref(false);
// The type of item to be deleted.
const deleteType = ref('');
// Data to be deleted.
const deleteData = ref('');
// The ID of the item to be deleted.
const deleteId = ref('');

// Indicates whether the form is default.
const isDefaultForm = ref(false);
// Indicates whether the form is active.
const isFormActive = ref(false);
// The ID of the form.
const formId = ref('');
// Data related to cloning.
const clonedData = ref('');
// Indicates whether multiple forms are present.
const isMultipleForm = ref(false);

onBeforeMount(()=>{

	clonedData.value = store.getters.getClonedForm;

	formId.value = clonedData.value ? clonedData.value.id : route.params.id;

	if(clonedData.value) {

		getFormDataFromServer().then((resp) => {
			
			hasFormFieldsLoaded.value = true;
			hasMenuLoaded.value = true;
			
			setTimeout(() => {
				
				onSaveForm();
				
			},1000)
		})

	} else {

		setInitialValue();
	}
});

/**
 * Sets initial values for the form.
 */
const setInitialValue = () => {

	activeFormCategoryType.value = route.params.type;

	getMenuJson();

	assignFormFields();
}

/**
 * Fetches menu JSON data from the server based on the active form category type.
 */
const getMenuJson = () => {

	axios.get('api/get-form-menu/' + activeFormCategoryType.value).then(res => {

		store.commit('updateFormMenu', res.data.data);

		hasMenuLoaded.value = true;
	});
}

/**
 * Assigns form fields by fetching form data from the server and getting the default menu.
 */
const assignFormFields = () => {

	getFormDataFromServer().then((resp) => {
		
		hasFormFieldsLoaded.value = true;
	})
}

const formType = ref('');

/**
 * Fetches form data from the server.
 * Updates various states and the form sections in the store.
 * Handles loading indicators and error handling.
 */
const getFormDataFromServer = () => {

	showLoader.value = true;

	store.commit('updateFormCategoryType', activeFormCategoryType.value);

	let apiEndpoint = 'render/form';

	let params = { category: route.params.type, id: formId.value, mode: 'config' };

	return axios.get(apiEndpoint , { params }).then((response) => {

		pageHeading.value = response.data.data.name;

		isDefaultForm.value = response.data.data.is_default;

		isFormActive.value = response.data.data.is_active;

		isMultipleForm.value = response.data.data.is_multiple;
		
		formType.value = response.data.data.type;

		store.commit('updateFormSections', response.data.data.form_sections);

		showLoader.value = false;

		return response

	}).catch((error) => {

		showLoader.value = false;

		errorHandler(error, 'form-builder-main');
	})
}

/**
 * Handles saving the form.
 * Retrieves form sections from the store, assigns sort order, and saves the form.
 */
const onSaveForm = async () => {

	const formBuilderData = store.getters.getFormSections;

	assignSortOrder(formBuilderData);

	await saveForm(formBuilderData);
}

/**
 * Recursively assigns sort order to categories and form fields.
 * @param {Array} array - The array containing categories and form fields.
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
 * Saves the form data to the server.
 * @param {Array} formBuilderData - The form builder data to be saved.
 */
const saveForm = async (formBuilderData) => {
	
	formBuilderIsModified.value = false;
	
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

		const resp = await postFormData('/post/form-fields', filteredData);

		handleSuccess(resp);

	} catch (error) {

		handleFailure(error);
	}
}

/**
 * Sends a POST request to the specified API endpoint with the form data after flattening it.
 * @param {string} api - The API endpoint to send the POST request to.
 * @param {Array} formBuilderData - The form builder data to be posted.
 * @returns {Promise} A Promise representing the POST request.
 */
const postFormData = async (api, formBuilderData) => {

	let filetered = flattenFormFields(formBuilderData);
	
		onEditClose();
		
	return await axios.post(api, getSaveFormParams(filetered));
}

/**
 * Flattens the form fields array by adding a "column" key to each object and recursively flattens nested arrays.
 * @param {Array} fields - The array of form fields to be flattened.
 * @returns {Array} The flattened form fields array.
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
 * @param {Array} formBuilderData - The form builder data to be included in the parameters.
 * @returns {Object} An object containing parameters for saving form data.
 */
const getSaveFormParams = (formBuilderData) => {

	let params = {};

	params['category'] = route.params.type;
	params['id'] = route.params.id;
	params['is_clone'] = 1;
	params['is_delete'] = 0;
	params['is_active'] = isFormActive.value ? 1 : 0;
	params['is_default'] = clonedData.value ? 0 : isDefaultForm.value ? 1 : 0;

	params['form_sections'] = formBuilderData;

	return params;
}

/**
 * Handles the success response from a form submission.
 * @param {Object} resp - The response object.
 */
const handleSuccess = (resp) => {

	if(clonedData.value) {

		formId.value = route.params.id;

		store.dispatch('updateCloneableFormData', '');

		setInitialValue();
		
		successHandler(resp, 'form-builder-main');
		
		return
	}

	successHandler(resp, 'form-builder-main');

	handleSuccessForOther();
}

/**
 * Handles success for other cases by fetching form data from the server.
 */
const handleSuccessForOther = () => {

	getFormDataFromServer().then(() => {

		showLoader.value = false;
	});
}

/**
 * Handles the failure response from a form submission.
 * @param {Object} error - The error object.
 */
const handleFailure = (error) => {

	showLoader.value = false;
	
	getFormDataFromServer();
	
	errorHandler(error, 'form-builder-main');
}

const showSaveDiscardModal = ref(false);
const selectedMenuType = ref('');
const formBuilderIsModified = ref(false);
/**
 * Toggles the display of different types of fields.
 * @param {string} value - The selected field type.
 */
const toggleFields = (value) => {
	
	window.emitter.off('updateMenuOnChildSelect');
	
	if(value === 'fields') {
		hasMenuLoaded.value = false;
		getMenuJson();
	}
	
	if(formBuilderIsModified.value) {
		
		showSaveDiscardModal.value = true;
		
		selectedMenuType.value = value;
		
		return;
	}
	
	selectedType.value = value;
}

// Define a reactive reference to control the visibility of the settings modal
let showSettingModal = ref(false);
// Define a reactive reference to store the selected form field object for editing
let selectedFormFieldObject = ref(null);

/**
 * Closes the settings modal and clears the selected form field object.
 */
const onEditClose = () => {

	showSettingModal.value = false;

	selectedFormFieldObject.value = null;
}

/**
 * Opens the settings modal and sets the selected form field object.
 * @param {Object} data - The data of the selected form field.
 */
const onFieldEdit = ({data}) => {

	showSettingModal.value = false;

	selectedFormFieldObject.value = data;

	setTimeout(()=>{

		showSettingModal.value = true;
	},0)
}

/**
 * Computed property to get and set form sections store value.
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
 * Applies the settings changes to the form sections.
 * @param {Object} changedValue - The changed value object.
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
 * Recursively assigns new value to the array element with the specified identifier.
 * @param {Array} array - The array to search for the element with the specified identifier.
 * @param {string} affectedId - The identifier of the element to be updated.
 * @param {Object} newObj - The new value to be assigned.
 * @returns {Promise<boolean>} A promise that resolves to true.
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
 * Opens the delete modal and sets the delete parameters.
 * @param {Object} obj - The object containing information about the element to be deleted.
 */
const onRemoveElement = (obj) => {
	showDeleteModal.value = true;
	deleteType.value = obj['reference_type'];
	deleteData.value = obj['fieldData'];
	deleteId.value = obj['reference_id'];
}

/**
 * Performs the delete operation.
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
 * Deletes the element locally from the form sections.
 * @param {string} form_identifier - The identifier of the element to be deleted.
 */
const deleteElementLocally = (form_identifier, fieldVal) => {

	const data = store.getters.getFormSections;

	const isResolved = removeAt(data, form_identifier)

	if(isResolved) {

		store.dispatch('updateFormFields', data);
		
		window.emitter.emit('updateNestedObjects');
		
		window.emitter.emit('updateMenuCount', { field: fieldVal, from: 'local' })
		
		onEditClose()
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

		showLoader.value = false;
		
		window.emitter.emit('updateNestedObjects');
		
		window.emitter.emit('updateMenuCount', { field: fieldVal, from: 'db' })
		
		onEditClose();
		
		if(selectedType.value === 'default_fields') {

			window.emitter.emit('removeElementFromDB');
		}
		
	}).catch(error => {

		showLoader.value = false;

		errorHandler(error, 'form-builder-main');
	});
}

/**
 * Checks if the element should be deleted from the database.
 * @param {Object} fieldData - Information about the field data.
 * @returns {boolean} - Returns true if the element should be deleted from the database, otherwise false.
 */
const isDeleteFromDB = (fieldData) => {

	if(fieldData.type === 'group') {

		return typeof fieldData.groupid === 'undefined';
	}

	return fieldData.temp_id ? fieldData.temp_id.toString().length < 13 : fieldData.id.toString().length < 13;
}

/**
 * Removes the element at the specified form identifier from the array recursively.
 * @param {Array} array - The array to remove the element from.
 * @param {string} form_identifier - The identifier of the element to be removed.
 * @returns {Promise<boolean>} - A promise that resolves to true.
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

const dontWant = () => {
	
	hasFormFieldsLoaded.value = false;
	
	hasMenuLoaded.value = false;
	
	getMenuJson();
	
	getFormDataFromServer().then(() => {
		
		selectedType.value = selectedMenuType.value;
		
		showSaveDiscardModal.value = false;
		
		hasFormFieldsLoaded.value = true;
		
		formBuilderIsModified.value = false;
	})
}

const saveChanges = () => {
	
	onSaveForm();
	
	selectedType.value = selectedMenuType.value;
	
	showSaveDiscardModal.value = false;
	
	formBuilderIsModified.value = false;
	
	getMenuJson();
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
window.emitter.on('formBuilderModified',() => {
	formBuilderIsModified.value = true;
})

window.emitter.on('formLangRemoved',onEditClose);
window.emitter.on('formLangRemovedInDb',onLangRemoved);

</script>

<template>

	<div class="col-sm-12">

		<Alert component-name="form-builder-main"></Alert>

		<div class="row">

			<div v-if="hasMenuLoaded" class="col-sm-3">

				<div class="card sticky-top sticky-fields mb-1">

					<div class="p-2">

						<div class="row">

							<div class="col-12">

								<ul class="nav nav-tabs" role="tablist">

									<li class="nav-item">

										<a class="nav-link" href="javascript:;" @click="toggleFields('fields')"
										   :class="selectedType === 'fields' ? 'active font-weight-bold plr-5' : ''" data-bs-toggle="pill" role="tab">
											{{ trans('formfields') }}
										</a>
									</li>

									<li v-if="!isDefaultForm" class="nav-item">

										<a class="nav-link" href="javascript:;" @click="toggleFields('default_fields')"
										   :class="selectedType === 'default_fields' ? 'active font-weight-bold plr-5' : ''" data-bs-toggle="pill" role="tab">
											{{ trans('default_fields') }}
										</a>
									</li>

									<li v-if="isMultipleForm" class="nav-item">

										<a class="nav-link" href="javascript:;" @click="toggleFields('shared_fields')"
										   :class="selectedType === 'shared_fields' ? 'active font-weight-bold plr-5' : ''" data-bs-toggle="pill" role="tab">
											{{ trans('shared_fields') }}
										</a>
									</li>
								</ul>

								<Menu :key="selectedType" :type="selectedType" :isDefaultForm="isDefaultForm"></Menu>
							</div>
						</div>
					</div>
				</div>
			</div>

			<template v-if="hasFormFieldsLoaded && hasMenuLoaded">

				<div class="col-sm-9">

					<div class="card card-light">

						<CustomLoader v-if="showLoader"></CustomLoader>

						<div v-if="hasFormFieldsLoaded && hasMenuLoaded" class="card-header">

							<h3 class="card-title">{{ pageHeading }}</h3>

							<div class="card-tools">

								<button class="btn btn-primary form-save-btn float-end form_save_btn" @click="onSaveForm()">

									<i class="fas fa-save"></i> {{ trans('save') }}
								</button>

								<StatusSwitch v-if="!isDefaultForm" name="is_active" :value="isFormActive" :onChange="(value) => isFormActive = value"
								              classname="float-end" :bold="true">
								</StatusSwitch>
							</div>
						</div>

						<div class="card-body p-2">

							<Sections :sections="formSectionsStoreValue" :auth="auth" :formType="formType">

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

				<FieldSettings v-if="showSettingModal" :fieldData="selectedFormFieldObject" :isShowSettingModal="showSettingModal" :onCloseSettingModal="onEditClose" :auth="auth">

				</FieldSettings>
			</template>
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
		
		<transition name="modal">
			
			<Modal v-if="showSaveDiscardModal" :showModal="true" :show-close-btn="false" :containerStyle="{width:'400px'}"
				footerClass="justify-content-between">
				
				<template #title>
					
					<h4 class="modal-title">{{trans('confirm')}}</h4>
				</template>
				
				<template #fields>
					
					<span>{{trans('do_you_want_to_save_these_changes')}}</span>
				</template>
				
				<template #controls>
					
					<button type="button" @click="dontWant()" class="btn btn-light">
						
						<i class="fas fa-times" aria-hidden="true"></i>&nbsp;{{trans('no_discard')}}
					</button>
					
					<button type="button" @click="saveChanges()" class="btn btn-primary">
						
						<i class="fas fa-check" aria-hidden="true"></i>&nbsp;{{trans('yes_keep')}}
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

	.sticky-fields { position: sticky !important; }

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

	.plr-5 { padding-left: 5px; padding-right: 5px; }
</style>