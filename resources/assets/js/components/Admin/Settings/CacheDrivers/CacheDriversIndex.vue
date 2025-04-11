<template>
  <div class="col-sm-12">

    <alert componentName="dataTableModal"/>

    <div class="card card-light ">

      <div class="card-header">

        <h3 class="card-title">{{trans('cache-driver')}}</h3>

      </div>

      <div class="card-body" id="driver_index">
        <!-- Display data table component with specified properties -->
        <data-table :url="apiUrl" :dataColumns="columns" :option="options" scroll_to ="driver_index" componentTitle="DriverIndex" />
      </div>
    </div>
  </div>
</template>

<script>

import DriversName from "./DriversName.vue";
import DriversActions from "./DriversActions.vue";

export default {
  name: "CacheDriversIndex",

  description: 'CacheDrivers table component',

  data(){
    return{
      columns:['name', 'status', 'action'], // Columns to display in the data table

      options:{}, // Options for configuring the data table

      activated:'', // Indicator for an activated driver

      apiUrl:'api/cache-lists'  // API URL for fetching data
    }
  },

  beforeMount() {

    const self = this;

    this.options = {

      sortIcon: {

        base : 'glyphicon',

        down: 'glyphicon-chevron-up',

        up: 'glyphicon-chevron-down'
      },

      headings : {
        name: this.trans('name'),

        status: this.trans('status'),

        action: this.trans('action'),
      },

      columnsClasses : {

        name: 'drivers-name',

        status: 'drivers-status',

        action: 'drivers-action',
      },

      texts: { filter: '', limit: '' },

      templates: {

        name : (f,row)=>{
          return self.h(DriversName,{ data : row})
        },

        status: function(createElement, row) {
          // Display status as a button with proper class
          let span = self.h('span', {
            'class' : row.status ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'
          }, row.status ? this.lang('active') : this.lang('inactive'));


          return self.h('a', {class: 'pointer_normal'}, [span]);
        },

        action: (f,row)=>{

          return self.h(DriversActions,{ data : row})
        },
      },

      sortable:  '',

      filterable:  '',

      pagination: { chunk:5,nav: 'fixed',edge:true },

      requestAdapter(data) {

        return {

          'sort-field' : data.orderBy ? data.orderBy : 'name',

          'sort-order' : data.ascending ? 'asc' : 'desc',

          'search-query' : data.query.trim(),
        }
      },

      responseAdapter({data}) {

        self.activated = data.data.find( ({ status }) => status );  // Find an activated driver

        return {

          data: data.data,

          count: 5
        }
      },

	    orderBy: { column: 'name', ascending: true },
    }
  },
}
</script>

<style type="text/css">

.drivers-name,.drivers-status,.drivers-action { max-width: 250px; word-break: break-all;}

#driver_index .VueTables .table-responsive {
  overflow-x: auto;
}

#driver_index .VueTables .table-responsive > table{
  width : max-content;
  min-width : 100%;
  max-width : max-content;
  overflow: auto !important;
}
</style>