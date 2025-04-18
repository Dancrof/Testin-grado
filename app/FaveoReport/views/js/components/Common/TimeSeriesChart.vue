<template>

  <div class="row">

    <div class="col-md-12">
    
      <div class="card card-light " id="chart-panel-main">

        <!-- Panel heading -->
        <div class="card-header">

          <h3 class="card-title">{{chartApiData ? chartApiData.name : ''}}</h3>

          <!-- Category dropdown -->
          <div class="card-tools">

            <div class="btn-group" v-if="categories.length">
              
              <button type="button" class="btn btn-tool dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="true">
                
                <i class="fas fa-eye"></i> {{lang(categoryPrefix)}} <label> {{ lang(selectedCategory)}}</label>
              </button>
              
              <div class="dropdown-menu dropdown-menu-end" role="menu" x-placement="bottom-end">
                
                <template v-for="(item, index) in categories" :key="index">

                  <a :class="selectedCategory === item ? 'active text-light' : 'text-dark'" class="dropdown-item"
                      @click="onCategoryChange(item)" href="javascript:;">
                    {{lang(categoryPrefix) + lang(item)}}
                  </a>
                </template>
              </div>
            </div>
          </div>
        </div>

        <!-- Panel body -- chart area -->
        <div class="card-body">

          <!-- Loader -->
          <loader v-if="isLoading" />

          <div v-else>
            <!-- data widget section if present -->
            <section v-if="dataWidgetApi">
              <data-widget :data-widget-data="dataWidgetData" />
            </section>

            <!-- section for chart -->
            <faveo-chart :chart-data="chartData" :chart-type="'line'" />
          </div>

        </div>

      </div>
    </div>
  </div>
</template>

<script>

import axios from 'axios';
import { getTimeLabels, parseTimeSeriesChartData} from "../../../../../../resources/assets/js/ChartFactory/utils";
import { boolean} from "../../../../../../resources/assets/js/helpers/extraLogics";
import { errorHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
import { getValidFilterObject } from "../../helpers/utils";
import FaveoChart from "../../../../../../resources/assets/js/ChartFactory/FaveoChart.vue";
import DataWidget from "../../../../../../resources/assets/js/components/Common/DataVisualization/DataWidget.vue";

export default {

  name: 'time-series-chart',

  components: {
    'faveo-chart': FaveoChart,
    'data-widget': DataWidget
  },

  props: {

    // Api endpoint to fetch chart data
    chartDataApi: {
      type: String,
      required: true
    },

    // Api endpoint to fetch data widget data 
    dataWidgetApi: {
      type: String,
      default: () => undefined
    },

    // Category array 
    categories: {
      type: Array,
      default: () => []
    },

    // Default category option
    defaultCategory: {
      type: String,
      default: () => ''
    },

    /**
     * string to show in the category dropdown
     * used as key for fetching data from server basis of category
     */
    categoryPrefix: {
      type: String,
      default: () => 'view_by'
    },

    // Defualt filter field value objec
    filterParams: {
      type: Object,
      default: () => {}
    },

    /**
     * Report array index
     */
    reportIndex: {
      type: Number,
      required: true
    }
  },

  data: () => {
    return {
      chartApiData: null,
      isLoading: true,
      chartData: {},
      selectedCategory: '',
      dataWidgetData: null
    }
  },

  beforeMount() {

    // Assign defualt category to selected category
    this.selectedCategory = this.defaultCategory;

    // Make api call to fetch chart data
    this.getDataFromServer();
  },

  methods: {

    // Fetch widget/chart data when category changes
    onCategoryChange(value) {
      this.selectedCategory = value;
      this.$emit('updateChangedValue', this.selectedCategory, this.reportIndex, 'selected_view_by');
      this.getDataFromServer();
    },

    getDataFromServer() {
      this.isLoading = true;

      // Fetch data widget data if datawidget api endpoint provided 
      if(boolean(this.dataWidgetApi)) {
        axios.get(this.dataWidgetApi, { params: this.getUrlParams() })
        .then(res => {
          this.dataWidgetData = res.data.data;
          this.updateDataCount('widget', this.dataWidgetData );
        })
        .catch(err => {
          errorHandler(err, 'category-based-report');
        })
      }

      // Fetch chart data
      axios.get(this.chartDataApi, { params: this.getUrlParams() })
      .then(res => {
        this.chartApiData = res.data.data;
        this.processChartData();
        this.updateDataCount('chart', this.chartApiData);
      })
      .catch(err => {
        errorHandler(err, 'category-based-report');
        this.isLoading = false;
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

    processChartData() {
      try {
        // Sorted(basis of time) list of time labels
        const timeSeriesLabels = getTimeLabels(this.chartApiData.data);

        // Chart object
        this.chartData = {
          data: parseTimeSeriesChartData(this.chartApiData.data, timeSeriesLabels),
          labels: timeSeriesLabels,
          categoryLabel: this.chartApiData.categoryLabel,
          dataLabel: this.chartApiData.dataLabel,
          panelTitle: this.chartApiData.name
        }
      } catch (error) {
        console.error('TimeSeriesChart | processChartData ', error);
      }

      this.isLoading = false;
    },

    /**
     * get Url parameters
     * may contain slected filter values, selected category limit
     */
    getUrlParams() {
      let params = getValidFilterObject(this.filterParams);
      params[this.categoryPrefix] = this.selectedCategory;
      return params;
    },

  },

  watch: {
    filterParams(){
      this.getDataFromServer();
    }
  }
}
</script>

<style lang="css" scoped>
.panel-heading {
  padding: 6px 15px;
}
.panel-heading.row {
  margin: 0;
}
.rpt_icon {
  cursor: pointer;
}
.chart-panel-heading {
  padding-left: 0;
  padding-top: 0.5rem;
}
.chart-list {
  display: flex;
  flex-wrap: wrap;
}
#chart-container {
  margin: 1rem -5px 1rem -5px;
}

</style>