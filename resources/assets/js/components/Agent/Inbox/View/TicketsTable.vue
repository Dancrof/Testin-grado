<template>

	<div class="col-sm-12" id="hd-report-template">

		<alert componentName="report-entry-page" />

		<custom-loader v-if="isLoading" :duration="4000"></custom-loader>

		<div class="card card-light  report-box-primary" v-if="reportConfigObj">

			<div class="card-header">

				<h3 class="card-title">{{reportConfigObj.name}}
					<a v-if="reportConfigObj.helplink" :href="reportConfigObj.helplink" target="__blank">
						<tool-tip slot="headerTooltip" :message="lang('click_to_see_how_to_read_this_report')" size="medium"></tool-tip></a>
				</h3>

				<div class="card-tools">

					<div class="btn-group">

						<button type="button" class="btn btn-tool" v-tooltip="lang('report_config_filter')" @click="toggleFilterView()">

							<i class="glyphicon glyphicon-filter"></i>
						</button>

						<button v-if="showExportButton && dataCount" id="export-report"  class="btn btn-tool" @click="exportReport"
						        v-tooltip="lang('export')">

							<i class="fas fa-paper-plane" aria-hidden="true"></i>
						</button>
					</div>
				</div>
			</div>

			<div class="card-body">

				<ticket-filter  v-if="isShowFilter" v-on:filter="setFilter" :isApplyOnlyMode="true" :prefilled-filter-object="filterParams"
				                filter-dependencies-api-endpoint="/api/agent/filter-dependencies" :showFilter="isShowFilter"
				                :closeFilterView="toggleFilterView" :filterNumber="filterId">

					<template #filter-operation-btn-group>
						<button class="btn btn-primary" v-if="!reportConfigObj.is_default" @click="forkUpdateAction('update')">
							<i class="fas fa-edit" aria-hidden="true"></i>
							&nbsp;{{lang('edit')}}
						</button>
						<button class="btn btn-primary" @click="forkUpdateAction('fork')">
							<i class="fas fa-save" aria-hidden="true"></i>
							&nbsp;{{lang('save')}}
						</button>
					</template>

				</ticket-filter>

				<div :key="randKey">

					<section v-for="(report, reportIndex) in reportConfigObj.sub_reports" :key="report.id">

						<tabular-report-layout v-if="report.data_type === 'datatable'" :data-url="report.data_url"
						                       :table-columns="report.columns" :sub-report-id="report.id" :export-url="reportConfigObj.export_url"
						                       :add-custom-column-url="report.add_custom_column_url" delete-custom-column-url="api/delete-custom-column"
						                       :short-code-url="'api/report-shortcodes/' + reportConfigObj.type" :filterParams="filterParams"
						                       :report-index="reportIndex" :report-id="reportId">
						</tabular-report-layout>
					</section>
				</div>

			</div>
		</div>
		<save-report-modal v-if="openSaveReportModal" :onClose="closeSaveReportModal"
		                   :reportDataObj="clonedReportConfigOnj" :modal-mode="modalMode" />

	</div>
</template>

<script>

import axios from 'axios';
import { getIdFromUrl } from "../../../../helpers/extraLogics";
import { errorHandler, successHandler } from "../../../../helpers/responseHandler";
import { getFilterObjectToArray, getValidFilterObject } from "../../../../../../../app/FaveoReport/views/js/helpers/utils";
import TicketFilter from "../../tickets/filters/TicketFilter.vue";
import TabularReportLayout
	from "../../../../../../../app/FaveoReport/views/js/components/Common/TabularReportLayout.vue";
import SaveReportModal from "../../../../../../../app/FaveoReport/views/js/components/SaveReportModal.vue";
import ToolTip from "../../../MiniComponent/ToolTip.vue";

export default {

	name: 'ticket-table-page',

	components: {
		'ticket-filter': TicketFilter,
		'tabular-report-layout': TabularReportLayout,
		'save-report-modal': SaveReportModal,
		"tool-tip": ToolTip
	},

	data: () => {
		return {
			reportConfigObj: null,
			clonedReportConfigOnj: null, // usded to save/update report
			isLoading: true,
			openSaveReportModal: false,
			modalMode: '',
			filterParams: {},
			isShowFilter : false,
			dataCount : 0,
			randKey: Math.floor(Math.random() * 11111),
			reportId:'',
			requiredPayload:[],
			scheduleData:'',
			filterId: ''
		}
	},

	beforeMount() {

		this.dashboardInit();
	},

	created() {
		window.emitter.on('onReportsColumnUpdate', this.onColumnUpdate);
		window.emitter.on('refreshReportEntryPage', this.dashboardInit);
		window.emitter.on('dataCount',this.getCount)
	},

	computed: {
		/**
		 * function to show export button only in tabular report
		 * remove this logic once export in chart will be implemented
		 */
		showExportButton: function() {
			if(this.reportConfigObj && Array.isArray(this.reportConfigObj.sub_reports)) {
				for(let i = 0; i < this.reportConfigObj.sub_reports.length; i++) {
					if(this.reportConfigObj.sub_reports[i].data_type === 'datatable') {
						return true;
					}
				}
			}
			return false;
		},
	},

	methods: {

		getCount(value) {

			this.dataCount = value;
		},

		toggleFilterView() {

			this.isShowFilter = !this.isShowFilter;
		},

		dashboardInit() {
			this.getReportConfiguration(getIdFromUrl(window.location.pathname));
		},

		/** Get report configuration object from server */
		getReportConfiguration(reportId) {
			this.isLoading = true;
			let params = getValidFilterObject(this.filterParams);
			params.include_filters = 1;

			this.reportId = reportId

			axios.get('api/agent/report-config/' + reportId, { params: params })
				.then(res => {
					this.reportConfigObj = res.data.data;
					this.scheduleData = res.data.data;
					this.clonedReportConfigOnj = JSON.parse(JSON.stringify(this.reportConfigObj));
					this.filterId = res.data.data.filter_id;
					this.updateFilterObj();
				}).catch(err => {
				errorHandler(err, 'report-entry-page');
			}).finally(res => {
				this.isLoading = false;
			});
		},

		/** Update local copy of filter object with the filter-object recieved form api response */
		updateFilterObj() {
			let filterObj = {};
			if(Array.isArray(this.reportConfigObj.filters)) {
				this.reportConfigObj.filters.forEach(element => {
					filterObj[element.key] = element.value
				});
			}
			this.filterParams = filterObj;
		},

		/** Export report */
		exportReport() {

			const exportPayload = {
				...this.filterParams, // Copy existing filter parameters
				['total']: this.dataCount // Add 'total' key with this.dataCount as the value
			};
			this.isLoading = true;
			axios.post(this.reportConfigObj.export_url, exportPayload)
				.then(res => {
					successHandler(res, 'tabular-report-layout');
				})
				.catch(err => {
					errorHandler(err, 'tabular-report-layout');
				}).finally(() => {
				this.isLoading = false;
			})
		},

		/** Emit event for forking the report */
		forkUpdateAction(actionType) {
			window.emitter.emit('performApplyAction');
			this.modalMode = actionType;
			this.openSaveReportModal = true;
		},

		/** close save report modal */
		closeSaveReportModal() {
			this.openSaveReportModal = false;
		},

		/** set filter values to report-config-object */
		setFilter(payload) {
			this.filterParams = JSON.parse(JSON.stringify(payload));
			this.clonedReportConfigOnj.filters = getFilterObjectToArray(this.filterParams);
		},

		/** Update the local copy of the column list in case of tabular report */
		onColumnUpdate() {

			window.emitter.emit('refreshData');
		}
	}
}
</script>