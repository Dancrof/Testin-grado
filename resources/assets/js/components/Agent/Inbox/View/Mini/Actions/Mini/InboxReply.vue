<template>

  <div class="card card-light" :class="{'reply-card' : !replyZindex}">

    <div class="card-header">

      <h3 class="card-title">{{trans('reply')}}</h3>

      <div class="card-tools d-flex">

        <div id="support-session-view">{{displaySupportSession()}}</div>

        <button v-if="showCanned" class="btn btn-light btn-sm" @click="toggleCanned">

          <i class="fas fa-minus"></i> {{trans('hide_canned_response')}}
        </button>

        <button v-else class="btn btn-light btn-sm" @click="toggleCanned">

          <i class="glyphicon glyphicon-plus"></i> {{trans('add_canned_response')}}
        </button>
        <div id="redaction-view">{{displayRedaction()}}</div>
      </div>
    </div>

    <div class="card-body">

      <div class="row">

        <dynamic-select :label="trans('to')" name="to" :value="to" :onChange="onChange" :disabled="true" :strlength="30"
                        :multiple="false" classname="col-sm-6" :clearable="false" optionLabel="meta_name">

        </dynamic-select>

        <dynamic-select :label="trans('cc')" name="cc" :value="cc" :onChange="onChange" :taggable="true"
                        :close_on_select="true" apiEndpoint="/api/dependency/users?meta=true"  :multiple="true" :strlength="30"
                        classname="col-sm-6 cc_field" :rules="rules" :key="resetCC">

        </dynamic-select>
      </div>

      <div class="row">

        <dynamic-select v-if="showCanned" :label="trans('response')" name="response" :value="response"
                        :onChange="onChange" :strlength="30"
                        :multiple="false" classname="col-sm-6" apiEndpoint="/api/dependency/canned-responses"
        >

        </dynamic-select>

        <time-field v-if="getTicketActions.show_thread_worktime && !fieldLoader" :label="trans('worktime')" :formStyle="formStyle"
                    :value="worktime" type="number" name="worktime" :onChange="onChange" classname="col-sm-6"
                    :required="getTicketActions.require_thread_worktime">

        </time-field>

        <dynamic-select v-if="getTicketActions.show_worktime_type && !fieldLoader && worktime" :label="trans('worktime_type')" name="worktime_type" :value="worktime_type"
                        :onChange="onChange" :strlength="30" :multiple="false" classname="col-sm-6"
                        apiEndpoint="api/worktime-type-list" :required="getTicketActions.require_worktime_type_field && worktime"></dynamic-select>
        <div v-if="getTicketActions.show_thread_worktime && fieldLoader" class="col-sm-6 load_margin">

          <reuse-loader :size="30" :duration="4000"></reuse-loader>
        </div>
      </div>

			<div class="row">

        <add-media :type="type" :attachments="attachments" :inlineFile="inline" :description="reply" id="focus_editor"
                   classname="col-sm-12" name="reply" :onAttach="getAttachments" :onInline="getInlineImages" :onInput="onChange"
                   page_name="reply">

        </add-media>
      </div>

      <div v-if="loading">

        <custom-loader :size="60" :duration="4000"></custom-loader>
      </div>
    </div>

    <div class="card-footer">

      <div class="btn-group">

        <button type="button" class="btn btn-primary" :class="{'right-margin-0': lang_locale !== 'ar', 'border-line-left': lang_locale === 'ar'}" @click="onSubmit('sendReply')" :disabled="isDisabled">
          <i class="fas fa-sync-alt"> </i> {{trans('send_reply')}}
        </button>

        <button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split border-line-left" :class="{'right-margin-0 border-line-left': lang_locale === 'ar'}" :disabled="isDisabled" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only"></span>
        </button>

        <div class="dropdown-menu min-content-width">

          <a class="dropdown-item" v-for="status in statusList" data-test-id="submit-button" @click="onStatusSubmit(status)" href="javascript:;" v-tooltip="lang('send_and_set_status_as') + ' ' + status.name">
            <i :style="{color: status.icon_color}" :class="status.icon"> </i>  {{lang('send_and_set_status_as') + ' ' + subString(status.name, 8) }}
          </a>

        </div>
      </div>
    </div>
  </div>
</template>

<script>

import axios from 'axios'

import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";

import { validateReplySettings } from "../../../../../../../helpers/validator/replyRules";

import {useStore} from 'vuex';
import {computed} from "vue";
import AddMedia from "../../../../../../MiniComponent/FormField/AddMedia.vue";
import TimeField from "../../../../../../MiniComponent/FormField/TimeField.vue";
import DynamicSelect from "../../../../../../MiniComponent/FormField/DynamicSelect.vue";
import {getSubStringValue} from "../../../../../../../helpers/extraLogics";

export default {

  name : 'inbox-reply',

  description : 'Inbox Reply Component',

  setup() {

    const store = useStore();

    return {

      getTicketActions : computed(()=>store.getters.getTicketActions)
    }
  },

  props : {

    id : { type : [String, Number], default : '' },

    user : { type : Object, default : () => {} },

    ticket : { type : Object, default : () => {} },

    ccArray : { type : [Array, String], default : () => [] },

    updateThreads : { type : Function }
  },

  data() {

    return {

      type:'reply',

      worktime:0,

      worktime_type: '',

      reply : '',

      to : this.user,

      cc : this.ccArray,

      response : '',

      attachments : [],

      inline : [],

      isDisabled : false,

      loading : false,

      formStyle : { width:'40%' },

      fieldLoader : false,

      replyZindex : false,

      resetCC : 0,

      showCanned : false,

      rules : '',

      panel : 'agent',

      notify_department : [],

      notify_agent : [],

      notify_team : [],

      statusList: '',

      lang_locale: ''
    }
  },

  beforeMount() {

    this.lang_locale = this.appLanguage;
  },

  watch : {

    user(newValue,oldValue){

      this.to = newValue;
    }
  },

  created() {

    this.getStatusList();

    window.emitter.on('updateContent', this.updateReply)

    window.emitter.on('fileModal',this.getModal)

    window.emitter.on('changeStatusAndReply',this.onSubmit);
  },

  methods : {

	  subString(value,length = 15){

		  return getSubStringValue(value,length)
	  },

    displaySupportSession() {
      window.emitter.emit('support-session-renderer',{'ticket' :this.ticket});
    },

    displayRedaction() {
      window.emitter.emit('redaction-box-mounted',{'ticket' :this.ticket});
    },

    toggleCanned() {

      this.showCanned = !this.showCanned;
    },

    getModal(value) {

      this.replyZindex = value;
    },

    updateReply(thread) {

      this.reply = thread.content;

      document.body.classList.remove('overflow-hidden');
    },

    isMail(element, index, array) {

      var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,20}$/;

      return emailPattern.test(element.email ? element.email : element.name);
    },

    onChange(value, name){

      this[name]= value;

      if(name == 'cc') {

        if(value.length) {

          this.rules = value.every(this.isMail) ? '' : 'email'

        } else {

          this.rules = '';
        }

      }

      if(name == 'response') {

        if(value){

          axios.get('/get-canned-response-message/'+value.id + '/' +this.id).then(res=>{

            this.reply = res.data.data.message + this.reply.replace("<p id='extra_p'>&nbsp;</p>",'');

            this.attachments = res.data.data.attachments;

          }).catch(err=>{

            this.reply = '';

            this.attachments = [];
          })
        } else {

          this.reply = '';

          this.attachments = [];
        }
      }
    },

    isValid() {

      const { errors, isValid } = validateReplySettings(this.$data);

      if (!isValid) {

        return false;
      }
      return true;
    },

    getAttachments(files){

      this.attachments = files;
    },

    getInlineImages(files){

      this.inline = files;
    },

    onSubmit(from) {
      this.worktime_type = this.worktime_type || '';
      if(this.isValid())  {

        this.loading = true;

        this.isDisabled= true;

        if(this.worktime != 0) {

          this.saveTimeTrack();
        }

        this.addInlineStyles();

        this.getNotifyIds();


        const obj = {};

        obj['content'] = this.reply;

        obj['attachment']=this.attachments;

        obj['ticket_id']=this.id;

        obj['to'] = [this.to.id];

        if(this.cc.length > 0){

          obj['cc'] = this.cc.map(user => {

            if(user.hasOwnProperty('email') && user.email){

              return user.email;
            }
            return user.name;
          });
        } else {
          obj['cc'] = []
        }

        obj['notify_department'] = this.notify_department.length ? this.notify_department.toString() : '';
        obj['notify_team'] = this.notify_team.length ? this.notify_team.toString() : '';
        obj['notify_agent'] = this.notify_agent.length ? this.notify_agent.toString() : '';

        axios.post("api/thread/reply/"+this.id,obj).then(res=>{

          this.initialState();

          if(from === 'sendReply') {
            successHandler(res,'timeline');
          }

            window.emitter.emit('refreshTableAndData',true);

            this.updateThreads('reply');

            if(from === 'statusChange' || from === 'sendReply') {
              window.emitter.emit('closeReplyBox');
            }

            this.resetCC += 1;

        }).catch(err=>{

          this.loading = false;

          this.isDisabled= false;

          errorHandler(err,'timeline')
        })
      }
    },

    initialState(){

      this.loading = false;

      this.isDisabled= false;

      this.reply = '';

      this.to = this.ticket.user;

      this.attachments = []

      this.response = ''

      this.worktime = 0;

      this.fieldLoader = true;

      setTimeout(()=>{

        this.fieldLoader = false;
      },1)
    },

    saveTimeTrack() {

      const data = {};

      data['work_time'] = this.worktime;

      data['entrypoint'] = 'reply';

      if(this.worktime_type) {
        data['worktime_type'] = this.worktime_type.id;
      }
      axios.post('ticket/'+this.id+'/time-track',data).then(res=>{

        this.worktime = 0;
        this.worktime_type = '';
        window.emitter.emit('refreshTimeTrack')

      }).catch(err=>{

        this.worktime = 0;
        this.worktime_type = '';
      })
    },

    getNotifyIds() {

      var parser = new DOMParser();

      var doc = parser.parseFromString(this.reply, 'text/html');

      const root = doc.getElementsByTagName('body')[0];

      const elements = root.querySelectorAll('[title="mention_link"]');

      elements.forEach(anchor => {

        let anchorArr = anchor.href.replace(this.basePath(),'').split('/');

        let modifiedArr = anchorArr.filter(item => item);

        if(modifiedArr[modifiedArr.length - 2] == 'user') {

          this.notify_agent.push(modifiedArr[modifiedArr.length - 1]);
        }

        if(modifiedArr[modifiedArr.length - 2] == 'department') {

          this.notify_department.push(modifiedArr[modifiedArr.length - 1]);
        }

        if(modifiedArr[modifiedArr.length - 2] == 'team') {

          this.notify_team.push(modifiedArr[modifiedArr.length - 1]);
        }
      })
    },

    addInlineStyles() {

      this.reply = this.reply
          // Handle td tags: Add default padding if not present
          .replace(/<td([^>]*)>/g, (match, attributes) => {
            const hasStyle = /style\s*=\s*["']([^"']*)["']/.test(attributes);
            const hasPadding = /padding\s*:\s*[^;]+/.test(attributes);

            if (!hasStyle) {
              return `<td${attributes} style="padding: 6.4px;">`;
            }

            if (!hasPadding) {
              return match.replace(/style\s*=\s*["']([^"']*)["']/, (styleMatch, styleContent) => {
                return `style="${styleContent} padding: 6.4px;"`;
              });
            }

            return match; // If padding exists, do nothing
          })

          // Handle table tags: Add default styles if missing
          .replace(/<table([^>]*)>/g, (match, attributes) => {
            const hasStyle = /style\s*=\s*["']([^"']*)["']/.test(attributes);
            const hasBorder = /border\s*=\s*["']([^"']*)["']/.test(attributes);

            if (!hasStyle) {
              return `<table${attributes} style="border-collapse: collapse;" ${!hasBorder ? 'border="1"' : ''}>`;
            }

            return match.replace(/style\s*=\s*["']([^"']*)["']/, (styleMatch, styleContent) => {
              return `style="${styleContent} border-collapse: collapse;" ${!hasBorder ? 'border="1"' : ''}`;
            });
          });


    },

    getStatusList(){

      this.statusList = '';

      this.loading = true;

      const ticketId = [];

      ticketId.push(this.id)

      let params = {meta: true, supplements: ticketId, limit: 'all'}

      axios.get('/api/dependency/statuses',{params}).then(res =>{

        this.loading  = false

        this.statusList=res.data.data.statuses;

      }).catch(err=>{

        this.loading  = false
      })
    },

    onStatusSubmit(status){

      if(this.isValid()) {

        // Set loading and disable state to true to prevent multiple submissions
        this.loading = true;

        this.isDisabled = true;

        const uniqueKey = Date.now().toString(); // Generate a unique key based on the current timestamp

        // Make an API call to change the ticket status
        axios.post('/ticket/change-status/'+this.id+'/'+status.id,
            {
              'comment': '', // Include the comment value
              'as-reply': false, // Include the reply status
              'uniqueKey': uniqueKey // Pass the unique key to the backend to prevent duplicate submissions
            }).then(res=>{

          // Handle success response
          successHandler(res, 'timeline');

          // On success, call Submit reply api
          this.onSubmit('statusChange');

        }).catch(err => {

          // On error, reset loading and disable state
          this.loading = false;

          this.isDisabled = false;

          // if we have added condition to have some required field in form builder ( for e.g, required for closure )
          if(err.response.status === 302){

            window.emitter.emit('closeReplyBox');

            //This event is listen in TimelineDetails component and opens edit ticket modal
            window.emitter.emit('showEditTicketModaltimeline', 'inboxReply');

            this.$store.dispatch('setAlert', {
              type: 'danger',
              message: err.response.data.message,
              component_name: 'faveo-form'
            })
          }else{
            window.emitter.emit('closeReplyBox');
            // Handle general error response
            errorHandler(err,'timeline');
          }
        })
      }
    },
  },

  components : {

    "add-media": AddMedia,

    'time-field': TimeField,

    "dynamic-select": DynamicSelect
  }
};
</script>

<style scoped>

.load_margin { margin-top: 30px;margin-bottom: 30px; }

.border-line-left { border-left:1px solid #1f6187 }

.right-margin-0 { margin-right: 0!important; }

.min-content-width { max-width: 250px; max-height: 250px; overflow: auto; }

</style>

<style>

.cc_field div.error-block { display: none !important; }
</style>