<template>
		
	<div>
		
		<alert componentName="TeamReport"/>

		<div class="card card-light ">
		
			<div class="card-header">
			
				<h3 class="card-title" v-tooltip="trans('report')">{{trans('report')}}</h3>

        <div v-if="loading" class="card-tools">

          <button type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

            <i class="fas fa-sync-alt"></i>
          </button>
        </div>
			</div>
			
			<div class="card-body">
			
					<div class="row">

						<date-time-field :place="trans('select_date_range')"
							:label="trans('select_date_range')"
							:value="date" 
							type="datetime" 
							name="date"
			         	:onChange="onChange" 
			         	range
			         	:required="false" 
			         	format="MMMM DD YYYY, h:mm a"
			         	classname="col-md-8 col-sm-12 col-12"
			         	:clearable="false" 
			         	:disabled="false" 
			         	:editable="true"
			        	 	:currentYearDate="false" 
			         	:time-picker-options="timeOptions"
			        	>
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
    import DateTimePicker from "../../../../MiniComponent/FormField/DateTimePicker.vue";

	export default {

		name : 'team-report',

		description : 'Team report page',

		props : { 

			id : { type : [String, Number], default : '' },

      disableLoader : {type: Boolean, default: false}
		},

		data() {

			return {

				chartData : '',

				updated_at : '',
				
				date  :'',
				
				apiUrl : '/api/ticket-chart-report',
				
				loading : true,

				timeOptions:{  start: '00:00', step: '00:30',  end: '23:30' },
			}
		},

		computed : {

			isMobile () {
	     
	      return (window.innerWidth <= 800 && window.innerHeight <= 600)
	    }
		},

		beforeMount(){

			this.getChartData();
		},

		created(){

			window.emitter.on('refreshOrgReport',this.getChartData)
		},

		methods : {

			onChange(value,name){

				let val =  'date::' + value.map(date => moment(date).format('YYYY-MM-DD HH:mm:ss')).join('~');

				this.updated_at = val;
				
				if(value){
				
					this.getChartData();	
				}
			},

			getChartData(){

				this.loading = true;
				
				axios.get(this.apiUrl,{
					params : {
					'team-ids[]' : this.id,
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
										stepSize: 1,
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

			'date-time-field': DateTimePicker,
		}
	};
</script>

<style scoped>
	
.fullCanvas {
	width: 100%;
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