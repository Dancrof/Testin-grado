<template>
  <div class="card card-light dashboard-widget-box">
		
		  <div class="card-header">

        <template v-if="hasDataFetched && topAgentData">

          <h3 class="card-title"><i class="far fa-star" aria-hidden="true"> </i> {{topAgentData.title}}</h3>
          <dashboard-help :helplink="topAgentData.helpLink" :description="topAgentData.description" />&nbsp;
          <sup style="font-size: 14px;"><span class="badge text-bg-info">Beta</span></sup>

        </template>
			  <div class="card-tools">
				
				  <button type="button" class="btn btn-tool" :class="loading ? 'rotating': ''" data-card-widget="refresh" @click="refreshData()" v-tooltip="lang('refresh')">
					
					  <i class="fas fa-sync-alt"></i>
				  </button>
			  </div>
		  </div>
		  <div class="card-body scrollable-area" v-if="hasDataFetched && topAgentData">
			  <div class="col-md-12" style="padding-bottom: 0.8rem;" v-for="(agentData, index) in topAgentData.data" :key="index">
				  <div class="progress-group" :title="agentData.description">
					  <span class="progress-text">{{agentData.key}}</span>
					  <span class="progress-number"><b>{{agentData.value ? agentData.value + '%' : ''}}</b></span>
					  <div class="progress sm">
						  <div :class="getProgressBarClass(agentData.value)" :style="getProgressBarStyle(agentData.value)"></div>
					  </div>
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
		
    name : 'dashboard-agent-performance-widget',
  
		data: () => {
			return {
        topAgentData: null,
        hasDataFetched: false,
        loading: false
      }
    },

    beforeMount() {
      this.getDataFromServer();
    },
    
    methods: {

			getDataFromServer(params = '') {
        this.loading  = true;
        //this.$store.dispatch('startLoader', this.$options.name);
        axios.get('api/agent/dashboard-report/agent-performance-widget'+params)

        .then(response => {
          this.topAgentData = response.data.data;
          this.hasDataFetched = true;
          this.loading  = false;
        })
        .catch(error => {
          errorHandler(error, 'dashboard-page');
          this.loading  = false;
        })
        .finally(() => {
	        this.hasDataFetched = true;
        })
      },

      getProgressBarClass(value) {
        if(value >= 90) {
          return 'progress-bar progress-bar-green';
        } else if(value >= 70) {
          return 'progress-bar progress-bar-aqua';
        } else if(value >= 50) {
           return 'progress-bar progress-bar-yellow';
        } else {
          return 'progress-bar progress-bar-red';
        }
      },

      getProgressBarStyle(value) {
        if(value === null) {
          value = 0;
        }
        return { width: value + '%' }
      },

      refreshData() {
	      this.hasDataFetched = false;
        this.getDataFromServer('?refresh=1');
      }
    },
    
    components: {

      'dashboard-help': DashboardHelp
    }
	};
</script>

<style type="text/css" scoped>

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