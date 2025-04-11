<template>

  <div class="btn-group">

    <status-switch
        :name="data.id"
        :value="(data.revoked)?false:true"
        :key="Math.random()"
        :onChange="onChange"
    />

  </div>

</template>

<script>

import Switch from "../../../MiniComponent/FormField/Switch.vue";
import {errorHandler,successHandler} from "../../../../helpers/responseHandler";

export default {
  components : {
    "status-switch":Switch
  },
  props:['data'],

  methods: {

    onChange(value,name) {
      this.statusChange(name,value);
    },

    statusChange(id,active) {
      let status = (active)?1:0;
      axios.get('edit/oauth/status/'+id+'/'+status)
          .then((res) => {
            successHandler(res,'dataTableModal');
            window.emitter.emit('refreshData');
          })
          .catch((err) => {
            errorHandler(err,'dataTableModal');
          })
    }
  }
}
</script>