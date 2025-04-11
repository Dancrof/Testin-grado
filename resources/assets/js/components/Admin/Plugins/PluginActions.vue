<template>

  <!-- Display a loader while the data is being fetched -->
  <div v-if="isLoading" >

    <custom-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
  </div>

  <!-- Display a loader while the data is being fetched -->
  <span v-if="from === 'available_plugins'">

      <!-- Button for manually updating the plugin -->
     <button type="button" class="btn btn-light table_btn" @click="installPlugin(data)" v-tooltip="lang('install_plugin')">
       <i class="fa-solid fa-download"></i>
     </button>

  </span>
   <span v-else>

     <!-- Display a loader while the data is being fetched -->
     <button type="button" class="btn btn-light table_btn" @click="autoUpdate(data)"  v-tooltip="lang('auto_update')+lang(data.background_update ? 'on' : 'off')">
       <i class="update-icon" :class="data.background_update ? 'fas fa-toggle-on' : 'fas fa-toggle-on fa-rotate-180'"></i>
     </button>

     <!-- Button for navigating to plugin settings -->
     <router-link v-if="data.status && data.settings" type="button" class="btn btn-light table_btn" :to="data.settings" v-tooltip="lang('settings')">
        <i class="fas fa-cog"></i>
     </router-link>

     <!-- Button for manually updating the plugin -->
     <button v-if="data.license_status !== 1" type="button" class="btn btn-light table_btn" @click="licenseModal()" v-tooltip="lang('plugin_license')">
       <i class="fas fa-drivers-license"></i>
     </button>

   </span>

  <!-- Modal for entering the license code -->
  <modal v-if="showLicenseModal" :showModal="true" :showIconCloseBtn="false" :onClose="closeLicenseModal" :containerStyle="{width: '500px'}">

    <template #title>
      <h3 class="modal-title">{{lang('licenseCode')}}</h3>
    </template>

    <template #alert>

      <alert componentName="plugin-license"></alert>
    </template>

    <template #fields>

      <div class="entry-content clearfix">

        <p class="text-center"><b>{{lang('please_enter_your_license_code_for')}} {{data.display_name}}</b></p>

        <ValidationObserver ref="licenseErrorPage" v-slot="{ values, errors, validate }" @submit="onSubmit">

          <p class="container text-center" v-focus-first-input>

								<span v-for="(input,index) in inputArr" :key="input.current">

									<ValidationProvider :name="input.current" rules="required" v-model="input.value">

										<template v-slot="{ field, errorMessage, meta, classes }">
										<input
                        class="form-control inline_block text-uppercase"
                        :class="errorMessage ? 'field-danger' : ''"
                        type="text"
                        :name="input.current"
                        :id="input.current"
                        :ref="input.current"
                        v-model="input.value"
                        @input="onInput(input)"
                        maxlength="4"
                        size="4"
                        @paste="onPaste(index)"
                        @keydown="handleBackspace(input)"
                    />
									  <span v-if="input.next" id="dash">-</span>&nbsp;
								   </template>
								</ValidationProvider>
							</span>
          </p>

          <p class="text-center d-none">

            <button type="submit" class="btn btn-primary" :disabled="invalid" id="validate_license">
              <i class="fa fa-save"> </i> {{lang('submit')}}
            </button>
          </p>
        </ValidationObserver>
      </div>

      <div v-if="loading" slot="fields" >

        <loader :animation-duration="4000" color="#1d78ff" :size="60"/>
      </div>

    </template>

    <template #controls>

      <button type="button" @click = "onSubmit()" :disabled="!allFieldsFilled" class="btn btn-primary"><i class="fa fa-save" aria-hidden="true"></i> {{lang('save')}}</button>
    </template>
  </modal>

</template>

<script>
import { errorHandler, successHandler } from "../../../helpers/responseHandler";
import { validateLicenseSettings } from "../../../helpers/validator/licensseKeyRules";
import axios from "axios";

export default {

  // Defining props for the component
    props:{

      data:{ type: Object, required: true },

      from: { type: String, default: '' }
    },

    name: 'plugin-actions',

  data(){

      return{

        showLicenseModal:false,

        inputArr: [
          {
            current: "first",
            next: "second",
            previous : null,
            value: "",
          },
          {
            current: "second",
            next: "third",
            previous : "first",
            value: "",
          },
          {
            current: "third",
            next: "forth",
            previous : "second",
            value: "",
          },
          {
            current: "forth",
            next: null,
            previous : "third",
            value: "",
          },
        ],

        loading : false,

        hasDataPopulated : false,

        isLoading: false,

        showLoader: false,
      }
  },

  created() {
    // Listen for 'enterLicense' event and open the license modal
      window.emitter.on('enterLicense', (value) => {
          this.licenseModal(value);
      });
  },

  methods: {

    // Open's the license modal
      licenseModal() {
            this.showLicenseModal = true;
        },

    // Close's the license modal
      closeLicenseModal() {
            this.showLicenseModal = false;
            this.inputArr.map(input => {
              input.value = '';
              return input;
            });
        },

    // Handle's backspace event in the license input fields
      handleBackspace(input) {

        if (event.keyCode === 8) {
          // Handle the backspace event here
          if(!input.value.length && input.previous) {

            const inputElement = this.$refs[input.previous][0];

            if (inputElement) {

              inputElement.setSelectionRange(this.$refs[input.previous][0].value.length, this.$refs[input.previous][0].value.length);

              inputElement.focus();
            }
          }
        }
      },

    // Handle's input event in the license input fields
      onInput(input) {

        if (input.value.length === 4 && input.next && !this.$refs[input.next][0].value) {

          let focusField = this.$refs[input.next][0];

          focusField.setSelectionRange(focusField.value.length, focusField.value.length);

          focusField.focus();
        }
      },

    // Handle's paste event in the license input fields
      onPaste(index) {

        event.preventDefault();

        const text = event.clipboardData.getData("text/plain");

        if (!text) return;

        const sanitizedText = this.sanitizeText(text);

        // Get the clicked input field
        const clickedInput = this.inputArr[index];

        // Start pasting after existing characters in the clicked input field
        const startAt = clickedInput.value.length;

        // Calculate the remaining characters in the clicked input field
        const remainingChars = 4 - startAt;

        // Paste the text into the clicked input field, starting from the remaining characters
        clickedInput.value += sanitizedText.substring(0, remainingChars);

        // Distribute the remaining text to subsequent fields
        let textIndex = remainingChars;
        for (let i = index + 1; i < this.inputArr.length && textIndex < sanitizedText.length; i++) {
          const field = this.inputArr[i];
          const charsToCopy = Math.min(4, sanitizedText.length - textIndex);
          field.value = sanitizedText.substring(textIndex, textIndex + charsToCopy);
          textIndex += charsToCopy;
        }

        this.focusNextField(index);

      },

    // Focuses on the next empty input field after a paste event
      focusNextField(index) {
        for (let i = index; i < this.inputArr.length; i++) {
          const field = this.inputArr[i];

          if (!field.value || field.value.length !== 4 || !field.next) {
            this.$nextTick(() => this.focusField(i));
            break;
          }
        }
      },

    // Focuses on a specific input field
      focusField(index) {
        const nextField = this.$refs[this.inputArr[index].current][0];
        nextField.focus();
        nextField.selectionStart = nextField.value.length;
        nextField.selectionEnd = nextField.value.length;
      },

    // Sanitizes a string by removing non-alphanumeric characters
      sanitizeText(string) {

        return string.trim().replace(/[^A-Za-z0-9]/g, "");
      },

    // Checks if the license settings are valid
      isValid(){

        const {errors, isValid} = validateLicenseSettings(this.$data);
        if(!isValid){
          return false
        }
        return true
      },

    /**
     * Submits the license code.
     *
     * This method validates the license code entered by the user. If the validation is successful,
     * it sends the license code to the server for verification and processing. The method handles
     * the server response, displays success or error messages, and resets the input fields.
     */
    onSubmit() {

      // Validates the license code
      if (this.$refs.licenseErrorPage.validate()) {

        this.loading = true;

        let licenseValue = this.inputArr.map(input => input.value).join('').toUpperCase();
        let plugin = {
          plugin: this.data.path,
          licenseCode: licenseValue,
        };

        // Handles the server response
        axios.post('plugin/license',plugin).then(res=>{

          successHandler(res,'dataTableModal');
          window.location.reload();
          this.closeLicenseModal();
          this.inputArr.map(input => {
            input.value = '';
            return input;
          });
        }).catch(error=>{

          errorHandler(error,'plugin-license');
          this.inputArr.map(input => {
            input.value = '';
            return input;
          });
        }).finally(()=>{

          // Reset the input fields and close the license modal
          this.loading = false;
          setTimeout(()=>{
            this.$store.dispatch('unsetAlert'); // Unset the alert
          },3000);
        })
      }
    },

    // Toggles the auto-update setting of a plugin
      autoUpdate(plugin){

        this.isLoading = true;

        axios.post('plugin/auto-update-background', {key: plugin.path, enabled: !plugin.background_update})
            .then((res) => {

              this.isLoading = false;
              successHandler(res,'dataTableModal');
              setTimeout(()=>{
                window.emitter.emit('refreshData');
              },10);
            })
            .catch((err) => {
              this.isLoading = false;
              errorHandler(err, 'dataTableModal');
            })
      },

      installPlugin(plugin){

        this.isLoading = true;

        axios.post('plugin/install', {'product_id': plugin.id})
            .then((res) => {

              this.isLoading = false;
              successHandler(res,'dataTableModal');
              setTimeout(()=>{
                window.location.reload();
              },10);
            })
            .catch((err) => {
              this.isLoading = false;
              errorHandler(err, 'dataTableModal');
            })

      }

    },

  computed: {
    allFieldsFilled() {
      return this.inputArr.every(input => input.value.trim().length === 4);
    },
  },

}
</script>

<style scoped>

.inline_block{
  width: auto !important;
  display: inline-block !important;
}

#dash{
  margin-top: 5px;
  margin-left: 5px;
  color: #838586;
}
.field-danger{
  border : 1px solid red;
}

.update-icon{
  font-size: 17px;
}

</style>