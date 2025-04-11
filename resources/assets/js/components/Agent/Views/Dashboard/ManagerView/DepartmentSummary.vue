<template>
  
  <div class="card card-light dashboard-widget-box">
		
		  <div class="card-header">
			
			  <template v-if="departmentSummary.title">
				
				  <h3 class="card-title">
					  <i class="fas fa-sitemap" aria-hidden="true"> </i> {{lang(departmentSummary.title)}}
				  </h3>
				
				  <dashboard-help :helplink="departmentSummary.helpLink" :description="departmentSummary.description" />
			  </template>
			
			  <div class="card-tools">
				
				  <button type="button" class="btn btn-tool" :class="loading ? 'rotating': ''" data-card-widget="refresh" @click="refreshData()" v-tooltip="lang('refresh')">
					
					  <i class="fas fa-sync-alt"></i>
				  </button>
			  </div>
		  </div>
		
		  <div class="card-body scrollable-area" v-if="departmentSummary.data.length > 0">
			
			  <div class="card card-widget widget-user-2 shadow-0" v-for="(department, aindex) in departmentSummary.data" :key="aindex">
				
				  <div class="widget-user-header" style="padding: 0px;">
					
					  <h3 class="widget-user-username widget-name">{{department.title}}</h3>
				  </div>
				
				  <div class="card-footer p-0">
					
					  <ul class="nav flex-column bg-white">
						
						  <li  class="nav-item" v-for="(attribute, index) in department.attributes" :key="index">
							
							  <a class="nav-link department-list">{{attribute.key}}
								
								  <span class="float-end badge text-bg-primary font-14 pad-0">
                  
                  <router-link :to="getRoute(attribute.value,'href')" :class="getRoute(attribute.value,'className')">{{getRoute(attribute.value,'textContent')}}

                    </router-link>
                </span>
							  </a>
						  </li>
					  </ul>
				  </div>
			  </div>
			
			  <infinite-loading @infinite="getDataFromServer">
				  <template #spinner><span></span></template>
				  <template #complete><span></span></template>
			  </infinite-loading>
		  </div>

    <div v-if="hasDataFetched && departmentSummary.data.length === 0 && !refresh" class="no-data-section">{{lang('no_data_available')}}</div>
  </div>
</template>

<script>
import axios from 'axios';
import { errorHandler} from "../../../../../helpers/responseHandler";
import DashboardHelp from "../DashboardHelp.vue";

export default {
		
    name : 'dashboard-department-summary',
  
		data: () => {
			return {
        departmentSummary: {
          title: '',
          data: []
        },
        hasDataFetched: false,
        page : 1,
        refresh : false,
        loading  : false
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

			getDataFromServer($state,isRefresh,reqParam='') {
        //this.$store.dispatch('startLoader', this.$options.name);
        this.loading =  true;
        axios.get('api/agent/dashboard-report/manager/department-analysis'+reqParam, { params: { page: this.page } })

        .then(response => {
          this.updateData(response.data.data, $state, isRefresh);
          this.loading  = false;
        })
        .catch(error => {
          this.refresh = false;
          this.loading  = false;
          errorHandler(error, 'dashboard-page', this.$options.name);
        })
      },

      updateData(responseData, $state, isRefresh) {
        this.departmentSummary.title = responseData.title;
        this.departmentSummary.description = responseData.description;
        this.departmentSummary.helplink = responseData.helpLink;

		  if(isRefresh) {
			  this.departmentSummary.data = responseData.data;
		  } else {
			  this.departmentSummary.data.push(...responseData.data);
		  }

		  $state && $state.loaded();

		  if (responseData.data.length < 10) $state && $state.complete();

		  this.page++;

        this.hasDataFetched = true;
        this.refresh = false;
      },

      refreshData() {
        this.refresh = true;
	      this.hasDataFetched = false;
        this.page = 1;
        this.departmentSummary.data = [];
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
.attribute-value-text {
  font-size: 16px;
}
.shadow-0{ box-shadow: none !important; }

.widget-name {
  margin-left: 0 !important;
  padding-bottom: 5px;
  font-size: 20px !important;
  border-bottom: none !important;
}
.font-14 { font-size: 14px !important; }

.pad-0 { padding: 0px; }

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

.department-list {
  color: #3c8dbc;
}

.department-list:hover {
  color: #0366d6;
}
</style>