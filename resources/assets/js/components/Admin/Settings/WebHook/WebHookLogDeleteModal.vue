<template>
  <div>
    <modal v-if="showModal" :showModal="showModal" :onClose="onModalClose" :containerStyle="containerStyle">
      <template #title>
        <h4 class="modal-title">{{ lang(title) }}</h4>
      </template>

      <template #fields>
        <div v-if="loading" class="row">
          <reuse-loader :animation-duration="4000" color="#1d78ff" :size="size" />
        </div>

        <div class="row">
          <date-time-field
              id="log_delete_date1"
              :label="lang('delete_from')"
              :value="deleteAfterDate"
              type="datetime"
              :time-picker-options="timeOptions"
              name="delete_after_date"
              :required="true"
              :onChange="onChange"
              :currentYearDate="false"
              format="YYYY-MM-DD HH:mm:ss"
              classname="col-md-6"
              :clearable="true"
              :disabled="false"
          />
          <date-time-field
              id="log_delete_date2"
              :label="lang('delete_to')"
              :value="deleteBeforeDate"
              type="datetime"
              :time-picker-options="timeOptions"
              name="delete_before_date"
              :required="true"
              :onChange="onChange"
              :currentYearDate="false"
              format="YYYY-MM-DD HH:mm:ss"
              classname="col-md-6"
              :clearable="true"
              :disabled="false"
          />
        </div>
      </template>

      <template #controls>
        <button id="log_delete_btn" type="button" @click="onSubmit" class="btn btn-secondary" :disabled="isDisabled">
          <i class="fa fa-trash" aria-hidden="true"></i> {{ lang('delete') }}
        </button>
      </template>
    </modal>
  </div>
</template>

<script>
import {ref, reactive, computed} from 'vue';
import moment from 'moment';
import axios from 'axios';
import {errorHandler, successHandler} from '../../../../helpers/responseHandler';
import DateTimePicker
  from '../../../../../../../resources/assets/js/components/MiniComponent/FormField/DateTimePicker.vue';

export default {
  name: 'WebhookLogModal',
  components: {
    'date-time-field': DateTimePicker,
  },
  props: {
    showModal: {type: Boolean, default: false},
    onClose: {type: Function,  default: () => {}},
    data: {type: Object, default: () => ({})},
    title: {type: String, default: ''},
    webhookId: {type: Number, default:null},
  },
  setup(props, {emit}) {
    const containerStyle = reactive({width: '950px'});
    const loading = ref(false);
    const size = ref(60);
    const deleteAfterDate = ref('');
    const deleteBeforeDate = ref('');
    const timeOptions = reactive({
      start: '00:00',
      step: '00:30',
      end: '23:30',
    });

    const deleteAfterSelected = ref(false);
    const deleteBeforeSelected = ref(false);


    const onChange = (value, name) => {
      if (name === 'delete_after_date') {
        deleteAfterDate.value = value;
        deleteAfterSelected.value = value !== null;
      } else if (name === 'delete_before_date') {
        deleteBeforeDate.value = value;
        deleteBeforeSelected.value = value !== null;
      }
    };


    const isDisabled = computed(() => {
      return !deleteAfterDate.value || !deleteBeforeDate.value;
    });

    const onModalClose = () => {
      // Reset date fields
      deleteBeforeDate.value = '';
      deleteAfterDate.value = '';
      deleteAfterSelected.value = false;
      deleteBeforeSelected.value = false;
      emit('close');
    };


    const onSubmit = () => {
      loading.value = true;

      const data = {
        id: props.webhookId,
        delete_before:
            deleteBeforeDate.value !== '' && deleteBeforeDate.value !== null
                ? moment(deleteBeforeDate.value).format('YYYY-MM-DD HH:mm:ss')
                : '',
        delete_after:
            deleteAfterDate.value !== '' && deleteAfterDate.value !== null
                ? moment(deleteAfterDate.value).format('YYYY-MM-DD HH:mm:ss')
                : '',
      };

      axios
          .delete('/api/admin/webhook-logs/delete', {data})
          .then((res) => {
            successHandler(res, 'webhook-logs');
            window.emitter.emit('refreshWebhookDeleteLogs');
            onModalClose();
            loading.value = false;
          })
          .catch((err) => {
            loading.value = false;
            errorHandler(err, 'webhook-logs');
          });
    };

    return {
      containerStyle,
      loading,
      size,
      deleteAfterDate,
      deleteBeforeDate,
      timeOptions,
      deleteAfterSelected,
      deleteBeforeSelected,
      isDisabled,
      onChange,
      onModalClose,
      onSubmit,
    };
  },
};
</script>

