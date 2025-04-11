<template>

	<div class="h-300">

		<Bar :data="chartData" :options="options" :id="chartId"/>
	</div>
</template>

<script>

import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

import { Bar } from 'vue-chartjs'

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)

import { truncateString, hoverHandler } from './utils';

import { boolean } from '../helpers/extraLogics';

import ChartDataLabels from 'chartjs-plugin-datalabels';
ChartJS.register(ChartDataLabels);

export default {

	name: 'App',

	props: {

		chartData : { type : Object },

		redirectUrls: { type: Array, default: () => [] },

		chartOptions: { type: Object, default: null },

		labelString: { type: String, default: () => ''},

		chartId: { type: String, required: true },

		chartTitle: { type: Object, default: function () { return { display: false } } }
	},

	components: { Bar },

	data() {
		return {

			options: {

				indexAxis: 'y',

				responsive: true,

				title: this.chartTitle,

				plugins: {

					datalabels: {
						color: '#000',
						anchor: 'end',
						clamp: true,
						align: 'right'
					},

					legend: false
				},

				layout: {

					padding: {
						left: 0,
						right: 24,
						top: 0,
						bottom: 0
					}
				},

				scales: {

					y: {

						beginAtZero: true,

						title: {
							display: true,
							text: this.labelString
						},

						border: {
							display: false
						},

						grid: {
							display: true,
							drawOnChartArea: true,
							drawTicks: true,
						}
					},

					x: {

						border: {
							display: false
						},

						grid: {
							display: true,
							drawOnChartArea: true,
							drawTicks: true,
						},

						ticks: {

							precision : 0,

							callback: function(val, index) {
								return truncateString(this.getLabelForValue(val));
							},
						},
					},
				},

				maintainAspectRatio: false,

				onClick: this.clickHandler,

				onHover: this.onHover
			}
		}
	},

	beforeMount() {

		if (this.chartOptions !== null) {

			this.options = this.chartOptions;
		}
	},

	mounted() {

		setTimeout(() => {

			ChartJS.defaults.plugins.datalabels.display = true;

		}, 1000);
	},

	methods: {
		/**
		 * Handle click event on chart
		 * open embeded link in new tab
		 */
		clickHandler (point, event) {

			if (boolean(event) && boolean(this.redirectUrls)) {

				const redirectLink = this.redirectUrls[event[0].index];

				if (boolean(redirectLink)) {

					let params = JSON.parse('{"' + decodeURIComponent(redirectLink.split('?')[1]).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"') + '"}')

					this.$router.push({ path : redirectLink.replace(this.basePath(),''), query : params});
				}
			}
		},

		onHover(event, items,chart) {

			hoverHandler(items, this.chartId, this.redirectUrls);
		}
	}
}
</script>

<style scoped>
	.h-300{ height: 300px; }
</style>