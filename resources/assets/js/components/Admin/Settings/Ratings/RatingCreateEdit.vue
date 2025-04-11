<template>

    <div class="col-sm-12">
        <alert componentName="rating-create-edit" />

        <custom-loader v-if="loading" />

        <faveo-box :title="cardTitle">

            <div class="row" v-focus-first-input>

                <text-field
                    name="name" :value="name" :on-change="onChange" :placehold="lang('enter_a_value')" :label="lang('rating_label')"
                    type="text" :required="true" classname="col-sm-6"
               />

               <static-select
                  name="rating_scale" :value="rating_scale" :on-change="onChange" :hint="lang('rating-msg1')"
                  :label="lang('rating_scale')" :elements="ratingScaleOptions" :required="true" classname="col-sm-6" :disabled="id ? true : false"
                />

            </div>

            <div class="row">

                <text-field
                    name="thank_you_message" :value="thank_you_message" :on-change="onChange" :placehold="lang('enter_a_value')" :label="lang('rating_thank_you_message')"
                    :required="true" classname="col-sm-6" :hint="lang('rating_thank_you_message_hint')"
               />

              <radio-button :options="radioOptions" :label="trans('send_auto_reminders')" name="auto_reminder"
                            :value="auto_reminder" :onChange="onChange" classname="form-group col-sm-6">

              </radio-button>

            </div>


          <div v-if="auto_reminder" class="row">
            
            <text-field :label="trans('remider_time_interval')" :hint="lang('time_interval')" type="number" name="reminder_time_interval" :value="reminder_time_interval"
                        classname="col-sm-6" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" >

            </text-field>

            <text-field :label="trans('number_of_reminders')" :hint="lang('no_of_reminders')" type="number" name="total_number_of_reminders" :value="total_number_of_reminders"
                        classname="col-sm-6" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" >

            </text-field>

          </div>

            <div class="row">
              <div class="form-check ms-3 mt-1 col-sm-3">
                <input type="checkbox" :false-value="0" :true-value="1" v-model="is_default" class="form-check-input" id="default_rating_checkbox">
                <label class="form-check-label fw-normal fs-8" for="default_rating_checkbox">
                  {{ lang('rating_make_default') }}
                </label>
              </div>

              <div class="form-check ms-3 mt-1 col-sm-3">
                <input type="checkbox" :false-value="0" :true-value="1" v-model="show_additional_comment_box" class="form-check-input" id="additional_comment_checkbox" :disabled="id">
                <label class="form-check-label fw-normal fs-8" for="additional_comment_checkbox">
                  {{ lang('rating_show_additional_comment_box_label') }}
                  <tool-tip :message="lang('rating_show_additional_comment_box_label_hint')" size="small"/>
                </label>
              </div>

              <div class="form-check ms-3 mt-1 col-sm-3">
                <input type="checkbox" :false-value="0" :true-value="1" v-model="has_additional_question" class="form-check-input" id="additional_question_checkbox" @click="addQuestionIfEmpty" :disabled="id">
                <label class="form-check-label fw-normal fs-8" for="additional_question_checkbox">
                  {{ lang('rating_show_additional_rating_box_label') }}
                  <tool-tip :message="lang('rating_show_additional_rating_box_label_hint')" size="small"/>
                </label>
              </div>
            </div>

            <template id="additional_questions" v-if="has_additional_question">
              <faveo-box :title="trans('rating_additional_questions')" class="mt-4">
                <div class="row mt-1" v-for="(question,index) in questions" :key="index">

                  <span class="col-sm-auto">

                    <i v-if="!deleteQuestionBtnDisabled" id="rating-question-trash" class="fas fa-trash faveo-trash actionButtons" @click="deleteQuestion(index)"></i>

                    <i v-else id="rating-question-trash-d" class="fas fa-trash faveo-trash actionButtons disabled"></i>
                  </span>

                  <div class="col-sm-6">
                    <form-field-template :name="`additional_rating_questions.${index}.question`" label="">
                      <input :placeholder="lang('rating_additional_question_placeholder')" type="text" class="form-control" v-model="question.name">
                    </form-field-template>
                  </div>

                </div>

                <div class="row">
                  <div class="col-sm-12">
                    <div style = "margin-top: 1rem">
                      <button v-if="!deleteQuestionBtnDisabled" type="button" class="btn btn-light btn-block" @click="addQuestion">
                        <span>
                          <i aria-hidden="true" class="fas fa-plus"></i> {{trans('rating_add_question')}}
                        </span>
                      </button>
                      <button v-else type="button" class="btn btn-light btn-block disabled">
                        <span>
                          <i aria-hidden="true" class="fas fa-plus"></i> {{trans('rating_add_question')}}
                        </span>
	                    </button>
                    </div>
                  </div>
                </div>

              </faveo-box>


            </template>

			<template #actions>
				<div class="card-footer">

					<button type="button" id="submitter"  @click="submit" class="btn btn-primary">
						<i class="fas fa-save" aria-hidden="true"></i> {{lang('submit')}}
					</button>

				</div>
			</template>
        </faveo-box>
    </div>
  
</template>

<script>

import axios from 'axios';
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
import { validateRatingSettings } from './ratingValidator';
import ToolTip from "../../../MiniComponent/ToolTip.vue";
import FormFieldTemplate from "../../../MiniComponent/FormField/FormFieldTemplate.vue";
import  { getIdFromUrl } from '../../../../helpers/extraLogics';
import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";

    export default {

        components: {
          'radio-button': RadioButton,
            TextField, StaticSelect, ToolTip, FormFieldTemplate
        },

        props: { rating: {type: Object, default: () => {}}, edit: {type: Boolean, default: false} },

        data() {
            return {
                name: '',

                rating_scale: '',

                rating_icon: 'star', // will be changed when `smiley` is implemented.

                ratingScaleOptions: [
                    {id: 2, name: 'Two'},
                    {id: 3 ,name: 'Three'},
                    {id: 5,name:  'Five'},
                    {id: 7,name:  'Seven'}
                ],

                thank_you_message: '',

                is_default: 1,

                loading: false,

                id: null,

                show_additional_comment_box: 0,

                has_additional_question: 0,

                questions: [],

              auto_reminder  : 0,

              radioOptions:[{name:'yes',value:1},{name:'no',value:0}],

              reminder_time_interval: '',

              total_number_of_reminders: ''
            }
        },

        beforeMount() {

	        this.getDataForEdit();

        },

        computed: {
            cardTitle() {
                let langKey = this.id ? 'rating_update' : 'create_new_rating'
                return this.lang(langKey); 
            },

            deleteQuestionBtnDisabled() {
                return (this.id);
            }
        },

        methods: {
            async getDataForEdit() {

	            const ratingId = getIdFromUrl(window.location.pathname);

	            if (window.location.pathname.indexOf("edit") >= 0) {

		            this.loading = true;

		            try {
			            const response = await axios.get(`api/get-rating/${ratingId}`);
			            this.updateStatesWithData(response.data)
			            this.loading = false;
		            } catch (e) {
			            console.log("Trying to get rating for edit", e)
		            }

	            } else {
					return;
	            }
            },

            onChange(value,name){
                this[name] = value;
            },

            addQuestion() {                                
                this.questions.push({name: ''});
            },

            addQuestionIfEmpty() {
                if (!this.questions.length) {
                    this.addQuestion();
                }
            },

            deleteQuestion(index) {
                if (this.questions.length === 1) {
                    return;
                }
                this.questions.splice(index, 1);
            },

            isValid() {
              return !!validateRatingSettings(this.$data);
            },

            async submit() {
                
                if (!this.isValid()) {
                    return null;
                }

                let url,method;

                if(this.id) {
                    url = `update-rating/${this.id}`;
                    method = 'PATCH';
                } else {
                    url = 'store-rating';
                    method = 'POST'
                }

                this.loading = true;

                let data = {
                    name: this.name,
                    rating_scale: this.rating_scale,
                    thank_you_message: this.thank_you_message,
                    is_default: this.is_default,
                    show_additional_comment_box: Boolean(this.show_additional_comment_box),
                    has_additional_question: Boolean(this.has_additional_question),
                    questions: this.questions,
                    rating_icon: this.rating_icon || 'star', // changed when smiley is implemented
                    auto_reminder: this. auto_reminder,
                    reminder_time_interval: this.auto_reminder ? this.reminder_time_interval || '' : '',
                    total_number_of_reminders: this.auto_reminder ? this.total_number_of_reminders || '' : '',
                }

                try {

                    let response = await axios.request({ method, url, data })

                    this.$store.dispatch('unsetValidationError');

                    successHandler(response, 'rating-create-edit');

                    if(!this.id) {
                        setTimeout(()=> {
	                        this.$router.push({ name : 'Rating Index'})
                        }, 3000)
                    }
                } catch (e) {
                    errorHandler(e, 'rating-create-edit');
                } finally {
                    this.loading = false;
                }
            },

            updateStatesWithData(data){

                const self = this;

                const stateData = this.$data;

                Object.keys(data).map(key => {

                    if (stateData.hasOwnProperty(key)) {

                        self[key] = data[key];
                    }
                });
            },
        }

    }
</script>

<style scoped>
  .actionButtons {
    margin-top: 30px;
    padding-right: 1.5rem;
  }

  i.disabled {
    cursor: not-allowed;
  }

  .form-check-input{
    cursor: pointer;
  }

</style>