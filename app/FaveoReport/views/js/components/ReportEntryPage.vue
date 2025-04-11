<template xmlns="http://www.w3.org/1999/html">
  <div class="col-sm-12" id="hd-report-template">
    <!-- Alert -->
    <alert componentName="report-entry-page" />

    <custom-loader v-if="isLoading" :duration="4000"></custom-loader>

    <div class="card card-light  report-box-primary" v-if="reportConfigObj">

      <div class="card-header">

        <h3 class="card-title">{{reportConfigObj.name}}
              <a v-if="reportConfigObj.helplink" :href="reportConfigObj.helplink" target="__blank">
                <tool-tip slot="headerTooltip" :message="lang('click_to_see_how_to_read_this_report')" size="medium"></tool-tip></a>
        </h3>

        <div class="card-tools">

          <div class="btn-group">
            <template v-if="customFilters.length">

              <infinite-dropdown
                  v-for="filter in customFilters" :key="filter.label"
                  :event-key="filter.eventKey"
                  :api="filter.api" :limit="filter.limit"
                  :id="filter.label" :label="filter.label"
                  v-on:[filter.eventKey]="customFilterHandler"
              />

            </template>

            <button type="button" class="btn btn-tool" v-tooltip="lang('report_config_filter')" @click="toggleFilterView()">

              <i class="glyphicon glyphicon-filter"></i>
            </button>

            <!-- Export -->
            <button v-if="showExportButton && dataCount" id="export-report"  class="btn btn-tool" @click="exportReport"
                    v-tooltip="lang('export')">

              <i class="fas fa-paper-plane" aria-hidden="true"></i>
            </button>

            <button v-if="!showExportButton && showReport"
                    id="graphical-report" class="btn btn-tool" @click="exportGraphicalReport" v-tooltip="lang('export')">
              <i class="fas fa-paper-plane" aria-hidden="true"></i>
            </button>

	          <button v-if="showExportButton && dataCount" id="schedule-report" class="btn btn-tool" @click="scheduleList()"
	                   v-tooltip="lang('schedule')">

		          <i class="fas fa-calendar" aria-hidden="true"></i>
	          </button>

          </div>

<!--          <button type="button" class="btn btn-tool" v-tooltip="lang('Report configuration/filter')" @click="toggleFilterView()">-->

<!--            <i class="fas fa-filter"></i>-->
<!--          </button>-->

<!--            &lt;!&ndash; Export &ndash;&gt;-->
<!--            <button v-if="showExportButton && dataCount" id="export-report"  class="btn btn-tool" @click="exportReport"-->
<!--              v-tooltip="lang('export')">-->

<!--              <i class="fas fa-paper-plane" aria-hidden="true"></i>-->
<!--            </button>-->

      </div>
    </div>

      <div class="card-body">

        <!-- Filter -->
        <ticket-filter  v-if="isShowFilter" v-on:filter="setFilter" :isApplyOnlyMode="true" :prefilled-filter-object="filterParams"
          filter-dependencies-api-endpoint="/api/agent/filter-dependencies" :showFilter="isShowFilter"
          :closeFilterView="toggleFilterView" :filterNumber="filterId">

        <!-- filter operation button group -->
          <template #filter-operation-btn-group>
            <button class="btn btn-primary" v-if="!reportConfigObj.is_default" @click="forkUpdateAction('update')">
              <i class="fas fa-edit" aria-hidden="true"></i>
              &nbsp;{{lang('edit')}}
            </button>
            <button class="btn btn-primary" @click="forkUpdateAction('fork')">
              <i class="fas fa-save" aria-hidden="true"></i>
              &nbsp;{{lang('save')}}
            </button>
          </template>

        </ticket-filter>

      <div :key="randKey">
        <section v-for="(report, reportIndex) in reportConfigObj.sub_reports" :key="report.id">

          <!-- DATATABLE -->
          <tabular-report-layout v-if="report.data_type === 'datatable'" :data-url="report.data_url"
                                 :table-columns="report.columns" :sub-report-id="report.id" :export-url="reportConfigObj.export_url"
                                 :add-custom-column-url="report.add_custom_column_url" delete-custom-column-url="api/delete-custom-column"
                                 :short-code-url="'api/report-shortcodes/' + reportConfigObj.type" :filterParams="filterParams"
                                 :report-index="reportIndex" :report-id="reportId">
          </tabular-report-layout>

          <!-- CATEGORY CHART -->
          <category-based-report v-if="report.data_type === 'category-chart'" :category-chart-data-api="report.data_url"
                                 :widget-data-api="report.data_widget_url" :categories="report.list_view_by"
                                 :default-category="report.selected_view_by" :default-chart-type="report.selected_chart_type"
                                 category-prefix="view_by" :layout-class="getLayoutClass(report.layout)" :filterParams="filterParams"
                                 :report-index="reportIndex" @updateChangedValue="updateChangedValue" @showReports="handleExport">
          </category-based-report>

          <!-- TIME SERIES CHART -->
          <time-series-chart v-if="report.data_type === 'time-series-chart'" :chart-data-api="report.data_url"
                             :data-widget-api="report.data_widget_url" :categories="report.list_view_by"
                             :default-category="report.selected_view_by" :filterParams="filterParams" :report-index="reportIndex"
                             @updateChangedValue="updateChangedValue" @showReports="handleExport">
          </time-series-chart>

        </section>
      </div>

    </div>
</div>
    <save-report-modal v-if="openSaveReportModal" :onClose="closeSaveReportModal"
      :reportDataObj="clonedReportConfigOnj" :modal-mode="modalMode" />

  </div>
</template>

<script>

import axios from 'axios';
import { getIdFromUrl } from "../../../../../resources/assets/js/helpers/extraLogics";
import { errorHandler, successHandler } from "../../../../../resources/assets/js/helpers/responseHandler";
import { getFilterObjectToArray, getValidFilterObject, getColumnClass } from "../helpers/utils";
import InfiniteDropdown from "../../../../../resources/assets/js/components/MiniComponent/InfiniteDropdown.vue";
import TicketFilter from "../../../../../resources/assets/js/components/Agent/tickets/filters/TicketFilter.vue";
import TabularReportLayout from "./Common/TabularReportLayout.vue";
import TimeSeriesChart from "./Common/TimeSeriesChart.vue";
import CategoryBasedReport from "./Common/CategoryBasedReport.vue";
import SaveReportModal from "./SaveReportModal.vue";
import ToolTip from "../../../../../resources/assets/js/components/MiniComponent/ToolTip.vue";
import * as htmlToImage from 'html-to-image';

export default {

  name: 'report-entry-page',

  components: {
    'ticket-filter': TicketFilter,
    'tabular-report-layout': TabularReportLayout,
    'time-series-chart': TimeSeriesChart,
    'category-based-report': CategoryBasedReport,
    'save-report-modal': SaveReportModal,
    "tool-tip": ToolTip,
    InfiniteDropdown
  },

  data: () => {
    return {
      reportConfigObj: null,
      clonedReportConfigOnj: null, // usded to save/update report
      isLoading: true,
      openSaveReportModal: false,
      modalMode: '',
      filterParams: {},
      isShowFilter : false,
      dataCount : 0,
      randKey: Math.floor(Math.random() * 11111),
      customFilters: [],
	    reportId:'',
      requiredPayload:[],
      scheduleData:'',
      showReport: false,
	    filterId: ''
    }
  },

  beforeMount() {
    let pathname = window.location.pathname;

    let splitPath = pathname.split('/');

    if (splitPath.includes('rating-in-depth')) {
      this.customFilters.push({
        eventKey: 'rating', //name of event that is emitted by InfiniteDropdown Component
        label: this.trans('rating_default_rating'),
        api: 'ratings-list',
        limit: 5,
      });
    }

    this.dashboardInit();
  },

  created() {
    window.emitter.on('onReportsColumnUpdate', this.onColumnUpdate);
    window.emitter.on('refreshReportEntryPage', this.dashboardInit);
    window.emitter.on('dataCount',this.getCount)

    window.emitter.on('rating', payload => { this.customFilterHandler(payload); });
  },

  computed: {
    /**
     * function to show export button only in tabular report
     * remove this logic once export in chart will be implemented
     */
    showExportButton: function() {
      if(this.reportConfigObj && Array.isArray(this.reportConfigObj.sub_reports)) {
        for(let i = 0; i < this.reportConfigObj.sub_reports.length; i++) {
          if(this.reportConfigObj.sub_reports[i].data_type === 'datatable') {
            return true;
          }
        }
      }
      return false;
    },
  },

  methods: {

    getCount(value) {

      this.dataCount = value;
    },

    toggleFilterView() {

      this.isShowFilter = !this.isShowFilter;
    },

    dashboardInit() {
      this.getReportConfiguration(getIdFromUrl(window.location.pathname));
    },

    getLayoutClass(layout) {
      return getColumnClass(layout);
    },

    /** Get report configuration object from server */
    getReportConfiguration(reportId) {
      this.isLoading = true;
      let params = getValidFilterObject(this.filterParams);
      params.include_filters = 1;

      this.reportId = reportId

      axios.get('api/agent/report-config/' + reportId, { params: params })
      .then(res => {
        this.reportConfigObj = res.data.data;
        this.scheduleData = res.data.data;
        this.clonedReportConfigOnj = JSON.parse(JSON.stringify(this.reportConfigObj));
		this.filterId = res.data.data.filter_id;

	      if (this.reportConfigObj.sub_reports && Array.isArray(this.reportConfigObj.sub_reports)) {
		      this.reportConfigObj.sub_reports.forEach((item) => {
			      if (Array.isArray(item.columns)) {
				      item.columns.forEach((value) => {
					      if (value.key === 'turn_around_time_department') {
						      value['is_sortable'] = 0;
					      }
				      });
			      }
		      });
	      }

        this.updateFilterObj();
      }).catch(err => {
        errorHandler(err, 'report-entry-page');
      }).finally(res => {
        this.isLoading = false;
      });
    },

    /** Update local copy of filter object with the filter-object recieved form api response */
    updateFilterObj() {
      let filterObj = {};
      if(Array.isArray(this.reportConfigObj.filters)) {
        this.reportConfigObj.filters.forEach(element => {
          filterObj[element.key] = element.value
        });
      }
      this.filterParams = filterObj;
    },

    /** Export report */
    exportReport() {

      const exportPayload = {
        ...this.filterParams, // Copy existing filter parameters
        ['total']: this.dataCount // Add 'total' key with this.dataCount as the value
      };
      this.isLoading = true;
      axios.post(this.reportConfigObj.export_url, exportPayload)
        .then(res => {
          successHandler(res, 'tabular-report-layout');
        })
        .catch(err => {
          errorHandler(err, 'tabular-report-layout');
        }).finally(() => {
          this.isLoading = false;
        })
    },

    /** Emit event for forking the report */
    forkUpdateAction(actionType) {
      window.emitter.emit('performApplyAction');
      this.modalMode = actionType;
      this.openSaveReportModal = true;
    },

    /** close save report modal */
    closeSaveReportModal() {
      this.openSaveReportModal = false;
    },

    /** set filter values to report-config-object */
    setFilter(payload) {
      this.filterParams = JSON.parse(JSON.stringify(payload));
      this.clonedReportConfigOnj.filters = getFilterObjectToArray(this.filterParams);
	  this.schedulePayload = this.clonedReportConfigOnj.filters
    },

    /** Update local copy of `key` property with the updated one */
    updateChangedValue(newValue, reportIndex, key) {
      this.clonedReportConfigOnj.sub_reports[reportIndex][key] = newValue;
    },

    /** Update the local copy of the column list in case of tabular report */
    onColumnUpdate() {

      window.emitter.emit('refreshData');
    },

    customFilterHandler(payload) {

      if (payload.type === 'rating') {

        this.reportConfigObj.sub_reports.forEach((item) => {
          let dataUrl = item['data_url'];
          let widgetUrl = item['data_widget_url'];
          let stringToSplit = '?rating_id=';

          let indexInDataUrl = dataUrl.indexOf(stringToSplit);
          let indexInWidgetUrl = widgetUrl.indexOf(stringToSplit)

          if (indexInDataUrl > 0) {
            dataUrl = dataUrl.substring(0, indexInDataUrl);
          }

          if (indexInWidgetUrl > 0) {
            widgetUrl = widgetUrl.substring(0, indexInWidgetUrl)
          }

          let filterParamToAdd = `?rating_id=${payload.id}`
          item['data_url'] = dataUrl + filterParamToAdd;
          item['data_widget_url'] = widgetUrl + filterParamToAdd;
        })

        this.randKey++;
      }
    },

    scheduleList(){

      this.requiredPayload = JSON.stringify(this.filterParams);

      this.$router.push({path:'/reports/schedule/add/'+this.scheduleData.type+'/'+this.reportId, query:{params: this.requiredPayload}})
    },

    async exportGraphicalReport (){
      const formData = new FormData();
      const element = document.getElementById('hd-report-template');
      const buttons = element.querySelectorAll('.btn-group');

      if(this.isShowFilter === true){
        this.isShowFilter = false;
      }

      // Hide buttons temporarily during canvas generation
      buttons.forEach(buttonGroup => {
        buttonGroup.style.display = 'none';
      });

      const textElements = element.querySelectorAll('h3');
      textElements.forEach(textElement => {
        textElement.style.whiteSpace = 'nowrap';
      });

      try {
        // Generate canvas from HTML element
        const dataUrl = await htmlToImage.toPng(element);

        // Restore the buttons
        buttons.forEach(buttonGroup => {
          buttonGroup.style.display = 'block';
        });

        // Convert canvas to Blob object
        const blob = await fetch(dataUrl).then(res => res.blob());

        // no need to download the image
        // Append the blob to the form data with a key name
        formData.append('report_id', this.reportId );
        formData.append('image', blob, 'report.png');

        this.isLoading = true;

        // Send FormData object with Axios
        const res = await axios.post('api/export/graphical-report', formData);
        successHandler(res, 'report-entry-page');
        this.isLoading = false;
      } catch (err) {
        this.isLoading = false;
        errorHandler(err, 'report-entry-page');
      }
    },

    handleExport(value){

      this.showReport = value;
    }
  }
}
</script>

<style lang="css" scoped>

</style>