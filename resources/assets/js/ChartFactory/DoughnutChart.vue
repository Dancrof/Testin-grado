<template>
	<div>
		<Doughnut :id="chartId" :data="chartData" :options="{

			responsive: true,

			title: this.chartTitle,

			plugins: {

				datalabels: {
					display: 'auto',
					color: '#6c757d',
					anchor: 'end',
					clamp: true,
					align: 'start',
					offset: 10,
					font: {
					  weight: 'bold',
					},
					formatter: this.dataLabelFormatter
				},

				legend: {
					display: true,
					position: 'top'
				},
			},

			maintainAspectRatio: false,

			onClick: this.clickHandler,

			onHover: this.onHover
		}"/>

	</div>
</template>

<script>

import {Doughnut} from 'vue-chartjs'

import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement, CategoryScale } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale)

import { redirectToURL, getDatalabelInPercentage, hoverHandler } from './utils';

import { boolean } from '../helpers/extraLogics';

import ChartDataLabels from 'chartjs-plugin-datalabels';
ChartJS.register(ChartDataLabels);

export default {

	components: { Doughnut },

	props: {

		chartId: { type: String, required: true },

		chartData : { type : Object },

		redirectUrls: { type: Array, default: () => [] },

		labelString: { type: String, default: () => ''},

		chartTitle: { type: Object, default: function () { return { display: false } } }
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

		dataLabelFormatter(value, context) {

			return getDatalabelInPercentage(value, context);
		},

		onHover(event, items) {

			hoverHandler(items, this.chartId, this.redirectUrls);
		}
	}
}
</script>