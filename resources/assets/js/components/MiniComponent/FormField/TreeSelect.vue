<template>
	
	<form-field-template :label="label" :name="name" 
		:classname="classname" 
		:hint="hint" 
		:required="required" 
		:labelStyle="labelStyle">

		<treeselect
			v-model="selectedValue"
			:value="selectedValue"
			:name="name"
			@update:modelValue="onChange(selectedValue, name)"
			:options="listElements"
			:show-count="true"
			:multiple="multiple"
			@search-change="onSearch"
			:normalizer="normalizer"
			:value-format="valueFormat"
			@open="connectObserver"
			@close="disconnectObserver"
			:always-open="false"
			:max-height="200"
			noOptionsText=""
			noResultsText=""
			:placeholder="placeHolder"
			:search-nested="true"
			:flat="true">

			<template #option-label="{node}">

				<span v-tooltip="node.label">{{ subString(node.label) }}</span>
			</template>

         	<template #after-list="node">

	         	<template v-if="!isLoading && !listElements.length && !searching">

	         		<div class="vue-treeselect__tip vue-treeselect__no-options-tip">

	         			<div class="vue-treeselect__icon-container">

	         				<span class="vue-treeselect__icon-warning"></span>
	         			</div>

	         			<span class="vue-treeselect__tip-text vue-treeselect__no-options-tip-text">
	         			  {{lang('no_options_available')}}
	         			</span>
	         		</div>
	         	</template>

				<div v-if="hasNextPage || searching" ref="treeSelectLoader" class="loader-area">
					<loader :duration="4000" :size="25"></loader>
				</div>
			</template>
		</treeselect>
	</form-field-template>

</template>

<script>

	import Treeselect from 'vue3-treeselect'

	import axios from "axios";

	import FormFieldTemplate from "./FormFieldTemplate.vue";

	import _ from 'lodash-core';

	import { getSubStringValue, boolean } from "../../../helpers/extraLogics";

	import { convertMapToSubmitableData } from '../../../helpers/formUtils';

	import { errorHandler } from '../../../helpers/responseHandler'

	export default {
	
		components: {

			Treeselect,

			'form-field-template': FormFieldTemplate,

		},

		props : {


			label: { type: String, required: true },

			name: { type: [String, Number], required: true }, //the name of the state in parent class

			value: { type: [String, Number, Array], default: () => (this.multiple ? [] : '') },

			classname: { type: String, default: "" }, //class name (optional)

			onChange: { type: Function, Required: true },

			hint: { type: String, default: "" },

			required: { type: Boolean, default: false },

			id : {type: [String,Number], default:'static-select'},

			labelStyle:{type:Object, default: function () { return { }}},

			strlength : {type : [String,Number], default : 3},

			disabled: {type: Boolean, required: false, default: false},

			multiple: { type: Boolean,default: false },

			apiEndpoint: { type: String, default: null },

			apiParameters: { type: [Object, Map], default: () => {}},

			placeholder: { type: String, default: "Search or Select" },

			valueFormat : { type : String, default : 'object' },

			placeHolder : { type : String, default : 'Search or Select'},

      elements: { type: Array, default () {return []; } // An array of strings or objects to be used as dropdown choices.
      },
		},
	
		data() {
	
			return {
		  
				selectedValue: this.value,
		  
				treeselectOptions: [],

				isFetchingOptions : false,

				observer: null,

				nextPageUrl: '',

				searchQuery: undefined,

				isLoading : false,

				listElements: [],
				
				page: 0,

				searching : false
			}
		},

		computed: {
			
			hasNextPage() {
				
				return Boolean( this.nextPageUrl !== null && this.apiEndpoint);
			}
		},

		watch: {
			
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

			value(newvalue) {
			
				this.selectedValue = newvalue ? newvalue : null;
			},

      multiple(newVal) {
        if (newVal && !Array.isArray(this.value)) {
          this.$emit('input', []);
        } else if (!newVal && Array.isArray(this.value)) {
          this.$emit('input', '');
        }
      }
		},

    beforeMount() {
      // directly assigning the options value
      this.listElements = Boolean(this.elements) ? this.elements : [];
    },

		mounted() {

			if (this.apiEndpoint) {
				
				this.flushAndRestart();
			}

			//initialising input state with prop data
			this.selectedValue = this.value ? this.value : null;
		},

		methods : {

			subString(value) {
		
				return getSubStringValue(value, parseInt(this.strlength))
			},

			async connectObserver() {
				
				if (this.hasNextPage) {
					
					await this.$nextTick();

					this.observer.observe(this.$refs.treeSelectLoader);
				}
			},

			disconnectObserver() {
				
				if (this.observer) {
					
					this.observer.disconnect();
				}
			},

			flushAndRestart(from = '') {
				
				this.disconnectObserver();
				
				this.resetProperties(from);
				
				this.observer = new IntersectionObserver(this.infiniteScroll);
			},

			onSearch(searchQuery) {
				
				this.searchQuery = searchQuery;
				
				this.page = 1;
				
				this.searching = true;

				this.search();
			},

			search: _.debounce(function () {
				
				if (this.apiEndpoint) {
				
					this.getListFromServer(true);
				
				} else {
				
					// Search elements locally
					//this.filterListElements();

					this.searching = false;

				}
			
			}, 350),

			getListFromServer(isRefresh, target) {

				if (!boolean(this.apiEndpoint)) return;

				this.isLoading = true;
	
				axios.get(this.apiEndpoint, {
					params: this.getApiParams()
				})
	
				.then(response => {
					
					this.postApiResponseOperations(response.data.data, isRefresh, target);
				})
				.catch(error => {
          // if request fails, there won't be any next page, so nextPageUrl will be marked as null
				  this.nextPageUrl = null
					errorHandler(error);
				})
				.finally(() => {
					this.isLoading = false;
					this.searching = false;
				})
			},

			async postApiResponseOperations(responseData, isRefresh, target) {
				try {
					
					this.nextPageUrl = responseData.next_page_url;
					
					if (isRefresh) {
						
						this.listElements = responseData.data;
					
					} else {
						
						if(target) {
					
							var ul = target.offsetParent;
						
							if(ul){ var scrollTop = target.offsetParent.scrollTop;	}
						}
						
						this.listElements.push(...responseData.data);
						
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
				}

				let params = JSON.parse(JSON.stringify(apiParams));
				
				params['search-query'] = this.searchQuery;
				
				params['page'] = this.page || undefined;
				
				params['paginate'] = 1;
				
				return params;
			},

			infiniteScroll([{ isIntersecting, target }]) {
				
				if (isIntersecting) {
					
					this.page += 1;
					
					this.getListFromServer(false, target);
				}
			},
			
			resetProperties(from = '') {
				
				this.listElements = [];
				
				this.page = 0;
				
				this.observer = null;
				
				this.nextPageUrl = '';
				
				this.searchQuery = undefined;

				this.isLoading = false;
				
				if(from != 'update') { this.selectedValue = null; }
			},

			normalizer(node) {

		      return {
		        id: node.id,
		        label: node.name,
		        children: node.children && node.children.length ? node.children : 0,
		     	}
		   },
		}
	}
</script>

<style scoped>
	
	.loader-area { padding-top: 3px;height: 37px; }
</style>

<style>
	
	.vue-treeselect__icon-container { display: none !important; }

	.vue-treeselect__control { border: 1px solid rgba(60, 60, 60, 0.26) !important; }
</style>