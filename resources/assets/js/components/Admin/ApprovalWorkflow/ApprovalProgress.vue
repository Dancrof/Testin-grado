<template>

  <div class="card card-light">

    <div class="card-header pointer" @click="toggleCard">

      <h3 class="card-title">{{ lang('approval_progress') }}</h3>

      <div class="card-tools">

        <button v-if="loading && cardOpen" type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

          <i class="fas fa-sync-alt"></i>
        </button>

        <button type="button" class="btn btn-tool">

          <i :class="{'fas fa-angle-up' : cardOpen, 'fas fa-angle-down' : !cardOpen, }" class="fs-25"></i>
        </button>
      </div>
    </div>

    <div v-if="cardOpen" class="card-body">

      <div id="approval-progress" class="appproval">

        <div v-if="!loading" id="approval-progress">

          <div class="card" v-for="(workflow, workflowIndex) in workflowData" :key="'workflow'+workflowIndex"
               :id="'approval-progress-element-'+workflowIndex"
               :style="{'border-color': getIconStyle(workflow.status,'color')}">
            <div class="card-header" :style="{'background-color': getIconStyle(workflow.status,'color')}">
              <h3 class="card-title">{{ workflow.name }}</h3>
              <div class="card-tools approval-tools">
                <template v-if="workflow.status=='PENDING'">

                  <button v-if="!workflow.send_auto_reminders" class="btn btn-tool" v-tooltip="trans('resume_reminder')"
                          @click="resumeReminder(workflow.id)">

                    <i class="fas fa-play"></i>
                  </button>

                  <button v-if="workflow.send_auto_reminders" class="btn btn-tool" v-tooltip="trans('stop_reminder')"
                          @click="stopReminder(workflow.id)">

                    <i class="fas fa-stop"></i>
                  </button>
                </template>
                <button v-tooltip="workflow.status" class="btn btn-tool"
                        :class="getIconStyle(workflow.status)"></button>
              </div>
            </div>
            <!--  levels -->
            <div class="card-body">
              <div class="levels">
                <div class="approval-level" v-for="(level,levelIndex) in workflow.approval_levels"
                     :id="'approval-level-'+levelIndex" :style="{opacity : getOpacity(level.is_active)}">
                  <div class="card " :style="{'border-color': getIconStyle(level.status,'color')}">
                    <div class="card-header" :style="{'background-color': getIconStyle(level.status,'color')}">
                      <h3 class="card-title ms-2">
                        {{ level.name }}
                      </h3>

                      <div class="card-tools toolsKit">
                        <div v-if="level.status=='PENDING'">
                          <button v-if="level.is_active" class="btn btn-tool p-0" v-tooltip="trans('send_reminder')"
                                  @click="sendReminder('level',level.id)">

                            <i class="fas fa-paper-plane pe-2"></i>
                          </button>


                          <button v-else v-tooltip="trans('cant_send_reminder_level')"
                                  class="btn btn-tool not-cursor p-0">

                            <i class="fas fa-paper-plane pe-2"></i>
                          </button>


                          <button v-if="level.is_active" class="btn btn-tool p-0" v-tooltip="trans('add_approver')"
                                  @click="addRemoveApprover('add',level.id)">

                            <i class="fas fa-plus"></i>
                          </button>


                          <button v-if="!level.is_active" class="btn btn-tool not-cursor p-0"
                                  v-tooltip="trans('you_cant_add_approver')">

                            <i class="fas fa-plus"></i>
                          </button>
                          <button class="btn btn-tool" v-tooltip="level.status"
                                  :class="[getIconStyle(level.status)]"></button>

                        </div>
                      </div>
                    </div>

                    <div class="card-body">
                      <!-- user-approvers -->
                      <div v-for="(user,userIndex) in level.approve_users" :id="'level-user-'+userIndex">
                        <ul class="list-group list-group-unbordered">

                          <li id="highlight" class="list-group-item border-0 p-2p px-2 rounded">

                            <span class="approver-name">{{ user.name }}&nbsp;&nbsp;&nbsp;&nbsp;</span>

                            <span class="float-end">
                          <template v-if="user.status=='PENDING'">


                          <a href="javascript:;" v-if="level.is_active" v-tooltip="trans('send_reminder')"
                             class="text-dark me-3" @click="sendReminder('approver',level.id,user.id)">

                            <i class="fas fa-paper-plane"></i>
                          </a>


                          <a v-else v-tooltip="trans('cant_send_reminder_approver')"
                             class="text-dark me-3 not-cursor">

                            <i class="fas fa-paper-plane"></i>
                          </a>


                          <a v-if="level.is_active"
                             v-tooltip="trans('remove_approver')"
                             class="text-danger me-3" href="javascript:;"
                             @click="addRemoveApprover('remove',level.id,user.id)">

                            <i class="fas fa-times"></i>
                          </a>


                          <a v-if="!level.is_active"
                             v-tooltip="trans('you_cant_remove_approver')"
                             class="text-danger me-3 not-cursor">

                            <i class="fas fa-times"></i>
                          </a>
                        </template>
                              <span v-tooltip="user.status" :class="['approver-status', getIconStyle(user.status)]">

                           </span>
                          </span>
                          </li>
                        </ul>

                      </div>

                      <!-- user-type-approvers -->
                      <div v-for="(userType,userTypeIndex) in level.approve_user_types"
                           :id="'level-user-type-'+userTypeIndex">
                        <ul class="list-group list-group-unbordered">
                          <li id="highlight" class="list-group-item border-0 p-2p px-2 rounded">
                         <span class="approver-name" v-tooltip="lang(userType.name)">
                         {{ subString(lang(userType.name), 25) }}
                            </span>
                            <span class="float-end">

            <template v-if="userType.status=='PENDING'">

             <a v-if="level.is_active" href="javascript:;" v-tooltip="trans('send_reminder')"
                class="text-dark me-3" @click="sendReminder('approver',level.id,userType.id)">

              <i class="fas fa-paper-plane"></i>
             </a>

             <a v-else v-tooltip="trans('cant_send_reminder_approver_type')"
                class="text-dark me-3 not-cursor">

              <i class="fas fa-paper-plane"></i>
             </a>

             <a v-if="level.is_active"
                v-tooltip="trans('remove_approver_type')"
                class="text-danger me-3" href="javascript:;"
                @click="addRemoveApprover('remove',level.id,userType.id)">

              <i class="fas fa-times"></i>
             </a>


             <a v-if="!level.is_active"
                v-tooltip="trans('you_cant_remove_approver_type')"
                class="text-danger me-3 not-cursor">

              <i class="fas fa-times"></i>
             </a>
            </template>
                                 <span v-tooltip="userType.status"
                                       :class="['approver-status', getIconStyle(userType.status)]">

            </span>
                            </span>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-if="!loading" id="approval-workflow-actions">
          <button v-if="shallApprovalActionsBeVisible" class="btn btn-primary" id="approve-button"
                  @click="onWorkflowAction('approve')" name="button">
            <span class="glyphicon glyphicon-ok"></span>&nbsp;{{ lang('approve') }}
          </button>

          <button v-if="shallApprovalActionsBeVisible" class="btn btn-light btn-light" id="deny-button"
                  @click="onWorkflowAction('deny')" name="button">
            <span class="glyphicon glyphicon-remove"></span>&nbsp;{{ lang('deny') }}
          </button>

          <button v-if="actions.remove_approval_workflow" class="btn btn-light" id="remove-button"
                  @click="onWorkflowAction('remove')" name="button">
            <span class="fas fa-trash"></span>&nbsp;{{ lang('remove') }}
          </button>
        </div>


        <!-- confirmation pop-up -->
        <modal v-if="showModal" :showModal="true" :onClose="() => showModal = false">
          <template #title>

            <h4 class="modal-title">{{ lang(modalTitle) }}</h4>
          </template>

          <template #alert>
            <alert/>
          </template>

          <template #fields>

            <reuse-loader v-if="loading"></reuse-loader>

            <span v-if="!loading">{{ lang(modalQuestion) }}</span>

            <div class="row" v-focus-first-input>

              <text-field v-if="!loading && action !== 'remove'" id="textarea" :label="lang('comment')" :value="comment"
                          type="textarea" name="comment"
                          :onChange="onChange" classname="col-sm-12" :required="true"></text-field>
            </div>
          </template>
          <template #controls>
            <button id="approval-action-confirm" type="button" @click="onWorkflowActionConfirm()"
                    class="btn btn-primary">
              <i class="glyphicon glyphicon-ok" aria-hidden="true"></i>&nbsp;{{ lang('confirm') }}
            </button>
          </template>
        </modal>
        <modal v-if="showAddRemoveModal" :showModal="true" :onClose="closeAddModal" :containerStyle="containerStyle">

          <template #title>


            <h4 class="modal-title">{{ addRemoveType === 'add' ? lang('add_approver') : lang('remove_approver') }}</h4>
          </template>


          <template #alert>
            <alert componentName="add_remove_approver"></alert>
          </template>


          <template #fields>

            <reuse-loader v-if="modalLoad"></reuse-loader>


            <div class="row" v-else>


              <dynamic-select v-if="addRemoveType === 'add'" :label="lang('approver')" :value="add_approver"
                              :onChange="onChange"
                              name="add_approver" apiEndpoint="/api/dependency/users?meta=true"
                              :multiple="false" classname="col-md-12" strlength="50" :required="true">


              </dynamic-select>


              <text-field id="textarea" :label="lang('reason')" :value="approver_comment"
                          :autofocus="addRemoveType == 'add' ? false : true"
                          type="textarea" name="approver_comment" :onChange="onChange" classname="col-sm-12"
                          :required="true">

              </text-field>
            </div>
          </template>


          <template #controls>

            <button type="button" @click="onAddRemoveConfirm()" class="btn btn-primary"
                    :disabled="isProceedButtonDisabled">

              <i class="fas fa-check" aria-hidden="true"></i>&nbsp;{{ lang('proceed') }}
            </button>
          </template>
        </modal>
      </div>
    </div>
  </div>
</template>

<script>

import axios from 'axios';

import {computed} from 'vue';
import {useStore} from 'vuex';

import {errorHandler, successHandler} from "../../../helpers/responseHandler";

import {validateApprovalTicketSettings} from "../../../helpers/validator/approvalTicketRules";

import {getQueryParams, getSubStringValue, lang} from '../../../helpers/extraLogics';
import TextField from "../../MiniComponent/FormField/TextField.vue";
import {
  validateCabAddRemoveApproverSettings
} from "../../../../../../app/Plugins/ServiceDesk/views/js/validator/cabAddRemoveApproverRules";
import Modal from "../../Common/Modal.vue";
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";

export default {
  name: 'approval-progress',

  description: 'Handles Approval Progress of a ticket at any given time',

  setup() {

    const store = useStore();

    return {

      // getter
      shallApprovalActionsBeVisible: computed(() => store.getters.getApprovalActionVisibility),
    };
  },

  props: {

    /**
     * If of the ticket for which approval progress is required
     */
    ticketId: {type: [Number, String], required: true},

    actions: {
      type: Object, default: () => {
      }
    },

    alertName: {type: String, default: ''},
  },
  data() {
    return {
      modalLoad: false,

      showAddRemoveModal: false,

      add_approver: '',


      approver_comment: '',


      addRemoveLevelId: '',

      addRemoveType: "",
      /**
       * If the API response is  still pending
       * @type {Boolean}
       */
      loading: false,

      /**
       * array of approval workflow that were/are enforced on the ticket
       * @type {Array}
       */
      workflowData: [],

      /**
       * Comment on the approval
       * @type {String}
       */
      comment: '',

      /**
       * Whether to show confirmation pop-up or not
       * @type {Boolean}
       */
      showModal: false,

      /**
       * It can be
       * @type {String}
       */
      action: '',

      cardOpen: false
    }
  },

  created() {
    window.emitter.on('approvalWorkflowApplied', this.getDataFromServer);
  },

  methods: {

    closeAddModal() {


      this.showAddRemoveModal = false;


      this.approver_comment = '';


      this.$store.dispatch('unsetValidationError');


      this.$store.dispatch('unsetAlert');
    },

    isAddRemoveValid() {

      const {errors, isValid} = validateCabAddRemoveApproverSettings(this.$data)

      return isValid
    },

    onAddRemoveConfirm() {


      if (this.isAddRemoveValid()) {


        this.endPoint = this.addRemoveType === 'add' ? 'add-approver' : 'remove-approver';


        this.modalLoad = true;


        let data = {};


        data['action'] = this.addRemoveType;


        data['approver_id'] = this.addRemoveType === 'add' ? this.add_approver.id : this.add_approver;


        data['ticket_id'] = this.ticketId;


        data['level_id'] = this.addRemoveLevelId;


        data['comment'] = this.approver_comment;


        axios.post('/api/workflow/' + this.endPoint, data).then(res => {


          this.modalLoad = false;

          successHandler(res, 'timeline');

          window.emitter.emit('approvalWorkflowApplied');

          window.emitter.emit('workflowUpdated', 'approval');

          this.showAddRemoveModal = false;


          this.addRemoveType = '';


          this.addRemoveLevelId = '';


          this.add_approver = '';


        }).catch(err => {


          this.modalLoad = false;


          errorHandler(err, 'add_remove_approver');
        });
      }
    },
    addRemoveApprover(type, lId, uId = '') {


      this.addRemoveType = type;


      this.addRemoveLevelId = lId;


      this.add_approver = uId;


      this.showAddRemoveModal = true;
    },
    resumeReminder(id) {


      this.loading = true;


      axios.get('/api/resume-auto-reminder/' + id).then(res => {


        this.getDataFromServer();

        successHandler(res, 'timeline');


      }).catch(err => {


        this.loading = false;


        errorHandler(err, 'timeline');
      });
    },

    stopReminder(id) {


      this.loading = true;


      axios.get('/api/stop-auto-reminder/' + id).then(res => {


        this.getDataFromServer();


        successHandler(res, 'timeline');


      }).catch(err => {


        this.loading = false;


        errorHandler(err, 'timeline');
      });
    },
    sendReminder(type, levelId = "", userId = "") {


      this.loading = true;


      let data = {};


      data['type'] = type;

      data['ticket_id'] = this.ticketId;


      data[type === 'level' ? 'level_id' : null] = levelId;

      type === 'approver' ? (data['user_id'] = userId, data['level_id'] = levelId) : null

      axios.post('/api/send_approval_reminder', data).then(res => {


        this.getDataFromServer();


        successHandler(res, 'timeline');


      }).catch(err => {


        this.loading = false;


        errorHandler(err, 'timeline')
      });
    },

    closeModal() {


      this.showModal = false


      this.$store.dispatch('unsetValidationError');
    },
    subString(value, length = 15) {

      return getSubStringValue(value, length)
    },
    toggleCard() {

      this.cardOpen = !this.cardOpen;

      if (this.cardOpen) {

        this.getDataFromServer();
      }
    },

    /**
     * gets approval workflow data from server
     * @return {undefined}
     */
    getDataFromServer() {

      this.workflowData = [];

      this.loading = true;

      axios.get('/api/ticket-approval-status/' + this.ticketId+'?'+getQueryParams()).then(res => {

        this.workflowData = res.data.data


      }).catch(err => {

        errorHandler(err, 'timeline');
      }).finally(res => {

        this.loading = false;
      })
    },

    /**
     * checks if the given form is valid
     * @return {Boolean} true if form is valid, else false
     * */
    isValid() {
      const {errors, isValid} = validateApprovalTicketSettings(this.$data)
      if (!isValid) {
        return false
      }
      return true
    },

    /**
     * populates the states corresponding to 'name' with 'value'
     * @param  {string} value
     * @param  {[type]} name
     * @return {void}
     */
    onChange(value, name) {
      this[name] = value;
    },

    /**
     * Shows the pop-up for approval/denial
     * @param  {string} type
     * @return {undefined}
     */
    onWorkflowAction(type) {
      this.showModal = true
      this.action = type;
    },

    /**
     * Gets icons class
     * @param {String} type   `icon` or `color`
     * @param {String} status   `PENDING`,`APPROVED` or `DENIED`
     * @return {String}
     */
    getIconStyle(status, type = "icon") {
      switch (status) {
        case 'PENDING':
          return type == "icon" ? 'glyphicon glyphicon-time text-warning' : '#eee';

        case 'APPROVED':
          return type == "icon" ? 'glyphicon glyphicon-check text-success' : '#cbe0d3';

        case 'DENIED':
          return type == "icon" ? 'glyphicon glyphicon-exclamation-sign text-danger' : '#f6ddd8';

        default:
          return null;
      }
    },

    /**
     * Gets the opacity based on if the level is active
     * @param  {Boolean} isActive
     * @return {Number}
     */
    getOpacity(isActive) {
      if (isActive == 1) {
        return 1;
      }
      return 0.5;
    },

    /**
     * Makes the API call to the server trigger approval/denial of the ticket
     * @return {undefined}
     */
    onWorkflowActionConfirm() {

      if (this.action !== 'remove') {

        if (this.isValid()) {

          this.loading = true;

          axios.post('/api/approval-action-without-hash/' + this.ticketId, {
            action_type: this.action,
            comment: this.comment
          })
              .then(res => {

                successHandler(res, this.alertName);
              }).catch(err => {

            errorHandler(err);
          }).finally(res => {

            window.emitter.emit('workflowUpdated', 'approval');


            this.showModal = false;

            this.action = '';

            this.comment = '';

            this.workflowData = [];

            //refreshes the data again
            this.getDataFromServer();

          })
        }
      } else {

        this.loading = true;

        axios.delete('/api/remove-approval-workflow/' + this.ticketId).then(res => {

          successHandler(res, this.alertName);

          window.emitter.emit('workflowUpdated', 'approval');

          this.showModal = false;

          this.action = '';

          this.comment = '';

          this.workflowData = [];


        }).catch(err => {

          errorHandler(err);
        })
      }
    },
    initialActions() {

      this.showModal = false;

      this.action = '';

      this.comment = '';
    }
  },

  computed: {

    modalTitle() {

      return this.action == 'approve' ? 'approve_ticket' : this.action == 'remove' ? 'remove_workflow' : 'deny_ticket';
    },

    modalQuestion() {

      let message = `${lang('are_you_sure_you_want_to')} ${this.action}?`;

      return this.action == 'remove' ? message : `${message} ${lang('mention_a_reason')}`;
    },
    isProceedButtonDisabled() {
      return !this.add_approver || !this.approver_comment;
    }
  },

  components: {
    DynamicSelect,
    Modal,

    'text-field': TextField,
  }
};
</script>

<style scoped>

.appproval {

  min-height: 100px !important;
  position: relative;
}

.approval-level {
  margin: 5px;
  width: 100% !important;
  width: fit-content;
}

.levels {
  display: flex;
  overflow: auto;
}

.approver-status {
  margin-left: auto;
  order: 2;
  margin-top: 3px;
}

.approver-name {
  width: max-content;
}

.workflow-status {
  right: 12px;
  position: absolute;
  margin-top: 8px;
}

.box-header > .fa, .box-header > .glyphicon, .box-header > .ion, .box-header .box-title {
  margin-right: 0;
}

#approval-workflow-actions {
  margin-top: 10px;
}

.padding-left-15 {
  padding-left: 15px !important;
}

.margin_box {
  margin: 0 !important;
  margin-bottom: 10px !important;
}

.font-size-14 {
  font-size: 14px !important;
}

.load_margin {
  margin-top: 70px;
  margin-bottom: 70px;
}

.mb_5 {
  margin-bottom: 5px;
}

.appproval-tools {
  margin-right: -8px !important;
  margin-top: 6px !important;
}

.approval_title {
  margin-bottom: 5px;
  margin-top: -2px;
}

#highlight:hover {
  background-color: rgb(238, 238, 238);
  cursor: pointer;
}

.p-2p {
  padding-top: 2px !important;
  padding-bottom: 2px !important;
}

.toolsKit {
  margin-right: -5px;
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Apply the rotation animation when the button has a class of "rotating" */
.btn-tool.rotating i {
  animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
}

</style>
