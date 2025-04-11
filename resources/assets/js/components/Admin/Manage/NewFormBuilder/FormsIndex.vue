<script setup>

import {onBeforeMount, ref, reactive, h, computed} from "vue";
import Datatable from "../../../Extra/DataTable.vue";
import Alert from "../../../MiniComponent/Alert.vue";
import Modal from "../../../Common/Modal.vue";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import {createTicketFormValidation} from "../../../../helpers/validator/formBuilder/createTicketFormRules";
import axios from "axios";
import {errorHandler, successHandler} from "../../../../helpers/responseHandler";
import ReuseLoader from "../../../Client/Pages/ReusableComponents/Loader.vue";
import FormTableActions from "./Table/FormTableActions.vue";
import {lang} from "../../../../helpers/extraLogics";

import {useStore} from "vuex";
import {RouterLink, useRoute, useRouter} from "vue-router";
import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
const store = useStore();

const route = useRoute();
const router = useRouter();

// The URL for fetching the list of forms.
const listApiUrl = ref('/ticket/forms/'+route.params.type);

// The columns to be displayed in the table.
const tableColumns = ref(['name', 'is_active', 'created_at', 'actions']);

// Options for customizing the table.
const tableOptions = ref({});

// Indicates whether organization details should be shown.
const showOrganization = ref(false);

onBeforeMount(()=>{

	store.dispatch('updateCloneableFormData','')

	tableOptions.value = {

		sortIcon: { base : 'glyphicon', up: 'glyphicon-chevron-down', down: 'glyphicon-chevron-up' },

		columnsClasses : {

			title: 'form-name',

			created_at : 'form-created',

			is_active: 'form-active',

			actions : 'form-actions'
		},

		headings: { is_active: lang('status') },

		texts: { filter: '', limit: '' },

		sortable:  ['name', 'created_at', 'is_active'],

		filterable:  ['name', 'created_at', 'is_active'],

		pagination: { chunk : 5, nav : 'fixed', edge : true},

		requestAdapter(data) {

			return {

				'paginate' : 1,

				'sort-field' : data.orderBy ? data.orderBy : 'id',

				'sort-order' : !data.ascending ? 'desc' : 'asc',

				'search-query' : data.query.trim(),

				page : data.page,

				limit : data.limit,
			}
		},

		responseAdapter({data}) {

			showOrganization.value = !!data.data.show_org;

			return {

				data: data.data.data.map(data => {

					data.edit_url = '/new/forms/' + data.category + '/edit';

					data.componentTitle = 'dataTableTittle';

					data.alertComponentName = 'form-builder-index';

					return data;
				}),
				count: data.data.total
			}
		},

		orderBy: { column: 'id', ascending: true },

		templates : {

			name: (f, row) => {

				return h(RouterLink, {

					to: '/new/forms/'+row.category+'/'+row.id+'/edit'

				}, row.name);
			},

			created_at: (f,row) => {

				return store.getters.formattedTime(row.created_at);
			},
			
			is_active: (f, row) => {

				let span = h('span', {
					'style' : 'cursor:auto',
					'class' : row.is_active ? 'btn btn-success btn-sm' : 'btn btn-danger btn-sm'
				}, row.is_active ? 'Active' : 'Inactive');

				return h('a', {}, [span]);
			},

			actions: (f,row)=>{

				return h(FormTableActions,{data:row, onUpdate:onUpdate, onClone:onClone})
			},
		}
	}
});

// Indicates whether the pop-up for editing is visible.
const popUpForEdit = ref(false);
// Data associated with the pop-up for editing.
const popUpForEditData = ref('');
// Indicates whether the pop-up for cloning is visible.
const popUpForClone = ref(false);
// Data associated with the pop-up for cloning.
const popUpForCloneData = ref('');

/**
 * Initiates the cloning process and opens the modal.
 * @param {object} value - The data of the item to be cloned.
 */
const onClone = (value) => {
	
	showModal.value = true;

	state.name = 'Copy of ' + value.name;
	state.is_user_form = value.is_user_form;

	popUpForClone.value = true;

	popUpForCloneData.value = value;
}

/**
 * Initiates the update process and opens the modal.
 * @param {object} value - The data of the item to be updated.
 */
const onUpdate = (value) => {
	
	showModal.value = true;

	state.name = value.name;
	state.organizations = value.organizations;
	state.is_user_form = value.is_user_form;

	popUpForEdit.value = true;

	popUpForEditData.value = value;
}

// Indicates whether the modal is visible.
const showModal = ref(false);

// State object for holding the name and organizations.
const state = reactive({
	name: '',
	organizations: [],
	is_user_form: false
});

// Indicates whether loading is in progress.
const loading = ref(false);
// Indicates whether the button is disabled.
const isDisabled = ref(false);

/**
 * Updates the state based on the input value.
 * @param {any} value - The new value.
 * @param {string} inputName - The name of the input field.
 */
const onChange = function (value,inputName) {

	state[inputName] = value;
};

/**
 * Closes the modal and resets state.
 */
const onClose = () => {

	store.dispatch('unsetValidationError')

	showModal.value = false;

	state.name = "";
	state.organizations = [];
	state.is_user_form = false;

	isDisabled.value = false;

	popUpForEdit.value = false;
	popUpForEditData.value = "";
	popUpForClone.value = false;
	popUpForCloneData.value = "";
}

/**
 * Checks if the form data is valid.
 * @returns {boolean} - Indicates whether the form data is valid.
 */
const isValid = () => {

	const { errors, isValid } = createTicketFormValidation(state);

	return isValid
}

/**
 * Submits the form data.
 */
const onSubmit = () => {

	if(isValid()) {

		loading.value = true

		isDisabled.value = true

		let data = {};

		data['name'] = state.name;

		if(popUpForEdit.value) {

			data['id'] = popUpForEditData.value.id;
		}

		if(popUpForClone.value) {

			data['id'] = popUpForCloneData.value.id;
		}

		if(state.organizations && state.organizations.length) {

			data['org_ids'] = state.organizations.map(obj=>obj.id);
		}
		
		if(showFormCheckbox.value) {
			
			data['is_user_form'] = state.is_user_form;
		}

		let endpoint = popUpForEdit.value ? '/'+popUpForEditData.value.update_api : popUpForClone.value ? '/clone-forms' : '/add/custom/form/'+route.params.type;

		axios.post(endpoint, data).then(res => {

			loading.value = false

			if(!popUpForClone.value) {

				successHandler(res, 'form-builder-index');
			}

			if(!popUpForEdit.value) {

				router.push({ path : `/new/forms/${res.data.data.category}/${res.data.data.id}/edit` })

			} else {

				window.emitter.emit('refreshData');
			}

			if(popUpForClone.value) {

				store.dispatch('updateCloneableFormData',popUpForCloneData.value)
			}

			onClose();

		}).catch(err => {

			loading.value = false;

			isDisabled.value = false

			errorHandler(err, 'form-builder-index');

		})
	}
}

/**
 * Computed property for determining the modal title based on the pop-up state.
 */
const modalTitle = computed(()=>{

	return popUpForEdit.value ? 'edit_form' : popUpForClone.value ? 'clone_form' : 'create_new_form_category'
})

/**
 * Computed property for determining the button name based on the pop-up state.
 */
const btnName = computed(()=>{

	return popUpForEdit.value ? 'update' : popUpForClone.value ? 'clone' : 'save'
})


/**
 * Computed property for determining the icon class based on the pop-up state.
 */
const iconClass = computed(()=>{

	return popUpForEdit.value ? 'fas fa-sync-alt' : popUpForClone.value ? 'far fa-clone' : 'fas fa-save'
})

/**
 * Computed property for determining whether to show organization based on current state.
 */
const showOrg = computed(()=>{

	if(showOrganization.value) {

		if(!popUpForEdit.value && !popUpForClone.value) {

			return true;

		} else if(popUpForClone.value) {

			return false

		} else if(popUpForEdit.value && !popUpForEditData.value.is_default) {

			return true

		} else {

			return false
		}
	} else {

		return false
	}
})

const showFormCheckbox = computed(()=>{
	
	if(route.params.type === 'ticket') {

		if(!popUpForEdit.value && !popUpForClone.value) {
			
			return true;
			
		} else if(popUpForClone.value && !popUpForCloneData.value.is_default) {
			
			return true
			
		} else if(popUpForEdit.value && !popUpForEditData.value.is_default) {
			
			return true
			
		} else {
			
			return false
		}
	} else {
		
		return false
	}
})
</script>

<template>

	<div class="col-sm-12">

		<Alert component-name="form-builder-index"></Alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{ trans('list_of_form_categories') }}</h3>

				<div class="card-tools">

					<a href="javascript:;" class="btn-tool" v-tooltip="{content: trans('create_form'), placement: 'left'}" @click="showModal = true">

						<i class="glyphicon glyphicon-plus"> </i>
					</a>
				</div>
			</div>

			<div class="card-body" id="forms-list">

				<Datatable :url="listApiUrl" :data-columns="tableColumns" :option="tableOptions" scroll_to ="forms-list">

				</Datatable>
			</div>
		</div>

		<Modal v-if="showModal" :showModal="showModal" :onClose="onClose">

			<template #title>

				<h4 class="modal-title"> {{ trans(modalTitle) }}</h4>
			</template>

			<template #fields>

				<div v-if="!loading" class="row" v-focus-first-input>

					<TextField :label="trans('name')" :value="state.name" type="text" name="name" :hint="trans('special_characters_are_not_supported')"
						:onChange="onChange" :required="true" classname="col-sm-12" @keyup.enter="onSubmit()">

					</TextField>
					
					<div class="form-check col-sm-12 ms-md-2 mb-3" v-if="showFormCheckbox">
						
						<input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="state.is_user_form" id="is_user_form">
						
						<label class="form-check-label" for="is_user_form">{{trans('enable_user_form')}}</label>
					</div>
					
					
					<DynamicSelect v-if="showOrg && state.is_user_form" :label="trans('organizations')" :multiple="true" name="organizations" :prePopulate="true" classname="col-sm-12"
					               apiEndpoint="/api/dependency/organizations" :value="state.organizations" :onChange="onChange"
					>
					
					</DynamicSelect>
				</div>

				<div v-if="loading" class="row">

					<ReuseLoader/>
				</div>
			</template>

			<template #controls>

				<button type="button" @click="onSubmit()" class="btn btn-primary" :disabled="isDisabled">

					<i :class="iconClass" aria-hidden="true"></i> {{trans(btnName)}}
				</button>
			</template>
		</Modal>
	</div>
</template>

<style>

	.form-name,.form-created, .form-actions, .form-active{
		max-width: 250px; word-break: break-all;
	}

	#forms-list .VueTables .table-responsive {
		overflow-x: auto;
	}

	#forms-list .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>