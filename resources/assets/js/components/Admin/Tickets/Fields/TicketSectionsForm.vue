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
import Menu from "../../Manage/NewFormBuilder/Builder/Menu.vue";
import globalMixin from "../../../../mixins/globalMixin";
import Sections from "../../Manage/NewFormBuilder/Builder/Sections.vue";
import FieldSettings from "../../Manage/NewFormBuilder/Builder/FieldSettings.vue";
import Modal from "../../../Common/Modal.vue";
const { basePathVersion } = globalMixin.methods;

let props = defineProps({
	auth: { type: Object, default: () => ({}) },
});

const showLoader = ref(true);
const hasMenuLoaded = ref(false);
const hasFormFieldsLoaded = ref(false);

const showDeleteModal = ref(false);
const deleteType = ref('');
const deleteData = ref('');
const deleteId = ref('');

onBeforeMount(()=>{

	getMenuJson();

	assignFormFields();
});

const getMenuJson = () => {

	axios.get('api/get-form-menu/ticket').then(res => {

		store.commit('updateFormMenu', res.data.data);

		hasMenuLoaded.value = true;
	});
}

const assignFormFields = () => {

	getFormDataFromServer().then((resp) => {

		hasFormFieldsLoaded.value = true;
	})
}

const getFormDataFromServer = () => {

	showLoader.value = true;

	let apiEndpoint = route.name === 'ticket.sections.edit' ? '/field-manager/ticket?data_type='+route.params.type+'&id='+route.params.id : '/field-manager-section';

	return axios.get(apiEndpoint).then((response) => {

		store.commit('updateFormSections', route.name === 'ticket.sections.edit' ? [response.data.data] : response.data.data);

		showLoader.value = false;

		return response

	}).catch((error) => {

		showLoader.value = false;

		errorHandler(error, 'ticket-section');
	})
}

const onSaveForm = async () => {

	const formBuilderData = store.getters.getFormSections;

	assignSortOrder(formBuilderData);

	await saveForm(formBuilderData);
}

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

		const api = '/post/field-managers/ticket';

		const resp = await postFormData(api, filteredData);

		handleSuccess(resp);

	} catch (error) {

		handleFailure(error);
	}
}

const postFormData = async (api, formBuilderData) => {

	let filtered = flattenFormFields(formBuilderData);
	
	onEditClose();
	
	return await axios.post(api, filtered[0]);
}

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

				if (boolean(element.options)) {

					element.options.forEach(element => {

						flattenFormFields(element.nodes)
					})
				}
			});
		} else {

			if (boolean(fields[i].options)) {

				fields[i].options.forEach(element => {

					flattenFormFields(element.nodes)
				})
			}
		}
	}

	return fields
};

const handleSuccess = (resp) => {

	successHandler(resp, 'ticket-section');

	if(route.name === 'ticket.sections.create') {

		router.push({ path: '/ticket-fields/list', query : { page: 'sections' } });

	} else {

		handleSuccessForOther();
	}
}


const handleSuccessForOther = () => {

	getFormDataFromServer().then(() => {

		showLoader.value = false;
	});
}

const handleFailure = (error) => {

	showLoader.value = false;

	errorHandler(error, 'ticket-section');
}

let showSettingModal = ref(false);

let selectedFormFieldObject = ref(null);

const onEditClose = () => {

	showSettingModal.value = false;

	selectedFormFieldObject.value = null;
}

const onFieldEdit = ({data}) => {

	showSettingModal.value = false;

	selectedFormFieldObject.value = data;

	setTimeout(() => {

		showSettingModal.value = true;
	}, 0)
}

const formSectionsStoreValue = computed({
	get() {
		return store.getters.getFormSections;
	},
	set(value) {
		store.dispatch('updateFormSections', value);
	}
});

const applySettingsChanges = async (changedValue) => {

	const data = store.getters.getFormSections;

	const isResolved = await assignNewValue(data, changedValue.form_identifier, changedValue);

	if (isResolved) {

		await store.dispatch('updateFormSections', data);
	}
	
	onEditClose();
	
	window.emitter.emit('updateNestedObjects');
}

const assignNewValue = (array, affectedId, newObj) => {

	let idx = _.findIndex(array, (element) => element.form_identifier === affectedId);

	if (idx !== -1) {

		array[idx] = newObj;

	} else {

		for (let i = 0; i < array.length; i++) {

			if (array[i].form_fields && typeof array[i].form_fields === 'object') {

				Object.keys(array[i].form_fields).forEach(key => {

					assignNewValue(array[i].form_fields[key], affectedId, newObj);
				});
			} else {

				if (boolean(array[i].options)) {

					array[i].options.forEach(element => {

						assignNewValue(element.nodes, affectedId, newObj)
					})
				}
			}
		}
	}

	return new Promise(resolve => {

		resolve(true);
	});
}

const onRemoveElement = (obj) => {
	showDeleteModal.value = true;
	deleteType.value = obj['reference_type'];
	deleteData.value = obj['fieldData'];
	deleteId.value = obj['reference_id'];
}

const doDelete = () => {

	showDeleteModal.value = false;

	if (isDeleteFromDB(deleteData.value)) {

		deleteElementFormDB(deleteData.value.id, deleteId.value, deleteType.value, deleteData.value);

	} else {

		deleteElementLocally(deleteData.value.form_identifier, deleteData.value);
	}
}

const deleteElementLocally = (form_identifier, fieldVal) => {

	const data = store.getters.getFormSections;

	const isResolved = removeAt(data, form_identifier)

	if (isResolved) {
		
		onEditClose();
		
		window.emitter.emit('updateNestedObjects');
		
		window.emitter.emit('updateMenuCount', { field: fieldVal, from: 'local' })
		
		store.dispatch('updateFormFields', data);
	}
}

const deleteElementFormDB = (id, reference_id, reference_type, fieldVal) => {

	showLoader.value = true;

	let api = deleteData.value.data_type === 'section' ? '/remove/form-sections/' + id : '/remove/form-fields/' + id;

	axios.delete(api).then(resp => {

		successHandler(resp, 'ticket-section');
		
		hasFormFieldsLoaded.value = false;
		
		getFormDataFromServer().then(() => {
			
			hasFormFieldsLoaded.value = true;
		})

		showLoader.value = false;
		
		window.emitter.emit('updateNestedObjects');
		
		window.emitter.emit('updateMenuCount', { field: fieldVal, from: 'db' })
		
		onEditClose();

	}).catch(error => {

		showLoader.value = false;

		errorHandler(error, 'ticket-section');
	});
}

const isDeleteFromDB = (fieldData) => {

	if (fieldData.type === 'group') {

		return typeof fieldData.groupid === 'undefined';
	}

	return fieldData.id.toString().length < 13;
}

const removeAt = (array, form_identifier) => {

	let idx = _.findIndex(array, (element) => element.form_identifier === form_identifier);

	if (idx !== -1) {

		array.splice(idx, 1);

	} else {

		for (let i = 0; i < array.length; i++) {

			if (array[i].form_fields && typeof array[i].form_fields === 'object') {

				Object.keys(array[i].form_fields).forEach(key => {

					removeAt(array[i].form_fields[key], form_identifier)
				});

			} else {

				if (boolean(array[i].options)) {

					array[i].options.forEach(element => {

						removeAt(element.nodes, form_identifier)
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

	}).catch((err) => {

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

	<Alert component-name="ticket-section"></Alert>

	<div class="card card-light shadow-none">

		<div class="card-header sticky-top menu-border sticky-top-menu">

			<CustomLoader v-if="showLoader"></CustomLoader>

			<h3 class="card-title">
				{{ trans('ticket_section') }}
			</h3>

			<div class="card-tools" v-if="hasFormFieldsLoaded && hasMenuLoaded">

				<button class="btn btn-primary form_save_btn float-end form-save-btn" @click="onSaveForm()">

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

									<div class="btn-group w-100">

										<a class="btn btn-light field-btn active cursor-default">
											{{ trans('formfields') }}
										</a>
									</div>

									<Menu from="ticket-sections"></Menu>
								</div>
							</div>
						</div>
					</div>
				</div>

				<template v-if="hasFormFieldsLoaded && hasMenuLoaded">

					<div :class="showSettingModal ? 'col-sm-6' : 'col-sm-9'">

						<div class="card">

							<div class="card-body p-2">

								<Sections :sections="formSectionsStoreValue" :auth="auth">

								</Sections>

								<div v-if="!formSectionsStoreValue.length" class="row no-drag-form-card">

									<div class="text-center pt-4 no-drag-fields">

										<img :src="basePathVersion()+'/themes/default/common/images/drag.png'"
											 alt="form-no-drag"
											 class="no-drag-img">

										<h5>{{ trans('drag_elements_here') }}</h5>

										<p>{{ trans('drag_an_element_from_the_left') }}</p>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div v-if="showSettingModal" class="col-sm-3">

						<FieldSettings :fieldData="selectedFormFieldObject" :isShowSettingModal="showSettingModal"
						   :onCloseSettingModal="onEditClose" :auth="auth" from="ticket-fields-form" :fieldUpdate="applySettingsChanges"
							settingBtnName="apply">

						</FieldSettings>
					</div>
				</template>
			</div>
		</div>
	</div>

	<transition name="modal">

		<Modal v-if="showDeleteModal" :showModal="true" :onClose="() => showDeleteModal = false"
			   :containerStyle="{width:'400px'}">

			<template #title>

				<h4 class="modal-title">{{ trans('delete') }}</h4>
			</template>

			<template #fields>

				<span>{{ trans('are_you_sure_you_want_to_delete') }}</span>
			</template>

			<template #controls>
				<button id="approval-action-confirm" type="button" @click="doDelete()" class="btn btn-secondary">
					<i class="fas fa-trash-alt" aria-hidden="true"></i>&nbsp;{{ trans('confirm') }}
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

.sticky-top-menu {
	position: sticky !important;
	top: 45px !important;
}

.sticky-fields {
	position: sticky !important;
	top: 100px !important;
}

.btn-light:not(:disabled):not(.disabled).active {
	background-color: #c0c3c4;
	border-color: #c0c3c4;
}

.field-btn {
	margin-right: 0px !important;
}

.no-drag-form-card {
	min-height: 170px;
}

.no-drag-fields {
	position: absolute !important;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	opacity: 0.3;
}

.no-drag-img {
	width: 60px;
	height: 60px;
}

.form_save_btn { margin: -5px 4px -12px 10px; padding: 4px 8px}
</style>