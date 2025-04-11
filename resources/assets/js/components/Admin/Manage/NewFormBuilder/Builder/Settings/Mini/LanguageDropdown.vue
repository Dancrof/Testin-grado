<script setup>

import {computed, onBeforeMount, ref, watch} from "vue";

import {useStore} from "vuex";
const store = useStore();

import Loader from "../../../../../../MiniComponent/Loader.vue";

import globalMixin from "../../../../../../../mixins/globalMixin";
import Modal from "../../../../../../Common/Modal.vue";
import {boolean} from "../../../../../../../helpers/extraLogics";
const { basePathVersion } = globalMixin.methods;

/**
 * Computed property to get all available languages.
 */
const getAllLangs = computed(()=> store.getters.getAllLangs);

/**
 * Props for the component.
 * @prop {Object} auth - The authentication object.
 * @prop {Array} addedLanguages - Array of added languages.
 */
const props = defineProps({

	auth : { type : Object, default : ()=>{} },

	addedLanguages : { type : Array, default : ()=>[] }
})

/**
 * Emit event definitions.
 */
const emit = defineEmits(['getflag', 'removeflag']);

// Ref for the list of languages.
const languageList = ref([]);
// Ref for the list of added languages.
const addedLanguageList = ref([]);
// Ref for the loading state.
const isLoading = ref(false);
// Ref for the selected language.
const selectedLang = ref('');
// Ref for the hovering field.
const hoveringField = ref('')

/**
 * Hook that runs before the component is mounted.
 * Fetches language list data.
 */
onBeforeMount(()=>{

	let value = props.auth && props.auth.user_data && props.auth.user_data.user_language ? props.auth.user_data.user_language : 'en';

	selectedLang.value = {
		locale : value,
		name :  getAllLangs.value.find(obj => obj.locale === value).name
	}

	getLanguageList()
})

watch(() => props.addedLanguages, () => {
	getLanguageList();
}, { deep: true });

/**
 * Method triggered on hover over a field.
 * @param {Object} value - The value of the field.
 */
const onHover = (value) => {

	hoveringField.value = value.locale
}

/**
 * Method to fetch the list of languages.
 */
const getLanguageList = () => {

	isLoading.value = true;

	axios.get('api/dependency/languages?meta=true').then((resp) => {

		let updatedList = resp.data.data.languages.sort((a, b) => {

			if (a.name < b.name) { return -1; }

			if (b.name < a.name) { return 1; }

			return 0;
		});

		languageList.value = updatedList.filter(obj => !props.addedLanguages.some(value => obj.locale === value.language));

		addedLanguageList.value = updatedList.filter(obj => props.addedLanguages.some(value => obj.locale === value.language));

	}).catch((err) => {

		languageList.value = [];

	}).finally(()=> {

		isLoading.value = false;
	})
}

/**
 * Method to get the URL of the local flag image.
 * @param {string} x - The language code.
 * @returns {string} - The URL of the flag image.
 */
const getLocalFlag = (x) => {

	return basePathVersion() + '/themes/default/common/images/flags/' + x + '.png'
}

/**
 * Method to change the selected language.
 * @param {Object} newLang - The new language object.
 */
const changeFlag = (newLang) => {

	selectedLang.value = newLang;

	let languageFlag = {};

	languageFlag['language'] = newLang.locale;

	emit('getflag', languageFlag);
}

const showRemoveModal = ref(false);
const removeData = ref('');

const onRemoveLang = (obj) => {
    showRemoveModal.value = true;
    removeData.value = obj;
}

const isRemoveFromDB = (flag) => {

    let selectedFlagData = props.addedLanguages.find(obj => obj.language === flag);

    return selectedFlagData.id.toString().length < 13;
}

const removeLang = () => {

    showRemoveModal.value = false;

    if(isRemoveFromDB(removeData.value)) {

        emit('removeflag', { from: 'db', value: removeData.value });

    } else {

        emit('removeflag', { from: 'local', value: removeData.value });
    }
}
</script>

<template>

	<div class="language-menu">

		<div class="form-group">

			<button class="btn btn-light dropdown-toggle" type="button" id="language-list-dropdown"
					data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true">

				<template v-if="selectedLang">

					<img :src='getLocalFlag(selectedLang.locale)' alt="Img">&nbsp;

					{{ selectedLang.name }}
				</template>

				<template v-else> {{ trans('add_new_language') }}  </template>

				<span class="caret"></span>
			</button>

			<ul class="dropdown-menu dropdown-menu-lg language-dropdown right-auto" aria-labelledby="language-list-dropdown">

				<li v-if="isLoading" class="nav-item mt-2">

					<Loader :size="30" />
				</li>

				<template v-else>

					<span v-if="addedLanguageList.length" class="dropdown-item dropdown-header">{{ trans('select_language') }}</span>

					<li v-for="lang in addedLanguageList" :key="lang.id" class="nav-item bg-light" @mouseenter="onHover(lang)" @mouseleave="hoveringField = ''">

						<a href="javascript:void(0)" @click="changeFlag(lang)" class="nav-link text-dark px-2 pt-1 pb-1">

							<img :src='getLocalFlag(lang.locale)'>&nbsp;{{lang.name}} ({{ lang.translation }})&rlm;

                            <span v-if="hoveringField === lang.locale && hoveringField !== 'en' && hoveringField !== appLanguage" class="float-end text-muted text-sm" v-tooltip="trans('delete')"
                                @click="onRemoveLang(hoveringField)">
                                <i class="fas fa-times text-danger"></i>
                            </span>

                            <span v-if="hoveringField === lang.locale" class="float-end text-muted text-sm me-2" v-tooltip="trans('edit')">
                                <i class="fas fa-pencil-alt"></i>
                            </span>
						</a>
					</li>

					<span v-if="languageList.length" class="dropdown-item dropdown-header">{{ trans('add_new_language') }}</span>

					<li v-for="lang in languageList" :key="lang.id" class="nav-item" @mouseenter="onHover(lang)" @mouseleave="hoveringField = ''">

						<a href="javascript:void(0)" @click="changeFlag(lang)" class="nav-link text-dark px-2 pt-1 pb-1">

							<img :src='getLocalFlag(lang.locale)'>&nbsp;{{lang.name}} ({{ lang.translation }})&rlm;

							<span v-if="hoveringField === lang.locale" class="float-end text-muted text-sm"><i class="fas fa-plus"></i></span>
						</a>
					</li>
				</template>
			</ul>
		</div>

        <transition name="modal">

            <Modal v-if="showRemoveModal" :showModal="true" :onClose="() => showRemoveModal = false" :containerStyle="{width:'400px'}">

                <template #title>

                    <h4 class="modal-title">{{trans('delete')}}</h4>
                </template>

                <template #fields>

                    <span>{{trans('are_you_sure_you_want_to_delete')}}</span>
                </template>

                <template #controls>
                    <button type="button" @click="removeLang()" class="btn btn-danger">
                        <i class="fas fa-trash-alt" aria-hidden="true"></i>&nbsp;{{trans('confirm')}}
                    </button>
                </template>
            </Modal>
        </transition>
	</div>
</template>

<style scoped>
	.language-dropdown {
		min-height: 50px;
		max-height: 250px;
		overflow-y: auto;
	}
	.language-menu {
		margin-bottom: 0.5rem;
		margin-top: 0.5rem;
	}
	.w-61{ width: 61%; }
</style>