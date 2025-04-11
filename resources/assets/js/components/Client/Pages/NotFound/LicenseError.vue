<template>

    <div class="row">

        <div id="content" class="site-content col-sm-12">

            <div v-if="loading">

                <client-panel-loader :size="60"></client-panel-loader>
            </div>

            <div v-if="!hasDataPopulated">

                <loader :size="60"></loader>
            </div>

            <alert componentName="License"/>

            <article class="hentry" v-if="verify">

                <header class="entry-header text-center">

                    <h3 class="entry-title">{{lang('licenseCode')}}</h3>
                </header>

                <div class="entry-content clearfix">

                    <p class="text-center">{{lang('find_your_license_code')}}
                        <a href="https://billing.faveohelpdesk.com" target="_blank">billing.faveohelpdesk.com</a>
                    </p>


                      <p class="text-center"><b>{{lang('please_enter_your_license_code_for')}} {{laravelConfig}}</b></p>


                    <ValidationObserver ref="licenseErrorPage" v-slot="{ values, errors, validate }" @submit="onSubmit">

                        <p class="container text-center">
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
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
                                        />&nbsp;
									  <span v-if="input.next" id="dash">-</span>&nbsp;
								   </template>
								</ValidationProvider>
							</span>
                        </p>

                        <p class="text-center">

                            <button type="submit" class="btn btn-primary" :disabled="invalid" id="validate_license">
                                <i class="fa fa-save"> </i> {{lang('submit')}}
                            </button>
                        </p>
                    </ValidationObserver>
                </div>
            </article>
        </div>
    </div>
</template>

<script>

import { errorHandler, successHandler } from '../../../../helpers/responseHandler'
import {scrollToErrorBlock, validateFormData} from '../../../../helpers/formUtils'

import axios from  'axios'
import Loader from "../../ClientPanelLayoutComponents/ReusableComponents/Loader.vue";

export default {

  props : {
    laravelConfig : { type : Object, default : ()=>{}},
  },


  data(){

        return {

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

            verify : false
        }
    },

    beforeMount(){

        this.getValues();
    },

    methods : {

        getValues(){

            this.$Progress.start();

            axios.get('/api/licenseError').then(res=>{

                this.hasDataPopulated = true;

                this.verify = true;

                this.$Progress.finish();

            }).catch(error=>{


                this.$Progress.fail();

                this.hasDataPopulated = true;

                errorHandler(error,'License');

                var msg = error.response.data.message;

                if(msg.includes('not') || msg.includes('expired')){

                    this.verify = true
                } else {

                    this.redirect('/')
                }
            })
        },
        
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
        
        onInput(input) {

            if (input.value.length === 4 && input.next && !this.$refs[input.next][0].value) {
                
                let focusField = this.$refs[input.next][0];
                
                focusField.setSelectionRange(focusField.value.length, focusField.value.length);
                
                focusField.focus();
            }
        },

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
        
        focusNextField(index) {
            for (let i = index; i < this.inputArr.length; i++) {
                const field = this.inputArr[i];
                
                if (!field.value || field.value.length !== 4 || !field.next) {
                    this.$nextTick(() => this.focusField(i));
                    break;
                }
            }
        },
        
        focusField(index) {
            const nextField = this.$refs[this.inputArr[index].current][0];
            nextField.focus();
            nextField.selectionStart = nextField.value.length;
            nextField.selectionEnd = nextField.value.length;
        },
        
        sanitizeText(string) {

            return string.trim().replace(/[^A-Za-z0-9]/g, "");
        },

        isValid(){

            const {errors, isValid} = validateLicenseSettings(this.$data);

            if(!isValid){

                return false
            }
            return true
        },

        onSubmit() {

            if (this.$refs.licenseErrorPage.validate()) {

                this.$Progress.start();

                this.loading = true;

                const data = {};

                for(let i in this.inputArr) {

                    data[this.inputArr[i].current] = this.inputArr[i].value
                }

                axios.post('/licenseVerification',data).then(res=>{

                    this.loading = false;

                    successHandler(res,'License');

                    this.redirect('/');

                    this.$Progress.finish();

                }).catch(error=>{

                    this.loading = false;

                    errorHandler(error,'License');

                    this.$Progress.fail();

                })
            }
        }
    },

    components : {

        'client-panel-loader' : Loader
    }
};
</script>

<style scoped>

.inline_block{
    width: auto !important;
    display: inline-block !important;
}

#dash{
    margin-top: 5px;
    color: #838586;
}
.field-danger{
    border : 1px solid red;
}
</style>