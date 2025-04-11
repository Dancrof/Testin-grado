<script setup>

import {onBeforeMount, ref, h } from "vue";
import Alert from "../../../MiniComponent/Alert.vue";
import FaveoBox from "../../../MiniComponent/FaveoBox.vue";
import Datatable from "../../../Extra/DataTable.vue";
import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";
import {lang} from "../../../../helpers/extraLogics";

// Columns data for table
const columns = ref(['app_name', 'iframe_url', 'route_name', 'status', 'actions']);

// table options
const options = ref({});

// endpoint for fetching data
const apiUrl = '/integration-settings';

onBeforeMount(()=>{

  options.value = {

    headings : {  app_name: lang('app_name'),
      iframe_url: lang('iframe_url'),
      status : lang('status'),
      route_name: lang('route_name'),
      actions: lang('actions') },

    columnsClasses : {
      app_name: 'app-name',
      iframe_url: 'iframe-url',
      status: 'iframe-status',
      route_name: 'route_name',
      actions: 'iframe-actions'
    },

    sortIcon: {

      base : 'glyphicon',

      up: 'glyphicon-chevron-down',

      down: 'glyphicon-chevron-up'
    },

    texts: { filter: "", limit: "" },

    templates: {

      actions: (f,row)=>{

        return h(DataTableActions,{data:row})
      },

      status: function(f, row) {

        let span = h('span', {

          'class' : row.integration_status ? 'btn btn-success btn-xs pointer_normal' : 'btn btn-danger btn-xs pointer_normal'

        }, row.integration_status ? lang('active') : lang('inactive'));

        return h('a', { class : 'pointer_normal'}, [span]);
      },

      route_name: (f, row) => {

        if (!row.routes || row.routes.length === 0) return '---';

        const badges = row.routes.map(item =>
            h('span', { class: 'badge text-bg-secondary mx-1', style: { display: 'inline-block' },}, item.name)
        );

        return h('div', { class: 'd-flex flex-wrap' }, badges);
      },

      iframe_url: (f,row) => {

        return row.app_url ? row.app_url : '---';
      }
    },

    sortable: [ 'app_name' ],

    filterable: [ 'app_name' ],

    pagination: { chunk: 5, nav: "scroll" },

    requestAdapter(data) {

      return {

        'sort-field': data.orderBy ? data.orderBy : "id",

        'sort-order': data.ascending ? "desc" : "asc",

        'search-query': data.query.trim(),

        page: data.page,

        limit: data.limit
      };
    },

    responseAdapter({ data }) {

      return {

        data: data.data.data.map(data => {

          data.edit_url = "/iframe-injection/" + data.id + '/edit';

          data.delete_url = "/api/delete-integration-setting/" + data.id;

          data.settings_url = "/iframe-injection/" + data.id + '/settings';

          data.deleteMessage = 'are_you_sure_you_want_to_delete';

          return data;
        }),

        count: data.data.total
      };
    },

    orderBy: { column: 'id', ascending: true },
  }
});

</script>

<template>

  <div id="iframe-index" class="col-sm-12">

    <Alert component-name="dataTableModal"></Alert>

    <FaveoBox :title="trans('list_of_iframe_configurations')">

      <template #customActions>

        <div class="card-tools">

          <router-link class="btn btn-tool pointer-cursor" to="/iframe-injection/create" v-tooltip="trans('create_new_iframe_configuration')">

            <i class="glyphicon glyphicon-plus"> </i>
          </router-link>
        </div>
      </template>

      <Datatable :url="apiUrl" :dataColumns="columns" :option="options" scroll_to="iframe-index">

      </Datatable>
    </FaveoBox>
  </div>
</template>

<style>

#iframe-index .VueTables .table-responsive {
  overflow-x: auto;
}

#iframe-index .VueTables .table-responsive > table{
  width : max-content;
  min-width : 100%;
  max-width : max-content;
  overflow: auto !important;
}
</style>