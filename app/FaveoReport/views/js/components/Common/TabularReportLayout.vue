<template>
  <div class="tabular-layout">
    <!-- Alert  -->
    <alert componentName="tabular-report-layout" />

    <div class="column-list-right">
      <!-- Columns -->
      <column-list :table-columns="columns" :sub-report-id="subReportId" :add-custom-column-url="addCustomColumnUrl" :filterParams="filterParams"
        :delete-custom-column-url="deleteCustomColumnUrl" :short-code-url="shortCodeUrl" :report-index="reportIndex" :report-id="reportId"
        :showAddColumn="showAddColumn"/>
    </div>

    <div>
      <dynamic-datatable v-if="columns.length" :show_pagination="show_pagination" :data-url="dataUrl" :columns="visibleColumns" :columnsMeta="columns"
        :filterParams="filterParams" :reportType="reportType" :staticColumns="staticColumns" :tickets="tickets" :perpage="perpage" :perPageValues="perPageValues"/>
    </div>

  </div>
</template>

<script>

import {boolean} from "../../../../../../resources/assets/js/helpers/extraLogics";
import TicketFilter from "../../../../../../resources/assets/js/components/Agent/tickets/filters/TicketFilter.vue";
import DynamicDatatable from "../../../../../../resources/assets/js/components/Extra/DynamicDatatable.vue";
import ColumnList from "./ColumnList.vue";

export default {

  name: 'tabular-report-layout',

  description: 'Common layout component for tabular reports',

  props: {

	  tickets : { type : Function, default : ()=>[]},

    // Api endpoint for getting table data
    dataUrl: {
      type: String,
      required: true
    },

    // Api endpoint for getting table column list
    tableColumns: {
      type: Array,
      required: true
    },

    // Api endpoint for export call
    exportUrl: {
      type: String,
      required: true
    },

    // Api endpoint for saving cloumns order, visibility etc
    subReportId: {
      type: Number,
      required: true
    },

    /**
     * Url endpoint for adding custom column
     */
    addCustomColumnUrl: {
      type: String,
      required: true
    },

    /**
     * Url endpoint for deleting custom column
     */
    deleteCustomColumnUrl: {
      type: String,
      required: true
    },

    /**
     * Url endpoint for getting short codes
     */
    shortCodeUrl: {
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
    },

    reportId: {
      type: Number,
      required: true
    },

	  reportType: { type: String, default: '' },

	  showAddColumn: { type: Boolean, default: true },

	  staticColumns: { type: Array, default: () => [] },

	  perpage: { type: [Number, String], default: 10 },

	  perPageValues: { type: Array, default: () => [] }
  },

  data(){
    return {
      isLoading: false,
      columns: [],
      visibleColumns: {},
      show_pagination: true,
    }
  },

  created() {
    window.emitter.on('onReportsColumnUpdate', this.onColumnUpdate);
  },

  beforeMount() {
    this.columns = this.tableColumns;
    this.updateVisibleColumns();
  },

  methods: {

    onColumnUpdate(columns) {

      this.columns = columns;
      this.updateVisibleColumns();
    },

    updateVisibleColumns() {
      // setting visibleColumns to empty so that old values can be removed
      this.visibleColumns = {};

      this.columns.map(column => {
        if(boolean(column.is_visible)){
          this.visibleColumns[column.key] = column.label;
        }
      })
    }
  },

  components : {
    'ticket-filter': TicketFilter,
    'dynamic-datatable' : DynamicDatatable,
    'column-list': ColumnList,
  }
}
</script>

<style scoped>
.tabular-report-layout-box {
  padding: 0px !important;
}
.column-list-right { float : right; }
</style>
