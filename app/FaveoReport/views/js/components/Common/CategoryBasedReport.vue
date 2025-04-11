
<template>
  <div>
	 <!-- Loader -->
	 <loader v-if="isLoading" :duration="4000"></loader>

	 <div class="row mb-3">
		
		<div class="col-sm-12">

			<!-- category dropdown -->
			<div class="btn-group float-end" v-if="categories && categories.length">
			
				<button type="button" class="btn btn-sm btn-light dropdown-toggle text-capitalize" data-bs-toggle="dropdown"
					id="category-dropdown">
					{{lang(categoryPrefix) }} {{selectedCategory}}
				</button>

				<div class="dropdown-menu dropdown-menu-end" style="" aria-labelledby="category-dropdown">
				
					<template v-for="(item, index) in categories" :key="index">
						
						<a class="dropdown-item text-capitalize" @click="onCategoryChange(item)" href="javascript:;" 
							:class="selectedCategory === item ? 'active' : ''">
							{{lang(categoryPrefix)}} {{item}}
						</a>
					</template>
				</div>
			</div>

			<!-- Chart types -->
			<div class="float-end btn-group">
				
				<button class="btn btn-sm btn-light dropdown-toggle" id="chart-type-dropdown" data-bs-toggle="dropdown">
					{{ lang('chart_type') }}
				</button>

			  <div class="dropdown-menu dropdown-menu-end" style="" aria-labelledby="chart-type-dropdown">

					<template v-for="item in chartTypes" v-bind:key="item">
						
						<a class="dropdown-item" href="javascript:;" @click="onChangeChartType(item)" 
							:class="selectedChartType === item ? 'active' : ''">
							{{lang(categoryPrefix)}} {{lang(item)}}
						</a>
					</template>
				</div>
			</div>
		</div>
	 </div>

		<div class="data-widget">
	 	
	 	 	<data-widget v-if="widgetDataApi" :data-widget-data="dataWidgetData" />
	 	</div>

	 <div class="row">
		  <!-- Chart panels -->
		  <div :class="layoutClass" v-for="panel in chartApiData" v-bind:key="panel.id">

			<div class="card card-light ">

				<div class="card-header">
					
					<h3 class="card-title">{{panel.panelTitle}}</h3>
				</div>
				
				<div class="card-body">

					<faveo-chart :chart-data="panel" :chart-type="selectedChartType" />
				</div>
			</div>
		  </div>
	 </div>

  </div>

</template>

<script>
import axios from 'axios';
import { lang, boolean, getIdFromUrl} from "../../../../../../resources/assets/js/helpers/extraLogics";
import { parseCategoryBasedChartApiData} from "../../../../../../resources/assets/js/ChartFactory/utils";
import { errorHandler, successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
import { getValidFilterObject } from '../../helpers/utils';
import TicketFilter from "../../../../../../resources/assets/js/components/Agent/tickets/filters/TicketFilter.vue";
import TimeSeriesChart from "./TimeSeriesChart.vue";
import FaveoChart from "../../../../../../resources/assets/js/ChartFactory/FaveoChart.vue";
import DataWidget from "../../../../../../resources/assets/js/components/Common/DataVisualization/DataWidget.vue";

export default {

  name: 'category-based-report',

  components: {
	 'ticket-filter': TicketFilter,
	 'time-series-chart': TimeSeriesChart,
	 'faveo-chart': FaveoChart,
	 'data-widget': DataWidget
  },

  props: {

	 // Api endpoint to fetch category based charts
	 categoryChartDataApi: {
		type: String,
		default: () => ''
	 },

	 // Api endpoint to fetch time series charts
	 timeSeriesChartDataApi: {
		type: String,
		default: () => ''
	 },

	 widgetDataApi: {
		type: String,
		default: () => undefined
	 },

	 // Array of categories; decides the current view of chart
	 categories: {
		type: Array,
		default: () => []
	 },

	 // Default category
	 defaultCategory: {
		type: [Number, String],
		default: () => undefined
	 },

	 /**
	  * string to show in the category dropdown
	  * used as key for fetching data from server basis of category
	  */
	 categoryPrefix: {
		type: String,
		default: ''
	 },

	 defaultChartType: {
		type: String,
		default: 'bar'
	 },

	 layoutClass: {
		type: String,
		required: true
	 },

	 // Defualt filter field value objec
	 filterParams: {
		type: Object,
		default: () => {}
	 },

	 reportIndex: {
		type: Number,
		required: true
	 }

  },

  data: () => {
	 return {

		// selected chart type, default is bar chart
		selectedChartType: '',

		// selected caytegory option
		selectedCategory: '',

		// some of the chart types supported by chart js
		chartTypes: ['bar', 'horizontal_bar', 'pie', 'doughnut'],

		isLoading: true,
		chartApiData: null, // Api response chart data
		dataWidgetData: null,
    reportId: null
	 }
  },

  beforeMount() {

    // const path = window.location.pathname;
    //
    // this.reportId = getIdFromUrl(path);

	 // Assign defualt category to selected category
	 this.selectedCategory = this.defaultCategory;

	 this.selectedChartType = this.defaultChartType;

	 // Make api call to fetch chart data
	 this.getDataFromServer();
  },

  methods: {

	 getColumnClass() {
		return getColumnClass()
	 },

	 // Fetch data from server
	 getDataFromServer() {
		this.isLoading = true;

		// Fetch data widget data if datawidget api endpoint provided 
		if(boolean(this.widgetDataApi)) {
		  axios.get(this.widgetDataApi, { params: this.getUrlParams() })
		  .then(res => {
			 this.dataWidgetData = res.data.data;
        this.updateDataCount('widget', this.dataWidgetData );
		  })
		  .catch(err => {
			 errorHandler(err, 'category-based-report');
		  })
		}

		axios.get(this.categoryChartDataApi , { params: this.getUrlParams() })
		.then(res => {
		  this.chartApiData = parseCategoryBasedChartApiData(res.data.data);
		  this.isLoading = false;
      this.updateDataCount('chart', this.chartApiData);
		})
		.catch(err => {
		  errorHandler(err, 'category-based-report');
		})

	 },

    updateDataCount(type, value){

      let allChartParamsEmpty = false;
      let allWidgetsZero = false;

      if(type === 'chart'){
        allChartParamsEmpty = value.every(chart => chart.data.length === 0);
      }

      if(type === 'widget'){
        allWidgetsZero = value.every(widget => widget.value === 0);
      }

      this.$emit('showReports', !((allChartParamsEmpty) || (allWidgetsZero)));
    },

	 // Fetch chart data basis of category
	 onCategoryChange(value) {
		this.selectedCategory = value;
		this.$emit('updateChangedValue', this.selectedCategory, this.reportIndex, 'selected_view_by');
		this.getDataFromServer();
	 },

	 onChangeChartType(value) {
		this.selectedChartType = value;
		this.$emit('updateChangedValue', this.selectedChartType, this.reportIndex, 'selected_chart_type');
    // this.passChartDetails(value)
	 },

    // passChartDetails(chart){
    //
    //   let data = {}
    //
    //   data['report_id'] = this.reportId;
    //
    //   data['chart_type'] = chart;
    //
    //   axios.post('api/report/update/chart-type', data ).then(res => {
    //
    //   }).catch(err => {
    //
    //     errorHandler(err, 'sd-reports-view');
    //
    //   })
    // },


	 /**
	  * get Url parameters
	  * may contain slected filter values, selected category limit
	  */
	 getUrlParams() {
		let params = getValidFilterObject(this.filterParams);

		// set category type for fetching chart data, if categoryPrefix is valid
		if(typeof this.categoryPrefix !== 'undefined') {
		  params[this.categoryPrefix] = this.selectedCategory;
		}
		return params;
	 }
  },

  watch: {
	 filterParams(){
		this.getDataFromServer();
	 }
  }

}
</script>

<style lang="css" scoped>
.btn-group {
  padding-left: 3px;
  padding-right: 3px;
}
.report-box-primary {
  padding: 0px !important;
}
.ml-10 { margin-left : 11px;}
</style>