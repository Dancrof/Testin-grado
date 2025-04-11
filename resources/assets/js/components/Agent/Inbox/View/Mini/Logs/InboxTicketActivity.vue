<template>

	<div class="inbox-tic-activity">

		<div :class="{'scrollable-log' : !maximized}" id="activity_scroll">

			<div class="timeline timeline-inverse" v-if="activityLogs.length > 0">
			
				<template v-for="(log,index) in activityLogs">
						
					<div class="time-label" v-if="checkDate(index)">

						<span class="text-bg-light border">{{formattedDate(log.created_at)}}</span>
					</div>

					<div>

						<i class="far fa-dot-circle timeline-icon"></i>

						<div class="timeline-item">

							<span class="time">

								<i class="far fa-clock"></i> {{formattedTime(log.created_at)}}
							</span>

							<div class="timeline-body" id="activity	_desc">
									
								<activity-parser :data="log.text" from="ticket-activity"></activity-parser>
							</div>
						</div>
					</div>

					<div v-if="showThreadEnd(index)">

	              <i class="fas fa-history text-bg-secondary timeline-icon"></i>
	            </div>
				</template>

				<infinite-loading @infinite="getLogs" ref="infiniteLoading">
					<template #spinner><span></span></template>
					<template #complete><span></span></template>
				</infinite-loading>
			</div>
			<div v-if="!showLoader && !activityLogs.length">
				<h6 class="text-center">{{trans('no-records')}}</h6>
			</div>
		</div>
	</div>
</template>

<script>

import {useStore} from 'vuex';
	
	import { errorHandler } from "../../../../../../helpers/responseHandler";

	import axios from 'axios';

import {getIdFromUrl, parseUrlParams} from "../../../../../../helpers/extraLogics";
import {computed} from "vue";
import ThreadBody from "./Mini/ThreadBody.vue";
import ActivityParser from "../../../../../Common/ActivityParser.vue";

	export default {

		name : 'inbox-ticket-activity-log',

		description : 'Inbox Ticket Activity Log Component',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},

		props : {

			ticketId : { type : [String, Number], default : '' },

			maximized : { type : Boolean, default : false }
		},

		data() {

			return {

				activityLogs : [],
				
				page : 1,

				showLoader: false,

				ticketNum : this.ticketId
			}
		},

		beforeMount() {
			  this.getLogs()
		},

		created() {

			window.emitter.on('updateTimelineActivity',this.updateLogs)
		},

		watch : {

			showLoader(newValue,oldValue){

        this.$emit('loaderState',newValue);

				this.showLoader = newValue;

				return newValue
			}
		},

		methods : {

			updateLogs() {

				this.showLoader = true;

				this.activityLogs = [];

				this.page = 1;

        this.getLogs(undefined, true);

			},

			getLogs($state, isRefresh = false) {

				this.showLoader = true;

				 this.ticketNum = this.ticketId ? this.ticketId :  getIdFromUrl(window.location.pathname);

				let page = this.page;
				let time = Date.now();

				const urlParams = parseUrlParams();
				let queryString = Object.entries({ page, time, ...urlParams }).map(([key, value]) => {
					return `${encodeURIComponent(key)}=${encodeURIComponent(value)}`;
				}).join('&');

				setTimeout(()=>{

					axios.get('/api/agent/ticket-activity-log/'+ this.ticketNum+'?' + queryString).then(res => {

						if(isRefresh) {

							this.activityLogs = res.data.data.data;

						} else {

							this.activityLogs.push(...res.data.data.data);
						}

						$state && $state.loaded();

						if (res.data.data.data.length < 10) $state && $state.complete();

						this.page++;

						this.activityLogs.forEach( function(element, index) {

							element['text'] = `<div>`+element['text']+`</div>`
						});

						this.showLoader = false;

			  		}).catch(error => {

				 		errorHandler(error, 'inbox-threads');

				 		this.activityLogs = [];

						this.showLoader = false;
			  		
			  		})
				},1);
			},

			checkDate(x){

				if(x==0){

					return true;

				}else{

					var date1=this.formattedDate(this.activityLogs[x-1].created_at);

					var date2=this.formattedDate(this.activityLogs[x].created_at);

					if(date1!=date2){

						return true;
					}
				}
			},

			showThreadEnd(x){

				return x === this.activityLogs.length-1 
			}
		},

		components : {

			'thread-body' : ThreadBody,

			'activity-parser': ActivityParser,
		}
	};
</script>

<style scoped>
	#activity_scroll::-webkit-scrollbar-track
  {
    background-color: #f1f1f1;
    border-radius:10px;
  }

  #activity_scroll::-webkit-scrollbar
  {
    width: 6px;
    background-color: #f1f1f1;
  }

  #activity_scroll::-webkit-scrollbar-thumb
  {
    background-color: #c1c1c1;
    border-radius: 10px;
  }

  .scrollable-log {
    min-height: 120px;
    max-height: 523px;
    overflow-y: auto;
  }
</style>