<template>
		
	<div>
		
		<alert componentName="DeptReport"/>

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

						<date-time-field :label="trans('select_date_range')"
							:value="date"
							type="date"
							name="date"
							:required="false"
							:onChange="onChange" range
							:currentYearDate="false"
						    :place="trans('select_date_range')"
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

    import DateTimePicker from "../../../../MiniComponent/FormField/DateTimePicker.vue";

	export default {

		name : 'department-report',

		description : 'Department report page',

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
					'dept-ids[]' : this.id,
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