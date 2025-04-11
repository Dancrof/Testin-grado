<script setup>

import {onBeforeMount, ref} from "vue";
import moment from "moment/moment";
import copy from "clipboard-copy";
import axios from "axios";

import {useRoute, useRouter} from "vue-router";
const route = useRoute();
const router = useRouter();

import {useStore} from "vuex";
const store = useStore();

// Components
import FaveoBox from "../../../MiniComponent/FaveoBox.vue";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import Loader from "../../../MiniComponent/Loader.vue";
import ReuseLoader from "../../../Client/Pages/ReusableComponents/Loader.vue";
import Alert from "../../../MiniComponent/Alert.vue";
import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
import DateTimePicker from "../../../MiniComponent/FormField/DateTimePicker.vue";
import Checkbox from "../../../MiniComponent/FormField/Checkbox.vue";

import {validateReTokenForm, validateTokenForm} from "../../../../helpers/validator/validateTokenFormFields";
import {errorHandler, successHandler} from "../../../../helpers/responseHandler";
import {flatten} from "../../../../helpers/extraLogics";
import Modal from "../../../Common/Modal.vue";

// Variables
const isEditMode = ref(false);
const hasDataPopulated = ref(false);
const loading = ref(false);
let expiryOptions = ref('');
const showDateField = ref(false);
const copied = ref(false);
const selectAll = ref(false);
let form = ref({
    name : "",
    expiry : "",
    end_date : "",
    full_access : 1
})
const editFormData = ref('');
const selectedPermissionIdsSD = ref('');
const permissionsList = ref([]);
let start_date = new Date();
const showModal = ref(false);
const modalLoading = ref(false);
const isDisabled = ref(false);
const containerStyle = ref({ width:'600px' });

const allSDPermissionsSelected = ref(false);

onBeforeMount(()=>{

    getPermissions();

    getExpiryOptions();

    window.emitter.on("selected-permission-list", (data) => {

        selectedPermissionIdsSD.value = data.permissions;

		allSDPermissionsSelected.value = data.all_selected;
    })
});

//Methods
/**
 * Fetches expiry options from the server and updates the expiryOptions ref.
 */
const getExpiryOptions = () => {

    axios.get('/get/application-expiry').then(response=>{

        expiryOptions.value = response.data.data;

    }).catch(err=>{

        errorHandler(err,'token-form');
    })
}

/**
 * Fetches token form data from the server and updates the form and related refs.
 */
const getTokenFormData = () => {

    loading.value = true;

    axios.get('/get-api-application-id/'+route.params.id).then(res=>{

        // Update form data
        editFormData.value = res.data.data;

        form.value.name = editFormData.value.name;

        form.value.expiry = editFormData.value.expiry_id;

        // Show date fields if expiry is custom
        if(form.value.expiry === 'custom') {
            showDateField.value = true;
            form.value.end_date = editFormData.value.end_date;
        }

        form.value.full_access = editFormData.value.full_access;

        // Handle permissions
        let ctr = 0;

        let _tempVal = undefined

        editFormData.value.permission.forEach(function(element, index, array){

            ctr++;

            if(element.key === 'global_access' || element.key === 'restricted_access') {

                _tempVal = element.key
            }

            checkBoxOperations(true, element.key, true)

            if(ctr===array.length && _tempVal){

                handleGlobalResMode(true, _tempVal);
            }
        });

		selectAll.value = editFormData.value.all_permission_selected ? true : false;

		allSDPermissionsSelected.value = editFormData.value.all_sd_permission_selected ? true : false;

        showSdPermissionListBox(editFormData.value.permission);

        hasDataPopulated.value = true;

        loading.value = false;

    }).catch(err=>{

        errorHandler(err,'token-form')
    })
}

/**
 * Handles the change event for form fields and updates the form.
 * @param {any} value - The new value.
 * @param {string} fname - The field name.
 */
const onChange = (value,fname) => {

    form.value[fname] = value;

    if(fname === 'expiry') {

        // Show date fields if expiry is custom
        if(value === 'custom') {

            showDateField.value = true;

        } else {

            showDateField.value = false;

            form.value['end_date'] = ''
        }
    }
}

/**
 * Fetches permissions from the server and updates the permissionsList ref.
 */
const getPermissions = () =>{

    axios.get('api/dependency/permissions?limit=all', {}).then(res => {

        permissionsList.value = flatten(res.data.data);

        updatePermissions();

        if(route.name === 'personal_access_token.edit') {

            isEditMode.value = true;

            getTokenFormData();

        } else {

            hasDataPopulated.value = true;

            loading.value = false;
        }
    }).catch(err=>{

        errorHandler(err, 'token-form')
    })
}

/**
 * Updates the permissionsList ref by initializing and disabling certain permissions.
 */
const updatePermissions = () => {

    permissionsList.value.forEach(function(element) {

        element.checked = false ;

        element.disabled = false;

        element.title = ""

        if(element.key === "global_access"){

            element.title = "Restricted access will be disabled if global access is checked."

        } else if(element.key === "restricted_access"){

            element.title = "Global access will be disabled if restricted access is checked."

        }else if(element.key === "edit_articles_created_by_others"){

            element.disabled = true;
        }
    });
}

/**
 * Emits an event to show the permission list box with the given data.
 * @param {any} data - The data to be shown in the permission list box.
 */
const showSdPermissionListBox = (data) => {

    window.emitter.emit("permission-list-box-mounted",  { 'data' : data, 'all_sd_permission_selected' : allSDPermissionsSelected.value});
}

/**
 * Handles checkbox operations, updating the selectAll ref and permissionsList ref.
 * @param {boolean} value - The new checkbox value.
 * @param {string} selectedId - The ID of the selected checkbox.
 */
const checkBoxOperations = (value, selectedId) => {

    if(!value) {

        selectAll.value = false;
    }

    permissionsList.value.forEach(function(element) {

        if(element.key === selectedId) {

            element.checked = value;

            return;
        }

        handleGlobalResMode(value, selectedId);
    });
}

/**
 * Handles the global and restricted access mode based on the selected ID.
 * @param {boolean} value - The new checkbox value.
 * @param {string} selectedId - The ID of the selected checkbox.
 */
const handleGlobalResMode = (value, selectedId) => {

    if(!form.value.full_access){

        setTimeout(()=> {

            if(selectedId === 'global_access' || selectedId === 'restricted_access'){

                let restrictedId = selectedId === 'global_access' ? 'restricted_access' : 'global_access';

                if(permissionsList.value.find(obj => obj.key === selectedId).checked){

                    if(permissionsList.value.find(obj => obj.key === restrictedId).checked){

                        permissionsList.value.find(obj => obj.key === restrictedId).checked = false;

                        permissionsList.value.find(obj => obj.key === restrictedId).disabled = true;
                    }
                }

                document.getElementById(restrictedId).checked = false;

                document.getElementById(restrictedId).disabled = value;

                document.getElementById('view_all_tickets').checked = false;

                document.getElementById('view_all_tickets').disabled = value;
            }

            else if(selectedId === 'access_kb' ){

                if(permissionsList.value.find(obj => obj.key === 'access_kb').checked){

                    document.getElementById('edit_articles_created_by_others').disabled = false;

                } else {

                    document.getElementById('edit_articles_created_by_others').disabled = true;

                    document.getElementById('edit_articles_created_by_others').checked = false;
                }
            }
        },500)
    }
}

/**
 * Validates the token form and returns the validation result.
 * @returns {Object} - The validation result containing errors and isValid.
 */
const isValid = () => {

    const {errors, isValid} = validateTokenForm(form.value);

    return isValid;
}

/**
 * Submits the token form data to the server if it is valid.
 */
const onSubmit = () => {

    if(isValid()) {

        loading.value = true;

        let data = {};

        data['name'] = form.value.name;

        data['expiry'] = form.value.expiry;

        if(form.value.expiry === 'custom') {

            data['end_date'] =  moment(form.value.end_date).format("YYYY-MM-DD HH:mm:ss");
        }

        data['full_access'] = form.value.full_access;

        if(!form.value.full_access) {

            data['permission'] = permissionsList.value.filter(perm => perm.checked).map(p => p.key);

			data['all_permission_selected'] = selectAll.value;

            if(selectedPermissionIdsSD.value){

				data['all_sd_permission_selected'] = allSDPermissionsSelected.value;

                data['permission'] = data['permission'].concat(selectedPermissionIdsSD.value);
            }
        } else {

            data['permission'] = [];
        }

        if(route.name === 'personal_access_token.edit') {

            data['id'] = route.params.id;
        }

        if(!form.value.full_access && !data['permission'].length) {

            loading.value = false;

            store.dispatch('setAlert',{
                type:'danger',message:'Permissions are required', component_name : 'token-form'
            })

            return
        }

        axios.post('/post-api-application', data).then(res=>{

            loading.value = false;

			if(res.data.data && res.data.data.access_token) {

				access_token.value = res.data.data.access_token;

				showTokenModal.value = true;

				successHandler(res, 'token-modal-form');

			} else {

				successHandler(res, 'token-form');
			}
        }).catch(err=>{

            errorHandler(err, 'token-form');

            loading.value = false;
        })
    }
}

/**
 * Copies the access token to the clipboard and sets the copied ref to true.
 */
const copyToken = ()=> {

    copy(access_token.value);

    copied.value = true;

	setTimeout(()=>{

		copied.value = false;

		showTokenModal.value = false;

		if(route.name === 'personal_access_token.edit') {

			getTokenFormData();

		} else {

			router.push({ name: 'personal_access_token.index' })
		}

	},3000)
}

/**
 * Selects or deselects all permissions based on the selectAll ref.
 */
const selectAllPermissions = ()=>{

    if(selectAll.value) {

        permissionsList.value.forEach(function(element) {

            if(element.key !== 'restricted_access') {

                element.checked = true;
            }

            handleGlobalResMode(true, 'global_access');
        });

    } else {

        updatePermissions();
    }
}

/**
 * Handles the change event for access permissions and updates the selectAll ref and permissionsList ref.
 */
const handleAccessChange = () => {

    if(!isEditMode.value || (editFormData.value && !editFormData.value.permission.length)) {

        selectAll.value = false;

        updatePermissions();

        selectedPermissionIdsSD.value = ""
    }
}

/**
 * Closes the modal by setting the value of showModal to false.
 */
const onClose = () =>{

    showModal.value = false;
}

/**
 * Checks the validity of the token form using the validateReTokenForm function.
 * @returns {boolean} True if the token form is valid, otherwise false.
 */
const isReTokenValid = () => {

    const {errors, isValid} = validateReTokenForm(form.value);

    return isValid;
}

/**
 * Handles the update logic for a token, including form validation and API request.
 */
const onUpdate = () => {

    if(isReTokenValid()) {

        modalLoading.value = true;

        let data = {};

        data['expiry'] = form.value.expiry;

        if(form.value.expiry === 'custom') {

            data['end_date'] =  moment(form.value.end_date).format("YYYY-MM-DD HH:mm:ss");
        }

        data['full_access'] = form.value.full_access;

        if(!form.value.full_access) {

            data['permission'] = permissionsList.value.filter(perm => perm.checked).map(p => p.key);

			data['all_permission_selected'] = selectAll.value;

            if(selectedPermissionIdsSD.value){

				data['all_sd_permission_selected'] = allSDPermissionsSelected.value;
				
                data['permission'] = data['permission'].concat(selectedPermissionIdsSD.value);
            }
        } else {

            data['permission'] = [];
        }

        if(route.name === 'personal_access_token.edit') {

            data['id'] = route.params.id;
        }

        if(!form.value.full_access && !data['permission'].length) {

            modalLoading.value = false;

            store.dispatch('setAlert',{
                type:'danger',message:'Permissions are required', component_name : 'token-form'
            })

            onClose();

            return
        }

        axios.post('application/regenerate-token', data).then(res=>{

            modalLoading.value = false;

            onClose();

			if(res.data.data && res.data.data.access_token) {

				access_token.value = res.data.data.access_token;

				showTokenModal.value = true;

				successHandler(res, 'token-modal-form');

			} else {

				successHandler(res, 'token-form');
			}

        }).catch(err=>{

            errorHandler(err, 'token-form');

            modalLoading.value = false;

            onClose();
        })
    }
}

const showTokenModal = ref(false);

const access_token = ref('')

</script>

<template>

    <div class="col-sm-12">

        <div class="row" v-if="!hasDataPopulated || loading">

            <Loader></Loader>
        </div>

        <Alert component-name="token-form"></Alert>

        <FaveoBox v-if="hasDataPopulated" :title="isEditMode ? trans('edit') : trans('create')">

            <div class="row" v-focus-first-input>

                <TextField name="name" :value="form.name" :label="trans('application_name')" :classname="isEditMode ? 'col-sm-4' : 'col-sm-6'"
                   :onChange="onChange" :required="true">

                </TextField>

                <template v-if="isEditMode">

                    <div class="col-sm-4 mt-4">

                        <span v-if="isEditMode" class="re-token">

                            {{ trans('to-set-new-expiration-date-you-must') }}

                            <a href="javascript:;" @click="showModal = true"> {{ trans('regenerate-the-token') }}.</a>
                        </span>
                    </div>
                </template>

                <template v-if="!isEditMode">

                    <StaticSelect :label="trans('expiry_date')" :elements="expiryOptions" name="expiry"
                                  :value="form.expiry" :classname="showDateField ? 'col-sm-3' : 'col-sm-6'" :onChange="onChange" :required="true">

                    </StaticSelect>

                    <DateTimePicker v-if="showDateField" :label="trans('end_date')" :value="form.end_date" :required="true" name="end_date"
                                    type="date" :onChange="onChange" format="DD-MM-YYYY" classname="col-sm-3" :not-before="start_date"
                                    :exactDisabledDate="true">
                    </DateTimePicker>
                </template>
            </div>

            <div class="row mt-2">

                <div class="col-sm-3">

                    <div class="form-group">

                        <div class="custom-control custom-radio">

                            <input v-model="form.full_access" class="custom-control-input custom-control-input-primary custom-control-input-outline"
                                type="radio" id="full_access" :value="1" name="full_access" @change="handleAccessChange">

                            <label for="full_access" class="custom-control-label p-2">{{ trans('full_access') }}</label>
                        </div>
                    </div>
                </div>

                <div class="col-sm-3">

                    <div class="form-group">

                        <div class="custom-control custom-radio">

                            <input v-model="form.full_access" class="custom-control-input custom-control-input-primary custom-control-input-outline"
                               type="radio" id="restricted-access" :value="0" name="restricted-access" @change="handleAccessChange">

                            <label for="restricted-access" class="custom-control-label p-2">{{ trans('restricted_access') }}</label>
                        </div>
                    </div>
                </div>
            </div>

            <template v-if="!form.full_access">

                <FaveoBox :title="trans('access-permissions')" boxClass="card-light">

                    <template #customActions>

                        <div class="card-tools">

                            <div class="form-check">

                                <input type="checkbox" class="form-check-input" id="select-all"
                                    v-model="selectAll" @change="selectAllPermissions">

                                <label class="form-check-label" for="select-all"> {{ trans('select_all') }} </label>
                            </div>
                        </div>
                    </template>

                    <div class="row">

                        <div class="col-sm-4" id="assign_groups" v-for="item in permissionsList" :key="item.id">

                            <Checkbox :name="item.key" :value="item.checked" :disabled="item.disabled" :label="item.key"
                                :title="item.name" :onChange="checkBoxOperations" :id="item.key">
                            </Checkbox>
                        </div>
                    </div>
                </FaveoBox>

                <div id="permission-list-box">{{ showSdPermissionListBox(editFormData && editFormData.permission ? editFormData.permission : []) }}</div>
            </template>

            <template #actions>

                <div class="card-footer justify-content-end">

                    <button type="button" class="btn btn-primary" @click="onSubmit">

                        <i :class="isEditMode ? 'fas fa-sync-alt' : 'fas fa-save'"></i>
                        {{ isEditMode ? trans('update') : trans('save') }}
                    </button>
                </div>
            </template>
        </FaveoBox>

        <Modal v-if="showModal" :show-modal="showModal" :onClose="onClose" :containerStyle="containerStyle">

            <template #title>

                <h4 class="modal-title">{{trans('regenerate-token')}}</h4>
            </template>

            <template #fields>

                <div v-if="!modalLoading" class="row">

                    <StaticSelect :label="trans('expiry_date')" :elements="expiryOptions" name="expiry"
                                  :value="form.expiry" :classname="showDateField ? 'col-sm-6' : 'col-sm-12'" :onChange="onChange" :required="true">

                    </StaticSelect>

                    <DateTimePicker v-if="showDateField" :label="trans('end_date')" :value="form.end_date" :required="true" name="end_date"
                                    type="date" :onChange="onChange" format="DD-MM-YYYY" classname="col-sm-6" :not-before="start_date"
                                    :exactDisabledDate="true">
                    </DateTimePicker>
                </div>

                <div v-if="modalLoading" class="row">

                    <ReuseLoader/>
                </div>
            </template>

            <template #controls>

                <button type="button" @click="onUpdate" class="btn btn-primary" :disabled="isDisabled">

                    <i class="fas fa-sync-alt"></i> {{trans('update')}}
                </button>
            </template>
        </Modal>

		<Modal v-if="showTokenModal" :show-modal="showTokenModal" :showCloseBtn="false" :containerStyle="containerStyle">

			<template #title>

				<h4 class="modal-title">{{trans('access_token')}}</h4>
			</template>

			<template #alert>

				<Alert component-name="token-modal-form"></Alert>
			</template>

			<template #fields>

				<div class="row">

					<div class="col-sm-12">

						<div class="input-group mb-3">

							<input type="password" class="form-control" :value="access_token" disabled>

<!--							<div class="input-group-append" v-tooltip="!copied ? trans('copy') : trans('clipboard-copy-message')"-->
<!--								 @click="copyToken">-->

<!--								<span class="input-group-text">-->

<!--									<i :class="copied ? 'fas fa-check text-green' : 'fa fa-clipboard'"></i>-->
<!--								</span>-->
<!--							</div>-->
						</div>
					</div>
				</div>
			</template>

			<template #controls>

				<button type="button" @click="copyToken" class="btn btn-primary" :disabled="copied">

					<i :class="copied ? 'fas fa-check' : 'fa fa-clipboard'"></i> {{ !copied ? trans('copy') : trans('clipboard-copy-message') }}
				</button>
			</template>
		</Modal>
    </div>
</template>

<style scoped>

    .re-token {
        position: relative;
        top: 10px;
    }
</style>
