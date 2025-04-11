<template>

	<div class="card card-light">

		<div class="card-header">

			<h3 class="card-title">{{trans('versions') }}</h3>

      <div class="card-tools">
        <button v-if="showLoader" type="button" class="btn btn-tool rotating" data-card-widget="refresh">

          <i class="fas fa-sync-alt"></i>
        </button>
      </div>
		</div>

		<div class="card-body" id="revision_scroll" :class="from == 'revision' ? 'scrollable-rev' : 'scrollable-revisions'"
         @scroll="handleScroll">

			<div v-if="revisionData.length > 0">
				
				<ul class="todo-list">
		  			
		  			<template v-for="(log,index) in revisionData">

		  				<li v-if="from == 'revision'" class="pointer" @click="goToRevision(log.id)" 
		  					:class="versionId == log.id ? 'bg-primary' : ''">

		  					<span class="badge text-bg-secondary">{{log.version_number}}</span>
							
							<span v-if="log.user" class="text ms-1" v-tooltip="log.user.full_name">{{subString(log.user.full_name,10)}}</span>&nbsp;
							
							<small v-tooltip="formattedTime(log.created_at)" class="float-end">

								<i class="far fa-clock"></i>&nbsp;{{formatTime(log.created_at)}}
							</small>
		  				</li>

					  	<li v-else class="pointer" @click="goToRevision(log.id)">

							<span class="badge text-bg-secondary">{{log.version_number}}</span>

							<span v-if="log.user" class="text ms-1" v-tooltip="log.user.full_name">{{subString(log.user.full_name)}}</span>&nbsp;

							<small>

								<i class="far fa-clock"></i>&nbsp;{{formatTime(log.created_at)}}
							</small>

							<small class="float-end">{{formattedTime(log.created_at)}}</small>
			  			</li>
			  		</template>
				</ul>

				<infinite-loading @infinite="getRevisions" ref="infiniteLoading">
					<template #spinner><span></span></template>
					<template #complete><span></span></template>
				</infinite-loading>
			</div>
			<div v-if="!showLoader && !revisionData.length">
				<h6 class="text-center">{{trans('no-records')}}</h6>
			</div>
		</div>
	</div>
</template>

<script>

	import {useStore} from 'vuex';

  import moment from "moment";
	
	import { successHandler, errorHandler } from "../../../../../helpers/responseHandler";

	import axios from 'axios';

	import  { getIdFromUrl, getSubStringValue } from "../../../../../helpers/extraLogics";

	import {computed} from "vue";

	export default {

		name : 'article-revisions',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate),

				customFormattedTime : computed(()=>store.getters.customFormattedTime)
			}
		},

		props : {

			articleId : { type : [String, Number], default : '' },

			from : { type : String, default : '' },

			versionId : { type : [String, Number], default : "" }
		},

		data() {

			return {

				revisionData : [],
				
				page : 1,

				showLoader: false,

				articleNum : this.articleId
			}
		},

		beforeMount () {

			this.getRevisions();
		},

		created() {

			window.emitter.on('updateRevisionsData',this.updateRevisions)
		},

		watch : {

			showLoader(newValue,oldValue){

				this.showLoader = newValue;

				return newValue
			}
		},

		methods : {
	
			subString(value,length = 30) {
				
				return getSubStringValue(value, length)
			},

			goToRevision(id) {

				this.$router.push({ path : '/article/revision/'+this.articleId+'/'+id })
			},

			formatTime(value) {

				const then = this.customFormattedTime(value,"YYYY-MM-DD HH:mm:ss");

				const now  = moment(new Date()).format("YYYY-MM-DD HH:mm:ss");

				const ms = moment(now,"YYYY-MM-DD HH:mm:ss").diff(moment(then,"YYYY-MM-DD HH:mm:ss"));

				const days = Math.floor(ms / (24*60*60*1000));
				
				const daysms = ms % (24*60*60*1000);
				
				const hours = Math.floor(daysms / (60*60*1000));
				
				const hoursms = ms % (60*60*1000);
				
				const minutes = Math.floor(hoursms / (60*1000));
				
				const minutesms = ms % (60*1000);
				
				const sec = Math.floor(minutesms / 1000);

				if(days) {

					return days + ' days ago'
				
				} else if(!days && hours) {

					return hours + ' hours ago'
				
				} else if(!days && !hours && minutes){

					return minutes + " minutes ago"

				} else {

					return sec + " seconds ago"
				}
			},
			
			updateRevisions() {

				this.showLoader = true;

				this.revisionData = [];

				this.page = 1;

				setTimeout(()=>{
					
					this.getRevisions(undefined, true);
				},1000);				
			},

			getRevisions($state, isRefresh = false) {

				this.showLoader = true;

				 this.articleNum = this.articleId ? this.articleId :  getIdFromUrl(window.location.pathname);

				axios.get('/api/article/get-version-data/'+ this.articleNum, { params: { page: this.page } }).then(res => {

					if(isRefresh) {

						this.revisionData = res.data.message.data;

					} else {

						this.revisionData.push(...res.data.message.data);
					}

					$state && $state.loaded();

					if (res.data.message.data.length < 10) $state && $state.complete();

					this.page++;

				}).catch(error => {

					errorHandler(error, 'article-create');

					this.revisionData = [];
				
				}).finally(() => {

					this.showLoader = false;
				})
			}
		}
	};
</script>

<style scoped>
	#revision_scroll::-webkit-scrollbar-track
	{
		background-color: #f1f1f1;
		border-radius:10px;
	}

	#revision_scroll::-webkit-scrollbar
	{
		width: 6px;
		background-color: #f1f1f1;
	}

	#revision_scroll::-webkit-scrollbar-thumb
	{
		background-color: #c1c1c1;
		border-radius: 10px;
	}

	.scrollable-revisions {
		height: 242px;
		overflow-y: auto;
	}

	.scrollable-rev {
		height: 600px;
		overflow-y: auto;
	}

	.point_cursor { cursor: pointer; }

	.img-30 {height: 30px;width: 30px;}

	.mt_6 { margin-top: 6px; }

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