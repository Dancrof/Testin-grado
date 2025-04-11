<template>

	<div class="h-300">

		<Line :data="datacollection" :options="options" :id="chartId"/>
	</div>
</template>

<script>

	import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js'

	import { Line } from 'vue-chartjs'

	ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend)

  	import { boolean } from '../helpers/extraLogics';

	import ChartDataLabels from 'chartjs-plugin-datalabels';
	ChartJS.register(ChartDataLabels);

	export default {

		components: { Line },

    	props: {

			chartData : { type : Object },

			redirectUrls: { type: Array, default: () => []},

      		chartOptions: { type: Object, default: null },

      		labelString: { type: String, default: () => '' },

      		chartTitle: { type: Object, default: function () {return { display: false } }},

      		chartId: { type: String, required: true },
    	},

    	data () {

			return {

				datacollection: {

				  	//Data to be represented on x-axis
				  	labels: this.chartData.labels,

				  	// Array of chart data
				  	datasets: this.chartData.data
				},

				//Chart.js options that controls the appearance of the chart
				options: {

					responsive: true,

					title: this.chartTitle,

					plugins :{

						datalabels: {
							display : false,
							color: '#000',
							anchor: 'end',
							clamp: true,
							align: 'right'
						},
					},

          layout: {

            padding: {
              left: 0,
              right: 0,
              top: 24,
              bottom: 0
            }
          },

					scales: {

						y: {

							beginAtZero: true,

							title: {
								display: true,
								text: this.chartData.dataLabel
							},

							border: {
								display: false
							},

							grid: {
								display: true,
								drawOnChartArea: true,
								drawTicks: true,
							},

							ticks : {
								precision : 0
							},

              min : 0
						},

						x: {

							border: {
								display: false
							},

							grid: {
								display: false,
								drawOnChartArea: false,
								drawTicks: false,
							},

							title: {
								display: true,
								text: this.chartData.categoryLabel
							}
						},
          			},

            		onHover: this.onHover,

          			maintainAspectRatio: false,

					onClick: this.clickHandler
        		}
      		}
    	},

    	beforeMount() {
		  	/**
		   	* If prop `chartOptions` is not passed, use default chart option
		   	*/
		  	if (this.chartOptions !== null) {
				this.options = this.chartOptions;
		  	}

			this.chartData.data.forEach(obj=>{
				obj['tension'] = 0.3
			})

		},

		mounted() {

			setTimeout(() => {

				ChartJS.defaults.plugins.datalabels.display = true;

			}, 1000);
		},

    methods: {

		clickHandler (point, event, chart) {

			if (boolean(event) && boolean(this.chartData.redirectURLs)) {

				const redirectLink = this.chartData.redirectURLs[event[0].datasetIndex][event[0].index];

				if (boolean(redirectLink)) {

					let params = JSON.parse('{"' + decodeURIComponent(redirectLink.split('?')[1]).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"') + '"}')

					this.$router.push({ path : redirectLink.replace(this.basePath(),''), query : params});
				}
			}
		},

		onHover(event, items) {
			try {
				const el = document.getElementById(this.chartId);
				let datasetIndex = items[0].datasetIndex;
				el.style.cursor = 'default';
				if(typeof datasetIndex !== 'undefined' && this.chartData.redirectURLs[datasetIndex][items[0].index]) {
					el.style.cursor = 'pointer';
				}
			} catch (error) {
				// Do nothing
			}
		}
    }
  }
</script>

<style scoped>
.h-300{ height: 300px; }
</style>