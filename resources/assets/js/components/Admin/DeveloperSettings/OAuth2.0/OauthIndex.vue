<script setup>

import {onBeforeMount, ref, h } from "vue";

import Alert from "../../../MiniComponent/Alert.vue";
import FaveoBox from "../../../MiniComponent/FaveoBox.vue";
import Datatable from "../../../Extra/DataTable.vue";
import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

import globalMixin from "../../../../mixins/globalMixin";
const { basePath } = globalMixin.methods;

import {useStore} from "vuex";
import SwitchOauthAction from "./SwitchOauthAction.vue";

const store = useStore();

// Columns data for table
const columns = ref(['name', 'redirect', 'revoked', 'actions']);

// table options
const options = ref({});

// endpoint for fetching data
const apiUrl = '/get/oauth/clients';

onBeforeMount(()=>{

  options.value = {

    headings : { revoked : 'App status', redirect: 'Callback URL', name: 'App'},


    columnsClasses : {
      name: 'name',
      redirect: 'redirect',
      revoked: 'revoked',
      actions: 'token-actions'
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
      revoked: (f,row) => {

        return h(SwitchOauthAction,{ data : row })
      },
    },

    sortable: [ 'name' ],

    filterable: [ 'name' ],

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

          data.edit_url = "/oauth/" + data.id + "/edit";

          data.delete_url = basePath() + "/revoke/oauth/delete/client/" + data.id;

          data.deleteMessage = 'are_you_sure_delete_oauth_app';

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

  <div id="tokens-index" class="col-sm-12">

    <Alert component-name="dataTableModal"></Alert>

    <FaveoBox :title="trans('lists_of_oauth_clients')">

      <template #customActions>

        <div class="card-tools">

          <router-link class="btn btn-tool pointer-cursor" to="/oauth/create" v-tooltip="trans('create_oauth_apps')">

            <i class="glyphicon glyphicon-plus"> </i>
          </router-link>
        </div>
      </template>

      <Datatable :url="apiUrl" :dataColumns="columns" :option="options" scroll_to="tokens-index">

      </Datatable>
    </FaveoBox>
  </div>
</template>

<style>

.name,.redirect, .revoked, .token-actions{
  max-width: 250px; word-break: break-all;
}

#tokens-index .VueTables .table-responsive {
  overflow-x: auto;
}

#tokens-index .VueTables .table-responsive > table{
  width : max-content;
  min-width : 100%;
  max-width : max-content;
  overflow: auto !important;
}
</style>