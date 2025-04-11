<template>

  <div class="card card-light dashboard-widget-box">
		
		  <div class="card-header with-border">
			
			  <template v-if="hasDataFetched && ticketData.title">
				
				  <h3 class="card-title">
					
					  <i class="fas fa-exclamation-triangle text-danger" aria-hidden="true"> </i> {{ticketData.title}}
				  </h3>
				
				  <dashboard-help :helplink="ticketData.helpLink" :description="ticketData.description" />
			  </template>
			
			  <div class="card-tools">
				
				  <button type="button" class="btn btn-tool" :class="loading ? 'rotating': ''" data-card-widget="refresh" @click="refreshData()" v-tooltip="lang('refresh')">
					
					  <i class="fas fa-sync-alt"></i>
				  </button>
			  </div>
		  </div>
		
		  <div class="card-body scrollable-area" v-if="ticketData.data.length > 0">
			
			  <ul class="products-list product-list-in-card px-2">
				
				  <li class="item" v-for="(ticket, aindex) in ticketData.data" :key="aindex">
					
					  <div class="product-info">

						<span>

						   <router-link :to="getRoute(ticket.title,'href')" :class="getRoute(ticket.title,'className')">{{getRoute(ticket.title,'textContent')}}

						   </router-link>
						</span> &nbsp;

						
						  <span v-if="ticket.metaData.assigned_to_me" class="badge text-bg-info">{{lang('assigned_to_me')}}</span>&nbsp;
						  <span v-if="ticket.metaData.reopened" class="badge text-bg-warning">{{lang('reopened')}}</span>
						
						  <div class="float-end">
							  <div v-for="(attribute, index) in ticket.attributes" :key="index" class="float-end">
								  <div v-if="attribute.value" :class="ticket.metaData.overdue ? 'text-danger': ''">{{attribute.key}}: <span v-html="attribute.value"></span></div>
							  </div>
						  </div>
					  </div>
				  </li>
				  <infinite-loading @infinite="getDataFromServer">
					  <template #spinner><span></span></template>
					  <template #complete><span></span></template>
				  </infinite-loading>
			  </ul>
		  </div>
    <div v-if="hasDataFetched && ticketData.data.length === 0" class="no-data-section">{{lang('no_data_available')}}</div>
  </div>
</template>

<script>
import axios from 'axios';
import { errorHandler} from "../../../../helpers/responseHandler";
import DashboardHelp from "./DashboardHelp.vue";

	export default {

    name : 'dashboard-require-immediate-action',

		data: () => {
			return {
        ticketData: {
          title: '',
          data: []
        },
        page: 1,
        hasDataFetched: false,
        loading: false
      }
    },

    beforeMount() {
      this.getDataFromServer();
    },

		methods: {

      getRoute(value,attr) {

        var parser = new DOMParser();

        var doc = parser.parseFromString(value, 'text/html');

        return attr == 'href' ? doc.getElementById('hyper_link')[attr].replace(this.basePath(),'') : doc.getElementById('hyper_link')[attr];
      },

			getDataFromServer($state, isRefresh, reqParam='') {

        this.loading = true;
        //this.$store.dispatch('startLoader', this.$options.name);
        axios.get('api/agent/dashboard-report/require-immediate-action'+reqParam, { params: { page: this.page } })

        .then(response => {
          this.updateData(response.data.data, $state, isRefresh);

          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
          errorHandler(error, 'dashboard-page');
        })
      },

      updateData(responseData, $state, isRefresh) {
        this.ticketData.title = responseData.title;
        this.ticketData.description = responseData.description;
        this.ticketData.helplink = responseData.helpLink;

		  if(isRefresh) {
			this.ticketData.data = responseData.data;
		  } else {
			this.ticketData.data.push(...responseData.data);
		  }

		  $state && $state.loaded();

		  if (responseData.data.length < 10) $state && $state.complete();

		  this.page++;

        this.hasDataFetched = true;
      },

      refreshData() {
		  this.ticketData.data = [];
        this.page = 1;
        this.hasDataFetched = false;
        this.getDataFromServer(undefined, true,'?refresh=1');
      }
    },

    components: {

      'dashboard-help': DashboardHelp
    }
	};
</script>

<style type="text/css" scoped>
.products-list .product-info {
  margin-left: 0px !important;
}
.fw-500 { font-weight: 500!important }

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.products-list{
  display: grid;
}

/* Apply the rotation animation when the button has a class of "rotating" */
.btn-tool.rotating i {
  animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
}
</style>