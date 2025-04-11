<template>
  <div class="col-sm-12">
    <alert componentName="webhook-list" />

    <div class="card card-light">
      <div class="card-header">
        <h3 id="contract-type-list" class="card-title">{{ lang('list_of_webhooks') }}</h3>
        <div class="card-tools">
          <router-link class="btn btn-tool" to="/webhook/add" v-tooltip="lang('add_webhook')">
            <span class="glyphicon glyphicon-plus"> </span>
          </router-link>
        </div>
      </div>

      <div class="card-body">
        <data-table :url="apiUrl" :dataColumns="columns" :option="options" scroll_to="webhook-list" />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, h } from 'vue';
import { useStore } from 'vuex';
import DataTableActions from '../../../MiniComponent/DataTableComponents/DataTableActions.vue';
import { lang } from "../../../../helpers/extraLogics";
import DataTableStatus from "../../../MiniComponent/DataTableComponents/DataTableStatus.vue";

export default {
  name: 'WebhookList',

  components: { DataTableActions },

  setup() {
    const store = useStore();
    const formattedTime = computed(() => store.getters.formattedTime);

    const columns = ref(['url', 'status', 'created_at', 'updated_at', 'action']);
    const options = ref({});
    const apiUrl = ref('/api/admin/webhook/list');
    const loading = ref(false);  // Directly set to false since no asynchronous actions

    const renderActions = (row) => h(DataTableActions, { data: row });
    const statusTemplate = (row) => h(DataTableStatus, { data: row });

    options.value = {
      headings: {
        url: lang('url'),
        status: lang('status'),
        created_at: lang('created_at'),
        updated_at: lang('updated_at'),
        action: lang('action'),
      },

      sortIcon: {
        base: 'glyphicon',
        up: 'glyphicon-chevron-up',
        down: 'glyphicon-chevron-down',
      },

      texts: { filter: '', limit: '' },

      templates: {
        status(h, row) {
          return statusTemplate(row);
        },
        created_at(h, row) {
          return formattedTime.value(row.created_at);
        },
        updated_at(h, row) {
          return formattedTime.value(row.updated_at);
        },
        action(h, row) {
          return renderActions(row);
        },
      },

      sortable: ['url', 'status', 'created_at', 'updated_at'],
      filterable: [],
      pagination: { chunk: 5, nav: 'fixed', edge: true },

      requestAdapter(data) {
        return {
          paginate: 1,
          'sort-field': data.orderBy ? data.orderBy : 'updated_at',
          'sort-order': data.ascending ? 'desc' : 'asc',
          'search-query': data.query.trim(),
          page: data.page,
          limit: data.limit,
        };
      },

      responseAdapter({ data }) {
        return {
          data: data.data.data.map((item) => {
            item.alertComponentName = 'webhook-list';
            item.deleteMessage = 'are_you_sure_you_want_to_delete_dependencies';
            return item;
          }),
          count: data.data.total,
        };
      },
    };

    return {
      columns,
      options,
      apiUrl,
      loading,
      formattedTime,
    };
  },
};
</script>
