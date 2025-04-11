<template>
  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle" :id="id">
    <template #title>
      <h4 class="modal-title">{{ lang('merge_users') }}</h4>
    </template>
    <template #alert>
      <alert componentName="merge-user-modal" />
    </template>

    <template #fields>
      <div v-if="!loading" id="merge_content">
        <div class="alert alert-warning"><i class='fas fa-warning'></i> {{ trans('caution-merge-users') }}</div>
        <div class="row" v-if="!this.userId">
          <dynamic-select
              name="parentUser"
              :label="lang('select-parent-user')"
              :value="parentUser"
              :elements="parentUsers"
              :onChange="onChange"
              classname="col-sm-6"
              :apiEndpoint="dynamicSelectEndpoint"
              :required="true"
              strlength="30"
              :multiple="false">
          </dynamic-select>
          <dynamic-select
              name="childUser"
              :label="lang('select_users')"
              :value="childUser"
              :elements="childUsers"
              :onChange="onChange"
              classname="col-sm-6"
              :apiEndpoint="dynamicSelectEndpoint"
              :multiple="true"
              :required="true"
              strlength="30"
              :loadOnScroll="true"
          ></dynamic-select>
        </div>
        <div class="row" v-else>
          <dynamic-select
              name="childUser"
              :label="lang('select_users')"
              :value="childUser"
              :elements="childUsers"
              :onChange="onChange"
              classname="col-sm-12"
              :apiEndpoint="dynamicSelectEndpoint"
              :multiple="true"
              :required="true"
              strlength="30"
              :loadOnScroll="true"
          ></dynamic-select>
        </div>

        <div class="row">
          <text-field
              :label="lang('merge-reason')"
              :value="merge_reason"
              type="textarea"
              name="merge_reason"
              :onChange="onChange"
              classname="col-sm-12"
          ></text-field>
        </div>
      </div>

      <div v-if="loading" class="row" slot="fields">
        <reuse-loader :animation-duration="4000" color="#1d78ff" :size="size" />
      </div>
    </template>
    <template #controls>
      <button type="button" id="submit_btn" @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">
        <i class="fas fa-check"></i> {{ lang('proceed') }}
      </button>
    </template>
  </modal>
</template>

<script>
import { userMergeSettingRules } from "../../../../../helpers/validator/userMergeSettingRules";
import { errorHandler, successHandler } from "../../../../../helpers/responseHandler";
import axios from 'axios';
import textField from "../../../../MiniComponent/FormField/TextField.vue";
import staticSelect from "../../../../MiniComponent/FormField/StaticSelect.vue";
import dynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";

export default {
  name: 'merge-user-modal',
  description: 'Merge user Modal component',
  props: {
    showModal: { type: Boolean, default: false },
    userId: { type: Number | String, default: '' },
    onClose: { type: Function },
    componentTitle: { type: String, default: 'timeline' },
    reloadUsers: { type: Function }
  },
  data() {
    return {
      isDisabled: false,
      containerStyle: { width: '800px' },
      loading: false,
      size: 60,
      merge_reason: '',
      title: '',
      parentUser: '',
      childUser: '',
      user: '',
      id: false,
      page: 1, // Current page
      pageSize: 10, // Number of records per page
      parent_users: [], // Initialize with an empty array
      parentUsersLoaded: false,
      childUsersLoaded: false,
      initialParentUsers: [],
      initialChildUsers: [],
    };
  },
  computed: {
    parentUsers() {
      if (Array.isArray(this.parent_users)) {
        if (this.initialChildUsers && this.initialChildUsers.length > 0) {
          return this.parent_users.filter(i => !this.initialChildUsers.some(user => user.id === i.id));
        } else {
          return this.parent_users;
        }
      } else {
        return []; // Return an empty array if parent_users is not yet populated
      }
    },
    childUsers() {
      if (this.initialParentUsers) {
        return this.parent_users.filter(i => i.id !== this.initialParentUsers.id);
      } else if (this.userId) {
        return this.parent_users.filter(i => i.id !== this.userId);
      } else {
        return this.parent_users;
      }
    },
    dynamicSelectEndpoint() {
      return `/api/dependency/users?page=${this.page}&per_page=${this.pageSize}&supplements[no_email]=user-only`;
    }
  },
  methods: {
    isValid() {
      const { errors, isValid } = userMergeSettingRules(this.$data);
      return isValid;
    },
    mergeUser(page, isParent) {
     // this.loading = true;
      const params = {
        page: page,
        per_page: this.pageSize,
        'supplements[no_email]': 'user-only'
      };
      axios
          .get('/api/dependency/users', { params })
          .then((res) => {
            this.loading = false;
            const users = res.data.data.users;
            for (var i in users) {
              users[i].value = users[i]['email'];
              users[i].id = users[i]['id'];
              users[i].name = users[i]['name'];
            }
            if (isParent) {
              this.initialParentUsers = users;
              this.parentUsersLoaded = true;
            } else {
              this.child_users = [...this.child_users, ...users.filter(user => !this.child_users.some(u => u.id === user.id))];
              this.childUsersLoaded = true;
            }
          })
          .catch((err) => {
            this.loading = false;
            errorHandler(err, this.componentTitle);
          });
    },
    onChange(value, name) {
      this[name] = value;
      this.isValid();

      // Check if the selected item is not empty
      if (name === 'parentUser' || name === 'childUser') {
        if (value) {
          // Clear the validation error for the corresponding field
          this.isValid();
        }
        if (value == null) {
          this.isValid();
        }
      }
    },
    onSubmit() {
      if (this.isValid()) {
        this.loading = true;
        this.isDisabled = true;

        const data = {
          parent_id: (this.parentUser) ? this.parentUser.id : this.userId,
          reason: this.merge_reason,
          _method: 'PATCH',
          children_id: this.childUser.map(a => a.id)
        };

        axios.post('/merge-users', data)
            .then((res) => {
              this.loading = false;
              successHandler(res, 'merge-user-modal');
              setTimeout(() => {
                this.onClose();
                this.reloadUsers();
              }, 2000);
            })
            .catch((err) => {
              this.loading = false;
              this.isDisabled = false;
              errorHandler(err, 'merge-user-modal');
            });
      }
    }
  },
  watch: {
    showModal(newValue) {
      if (newValue) {
        this.page = 1;
        this.child_users = [];
        this.mergeUser(this.page, true);
      }
    },
    childUser(newValue) {
      if (newValue && newValue.length > 0) {
        this.mergeUser(1, false);
      }
    },
    page(newValue) {
      if (newValue > 1 && this.child_users.length < this.pageSize * (newValue - 1)) {
        this.mergeUser(newValue, false);
      }
    }
  },
  components: {
    textField,
    staticSelect,
    dynamicSelect
  }
};
</script>
<style>
#merge_content {
  max-height: 500px;
  overflow-y: auto;
  overflow-x: hidden;
	padding-right: 5px;
}
</style>