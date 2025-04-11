<template>

	<div class="card card-light">

		<div class="card-header pointer" @click="toggleCard">
			
			<h3 class="card-title">{{trans('time-track')}}</h3>

			<div class="card-tools">

        <button v-if="loading && cardOpen" type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

          <i class="fas fa-sync-alt"></i>
        </button>
				
				<button type="button" class="btn btn-tool">

                 <i :class="{'fas fa-angle-up' : cardOpen, 'fas fa-angle-down' : !cardOpen }" class="fs-25"></i>
             </button>
			</div>
		</div>

		<div v-if="cardOpen" class="card-body" id="time-track-list">
			
			<table class="table  table-striped">
					
				<template v-if="total > 0">

					<template  v-for="track in data" :key="track.id" >
						
						<table-row :track="track" :current="pagination" :reloadData="updateData">
						
						</table-row>	
					</template>	
				</template>
					
				<tbody v-if="total > 0">
					
					<tr style="background :none !important">
					
						<td class="mailbox-name">
					
							<div class="ticket_subject">
					
								<h4 style="font-weight:bold">{{lang('total')}}</h4>
					
								<div for="Time and amount details" style="margin-bottom:5px">
					
									<label>
					
										<a style="color:#878686">{{lang('worktime')}}
					
											<span style="color:#bab8b8;font-size: 12px;font-weight: normal;"> (hr:min) : &nbsp;</span>
					
										</a>
									</label>
					
									<span style="font-weight:bold">   {{(Math.floor(totalTime/60) < 10 ) ? ("0"+Math.floor(totalTime/60)):Math.floor(totalTime/60)}}:{{(totalTime%60 < 10) ? ("0" + totalTime%60): totalTime%60}}
									</span> &nbsp;
								</div>
							</div>
						</td>
					</tr>
				</tbody>
					
				<div v-if="total > 10" class="pull-right">
					
					<uib-pagination :records="total" v-model="pagination" class="pagination" :boundary-links="true"
						:per-page="per_page" @paginate="pageChanged()" :options="{chunk:3, chunksNavigation:'scroll'}">
								
					</uib-pagination>
				</div>
			</table>
				
			<div v-if="total == 0">
					
				<p style="text-align:center">{{lang('no-data-to-show')}}</p>
			</div>
		</div>
	</div>
</template>

<script>

	import axios from 'axios'
	
	import {errorHandler} from "../../../../../../../helpers/responseHandler";
	import RecordRow from "./Child/RecordRow.vue";
	import {getQueryParams} from "../../../../../../../helpers/extraLogics";

	export default{
	
		name : 'timetrack-event',

		description : 'time track table page',

		props : {

			id : { type : [String, Number], default : '' }
		},

		data () {
			
			return{
			
				loading:true,

				data:[],

				per_page:null,

				total:null,

				pagination:1,

				paramsObj:{},

				totalTime:null,

				cardOpen : false
			}
		},

		created() {
			
			window.emitter.on('refreshTimeTrack',this.updateTableData)
		},

		methods:{

			toggleCard() {
          
            this.cardOpen = !this.cardOpen;

            if(this.cardOpen) {

            	this.getTableData();
            }
          },

			updateData(){

				this.getTableData()
			},

			updateTableData() {

				this.loading = true;
				
				this.pagination = 1;

				this.getTableData()
			},
			
			getTableData(y){

        this.loading = true;

				var params;

				params = getQueryParams(y);

				axios.get('ticket/'+this.id+'/time-track?'+params).then(res => {
			
					this.loading = false;
			
					this.data = res.data.data.data;
			
					this.per_page = res.data.data.per_page;
			
					this.total = res.data.data.total;
				
					var timesArr=this.data.map(a => a.work_time);
				
					this.totalTime = timesArr.reduce( (accumulator, currentValue) => accumulator + currentValue);
				
				}).catch(err =>{
			
					this.loading =false;
			
					errorHandler(err)
				})
			},

			pageChanged() {

				this.paramsObj['page']=this.pagination;

				this.getTableData(this.paramsObj);

				var elmnt = document.getElementById('time-track-list');
	  			
	  			elmnt.scrollIntoView({ behavior : "smooth"});
			},
		},

		components : {

			'table-row':RecordRow
		},
	};
</script>

<style scoped>
	
	.load_margin { margin-top: 70px;margin-bottom: 70px; }


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