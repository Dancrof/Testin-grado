<template>
		
	<div class="org-tic-report">
		
		<alert componentName="UserReport"/>

		<div class="card card-light ">
		
			<div class="card-header pointer" @click="toggleCard">
			
				<h3 class="card-title" v-tooltip="lang('report')">{{lang('report')}}</h3>

				<div class="card-tools">

          <button v-if="loading && cardOpen" type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

            <i class="fas fa-sync-alt"></i>
          </button>
					
					<button type="button" class="btn btn-tool">

                  <i :class="{'fas fa-angle-up' : cardOpen, 'fas fa-angle-down' : !cardOpen }" class="fs-25"></i>
              </button>
				</div>
			</div>
			
			<div v-if="cardOpen" class="card-body">
			
					<div class="row">
						
						<date-time-field :label="lang('select_date_range')" :place="lang('select_date_range')"
							:value="date"
							type="date"
							name="date"
							:required="false"
							:onChange="onChange" range
							:currentYearDate="false"
							format="YYYY-MM-DD" classname="col-md-6 col-sm-12 col-12" :confirm="true"
							:clearable="true" :editable="true" :disabled="false" :after="new Date()">
						</date-time-field>
					</div>

					<div class="row">
							
						<div v-if="!loading" class="col-md-12 col-sm-12 col-12">
						
							<canvas id="trafficBar"></canvas>
						</div>
						
						<hr class="visible-xs-block">
					</div>
			</div>
		</div>
	</div>
</template>

<script>

	import Chart from 'chart.js/auto';
	
	import moment from 'moment';

	import axios from 'axios';
	import DateTimePicker from "../../../MiniComponent/FormField/DateTimePicker.vue";

	export default {

		name : 'user-report',

		description : 'User report page',

		props : { 

			id : { type : [String, Number], default : '' },
		},

		data() {

			return {

				chartData : '',

				updated_at : '',
				
				date  :'',
				
				apiUrl : '/api/ticket-chart-report',
				
				loading : true,

				cardOpen : false
			}
		},

		computed : {

			isMobile () {
	     
	      return (window.innerWidth <= 800 && window.innerHeight <= 600)
	    }
		},

		created(){

			window.emitter.on('refreshOrgReport',this.getChartData)
		},

		methods : {

			toggleCard() {
          
             this.cardOpen = !this.cardOpen;

             if(this.cardOpen){
             	
             	this.getChartData();
             }
         },

			onChange(value,name){

				let filteredVal = value.filter((item) => item);

				let val = '';

				if(filteredVal.length) {

					val =  'date::' + filteredVal.map(date => moment(date).format('YYYY-MM-DD HH:mm:ss')).join('~');
				}
				
				this.updated_at = val;

				if(value){
				
					this.getChartData();	
				}
			},

			getChartData(){

				this.loading = true;
				
				axios.get(this.apiUrl,{
					params : {
					'organization-ids[]' : this.id,
					'updated-at' : this.updated_at
				}}).then(res=>{
						
					this.chartData = res.data.data;
				
					this.showChart(this.chartData);
					
				}).catch(error=>{
				
					this.loading = false
				})
			},

			showChart(data){
				
				this.loading = false;
				
				var newset = data.datasets.map(el=>{
				
					el = {
				
						label: el.label,
						tension : 0.5,
        
            fill: false,
        
            borderColor: el.border_color,
        
            pointBackgroundColor: el.point_background_color,
        
            backgroundColor: el.background_color,
        
            data: el.data
					}
					return el
				})
				
				let result = newset.map(a => a.data);
				
				let maxRow = result.map(function(row){ return Math.max.apply(Math, row); });

				let step = Math.max.apply(null, maxRow) < 10 ? 1 : '';

				this.$nextTick(() => {
				
					var ctx = document.getElementById('trafficBar').getContext('2d')

					var config = {

						type: 'line',

						data: {

							labels: data.labels,

							datasets: newset
						},

						options: {

							responsive: true,

							maintainAspectRatio: !this.isMobile,

							plugins : {

								legend: {

									position: 'bottom',

									display: true
								},

                datalabels: {
                  color: '#000',
                  anchor: 'end',
                  clamp: true,
                  align: 'bottom',
                  formatter: function (value, context) {
                    return '';
                  },
                  display: function (context) {
                    return false;
                  }
                }
							},

							scales: {

								y: {

									min :0,

									ticks : {
										precision : 0,
										stepSize: step,
									}
								},
							}
						}
					}
					new Chart(ctx, config)
				})
			}
		},

		components : {

			'date-time-field': DateTimePicker
		}
	};
</script>

<style scoped>
	
.fullCanvas {
	width: 100%;
}

.fs-25{ font-size: 25px; }

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