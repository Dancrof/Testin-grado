<template>
  <div :class="showDivClass ? 'row' : ''">
    <div :class="showDivClass ? 'dynamic-select-with-filter-container col-md-12' : ''">
      <dynamic-select
        :id="node.key"
        :name="node.key"
        :api-endpoint="apiEndpoint"
        :api-parameters="apiParams"
        :multiple="multiple"
        :value="selectedAssets"
        :required="Boolean(node.required)"
        :label="node.label"
        :onChange="onChange"
        :isInlineForm="isInlineForm"
        :actionBtn="{ text: 'filter', isFor : 'requester', action: openFilterPopup }"
        :tip-rule="node.show_description"
        :hint="node.description"
        :optionLabel="optionLabel">
        <template #dsHelpText>
          <small><span v-tooltip="{ content : formattedFilterString, html : true }" v-html="formattedFilterString"></span></small>
        </template>
      </dynamic-select>
    </div>

    <transition name="modal">
      <modal v-if="showFilterPopup" :showModal="showFilterPopup" :onClose="() => showFilterPopup = false"
			:containerStyle="{ width: '800px' }">
      	<template #title>
          <h4>{{ trans('filter') }}</h4>
        </template>
		  <template #fields>
			  <div class="ds-filter-modal">
				  <loader v-if="isLoading" :animation-duration="4000" :size="60" />
				  <filter-dropdowns v-if="!isLoading" :metaData="filterOptions" @onChangeFilter="onChangeFilter" />
			  </div>
		  </template>
        <template #controls>
          <button class="btn btn-primary" type="button" @click="applyFilter()">{{ trans('apply') }}</button>
        </template>
      </modal>
    </transition>
  </div>
</template>

<script>
import Modal from '../../../components/Common/Modal.vue'
import axios from 'axios'
import { MULTIPLE_PROPERTY_HELPER, getFormattedTextAndApiParamsForSelectedFilter } from '../../../helpers/extraLogics'
import { mapGetters } from 'vuex'
import DynamicSelect from "./DynamicSelect.vue";
import FilterDropdowns from "../../Common/Filter/FilterDropdowns.vue";

export default {

  name: 'dynamic-select-with-filter',

  props: {
    node: { type: Object, required: true },
    filterApiEndpoint: { type: String, required: true },
    multiple: { type: Boolean, default: false },
    onChange: { type: Function, required: true },
    selectedAssets: { type: Array, required: false},
    clearSelectedValue: { type: Function, required: false},
    changeSelectedAsset: { type: Function, required: false},
	  isInlineForm: { type: Boolean, default: true },
	  showDivClass: { type: Boolean, default: true }
  },

  data: () => {
		return {
      showFilterPopup: false,
      isLoading: false,
      filterOptions: [],
      apiParameters: {},
      filterParams: {},
      selectedFilters: {},
      formattedFilterString: ''
		}
  },

  computed: {
    apiEndpoint: function () {
	    
	    let apiUrl = MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.node.api_info).url;
		
	    if(!apiUrl && this.formField.api_info) {
		    
		    apiUrl = this.formField.api_info + '?mode=render';
		    
	    }
		
      return apiUrl;
    },

    optionLabel () {
      return MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.node.api_info).url.split('?').includes("extra_format=1") ? 'format' : 'name';
    },

	  apiParams() {

		return Object.keys(this.filterParams).length ? this.filterParams : this.apiParameters;
	  },

    ...mapGetters(['getReporter'])

  },
	
	watch: {

    getReporter(newValue,oldValue){

      if( newValue ){
        let usedByIds = []
        usedByIds.push( newValue );
        this.apiParameters = {
          "used_by_ids[n]": newValue
        }
        this.$store.dispatch('setSelectedValues', [])
        this.clearSelectedValue();
      } else {
        this.apiParameters ={}
      }
    }
  },

  methods: {

    openFilterPopup() {
      this.showFilterPopup = true

      if (this.filterOptions.length === 0) {
        this.isLoading = true
        axios.get(this.filterApiEndpoint)
          .then((response) => {
            this.filterOptions = response.data.data
          })
          .catch((error) => {
            console.error(error)
          })
          .finally(() => {
            this.isLoading = false
          })
      }
    },

    applyFilter () {
      this.filterOptions.map((element) => element.value = this.selectedFilters[element.key])
      const result = getFormattedTextAndApiParamsForSelectedFilter(this.filterOptions)
      this.formattedFilterString = result.formatedText
	    this.filterParams = result.apiParams;
      this.showFilterPopup = false
      this.changeSelectedAsset()
    },

    onChangeFilter (value) {
      this.selectedFilters = { ...this.selectedFilters, ...value }
    },
  },

  components: {
    'modal': Modal,
    'dynamic-select': DynamicSelect,
    'filter-dropdowns': FilterDropdowns,
  }

};
</script>

<style>
  .dynamic-select-with-filter-container {
    margin-right: -32px;
    margin-bottom: 1rem;
  }
  .dynamic-select-with-filter-container > .form-group {
    padding-right: 0px;
    margin-bottom: 0px;
  }
  .ds-filter-modal {
    padding-left: 1em;
    padding-right: 1em;
  }
  /*.dynamic-select-with-filter-container .faveo-dynamic-select .vs__dropdown-toggle {
    border-top-right-radius: 0px;
    border-bottom-right-radius: 0px;
  }*/
</style>
