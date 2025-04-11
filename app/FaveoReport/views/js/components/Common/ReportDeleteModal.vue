<template>
  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

    <template #title>

      <h4 class="modal-title">{{trans('delete')}}</h4>
    </template>

    <template #fields>

      <span v-if="!loading">{{trans('are_you_sure_you_want_to_delete_this_report')}}</span>

      <div class="row" v-if="loading">

        <reuse-loader :duration="4000"></reuse-loader>
      </div>
    </template>

    <template #controls>

      <button type="button" id="submit_btn"  @click = "deleteCustomReport" class="btn btn-secondary">

        <i class="fas fa-trash"></i> {{trans('delete')}}
      </button>
    </template>
  </modal>
</template>

<script setup>
import {ref} from 'vue';
import Modal from "../../../../../../resources/assets/js/components/Common/Modal.vue";
import axios from "axios"
import {errorHandler, successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";

const props = defineProps({

  showModal : { type : Boolean, default : false },

  onClose : { type : Function },

  reportId : {type : Number, default : ''},

  reportType: {type: String, default: ''},

  type: {type: String, default: ''}

})

const emit = defineEmits(['refreshReportHomePage']);

const loading = ref(false);


const containerStyle = ref({
  width: '500px'
});

const  deleteCustomReport = () => {
  loading.value = true;
  let apiUrl = '';
  apiUrl = props.reportType === "ServiceDesk Analysis" ? 'service-desk/api/report/delete/' : 'api/report/';
    axios.delete( apiUrl+ props.reportId)
        .then(res => {
          loading.value = false;
          props.onClose();
          window.emitter.emit('refreshReportHomePage', props.type);
          window.emitter.emit('updateAgentSidebar');
          successHandler(res, 'report-home-page');
        }).catch(err => {
      props.onClose();
      errorHandler(err, 'report-home-page');
      loading.value = false;
    })
}
</script>


<style scoped>

</style>