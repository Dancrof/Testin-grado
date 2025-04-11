
<template>
	
	<li class="nav-item dropdown">
		
		<a class="nav-link font-1" data-bs-toggle="dropdown" href="javascript:;" @click="reloadNotifications">
			<div>
					<i class="far fa-bell"></i>
					<div class="indicator" :style="{'border-color':indicatorBackground}" v-if="notification_count > 0"></div>
				</div>
		</a>
		
		<div class="dropdown-menu dropdown-menu-xl dropdown-menu-end inapp-notify-drop">
			
			<span class="dropdown-header">{{trans('you_have')}} {{ notification_count }} {{trans('unread_notification')}}</span>
			<div class="dropdown-header notify-actions row" v-if="handledData.length > 0">
				<div class="row">
					<div class="col-sm-6 read">
						<a href="javascript:;" @click="markALLSeen" v-if="notification_count > 0 "><span><i class="fas fa-circle"></i></span>&nbsp;{{trans('mark_all_as_read')}}</a>
					</div>
					<div class="col-sm-6 delete pe-0">
						<a href="javascript:;" @click="deleteAll" class="float-end"><span><i class="fas fa-trash-alt"></i></span>&nbsp;{{trans('delete_all')}}</a>
					</div>
				</div>	
			</div>
			<div class="scrollable-ul" id="activity_scroll" @scroll="handleScroll">

				<div  v-if="handledData.length > 0">
				
					<template v-for="(item,index) in handledData">
							
						<div class="dropdown-divider"></div>

						<a href="javascript:;" @click="makeSeen(item)" class="dropdown-item" :class="{'bg-light' : !item.is_read, 'bg-whitte' : item.seen, 'pointer-normal' : item.action_link === ''}">
							
							<div class="media">
								
								<faveo-image-element id="size-30" :source-url="item.notified_by.profile_pic" :classes="['img-size-50 me-3 img-circle elevation-2 img-rounder']"
									alternative-text="User Image"/>

								<div class="media-body">
									
									<h3 class="dropdown-item-title text-primary" v-tooltip="item.user">{{subString(item.user)}}</h3>
									
									<p class="text-gray break-word" v-html="item.notify_message" v-tooltip="{ content: item.notify_message, html: true }"></p>
									
									<p class="text-xs text-muted"><i class="far fa-clock me-1"></i> <i>{{formattedTime(item.created_at)}}</i></p>
								</div>
							</div>
						</a>
					</template>

<!--					<infinite-loading @infinite="getLogs" ref="infiniteLoading">		-->
<!--						<div slot="spinner"></div>								-->
<!--						<div slot="no-results"></div>-->
<!--						<div slot="no-more"></div>-->
<!--					</infinite-loading>-->

					<infinite-loading @infinite="getLogs">
						<template #spinner><span></span></template>
						<template #complete><span></span></template>
					</infinite-loading>
				</div>

<!-- 				<div v-if="!showLoader && !handledData.length">
					<h6 class="text-center">{{trans('no-records')}}</h6>
				</div> -->
			</div>
			
			<div v-if="showLoader" class="mb-3">
				<reuse-loader  :animation-duration="4000" :size="30"/>
			</div>
		</div>

		<custom-loader v-if="loading"  :animation-duration="4000"/>
	</li>
</template>

<script type="text/javascript">
	
	import axios from 'axios';
    import { computed }  from 'vue';
    import { useStore } from 'vuex';
    import { getSubStringValue } from "../../../../helpers/extraLogics";
    import {errorHandler} from "../../../../helpers/responseHandler";

  export default {

        setup() {

            const store = useStore();

            return {
                // getter
                formattedTime: computed(() => store.getters.formattedTime),
                formattedDate: computed(() => store.getters.formattedDate),
            };
        },

		props : {

			userId : { type : [String, Number], default : ''},

			callingFrom : { type : String, default : '' },

			headerBackground: {type: String, default : '' }
		},

		data(){

			return {

				loading: false,
					
				notifications : [],

				count : 0,

				notification_count : 0,

				handledData : [],

				page : 1,

				showLoader: false,

				initialLoading : true,

				backgroundColors : {
					"navbar-light" : "#f8f9fa",
					"navbar-dark navbar-blue" : "#3c8dbc",
					"navbar-dark navbar-black": "#343a40",
					"navbar-dark navbar-green" : "#28a745",
					"navbar-dark navbar-purple" : "#6f42c1",
					"navbar-dark navbar-red" : "#dc3545",
					"navbar-light navbar-yellow": "#ffc107",
					"navbar-light navbar-orange": "#fd7e14",
				},
				indicatorBackground : "#FFF"
			}
		},

		beforeMount(){
			this.indicatorBackground = this.backgroundColors[this.headerBackground]
			this.getInitialLogs();
		},

		created() {

			window.emitter.on('update-sidebar',this.getCount);
		},

		methods: {
		
			subString(value,length = 30){

        		return getSubStringValue(value,length)
      		},

      		reloadNotifications()
      		{
      			if(this.initialLoading) {
      				this.initialLoading = false;
      				return false;
      			}
      			this.getInitialLogs();
      		},

			getInitialLogs() {

				this.handledData = [];

				this.notifications = [];

				this.page = 1;

				this.getLogs();
			},

			getLogs($state, isRefresh = false) {

				this.showLoader = true;

				axios.get('/api/in-app/auth/notifications', { params: { page: this.page } }).then(res => {

					if(isRefresh) {

						this.notifications = res.data.data;

					} else {

						this.notifications.push(...res.data.data);
					}

					$state && $state.loaded();

					if (res.data.data.length < 10) $state && $state.complete();

					this.page++;

					this.notification_count = res.data.unread_count;

					this.handleData(this.notifications)

					this.showLoader = false;

				}).catch(error => {

					this.showLoader = false;

		 			this.notifications = [];
	  			})
			},

			handleData(data){

				for(var i in data){

					if (data[i].notified_by == null || typeof data[i].notified_by.full_name == "undefined") {
						data[i]['user']= 'Elea';
						var profile_pic =  this.basePathVersion()+"/themes/default/common/images/system.png";
						data[i]['notified_by']= {'profile_pic':profile_pic};

					} else {
						data[i]['user'] = data[i].notified_by.full_name;
					}

				}

				this.handledData = data;
			},

			makeSeen(item){

				let redirectUrl = item.action_link.includes('panel') ? item.action_link.replace(this.basePath()+'/panel','') : item.action_link.replace(this.basePath(),'');

				if(item.seen) {

					this.redirectTo(redirectUrl);

				} else {

					this.loading = true;

					axios.patch('/api/in-app/auth/mark-read/'+item.id).then(res=>{

						this.loading = false;

						this.notification_count = this.notification_count-1;

						this.redirectTo(redirectUrl);

					}).catch(error=>{

						this.loading = false
					})
				}
			},

			markALLSeen()
			{
				this.loading = true;

				axios.patch('/api/in-app/auth/mark-read/').then(res=>{

					this.loading = false;

					this.getInitialLogs()

				}).catch(error=>{

					this.loading = false
				})
			},

			deleteAll()
			{
				this.loading = true;

				axios.delete('/api/in-app/auth/delete').then(res=>{

					this.loading = false;

					this.getInitialLogs()

				}).catch(error=>{

					this.loading = false
				})
			},

			redirectTo(redirectUrl) {

        // Check if the 'redirectUrl' includes specific paths related to agent export or service desk change print
				if(redirectUrl.includes('/agent/export/download/') || redirectUrl.includes('/admin/view/import-tracking-details') || redirectUrl.includes('ticket-print')
            || redirectUrl.includes('service-desk/change-print') || redirectUrl.includes('user/list/download/') || redirectUrl.includes('/billing-user-packages')) {

          axios.get(redirectUrl).then(res=>{

            // if redirectUrl is not expired.
            window.open((this.basePath()+redirectUrl));

          }).catch(err=>{

            //if the redirectUrl is expired.

            errorHandler(err,'layout');
          })

				} else if(redirectUrl.includes('/service-desk/import-tracking/')){

          window.open((redirectUrl.replace(this.basePath(),this.basePath()+'/admin')));

				}else {

					if(this.callingFrom == 'admin' && !redirectUrl.includes('system-backup')) {

						this.redirect('/panel'+redirectUrl);

					} else {

            if(redirectUrl.includes('user/list')){

              this.redirect('/panel'+redirectUrl);

            }else{

              redirectUrl.includes('/admin/system-backup') ? this.redirect(redirectUrl) :
                  this.$router.push({ path : redirectUrl });
            }
					}
				}
			}
		}
	};
</script>

<style type="text/css" scoped>

	.break-word { word-break: break-word; }
	#size-30{
		width: 50px !important;
		height: 50px !important;
	}

	.navbar-badge{
		padding : 1px 4px !important;
	}

	.scrollable-ul {
    max-height: 280px;
    overflow-y: auto;
    overflow-x: auto;
    padding-bottom: 5px;
  }

	.scrollable-ul::-webkit-scrollbar-track
  {
    background-color: #f1f1f1;
    border-radius:10px;
  }

  .scrollable-ul::-webkit-scrollbar
  {
    width: 6px;
    background-color: #f1f1f1;
  }

  .scrollable-ul::-webkit-scrollbar-thumb
  {
    background-color: #c1c1c1;
    border-radius: 10px;
  }
    .indicator {
      position: absolute;
      top: 21%;
      right: 20%;
      left: 50%;
      bottom: 36%;
      background-color: #03f4fc;
      border: 3px solid;
      border-radius: 50%;
    }

    .dropdown-header.notify-actions {
    	display: block;
    	font-size: .775rem;
    	padding: .5rem 1rem;
    	text-align: inherit;
    	color: #6c757d;
	}
	
	.read > a,.delete > a{
    	color: #6c757d;
	}
	.delete {
		text-align: right;
	}

  .pointer-normal{
    cursor: default !important;
  }

  .media{
    display: flex;
    -ms-flex-align: start;
    align-items: flex-start;
  }
</style>