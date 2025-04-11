<template>
  <div class="col-sm-12">

    <alert componentName="dataTableModal"/>

    <div class="card card-light ">

      <div class="card-header">

        <h3 class="card-title">{{trans('search-drivers')}}</h3>

      </div>

      <div class="card-body" id="drivers_index">
        <!-- Display data table component with specified properties -->
        <data-table :url="apiUrl" :dataColumns="columns" :option="options" scroll_to ="drivers_index" componentTitle="DriversIndex" />

     </div>
    </div>
  </div>
</template>

<script>
import DriverSettingsName from "./DriverSettingsName.vue";
import DriverSettingsAction from "./DriverSettingsAction.vue";

export default {
  name: "DriversIndex",

  description: "drivers table component",

  data(){
    return{
      columns: [ 'name', 'status', 'action'], // Columns to display in the data table

      options: {}, // Indicator for an activated driver

      apiUrl:'api/get/search-driver', // API URL for fetching data

      activated : '' // Indicator for an activated driver
    }
  },

  beforeMount() {

    const self = this;

    this.options = {

      headings : {
        'name' : this.trans('name'),

        'status' : this.trans('status'),

        'action' : this.trans('action')
      },

      sortIcon: {

        base : 'glyphicon',

        down: 'glyphicon-chevron-up',

        up: 'glyphicon-chevron-down'
      },

      columnsClasses : {

        name: 'driver-name',

        status: 'driver-status',

        action: 'driver-action',
      },

      texts: { filter: '', limit: '' },

      templates: {

        name : (f,row)=>{
          return self.h(DriverSettingsName,{ data : row})
        },

        status: function(createElement, row) {
          // Display status as a button with proper class
          let span = self.h('span', {

            'class' : row.status ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'
          }, row.status ? self.trans('active') : self.trans('inactive'));

          return self.h('a', {class:'pointer_normal'}, [span]);
        },

        action: (f,row)=>{
          return self.h(DriverSettingsAction,{ data : row})
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

        self.activated = data.data.data.find( ({ status }) => status );

        return {

          data: data.data.data,

          count: data.data.total
        }
      },

	    orderBy: { column: 'name', ascending: true },
    }
  },
}
</script>

<style type="text/css">

.drivers-name,.drivers-status,.drivers-action { max-width: 250px; word-break: break-all;}

#drivers_index .VueTables .table-responsive {
  overflow-x: auto;
}

#drivers_index .VueTables .table-responsive > table{
  width : max-content;
  min-width : 100%;
  max-width : max-content;
  overflow: auto !important;
}

</style>