<template>
<div>
<p id="log">
  <parsed-data :dataValue="data" :logName="logName"></parsed-data>
  <a v-if="info.length > 0" id="logs_read_more" href="javascript:;" @click="showModal = true">

    <span class="label label-default">{{lang('read-more')}}</span>
  </a>
</p>

<transition name="modal">
  <modal v-if="showModal" :showModal="showModal" :onClose="onClose"
         :containerStyle="{ width:'500px' }">

    <template #title>
      <h4 class="modal-title">{{lang('detailed_log_info')}}</h4>
    </template>

    <template #fields>

      <div id="log_desc">

        <table class="table table-bordered table-striped">
          <tbody>
          <tr v-if="logName === 'Labels' || logName === 'Tags'" v-for="detailedInfo in info" v-html="loadLabel(detailedInfo)"></tr>
          <tr v-else v-for="detailedInfo in info">
            {{ detailedInfo }}
          </tr>
          </tbody>
        </table>
      </div>

    </template>

  </modal>
</transition>
</div>

</template>

<script>

import Modal from "../../../Common/Modal.vue";
import {renderLabelWithEmoji} from "../../../../helpers/extraLogics";

export default {

  name: "detailed-logs",

  description: "Logs component",

  props: {

    data : { type : String, required : true },

    scenario : { type : String, required : true },

    info : { type: Array, default: () => [] },

    logName: { type: String, default: '' },

  },

  beforeMount(){

    app.component('parsed-data',{

      props : ['dataValue', 'logName'],

      template : '<div v-html="loadData()"></div>',

      methods : {

        loadLabel(label) {
          return renderLabelWithEmoji(label);
        },

        loadData() {
      const parser = new DOMParser();
      const doc = parser.parseFromString(this.dataValue, 'text/html');
      const root = doc.querySelector('body');
      const anchors = Array.from(root.querySelectorAll('a'));

      anchors.forEach((anchor) => {
        const href = anchor.getAttribute('href');

        if (href && href.includes(this.basePath())) {
          const parts = href.replace(this.basePath(), '').split('/').filter(Boolean);

          if (parts[0] === 'check-ticket') {
            anchor.setAttribute('target', '_blank');
          } else if (['department', 'team', 'service-desk/products', 'service-desk/vendor'].includes(parts[0])) {
            anchor.setAttribute('target', '_blank');
            anchor.setAttribute('href', `${this.basePath()}/admin`);
            if (anchor.title === 'mention_link') {
              anchor.setAttribute('data-id', 'mention_link');
              anchor.removeAttribute('title');
            }
          }
        }

        anchor.setAttribute('target', '_blank');
      });

          const innerHTML = root.innerHTML;
          if (this.logName === 'Labels' || this.logName === 'Tags') {
            return this.loadLabel(innerHTML);
          } else {
            return innerHTML;
          }
    }

  }
    });
  },

  data(){

    return {

      showModal : false,
    }
  },

  methods:{

    onClose(){

      this.showModal = false;
    },

    loadLabel(label) {
      return renderLabelWithEmoji(label);
    },
  },

  components:{
    Modal

  }
};

</script>
