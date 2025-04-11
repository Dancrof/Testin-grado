<template>

  <div class="col-sm-12">

    <alert componentName="dataTableModal"/>

    <div class="card card-light" v-if="hasDataPopulated">

      <div class="card-header">

        <h3 class="card-title">{{trans('schedule')}}</h3>

        <div class="card-tools">

          <a id="advance-filter-btn" class="btn btn-tool" @click = "toggleFilterView" v-tooltip="trans('filter')"
             href="javascript:;">

            <span class="glyphicon glyphicon-filter"></span>
          </a>
        </div>
      </div>

      <div class="card-body" id="schedule_list">

        <schedule-filter id="filter-box" v-if="isShowFilter" :metaData="filterOptions" :appliedFilters="appliedFilters"
                         @selectedFilters="selectedFilters"  @scheduleByChanged="handleScheduleByChanged">

        </schedule-filter>

        <section v-for="report in columnData" :key="report">

          <user-column-list :table-columns="report.columns" :reportId="report.id" :columnId="newReportId"/>

          <dynamic-datatable
              v-if="columns.length" :data-url="apiUrl" :columns="visibleColumns"
              :columnsMeta="report.columns" :staticColumns="staticColumns" :deleteMessage="deleteMessage"
          >

          </dynamic-datatable>

        </section>
      </div>

    </div>


  </div>

</template>

<script>

import {boolean, getApiParamsFromArray} from "../../../../../../resources/assets/js/helpers/extraLogics";
import DataTableFilter from "../../../../../../resources/assets/js/components/Extra/DataTableFilter.vue";
import userColumnList
  from "../../../../../../resources/assets/js/components/Agent/User/View/MiniComponents/UserColumnList.vue";
import DynamicDatatable from "../../../../../../resources/assets/js/components/Extra/DynamicDatatable.vue";
import axios from "axios";
import {errorHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";

export default {
  name: "AllScheduleList",

  description: 'Schedule list component',

  data(){
    return{

      columns:[],

      hasDataPopulated: false,

      visibleColumns:{},

      staticColumns: ['actions'],

      reportType:'schedule-report',

      apiUrl:'/schedules',

      filterOptions:[
        {
          section:[
            {
              name:'report_type',
              url:'/api/report-types',
              label: 'report_type'
            },
            {
              name:'user_id',
              url:'/api/dependency/users',
              label: 'notify_assign'
            },
            {
              name:'scheduled_by',
              label:'schedule_by',
              type:'static-select',
              elements:[
                {id:'daily',name:'Daily'},
                {id:'weekly',name:'Weekly'},
                {id:'monthly',name:'Monthly'},
              ]
            },
          ]
        },
        {
          section:[
            {
              name: 'executed_at',
              type: 'time',
              label: 'execute_at',
              timeOptions:{  start: '00:00', step: '00:30',  end: '23:30' },
              range : true,
              placeholder:"select_date",
            },
            {
              name:'status',
              label:'status',
              type:'static-select',
              elements:[
                {id:1,name:'Active'},
                {id:0,name:'Inactive'},
              ]
            },
            {
              name: 'created_at',
              type: 'date',
              label: ['created_at', 'created_within_last'],
              timeOptions:{  start: '00:00', step: '00:30',  end: '23:30' },
              range : true
            },
          ]
        },{
          section:[
            {
              name: 'updated_at',
              type: 'date',
              label: ['updated_at', 'updated_within_last'],
              timeOptions:{  start: '00:00', step: '00:30',  end: '23:30' },
              range : true
            },
          ],
        }],

      options:{},

      isShowFilter : false,

      appliedFilters : {},

      columnData: null,

      scheduleData:'',

      loading: true,

      newReportId: '',

      deleteMessage: 'are_you_sure_you_want_to_delete_this_schedule_report'
    }
  },

  created(){

    //Listner for columns
    window.emitter.on("onColumnUpdate", this.onColumnUpdate);
    //Listner for filter's
    window.emitter.on('updateFilter', this.updateFilter);
  },

  beforeMount() {

    this.filterData();

    this.getScheduleData();
  },

  methods:{

    handleScheduleByChanged(value){

        // Remove the monthly filter section if it exists
        if (this.filterOptions[2].section) {

          const monthlyIndex = this.filterOptions[2].section.findIndex(
              (section) => section.name === 'monthly'
          );
          if (monthlyIndex !== -1) {
            this.filterOptions[2].section.splice(monthlyIndex, 1);
          }
        }

        // Remove the weekly filter section if it exists
        if (this.filterOptions[2].section) {
          const weeklyIndex = this.filterOptions[2].section.findIndex(
              (section) => section.name === 'weekly'
          );
          if (weeklyIndex !== -1) {
            this.filterOptions[2].section.splice(weeklyIndex, 1);
          }
        }

      if (value === 'Monthly') {
        const monthlyArray = {
          name: 'monthly',
          label: 'monthly',
          className: 'col-sm-4',
          isMultiple: true,
          elements: [
            ...Array.from({ length: 31 }, (_, i) => ({
              id: i + 1,
              name: i + 1,
            })),
          ],
        };

        if (!this.filterOptions[2].section) {
          this.filterOptions[2].section = [];
        }

        // Add the new filter section to the beginning of the section array
        this.filterOptions[2].section.push(monthlyArray);
      }

      if (value === 'Weekly') {
        const weeklyArray = {
          name: 'weekly',
          label: 'weekly',
          className: 'col-sm-4',
          isMultiple: true,
          elements: [
            { id: 'Monday', name: 'Monday' },
            { id: 'Tuesday', name: 'Tuesday' },
            { id: 'Wednesday', name: 'Wednesday' },
            { id: 'Thursday', name: 'Thursday' },
            { id: 'Friday', name: 'Friday' },
            { id: 'Saturday', name: 'Saturday' },
            { id: 'Sunday', name: 'Sunday' },
          ],
        };

        if (!this.filterOptions[2].section) {
          this.filterOptions[2].section = [];
        }

        // Add the new filter section to the beginning of the section array
        this.filterOptions[2].section.push(weeklyArray);
      }
    },

    updateFilter(data) {

      this.filterOptions.map(function (obj) {

        obj.section.map(function(row){

          if(data.name == row.name) {

            row.value = data.value;
          }
        })
      });
    },

    updateFilterMeta(data) {

      this.filterOptions.map(function (obj) {

        obj.section.map(function(row){

          row.value = data[row.name] ? data[row.name] : '';
        })
      });
    },

    getScheduleData() {

      this.hasDataPopulated = false;

      // Fetch schedule report data from the API
      axios.get('api/agent/report-config/schedule-report')
          .then(res => {

            this.newReportId = res.data.data.id;

            this.columnData = res.data.data.sub_reports;

            this.hasDataPopulated = true;

            // Iterate through sub_reports and retrieve column information
            this.columnData.forEach(subReport => {
              subReport.columns.forEach(column => {
              });
              // Set the columns property with the columns from the last sub_report
              this.columns = subReport.columns;
            });

            // Update the visibility of columns
            this.columns.map(column => {
              // Convert column's is_visible property to a boolean
              column.is_visible = column.is_visible ? true : false;
            });

            // Trigger a method to update visible columns
            this.updateVisibleColumns();

          }).catch(err => {
        // Handle errors
        this.hasDataPopulated = true;
        this.columns = [];
        errorHandler(err); // Handle the error with the errorHandler function
      });
    },

    onColumnUpdate(columns) {

      this.columns = columns;

      this.updateVisibleColumns();
    },

    updateVisibleColumns() {

      this.visibleColumns = {};

      this.columns.map(column => {
        if(boolean(column.is_visible)){
          this.visibleColumns[column.key] = column.label;
        }
      });
    },

    filterData(){

      this.filterOptions.map(function (obj) {

        obj.section.map(function(row){

          row.elements=row.type === 'static-select' ? row.elements : [];
          row.isMultiple = row.type === 'static-select' ? false : true;
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

      return this.applyFilter(value)
    },

    resetFilter(){

      this.apiUrl = '/schedules';

      this.filterOptions = this.filterOptions.map(function (obj) {

        obj.section.map(function(row){

          row.elements = row.type === 'static-select' ? row.elements : [];
          row.isMultiple=row.type === 'static-select' ? false : true;
          row.isPrepopulate = false;
          row.value = '';
          row.className = 'col-sm-4';
        })

        return obj;
      });
    },

    applyFilter(value){

      if(value.scheduled_by === null){
        if(this.filterOptions[2].section[1]){
          this.filterOptions[2].section.splice( 1, 1)
        }
      }

      this.updateFilterMeta(value);

      this.appliedFilters = value;

      let baseUrlForFilter = '/schedules?';

      let params = getApiParamsFromArray(this.filterOptions,value);

      if(params[params.length-1] === '&') {
        params = params.slice(0, -1);
      }

      this.apiUrl = baseUrlForFilter + params;

      this.isShowFilter = false;
    },

    toggleFilterView() {

      this.isShowFilter = !this.isShowFilter;
    },
  },

  components: {
    'schedule-filter': DataTableFilter,

    'user-column-list': userColumnList,

    'dynamic-datatable': DynamicDatatable
  },
}
</script>

<style scoped>
#schedule_list .VueTables .table-responsive {
  overflow-x: auto;
}
</style>