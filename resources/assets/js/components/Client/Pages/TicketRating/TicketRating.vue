<template>

  <transition name="page" mode="out-in">

    <div>

      <alert id="alert">
      </alert>

      <template  v-if="loading">
        <div id="loader" class="row">
          <loader :animation-duration="4000" :size="60" :color="layout.portal.client_header_color"/>
        </div>
      </template>

      <template v-else>

        <div class="card" v-if="showExtraForm">
          <div class="card-body scrolling-card">
            <div class="row">
              <div class="col-sm-12">
                <div class="alert alert-success" role="alert">
                  <strong>{{ thankYouMessage }}</strong>
                  <button type="button" class="btn-close float-end" data-dismiss="alert" aria-label="Close">
                  </button>
                </div>
              </div>
            </div>

            <div class="row mt-3" v-if="showAdditionalQuestions && (questions.length)">
              <div class="col-sm-12">

                <faveo-box title="Additional Rating">
                  <div class="table-responsive">
                    <table class="table table-sm table-borderless" style="width:100%">
                      <tbody>
<!--                      <tr v-for="question in questions" :key="question.id">-->
<!--                        <td class="wrap-text">{{ question.question }}</td>-->
<!--                        <td>-->
<!--                          <star-rating :inline="true" v-model="question.value"-->
<!--                             :show-rating="false" :max-rating="ratingScale" :star-size="20"-->
<!--                          />-->
<!--                        </td>-->
<!--                      </tr>-->
                      <tr v-for="question in questions" :key="question.id">
                        <td>
                          <b class="question_name">{{question.name}}</b> &nbsp; &nbsp;<star-rating :inline="true" v-model="question.value"
                             :show-rating="false" :max-rating="ratingScale" :star-size="20"
                        />
                        </td>
                      </tr>
                      </tbody>
                    </table>
                  </div>

                  <div class="row" v-if="showCommentBox" v-focus-first-input>

                    <text-field
                        name="comment" :value="comment" :placehold="lang('rating_additional_feedback_placeholder')"
                        :onChange="onChange" label="" classname="col-sm-12" rows="3"
                        type="textarea" length="250" :show-word-limit="true"
                    />

                  </div>

                </faveo-box>

              </div>
            </div>
          </div>

          <div class="card-footer">
            <button class="btn btn-custom btn-md" :style="btnStyle" @click.once.prevent="submitAdditionalComments" v-if="showAdditionalQuestions || showCommentBox
            ">
              {{ lang('submit') }}
            </button>
          </div>
        </div>

        <div v-else><index :layout="layout" :auth="auth"></index></div>

      </template>

    </div>
  </transition>
</template>

<script>

import {errorHandler, successHandler} from '../../../../helpers/responseHandler'

import axios from 'axios'

import TextField from "../../../MiniComponent/FormField/TextField.vue";

import FaveoBox from "../../../MiniComponent/FaveoBox.vue";

import Index from "../Index.vue";

export default{

  props : {

    layout : { type :  Object, default : ()=>{}},

    auth : { type : Object, default : ()=>{}}
  },

  data(){

    return{

      hash : '',

      rating : '',

      loading : true,

      comment: '',

      showCommentBox: false,

      thankYouMessage: '',

      ticketId: '',

      ratingTypeId: '',

      language : this.layout.language,

      btnStyle : {

        borderColor : this.layout.portal.client_button_border_color,
	      color : this.layout.portal.client_button_font_color + ' !important',
        backgroundColor : this.layout.portal.client_button_color,
      },

      questions: [],

      showAdditionalQuestions: false,

      ratingScale: null
    }
  },

  beforeMount() {

    this.getValues();
  },

  computed: {
    showExtraForm() {
      return this.showCommentBox || this. showAdditionalQuestions;
    }
  },


  methods:{

    getHashFromUrl(url){

      let urlArray = url.split("/");

      return urlArray[urlArray.length - 1];

    },

    onChange(value,name){
      this[name] = value;
    },

    getRatingFromUrl(url){

      let urlArray = url.split("/");

      return urlArray[urlArray.length - 1];

    },

    hideCommentBox() {
      this.showCommentBox = false;
    },

    hideQuestions() {
      this.showAdditionalQuestions = false;
    },

    finishProgress() {
      this.loading = false;
      this.$Progress.finish();
    },

    displayAlert(type, message) {
      this.$store.dispatch('setAlert', { type: type, message: message, component_name: '' })
    },

    detectRatingGivenForAtLeastOneQuestion() {
      let ratingAddedCount = 0;

      this.questions.forEach((question) => {
        if (question.value) {
          ratingAddedCount++;
        }
      });

      return Boolean(ratingAddedCount);
    },

    submitAdditionalComments() {
      this.loading = true;
      this.$Progress.start();

      if (this.showExtraForm && (! this.comment && ! this.detectRatingGivenForAtLeastOneQuestion())) {
        this.hideCommentBox();
        this.hideQuestions();
        this.finishProgress();
        return;
      } else if (!this.showExtraForm && this.showCommentBox && ! this.comment) {
        this.hideCommentBox();
        this.finishProgress();
        return;
      } else if (!this.showExtraForm && this.showAdditionalQuestions && ! this.detectRatingGivenForAtLeastOneQuestion()) {
        this.hideQuestions();
        this.finishProgress();
      }

      if (!this.ticketId || !this.ratingTypeId) {
        this.hideCommentBox();
        this.displayAlert('danger', this.lang('rating_comment_invalid_ticket_or_rating_type'));
        return;
      }
      
      axios.post(`api/add-additional-feedback/${this.ticketId}/${this.ratingTypeId}`,
          {comment: this.comment, questions: this.questions, user_id: this.auth.user_data.id}
      )
      .then((response) => {
        successHandler(response);
        this.redirect('/');
        this.hideQuestions();
        this.hideCommentBox();
        this.finishProgress();
      })
      .catch((error) => {
        this.$Progress.fail();
        errorHandler(error)
      })

    },

    getValues(){

      this.$Progress.start();

      const path = window.location.pathname;

      this.hash = this.getHashFromUrl(path);

      this.rating = this.getRatingFromUrl(path);

      const urlParams = new URLSearchParams(window.location.search);

      axios.get('/api/rating/'+this.hash).then(res => {

        localStorage.setItem('redirectPath','');

        let data = res.data.data;

        this.loading = false

        this.$Progress.finish();

        this.showCommentBox = !!data.show_additional_comment_box;

        this.showAdditionalQuestions = !!data.has_additional_question;

        this.thankYouMessage = data.thank_you_message;

        this.ticketId = data.ticketId;

    this.$store.dispatch('setRatingTypes', this.ticketId);

        this.ratingTypeId = data.id;

        this.ratingScale = data.rating_scale;

        if (! this.showExtraForm) {
          this.displayAlert('success', data.thank_you_message)
        }

        if (data.questions.length) {
          data.questions.forEach((question) => {
            this.questions.push({...question, value: 0});
          });
        }

      }).catch(err => {
        this.loading = false
        this.$Progress.fail();
        if(err.response.data.message == 'You are unauthorised to give feedback.'){
          this.redirect('/auth/login');
        }
        this.displayAlert('danger', err.response.data.message)
        localStorage.setItem('redirectPath',window.location.pathname);

      })
    },
  },

  components : {


    'index' : Index,

    TextField, FaveoBox
  }
};
</script>

<style scoped>

.card-title { float: left; font-size: 1.1rem; font-weight: 400; margin: 0; }

.card-header>.card-tools { float: right; margin-right: -.625rem;}

.wrap-text {
  min-width: 100px;
  max-width: 100px;
  word-wrap: break-word;
  margin-top: 2px;
}

.scrolling-card {
  max-height: 500px;
  overflow-y: auto;
}

/* This is hiding label of textfield please feel free to tweak this if any problem occurs */
div > label {
  display: none;
}

</style>
