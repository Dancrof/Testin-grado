<template>
  <div class="actions-row">
    <button
        class="btn btn-light table_btn"
        :disabled="data.system_default_language"
        @click="makeDefault(data.iso_code)"
        v-tooltip="isDefault ? trans('already_default') : trans('make_default')"
    >
      <i :class="[isDefault ? 'fas fa-check success' : 'fa-solid fa-right-to-bracket']"></i>
    </button>
    <a class="btn btn-light table_btn" v-tooltip="trans('download_lang_files')" :href="basePath()+'/api/admin/download-language-template/'+data.id">

      <i class="fas fa-download"></i>
    </a>
  </div>
</template>

<script>
import axios from "axios";
import {errorHandler, successHandler} from "../../../../helpers/responseHandler";

export default {
  props: {
    data: {
      type: Object,
      required: true
    }
  },
  computed: {
    isDefault() {
      return this.data.system_default_language;
    },
  },
  methods: {
    async makeDefault(iso) {
      this.loading = true;

      await axios.patch('api/admin/update-system-language/' + iso)
          .then(res => {
            this.loading = false;
            this.updateTable += 1;
            successHandler(res, 'language');
            window.emitter.emit('refreshData');
          })
          .catch(err => {
            this.loading = false;
            errorHandler(err, 'language');
          });
    }
  },
};
</script>

<style scoped>

</style>
