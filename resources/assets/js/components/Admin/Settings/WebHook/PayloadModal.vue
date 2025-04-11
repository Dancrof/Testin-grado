<template>
  <div>
    <span :id="'log-status-' + data.id" class="logStatus">
      {{ data.payload.substring(0, 100) }}...
    </span>

    <a type="button" class="viewAll" @click="toggleModal" data-card-widget="refresh">
      {{ lang('view_all') }}
    </a>

    <transition name="modal">
      <div v-if="showModal">
        <modal
            :showModal="showModal"
            @close="onClose"
            :containerStyle="containerStyle"
        >
          <template #title>
            <h4 class="modal-title">{{ lang('webhook_detailed_log') }}</h4>
          </template>

          <template #fields>
            <span v-if="data.message.length > 0">
              <strong>{{ lang('webhook_error') }}:</strong> {{ data.message }}
            </span>
            <br />
            <br />
            <strong>{{ lang('payload') }}:</strong>
            <p v-html="formattedPayload(data.formatted_payload)" class="trace"></p>
          </template>
        </modal>
      </div>
    </transition>
  </div>
</template>

<script>
import { ref, computed } from 'vue';

export default {
  name: 'PayloadModal',
  props: {
    data: { type: Object, required: true },
  },
  setup(props) {
    const showModal = ref(false);
    const containerStyle = ref({ width: '800px' });

    const toggleModal = () => {
      showModal.value = !showModal.value; // Toggle the modal's visibility
    };

    const onClose = () => {
      showModal.value = false; // Close the modal
    };

    const formattedPayload = (payload) => {
      if (typeof payload === 'object' && payload !== null) {
        const jsonString = JSON.stringify(payload, null, 2);
        return `<pre style="color:white;">${escapeHtml(jsonString)}</pre>`;
      }
      return '';
    };

    const escapeHtml = (string) => {
      const entityMap = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;',
        '/': '&#x2F;',
        '`': '&#x60;',
        '=': '&#x3D;',
      };
      return String(string).replace(/[&<>"'`=/]/g, (s) => entityMap[s]);
    };

    return {
      showModal,
      containerStyle,
      toggleModal,
      onClose,
      formattedPayload,
      escapeHtml,
    };
  },
};
</script>

<style scoped>
.log-status {
  min-width: 65px;
}

.logStatus {
  cursor: pointer !important;
}

.viewAll {
  color: #3c8dbc;
}
</style>
