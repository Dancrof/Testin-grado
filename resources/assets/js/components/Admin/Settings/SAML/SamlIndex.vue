<template>
  <div class="col-sm-12" id="SAML-table">

    <alert componentName="dataTableModal"/>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans(title)}}</h3>

        <div class="card-tools">

          <router-link class="btn btn-tool" to="/single-sign-on/settings/add" v-tooltip="lang('Create_SSO')">

            <i class="glyphicon glyphicon-plus"> </i>
          </router-link>
        </div>
      </div>

      <div class="card-body" id="SAML">

        <data-table :url="apiUrl" :dataColumns="columns" :option="options" scroll_to="SAML-table"></data-table>
      </div>

    </div>

  </div>

</template>

<script>

import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

export default {
  name: "SamlIndex.vue",

  description: 'Single Sign On component',

  data() {
    return {
      columns: ['provider', 'status', 'action'],

      apiUrl: '/api/SSO/list',

      options: {},

      title: 'SAML_Integration'
    }
  },
  beforeMount() {

    const self = this;

    this.options = {

      texts: {filter: '', limit: ''},

	    sortIcon: {

		    base : 'glyphicon',

		    up: 'glyphicon-chevron-down',

		    down: 'glyphicon-chevron-up'
	    },

      columnsClasses: {
        provider: 'provider',

        activate: 'status',

        actions: 'actions',
      },
      headings: {is_active: this.trans('activate'),

        provider: this.trans('provider'),

        status: this.trans('status'),

        action: this.trans('action'),
      },

      templates: {

        status(f, row) {

          if (row.status) {

            return self.h('p', {style: {color: 'green'}}, this.trans('active'));

          } else {

            return self.h('p', {style: {color: 'red'}}, this.trans('inactive'));
          }
        },

        action(f,row) {

          return self.h(DataTableActions,{ data : row})
          
        }
      },

      sortable: ['provider', 'status'],

      filterable: ['provider', 'status'],

      pagination: {chunk: 5, nav: 'scroll'},

      requestAdapter(data) {

        return {

          'sort-field': data.orderBy ? data.orderBy : 'id',

          'sort-order': data.ascending ? 'desc' : 'asc',

          'search': data.query.trim(),

          page: data.page,

          limit: data.limit,
        }
      },

      responseAdapter({data}) {

        if (data) {

          return {

            data: data.data.data.map(data => {

              data.edit_url = '/single-sign-on/settings/' + data.id + '/edit';

              data.view_url = '/single-sign-on/settings/' + data.id;

              data.delete_url = self.basePath() + '/api/SSO/delete/' + data.id;

              return data;
            }),
            count: data.data.total
          }

        }

      },

	    orderBy: { column: 'id', ascending: true },

    }
  },

}
</script>

<style>

#SAML .VueTables .table-responsive {
  overflow-x: auto;
}

#SAML .VueTables .table-responsive > table {
  width: max-content;
  min-width: 100%;
  max-width: max-content;
  overflow: auto !important;
}

</style>

