<template>
    <div>
      <span :id="'log-status-' + data.id" :class="['badge', badgeClass, 'log-status', 'text-uppercase']" @click="showModal = Boolean(data.exception)" v-tooltip="getStatusTitle" :style="data.exception ? {cursor: 'pointer'} : {} ">
        {{lang(data.status)}}
      </span>
      <transition name="modal">
        <exception-detail-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :data="data.exception"/>
      </transition>
    </div>
</template>

<script>

	import ExceptionDetailModal from "./ExceptionDetailModal.vue";
  import {toLower} from "lodash/string";

	export default {

		name: "log-status",

    description: "status of the log",

    components: {
      'exception-detail-modal': ExceptionDetailModal
    },

		props: {
			data : { type : Object, required : true }
		},

		data(){
			return {
				showModal: false,
			}
    },

    computed : {
      badgeClass(){
        switch(this.data.status){

          case "sent":
          case "accepted":
          case "completed":
            return "text-bg-success";

          case "queued":
          case "running":
          case "pending":
            return "text-bg-warning";

          case "rejected":
          case "failed":
          case "blocked":
            return "text-bg-danger";

            case "attachment-removed":
              return "text-bg-danger";


          default:
            return "text-bg-light";
        }
      },

      getStatusTitle: function() {
        let status =  toLower(this.trans(this.data.status));
        return Boolean(this.data.exception) ? status + this.trans('click_to_view_exception') : this.trans(this.data.status);
      }
    },

    methods: {
      onClose() {
				this.showModal = false;
			},
    },

	};

</script>

<style type="text/css">
  .log-status{
    min-width : 65px;
  }
</style>
