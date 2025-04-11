<template>

  <div class="card card-light" v-if="showTemplate">

    <div class="card-header pointer" @click="toggleCard">

      <h3 class="card-title">{{trans('ticket_details_associated_tickets')}}</h3>

      <div class="card-tools">

        <button v-if="loading && cardOpen" type="button" class="btn btn-tool rotating" data-card-widget="refresh">

          <i class="fas fa-sync-alt"></i>
        </button>

        <button type="button" class="btn btn-tool">

          <i :class="{'fas fa-angle-up' : cardOpen, 'fas fa-angle-down' : !cardOpen }" class="fs-25"></i>
        </button>
      </div>
    </div>

    <div v-if="cardOpen" class="card-body" id="crt-associated-tickets">

      <data-table :url="apiUrl" :dataColumns="columns"  @loaderState="handelLoader" disableLoader="true"
                  scroll_to="crt-associated-tickets" :option="options"></data-table>
    </div>
  </div>
</template>

<script>
import {useStore} from "vuex";
import axios from 'axios';
import {computed} from "vue";
import {RouterLink} from "vue-router";
import {getQueryParams} from "../../../../../../helpers/extraLogics";

export default {

  name: "associated-ticket-crt",

	setup() {

		const store = useStore();

		return {

			formattedTime : computed(()=>store.getters.formattedTime),

			formattedDate : computed(()=>store.getters.formattedDate)
		}
	},

  data() {
    return {
      apiUrl: '',

      columns: ['ticket_number', 'ticket_title', 'status', 'type'],

      options: {},

      cardOpen : false,

      showTemplate: false,

      loading: true
    }
  },

  props : {

    ticketId : {type: [String,Number]},
  },

  beforeMount() {

    this.apiUrl = `api/agent/associated-tickets?`+getQueryParams({ticket_id: this.ticketId});

    this.checkForVisibility();

    const self = this;

    this.options = {

      headings: {ticket_number: this.trans('ticket_number'), type : this.trans('parent/child'), ticket_title: this.trans('subject'), status: this.trans('status')},

      columnsClasses : {
        ticket_number: 'ticket-number', ticket_type_for_crt : 'ticket-type-parent-or-child',
        ticket_title:'ticket-subject', ticket_status: 'associated-ticket-status'
      },

      sortIcon: {

        base : 'glyphicon',

        up: 'glyphicon-chevron-down',

        down: 'glyphicon-chevron-up'
      },

      texts: { filter: '', limit: '' },

      templates: {

        ticket_number: (createElement,row) => {
          let ticket = row.id;
          if (!ticket)
            return '--';
          return self.h(RouterLink, {

              to:'/thread/'+ticket+'?'+getQueryParams()

          }, row.ticket_number)
        },

        status: (createElement, row) => {
          let status = row.status;
          let statusColor = row.status_icon_color;

          if (!status) {
            return '--';
          }

          return self.h('span', {

              class: 'badge',
              style: `background-color: ${statusColor}; color: white`
            
          }, status);
        }
      },

      sortable:  ['ticket_number'],

      filterable:  false, //for hiding search bar

      pagination:{chunk:5,nav: 'fixed',edge:true},

      requestAdapter(data) {

        return {

          'sort_field' : data.orderBy ? data.orderBy : 'id',

          'sort_order' : data.ascending ? 'desc' : 'asc',

          'search_term' : data.query,

          page : data.page,

          limit : data.limit,
        }
      },

      responseAdapter({data}) {
        return {
          data: data.data.data,
          count: data.data.total
        }
      },

	    orderBy: { column: 'id', ascending: true },
    }
  },

  methods : {
    toggleCard() {
      this.cardOpen = !this.cardOpen;
    },

    async checkForVisibility() {
      try {
        let { data } = await axios.get(this.apiUrl + '&count=1&' + getQueryParams());
        let count = data.data.count;
        if (count) {
          this.showTemplate = true;
        }
      } catch (e) {
        console.log("Error, while checking visibility of associated tickets", e);
      }
    },

    handelLoader(loader){
      this.loading = loader
    }
  }
}
</script>

<style scoped>
.ticket-number { width: 25%; word-break: break-word !important; }

.ticket-subject { width: 50%; word-break: break-word !important; }

.associated-ticket-status { width: 25%; word-break: break-word !important; }

.ticket-type-parent-or-child { width: 25%; word-break: break-word !important;  }

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Apply the rotation animation when the button has a class of "rotating" */
.btn-tool.rotating i {
  animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
}
</style>
