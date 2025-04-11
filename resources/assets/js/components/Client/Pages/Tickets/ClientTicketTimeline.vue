<template>

  <div>

    <meta-component :dynamic_title="lang('check-ticket-title')"
                    :dynamic_description="lang('check-ticket-description')" :layout="layout">

    </meta-component>

    <div v-if="pageChange || loading" class="row" style="margin-top:30px;margin-bottom:30px">

      <loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
    </div>

    <alert componentName="statusBox"/>

    <div class="row" v-if="hasDataPopulated">

      <div id="content" class="site-content col-sm-12">

        <article class="hentry">

          <header class="row">

            <div class="col-sm-7">

              <h3 class="entry-title" :title="TicketDetail.title" :class="{align1: lang_locale == 'ar'}">
                <i class="fas fa-ticket"> </i>
                {{ subString(TicketDetail.title) }}

                <small>( {{ TicketDetail.ticket_number }} )</small>

              </h3>
            </div>

            <div class="col-sm-5">

              <div :class="{left: lang_locale == 'ar'}" class="float-end status">

                <div class="btn-group" id="ticket-sort">

                  <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-bs-toggle="dropdown">
	                  <i class="fas fa-sort"></i> {{trans('sort')}}
	                  <span class="caret"></span>
                  </button>

                  <div class="dropdown-menu dropdown-class dropdown-menu-left">

                    <a class="dropdown-item" :class="{'bg-gray': this.sort_order === 'ASC'}" @click="conversationSort('ASC')" href="javascript:;">
                      <i class="fas fa-sort-amount-down"></i>
                      {{ trans('created_date') + ' ' + trans('ascending') }}
                      <i v-if="this.sort_order === 'ASC'" class="fas fa-check"></i>
                    </a>

                    <a class="dropdown-item" :class="{'bg-gray': this.sort_order === 'DESC'}" @click="conversationSort('DESC')" href="javascript:;">
                      <i class="fas fa-sort-amount-up"></i>
                      {{ trans('created_date') + ' ' + trans('descending') }}
                      <i v-if="this.sort_order === 'DESC'" class="fas fa-check"></i>
                    </a>

                  </div>
                </div>

                <template v-if="status_type != 'Unapproved'">

                  <ticket-status v-if="tic_status == 1" :status_type="status_type"
                                 :layout="layout" :updateStatus="updateStatus" :ticketIds="selected">

                  </ticket-status>
                </template>

                <template
                    v-if="ticketData && ticketData.custom_field_values && ticketData.custom_field_values.length > 0">

                  <button class="btn btn-light btn-sm" @click="toggleData">

                    <template v-if="!dataOpen">
                      <i class="fas fa-eye"></i> {{ trans('view_custom_field_details') }}
                    </template>

                    <template v-else>
                      <i class="fas fa-eye-slash"></i> {{ trans('hide_custom_field_details') }}
                    </template>

                  </button>
                </template>
              </div>
            </div>
          </header>

          <div class="clearfix">

            <div class="entry-attribute clearfix" id="rate_entry" v-if="status_type != 'Unapproved'">

              <div class="row">

                <div class="share-links col-sm-6"></div>

                <div class="rate-post col-sm-6" :class="[(lang_locale === 'ar') ? 'text-start' : 'text-end']">

                  <rating-component v-if="rateDispatched" :layout="layout"
                                    :auth="auth" :department="TicketDetail.department" :ticketId="ticket_Id"
                                    area="Helpdesk Area">
                  </rating-component>

                  <div v-else class="row">

                    <loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="30"/>
                  </div>

                </div>
              </div>
            </div>

            <ticket-details v-if="ticketData" :ticket="ticketData" :layout="layout" :auth="auth"></ticket-details>

            <div v-if="dataOpen" class="data_cus_cls">

              <custom-ticket-details v-if="ticketData" :ticket="ticketData" :layout="layout"
                                     :auth="auth"></custom-ticket-details>
            </div>

            <div id="comments" class="comments-area" :class="{align1: lang_locale == 'ar'}">

              <ol class="comment-list">

                <ticket-thread :userId="user_id" v-for="comments in comments_list" :key="comments.id"
                               :comments="comments"
                               :layout="layout" :auth="auth" :dept="TicketDetail.department" :status_type="status_type">

                </ticket-thread>
              </ol>

              <div class="row">

                <div :class="{left: lang_locale == 'ar'}" class="col-sm-12 text-end" v-if="records > 10">

                  <uib-pagination :records="records" v-model="pagination" class="pagination" @paginate="changePage"
                                  :boundary-links="true" :per-page="perpage"
                                  :options="{chunk:3, chunksNavigation:'scroll'}">

                  </uib-pagination>
                </div>
              </div>

              <template v-if="status_type != 'Unapproved'">

                <alert componentName="replyBox"></alert>

                <div v-if="showEditor==1">

									<button v-if="!openReply" class="btn btn-reply btn-custom btn_font_color btn-150 float-end" @click="toggleReply">

                    <i class="fas fa-reply"></i> {{ lang('reply') }}
                  </button>

                  <div v-if="openReply" id="reply_threads" class="comment-respond form-border">

                    <h3 class="comment-reply-title section-title reply_title" id="H3">

                      <i class="line" :class="{left0 : lang_locale == 'ar'}"
                         :style="lineStyle"></i>{{ lang('leave_a_reply') }}

                      <span style="color:red"> *</span>

                      <button class="btn btn-light btn-sm float-end ms-1" @click="toggleReply"
                              v-tooltip="lang('close')">
                        <i class="fas fa-times"></i>
                      </button>
                      <button class="btn btn-light btn-sm float-end" @click="toggleCC">{{ lang('cc') }}</button>
                      <div id="redaction-view" class="redactText">{{ displayclientRedaction() }}</div>

                    </h3>
                    <form method="POST" action="" accept-charset="UTF-8" id="client-reply" class="cc_div"
                          :class="hideAction ? 'remove_action' : '' ">

                      <dynamic-select v-if="showCC" :label="lang('cc')" :multiple="true" name="cc" :value="cc"
                                      :onChange="onChange" :clearable="hideAction ? false : true"
                                      classname="col-sm-12 pad_0 cc_field" :taggable="true"
                                      :placeholder="lang('enter_email_addresses')" :labelStyle="labelStyle"
                                      :rules="rules" :key="resetCC">

                      </dynamic-select>

                      <tiny-editor :value="reply" type="text" :onChange="onChange" name="reply" :label="lang('reply')"
                                   :required="true" :lang="lang_locale" :labelStyle="labelStyle" id="focus_editor">

                      </tiny-editor>

                      <br>

                      <span id="fileselector">

												<input ref="fileInput" multiple type="file" @change="onFileSelected" style="display:none">

												<div v-if="files.length>0">

													<div v-for="(file,index) in files">

														<li id="list">{{ file.name }}

															<i id="close_attach" class="fa fa-times" @click="removeFile(index)"></i>

														</li>
													</div>
												</div>

												<button id="btun" type="button" class="btn btn-custom" @click="$refs.fileInput.click()"
                                :style="buttonStyle">
													{{ lang('attach files') }}

												</button>

												<i> {{ lang(str) }}</i>
											</span>

                      <div :class="{rem: lang_locale == 'ar'}" class="text-end">

                        <button type="button" @click="verify" class="btn btn-custom btn-lg" :style="buttonStyle"
                                :disabled="disableButton" id="client_timeline_reply">

                          <i class="fa fa-reply-all"></i>&nbsp;{{ lang(btnName) }}
                        </button>
                      </div>
                    </form>
                  </div>
                </div>
              </template>

              <template v-if="getApprovalActionVisibility">

                <div class="row" id="approval-act-form" :class="{align1: lang_locale == 'ar'}" v-focus-first-input>

                  <text-field id="approval_con_comment" :input-style="inputStyle" :label="lang('comment')"
                              :value="approval_con_comment" type="textarea"
                              name="approval_con_comment"
                              :onChange="onChange" classname="col-sm-12" :required="true">

                  </text-field>

                  <div class="form-group col-md-12">

                    <button id="approval_con_approve" @click="onApproveDeny('approve')" class="btn btn-success"
                            :disabled="isDisabled">

                      <span class="fa fa-check"></span> {{ lang('approve') }}
                    </button>

                    <button id="approval_con_deny" @click="onApproveDeny('deny')" class="btn btn-secondary"
                            :disabled="isDisabled">

                      <span class="fa fa-times"></span> {{ lang('deny') }}
                    </button>
                  </div>
                </div>
              </template>
            </div>
          </div>
        </article>
      </div>
    </div>
    <div v-if="loading+hasDataPopulated==0">
      <h3 style="text-align:center">{{ lang('no-data-to-show') }}</h3>
    </div>
  </div>
</template>

<script>

import axios from 'axios'

import {mapGetters} from 'vuex'

import {findObjectByKey, getSubStringValue} from '../../../../helpers/extraLogics'

import {errorHandler, successHandler} from '../../../../helpers/responseHandler';

import {validateReplySettings} from "../../../../helpers/validator/replyRules";

import {validateApprovalTicSettings} from "../../../../helpers/validator/approvalTicRules";

import ChangeStatus from './MiniComponents/ChangeStatus.vue';

import ClientPanelTimelineRatings from './MiniComponents/ClientPanelTimelineRatings.vue';

import ThreadsList from './MiniComponents/ThreadsList.vue';

import TicketDetails from './MiniComponents/TicketDetails.vue';

import CustomTicketDetails from './MiniComponents/CustomTicketDetails.vue';

import Loader from '../../../../components/Client/ClientPanelLayoutComponents/ReusableComponents/Loader.vue';

import Alert from '../../../../components/MiniComponent/Alert.vue';

import DynamicSelect from '../../../../components/MiniComponent/FormField/DynamicSelect.vue';

import TextField from '../../../../components/MiniComponent/FormField/TextField.vue';
import Modal from "../../../Common/Modal.vue";
import Checkbox from "../../../MiniComponent/FormField/Checkbox.vue";
import * as openpgp from "openpgp";
import CryptoJS from "crypto-js";

export default {

  name: 'client-ticket-timeline',

  description: 'Client panel ticket timeline page',

  props: {

    layout: {
      type: Object, default: () => {
      }
    },

    auth: {
      type: Object, default: () => {
      }
    }
  },

  components: {
    Checkbox, Modal,

    'ticket-status': ChangeStatus,

    'rating-component': ClientPanelTimelineRatings,

    'ticket-thread': ThreadsList,

    'ticket-details': TicketDetails,

    'custom-ticket-details': CustomTicketDetails,

    'client-panel-loader': Loader,

    'alert': Alert,

    'dynamic-select': DynamicSelect,

    'text-field': TextField,
  },

  data() {

    return {

      reply: '',

      cc: [],

      labelStyle: {display: 'none'},

      tic_status: this.layout.user_set_ticket_status.status,

      buttonStyle: {

					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				inputStyle : { borderColor : this.layout.portal.client_input_field_color},

				lineStyle : { borderColor : this.layout.portal.client_header_color},

				str:'',

				loading : true,

				perpage:10,

				pagination:1,

				records:0,

				TicketDetail:'',

				ticketData :'',

				comments_list:[],

				ticket_Id:'',

				selectedFile:[],

				files:[],

				url:'',

				btnName:'reply',

				disableButton: false,

				status_type:'',

				AreaRatings : '',

				showEditor:'',

				max_size:0,

				file_size:0,

				max_file:0,

				user_id : this.auth.user_data.id,

				tic_user_id:null,

				check_id:null,

				paramsObj:{},

				base : this.auth.system_url,

				lang_locale : this.layout.language,

				pageChange : false,

				actionPerformed : 'initialLoad',

				selected : [],

				hasDataPopulated: false,

				showCC : false,

				openReply : false,

				approval_con_comment : '',

				isDisabled : false,

				dataOpen : false,

				rateDispatched : false,

				panel : 'client',

				rules : '',

				resetCC : 0,

        hideAction : false,

        modalType: '',

        showModal: false,

        modalText: '',

        selectedDuration:3600,

        message: '',

        encryptedMessage: '',

        decryptedMessage: '',

        publicKey: '',

        privateKey: '',

        getId:null,

        passphrase: 'your-passphrase',

        sendOneTimeDownload:true,

        checkboxOptions: [
          { label: 'True', value: true },
          { label: 'False', value: false }
        ],
        encrptedPrivatekey:'',

        imageFile: null,

        encryptedImage: '',

        fileName:'',

        sort_order: ''
			}
		},

		async created() {

			this.path=location.pathname.split('/');

			this.check_id=this.path[this.path.length-1];

			this.paramsObj['page']=this.pagination;

			this.checkTicketId(this.paramsObj);

      const { publicKey, privateKey } = await this.generateKeys();
      this.publicKey = publicKey;
      this.privateKey = privateKey;
      const password = "my-password";
      this.encrptedPrivatekey = CryptoJS.AES.encrypt(this.privateKey, password).toString()
      const bytes = CryptoJS.AES.decrypt(this.encrptedPrivatekey , password);
      bytes.toString(CryptoJS.enc.Utf8);
		},

		filters : {

			toUp(value){

				return value.toUpperCase();
			},
		},

		computed: {

			...mapGetters(['formattedTime','formattedDate', 'getApprovalActionVisibility', 'getDefaultRatings'])
		},

		methods : {

    openModal(type) {
        this.modalType = type; // Set the modal type
        this.showModal = true;
    },

    toggleData() {

      this.dataOpen = !this.dataOpen;
    },

    onApproveDeny(url) {

      if (this.isApproveValid()) {

        this.pageChange = true;

        this.$Progress.start();

        this.isDisabled = true

        axios.post('/api/approval-action-without-hash/' + this.TicketDetail.id, {
          action_type: url,
          comment: this.approval_con_comment
        }).then(res => {

          successHandler(res, 'statusBox');

          this.isDisabled = false;

          this.comment = '';

          this.pagination = 1;

          this.paramsObj['page'] = this.pagination;

          this.checkTicketId(this.paramsObj);

          successHandler(res, 'statusBox');

          this.$Progress.finish();

        }).catch(err => {

          this.isDisabled = false

          this.pageChange = false;

          this.$Progress.fail();

          errorHandler(error, 'statusBox')
        })
      }
    },

    isApproveValid() {

      const {errors, isValid} = validateApprovalTicSettings(this.$data)

      if (!isValid) {

        return false
      }
      return true
    },

    toggleCC() {

      this.showCC = !this.showCC;
    },

    toggleReply() {

      this.openReply = !this.openReply;
    },

    isMail(element, index, array) {

      var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,20}$/;

      return emailPattern.test(element.email ? element.email : element.name);
    },

    onChange(value, name) {

      this[name] = value;

      if (name == 'cc') {

        if (value.length) {

          this.rules = value.every(this.isMail) ? '' : 'email'

        } else {

          this.rules = '';
        }

      }
    },

    checkTicketId(x, from) {

      this.$Progress.start();

      this.pageChange = true;

      let params = {};

      if(from === 'sort') {
        params['sort_order'] = this.sort_order;
      }

      params['page'] = x.page

      axios.get('api/check-ticket/' + this.check_id, {params}).then(response => {

        if (x.page === 1) {

          this.ticketData = response.data.data.ticket;
        }

        if(from === 'sort') {
          this.pagination = 1;
        }

        this.loading = false;

        this.hasDataPopulated = true;

        this.pageChange = false;

        this.$Progress.finish();

        this.fileUploadRules(response.data.data);

        this.TicketDetail = response.data.data.ticket;

        this.tic_user_id = this.TicketDetail.user.id;

        this.sort_order = this.TicketDetail.sort_order

        this.ticket_Id = this.TicketDetail.id;

        this.$store.dispatch('updateTicketActions', this.ticket_Id);

        this.selected.push(this.ticket_Id)

        this.status_type = this.TicketDetail.status;

        this.AreaRatings = this.TicketDetail.ratings;

        this.comments_list = this.TicketDetail.threads;

        this.records = this.TicketDetail.strictly_thread_count;

        this.cc = this.TicketDetail.collaborators;

        this.$store.dispatch('setRatingTypes', this.ticket_Id);

        setTimeout(() => {

          this.rateDispatched = true;
        }, 1500);

        // for(var i in this.TicketDetail.collaborators){
        // 	if(this.TicketDetail.collaborators.hasOwnProperty(i) && this.auth.user_data.id != this.TicketDetail.collaborators[i].id){
        //
        // 		this.cc.push({ id : this.TicketDetail.collaborators[i].id, name : this.TicketDetail.collaborators[i].email})
        // 	}
        // }

        this.url = 'rating/'

        if (this.tic_user_id == this.user_id || this.layout.organization != undefined) {

          this.showEditor = response.data.data.replybutton === 1 ? 1 : 0;
        } else {

          if (response.data.data.replybutton === 1) {

            this.showEditor = response.data.data.org_member_reply;
          } else {

            this.showEditor = 0;
          }
        }

        if (this.tic_user_id !== this.user_id && this.auth.user_data.role === 'user') {

          this.hideAction = true;

          this.injectDynamicCSS();
        }
      }).catch(error => {

        this.loading = false;
        this.pageChange = false;
        this.hasDataPopulated = false;
        this.$Progress.fail();
        errorHandler(error, 'statusBox');
      })
    },

    fileUploadRules(data) {

      this.max_size = data.uploadfilesize;

      this.file_size = data.uploadSingleFileSize;

      this.max_file = data.uploadFilecount;

      this.str = this.lang('max_upload_size') + this.formatBytes(this.max_size);
    },

    onFileSelected(event) {

      var element = this.$refs.fileInput;

      this.selectedFile = event.target.files;

      for (var i = 0; i < this.selectedFile.length; i++) {

        if (this.selectedFile[0].size < this.file_size) {

          if (this.files.length < this.max_file) {

            this.files.push(this.selectedFile[i]);
          } else {

            this.$store.dispatch('setAlert', {
              type: 'danger',
              message: this.lang('client_max_number_of_files') + this.max_file,
              component_name: 'replyBox'
            });
          }
        } else {

          this.$store.dispatch('setAlert', {
            type: 'danger',
            message: this.lang('upload_failed') + this.formatBytes(this.file_size),
            component_name: 'replyBox'
          });
        }
      }
      element.value = "";
    },

    formatBytes(bytes, decimals) {

      if (bytes == 0) return '0 Bytes';

      var k = 1024,

          dm = decimals || 2,

          sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],

          i = Math.floor(Math.log(bytes) / Math.log(k));

      return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    },

    removeFile(i) {

      this.files.splice(i, 1);
    },

    changePage() {

      this.actionPerformed = 'pageChange';

      var elmnt = document.getElementById('comments');

      elmnt.scrollIntoView({behavior: "smooth"});

      this.$Progress.start();

      this.pageChange = true;

      this.paramsObj['page'] = this.pagination;

      this.checkTicketId(this.paramsObj);
    },

      conversationSort (val) {

        if(val === 'ASC') {
          this.sort_order = 'ASC'
          this.checkTicketId({page:1}, 'sort');
        } else {
          this.sort_order = 'DESC'
          this.checkTicketId({page: 1}, 'sort');
        }
      },

    updateStatus(status) {

      this.pageChange = true;

      this.$Progress.start();

      const data = {}

      data['panel'] = this.panel;

      axios.post('api/ticket/change-status/' + this.TicketDetail.id + '/' + status.id, data).then(res => {

        this.actionPerformed = 'statusChange';

        this.pagination = 1;

        this.paramsObj['page'] = this.pagination;

        this.checkTicketId(this.paramsObj);

        successHandler(res, 'statusBox');

        this.$Progress.finish();

      }).catch(error => {

        this.pageChange = false;

        this.$Progress.fail();

        errorHandler(error, 'statusBox')
      })
    },

    verify() {

      if (this.files.length > 0) {

        var fileArr = this.files.map(a => a.size);

        const totalSize = fileArr.reduce((accumulator, currentValue) => accumulator + currentValue);

        if (totalSize < this.max_size) {

          this.postTicketComment();
        } else {

          this.loading = false;
          this.$store.dispatch('setAlert', {
            type: 'danger',
            message: this.trans('max_upload_size') + this.formatBytes(this.max_size),
            component_name: 'statusBox'
          });
        }

      } else {

        this.postTicketComment();
      }
    },

    isValid() {

      const {errors, isValid} = validateReplySettings(this.$data);

      if (!isValid) {

        return false;
      }

      return true;
    },

    postTicketComment() {

      if (this.isValid()) {

        this.$Progress.start();

        this.disableButton = true;

        var fd = new FormData();

        if (this.cc.length > 0) {

          this.cc.forEach((user, i) => {

            fd.append('cc[' + i + ']', user.hasOwnProperty('email') && user.email ? user.email : user.name);

          });
        } else {
          fd.append('cc', []);
        }

        fd.append('content', this.reply);

        for (var i in this.files) {

          fd.append('attachment[' + i + ']', this.files[i]);
        }

        const config = {headers: {'Content-Type': 'multipart/form-data'}};

        axios.post('api/thread/reply/' + this.ticket_Id, fd, config).then(res => {

          this.reply = '';

          this.disableButton = false;

          this.checkTicketId(this.paramsObj)

          var elmnt = document.getElementById('reply_threads');

          elmnt.scrollIntoView({behavior: "smooth"});

          this.$store.dispatch('setAlert', {
            type: 'success',
            message: 'Successfully replied', component_name: 'replyBox'
          });

          this.files = [];

          this.$Progress.finish();

          window.emitter.emit('refreshThreads');

          // this.cc =[];

          this.resetCC += 1;

        }).catch(error => {

          if (error.response && error.response.data.message['attachment']) {

            this.$store.dispatch('setAlert', {
              type: 'danger',
              message: error.response.data.message['attachment'],
              component_name: 'replyBox'
            })
          }

          errorHandler(error, 'replyBox');

          this.pageChange = false;

          this.disableButton = false;

          this.$Progress.fail();
        });
      }
    },

    subString(value) {

      return getSubStringValue(value, 15)
    },
    displayclientRedaction() {
      window.emitter.emit('redaction-box-mounted', {'ticket': this.TicketDetail});
    },

    injectDynamicCSS() {
      // Generate the CSS selector dynamically based on the 'name' property of each item in 'cc'
      const dynamicSelector = this.cc.map(item => `.remove_action .v-select .vs__dropdown-toggle .vs__selected-options .vs__deselect[title="Deselect ${item.name}"]`).join(', ');

      // Construct the CSS rule with the dynamically generated selector
      const dynamicCSS = `${dynamicSelector} { display: none; }`;

      // Create a style element and inject the dynamic CSS rule into it
      const styleElement = document.createElement('style');
      styleElement.textContent = dynamicCSS;

      // Append the style element to the component's head
      document.head.appendChild(styleElement);
    }
  },
};
</script>
<style scoped>

.status {
  margin-top: -5px;
  margin-bottom: 5px;
}

.rate-post {
  margin-top: -0.5rem !important;
}

#rate_entry {
  margin-bottom: 1.5em !important;
  border-bottom: 0px solid #eee !important;
  line-height: 2.35em;
}

#time_reply {
  margin-top: 0.5rem !important;
}

#close_attach {
  cursor: pointer;
  float: right;
  margin-top: 3px;
}

#list {
  list-style-type: none;
  background-color: #f5f5f5;
  border: 1px solid #dcdcdc;
  font-weight: 700;
  margin: 8px 8px 8px 0;
  overflow-y: hidden;
  padding: 4px 4px 4px 8px;
  max-width: 448px;
}

.pad_0 {
  padding: 0px !important;
}

.reply_title {
  margin-bottom: 0.5em !important;
}

.data_cus_cls {
  height: 300px;
  overflow-y: auto;
  overflow-x: hidden;
}

.btn-150 {
  width: 150px;
}


.btn-reply {
  float: right;
  width: auto;
}

  .btn_font_color{
    border-color: rgb(0, 192, 239);
    color: rgb(255, 255, 255) !important;
    background-color: rgb(0, 154, 186);
  }
  .redactText{
    margin-top: -4px!important;
  }
  .dropdown-class{
    width: fit-content;
  }

</style>

<style>
.pad_0 .dynamic-select {
  background: white !important;
}

.client_timeline .tox {
  height: 250px !important;
  width: 104% !important;
}

.cc_field div.error-block {
  display: none !important;
}
#redaction-view{
  float: right;
}
</style>
