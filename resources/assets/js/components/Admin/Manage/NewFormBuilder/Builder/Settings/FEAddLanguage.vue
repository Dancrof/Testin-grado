<script setup>

import {computed, onBeforeMount, ref} from "vue";
import _ from 'lodash-core';

import LanguageDropdown from "./Mini/LanguageDropdown.vue";
import ToolTip from "../../../../../MiniComponent/ToolTip.vue";
import {errorHandler, successHandler} from "../../../../../../helpers/responseHandler";
import Alert from "../../../../../MiniComponent/Alert.vue";

/**
 * Props for the component.
 * @prop {Object} formFieldData - The form field data object.
 * @prop {Object} auth - The authentication object.
 * @prop {Function} selectedLanguage - The function to handle language selection.
 */
const props = defineProps({

	formFieldData: { type: Object, required: true },

	auth : { type : Object, default : ()=>{} },

	selectedLanguage : { type : Function, default : ()=>{} }
})

// Selected language based on user authentication data.
let selectedLang = props.auth && props.auth.user_data && props.auth.user_data.user_language ? props.auth.user_data.user_language : 'en';

// Array to store added languages.
const addedLanguages = ref([])

const deptHelptopic = ['Department', 'Help Topic'];

/**
 * Computed property to determine if language change is allowed for options.
 */
const canChangeLanguageForOptions = computed(() => {
	return !deptHelptopic.includes(props.formFieldData.title);
});

onBeforeMount(()=>{

	addedLanguages.value = props.formFieldData.labels.map(obj=> ({ id: obj.id, language: obj.language}));
	//
	// if(!addedLanguages.value.includes(selectedLang)) {

		assignNewLanguage({ language : selectedLang })

	if(selectedLang !== 'en') {
		assignNewLanguage({ language : 'en' })
	}
	// }
})

/**
 * Method to determine if placeholder should be shown.
 */
const showPlaceholder = () => {

	const simpleFields = ['text', 'number', 'decimal', 'mobile', 'date', 'email', 'textarea'];

	return simpleFields.indexOf(props.formFieldData.data_type) > -1;
}

const loading = ref(false);

const removeLanguage = (removeLang) => {

    if(removeLang.from === 'db') {

        const data = {};

        data['language'] = removeLang.value;

        axios.delete('/remove/form-field/language/'+props.formFieldData.id, { data }).then(res=>{

	        successHandler(res,'add-lang');

			setTimeout(()=>{

				window.emitter.emit('formLangRemovedInDb');
			},2500);

        }).catch(err=>{

            window.emitter.emit('formLangRemoved');

            setTimeout(()=>{
	            errorHandler(err,'form-builder-main');
                errorHandler(err,'ticket-section');
                errorHandler(err,'ticket-fields-form');
            }, 1);
        });
    } else {

        window.emitter.emit('refreshFieldSettings', true);

        if(props.formFieldData.options && canChangeLanguageForOptions.value && props.formFieldData.data_type !== 'section') {

            props.formFieldData.options.forEach(element => {

                const index = element.labels.findIndex(obj => obj.language === removeLang.value);

                if (index !== -1) {
                    element.labels.splice(index, 1);
                }
            });
        }

        const index = props.formFieldData.labels.findIndex(obj => obj.language === removeLang.value);

        if (index !== -1) {
            props.formFieldData.labels.splice(index, 1);
        }

        addedLanguages.value = props.formFieldData.labels.map(obj=>({ id: obj.id, language: obj.language}));

        setTimeout(()=>{
            window.emitter.emit('refreshFieldSettings', false);
        },1000)
    }
}
/**
 * Method to assign a new language to the form field data.
 * @param {Object} newLang - The new language object.
 */
const assignNewLanguage = (newLang) => {

	loading.value = true;

	selectedLang = newLang.language

	props.selectedLanguage(newLang.language);

	const currentTimestamp = getCurrentTimestamp();

	newLang.form_identifier = currentTimestamp;

	newLang.id = currentTimestamp;
	
	if(props.formFieldData.options && canChangeLanguageForOptions.value && props.formFieldData.data_type !== 'section') {

		props.formFieldData.options.forEach(element => {

			newLang.label = element.labels[0].label;

			if(!isLangPresentAlready(element.labels, newLang.language)) {

				element.labels.push(new Object(Object.assign({}, newLang)));
			}
		});
	}

	if(!isLangPresentAlready(props.formFieldData.labels, newLang.language)) {

		newLang.label = props.formFieldData.labels[0].label;

		newLang.description = props.formFieldData.labels[0].description;

		props.formFieldData.labels.push(new Object(Object.assign({}, newLang)));

		addedLanguages.value = props.formFieldData.labels.map(obj=>({ id: obj.id, language: obj.language}));
	}
	
	if(props.formFieldData.data_type === 'mobile' && props.formFieldData.union && props.formFieldData.union.length && !isLangPresentAlready(props.formFieldData.union[0].labels, newLang.language)) {
		
		newLang.label = props.formFieldData.union[0].labels[0].label;
		
		newLang.description = props.formFieldData.union[0].labels[0].description;
		
		props.formFieldData.union[0].labels.push(new Object(Object.assign({}, newLang)));
		
		addedLanguages.value = props.formFieldData.labels.map(obj=>({ id: obj.id, language: obj.language}));
	}

	loading.value = false;
}

/**
 * Method to check if language is already present in the array.
 * @param {Array} array - The array to check.
 * @param {string} lang - The language to check for.
 * @returns {boolean} - Whether the language is present or not.
 */
const isLangPresentAlready = (array, lang) => {

	return _.findIndex(array, (element) => element.language === lang) > -1;
}

/**
 * Method to get the current timestamp.
 * @returns {number} - The current timestamp.
 */
const getCurrentTimestamp = () => {

	return new Date().getTime();
}
</script>

<template>

	<div class="fe-add-lang">

		<Alert componentName="add-lang"></Alert>

		<div class="language-menu-dropdown">

			<LanguageDropdown v-on:getflag="assignNewLanguage" v-on:removeflag="removeLanguage" :auth="auth" :addedLanguages="addedLanguages"></LanguageDropdown>

		</div>

		<div v-if="!loading" class="add-language-box">
			
			<template v-for="(label, labelIndex) in formFieldData.labels">

				<template v-if="label.language === selectedLang">

					<div v-if="formFieldData.default" class="form-group mb-3">

						<label>{{ trans('default_label') }} <ToolTip :message="lang('default_label_hint')" size="small"></ToolTip></label>

						<input type="text" class="form-control" disabled :value="formFieldData.title">

					</div>

					<div class="form-group mb-3">

						<label>{{ trans('label') }}</label>

						<input type="text" class="form-control" placeholder="Label" :name="label.label + '_' + labelIndex" v-model="label.label">

					</div>

					<div class="form-group mb-3" v-if="showPlaceholder()">

						<label>{{ trans('placeholder') }}</label>

						<input type="text" class="form-control" placeholder="Placeholder" :name="label.place_holder + '_' + labelIndex" v-model="label.place_holder">

					</div>

					<div class="fe-lang-tooltip" v-if="formFieldData.data_type !== 'section'">

						<label>{{ trans('tooltip') }}</label>

						<textarea class="form-control col-md-12 textarea" placeholder="Description (Tooltip)"
								  :name="label.description + '_' + labelIndex" v-model="label.description">

						</textarea>

						<div v-if="formFieldData.title !== 'Captcha'" class="form-check mt-3 ms-1">

							<input class="form-check-input cursor-pointer" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.show_description" id="form-tooltip-lang">

							<label class="form-check-label" for="form-tooltip-lang">{{lang('show_description_under_form_field')}}</label>
						</div>
					</div>
				</template>
			</template>
<!--			COMMENTING THIS - AS WE DONT HAVE ANY USE CASE CURRENTLY-->
<!--			<template v-if="formFieldData.data_type === 'mobile' && formFieldData.union && formFieldData.union.length">-->
<!--				-->
<!--				<template v-for="(label, labelIndex) in formFieldData.union[0].labels">-->
<!--					-->
<!--					<template v-if="label.language === selectedLang">-->
<!--						-->
<!--						<div class="form-group mb-3 mt-3">-->
<!--							-->
<!--							<label>{{ trans('ext') }}</label>-->
<!--							-->
<!--							<input type="text" class="form-control" placeholder="EXT" :name="label.label + '_ext_' + labelIndex" v-model="label.label">-->
<!--						-->
<!--						</div>-->
<!--					</template>-->
<!--				</template>-->
<!--			</template>-->
		</div>
	</div>
</template>

<style scoped>

	.form-field-label { overflow: hidden; }

	.form-field-label > input { width: 85%; border: 1px dashed #fff; }

	.textarea{ margin-bottom: 10px; }

	ul { list-style-type: none; }

	.label-word-break { word-break: break-word; }

	.li-child { padding-left: 1.5rem; }

	.add-language-box { overflow: auto; border-radius : 0.25rem; }

	.add-language-li { margin: 1.5rem; width: 185px; }

	.w-61{ width: 61%; }
</style>