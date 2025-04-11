<template>

	<div>

		<date-time-field v-if="formField.data_type === 'date'" :type="formField.request_time_information ? 'datetime' : 'date'"  :label="formField.label" :value="selectedValue" :id="formField.key" :required="false"
			:name="formField.key" :onChange="onChange" :format="formField.request_time_information ? 'MMMM DD YYYY HH:mm:ss' : 'MMMM DD YYYY'" :clearable="true" outputFormat="YYYY-MM-DD HH:mm:ss">
			
		</date-time-field>
		
		<dynamic-select v-if="formField.data_type === 'select' && formField.title !== 'Api'" :id="formField.key" :label="formField.label" :multiple="false" :name="formField.key" :apiEndpoint="apiInfoUrl" :value="selectedValue" :onChange="onChange" :optionLabel="dropdownLabel">
		
		</dynamic-select>
		
		<dynamic-select v-if="formField.data_type === 'select' && formField.title === 'Api'" :id="formField.key" :label="formField.label"
		                :multiple="false"
		                :name="formField.key" :elements="dropdownOptions" :value="selectedValue" :onChange="onChange"
		                :optionLabel="dropdownLabel" :strlength="75"
		                :fieldUniqueName="formField.key" :labelLength="25">
		</dynamic-select>

		<text-field v-if="formField.data_type === 'text' || formField.data_type === 'textarea' || formField.data_type === 'number' || formField.data_type === 'decimal' || formField.data_type === 'email'" 
			:id="formField.key" :label="formField.label" :type="formField.data_type" :name="formField.key" :value="selectedValue" :onChange="onChange"
			from="filter" :keypressEvt="keypressEvent" :pasteEvt="pasteEvent">
			
		</text-field>

		<radio-field v-if="formField.data_type === 'radio'" :name="formField.key" :label="formField.label" :options="formField.options" :value="selectedValue" 
			:onChange="onChange" from="filter">
				
		</radio-field>

		<checkbox-field v-if="formField.data_type === 'checkbox'" :name="formField.key" :label="formField.label" :options="formField.options" 
			:value="selectedValue" :onChange="onChange" from="filter">
				
		</checkbox-field>
		
		<MobileField v-if="showMobileField && formField.data_type === 'mobile'" fieldFor="automator"
             :id="formField.key" :label="formField.label" :type="formField.data_type" :name="formField.key"
             :value="selectedValue" :onChange="onChange" :isInlineForm="false"
             :countryCode="country_code" @countryCode="onCountryCodeUpdate($event, 'country_code')"
             :keypressEvt="keypressEvent" :pasteEvt="pasteEvent"
             :extensionEnabled="0" :ext="[]">
		</MobileField>
	</div>
	
</template>

<script>

import {MULTIPLE_PROPERTY_HELPER, boolean} from "../../../../helpers/extraLogics";
import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import RadioField from "../../../Common/Form/RadioField.vue";
import CheckboxField from "../../../Common/Form/CheckboxField.vue";
import DateTimePicker from "../../../MiniComponent/FormField/DateTimePicker.vue";
import MobileField from "../../../Common/NewForm/MobileField.vue"
import axios from "axios";

export default {

	name: 'custom-form-fields',

	props: {

		formField: { type: Object, required: true },

		allFields : { type : Array, default : ()=> [] }
	},

	data () {

		return {

			selectedVal : this.formField.value,

			uniqueId : this.formField.key,

			updatedFields : this.allFields,

			dropdownOptions: [],

			dropdownLabel : 'label',
			
			country_code: null,
			showMobileField: false,
		}
	},

	watch : { 

		allFields(newValue,oldValue){

			this.updatedFields = newValue;
		},

		formField(newValue,oldValue) {

			this.uniqueId = newValue.key;

			this.selectedVal = newValue.value;

			if(newValue.data_type === 'checkbox') {

				this.selectedVal = this.selectedVal.split(',')
			}
			
			if(newValue.data_type === 'mobile' && this.selectedVal && this.selectedVal.includes(" ")) {

        const parts = this.selectedVal.split(' ');
        if (parts.length > 1) {
          const code = parts.shift();
          this.selectedVal = parts.join(' ');
        }
			}
		}
	},

	beforeMount() {

		if(this.formField.data_type === 'select' || (this.formField.data_type === 'select' && this.formField.title === 'Api')) {
	      
	      this.getSelectFieldOptions()
	   }
		
		if(this.formField.data_type === 'mobile' && this.formField.value && this.formField.value.includes(" ")) {
			
			this.country_code = this.formField.value.split(' ')[0];
			
			this.showMobileField = true;
			
		} else {
			
			this.showMobileField = true;
		}
	},

	computed : {

		apiInfoUrl () {
			
			let apiUrl = MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.formField.api_info).url;
			
			if(!apiUrl && this.formField.api_info) {
				
				apiUrl = this.formField.api_info;
				
			}
			
			return apiUrl
    	},

    	dropdownKey () {

    		let keyName = MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.formField.api_info).key || 'label';

    		return keyName
    	},

		selectedValue() {

			let index = this.updatedFields.findIndex(obj => obj.key == this.uniqueId);
			
			if(index != -1){
				
				if (this.formField.data_type === 'mobile' && this.selectedVal && this.selectedVal.includes(" ")) {
          const parts = this.selectedVal.split(' ');
          if (parts.length > 1) {
            const code = parts.shift();
            return parts.join(' ');
          }
				}

				if (Array.isArray(this.selectedVal) && this.selectedVal != null) {
				
					let valueArr = [];

					this.selectedVal.forEach(val => {
				
						if(typeof val == 'object'){
				
							valueArr.push(val.label)
				
						} else{
				
							valueArr.push(val)
						}
					})
					
					this.updatedFields[index].value = valueArr.map(val => val).toString();
					
					return this.updatedFields[index].options.filter(option =>valueArr.includes(option.label));
		
				} else if (!boolean(this.updatedFields[index].options)) return (this.selectedVal ? this.selectedVal : '');

				else {

					let objVal = '';

						if(typeof this.selectedVal == 'object'){
							
							objVal = this.selectedVal.label;
						} else{
							
							objVal = this.selectedVal;
						}

						return this.updatedFields[index].options.find((item) => item.label === objVal);		
				}
				
			} else {

				return this.selectedVal;
			}
		}
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
			
			if (type === 'number' || type === 'mobile') {
				
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
		},
		
		getSelectFieldOptions () {
      	
      	if (boolean(this.apiInfoUrl)) {
	        
	        if(this.formField.title === 'Api') {
		        
		        this.dropdownLabel = this.dropdownKey;
				
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

        		this.dropdownLabel = 'label'
      	}
    	},

    	// Fetch option list -- specifically for 3rd party api config form-field
    	fetchOptionListForApiField () {

      	axios.get(this.apiInfoUrl).then((response) => {

          	this.dropdownLabel = this.dropdownKey;

          	let finalizedValue = response.data;

          	for(let i in finalizedValue) {

          		finalizedValue[i][this.dropdownLabel] = finalizedValue[i][this.dropdownLabel].toString()
          	}

         	this.dropdownOptions = finalizedValue;
          	
        	}).catch((error) => {
         
          	this.dropdownOptions = [];
        	})
    	},

		// triggered when any form-field value detects any change
		onChange (value, name) {

			if(this.formField.data_type === 'number' && value === 0) {
				value = "0"
			}

			let index = this.updatedFields.findIndex(obj => obj.key === name);
			
			if(Array.isArray(value) && value != null){
			
				this.updatedFields[index].value = value.map(obj => obj.label).toString();
				
				this.selectedVal = value;

			} else if(typeof value == 'object' && value != null){
			
				this.updatedFields[index].value = value[this.dropdownLabel];

				this.selectedVal = value;

			}  else {
				
				if(this.formField.data_type === 'mobile') {
				
					this.updatedFields[index].value = value ? this.country_code + ' ' + value : '';
					
					this.selectedVal = value ? this.country_code + ' ' + value : '';
					
				} else {
					
					this.updatedFields[index].value = value ? value : ''
					
					this.selectedVal = value ? value : '';
				}
			}
			
			this.$emit('updated',this.updatedFields);
		}
	},

	components: {
	 
		'dynamic-select': DynamicSelect,
		
		'text-field': TextField,
		
		'radio-field': RadioField,
		
		'checkbox-field': CheckboxField,
		
		'date-time-field': DateTimePicker,
		
		MobileField
	}
};
</script>