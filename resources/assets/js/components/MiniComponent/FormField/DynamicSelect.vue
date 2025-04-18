<template>
   <form-field-template v-if="showField" :labelLength="labelLength" :showTooltipOnLabel="showTooltipOnLabel"
      :name="name"
      :classname="classname"
      :label="label"
      :hint="hint"
      :required="required"
      :labelStyle="labelStyle"
      :showNewButton="showNewButton"
      :onClickEvent="getFieldName"
			:actionBtn="actionBtn"
			:isInlineForm="isInlineForm"
			:showPreview="showPreview"
			:tipRule="tipRule"
      >

			<ValidationProvider :name="name" :rules="rules" v-model="selectedValue">
				<template v-slot="{ field, errorMessage, meta, classes }">
					<div class="dynamic-select">
						<v-select
						:name="name"
						:class="['faveo-dynamic-select', classes, errorMessage ? 'field-danger' : '']"
						ref="faveoDynamicSelect"
						:options="listElements"
						v-model:modelValue="selectedValue"
						:label="optionLabel"
						:multiple="multiple"
						:placeholder="lang('search_or_select')"
						:autoscroll="autoscroll"
						:disabled="disabled"
						:clearable="clearable"
						:searchable="searchable"
						:transition="transition"
						:closeOnSelect="closeOnSelect"
						:taggable="taggable"
						:pushTags="pushTags"
						:filterable="false"
						:noDrop="noDrop"
						:inputId="id"
						:dir="isRtlLayout ? 'rtl' : 'ltr'"
						@update:modelValue="onValueChange"
						@search="onSearch"
						@open="connectObserver"
						@close="disconnectObserver"
						@search:blur="clearSearchQuery"
						@option:deselected="onDeselect"
						:select-on-key-codes="[188, 13]"
						:style="inputStyle"
						>
              <template #spinner="{ loader }" >
                <loader v-if="isLoading" class="loader-area" :duration="4000" :size="20"></loader>
              </template>
						<template #no-options="{search, searching}">
							<span></span>
							<template v-if="searching">{{ lang('no_results_found_for') }} <em>{{ search }}</em>. </template>
							<template v-else>
								<span v-if="!isLoading && !hasNextPage">{{lang('no_options_found')}}</span>
<!--								<loader v-if="isLoading && !hasNextPage" :duration="4000" :size="25"></loader>-->
							</template>
						</template>
						<template #option="option">

							<template v-if="optionLabel === 'format'" :style="inputStyle">

								<div class="d-center" :title="option['identifier'] + ' ' + option['name']">

									<faveo-image-element v-if="option.profile_pic" id="faveo-dynamic-select-img" :source-url="option.profile_pic"
                                                         img-height="20" img-width="20" />

									<i v-if="showIcon || (option.icon_class || option.icon)" :style="{ color: option.icon_color }" :class="option.icon_class || option.icon" aria-hidden="true"></i>&nbsp;

									<span v-if="optionLabel === 'format'" v-html="option[optionLabel]"></span>
								</div>
							</template>

							<template v-else>

								<div class="d-center" :title="isSpecialCase ? (loadLabel(option[optionLabel])) : (option['hover'] ? option['hover'] : option[optionLabel])">

									<faveo-image-element v-if="option.profile_pic" id="faveo-dynamic-select-img" :source-url="option.profile_pic"
                                                         img-height="20" img-width="20" />
                  <!-- Display icon if available -->
									<i v-if="showIcon || (option.icon_class || option.icon)" :style="{ color: option.icon_color }" :class="option.icon_class || option.icon" aria-hidden="true"></i>&nbsp;
                  <!-- Display label with emoji if it is a special case -->
                  <template v-if="isSpecialCase">
                    <span v-html="loadLabel(subString(option[optionLabel]))"></span>
                  </template>
                  <!-- Display truncated label if it is not a special case -->
                  <template v-else>
                    {{ subString(option[optionLabel]) }}
                  </template>
								</div>
							</template>
						</template>

						<template #selected-option="option">

							<template v-if="optionLabel === 'format'">

								<div class="selected d-center" :title="option['identifier'] + ' ' + option['name']">
									<!-- For images -->
									<faveo-image-element v-if="option.profile_pic" id="faveo-dynamic-select-img" :source-url="option.profile_pic"
                                                         img-height="20" img-width="20"/>
									<!-- For Icons -->
									<i v-if="showIcon || (option.icon_class || option.icon)" :style="{ color: option.icon_color }" :class="option.icon_class || option.icon" aria-hidden="true"></i>&nbsp;
									<span v-html="option[optionLabel] ? option[optionLabel] : option['name']"></span>
								</div>
							</template>

							<template v-else>
                <!-- Container for the selected option -->
								<div class="selected d-center" :title="isSpecialCase ? (loadLabel(option[optionLabel]))  : option['hover'] ? option['hover'] : option[optionLabel]">
									<!-- For images -->
									<faveo-image-element v-if="option.profile_pic" id="faveo-dynamic-select-img" :source-url="option.profile_pic"
                                                         img-height="20" img-width="20"/>
									<!-- For Icons -->
									<i v-if="showIcon || (option.icon_class || option.icon)" :style="{ color: option.icon_color }" :class="option.icon_class || option.icon" aria-hidden="true"></i>&nbsp;

                  <!-- Display label with emoji if it is a special case -->
									<span v-if="isSpecialCase" v-html="loadLabel(subString(option[optionLabel]))"></span>

                  <!-- Display truncated label if it is not a special case -->
									<span v-else>{{ option[optionLabel] ? subString(option[optionLabel]) : option['meta_name'] }}</span>
								</div>
							</template>
						</template>

						<template #list-footer v-if="hasNextPage">
								<li ref="dynamicSelectLoader" >
<!--									<loader :duration="4000" :size="25"></loader>-->
								</li>
						</template>
						</v-select>
					</div>
                    <span v-show="errorMessage" class="error-block is-danger">{{errorMessage}}</span>
				</template>
			</ValidationProvider>
			<slot name="dsHelpText"></slot>
   </form-field-template>
</template>

<script>
import vSelect from "vue-select";

import axios from "axios";

import FormFieldTemplate from "./FormFieldTemplate.vue";

import { errorHandler } from "../../../helpers/responseHandler";
import {getSubStringValue, boolean, renderLabelWithEmoji} from "../../../helpers/extraLogics";
import { convertMapToSubmitableData } from '../../../helpers/formUtils';

import _ from 'lodash-core';

export default {
	name: "dynamic-select",

	props: {
		/**
		 * the name of the state in parent class
		 * @type {String}
		 */
		name: {
			type: [String, Number],
			Required: true
		},

		/**
		 * Hint regarding what the field is about (it will be shown as tooltip message)
		 * @type {String}
		 */
		hint: {
			type: String,
			default: ""
		},

		/**
		 * Whether the given field is required or not.
		 * If passed yes, an asterik will be displayed after the label
		 * @type {Boolean}
		 */
		required: {
			type: [Boolean, Number],
			default: false
		},

		/**
		 * classname of the form field. It can be used to give this component any bootstrap class or a custom class
		 * whose css will be defined in parent class
		 * @type {String}
		 */
		classname: {
			type: String,
			default: ""
		},

		/**
		 * Id of the field
		 * @type {String|Number}
		 */
		id: {
			type: [String, Number],
			default: "dynamic-select"
		},

		/**
		 * For showing Field label.
		 * If passed display as none, the label will not be displayed
		 * @type {Object}
		 */
		labelStyle: {
			type: Object,
			default: function () {
				return {};
			}
		},

		/**
		 * The function which will be called as soon as value of the field changes
		 * It should have two arguments `value` and `name`
		 *     `value` will be the updated value of the field
		 *     `name` will be thw name of the state in the parent class
		 *
		 * An example function:
		 *   onChange(value, name){
		 *     this[name]= selectedValue
		 *   }
		 *
		 * @type {Function}
		 */
		onChange: {
			type: Function,
			required: true
		},

		/**
		 * When true, the dropdown will automatically scroll to ensure that the option highlighted is fully within the dropdown viewport when navigating with keyboard arrows.
		 */
		autoscroll: {
			type: Boolean,
			default: true
		},

		/**
		 * Contains the currently selected value.
		 * Very similar to a value attribute on an <input>.
		 * You can listen for changes using 'change' event using v-on.
		 */
		value: {
			type: [Object, String],
			default: null
		},

		/**
		 * An array of strings or objects to be used as dropdown choices.
		 * If you are using an array of objects, vue-select will look for a label key (ex. [{label: 'Canada', value: 'CA'}]).
		 * A custom label key can be set with the label prop.
		 */
		elements: {
			type: Array,
			default () {
				return [];
			}
		},

		/**
		 * Disable the dropdown.
		 */
		disabled: {
			type: Boolean,
			default: false
		},

		/**
		 * Can the user clear the selected property?
		 */
		clearable: {
			type: Boolean,
			default: true
		},

		/**
		 * Enable/disable filtering the options.
		 */
		searchable: {
			type: Boolean,
			default: true
		},

		/**
		 * Equivalent to the multiple attribute on a <select> input.
		 */
		multiple: {
			type: Boolean,
			default: false
		},


		/**
		 * Api endpoint which will return the list of elements which are needed to be displayed
		 * if api endPoint is null, we use elements to display
		 * @type {String}
		 */
		apiEndpoint: {
			type: String,
			default: null
		},

		/**
		 * API parameters needs to get added in the api calls
		 */
		apiParameters: {
			type: [Object, Map],
			default: () => {}
		},

		/**
		 * Equivalent to the placeholder attribute on an <input>.
		 */
		placeholder: {
			type: String,
			default: "Search or Select"
		},

		/**
		 * Sets a Vue transition property on the .dropdown-menu.
		 */
		transition: {
			type: String,
			default: "fade"
		},

		/**
		 * Enables/disables clearing the search text when an option is selected.
		 */
		clearSearchOnSelect: {
			type: Boolean,
			default: true
		},

		/**
		 * Close a dropdown when an option is chosen.
		 * Set to false to keep the dropdown open (useful when combined with multi-select, for example)
		 */
		closeOnSelect: {
			type: Boolean,
			default: true
		},

		/**
		 * Tells vue-select what key to use when generating option labels when each option is an object.
		 */
		optionLabel: {
			type: String,
			default: "name"
		},

		/**
		 * Form field label text
		 */
		label: {
			type: String,
			default: ''
		},

		/**
		 * Enable/disable creating options from searchInput.
		 */
		taggable: {
			type: Boolean,
			default: false
		},

		/**
		 * When true, newly created tags will be added to the options list.
		 */
		pushTags: {
			type: Boolean,
			default: false
		},

		/**
		 * Used to truncate a string
		 */
		strlength: {
			type: [Number, String],
			default: 40
		},

		/**
		 * Disable the dropdown entirely.
		 */
		noDrop: {
			type: Boolean,
			default: false
		},

		/**
		 * Sets the id of the input element.
		 */
		inputId: {
			type: String
		},

		/**
     * The new button is need to show or not.
     * @type {Boolean}
     */
    showNewButton: { type: Boolean, default: false },

    /**
     * for getting field name
     */
    onClickEvent : { type : Function },
    
    /**
     * This method will return field name to parent component.
     */
		onButtonClick: { type : Function},

		isInlineForm: { type: Boolean, default: false },

		rules: { type: String, default: '' },

		actionBtn: { type: Object, default: () => null },

		showPreview : { type : [String, Object], default : '' },

		//FOR TOOLTIP POSITION
		tipRule : { type : [Number, Boolean], default : false },

		removeVal : { type : Boolean, default : true },

    // KEY FOR MATCHING A DATA IN RESPONSE
    data_key : { type : String, default : 'data' },

		formIsFor : { type : String, default : '' },

		fieldUniqueName : { type : String, default : ''},

		inputStyle : { type : Object, default : ()=>{}},
		
		showIcon : { type : Boolean, default : true },
		
		labelLength : { type : [Number, String], default : 500 },
		
		showTooltipOnLabel: { type: Boolean, default: true },

    // \@prop {String} callingFrom - This prop was added to handle emoji icons in the tags (TicketTags.vue) component.
		callingFrom: { type: String, default: '' }
	},

	data: () => {
		return {
			listElements: [],
			page: 0,
			observer: null,
			nextPageUrl: '',
			searchQuery: undefined,
			isLoading: false,
			selectedValue: null,
			allParams : '',
      showField:false
		};
	},

	beforeMount() {
		this.listElements = Boolean(this.elements) ? this.elements : [];
	},

	mounted() {
		if (this.apiEndpoint) {
			this.flushAndRestart();
		}
        this.selectedValue = this.value;

        // Intentionally added 1 sec timeout for avoiding initial errors on page load
        setTimeout(()=>{
            this.showField = true
        },1);
	},

	created() {
		 window.emitter.on('updateDynamicSelect',this.updateProperties)
		},

	computed: {
		hasNextPage() {
			return Boolean( this.nextPageUrl !== null && this.apiEndpoint);
		},

    /**
     * Computed property to check if the current context is a special case.
     * This property returns true if the `callingFrom` is 'ticket-tags' or
     * if the `name` is 'label_ids' or 'orglabel_ids'.
     *
     * @returns {boolean} - True if the context is a special case, otherwise false.
     */

    isSpecialCase() {
      return this.callingFrom === 'ticket-tags' || this.name === 'label_ids' || this.name === 'orglabel_ids' || this.name.includes('label_ids');
    },
	},

	methods: {

		onDeselect() {

			const searchEl = this.$refs.faveoDynamicSelect.searchEl;

			if (searchEl) { searchEl.blur(); }
		},

		// mailHandlers: (map, vm) => ({
		// 	...map,
		// 	50: (e) => {
		// 		e.preventDefault()
		// 		if (e.key === '@' && vm.search.length > 0) {
		// 			vm.search = `${vm.search}@gmail.com`
		// 		}
		// 	},
		// }),

		updateProperties() {

			this.flushAndRestart('update');
		},

		getFieldName(name){
			
			this.onButtonClick(name)
		},

		subString(value) {
			return getSubStringValue(value, parseInt(this.strlength))
		},


		flushAndRestart(from = '') {
			this.disconnectObserver();
			this.resetProperties(from);
			this.observer = new IntersectionObserver(this.infiniteScroll);
		},

		/**
		 * gets value from the API based on the search string
		 * @param  {String} searchQuery  text that is typed in the field (for searching purpose)
		 * @return {void}
		 */
		onSearch(searchQuery) {
			this.searchQuery = searchQuery;
			this.page = 1;
			this.search();
		},

		/**
		 * Listens the change event from v-select if any
		 */
		onValueChange(value) {
			this.onChange(value, this.name);
		},

		search: _.debounce(function () {
			if (this.apiEndpoint) {
				this.getListFromServer(true);
			} else {
				// Search elements locally
				this.filterListElements();
			}
		}, 350),

		/** Filter list elements */
		filterListElements() {
			this.listElements = this.elements.filter((element) => element[this.optionLabel].toLowerCase().includes(this.searchQuery.toLowerCase()));
		},

		getListFromServer(isRefresh, target) {

			if (!boolean(this.apiEndpoint)) return;

			this.isLoading = true;
			axios.get(this.apiEndpoint, {
					params: this.getApiParams()
				})
				.then(response => {
					this.postApiResponseOperations(response.data.data, isRefresh, target);
					this.$nextTick(() => {
						this.connectObserver(); // Reconnect observer after updating list
					});
				})
				.catch(error => {
          // if request fails, there won't be any next page, so nextPageUrl will be marked as null
				  this.nextPageUrl = null
					errorHandler(error);
				})
				.finally(() => {
					this.isLoading = false;
				})
		},

		/*
		 * Ensure that the scroll position remains where it was before the list size changed.
		 * It's important to wait for $nextTick here so that the DOM elements have been inserted before setting the scroll position.
		 */
		async postApiResponseOperations(responseData, isRefresh, target) {
			try {

				if(this.formIsFor === 'requester' && this.fieldUniqueName == 'organisation_department'){

					if(!this.allParams.hasOwnProperty('organisation[0]')) {

						this.isLoading = false;

						this.listElements = [];

						this.nextPageUrl = null;

						return;
					}
				}

				this.nextPageUrl = responseData.next_page_url;

				if (isRefresh) {
          this.listElements = responseData[this.data_key];
				} else {
					if(target) {
						var ul = target.offsetParent;
						if(ul){ var scrollTop = target.offsetParent.scrollTop;	}
					}
          this.listElements.push(...responseData[this.data_key]);
					await this.$nextTick();
					if(target && ul) { ul.scrollTop = scrollTop;	}
				}
			} catch (error) {
				console.error(error);
			}
		},

		getApiParams() {
			let apiParams = boolean(this.apiParameters) ? this.apiParameters : {};

			if (apiParams instanceof Map) {

				apiParams = convertMapToSubmitableData(apiParams);

				if(apiParams.description) {

					delete apiParams.description;

				}
			}

			this.allParams = apiParams;
			let params = JSON.parse(JSON.stringify(apiParams));
			params['search-query'] = this.searchQuery;
			params['page'] = this.page || undefined;
			params['paginate'] = 1;
			return params;
		},

		/**
		 * Clear search query on search:blur event
		 * https://github.com/sagalbot/vue-select/issues/287
		 */
		clearSearchQuery() {
			this.$refs.faveoDynamicSelect.onEscape();
		},

		/**
		 * The observer is set to call infiniteScroll when the <li> is completely visible within the list.
		 * Some fancy destructuring is done here to get the first ObservedEntry, and specifically the isIntersecting & target properties.
		 * If the <li> is intersecting, we increase the limit
		 */
		infiniteScroll([{ isIntersecting, target }]) {
			if (isIntersecting) {
				this.page += 1;
				this.getListFromServer(false, target);
			}
		},

		/**
		 * When Vue Select opens, the open event is emitted and connectObserver will be called.
		 * We wait for $nextTick() so that the $ref we need will exist, then begin observing it for intersection.
		 */
		async connectObserver() {
			if (this.hasNextPage) {
				await this.$nextTick();
				this.observer.observe(this.$refs.dynamicSelectLoader);
			}
		},

		disconnectObserver() {
			if (this.observer) {
				this.observer.disconnect();
        this.isLoading = false;
			}
		},

		/**
		 * Reset properties
		 * Need to reset properties if `apiEndpoint` OR `apiParameters` changes
		 */
		resetProperties(from = '') {
			this.listElements = this.elements.length ? this.listElements : [];
			this.page = 0;
			this.observer = null;
			this.nextPageUrl = '';
			this.searchQuery = undefined;
			this.isLoading = false;
			if(from != 'update' && this.removeVal) { this.selectedValue = null; }
		},

    loadLabel(label) {
      return renderLabelWithEmoji(label);
    }

	},

	watch: {

		elements(newValue, oldValue) {
			if (newValue) {
				this.listElements = newValue;
			}
		},

		apiEndpoint(newValue, oldValue) {
			if (boolean(newValue)) {
				this.flushAndRestart();
			}
		},

		apiParameters(newValue, oldValue) {
			if (boolean(newValue)) {
				this.flushAndRestart();
			}
		},


		// TODO This `value` watcher needs refactoring
		value(newValues, oldValues) {
			this.selectedValue = newValues;

			// if taggable is there, handle value seperatey
			// loop over all values and see if a value is string
			// if it is a string make an object out of it with name as value and id as value
			if (this.taggable) {
				if (newValues === null) return;
				let modifiedValues = newValues.map(value => {
					let valueObj;
					if (typeof value === 'string') {
						valueObj = {}
						valueObj.id = value;
						valueObj[this.optionLabel] = value;
					}
					return valueObj || value;
				});
				// call onChange only if value if 2 objects are different to avoid infinite loop
				if (JSON.stringify(modifiedValues) !== JSON.stringify(newValues)) {
					this.onChange(modifiedValues, this.name)
				}
			}
		}
	},

	components: {
		'v-select': vSelect,
		'form-field-template': FormFieldTemplate
	}
};
</script>

<style scoped>
#faveo-dynamic-select-img {
	border: 1px solid transparent;
	width: 18px;
	border-radius: 10px;
	margin-top: -1px;
}

.vs__actions .loader-area {
  order: -1; /* Place the loader before other actions */
  margin-right: 5px; /* Adjust the margin as needed */
}

</style>