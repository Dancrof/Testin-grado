<template>

	<div class="col-sm-12" id="user_list">

		<alert componentName="dataTableModal" />

		<div class="card card-light " v-if="hasDataPopulated">

			<div class="card-header">

				<h3 class="card-title">{{ trans('list_of_contacts') }}</h3>

				<div class="card-tools">

					<router-link class="btn btn-tool" v-tooltip="trans('create_contact')" to="/user/create">

						<i class="glyphicon glyphicon-plus"></i>
					</router-link>

          <button v-if="showIcon" class="btn btn-tool" @click="triggerExport" href="javascript:;" v-tooltip="trans('export')">

            <i class="fas fa-paper-plane"></i>
          </button>

					<button class="btn btn-tool" @click="toggleFilterView" href="javascript:;" v-tooltip="trans('filter')">

						<i class="glyphicon glyphicon-filter"></i>
					</button>
          <button type="button" class="btn btn-tool" href="javascript:;" @click="mergeUSerModal()" id="merge_users" v-tooltip="trans('merge_users')">

            <i class="fas fa-code-merge"> </i>
          </button>
          <transition name="modal">
            <merge-user-modal v-if="showMergeUSerModal" :onClose="onClose" :showModal="showMergeUSerModal">
            </merge-user-modal>
          </transition>
				</div>
			</div>

			<div class="card-body" id="my_user">

				<advance-filter id="filter-box" v-show="isShowFilter" :metaData="filterOptions"
					@selectedFilters="selectedFilters">
				</advance-filter>

        <section v-for="report in columnData" :key="report">

          <user-column-list :table-columns="report.columns" :reportId="report.id" :columnId="newReportId" />

				<dynamic-datatable
					v-if="columns.length" :columns="visibleColumns" :filterParams="filterParams" :columnsMeta="columns"
					:data-url="apiUrl" :staticColumns="staticColumns"
					>

				</dynamic-datatable>
        </section>
			</div>
		</div>
	</div>
</template>

<script>
import {computed} from "vue";

import {boolean} from "../../../helpers/extraLogics";

import {errorHandler, successHandler} from "../../../helpers/responseHandler";

import axios from "axios";

import {useStore} from "vuex";

import UserColumnList from "./View/MiniComponents/UserColumnList.vue";
import AdvanceFilter from "../../Extra/AdvanceFilter.vue";
import DynamicDatatable from "../../Extra/DynamicDatatable.vue";
import MergeUserModal from "./View/MiniComponents/MergeUserModal.vue";
import moment from 'moment';

export default {
  name: "user-directory",

  description: "User list component",

	setup() {

		const store = useStore();

		return {

			formattedTime : computed(()=>store.getters.formattedTime),

			formattedDate : computed(()=>store.getters.formattedDate)
		}
	},

  data() {
    return {
      queryParameter : this.$route.query,

      params : '',

      hasDataPopulated: false,

      isShowFilter: false,

      showMergeUSerModal : false,

      visibleColumns: {},

      apiUrl: "user-export-data",

      columns: [],

      options: {},

      filterParams: {},

      staticColumns: ["info", "user_actions"],

      filterOptions: [
        {
          section: [
            {
              name: "userType",
              url: "",
              elements: [
                {
                  id: "all",
                  name: "All",
                  queryPerm: "roles[0]=user&roles[1]=agent",
                },
                {
                  id: "active_users",
                  name: "Active Users",
                  queryPerm: "roles[0]=user&active=1",
                },
                {
                  id: "deactivated_users",
                  name: "Deactivated Users",
                  queryPerm: "roles[0]=user&active=0",
                },
                {id: "all_users", name: "All Users", queryPerm: "roles[0]=user"},
                {
                  id: "active_agents",
                  name: "Active Agents",
                  queryPerm: "roles[0]=agent&active=1",
                },
                {
                  id: "deactivated_agents",
                  name: "Deactivated Agents",
                  queryPerm: "roles[0]=agent&active=0",
                },
                {
                  id: "all_agents",
                  name: "All Agents",
                  queryPerm: "roles[0]=agent",
                },
                {
                  id: "all_active",
                  name: "Active Users and Agents",
                  queryPerm: "roles[0]=user&roles[1]=agent&active=1",
                },
                {
                  id: "all_deactive",
                  name: "Deactivated Users and Agents",
                  queryPerm: "roles[0]=user&roles[1]=agent&active=0",
                },
              ],
              isMultiple: false,
              isPrepopulate: false,
              label: "user_type",
              value: {
                id: "active",
                name: "Active Users",
                queryPerm: "roles[0]=user&roles[1]=agent&active=1",
              },
              className: "col-sm-3",
              strlength: 25,
            },
            {
              name: "departments",
              url: "api/dependency/departments",
              elements: [],
              isMultiple: true,
              isPrepopulate: false,
              label: "departments",
              value: "",
              className: "col-sm-3",
              strlength: 25,
            },
            {
              name: "teams",
              url: "api/dependency/teams",
              elements: [],
              isMultiple: true,
              isPrepopulate: false,
              label: "teams",
              value: "",
              className: "col-sm-3",
              strlength: 25,
            }
          ],
        },

        {
          section : [
            {
              name: "organizations",
              url: "api/dependency/organizations",
              elements: [],
              isMultiple: true,
              isPrepopulate: false,
              label: "organizations",
              value: "",
              className: "col-sm-3",
              strlength: 25,
            },
            {
              name: 'created_at',
              type: 'date',
              label: ['created_between', 'created_in'],
              timeOptions: {start: '00:00', step: '00:30', end: '23:30'},
              range: true,
              isCustom: false
            },
          ],
        }
      ],

      newReportId: '',

      dataCount: '',

      showIcon: false,
    };
  },

  beforeMount() {
    if(this.queryParameter.hasOwnProperty('label_ids')){
      this.apiUrl = `user-export-data?label_ids=${this.queryParameter.label_ids}`
    }

    if(this.queryParameter.hasOwnProperty('dt')){
      this.handleDownload(this.queryParameter.dt);
    }

    this.getColumns();
  },

  created() {
    window.emitter.on("onColumnUpdate", this.onColumnUpdate);

    window.emitter.on('dataCount', this.handleDataCount);
  },

  methods: {
    getColumns() {
      this.hasDataPopulated = false;

      axios
          .get("api/agent/report-config/user-report")
          .then((res) => {

          this.hasDataPopulated = true;

            //reportId fetched.
            this.newReportId = res.data.data.id;

            this.columnData = res.data.data.sub_reports;

            this.columnData.forEach((subReport) => {
              this.columns = subReport.columns;
            });

            this.columns.map((column) => {
              column.is_visible = column.is_visible ? true : false;
            })

          this.updateVisibleColumns();
        })
        .catch((err) => {
          this.hasDataPopulated = true;

          this.columns = [];

          errorHandler(err);
        });
    },

    onColumnUpdate(columns) {
      this.columns = columns;

      this.updateVisibleColumns();
    },

    updateVisibleColumns() {
      // setting visibleColumns to empty so that old values can be removed
      this.visibleColumns = {};

      this.columns.map((column) => {
        if (boolean(column.is_visible)) {
          this.visibleColumns[column.key] = column.label;
        }
      });
    },

    selectedFilters(value) {
      if (value === "closeEvent") {
        return (this.isShowFilter = false);
      }
      if (value === "resetEvent") {
        return this.resetFilter();
      }

      return this.applyFilter(value);
    },

    resetFilter() {
      this.apiUrl = "/user-export-data";

      this.filterOptions = this.filterOptions.map(function(obj) {
        obj.value = "";

        return obj;
      });
    },

    applyFilter(value) {
      let baseUrlForFilter = "/user-export-data?";

      let params = "";

      if (value.userType) {
        this.filterOptions[0].value = value.userType;

        params = value.userType.queryPerm + "&";
      } else {
        params = "roles[0]=user&roles[1]=agent&";
      }

      if (value.departments) {
        params = this.commonMethod(0,1, "dept-ids", value.departments, params);
      }

      if (value.teams) {
        params = this.commonMethod(0,2, "team-ids", value.teams, params);
      }

      if (value.organizations) {
        params = this.commonMethod(1,0, "org-ids", value.organizations, params);
      }
      if (value.created_at) {
        value = value.created_at;
        let date = '';
        if(value.includes('last')){
          date = value;
        }else{
          let startDate = moment(value[0]).format('YYYY-MM-DD HH:mm:ss');
          let endDate = moment(value[1]).format('YYYY-MM-DD HH:mm:ss');
          date = 'date::' + startDate + '~' + endDate
        }

        params += 'created_at=' + date + '&';
      }

      if (params[params.length - 1] === "&") {
        params = params.slice(0, -1);
      }

      this.apiUrl = baseUrlForFilter + params;

      this.isShowFilter = false;

      this.params = this.reformatExportData(params);
    },

    reformatExportData(str) {

      const obj = str.split('&').reduce((result, pair) => {
        const [key, value] = pair.split('=');
        result[key] = value;
        return result;
      }, {});

      const reformattedObj = {};

      for (const key in obj) {
        const match = key.match(/([a-zA-Z_-]+)\[(\d+)\]/);

        if (match) {
          const [_, realKey, index] = match;
          reformattedObj[realKey] = reformattedObj[realKey] || [];
          reformattedObj[realKey][index] = obj[key];
        } else if (key === 'created_at') {
          reformattedObj[key] = obj[key];
        }
      }

      return reformattedObj;
    },

    commonMethod(section, i, key, value, param) {
      var params;

      params = param;

      this.filterOptions[section].section[i].value = value;

      value.forEach(function(element, index) {
        params += key + "[" + index + "]=" + element.id + "&";
      });

      return params;
    },

    toggleFilterView() {
      this.isShowFilter = !this.isShowFilter;
    },

    mergeUSerModal() {
      this.showMergeUSerModal = true;
    },

    onClose(){
      this.showMergeUSerModal =false;
      this.$store.dispatch('unsetValidationError');
      window.emitter.emit('onColumnUpdate', this.columns);
      window.emitter.emit('refreshData')
    },

    handleDownload(hash){
      axios.get('user/export/download/' + hash)
          .then((res) => {
            let fileURL = res.data.data.href;
            let fileLink = document.createElement('a');
            fileLink.href = fileURL;
            document.body.appendChild(fileLink);
            fileLink.setAttribute('download', this.generateFileNameFromPath(fileURL));
            fileLink.click();
            successHandler(res, 'dataTableModal')

            if (history.pushState) {
              let originalPath = `${window.location.protocol}//${window.location.host}${window.location.pathname}`;
              window.history.pushState({ path : originalPath },'', originalPath);
            }

          })
          .catch((err) => {
            errorHandler(err, 'dataTableModal');
          })
    },

    generateFileNameFromPath(filepath){
      let path = filepath.split('/');
      return path[path.length - 1]
    },

    handleDataCount(data) {

      this.showIcon = data ? true : false;

      this.dataCount = data;
    },

    triggerExport(){

      const exportPayload = {
        ...this.params,
        total: this.dataCount
      };

      axios.post('/api/agent/report-export/'+ this.newReportId, exportPayload).then(
          res => {
            successHandler(res, 'dataTableModal')
          }
      ).catch( err => {
        errorHandler(err, 'dataTableModal')
      })
    }
  },

  components: {
    "user-column-list": UserColumnList,

    "advance-filter": AdvanceFilter,

    "dynamic-datatable": DynamicDatatable,

    "merge-user-modal" : MergeUserModal,
  },
};
</script>

<style>
.user-name,
.user-user,
.user-name,
.user-email,
.user-phone,
.user-login {
  max-width: 250px;
  word-break: break-all;
}

.user-role {
  text-transform: capitalize;
}

#my_user .VueTables .table-responsive {
  overflow-x: auto;
}

#my_user .VueTables .table-responsive > table {
  width: max-content;
  min-width: 100%;
  max-width: max-content;
  overflow: auto !important;
}
</style>
