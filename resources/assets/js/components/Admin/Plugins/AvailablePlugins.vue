<script setup>

import { ref, h } from 'vue';

import {errorHandler, successHandler} from "../../../helpers/responseHandler";

import { lang } from "../../../helpers/extraLogics";

import PluginActions from './PluginActions.vue';

import PluginsName from "./PluginsName.vue";

const apiUrl = ref('/getplugin?installed=0');

const columns = ref(['name', 'description', 'action']);

const props = defineProps({

  whiteLabel: { type: Boolean, default: false },
});

const options = ref({

  headings: { name: lang('plugin'), description: lang('description'), action: lang('action') },

  columnsClasses: { name: 'name', description: 'description', action: 'action' },

  perPage: 25,

  sortIcon: { base: 'glyphicon', up: 'glyphicon-chevron-up', down: 'glyphicon-chevron-down' },

  texts: { filter: '', limit: '' },

  sortable: ['name', 'version'],

  filterable: ['name'],

  pagination: { chunk: 5, nav: 'fixed', edge: true },

  templates: {
    action: (createElement, row) => {
      return h(PluginActions, { data: row, from: 'available_plugins' });
    },

    description: (createElement, row) => {

      return h(PluginsName, {
        data: row, whiteLabel: props.whiteLabel, from: 'description'
      })
    },
  },

  requestAdapter: function(data) {

    return {

      'sort_field' : data.orderBy ? data.orderBy : 'name',

      sort_order : data.ascending ? 'desc' : 'asc',

      'search_query' : data.query.trim(),

      limit: data.limit,
    }
  },

  responseAdapter: function({data}) {
    return {
      data: data.data.plugin,
      count: data.data.total,
    }
  }
});

const show_pagination = ref(true);

const loading = ref(false);

const checkAvailablePlugins = () => {
  loading.value = true;
  axios.get('plugin/install/check')
      .then((res) => {
        loading.value = false;
        successHandler(res, 'dataTableModal');
        window.emitter.emit('refreshData');
      })
      .catch((err) => {
        loading.value = false;
        errorHandler(err, 'dataTableModal');
      })
}

</script>

<template>

  <!-- Display a loader while the data is being fetched -->
  <div v-if="loading">

    <custom-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
  </div>

  <!-- Container for the plugins list -->
  <div class="col-sm-12">

    <!-- Alert component for displaying messages -->
    <alert componentName="dataTableModal"/>

    <div class="card card-light" id="available-plugins-list">

      <div class="card-header">

        <!-- title -->
        <h3 class="card-title">
          {{ lang('list_of_available_plugin') }}
        </h3>

        <div class="card-tools">
          <button class="btn btn-tool" @click="checkAvailablePlugins()" v-tooltip="lang('check_available_plugin_install')"><i class="fas fa-refresh pe-1"></i></button>
        </div>

      </div> <!--header-->

      <div class="card-body" id="available-plugins-list">

          <!-- Data table for displaying the plugins list -->
          <data-table :url="apiUrl" :dataColumns="columns" :show_pagination="show_pagination" :option="options" scroll_to ="available-plugins-list"></data-table>

      </div> <!--card-body-->
    </div> <!--card-->
  </div>

</template>

<style scoped>

.id,.name,.description,.website,.version,.author{ max-width: 250px; word-break: break-word;}

#available-plugins-list .VueTables .table-responsive {
  overflow-x: auto;
}

#available-plugins-list .id{
  width: 60px;
}


#available-plugins-list .name{
  width: 400px;
}


#available-plugins-list .activate{
  width: 300px;
}

#available-plugins-list .VueTables .table-responsive > table{
  width : max-content;
  min-width : 100%;
  max-width : max-content;
  overflow: auto !important;
}

</style>