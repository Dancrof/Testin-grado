<template>

  <div class="col-sm-12">

    <alert componentName="dataTableModal"/>

    <div class="card card-light">

      <div class="card-header">

        <h3 id="system-log-list" class="card-title">{{lang('list_of_system_logs')}}</h3>

        <div class="card-tools">

          <!-- Refresh Table -->

          <button type="button" class="btn btn-tool" @click="refreshData" v-tooltip="lang('refresh')">
            <i class="fas fa-sync-alt"></i>
          </button>


          <!---Delete Button --->

          <button type="button" class="btn btn-tool" @click="showDeleteModal" v-tooltip="lang('delete_logs')">
            <i class="fas fa-trash"></i>
          </button>

          <!-- Filter button -->
          <button class="btn btn-tool" @click="toggleFilterView" href="javascript:;" v-tooltip="trans('filter')">

            <i class="glyphicon glyphicon-filter"></i>
          </button>

          <button class="btn btn-tool" @click="triggerExport" v-if="hasData" href="javascript:;" v-tooltip="trans('export')">
            <i class="fas fa-paper-plane"></i>
          </button>

        </div>
      </div>

      <div class="card-body" id="system-log-list">

        <!-- Filter component -->

        <data-table-filter id="filter-box" v-show="isShowFilter" :metaData="filterOptions"
                           :updateFields="updateFilterFields"
                           :appliedFilters="appliedFilters"
                           @selectedFilters="selectedFilters">
        </data-table-filter>

        <data-table :key="tableKey" :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="system-level-activity">

        </data-table>
        <transition name="modal">
          <log-modal v-if="showModal" title="delete_logs" :hideCheckBox="true" :onClose="onClose" :showModal="showModal"/>
        </transition>
      </div>
    </div>
  </div>
</template>
<script>

import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";
import {useStore} from "vuex";
import {computed} from "vue";
import HyperLinkInstance from "../../../Extra/Tables/HyperLinkInstance.vue";
import ActivityParser from "../../../Common/ActivityParser.vue";
import DetailedLog from "./DetailedLog.vue";
import {errorHandler, successHandler} from "../../../../helpers/responseHandler";
import TableView from "../../../../../../../app/FaveoLog/views/js/components/HealthCheck/TableView.vue";
import moment from "moment/moment";
import DeleteLog from "./DeleteLog.vue";
import LogModal from "./DeleteLog.vue";
import DataTableFilter from "../../../Extra/DataTableFilter.vue";



export default {
  name: 'system-activity-logs',

  description: 'System Activity Logs',

  setup() {
    // Use Vuex store
    const store = useStore();

    return {


      params: '',

      formattedTime : computed(()=>store.getters.formattedTime)
    }
  },

  data: () => ({

    hasData : false,

    showModal : false,

    isShowFilter: false,

    columns: ['module', 'event', 'role','performed_by', 'created_at', 'description'],

    options: {},

    apiUrl:'api/activitylogs',

    tableKey: 0,

    appliedFilters: {},

    filterOptions: [
      {
        section : [

          {
            name: 'log_name',
            url: 'api/module/list',
            label: 'module',
            className: 'col-sm-4',
          },

          {
            name: 'event',
            url: 'api/event/list',
            label: 'event',
            className: 'col-sm-4'
          },

          {
            name: 'performed_by',
            url: 'api/performedby/list',
            label: 'performed_by',
            className: 'col-sm-4'
          },
        ]
      },
      {
        section: [

          {
            name: 'created_at',
            type: 'date',
            label: ['created_at', 'created_within_last'],
            timeOptions:{  start: '00:00', step: '00:30',  end: '23:30' },
            range : true
          }

        ]
      }
    ]
  }),

  // For filter update event
  created() {
    window.emitter.on('updateFilter', this.updateFilter);
  },

  computed: {
    apiEndPoint() {

      return this.apiUrl
    },
  },

  beforeMount() {

    this.filterData();

    this.fetchLogs();

    const self= this;

    // Define options for the data table component
    this.options ={

      headings :{

        module:  this.trans('module'),

        event:   this.trans('event'),

        role:   this.trans('role'),

        created_at:  this.trans('created_at'),

        performed_by: this.trans('performed_by'),

        description:  this.trans('description'),
      },

      columnClasses :{
        module:  'module',

        event:    'event',

        role:    'role',

        created_at:  'created-at',

        performed_by:  'performed-by',

        description:   'description',


      },

      sortIcon: {

        base: 'glyphicon',

        up:  'glyphicon-chevron-down',

        down: 'glyphicon-chevron-up'
      },

      texts: {filter:'' ,limit: ''},

      templates: {

        module(h,row){
          return row.log_name;
        },

        event : function(createElement, row) {

          let span = self.h('span', {

            'class' : row.event !== 'Created' ? ( row.event === 'Updated' ? 'btn btn-warning btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal') :'btn btn-success btn-sm pointer_normal'}, row.event);

          return self.h('a', { class: 'pointer_normal' }, [span]);
        },

        role(h,row){
          return row.causer ? row.causer.role : '---';
        },

        performed_by(h, row) {
          if (row.performed_by) {
            return this.h(ActivityParser, { data: row.performed_by });
          } else {
            return '---';
          }
        },


        created_at(h, row) {
          return self.formattedTime(row.created_at);
        },

        description(h, row) {
          if (row.description) {
            return this.h(DetailedLog, { data: row.description, info: row.detailed_properties, scenario: row.event, logName: row.log_name});
          } else {
            return '---';
          }
        }

      },

      sortable : ['module','event','created_at'],

      filterable : ['module', 'event','role'],

      pagination: {chunk:5,nav: 'fixed',edge:true},

      requestAdapter(data) {

        return {

          'sort-field' : data.orderBy ? data.orderBy : 'id',

          'sort-order' : data.ascending ? 'desc' : 'asc',

          'search-query' : data.query.trim(),

          page : data.page,

          limit : data.limit,
        }
      },

      responseAdapter({data}) {

        return {
          data: data.data.data.map(data => {
            return data;
          }),

          count: data.data.total
        }
      },

	    orderBy: { column: 'id', ascending: true },
    }
  },

  methods: {

    async fetchLogs() {
      try {
        const response = await axios.get(this.apiUrl + '?sort-field=id');
        this.hasData = response.data.data.total;
      } catch (error) {
        errorHandler(error, 'dataTableModal');
      }
    },

    async refreshData() {
      await this.fetchLogs();
      this.tableKey++;
    },

    onClose(){

      this.showModal = false;
    },

    showDeleteModal(){

      this.showModal = true;
    },

    // Update the filter based on emitted event

    updateFilter(data) {

      this.filterOptions.map(function (obj) {

        obj.section.map(function (row) {

          if (data.name === row.name) {

            row.value = data.value;
          }
        })
      });
    },

    // Initialize/reset filter options
    filterData() {

      this.filterOptions.map(function (obj) {

        obj.section.map(function (row) {

          row.elements = [];
          row.isMultiple = true;
          row.isPrepopulate = false;
          row.value = '';
          row.className = 'col-sm-4';

        })
      });
    },

    selectedFilters(value){

      if(value === 'closeEvent') {

        return this.isShowFilter = false;
      }
      if(value === 'resetEvent') {

        return this.resetFilter();
      }

      return this.applyFilter(value);
    },

    resetFilter() {
      this.apiUrl = 'api/activitylogs';

      // Reset filter options to their initial state
      this.filterOptions = this.filterOptions.map(function (obj) {
        return {
          section: obj.section.map(function (row) {
            row.elements = [];
            row.isMultiple = true;
            row.isPrepopulate = false;
            row.value = '';
            row.className = 'col-sm-4';
            return row;
          }),
        };
      });

      // Hide the filter view if it's currently open
      this.isShowFilter = true;
    },



    // Apply filters and update API URL
    applyFilter(value) {

      this.appliedFilters = value;

      let baseUrlForFilter = 'api/activitylogs?';

      let params = "";

      if (value.log_name) {
        params = this.commonMethod(0,0, "module", value.log_name, params);
      }

      if (value.event) {
        params = this.commonMethod(0,1, "event", value.event, params);
      }

      if (value.performed_by) {
        params = this.commonMethod(0,2, "performed_by", value.performed_by, params);
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

      this.params = params;

    },

    commonMethod(section, i, key, value, param) {
      var params;

      params = param;

      this.filterOptions[section].section[i].value = value;

      value.forEach(function(element, index) {
        params += key + "[" + index + "]=" + (key === 'performed_by' ? element.id : element.name) + "&";
      });

      return params;
    },


    toggleFilterView() {

      this.isShowFilter = !this.isShowFilter;
    },
    triggerExport(){

      axios.get('/api/export/logs?'+ this.params).then(
          res => {
            successHandler(res, 'dataTableModal')
          }
      ).catch( err => {
        errorHandler(err, 'dataTableModal')
      })
    }
  },
  components: {
    LogModal,
DataTableFilter,
 DeleteLog,
    DataTableActions,
    DetailedLog,
    HyperLinkInstance,
    TableView
  }
}
</script>
