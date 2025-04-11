<template>
  <div class="col-sm-12">
    <div class="row" v-if="loading">
      <custom-loader :duration="4000" />
    </div>

    <alert :componentName="componentName" />

    <div class="card card-light">
      <div class="card-header">
        <h3 class="card-title">
          {{ isCreating ? lang('create_webhook') : lang('edit_webhook') }}
        </h3>
        <div class="card-tools">
          <status-switch
              name="status"
              :value="status"
              :onChange="onChange"
              :bold="true"
          />
        </div>
      </div>

      <div class="card-body">
        <div class="row">
          <text-field
              name="url"
              :value="url"
              :label="lang('webhook_url')"
              :onChange="onChange"
              classname="col-md-12"
              :required="true"
              :hint="lang('enter_url_to_send_ticket_details')"
              placehold="https://www.example.com"
          />
        </div>

        <div class="row">
          <dynamic-select
              :label="lang('events')"
              classname="col-md-6"
              :multiple="true"
              name="events"
              api-endpoint="api/admin/webhook/events"
              :value="events"
              :onChange="onChange"
              :required="true"
              :placeholder="lang('select-events')"
          />

          <dynamic-select
              :label="lang('sources')"
              classname="col-md-6"
              :multiple="true"
              name="sources"
              api-endpoint="api/dependency/sources"
              :value="sources"
              :onChange="onChange"
              :required="true"
              :placeholder="lang('select-sources')"
          />
        </div>
      </div>

      <div class="card-footer">
        <button
            type="button"
            @click="onSubmit"
            :disabled="loading"
            class="btn btn-primary"
        >
          <i class="fa fa-save"></i> {{ isCreating ? lang('save') : lang('update') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import axios from 'axios';
import DynamicSelect from '../../../MiniComponent/FormField/DynamicSelect.vue';
import TextField from '../../../MiniComponent/FormField/TextField.vue';
import StatusSwitch from '../../../MiniComponent/FormField/Switch.vue';
import { errorHandler, successHandler } from '../../../../helpers/responseHandler';
import { getIdFromUrl } from '../../../../helpers/extraLogics';
import { lang } from "../../../../helpers/extraLogics";
import { useRouter } from 'vue-router';

export default {
  name: 'WebhookCreateEdit',
  components: { StatusSwitch, TextField, DynamicSelect },

  setup() {
    const store = useStore();
    const router = useRouter();  // Make sure this line is present

    const loading = ref(false);
    const isCreating = ref(true);
    const componentName = ref('webhook-info');
    const events = ref([]);
    const sources = ref([]);
    const id = ref('');
    const submitEndPoint = ref('');
    const url = ref('');
    const status = ref(false);

    const onChange = (value, name) => {
      if (name === 'url') url.value = value;
      if (name === 'status') status.value = value;
      if (name === 'events') events.value = value;
      if (name === 'sources') sources.value = value;
    };

    const onSubmit = async () => {
      store.dispatch('unsetValidationError');

      try {
        loading.value = true;
        const payload = formatEventsAndSources();

        const response = await axios.post(submitEndPoint.value, {
          url: url.value,
          sources: payload.sources,
          events: payload.events,
          status: status.value
        });

        loading.value = false;
        successHandler(response, componentName.value);
        if (isCreating.value) {
          setTimeout(() => {
            router.push('list');
          }, 3000);
        }
      } catch (error) {
        loading.value = false;
        errorHandler(error, componentName.value);
      }
    };

    const formatEventsAndSources = () => {
      const configs = {
        sources: [],
        events: []
      };

      sources.value.sort().forEach(item => {
        if (!configs.sources.includes(item.id)) {
          configs.sources.push(item.id);
        }
      });

      events.value.sort().forEach(item => {
        if (!configs.events.includes(item.id)) {
          configs.events.push(item.id);
        }
      });

      return configs;
    };

    const getWebhookData = async (webhookId) => {
      id.value = webhookId;
      loading.value = true;

      try {
        const response = await axios.get(`api/admin/webhook/info/${id.value}`);
        const webhookInfo = response.data.data;

        url.value = webhookInfo.url;
        status.value = webhookInfo.status;
        sources.value = webhookInfo.sources;
        events.value = webhookInfo.events;
      } catch (error) {
        errorHandler(error, componentName.value);
      } finally {
        loading.value = false;
      }
    };

    onMounted(() => {
      isCreating.value = !window.location.pathname.includes('/edit');
      if (!isCreating.value) {
        getWebhookData(getIdFromUrl(window.location.pathname));
      }
      submitEndPoint.value = `api/admin/webhook/${id.value}`;
    });

    return {
      loading,
      isCreating,
      componentName,
      events,
      sources,
      url,
      status,
      onChange,
      onSubmit,
      getWebhookData,  // Ensure this is returned
      lang,
    };
  }
};

</script>
