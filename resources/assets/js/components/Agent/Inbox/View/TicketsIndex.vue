<template>

	<div id="tickets-index">

		<alert componentName="inbox"></alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{trans('tickets')}}</h3>

				<div class="card-tools">

					<template v-if="!loading">

						<button v-if="showExportButton && dataCount && viewMode === 'datatable' && permissions?.ticket_export" id="export-report"  class="btn btn-light btn-sm" @click="exportReport"
						        v-tooltip="lang('export')">

							<i class="fas fa-paper-plane" aria-hidden="true"></i>
						</button>

						<div class="btn-group">

							<button type="button" class="btn btn-light btn-sm" :class="{ 'active_btn' : viewMode === 'list'}"
							        @click="updateViewMode('list')" id="mr-0" v-tooltip="trans('list_view')">
								<i class="fa fa-columns"></i>
							</button>

							<button type="button" class="btn btn-light btn-sm" :class="{ 'active_btn' : viewMode === 'datatable'}"
							        @click="updateViewMode('datatable')" v-tooltip="trans('table_view')">
								<i class="fas fa-table"></i>
							</button>
						</div>

						<button type="button" class="btn btn-light btn-sm" v-tooltip="trans('filter_tickets')" @click="toggleFilterView()">

							<i class="glyphicon glyphicon-filter"></i>
						</button>
					</template>

			        <button type="button" class="btn btn-light btn-sm" @click="refreshIndex()"
			          	v-tooltip="trans('refresh')">

			        	<i class="fas fa-sync-alt" :class="hasDataPopulated ? 'fa-spin': ''"></i>
			        </button>
				</div>
			</div>

			<div class="card-body">

				<div v-if="loading && hasDataPopulated" style="padding: 1rem;">

					<BulletListLoader viewBox="0 0 300 200"></BulletListLoader>
				</div>

				<div v-if="!loading && viewMode === 'list'" class="row">

					<div class="col-md-12 pl-13">

						<div class="search-div form-group form-inline float-end VueTables__search">

							<div class="VueTables__search-field">

                                <div class="input-group ticket-searchbar mb-3">

	                                <div class="input-group-prepend">

		                                <button type="button" class="btn btn-light dropdown-toggle filter-ticket rounded-end-0" data-bs-toggle="dropdown">
                                            {{lang('search_by')}}
                                        </button>

		                                <div class="dropdown-menu filter-column">

			                                <div v-for="(value, key) in searchShortCode">

				                                <a class="dropdown-item search-filter" @click="(event) => toggleSearchFilter(event, key)">

					                                <i v-if="searchFilter.includes(key)" class="fas fa-check"></i>&nbsp;

					                                <span class="search-text" :class="!searchFilter.includes(key) ? 'ms-3' : ''" >{{value}}</span>
                                                </a>
                                            </div>
                                        </div>
                                    </div>

	                                <input type="text" class="form-control" :placeholder="lang('type_and_enter_to_search')" v-model="search"
                                        @keyup.enter="doSearch($event ,search)" @keydown="handleKeyDown($event)" :class="{ 'highlighted': isHighlighted }">
                                </div>
                            </div>
						</div>

						<div class="form-group float-start VueTables__limit ms-0">

							<div class="VueTables__limit-field ">

								<button type="button" class="btn btn-light btn-md cursor_def" v-tooltip="trans('select_all_tickets')">

								 	<select-all :tickets="ticketsArray" :selected="selectedTickets">

									</select-all>
								</button>

								<template v-if="sourceType === 'closed' || sourceType === 'archived'">

									<span id="ticket-actions-mounted">{{ticketActionsMounted()}}</span>
								</template>

								<ticket-actions v-if="selectedTickets.length" :selectedTickets="selectedTickets" :loadTickets="refreshTickets" :page="sourceType"
									:tickets="ticketsArray" :permissions="permissions">

								</ticket-actions>

								<per-page v-if="perpage" :perpage="perpage" :tableHeader="selectedColor"
									v-on:ticketCount="handlePageCount">

								</per-page>

								<ticket-sorting v-on:sort="sorting" v-on:filter="filtering" :sortPreferences="sort_preferences" :tableHeader="selectedColor"></ticket-sorting>
							</div>
						</div>
					</div>
				</div>

				<div v-if="filterLoad">

					<BulletListLoader viewBox="0 0 300 200"></BulletListLoader>
				</div>

				<div v-if="isShowFilter">

					<ticket-filter v-on:filter="setFilter" :showFilter="isShowFilter" :closeFilterView="toggleFilterView">

					</ticket-filter>
				</div>

				<template v-if="!loading && viewMode === 'list'">

					<div class="mailbox-messages mailinbox">

						<div class="row ticket-box">

							<div class="col-md-12 col-sm-12 col-12">

								<table v-if="ticketsArray.length > 0" id="tickets-expanded">

									<tbody>

									<ticket-details v-for="(ticket,index) in ticketsArray" :ticket="ticket" :key="ticket.id"
									                :color="selectedColor" :appendSelect="appendSelect" :onSelect="onTicketSelect"
									                :timelineId="timelineId">

									</ticket-details>
									</tbody>
								</table>

								<div v-if="!hasDataPopulated && ticketsArray.length === 0">

									<p class="text-center no-ticket-found">{{trans('no-ticket-found')}}</p>
								</div>
							</div>
						</div>
					</div>

					<div class="mailbox-controls">

						<div class="row">

							<div class="col-sm-6 pad-top-18">

								<template v-if="ticketResponse.total === 1">{{trans('one_record')}}</template>

								<template v-if="ticketResponse.total > 1 && ticketResponse.total <= 10">
									{{ ticketResponse.total }} {{trans('records')}}
								</template>


								<div v-if="ticketResponse.total > 10" class="me-2">
									{{trans('showing')}} {{ ticketResponse.from }} to {{ ticketResponse.to }} of {{ ticketResponse.total }} {{trans('records')}}
								</div>
							</div>

							<div class="col-sm-6">

								<div v-if="ticketResponse.total > 10" class="float-end mr-2">

									<simple-pagination :prev_page="prev_page" :next_page="next_page" :onPagination="pageChanged">

									</simple-pagination>
								</div>
							</div>
						</div>
					</div>
				</template>

				<template v-else-if="!loading && viewMode === 'datatable'">

					<div class="form-group mt_11">

						<div class="VueTables__limit-field ">

							<template v-if="pageType === 'closed' || pageType === 'archived'">

								<span id="ticket-actions-mounted">{{ticketActionsMounted()}}</span>
							</template>

							<ticket-actions v-if="selectedTickets.length" :selectedTickets="selectedTickets" :loadTickets="refreshTickets" :page="pageType"
							                :tickets="ticketsArray" :currentTicketCategory="currentTicketCategory" :permissions="permissions">

							</ticket-actions>
						</div>
					</div>

					<section v-for="(report, reportIndex) in reportConfigObj.sub_reports" :key="report.id">

						<TabularReportLayout v-if="report.data_type === 'datatable'" :data-url="dataUrl" :perpage="perpage"
	                        :table-columns="report.columns" :sub-report-id="report.id" :export-url="reportConfigObj.export_url"
	                        :short-code-url="''" :delete-custom-column-url="''" :add-custom-column-url="''" :filterParams="filterParams"
	                        :report-index="reportIndex" :report-id="tableId" reportType="tickets" :showAddColumn="false" :staticColumns="['id']" :tickets="ticketsData" :per-page-values="[10,25,50,100]">
						</TabularReportLayout>
					</section>
				</template>
			</div>
		</div>

		<div class="time-ab-div">

			<div id="ticket-timeline" class="row timelinebtns">

				<ticket-timeline v-if="timelineId" :ticketId="timelineId" :updateTable="reloadData" :key="counter" ref="ticketTimeline" fromComp="index" :currentTicketCategory="currentTicketCategory">

					<template #headerMenu>

						<button class="btn btn-light btn-xs fs-9" @click="refreshDetails" v-tooltip="trans('refresh')" href="javascript:;">

							<i class="fas fa-sync-alt"></i>
						</button>

						<button type="button" class="btn btn-light btn-xs fs-9" @click="backToInbox" v-tooltip="trans('back_to_inbox')">

							<i class="fas fa-arrow-up"></i>
						</button>

						<button type="button" class="btn btn-light btn-xs fs-9" @click="closeTimeline" v-tooltip="trans('close')">

							<i class="fas fa-times"></i>
						</button>
					</template>
				</ticket-timeline>
			</div>
        </div>
	</div>
</template>

<script>

import { BulletListLoader } from 'vue-content-loader'

import {boolean, getIdFromUrl, parseUrlParams} from "../../../../helpers/extraLogics";

import {errorHandler, successHandler} from "../../../../helpers/responseHandler";

import axios from 'axios';

import TicketActions from "./Mini/Table/TicketActions.vue";
import TicketDetails from "./Mini/Table/TicketDetails.vue";
import TicketPerPage from "./Mini/Table/TicketPerPage.vue";
import SelectAllTickets from "./Mini/Table/SelectAllTickets.vue";
import TicketSortingMenu from "./Mini/Table/TicketSortingMenu.vue";
import TicketTimeline from "./TicketTimeline.vue";
import TicketFilter from "../../tickets/filters/TicketFilter.vue";
import SimplePagination from "../../../Common/SimplePagination.vue";
import TabularReportLayout
	from "../../../../../../../app/FaveoReport/views/js/components/Common/TabularReportLayout.vue";
import {getValidFilterObject} from "../../../../../../../app/FaveoReport/views/js/helpers/utils";

export default {

	props: {

		selectedColor: { type: String, default: '' },

		ticketPage: { type: String, default: '' },

		permissions: { type: [String, Object], default: '' }
	},

	data() {

		return {

			buttonStyle: { 'background-color': this.selectedColor + ' !important', 'color': '#fff' },

			loading: true,

			ticketsArray: [],

			ticketResponse: '',

			perpage: '',

			pagination: 1 ,

			paramsObj: {},

			hasDataPopulated: true,

			search: '',

			selectedTickets: [],

			timelineId: '',

			url_params: [],

			/**
			 * `isApplyClicked` is true when filter is applied and saved by the user
			 * This is a fix for issue #4896
			 *
			 * Get filter fileds params from `URL` only when
			 * 1. Redirection
			 * 2. Url parmas changed manualy
			 *
			 */
			isApplyClicked: false,

			activePage : this.ticketPage,

			isShowFilter : false,

			counter : 0,

			next_page : '',

			prev_page :  '',

			searchShortCode: '',

			searchFilter: ['id'],

			filterArray: [],

			sourceType: '',

			filterLoad: false,

      sort_preferences: {},

			viewMode: 'list',

			// For table
			reportConfigObj: null,
			dataCount : 0,
			filterParams: {},
			tableId: '',
			dataUrl: '',
			currentTicketCategory: '',
			pageType: ''
		}
	},

	beforeMount() {

		let url_params = new URLSearchParams(window.location.search);

		this.timelineId = url_params.get("timelineId") ? url_params.get("timelineId") : '';

		this.currentTicketCategory = url_params.get("category") ? url_params.get("category") : '';

		// Get the tickets view mode
		this.getTicketsViewMode();
	},

	mounted() {

		if(this.timelineId) {

			$('html, body').animate({ scrollTop: $('#ticket-timeline').offset().top-70 }, 'slow');
		}
	},

	created() {

		window.emitter.on('refreshInbox', this.getRefreshList);

		window.emitter.on('closeTimelineView', this.closeTimeline);

		window.emitter.on('dataCount',this.getCount);

		window.emitter.on('refreshTicketsIndex', this.refreshTickets);

		window.emitter.on('responseData', this.handleTicketData);

		window.emitter.on('updatedLimit', (value) => {
			this.perpage = value;
		});

	},

    computed: {
        //  the input text contains the content generated from 'searchFilter'
        isHighlighted() {
            const generatedContent = this.searchFilter.map(key => ('is:' + key + ' ')).join('');
            return this.search === generatedContent;
        },

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

	    ticketActionsMounted(){

		    window.emitter.emit('ticketActionsMounted', {component: { selectedTickets : this.selectedTickets, permissions: this.permissions }, category : this.sourceType ? this.sourceType : this.pageType });
	    },

	    handleTicketData(data) {

			this.pageType = data.data.category;
	    },

	    ticketsData(data){

		    this.selectedTickets = data;
	    },
	    onColumnUpdate() {

		    window.emitter.emit('refreshData');
	    },

	    exportReport() {
		    const exportPayload = {
			    ...this.filterParams,
				['total']: this.dataCount,
			    ['filter_id'] : this.$route?.params?.id
			};

		    this.hasDataPopulated = true;

			axios.post(this.reportConfigObj.export_url, exportPayload).then(res => {

				this.hasDataPopulated = false;

				successHandler(res, 'inbox');

			}).catch(err => {

				this.hasDataPopulated = false;

				errorHandler(err, 'inbox');
			})
	    },

	    getCount(value) {

		    this.dataCount = value;
	    },

	    getTicketsViewMode() {

			axios.get('/ticket-datatable-settings').then(res => {

				this.viewMode = res.data.data.view;

				this.perpage = parseInt(res.data.data.per_page);

				this.callTickets();

			}).catch(error => {

				errorHandler(error, 'inbox');
			})
	    },

	    updateViewMode(mode) {

			this.viewMode = mode;

		    this.loading = true;

		    this.hasDataPopulated = true;

			this.selectedTickets = [];

			axios.post('/update-settings/ticket-datatable', { ticket_view: mode }).then(res => {

				successHandler(res, 'inbox');

				this.callTickets();

			}).catch(error => {

				errorHandler(error, 'inbox');
			})
	    },

	    callTickets() {

		    const urlParams = parseUrlParams();

		    if(this.viewMode === 'list') {

				if(getIdFromUrl(window.location.pathname)) {

					this.paramsObj['filter_id'] = getIdFromUrl(window.location.pathname);
				}

			    this.getTicketList({...this.paramsObj, ...urlParams})

			    this.getSearchShorCodes();

			    this.search = this.formatSearchFilter();

			    this.filterArray.push(this.search);

			    window.emitter.emit('updateAgentSidebar');

		    } else {

				if(getIdFromUrl(window.location.pathname)) {

					this.paramsObj['filter_id'] = getIdFromUrl(window.location.pathname);
				}

			    this.getTableConfiguration({...this.paramsObj,...urlParams});
		    }
	    },

	    getTableConfiguration(params) {

		    let tableCategory = 'ticket-export';

		    const urlParams = parseUrlParams();

		    if (urlParams && urlParams.hasOwnProperty('category') && urlParams.category === 'archived') {

			    tableCategory = 'archived-ticket-export';
		    }

		    axios.get('/api/agent/report-config/' + tableCategory).then(res => {

			    let  paramsVal = '';

			    if(!this.isApplyClicked) {

				    var search = location.search.substring(1);

				    if(search.length!==0){

					    this.url_params=JSON.parse('{"' + decodeURIComponent(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"').replace(/%2F/g, '\/') + '"}')
				    }

				    // Using Object spread syntax for merging filter values
				    paramsVal = { ...this.handleUrlParamsInTicketFilter(paramsVal), ...params};

				    params = paramsVal ? paramsVal : params;
			    }

			    let category = this.activePage;

			    category = category === 'trash' ? 'deleted' : category;

			    if(params && params.hasOwnProperty('category') && params.category && params.filter_id) {

				    delete params.filter_id;
			    }

			    let queryString = Object.entries({ category, ...params }).map(([key, value]) => {

					if(key !== 'limit') {

						if (Array.isArray(value)) {

							return value.map(item => `${encodeURIComponent(key)}[]=${encodeURIComponent(item)}`).join('&');

						} else {

							return `${encodeURIComponent(key)}=${encodeURIComponent(value)}`;
						}
					}
			    }).join('&');

			    const timestamp = new Date().getTime();
			    this.dataUrl = `/api/agent/ticket-list?${queryString}&timestamp=${timestamp}`;

			    this.reportConfigObj = res.data.data;

			    this.filterId = res.data.data.filter_id;

				this.tableId = res.data.data.id;

				this.updateFilterObj(params);

			    this.loading = false;

				this.hasDataPopulated = false;

		    }).catch(err => {

			    this.loading = false;

			    errorHandler(err, 'inbox');
		    })
	    },

	    updateFilterObj(originalObject) {

			if(Array.isArray(this.reportConfigObj.filters)) {

				let filterObj = {};

			    this.reportConfigObj.filters.forEach(element => {

				    filterObj[element.key] = element.value
			    });

				this.filterParams = filterObj;

			} else if(this.viewMode === 'datatable') {

				let transformedObject = {};

				for (const key in originalObject) {

					if (key.endsWith("[]")) {

						const newKey = key.replace("[]", ""); // Remove "[]" from the key

						const value = originalObject[key];

						transformedObject[newKey] = Array.isArray(value)
							? value
							: [value].map((v) => (isNaN(v) ? v : Number(v)));
					} else if (!key.includes("[]")) {

						transformedObject[key] = originalObject[key];
					}
				}

				this.filterParams = transformedObject;
			}
	    },

		refreshDetails(){

			this.$refs.ticketTimeline.reloadTimeline();
		},

		backToInbox() {

			var elmnt = document.getElementById('tickets-index');

			elmnt.scrollIntoView({ behavior : "smooth"});
		},

		toggleFilterView() {

			this.isShowFilter = !this.isShowFilter;
		},

		reloadData(from) {

			if(from && from == 'duedate') {

				this.ticketsArray = [];

				this.loading = true;
			}

			this.hasDataPopulated = true;

			this.getTicketList(this.paramsObj);
		},

		closeTimeline() {

			var elmnt = document.getElementById('tickets-index');

			elmnt.scrollIntoView({ behavior: "smooth" });

			this.timelineId = '';

			const url = new URL(window.location.href);
			url.searchParams.delete('timelineId');
			window.history.replaceState(null, null, url.toString());
		},

		onTicketSelect(id) {

			$('html, body').animate({ scrollTop: $('#ticket-timeline').offset().top-70 }, 'slow');

			let url_params = new URLSearchParams(window.location.search);

			if(url_params.get("timelineId")){

				const paramName = 'timelineId'

				const paramValue = id

				const searchParams = new URLSearchParams(window.location.search)

				searchParams.set(paramName, paramValue)

				const newUrl = `${window.location.origin}${window.location.pathname}?${searchParams.toString()}`

				window.history.replaceState(null, null, newUrl)

			} else {

				const paramName = 'timelineId'

				const paramValue = id;

                const currentURL = window.location.href;

                const separator = currentURL.includes('?') ? '&' : '?';

                const newUrl = `${currentURL}${separator}${paramName}=${paramValue}`;

                window.history.replaceState(null, null, newUrl);
			}

			this.timelineId = id;

			this.counter += 1;
		},

		refreshTickets() {

			this.getRefreshList();

			window.emitter.emit("unCheckTicket");

			window.emitter.emit('refreshTicket');
		},

		doSearch(event, value) {

			const urlParams = parseUrlParams();

            let removeFilter = this.formatSearchFilter();

            let searchValue = value.replace(removeFilter, '');

            let Decoded = decodeURIComponent(searchValue).replace(/[^\x00-\x7F]/g, '');

			this.commonActions();

			this.paramsObj['page'] = 1;

			this.paramsObj['search-query'] = Decoded.trim();

            this.paramsObj['short_code'] = this.searchFilter;

	        this.getTicketList({ ...this.paramsObj, ...urlParams });

			this.pagination = 1;
		},

	    getTicketList(params, direction='') {

			let  paramsVal = '';

			if(!this.isApplyClicked) {

				var search = location.search.substring(1);

				if(search.length!==0){

					this.url_params=JSON.parse('{"' + decodeURIComponent(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"').replace(/%2F/g, '\/') + '"}')
				}

				// Using Object spread syntax for merging filter values
				paramsVal = { ...this.handleUrlParamsInTicketFilter(paramsVal), ...params};

				params = paramsVal ? paramsVal : params;
			}

		    if(params && params.hasOwnProperty('category') && params.category && params.filter_id) {

			    delete params.filter_id;
		    }

			axios.get('/api/agent/ticket-list', { params }).then(res => {

				this.ticketResponse = res.data.data;

				this.perpage = parseInt(this.ticketResponse.per_page);

        this.sort_preferences = res.data.data.sort_preferences

				this.ticketsArray = res.data.data.tickets;

		        this.next_page = res.data.data.next_page_url;

		        this.prev_page = res.data.data.prev_page_url;

		        this.sourceType = this.ticketResponse.category === 'deleted' ? 'trash' : this.ticketResponse.category

		        this.loading = false;

		        this.hasDataPopulated = false;

				if(!this.ticketsArray.length && this.pagination !== 1) {

					this.pagination = 1;

					this.paramsObj['page'] = 1;

					this.getTicketList(this.paramsObj);
				}
			}).catch(error => {

				this.loading = false;

				this.hasDataPopulated = false;

                errorHandler(error, 'inbox');
			})
		},

	    getPageNumberFromUrl(url) {
	        const regex = /[?&]page=(\d+)/;
	        const match = url.match(regex);
	        return match ? parseInt(match[1]) : null;
	    },

		refreshIndex() {

			axios.get('/ticket-datatable-settings').then(res => {

				this.viewMode = res.data.data.view;

				this.perpage = parseInt(res.data.data.per_page);

				window.emitter.emit('uncheckCheckbox');

				this.selectedTickets = [];

				const urlParams = parseUrlParams();

				if(this.viewMode === 'list') {

					this.hasDataPopulated = true;

					this.paramsObj['page'] = 1;

					if(getIdFromUrl(window.location.pathname)) {

						this.paramsObj['filter_id'] = getIdFromUrl(window.location.pathname);
					}

					this.getTicketList({...this.paramsObj, ...urlParams});

					window.emitter.emit('updateAgentSidebar');

				} else {

					this.hasDataPopulated = true;

					if(getIdFromUrl(window.location.pathname)) {

						this.paramsObj['filter_id'] = getIdFromUrl(window.location.pathname);
					}

					this.getTableConfiguration({...this.paramsObj, ...urlParams});
				}

				if(this.isShowFilter) {

					this.filterLoad = true;

					this.isShowFilter = false;

					setTimeout(()=> {
						this.isShowFilter = true;
						this.filterLoad = false;
					}, 1000);
				}

				this.pagination = 1;

			}).catch(error => {

				errorHandler(error, 'inbox');
			})
		},

		commonActions() {

			window.emitter.emit("unCheckTicket");

			this.selectedTickets = [];

			this.hasDataPopulated = true;

			var elmnt = document.getElementById('tickets-index');

			elmnt.scrollIntoView({behavior: "smooth"});
		},

		getRefreshList() {

			const urlParams = parseUrlParams();

			this.paramsObj['page'] =  this.pagination;

			this.commonActions();

			this.getTicketList({ ...this.paramsObj, ...urlParams });
		},

		pageChanged(direction) {

			const urlParams = parseUrlParams();

			this.commonActions();

            let page = ''

			if (direction === 'next' && this.next_page) {
                page = this.getPageNumberFromUrl(this.next_page);
            }

            if (direction === 'previous' && this.prev_page) {
                page = this.getPageNumberFromUrl(this.prev_page);
            }

            this.paramsObj['page'] = page;

			this.getTicketList({ ...this.paramsObj, ...urlParams });
		},

		handlePageCount(count) {

			const urlParams = parseUrlParams();

			this.commonActions();

			this.paramsObj['page'] = 1;

			this.paramsObj['limit'] = count;

			this.getTicketList({ ...this.paramsObj, ...urlParams });

			this.pagination = 1;
		},

		sorting(payload) {

			const urlParams = parseUrlParams();

			this.commonActions();

			this.paramsObj['answered'] = '';

			this.paramsObj['sort-field'] = payload.value;

			this.paramsObj['sort-order'] = payload.order;

			this.getTicketList({ ...this.paramsObj, ...urlParams });
		},

		filtering(payload) {

			const urlParams = parseUrlParams();

			this.commonActions();

			this.paramsObj['answered'] = payload.value;

			this.getTicketList({ ...this.paramsObj, ...urlParams });
		},

		appendSelect(ticketId, checked) {

			if (checked) {

				this.selectedTickets.push(ticketId);

			} else {

				this.selectedTickets.splice(this.selectedTickets.indexOf(ticketId), 1);
			}
		},

		setFilter(payload, scroll, isApplyClicked) {

			axios.get('/ticket-datatable-settings').then(res => {

				this.viewMode = res.data.data.view;

				this.commonActions();

				this.isApplyClicked = isApplyClicked

				const timeRangeFilterOptions = ['due-on', 'created-at', 'updated-at'];

				for (const key in payload) {
					if (payload.hasOwnProperty(key)) {
						if (timeRangeFilterOptions.includes(key)) {
							payload[key] = payload[key];
						}
					}
				}

				this.pagination = 1;

				if (payload.category === '') {
					payload.category = this.url_params['show[]'] ? this.url_params['show[]'] : '';
				}

				this.paramsObj = JSON.parse(JSON.stringify(payload));

				this.setParamsAndApplyFilter(this.paramsObj, scroll);

				this.filterParams = JSON.parse(JSON.stringify(payload));
			}).catch(error => {

				errorHandler(error, 'inbox');
			})
		},

		handleUrlParamsInTicketFilter(filterParams) {

      // commented out for now to avoid conflict with the new implementation on static filter update
			/*// get all parameters from the URL. If search by paramters is true, then
			if (boolean(this.url_params['filter-by-url'])) {
				return this.url_params;
			}*/

      // get all parameters from the URL. If search by parameters is true, then
      if (boolean(this.url_params['filter-by-url'])) {
        // Iterate over the keys in filterParams
        for (const key in filterParams) {
          if (filterParams.hasOwnProperty(key)) {
            // If the key is not present in url_params, add it
            if (!this.url_params.hasOwnProperty(key)) {
              this.url_params[key] = filterParams[key];
            } else {
              // If the key is present but the value is different, update the value
              if (this.url_params[key] !== filterParams[key]) {
                this.url_params[key] = filterParams[key];
              }
            }
          }
        }
        return this.url_params;
      }

			return filterParams;
		},

		/**
		 * This function will parse the params and apply filter to ticket list
		 * TODO: Need refactoring
		 */
		setParamsAndApplyFilter(parameters, scroll = false) {
			/**
			 * `isApplyClicked` is true when filter is applied and saved by the user
			 * This is a fix for issue #4896
			 *
			 * Get filter fields params from `URL` only when
			 * 1. Redirection
			 * 2. Url parmas changed manualy
			 *
			 */
			if (!this.isApplyClicked) {
				let search = location.search.substring(1);
				if (search.length !== 0) {
					this.url_params = JSON.parse('{"' + decodeURIComponent(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g, '":"').replace(/%2F/g, '\/') + '"}')
				}
				parameters = this.handleUrlParamsInTicketFilter(parameters);
			}

			if (this.url_params['show[]'] === "trash") {
				this.url_params['show[]'] = "deleted";
				this.deleteForver = true; // TODO:- Find the purpose of this line
			}

			if (typeof parameters === 'undefined') {
				let params = JSON.parse(JSON.stringify(this.paramsObj));
				//checking if params already have a non empty parameter as category and due_on
				params['category'] = (params['category'] !== undefined) ? params['category'] : (this.url_params['show[]'] ? this.url_params['show[]'] : '');
				// params['filter_id'] = getIdFromUrl(this.currentPath());

				if(this.viewMode === 'list') {
					this.getTicketList(params);
				} else {
					this.getTableConfiguration(params);
				}
			} else {
				//only if scroll is passed as true, this will be scrolled
				if (scroll) {
					window.emitter.emit('hideInboxTimeline');
				}
				let params = parameters;
				params['category'] = (params['category'] !== undefined) ? params['category'] : (this.url_params['show[]'] ? this.url_params['show[]'] : '');
				/**
				 * Condition for adding filter id in api params
				 * @param  {number} id of the filter
				 */
				// if (this.isShowFilter) {
				// 	params['filter_id'] = getIdFromUrl(this.currentPath());
				// }
				params['limit'] = this.perpage;
				if(this.viewMode === 'list') {
					this.getTicketList(params);
				} else {
					this.getTableConfiguration(params);
				}
			}
		},

        getSearchShorCodes() {
            // Make GET request to fetch search shortcodes
            axios.get('/filter/search-shortcodes').then(res => {
		        // Update searchShortCode data property with the response data
		        this.searchShortCode = res.data;

		        this.loading = false;

            }).catch(error => {

		        this.loading = false;
            })
        },

        toggleSearchFilter(event, key) {
      
            const index = this.searchFilter.indexOf(key);

			if (index !== -1) {

				this.searchFilter.splice(index, 1); // Remove from array if already selected

            } else {

				this.searchFilter.push(key); // Add to array if not yet selected
            }

            let removeFilterRegex = new RegExp('is:[^ ]+\\s', 'g');
            let searchValue = this.search.replace(removeFilterRegex, '');
            this.search = this.formatSearchFilter() + searchValue;

            this.filterArray = this.searchFilter.map(key => ('is:' + key+' '));

            this.preventToCloseBox(event)
        },

        preventToCloseBox(event) {

            event.stopPropagation();
        },

        formatSearchFilter() {
            // Map each element in searchFilter to a string with 'is:'
            return this.searchFilter.map(key => ('is:'+ key+' ')).join('');
        },

	    handleKeyDown(event) {
            // Check if backspace key is pressed and all text is selected
            if (event.key === 'Backspace' && this.isAllTextSelected()) {
                // Clear the input field
                this.search = '';
                // Clear the search filters
                this.searchFilter = [];
                // Clear the Filter Array
                this.filterArray = [];
            }
        },

        isAllTextSelected() {

            return document.activeElement.selectionStart === 0 && document.activeElement.selectionEnd === this.search.length;
        },
	},

    watch:{

	    selectedTickets(newVal,oldVal) {

		    window.emitter.emit('selectedTickets',newVal)
	    },

		search(){

            // Iterate over filterArray and check if each term is still in search
            for (let i = 0; i < this.filterArray.length; i++) {

                const searchTerm = this.filterArray[i];
                // Check if searchTerm is not present in search
                if (!this.search.includes(searchTerm)) {

                    let removeFilter = searchTerm.replace('is:', "").trim();

                    const index = this.searchFilter.indexOf(removeFilter);

					if (index !== -1) {
                        this.searchFilter.splice(index, 1);
                    }
                    // Remove the element from filterArray
                    this.filterArray.splice(i, 1);
                    this.search = this.filterArray.filter(term => this.filterArray.includes(term)).join('');
	                // Decrement the index as splice changes the array length
                    i--;
                }
            }
        },
    },

	components: {

		BulletListLoader,

		'ticket-actions': TicketActions,

		'ticket-details': TicketDetails,

		'per-page': TicketPerPage,

		'select-all': SelectAllTickets,

		'ticket-sorting': TicketSortingMenu,

		'ticket-timeline': TicketTimeline,

		'ticket-filter': TicketFilter,

        'simple-pagination': SimplePagination,

		TabularReportLayout
	},
};
</script>

<style>
	@import '../css/inbox.css';
	.mailbox-controls .VuePagination__count { display: none !important;}
</style>

<style scoped>

	.no-ticket-found {line-height: 1.2;font-size: 15px;padding: 1rem;}

	.pad-top-18 { padding-top: 18px;padding-bottom: 18px; }

	.cursor_def { cursor: default !important; }

	.VueTables__search-field input { width: auto !important;}

	@keyframes rotate {
	    from {transform: rotate(0deg);}
	    to {transform: rotate(360deg);}
	}

    .btn-tool.rotating i {animation: rotate 2s linear infinite;}

    .filter-column{max-width: 450px !important;width: 300px !important;}

    .search-filter{cursor: pointer;padding-left: 10px !important;max-width: 450px !important;width: 300px !important;}

    .filter-ticket{margin-right : 0 !important;}

    div.VueTables__search-field .input-group {max-width: 700px !important;width: 700px !important;}

    @media (max-width: 768px) {
        div.VueTables__search-field .input-group {width: 500px;}
    }

    .highlighted {color: #949494;}

    .search-div{margin-bottom: 0 !important;}

    #mr-0 { margin-right: 0px !important; }

    .active_btn {background-color: #e9ecef !important;color: #2b2b2b !important;}

    .pl-13 { padding-left: 13px !important; }

  .filter-ticket{
    margin-right : 0 !important;
  }

  div.VueTables__search-field .input-group {
    max-width: 700px !important;
    width: 700px !important;
  }

  /* Responsive adjustment */
  @media (max-width: 768px) {
    div.VueTables__search-field .input-group {
      width: 500px; /* Adjust for smaller screens */
    }
  }

  .highlighted {

    color: #949494; /* Make the text color */
  }

  .search-div{
    margin-bottom: 0 !important;
  }

	.timelinebtns .btn-xs { font-size: .75rem !important;}

    .mt_11 { margin-top: 11px !important; }
</style>
