<template>
  
  <div class="card card-light dashboard-widget-box">
		
		  <div class="card-header">
			
			  <template v-if="hasDataFetched && agentsData.title">
				
				  <h3 class="card-title">
					
					  <i class="fas fa-user" aria-hidden="true"> </i> {{agentsData.title}}
				  </h3>
				
				  <dashboard-help :helplink="agentsData.helpLink" :description="agentsData.description" />
			  </template>
			
			  <div class="card-tools">
				
				  <button type="button" class="btn btn-tool" :class="loading ? 'rotating': ''" data-card-widget="refresh" @click="refreshData()" v-tooltip="lang('refresh')">
					
					  <i class="fas fa-sync-alt"></i>
				  </button>
			  </div>
		  </div>
		  <div class="card-body scrollable-area" v-if="agentsData.data.length > 0">
			  <ul class="products-list product-list-in-card">
				  <li class="item" v-for="(agent, aindex) in agentsData.data" :key="aindex">
					  <div class="product-info" v-if="agent.title">
						  <div class="row">
							  <div class="col-md-7">
								  <div class="product-img">
									  <faveo-image-element :id=" 'user_img_' + aindex" :source-url="agent.picture" :classes="['img-circle', 'img-rounder']" alternative-text=""/>
								  </div>
								  <div style="padding-left: 5rem; padding-top: 1.0rem;"><span>

                  <router-link :to="getRoute(agent.title,'href')" :class="getRoute(agent.title,'className')">{{getRoute(agent.title,'textContent')}}

                  </router-link>
                </span></div>
							  </div>
							  <div class="float-end col-md-5">
								  <div v-for="(attribute, index) in agent.attributes" :key="index">
									  <div style="padding: 0.3rem;">{{attribute.key}}: <span class="attribute-value-text float-end">
                    
                    <router-link :to="getRoute(attribute.value,'href')" :class="getRoute(attribute.value,'className')">{{getRoute(attribute.value,'textContent')}}

                    </router-link>
                  </span></div>
								  </div>
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

    <div v-if="hasDataFetched && agentsData && agentsData.data && agentsData.data.length === 0 && !refresh" class="no-data-section">{{lang('no_data_available')}}</div>
  </div>
</template>

<script>
import axios from 'axios';
import { errorHandler} from "../../../../../helpers/responseHandler";
import DashboardHelp from "../DashboardHelp.vue";

export default {
		
    name : 'dashboard-agent-summary',
  
		data: () => {
			return {
        agentsData: {
          title: '',
          data: []
        },
        page: 1,
        hasDataFetched: false,
        refresh : false,
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

			getDataFromServer($state,isRefresh,reqParam='') {
        this.loading = true
        //this.$store.dispatch('startLoader', this.$options.name);
        axios.get('api/agent/dashboard-report/manager/agent-analysis'+reqParam, { params: { page: this.page } })

        .then(response => {
           this.updateData(response.data.data, $state, isRefresh);
           this.loading  = false;
        })
        .catch(error => {
          this.loading  = false;
          this.refresh = false;
          errorHandler(error, 'dashboard-page', this.$options.name);
        })
      },

      updateData(responseData, $state, isRefresh) {
        this.agentsData.title = responseData.title;
        this.agentsData.description = responseData.description;
        this.agentsData.helplink = responseData.helpLink;

		  if(isRefresh) {
			  this.agentsData.data = responseData.data;
		  } else {
			  this.agentsData.data.push(...responseData.data);
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
        this.agentsData.data = [];
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
.product-img { padding-top: 0.5rem; }

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

.products-list .product-img img {
  height: 50px;
  width: 50px;
}

.products-list .product-img {
  float: left;
}

.img-circle {
  border-radius: 50%;
}
img {
  vertical-align: middle;
  border-style: none;
}
</style>