<template>

  <div class="inbox-threads" id="inbox-thread-body">

      <div :class="{'scrollable-thread' : !maximized}" id="thread_scroll" @scroll="handleScroll">

        <div class="timeline" v-if="inboxThreads">

          <template v-for="(thread,index) in inboxThreads" :key="'thread'+index">

            <div class="time-label" v-if="checkDate(index)">

              <span class="text-bg-light border">{{formattedDate(thread.created_at)}} </span>
            </div>

            <thread-body :pluginStatus="pluginStatus" :showRedaction="true" from="inbox" :thread="thread" :total="total" :index="index" :max="maximized" :ticketId="ticketId" :ticketMerged="ticketMerged"
                :showThreadActions="showThreadActions">

            </thread-body>

            <div v-if="showThreadEnd(index)">

              <i class="timeline-icon fas fa-history text-bg-secondary"></i>
            </div>
          </template>

          <infinite-loading v-if="showInfinite" @infinite="getData" :firstload="false" ref="infiniteLoading">
			  <template #spinner><span></span></template>
			  <template #complete><span></span></template>
          </infinite-loading>

        </div>
      </div>
  </div>
</template>

<script>

import {useStore} from 'vuex';

import { errorHandler } from "../../../../../../helpers/responseHandler";

import axios from 'axios';

import {getIdFromUrl, parseUrlParams} from "../../../../../../helpers/extraLogics";
import ThreadBody from "./Mini/ThreadBody.vue";
import {computed} from "vue";

export default {

  name : 'inbox-threads',

  description : 'Inbox Threads Component',

	setup() {

		const store = useStore();

		return {

			formattedTime : computed(()=>store.getters.formattedTime),

			formattedDate : computed(()=>store.getters.formattedDate)
		}
	},

  props : {

	  ticketId : { type : [String, Number], default : '' },

    maximized : { type : Boolean, default : false },

    ticketMerged : { type : Boolean, default : false },

    pluginStatus : { type : Boolean, default : false },

    trigger : { type : String, default : '' },

	  showThreadActions : { type : Boolean, default : true }
  },

  data() {

    return {

      inboxThreads : [],

      page : 1,

      showLoader: false,

      ticketNum : this.ticketId,

      refreshThreads: false,

      total:null,

      pluginStatus:'',

      sort_order: '',

      showInfinite: true,

    }
  },

  async created() {
    try {
      const res = await axios.get('api/agent/checkplugin');
      this.pluginStatus = res.data.data.plugin_status;
    } catch (error) {
      errorHandler(error, 'inbox-threads');
    }

    window.emitter.on('updateTimelineThreads', () => {
      this.refreshThreads = true;
    });
  },

  mounted() {
    this.getData();
  },

  watch : {

      showLoader(newValue,oldValue){

        this.$emit('loaderState',newValue);

        this.showLoader = newValue;

        return newValue
      },

      refreshThreads(value){

        if(value=== true){

          this.updateLogs();
      }

      this.refreshThreads = false;

      },

      trigger(val) {

        this.sort_order = val;

        this.getThreads(undefined, true, 'sort');
      },

    },

  methods : {

    updateLogs() {

      this.showLoader = true;

      this.inboxThreads = [];

      this.page = 1;

      this.getThreads(undefined, true);
    },

    getData($state, isRefresh = false){
      this.getThreads($state, isRefresh)
    },

    getThreads($state, isRefresh = false, from) {

      const param_obj = {
        'page' : this.page
      }

      if(from === 'sort') {

        this.page = 1;
        param_obj['page'] = this.page;
        param_obj['sort-order'] = this.sort_order;

        // We are unmounting and immediately mounting infinite loader, so it resets the observer
        this.inboxThreads = [];
        this.showInfinite = false;
        setTimeout(() => (this.showInfinite = true), 0);
      }

      this.showLoader = true;

      this.ticketNum = this.ticketId ? this.ticketId : getIdFromUrl(window.location.pathname);

	    let page = this.page;
      let sort = this.sort_order;
	    let time = Date.now();

	    const urlParams = parseUrlParams();
	    let queryString = Object.entries({ page, sort, time, ...urlParams }).map(([key, value]) => {
		    return `${encodeURIComponent(key)}=${encodeURIComponent(value)}`;
	    }).join('&');

      axios.get('/api/agent/ticket-conversation/'+this.ticketNum+'?'+queryString).then(res => {

        this.total = res.data.data.total;

        this.sort_order = res.data.data.sort_order;

        this.$emit('sortOrder', this.sort_order)

        if (isRefresh) {

          this.inboxThreads = res.data.data.data;

        } else {

          this.inboxThreads.push(...res.data.data.data);
        }

        $state && $state.loaded();

        if (res.data.data.data.length < 10) $state && $state.complete();

        this.page++;

        this.showLoader = false;

      }).catch(error => {

        errorHandler(error, 'inbox-threads');

        this.inboxThreads = [];

        this.showLoader = false;

      })
    },

    checkDate(x) {

      if (x == 0) {

        return true;

      } else {

        var date1 = this.formattedDate(this.inboxThreads[x - 1].created_at);

        var date2 = this.formattedDate(this.inboxThreads[x].created_at);

        if (date1 != date2) {

          return true;
        }
      }
    },

    showThreadEnd(x) {

      return x === this.inboxThreads.length - 1
    },
    handleScroll() {
      const dropdowns = document.querySelectorAll('.rte-autocomplete.dropdown-menu'); // Select all dropdowns
      dropdowns.forEach((dropdown) => {
        dropdown.remove();
      });
    }
  },

  components : {

    'thread-body' : ThreadBody
  }
};
</script>

<style scoped>

.refresh_a { cursor: pointer;color: #777 !important; }

  #thread_scroll::-webkit-scrollbar-track
  {
    background-color: #f1f1f1;
    border-radius:10px;
  }

  #thread_scroll::-webkit-scrollbar
  {
    width: 6px;
    background-color: #f1f1f1;
  }

  #thread_scroll::-webkit-scrollbar-thumb
  {
    background-color: #c1c1c1;
    border-radius: 10px;
  }
.scrollable-thread {
  min-height: 120px;
  max-height: 523px;
  overflow-y: auto;
}

</style>
