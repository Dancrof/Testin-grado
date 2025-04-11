<template>

  <div class="card card-light card-outline">

    <template v-if="loading || !data">

      <div id="load" class="row">

        <reuse-loader :animation-duration="4000" :size="40"/>
      </div>
    </template>

    <template v-if="data && !loading">

      <div class="card-body box-profile">

        <div class="text-center">

          <faveo-image-element id="userimg" :source-url="data.profile_pic"
                               :classes="['profile-user-img img-fluid img-rounder img-circle']" alternative-text="User Image"/>

        </div>

        <h3 class="profile-username text-center" v-tooltip="data.full_name">{{ subString(data.full_name) }}
        </h3>

        <p class="text-muted text-center">

					<span :class="{'success':data.email_verified == 1,'danger':data.email_verified != 1}"
                class="fas fa-envelope"
                v-tooltip="data.email_verified == 1 ? lang('user_email_is_verified') : lang('user_has_not_verified_email')"
                @click="userModal('email_verified')">

					</span>

          <span :class="{'success':data.mobile_verified == 1,'danger':data.mobile_verified != 1}"
                class="fas fa-mobile-alt"
                v-tooltip="data.mobile_verified == 1 ? lang('user_mobile_is_verified') : lang('user_has_not_verified_mobile')"
                @click="userModal('mobile_verified')">

					</span>

          <span :class="{'success':data.is_2fa_enabled == 1,'danger':data.is_2fa_enabled != 1}"
                :id="'2fa_status_user__' + data.id" class="fas fa-shield-alt"
                v-tooltip="data.is_2fa_enabled == 1 ? lang('user_enabled_2fa') : lang('user_not_enabled_2fa')">
					</span>
        </p>

        <ul class="list-group list-group-unbordered mb-3">
          <li class="list-group-item">


            <div class="Username"><b>{{ trans('user_name') }}</b>
              <div class="float-end">
                <a v-tooltip="data.user_name">{{ subString(data.user_name) }}</a>
                <span v-if="isShowUsername" class="copyClip">
								{{ lang('copied') }}
							</span>
                <button class="btn btn-link ps-0 pe-0 " v-tooltip="lang('copy')"
                        @click.prevent="copyMethod('username', data.user_name)">&nbsp;&nbsp;<i class="far fa-copy"></i>
                </button>
              </div>
            </div>


          </li>

          <li class="list-group-item">

            <b>{{ trans('email') }}</b>

            <div class="float-end">
              <a v-tooltip="data.email">{{ subString(data.email) }} </a>
              <span v-if="isShowEmail" class="copyClip">
								{{ lang('copied') }}
							</span>
              <button class="btn btn-link ps-0 pe-0" v-tooltip="lang('copy')"
                      @click.prevent="copyMethod('email', data.email)">&nbsp;&nbsp;<i class="far fa-copy"></i></button>
            </div>
          </li>

          <li v-if="data.role === 'user' && editVisibilty" class="list-group-item">

            <b>{{ trans('labels') }}</b>&nbsp;
            <div class="float-end">


              <template v-for="(label,index) in data.labels">
                <a target="_blank" v-tooltip="{ content: loadLabel(label.title), html: true }" class="badge me-1"
                   :style="{'backgroundColor' : label.color, 'color': '#FFF'}">
                <span v-html="subString(loadLabel(label.title))"></span>
                </a>

              </template>
            </div>
            <user-label :userObj="data" :reloadDetails="reloadData"></user-label>

          </li>

          <li class="list-group-item">

            <b>{{ lang('role') }}</b>

            <a class="float-end text-capitalize text-green" v-tooltip="data.role">
              {{ subString(data.role) }}</a>
          </li>
	        
	        <li v-if="data.role !== 'user'" class="list-group-item">
		        
		        <b>{{ lang('work_phone') }}</b>
		        
		        <a class="float-end" v-tooltip="data.phone_number ? data.phone_number : ''">
			        
			        {{ formattedPhone(data) }}
		        
		        </a>
	        </li>
	        
          <li class="list-group-item">

            <b>{{ lang('mobile') }}</b>

            <a class="float-end" v-tooltip="data.mobile ? data.mobile : ''">

              {{ formattedMobile(data) }}

            </a>
          </li>

            <li v-if="data.role === 'user' && data.mobile_ext" class="list-group-item">

                <b>{{ lang('ext') }}</b>

                <a class="float-end" v-tooltip="data.mobile_ext ? data.mobile_ext : ''">

                    {{ subString(data.mobile_ext) }}

                </a>
            </li>

          <li class="list-group-item" v-if="data.role !== 'user'">

            <b>{{ lang('agent_time_zone') }}</b>

            <a class="float-end" v-tooltip="data.timezone ? data.timezone.name :''">

              {{ data.timezone ? subString(data.timezone.name) : '---' }}
            </a>
          </li>

          <li class="list-group-item" v-if="showLocation">

            <b>{{ lang('location') }}</b>

            <a class="float-end" v-tooltip="data.location ? data.location.title : ''">

              {{ data.location ? subString(data.location.title) : '---' }}
            </a>
          </li>

          <li v-if="data.role === 'user'" class="list-group-item">

            <div id="refresh-org">

              <b>{{ lang('organisation') }}</b>

              <template v-if="linkedOrg.length === 0 && !data.processing_account_disabling">

                <div class="float-end">

                  <button class="btn btn-link ps-0 pe-0" v-tooltip="lang('Assign')" @click="orgClick('assign')"
                          href="javascript:;">&nbsp;&nbsp;<i class="fas fa-tasks"></i></button>

                </div>

                <org-create-modal :showModal="showOrgModal" :userId="data.id"></org-create-modal>

              </template>

              <template v-else>

                <div class="float-end">

                  <button class="btn btn-link link-eye" v-tooltip="lang('view_linked_org')"
                          @click="showLinkedModal = true" href="javascript:;">
                    <i class="fas fa-eye"></i>
                  </button>
                </div>
              </template>
            </div>
          </li>

          <li v-if="data.role !== 'user'" class="list-group-item">

            <div id="refresh-org">

              <b>{{ lang('departments') }}</b>

              <a v-if="data.departments.length === 0" class="float-end">---</a>

              <template v-else>

                <ul class="department-list float-end">
                  <li v-for="(dept, index) in visibleDepartments" :key="dept.id">
                    <a :href="basePath()+'/admin/department/'+dept.id" v-tooltip="dept.name">
                      {{ subString(dept.name, 10) }}
                    </a>
                  </li>
                  <div v-if="data.departments.length > 2">
                  <a style="color:#444444" v-if="showAll" class="cursor-pointer" @click="showLessDepartments">{{ lang('view_less') }}</a>
                  <a style="color:#444444" v-else class="cursor-pointer" v-tooltip="trans('view_all_departments')"
                     @click="showAllDepartments">{{ lang('view_all') }}</a>
                  </div>
                </ul>

              </template>
            </div>
          </li>

          <li v-if="data.role !== 'user'" class="list-group-item">

            <div id="refresh-team">

              <b>{{ lang('teams') }}</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

              <a v-if="data.teams.length === 0" class="float-end">---</a>

              <template v-else>
                <ul class="department-list float-end">
                  <li v-for="(team, index) in visibleTeams">
                    <a :href="basePath()+'/admin/team/'+team.id" v-tooltip="team.name">
                      {{ subString(team.name, 10) }}
                    </a>
                  </li>
                  <div v-if="data.teams.length > 2">
                  <a style="color:#444444" v-if="showAllteams" class="cursor-pointer" @click="showLessTeams">{{ lang('view_less') }}</a>
                  <a style="color:#444444" v-else class="cursor-pointer" v-tooltip="trans('view_all_teams')"
                     @click="showAllTeams">{{ lang('view_all') }}</a>
                  </div>
                </ul>
              </template>
            </div>
          </li>

          <li v-if="data.role !== 'user'" class="list-group-item">

            <div id="refresh-team">

              <b>{{ lang('type') }}</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

              <a v-if="data.types.length === 0" class="float-end">---</a>

              <template v-else>
                <ul class="department-list float-end">
                  <li v-for="(type, index) in visibleTypes">
                    <a  v-tooltip="type.name">
                      {{ subString(type.name, 10) }}
                    </a>
                  </li>
                  <div v-if="data.types.length > 2">
                    <a style="color:#444444" v-if="showAlltypes" class="cursor-pointer" @click="showLessTypes">{{ lang('view_less') }}</a>
                    <a style="color:#444444" v-else class="cursor-pointer" v-tooltip="trans('view_all_types')"
                       @click="showAllTypes">{{ lang('view_all') }}</a>
                  </div>
                </ul>
              </template>
            </div>
          </li>

          <li v-if="data.role === 'user'" class="list-group-item">

            <b>{{ lang('address') }}</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            <p v-tooltip="data.internal_note"> {{ data.internal_note }}</p>
          </li>

          <li v-for="value in data.custom_field_values" class="list-group-item">
            <b v-tooltip="tooltipText(value.label, 30)">{{ subString(value.label, 30) }}</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <span v-if="Array.isArray(value.value)" class="float-end cursor-pointer">
           <template v-for="(item, index) in value.value">
            <a class="hover-color" v-tooltip="tooltipText(item, 30)">{{ subString(item, 30) }}</a>
            <span class="hover-color" v-if="index !== value.value.length - 1">, </span><span v-else>&nbsp;</span>
           </template>
        </span>

            <a v-else class="float-end cursor-pointer" v-tooltip="value.value">
              <span class="hover-color">{{ subString(value.value, 15) }}</span>
            </a>
          </li>

        </ul>
      </div>
    </template>

    <transition name="modal">

      <org-modal v-if="showOrgModal" :onClose="onClose" :showModal="showOrgModal" :title="orgModalTitle"
                 :orgId="orgId" :userId="data.id" :deptCondition="data.OrganizationDepartmentStatus">

      </org-modal>
    </transition>

    <transition name="modal">
      <org-linked-modal v-if="showLinkedModal" :onClose="onClose" :showModal="showLinkedModal"
                        :userId="data.id" :deptCondition="data.OrganizationDepartmentStatus">

      </org-linked-modal>
    </transition>

    <transition name="modal">

      <user-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :title="modalTitle" :userData="data">

      </user-modal>
    </transition>
  </div>
</template>

<script>

import {getSubStringValue, renderLabelWithEmoji} from "../../../../helpers/extraLogics";

import {errorHandler, successHandler} from "../../../../helpers/responseHandler";

import axios from 'axios'

import OrganizationCreateModal from "./MiniComponents/OrganizationCreateModal.vue";
import UserStatusModal from "./MiniComponents/UserStatusModal.vue";
import OrgLinkedModal from "./MiniComponents/OrgLinkedModal.vue";
import OrganizationModal from "./MiniComponents/OrganizationModal.vue";

import UserLabel from "../../../Agent/User/View/UserLabel.vue";

export default {

  name: 'user-details',

  description: 'User details  page',

  props: {

    data: {type: [Object, String], default: ''}
  },

  data() {

    return {

      loading: false,

      showOrgModal: false,

      userData: '',

      labels: '',

      orgModalTitle: '',

      orgId: '',

      modalTitle: '',

      showModal: false,

      ban: this.data.ban,

      obj: {},

      usernameContent: '',

      emailContent: '',

      isShowUsername: false,

      isShowEmail: false,

      showLinkedModal: false,

      linkedOrg: this.data.organizations,

      editVisibilty: false,

      showAll: false,

      showAllteams: false,

      showAlltypes: false,

      visibleTeams:[],

      visibleDepartments:[],

      visibleTypes:[],

    }
  },

  beforeMount() {
    // this.editVisibilty = this.data.label_field[0].display_for_agent;
    if (this.data.label_field && this.data.label_field.length > 0) {
      this.editVisibilty = this.data.label_field[0].display_for_agent;
    }
  },

  created() {
    window.emitter.on('linkedOrgTotal', this.updateLength);

    this.allDepartments = this.data.departments || [];
    this.visibleDepartments = this.allDepartments.slice(0, 2);

    this.allTeams = this.data.teams || [];
    this.visibleTeams = this.allTeams.slice(0, 2);

    this.allTypes = this.data.types || [];
    this.visibleTypes = this.allTypes.slice(0, 2);
  },


  computed: {
    showLocation() {
      if (this.data.role !== 'user') {
        return true;
      } else {
        return !!(this.data.location)
      }
    }
  },
  mounted() {
    this.usernameContent = this.data.user_name;
    this.emailContent = this.data.email;
  },

  methods: {

    showAllDepartments() {
      this.visibleDepartments = this.allDepartments;
      this.showAll = true;
    },

    showLessDepartments() {
      this.visibleDepartments = this.allDepartments.slice(0, 2);
      this.showAll = false;
    },
    showAllTeams() {
      this.visibleTeams = this.allTeams;
      this.showAllteams = true;
    },

    showLessTeams() {
      this.visibleTeams = this.allTeams.slice(0, 2);
      this.showAllteams = false;
    },
    showAllTypes() {
      this.visibleTypes = this.allTypes;
      this.showAlltypes = true;
    },

    showLessTypes() {
      this.visibleTypes = this.allTypes.slice(0, 2);
      this.showAlltypes= false;
    },
    updateLength(value) {

      if (!value) {
        this.linkedOrg = []
      }
    },

    subString(name, length = 20) {

      return getSubStringValue(name, length)
    },

    formattedPhone(data) {

      if (data.phone_number && data.phone_number !== 'Not available') {
        var ext = data.ext ? "-" + data.ext : " ";
        return data.phone_country_code || data.phone_number ? "+" + data.phone_country_code + " " + this.subString(data.phone_number) + ext : this.subString(data.phone_number);
      } else {
        return "---";
      }
    },

    formattedMobile(data) {

      if (data.mobile && data.mobile !== 'Not available') {

		  if(data.mobile.includes(" ")) {
			  
			  return '+' + this.subString(data.mobile);
			  
		  } else {
			  
			  if(data.country_code) {
			
				  return '+' + data.country_code + " " + this.subString(data.mobile);
			
			  } else {
			
				  return this.subString(data.mobile);
			  }
		  }
      } else {
        return "---";
      }
    },

    onClose() {

      this.showModal = false;

      this.showOrgModal = false;

      this.showLinkedModal = false;

      this.$store.dispatch('unsetValidationError');
    },

    userModal(title) {

      this.showModal = !this.data[title];

      this.modalTitle = title;
    },


    commonMethod(api, value) {

      if (api === '/settings/user/status') {

        this.obj['settings_status'] = value;
      }

      this.obj['user_id'] = this.data.id;

      axios.post(api, this.obj).then(res => {

        this.loading = false;

        window.emitter.emit('refreshUserData');

        successHandler(res, 'user-view')

      }).catch(error => {

        this.loading = false;

        errorHandler(error, 'user-view');
      })
    },

    orgClick(name, id) {

      this.orgId = id;

      this.showOrgModal = true;

      this.orgModalTitle = name;
    },


    copyMethod(field, value) {

      let inputElem = document.createElement("input");

      inputElem.type = "text";
      inputElem.value = value;
      document.body.appendChild(inputElem);
      inputElem.select();

      document.execCommand("Copy");

      if (field === 'username') {

        this.isShowUsername = true;

      } else {

        this.isShowEmail = true;
      }

      document.body.removeChild(inputElem);

      setTimeout(() => {

        this.isShowUsername = false;

        this.isShowEmail = false;

      }, 1000);
    },

    tooltipText(label, content) {
      return label.length > content ? label : '';
    },

    loadLabel(label) {
      return renderLabelWithEmoji(label);
    }
  },


  components: {

    'org-modal': OrganizationModal,

    'org-linked-modal': OrgLinkedModal,

    'user-modal': UserStatusModal,

    'user-label': UserLabel,

    'org-create-modal': OrganizationCreateModal,
  }
};
</script>

<style scoped>
.department-list{
  list-style: none;
}
#user_img {
  border: 3px solid #CBCBDA;
  padding: 3px;
}

#load {
  margin-top: 30px;
  margin-bottom: 30px;
}

.success {
  color: #017701 !important;
  cursor: pointer;
  padding: 3px;
}

.danger {
  color: red !important;
  padding: 3px;
  cursor: pointer;
}

#cursor {
  cursor: pointer;
}

.copyClip {
  position: absolute;
  background: black;
  color: white;
  border-radius: 0.2rem;
  padding: 2px;
  text-align: center;
  bottom: 80%;
  left: 81%;

}

.copyClip::after {
  content: '';
  position: absolute;
  top: 97%;
  margin-left: -9px;
  border-width: 5px;
  border-style: solid;
  border-color: black transparent transparent transparent;
}

.fa-copy {
  margin-right: 5px;
}

ol {
  padding: 0;
}

.link-eye {
  margin-right: -12px;
}

.hover-color{
  color: #3c8dbc;
}
</style>
