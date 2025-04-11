<template>
  <div class="automator-form">

	  <template v-if="showForm">

		  <date-time-field v-if="formField.data_type === 'date'" :type="formField.request_time_information ? 'datetime' : 'date'" :label="formField.label" :labelStyle="labelStyle" :value="selectedValue" :name="unique" :onChange="onChange" :format="formField.request_time_information ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD'" :clearable="true" :rules="validationRules" outputFormat="YYYY-MM-DD HH:mm:ss">

		  </date-time-field>

		  <!-- Dynamic Select with options form api -->
		  <dynamic-select v-if="(formField.data_type === 'api' || formField.data_type === 'multiselect')" :strlength="37" :id="formField.key" :label="formField.label" :multiple="formField.data_type === 'multiselect'" :name="unique" :apiEndpoint="apiInfoUrl" :value="selectedValue" :onChange="onChange" :labelStyle="labelStyle" :rules="validationRules" :clearable="clearable" :show-icon="false"></dynamic-select>

		  <!-- Dynamic select with static options -->
		  <dynamic-select v-if="formField.data_type === 'select' && formField.title !== 'Api'" :id="formField.key" :label="formField.label" :multiple="false" :name="unique" :apiEndpoint="apiInfoUrl" :value="selectedValue" :onChange="onChange" :optionLabel="optionLabel" :labelStyle="labelStyle" :rules="validationRules" :clearable="clearable" :show-icon="false"></dynamic-select>
		  
		  <dynamic-select v-if="formField.data_type === 'select' && formField.title === 'Api'" :id="formField.key" :label="formField.label"
             :multiple="false"
             :name="unique" :elements="dropdownOptions" :value="selectedValue" :onChange="onChange"
             :optionLabel="optionLabel"
             :rules="validationRules"
             :hint="formField.description" :strlength="75"
             :tip-rule="formField.show_description" :show-icon="false"
             :fieldUniqueName="formField.key" :labelLength="25" :labelStyle="labelStyle">
		  </dynamic-select>

		  <text-field v-if="formField.data_type === 'text' || formField.data_type === 'textarea' || formField.data_type === 'htmltextarea' || formField.data_type === 'number' || formField.data_type === 'decimal' || formField.data_type === 'email' || formField.data_type === 'time' || formField.data_type === 'count'" :id="formField.key" :label="formField.label"
              :type="formField.data_type === 'htmltextarea' ? 'textarea' : formField.title === 'EXT' ? 'text' : (formField.data_type === 'time' || formField.data_type === 'count') ? 'text' : formField.data_type" :name="unique" :value="selectedValue" :onChange="onChange" :labelStyle="labelStyle" :rules="validationRules" :pattern="formField.pattern" :validation-message="formField.validation_message"
		              :keypressEvt="keypressEvent" :placehold="lang(multipleField ? 'time_multiple_field' : !multipleField && formField.data_type === 'time' ? 'enter_the_time' : formField.data_type === 'count' ? 'enter_thread_count' :'enter_a_value')" :pasteEvt="pasteEvent" :max="formField.title === 'EXT' ? 8 : undefined" :isEXT="formField.title === 'EXT'"
      :defaultKey="formField.key">
			  
		  </text-field>

		  <radio-field v-if="formField.data_type === 'radio'" :name="unique" :label="formField.label" :options="formField.options" :value="selectedValue" :onChange="onChange" :labelStyle="labelStyle" :rules="validationRules"></radio-field>

		  <checkbox-field v-if="formField.data_type === 'checkbox'" :name="unique" :label="formField.label" :options="formField.options" :value="selectedValue" :onChange="onChange"  :labelStyle="labelStyle" :rules="validationRules"></checkbox-field>
	  </template>
	  
	  <MobileField v-if="showMobileField && formField.data_type === 'mobile'" fieldFor="automator"
	               :id="unique" :label="formField.label" :type="formField.data_type" :name="unique"
	               :value="selectedValue" :onChange="onChange" :isInlineForm="false"
	               :countryCode="country_code" @countryCode="onCountryCodeUpdate($event, 'country_code')"
	               :keypressEvt="keypressEvent" :pasteEvt="pasteEvent" :rules="validationRules"
	               :extensionEnabled="formField.enable_extension" :ext="formField.enable_extension ? formField.union : []"
	               :labelStyle="labelStyle" :extValue="extValue">
	  </MobileField>
	  
    <div  class="form-field-wrapper">
      <automator-form-field v-for="node in childNodes" :key="getEnforcerObject(node.key)._id" :form-field="node" :enforcerType="enforcerType" :enforcer-object="getEnforcerObject(node.key)" :isChild="true"></automator-form-field>
    </div>

  </div>
  
</template>

<script>
import axios from 'axios';
import _ from 'lodash-core';
import { MULTIPLE_PROPERTY_HELPER, boolean } from '../../../helpers/extraLogics';
import {getFormFieldValue} from "../../../helpers/formUtils";
import { getNewEnforcerInstance } from '../../../helpers/AutomatorUtils'
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
import TextField from "../../MiniComponent/FormField/TextField.vue";
import RadioField from "../../Common/Form/RadioField.vue";
import CheckboxField from "../../Common/Form/CheckboxField.vue";
import DateTimePicker from "../../MiniComponent/FormField/DateTimePicker.vue";
import MobileField from "../../Common/NewForm/MobileField.vue";


export default {

  name: 'automator-form-field',

  props: {

    enforcerType: { type: String, required: true },

    // Form field object
    formField: { type: Object, required: true },

    labelStyle: { type: Object, default: () => {} },

    isChild: { type: Boolean, default: false },

    enforcerObject : {type: Object, default: () => ({})},

    multipleField: {type: Boolean, default: false}

  },

  data: () => {
    return {
      _id: null,
      childNodes: [],
      dropdownOptions: [],
      selectedValue: null,
      mounted: false,
      enforcerList: [],
			showForm:true,
	    
	    country_code: null,
	    showMobileField: false,
	    extValue: '',
			relation: '',
    }
  },

  beforeMount () {
    
    // If type is 'select' we will assign options to the `dropdownOptions`
    if (this.formField.data_type === 'select' || (this.formField.data_type === 'select' && this.formField.title === 'Api')) {
      this.getSelectFieldOptions()
    }
	  
	  if(this.formField.data_type === 'mobile') {
		  
		  if(this.formField.value && this.formField.value.includes(" ")){
			  
			  this.country_code = this.formField.value.split(' ')[0];
		  }
		  
		  if(this.formField.enable_extension && this.formField.union && this.formField.union.length) {
			  
			  this.extValue = this.formField.union[0].value ? this.formField.union[0].value : '';
		  }
		  
		  this.showMobileField = true;
		  
	  } else {
		  
		  this.showMobileField = true;
	  }
  },

	created() {
		window.emitter.on('updateAutomatorField',this.updateFields);
    window.emitter.on('updateRelation', (relation) => {
      this.relation = relation;
    });
	},

  mounted () {
	  
      if(this.formField.data_type === 'mobile' && this.formField.enable_extension && this.formField.value) {
		  
		  let mobVal = "";
		  
		  if (this.formField.value && this.formField.value.includes(" ")) {
		
			  mobVal = this.formField.value.split(' ')[1];
		
		  } else {
		
			  mobVal = this.formField.value;
		  }
		  
		  this.selectedValue = mobVal;
		  
		  this.renderNestedFormFieldsIfAny({value : this.selectedValue, nodes : this.formField.union});
		  
	  } else {

		  this.selectedValue = getFormFieldValue(this.formField.value, this.formField.options, this.formField.default, this.formField.data_type, '', 'automator');

		  this.renderNestedFormFieldsIfAny(this.selectedValue);
	  }

    setTimeout(() => {
      this.mounted = true;
    }, 1000);
  },

  computed: {

    /**
     * Gives a unique key at the instance level
     */
    unique(){
      return this.formField.key + this.$.vnode.key;
    },
    
    /**
     * this will have url part of the api_info --used in case of <title = 'Api'>
     */
    apiInfoUrl () {

		let apiUrl = MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.formField.api_info).url;

		if(!apiUrl && this.formField.api_info) {

			apiUrl = this.formField.api_info;

		}

		return apiUrl
    },

    optionLabel () {
      return MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.formField.api_info).key || 'label';
    },

    clearable () {
      return this.isChild;
    },

    validationRules () {
      let validationObj = [];

      // Adding required validations only to the root {enforcer}
      if (!this.isChild) {
        validationObj.push('required')
      }

	    // if (this.formField.data_type === 'email') {
		//     validationObj.push('email')
	    // }

      return validationObj.join('|')
    },
  },

  methods: {
	  
	  /**
	   * Handles the keypress event based on the provided event, name, and type.
	   * Prevents non-numeric characters for type 'number'.
	   * Prevents non-numeric characters and multiple decimal points for types 'float' and 'decimal'.
	   * @param {Event} evt - The keypress event.
	   * @param {string} name - The name of the field.
	   * @param {string} type - The data type of the field.
	   */
	  keypressEvent(evt, name, type) {
			if (this.formField.data_type === 'time' || this.formField.data_type === 'count') {
				const charCode = (evt.which) ? evt.which : evt.keyCode;
				if (this.multipleField) {
					// Allow only natural numbers and one special character '~'
					if ((charCode < 48 || charCode > 57) && charCode !== 126) {
						evt.preventDefault();
					}else if (charCode === 126) {
						// Create a new string that represents what the value will be if the keypress event is allowed to proceed
						const newValue = (this.selectedValue || '') + String.fromCharCode(charCode);
						const hyphenIndex = newValue.indexOf('~');
						const lastHyphenIndex = newValue.lastIndexOf('~');
						if (hyphenIndex !== -1 && hyphenIndex !== lastHyphenIndex) {
							// Prevent '~' if it is already present
							evt.preventDefault();
						} else if (hyphenIndex !== -1 && (hyphenIndex !== 0 && hyphenIndex !== newValue.length - 1) || (newValue.length === 1 && hyphenIndex === 0)) {
							// Prevent '~' at the start or end, and when it's the only character
							evt.preventDefault();
						}
					}
				}else {
					// Allow only natural numbers
					if (charCode < 48 || charCode > 57) {
						evt.preventDefault();
					}
				}
				const newValue = (this.selectedValue || '') + String.fromCharCode(charCode);
				if (newValue[0] === '0') {
					// Prevent '0' at the start
					evt.preventDefault();
				}
			} else if (type === 'number' || type === 'mobile') {
			  
			  evt = (evt) ? evt : window.event;
			  
			  var charCode = (evt.which) ? evt.which : evt.keyCode;
			  
			  if ((charCode > 31 && (charCode < 48 || charCode > 57))) {
				  
				  evt.preventDefault();
			  } else {
				  
				  return true;
			  }
		  } else if (type === 'float' || type === 'decimal') {
			  
			  evt = evt || window.event;
			  
			  var charCode = (evt.which) ? evt.which : evt.keyCode;
			  
			  var value = evt.target.value;
			  
			  // Allow only one decimal point and not as first character
			  if ((charCode == 46 && value.indexOf('.') !== -1) || (charCode == 46 && value.length === 0)) {
				  evt.preventDefault();
			  }
			  
			  // Allow numeric characters and decimal point
			  else if ((charCode >= 48 && charCode <= 57) || charCode == 46) {
				  return true;
			  }
			  
			  // Prevent any other characters
			  else {
				  evt.preventDefault();
			  }
		  }
	  },
	  
	  /**
	   * Handles the paste event based on the provided event, name, and type.
	   * Prevents non-numeric characters for type 'number'.
	   * Prevents non-numeric characters and multiple decimal points for types 'float' and 'decimal'.
	   * @param {Event} evt - The paste event.
	   * @param {string} name - The name of the field.
	   * @param {string} type - The data type of the field.
	   */
	  pasteEvent(evt, name, type) {
		  
		  if (type === 'number' || type === 'mobile') {
			  
			  evt = (evt) ? evt : window.event;
			  
			  if (evt.clipboardData.getData('Text').match(/[^\d]/)) {
				  
				  evt.preventDefault();
			  }
			  
		  } else if (type === 'float' || type === 'decimal') {
			  
			  evt = evt || window.event;
			  
			  var clipboardData = evt.clipboardData || window.clipboardData;
			  
			  var pastedText = clipboardData.getData('Text');
			  
			  // Allow negative numbers and only one decimal point
			  if (!/^[-]?\d*\.?\d*$/.test(pastedText)) {
				  
				  evt.preventDefault();
			  }
		  }
	  },
	  
	  onCountryCodeUpdate(value, name) {
		  
		  this[name] = value;
		  
		  if(this.formField.enable_extension) {
			  
			  let dataVal = {
				  value : this.selectedValue,
				  nodes : this.formField.union
			  }
			  this.onChange(dataVal, this.formField.key);
		  } else {
			  
			  this.onChange(this.selectedValue, this.formField.key);
		  }
	  },
	  
	  updateFields() {

		  this.showForm = false;

		  setTimeout(()=>{

			  this.showForm = true;

		  },1);
	  },

    getEnforcerObject(unique) {
      let enforcerObject = this.enforcerObject[this.enforcerType+'s'].find(element => {
        return element.field.key === unique
      });

      if(!enforcerObject){
        return {_id: 'test'};
      }

      return enforcerObject;
    },

    onChange (value, name) {

      if (!this.mounted) return;

	    if(this.formField.data_type === 'number' && value === 0) {
		    value = "0"
	    }

	    if (this.formField.data_type === 'decimal' && typeof value === 'string' && value.endsWith('.')) {
		    value += '0';
	    }
	    
      if (Array.isArray(value)) {

        const prevVal = JSON.parse(JSON.stringify(this.selectedValue || []));

        this.selectedValue = value;

        if (value.length > prevVal.length) {
         this.processAndUpdateStore(_.differenceWith(value, prevVal, _.isEqual)[0], true);
        } else if (value.length < prevVal.length) {
          this.$store.dispatch('updateEnforcerList', { key: this.enforcerType, affectedUnique: this.$.vnode.key, formFieldUnique: this.formField.key, value: this.selectedValue, itemToRemove: _.differenceWith(prevVal, value, _.isEqual)[0] });
        }

      } else {
		
		  if(this.formField.data_type === 'mobile' && typeof value === 'object' && !Array.isArray(value)) {
			  
			  this.selectedValue = value.value;
		  } else {
			  this.selectedValue = value;
		  }
        
        this.processAndUpdateStore(value);
      }

      this.renderNestedFormFieldsIfAny(value,name);
    },

    processAndUpdateStore (data, isMultiple = false) {

      let enforcerList = [];

      if (boolean(data) && boolean(data.nodes)) {

        // for each node, one
        data.nodes.forEach((node) => {
          const newEnforcerInstance = getNewEnforcerInstance(this.enforcerType, node);
          enforcerList.push(newEnforcerInstance);
        });
      }
      this.enforcerList = enforcerList;
	    
	    const formData = {
		    key: this.enforcerType, affectedUnique: this.$.vnode.key, formFieldUnique: this.formField.key, enforcerList: enforcerList, value: this.selectedValue, isMultiple: isMultiple
	    };
	    
	    if(this.formField.data_type === 'mobile') {
		    
		    formData['appendValue'] = this.country_code;
	    }
		
      this.$store.dispatch('updateEnforcerList', formData);
    },

    renderNestedFormFieldsIfAny (value,name) {
		  
      this.childNodes = []
      if (value) {
        if (Array.isArray(value)) { // In case of checkbox `value` will be an array
          value.forEach(v => {
            if (boolean(v.nodes)) {
              this.childNodes.push(...v.nodes)
            }
          })
        } else if (boolean(value.nodes)) { // In other case value is the selected object
          // before pushing child nodes, should iterate through added enforcerList and pick unique from there

          this.childNodes = value.nodes
        }
      }
    },

    getSelectFieldOptions () {
      if (boolean(this.apiInfoUrl)) {
	      
	      if(this.formField.title === 'Api') {
		      
		      axios.get(this.apiInfoUrl).then((response) => {
			      
			      this.dropdownOptions = response.data;
			      
		      }).catch((error) => {
			      
			      console.error(error);
		      })
		      
	      } else {
		      
		      this.fetchOptionListForApiField();
	      }
      } else {
        this.dropdownOptions = this.formField.options;
      }
    },

    fetchOptionListForApiField () {
      axios.get(this.apiInfoUrl)
        .then((response) => {
          this.dropdownOptions = response.data;
        })
        .catch((error) => {
          console.error(error)
        })
    },

    clearSelectedValue () {
      this.selectedValue = null
    }

  },

  components: {
	  MobileField,
    'dynamic-select': DynamicSelect,
    'text-field': TextField,
    'radio-field': RadioField,
    'checkbox-field': CheckboxField,
    'date-time-field': DateTimePicker,
  }

}
</script>

<style scoped>
.multi-requester-checkbox {
  margin-top: -20px;
}
</style>