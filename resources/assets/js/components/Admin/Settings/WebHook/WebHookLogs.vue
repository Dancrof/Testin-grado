<template>
  <div class="col-sm-12">
    <alert componentName="webhook-logs" />

    <div class="card card-light">
      <div class="card-header">
        <h3 class="card-title">{{ lang('webhook_log') }}</h3>
        <div class="card-tools">
          <a type="button" class="btn btn-tool" @click="tableKey++" data-card-widget="refresh" v-tooltip="lang('refresh')">
            <i class="fas fa-refresh"></i>
          </a>

          <button v-if="showLogs" type="button" :disabled="disabled" class="btn btn-tool" @click="showDeleteModal = true" v-tooltip="lang('delete_logs')">
            <i class="fas fa-trash"></i>
          </button>
        </div>
      </div>

      <transition name="modal">
        <webhook-log-modal
            title="delete_logs"
            :webhook-id="getWebhookId()"
            :hideCheckBox="true"
            :onClose="onClose"
            :showModal="showDeleteModal"
        />
      </transition>

      <div class="card-body">
        <data-table
            :key="tableKey"
            :url="apiUrl"
            :dataColumns="columns"
            :option="options"
            scroll_to="webhook-list"
        />
        <custom-loader v-if="loading" /> <!-- Display loader based on loading state -->

      </div>
    </div>
  </div>
</template>

<script>
import { ref, onBeforeMount, onBeforeUnmount, computed, h } from 'vue';
import { useStore } from 'vuex';
import { getIdFromUrl } from '../../../../helpers/extraLogics';
import PayloadModal from './PayloadModal.vue';
import WebhookLogModal from './WebHookLogDeleteModal.vue';
import DataTableStatus from "../../../MiniComponent/DataTableComponents/DataTableStatus.vue";
import { lang } from "../../../../helpers/extraLogics";

export default {
  name: 'webhook-logs',
  components: { WebhookLogModal, DataTableStatus },

  setup() {
    const store = useStore();
    const tableKey = ref(0);
    const apiUrl = ref('');
    const showDeleteModal = ref(false);
    const showLogs = ref(true);
    const disabled = ref(false);
    const columns = ['event', 'payload', 'response', 'created_at'];
    const options = ref({});
    const loading = ref(false);

    const formattedTime = computed(() => store.getters.formattedTime);

    const payLoadMod = (row) => h(PayloadModal, { data: row });
    const statusTemplate = (row) => h(DataTableStatus, { data: row });

    const setupOptions = () => {
      options.value = {
        headings: {
          event: lang('event'),
          payload: lang('payload'),
          response: lang('status'),
          created_at: lang('created_at'),
        },
        sortIcon: {
          base: 'glyphicon',
          up: 'glyphicon-chevron-down',
          down: 'glyphicon-chevron-up',
        },
        texts: {filter: '', limit: ''},
        templates: {
          response(h, row) {
            return statusTemplate(row);
          },
          event(h, row) {
            return lang('webhook_event_' + row.event);
          },
          created_at(h, row) {
            return formattedTime.value(row.created_at);
          },
          payload(h, row) {
            return payLoadMod(row);
          },
        },
        sortable: ['event', 'response', 'created_at'],
        filterable: [],
        pagination: {chunk: 5, nav: 'fixed', edge: true},
        requestAdapter(data) {
          return {
            paginate: 1,
            'sort-field': data.orderBy ? data.orderBy : 'created_at',
            'sort-order': data.ascending ? 'desc' : 'asc',
            'search-query': data.query.trim(),
            page: data.page,
            limit: data.limit,
          };
        },
        responseAdapter({data}) {
          const logData = data.data.data.map((data) => {
            data.response = data.response >= 200 && data.response < 300;
            data.alertComponentName = 'webhook-logs';
            data.deleteMessage = 'are_you_sure_you_want_to_delete_dependencies';
            return data;
          });

          disabled.value = logData.length === 0;

          return {
            data: logData,
            count: data.data.total,
          };
        }
      };
    };

    const onClose = () => {
      showDeleteModal.value = false;
    };

    const getWebhookId = () => {
      return getIdFromUrl(window.location.pathname);
    };

    const refreshLogs = () => {
      tableKey.value += 1;
    };

    onBeforeMount(() => {

      apiUrl.value = `/api/admin/webhook-log/${getWebhookId()}`;
      setupOptions();
      window.emitter.on('refreshWebhookDeleteLogs', refreshLogs);
    });

    onBeforeUnmount(() => {
      window.emitter.off('refreshWebhookDeleteLogs', refreshLogs);
    });

    return {
      tableKey,
      apiUrl,
      showDeleteModal,
      showLogs,
      disabled,
      columns,
      options,
      formattedTime,
      onClose,
      getWebhookId,
      refreshLogs,
      loading
    };
  }
};
</script>
