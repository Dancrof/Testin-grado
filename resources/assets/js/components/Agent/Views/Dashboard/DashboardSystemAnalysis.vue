<template>
  <div class="card card-light dashboard-widget-box">
		
		  <div class="card-header">
        <template v-if="sysAnalysisData">

          <h3 class="card-title"><i class="fas fa-desktop" aria-hidden="true"> </i> {{sysAnalysisData.title}}</h3>
          <dashboard-help :helplink="sysAnalysisData.helpLink" :description="sysAnalysisData.description" />

        </template>
			  <div class="card-tools">
				
				  <button type="button" class="btn btn-tool" :class="loading ? 'rotating': ''" data-card-widget="refresh" @click="refreshData()" v-tooltip="lang('refresh')">
					
					  <i class="fas fa-sync-alt"></i>
				  </button>
			  </div>
		  </div>
		  <div class="card-body scrollable-area" v-if="sysAnalysisData">
			  <div v-for="(sysAnalysis, index) in sysAnalysisData.data" :key="index">
				  <div class="system-analysis-list">
					  <ul class="nav flex-column">
						  <li v-for="(attribute, index) in sysAnalysis.attributes" :key="index">{{sysAnalysis.title}}
							  <span class="float-end badge text-bg-blue" v-html="attribute.value"></span>
						  </li>
					  </ul>
				  </div>
			  </div>
		  </div>
  </div>   
</template>

<script>
import axios from 'axios';
import { errorHandler} from "../../../../helpers/responseHandler";
import DashboardHelp from "./DashboardHelp.vue";

export default {
		
    name: 'dashboard-system-analysis',
  
		data: () => {
			return {
        sysAnalysisData: null,
        hasDataFetched: false,
        loading: false
      }
    },
    
    beforeMount() {
      this.getDataFromServer();
    },
		
		methods:{
			getDataFromServer(params='') {
        //this.$store.dispatch('startLoader', this.$options.name);
        this.loading = true;
        axios.get('api/agent/dashboard-report/system-analysis'+params)

        .then(response => {
          this.sysAnalysisData = response.data.data;
          this.hasDataFetched = true;
          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
          errorHandler(error, 'dashboard-page');
        })
        .finally(() => {
	        this.hasDataFetched = true;
        })
      },
      refreshData() {
	      this.hasDataFetched = false;
        this.page = 1;
        this.notificationData = [],
        this.getDataFromServer('?refresh=1');
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
.system-analysis-list {
  border-bottom: 1px solid #f4f4f4;
  padding: 10px;
}

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