<template>
  <div class="col-sm-12">
    <!-- Alert -->
    <alert componentName="report-home-page" />

    <custom-loader v-if="isLoading" :duration="4000"></custom-loader>

    <div v-if="reportList.length > 0">
      <div class="card card-light " v-for="reportCategory in reportList" :key="reportCategory.id">
        <div class="card-header">
          <h3 class="card-title">{{reportCategory.category}}</h3>
        </div>
        <div class="card-body">
            <div class="row">
              <div class="col-sm-4" v-for="report in reportCategory.reports" :key="report.id">
                  <div class="card report-body bg-light d-flex flex-fill">
                    <div class="card-header text-muted border-bottom-0 pb-0 pt-0 row">
                      <div class="card-title col-sm-12">
                        <div class="row">
                          <div class="col-sm-11 p-0">
                            <div class="fa-stack fa-1x resize-icon">
                              <i :class="getIconClass(report.iconClass)" :style="{'color' : report.iconColor}"></i>
                            </div>
                            <router-link :to="viewReport(report.view_url)" class="text-header">
                              <b>{{report.name}}</b>
                            </router-link>
                            <sup class="badge-style">
                              <span class="badge text-bg-info" v-if="report.is_default">{{lang('default')}}</span>
                              <span class="badge text-bg-success" v-else-if ="report.is_public">{{lang('public')}}</span>
                              <span class="badge text-bg-danger" v-else >{{lang('private')}}</span>
                            </sup>
                          </div>
                          <div class="col-sm-1 p-0">
                            <div class="card-tools float-end">

                              <div class="btn-group">

			                        <span>

			                        	<button v-if="!report.is_default" type="button" class="btn btn-tool" v-tooltip="trans('action')" data-bs-toggle="dropdown">
			                        		<i class="fas fa-ellipsis-v"></i>
			                        	</button>

			                        	<div class="dropdown-menu dropdown-menu-end custom-dropdown-menu">

<!--			                        		<a class="dropdown-item text-dark" href="javascript:;" @click="viewReport(report.view_url)">
                                    <i class="fas fa-eye"></i>&nbsp;{{trans('view')}}
                                  </a>-->

			                        		<a class="dropdown-item text-dark" href="javascript:;" @click="editReport(report.id, report.category)">
                                    <i class="fas fa-edit"></i>&nbsp;{{trans('edit')}}
                                  </a>

			                        		<a v-if="report.is_deleteAble" class="dropdown-item text-dark" href="javascript:;" @click="deleteCustomReport(report.id, report.category)">
                                    <i class="fas fa-trash"></i>&nbsp;{{trans('delete')}}
                                  </a>
			                        	</div>
			                        </span>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="card-body pt-1 pb-0">
                      <div class="row">
                        <div class="col-sm-12">
                          <p class="text-muted text-sm">
                            {{subString(report.description, 180)}}
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
              </div>
            </div>
        </div>
      </div>
      <save-report-modal v-if="showEditModal" :on-close="onClose" :from="from" :report-data-obj="reportData" modal-mode="update"></save-report-modal>

      <report-delete-modal v-if="showDeleteModal" :showModal="showDeleteModal" :type="type" :on-close="closeDeleteModal" :report-id="reportId" :report-type="reportType"></report-delete-modal>
    </div>
  </div>

</template>

<script>

import axios from 'axios';
import { errorHandler, successHandler} from "../../../../../resources/assets/js/helpers/responseHandler";
import {useStore} from "vuex"
import {computed} from "vue";
import { getSubStringValue } from '../../../../../resources/assets/js/helpers/extraLogics'
import SaveReportModal from "./SaveReportModal.vue";

import {getValidFilterObject} from "../helpers/utils";
import ReportDeleteModal from "./Common/ReportDeleteModal.vue";

export default {

  name: 'report-home-page',
  components: {

    SaveReportModal,
    'report-delete-modal' : ReportDeleteModal
  },

	setup() {

		const store = useStore();

		return {

			formattedTime : computed(()=>store.getters.formattedTime)
		}
	},

  data: () => {
    return {
      reportList: [],
      isLoading: false,
      showDeleteModal: false,
      showEditModal: false,
      reportData: '',
      reportId:'',
      reportType:'',
      refreshReport : false,
      from: '',
      type: ''
    }
  },

  beforeMount() {
    let currentPath = window.location.pathname;
    this.type = ''
    const indexReports = currentPath.indexOf('/reports/'); // Find the index of '/reports/' in the pathname

// Check if '/reports/' is found in the pathname
    if (indexReports !== -1) {
      // Extract the value after '/reports/'
      this.type = currentPath.substring(indexReports + '/reports/'.length); // Adding length of '/reports/' to skip it
    }

    this.getReportList(this.type);
  },

  created() {

    window.emitter.on('refreshReportHomePage', ()=>this.refreshReport = true)
  },

  methods: {

    viewReport(value){
      return value.replace(/^\/?reports\//, '');
    },

    editReport(value, type){

      this.from = type === "ServiceDesk Analysis" ? 'sd_report_home' : 'report-list';

      let params = {};
      params.include_filters = 1;

      axios.get('api/agent/report-config/' + value, { params: params })
          .then(res => {
            this.reportData = res.data.data;
            this.showEditModal = true;
          }).catch(err => {
        errorHandler(err, 'report-home-page');
      }).finally(res => {
        this.isLoading = false;
      });

    },

    getIconClass(value) {

      return value == 'fa fa-support fa-stack-1x' ? 'fas fa-life-ring fa-stack-1x' : value == 'fa fa-bank fa-stack-1x' ? 'fas fa-university  fa-stack-1x' : value+ ' fa-stack-1x';
    },

    getReportList(type) {

      let params = '';
      if (type === 'public' || type === 'private' || type === 'default' || type === 'shared') {
        params = `is_${type}=1`;
      }
      this.isLoading = true;
      axios.get(`api/agent/report-list?${params}`)
      .then(res => {
        if(res.data.data){
          this.reportList = res.data.data;
        }else{
          this.$router.push({ path: '/reports'});
        }
      }).catch(err => {
        errorHandler(err, 'report-home-page');
      }).finally(res => {
        this.isLoading = false;
      });
    },

    subString(value,length){

      return getSubStringValue(value,length)
    },

    deleteCustomReport(value,type) {
      this.reportId = value;
      this.reportType = type;
      this.showDeleteModal = true;
    },

    onClose(){
      this.showEditModal = false;
      this.$store.dispatch('unsetAlert');
    },

    closeDeleteModal(){
      this.showDeleteModal = false;
    }

  },

  watch:{

    refreshReport(newValue, oldValue){
      if(newValue === true){
        this.getReportList(this.type);
      }

      this.refreshReport = false;
    }

  },
};
</script>

<style lang="css" scoped>
  .report-modify {
    position: relative;
    left: 68px;
  }

  .text-header{
    font-size: 15px;
  }

  .text-header:hover{
    color: #3c8dbc;
    cursor: pointer;
  }

  .resize-icon{
    width: 38px !important;
    font-size: 25px !important;
  }

  .report-body{
    height: 150px !important;
  }

  @media (max-width: 900px) {
    .report-body {
      min-height: 270px !important; /* Adjust minimum height for screens up to 900px */
    }
  }

  @media (max-width: 600px) {
    .report-body {
      min-height: 100px !important; /* Adjust minimum height for screens between 700px and 900px */
    }
  }

  @media (max-width: 500px) {
    .report-body {
      min-height: 100px !important; /* Adjust minimum height for screens between 700px and 900px */
    }
  }

  .custom-dropdown-menu{
    position: absolute;
    top: -5px !important;
    left: 0px;
    will-change: transform;
  }

  .badge-style{
    padding-left: 3px;
    vertical-align: -5px;
  }

  .ml-6 { margin-left: 6px; }

  .fw-500 { font-weight: 500 !important; }
</style>