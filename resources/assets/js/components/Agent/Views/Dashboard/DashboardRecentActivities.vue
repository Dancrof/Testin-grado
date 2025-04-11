<template>
  <div class="card card-light dashboard-widget-box">
		
		  <div class="card-header">
			  <h3 class="card-title">
				  <i class="far fa-bell" aria-hidden="true"> </i> {{lang('recent_activities')}}
			  </h3>
			  <div class="card-tools">
				
				  <button type="button" class="btn btn-tool" :class="loading ? 'rotating': ''" data-card-widget="refresh" @click="refreshData()" v-tooltip="lang('refresh')">
					
					  <i class="fas fa-sync-alt"></i>
				  </button>
			  </div>
		  </div>
		  <div class="card-body scrollable-area" v-if="notificationData.length > 0">
			  <ul class="products-list product-list-in-card">
				  <li class="item" v-for="activity in notificationData" :key="activity.id">
					  <div class="product-img">
						  <faveo-image-element :id=" 'user_img_' + activity.id" :source-url="activity.notified_by ? activity.notified_by.profile_pic: basePathVersion()+'/themes/default/common/images/system.png'" default-image="system.png" :classes="['img-circle', 'img-rounder']" alternative-text="activity.notified_by ? activity.notified_by.full_name: 'Elea'"/>
					  </div>
					  <div class="product-info fw-400" style="padding-top: 1rem;">
						  <div class="row">
							  <div class="col-sm-2">
								  {{ activity.notified_by ? activity.notified_by.full_name : 'Elea' }}
							  </div>
							  <div class="col-sm-8">

                  <a class="product-title  fw-400"  :href="getLink(activity.action_link)" @click.prevent="checkUrl(activity.action_link)"  @contextmenu="handleContextMenu(activity.action_link)" target="_blank">
                    <span  v-html="activity.notify_message"></span>
                  </a>
								  
							  </div>
							  <div class="col-md-2">
								  <span class="float-end">{{formattedTime(activity.created_at)}}</span>
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
    <div v-if="hasDataFetched && notificationData.length === 0" class="no-data-section">{{lang('no_data_available')}}</div>
  </div>
</template>

<script>
import { errorHandler } from "../../../../helpers/responseHandler";
import axios from 'axios';

import DashboardHelp from "./DashboardHelp.vue";
import {useStore} from "vuex";
import {computed} from "vue";


	export default {
		
    name : 'dashboard-recent-activities',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},
  
		data: () => {
			return {
				notificationData: [],
        page: 1,
        hasDataFetched: false,
        loading: false
      }
		},

		beforeMount() {
			this.getDataFromServer();
		},
		
		methods: {

			getLink(url) {
          return url.includes('/import-tracking/') ? url.replace(this.basePath(), this.basePath() + '/admin') : url;
			},

      checkUrl(url) {

        // Check's the redirectUrl for the export in the url.
        if(url.includes('/export/download')){
          axios.get(url).then(res=>{

            // if redirectUrl is not expired.
            let redirectUrl = url.replace(this.basePath(),'');

            this.redirect(redirectUrl);

          }).catch(err=>{

            //if the redirectUrl is expired.
            errorHandler(err,'dashboard-page');
          })
        }
        else{

          // if the url has import-tracking then need to change the basepath.
          window.open(url.includes('/import-tracking/')
              ? url.replace(this.basePath(), this.basePath() + '/admin')
              : url)
        }
      },

      handleContextMenu(url) {

        // if the url has the export the context menu will be displayed.

        if (url.includes('/export/download')) {
          
          event.preventDefault();
         }
      },

			getDataFromServer($state, isRefresh = false,reqParam = '') {
        this.loading  = true;
        // this.$store.dispatch('startLoader', this.$options.name);
				axios.get('api/in-app/auth/notifications'+reqParam, { params: { page: this.page } })

        .then(response => {
          this.updateData(response.data.data, $state, isRefresh);
          this.loading  = false;
        })
        .catch(error => {
          this.loading  = false;
          errorHandler(error, 'dashboard-page');
				})
      },

      updateData(data, $state, isRefresh) {

		  if(isRefresh) {
			  this.notificationData = data;
		  } else {
			  this.notificationData.push(...data);
		  }

		  $state && $state.loaded();

		  if (data.length < 10) $state && $state.complete();

		  this.page++;

        this.hasDataFetched = true;
      },
      
      refreshData() {
        this.hasDataFetched = false;
        this.page = 1;
		  this.notificationData = [];
		  this.getDataFromServer(undefined, true,'?refresh=1');
      }
			
    },
    
    components: {

      'dashboard-help': DashboardHelp
    }

	};
</script>

<style type="text/css" scoped>

.fw-400{ font-weight: 400; }

/* Create a rotation animation */
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

.products-list .product-img {
  float: left;
}

.products-list .product-img img {
  height: 50px;
  width: 50px;
}
</style>