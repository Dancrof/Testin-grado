<script setup>

import {ref, computed} from "vue";

import draggable from 'vuedraggable';

import ReuseLoader from "../../../../Client/Pages/ReusableComponents/Loader.vue";

import {useStore} from "vuex";
import axios from "axios";
const store = useStore();

import {useRoute, useRouter} from "vue-router";
import {boolean} from "../../../../../helpers/extraLogics";
const router = useRouter();
const route = useRoute();

/**
 * Props passed to the component
 * @prop {String} type - The type of the component
 * @prop {String} from - The source of the component
 */
const props = defineProps({

    type : { type : String, default : 'fields' },

    from: { type: String, default : '' },

    isDefaultForm: { type: Boolean, default : false },
})

//Retrieves the form menus from the Vuex store.
const formMenus = store.getters.getFormMenus;
// Retrieves the form category type from the Vuex store.
const formCategoryType = store.getters.getFormCategoryType;

const screenWidth = ref(window.innerWidth);

window.addEventListener('resize', () => {
    screenWidth.value = window.innerWidth;
});

// Computed property to get only the form sections from the form menus.
const getFormSection = computed(() => {

    return formMenus.filter(obj => obj.data_type === 'section');
});
// Computed property to get the filtered form menus excluding form sections.
const getFormFilteredMenu = computed(() => {

    return formMenus.filter(obj => obj.data_type !== 'section');
});

/**
 * Clones an element by creating a deep copy of the provided data.
 * If the data represents a group, it assigns a new group ID.
 * If the data represents a form field, it assigns a new ID.
 * Also assigns a new form identifier using the current timestamp.
 * @param {Object} data - The data of the element to clone.
 * @returns {Object} - The cloned element with updated IDs and form identifier.
 */
const cloneElement = (data) => {

    let newData = JSON.parse(JSON.stringify(data));

    const currentTimestamp = getCurrentTimestamp();

    if (newData.data_type === 'group') {

        newData.groupid = currentTimestamp;

    } else {

        newData.id = currentTimestamp;
    }

    newData.form_identifier = currentTimestamp;

    return newData;
}

/**
 * Gets the current timestamp in milliseconds.
 * @returns {number} - The current timestamp.
 */
const getCurrentTimestamp = () => {

    return new Date().getTime();
}

// for storing the search term used for filtering fields.
const searchTerm = ref('');
// for indicating whether the shared loader is active or not
const sharedLoader = ref(false);
// for storing the list of shared fields.
const sharedFieldsList = ref([]);
// Variable to keep track of the current page number when loading more data.
let page = 1;
// for indicating whether data loading is in progress.
const loading = ref(false);
// Flag to indicate whether there is more data available to load.
let hasMoreData = true;
// List of default fields.
const defaultFieldsList = ref([]);
const defaultLoader = ref(false);

/**
 * Fetches the default menu if the form is not a default form.
 */
const getDefaultMenu = () => {

    if (props.isDefaultForm) { return; }

    let parameters = { id: route.params.id };

    defaultLoader.value = true;

    axios.get('/default/form-fields/'+route.params.type+'?time='+Date.now(), { params: parameters }).then(res => {

        defaultFieldsList.value = res.data.data;

    }).catch(err => {

        console.error('Error in getting default fields list ', err);

    }).finally(() => {

        defaultLoader.value = false;
    })
}

const updateDefaultMenu = () => {

    defaultLoader.value = true;

    defaultFieldsList.value = [];

    setTimeout(()=>{

        getDefaultMenu()
    },1000);
}

/**
 * Function to fetch shared menu data from the server.
 * Increments the page number for pagination.
 */
const getSharedMenu = async () => {
    try {
        sharedLoader.value = true;
        const response = await axios.get(`/get/shared-fields/ticket?page=${page}`,{ params: { id: route.params.id } });

        if (response.data.data.length > 0) {
            sharedFieldsList.value = [...sharedFieldsList.value, ...response.data.data];
            page++;
        } else {
            // No more data, set the flag to false
            hasMoreData = false;
        }

    } catch (error) {
        console.error('Error fetching data:', error);
    } finally {
        sharedLoader.value = false;
    }
};

// Call getSharedMenu() if the component type is 'shared_fields'
if(props.type === 'shared_fields') {

    getSharedMenu();
}

if(props.type === 'default_fields') {

    getDefaultMenu();
}

/**
 * Computed property to filter the shared fields list based on the search term.
 */
const filteredSharedFieldsList = computed(() => {
    return sharedFieldsList.value.filter(item =>
        item.label.toLowerCase().includes(searchTerm.value.toLowerCase())
    );
});

/**
 * Computed property to group the shared form data based on the 'type' property.
 */
const groupedFormData = computed(() => {
    // Group the formData array based on the 'type' property
    return filteredSharedFieldsList.value.reduce((grouped, field) => {
        if (!grouped[field.data_type]) {
            grouped[field.data_type] = [];
        }
        grouped[field.data_type].push(field);

        return grouped;
    }, {});
});

/**
 * Function to handle scrolling in the card container.
 * Fetches more shared menu data if user scrolls near the bottom and more data is available.
 */
const handleCardScroll = () => {
    const cardContainer = document.getElementById('card-container');
    const scrollHeight = cardContainer.scrollHeight;
    const scrollTop = cardContainer.scrollTop;
    const clientHeight = cardContainer.clientHeight;

    if (scrollTop + clientHeight >= scrollHeight - 100 && !loading.value && hasMoreData) {
        getSharedMenu();
    }
};

/**
 * Function to get the group configuration based on the type.
 * Returns an object with name, pull, and put properties.
 * @param {string} type - The type of the group.
 * @returns {Object} - The group configuration object.
 */
const getGroup = (type) => {

    return type === 'section' ? { name: 'faveo-form-sections', pull: 'clone', put: false } : { name: 'faveo-form-builder', pull: 'clone', put: false }
}

function onEnd(e) {

    if(e.to != e.from) {

        let dropedElem = formMenus.find(item => item.id === e.item.__draggable_context.element.id)

        if(dropedElem) {
            dropedElem.count -= 1;
            window.emitter.emit('formBuilderModified');
        }
    }
}

function onChildSelectEnd(value) {

    let dropedElem = formMenus.find(item => item.id === value.id)

    if(dropedElem) {
        dropedElem.count -= 1;
        window.emitter.emit('formBuilderModified');
    }
}

const updateSharedMenuCounts = (value, from) => {

    let fieldVal = value.title === 'Api' ? sharedFieldsList.value.find(item => item.title === value.title) : sharedFieldsList.value.find(item => item.data_type === value.data_type);

    if(fieldVal) {

        fieldVal.count += 1;

        if(fieldVal.count) {

            fieldVal.disabled = false;
        }

        if(from === 'local') { window.emitter.emit('formBuilderModified'); }
    }

    if (value.form_fields && typeof value.form_fields === 'object') {

        Object.keys(value.form_fields).forEach(key => {

            const formFields = value.form_fields[key];

            for (let j = 0; j < formFields.length; j++) {

                updateSharedMenuCounts(formFields[j]);
            }
        });

    } else {

        if(boolean(value.options)) {

            value.options.forEach(element => {

                element.nodes.forEach(elem => {

                    updateAllCount(elem);
                })
            })
        }
    }
}

const updateAllCount = (value, from) => {

    let fieldVal = value.title === 'Api' ? formMenus.find(item => item.title === value.title) : formMenus.find(item => item.data_type === value.data_type)

    if(fieldVal) {

        fieldVal.count += 1;

        if(from === 'local') { window.emitter.emit('formBuilderModified'); }
    }

    if (value.form_fields && typeof value.form_fields === 'object') {

        Object.keys(value.form_fields).forEach(key => {

            const formFields = value.form_fields[key];

            for (let j = 0; j < formFields.length; j++) {

                updateAllCount(formFields[j]);
            }
        });

    } else {

        if(boolean(value.options)) {

            value.options.forEach(element => {

                element.nodes.forEach(elem => {

                    updateAllCount(elem);
                })
            })
        }
    }
}

const updateMenuCounts = (value) => {

    if(props.type === 'shared_fields') {

        updateSharedMenuCounts(value.field, value.from);

        return;
    }

    updateAllCount(value.field, value.from);
}

function onEndShared(e) {

    if(e.to != e.from) {

        let sharedDropedElem = sharedFieldsList.value.find(item => item.identifier === e.item.__draggable_context.element.identifier)

        if(sharedDropedElem) {

            updatedSharedCount(sharedDropedElem);
        }

        window.emitter.emit('formBuilderModified');
    }
}

function updatedSharedCount(sharedDropedElem) {

    sharedFieldsList.value.filter(obj => obj.data_type === sharedDropedElem.data_type).forEach(item => {

        item.count -= 1;

        if(!item.count) { item.disabled = true; }
    })

    if (sharedDropedElem.form_fields && typeof sharedDropedElem.form_fields === 'object') {

        Object.keys(sharedDropedElem.form_fields).forEach(key => {

            const formFields = sharedDropedElem.form_fields[key];

            for (let j = 0; j < formFields.length; j++) {

                updatedSharedCount(formFields[j]);
            }
        });
    }
}

window.emitter.on('removeElementFromDB', updateDefaultMenu);
window.emitter.on('updateMenuCount', updateMenuCounts);
window.emitter.on('updateMenuOnChildSelect', onChildSelectEnd);
</script>

<template>

    <div class="menu mt-3">

        <draggable v-if="type === 'fields'" class="form__menulist row" :list="getFormFilteredMenu" :group="{ name: 'faveo-form-builder', pull: 'clone', put: false }" :clone="cloneElement" itemKey="id"
                   :sort="false" @end="onEnd">

            <template #item="{ element, index }">

                <div :class="[screenWidth < 1220 ? 'col-sm-12' : 'col-sm-6', element.count ? '' : 'pe-none']">

                    <div class="info-box menu-info-box bg-light" :key="element.id" v-tooltip="element.title">

                        <div v-if="!element.count" class="overlay"></div>

                        <span v-if="element.icon_class" class="info-box-icon menu-icon">

							<i :class="['fas', element.icon_class]"></i>
						</span>

                        <div class="info-box-content">

							<span class="info-box-text">{{ element.title }}&nbsp;
								<small class="badge badge-count p-1">{{ element.count ? element.count : 0 }}</small>
							</span>
                        </div>
                    </div>
                </div>
            </template>
        </draggable>

        <draggable v-if="type === 'fields' && !from" class="form__menulist row" :list="getFormSection" :group="{ name: 'faveo-form-sections', pull: 'clone', put: false }" :clone="cloneElement" itemKey="id"
                   @end="onEnd">

            <template #item="{ element, index }">

                <div class="col-sm-12 text-center" :class="element.count ? '' : 'pe-none'">

                    <div class="info-box menu-info-box bg-light" :key="element.id" v-tooltip="element.title">

                        <div v-if="!element.count" class="overlay"></div>

                        <div class="info-box-content">

							<span class="info-box-text">{{ element.title }}&nbsp;
								<small class="badge badge-count p-1">{{ element.count ? element.count : 0 }}</small>
							</span>
                        </div>
                    </div>
                </div>
            </template>
        </draggable>

        <template v-if="type === 'default_fields'">

            <ReuseLoader v-if="defaultLoader"></ReuseLoader>

            <p v-if="!defaultLoader && !defaultFieldsList.length" class="text-center">{{ trans('no-records') }}</p>

            <draggable v-if="!defaultLoader" class="form__menulist row" :list="defaultFieldsList" :group="{ name: 'faveo-form-builder', put: false }" :clone="cloneElement" itemKey="id"
                       :sort="false">

                <template #item="{ element, index }">

                    <div :class="screenWidth < 1220 ? 'col-sm-12' : 'col-sm-6'">

                        <div class="info-box menu-info-box bg-light" :key="element.id" v-tooltip="element.title">

                            <div class="info-box-content">

                                <span class="info-box-text">{{ element.label }}</span>
                            </div>
                        </div>
                    </div>
                </template>
            </draggable>
        </template>

        <template v-if="type === 'shared_fields'">

            <ReuseLoader v-if="sharedLoader"></ReuseLoader>

            <div v-if="!sharedLoader && sharedFieldsList.length" class="search-container">

                <input type="text" placeholder="Search..." class="form-control" v-model="searchTerm">

                <i class="fas fa-search text-muted"></i>
            </div>

            <p v-if="!sharedLoader && !filteredSharedFieldsList.length" class="text-center pt-2" v-html="trans('create_ticket_fields')"></p>

            <div id="card-container" class="card-container mt-3" ref="cardContainer" @scroll="handleCardScroll">

                <div v-for="(group, type) in groupedFormData" :key="type" class="group-card">

					<span class="text-capitalize"><b>{{ type }}</b>&nbsp;
						<small class="badge badge-count p-1 mb-1">{{ group[0].count }}</small>
					</span>

                    <draggable class="form__menulist row" :list="group" :group="getGroup(type)" :clone="cloneElement" itemKey="id"
                               :sort="false" @end="onEndShared">

                        <template #item="{ element, index }">

                            <div class="col-sm-12" :class="!element.count ? 'pe-none' : ''">

                                <div class="info-box share-menu-info-box bg-light" :key="element.id" v-tooltip="element.title">

                                    <div v-if="!element.count" class="overlay"></div>

                                    <div class="info-box-content text-center">

                                        <span class="info-box-text">{{ element.label ? element.label : element.title }}</span>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </draggable>
                </div>
            </div>

            <div v-if="loading">Loading...</div>
        </template>
    </div>
</template>

<style scoped>

.menu-icon { font-size: 1.3rem !important; width: 60px !important; }

.menu-info-box { cursor : move; min-height: 40px !important; border: 1px dashed #c0c3c4; }

.search-container {
    position: relative;
}

.search-container input {
    padding-right: 30px; /* Space for the search icon */
}

.search-container i {
    position: absolute;
    top: 50%;
    right: 10px;
    transform: translateY(-50%);
    cursor: pointer;
}

#card-container {
    max-height: 300px;
    overflow-y: auto;
    overflow-x: hidden;
}

#card-container::-webkit-scrollbar-track
{
    background-color: #f1f1f1;
    border-radius:10px;
}
#card-container::-webkit-scrollbar
{
    width: 6px;
    background-color: #f1f1f1;
}
#card-container::-webkit-scrollbar-thumb
{
    background-color: #c1c1c1;
    border-radius: 10px;
}

.group-card {
    /*border: 1px dashed #ddd;*/
    /*border-radius: 0.25rem;*/
    /*background: #d3d3d336;*/
    /*padding: 10px;*/
    margin-right: 4px;
    /*margin-bottom: 10px;*/
}

.share-menu-info-box {
    cursor : move;
    min-height: 40px !important;
    border: 1px dashed #c0c3c4;
    margin-bottom: 0.5rem !important;
    padding: 0px !important;
}

.badge-count { background-color: #adb5bd !important; color: #fff;}
</style>