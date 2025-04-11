<template>
	
	<div id="client-tickets-table" :class="{align1: lang_locale == 'ar'}">


		<meta-component :dynamic_title="trans('mytickets-title')"  :dynamic_description="trans('mytickets-description')" 
			:layout="layout" >
		  
		</meta-component>
		
		<alert componentName="dataTableModal"></alert>

		<div class="card">
			
			<div class="card-header">

				<h3 class="card-title"> {{trans('tickets')}} </h3>

				<div class="card-tools">

					<a class="btn btn-tool " href="javascript:;" @click = "toggleFilterView" v-tooltip="trans('filter')">
						
						<span class="glyphicon glyphicon-filter"></span>

					</a>

				</div>

			</div>
			
			<div class="card-body">
				
				<template v-if="hasDataPopulated">
					
					<div class="mb-3">
					
						<client-ticket-filter id="filter-box" v-if="isShowFilter" :metaData="filterOptions" :appliedFilters="appliedFilters"
							@selectedFilters="selectedFilters">
				  
						</client-ticket-filter>
					</div>

					<div class="nav-tabs-custom">
						
						<ul class="nav nav-tabs" :class="{tabs_align: lang_locale == 'ar'}">
					
							<li v-for="tab in filterList" class="nav-item" v-if="isShowTabs">

                <a :id="tab.name+'_tickets'"  class="nav-link tickets_cursor_tab" :class="{ active: currentTabId == tab.id, float1: lang_locale === 'ar' }"
                   href="javascript:;" data-bs-toggle="tab" @click="tickets(tab)">
                  <i :class="tab.icon_class" :style="{ color: tab.icon_color }"></i>
                  <b class="ms-1">{{ lang(tab.name) }}</b>
                  <span class="badge badge-pill tab_count ms-1">{{tab.ticket_count}}</span>
                </a>
							</li>

              <li class="nav-item" v-if="isShowFilterTab">

                <a class="nav-link tickets_cursor_tab active" href="javascript:;" data-bs-toggle="tab">

                  <b>{{lang("search_result")}}</b>&nbsp;&nbsp;

                  <span> <i class="fas fa-times" @click="resetFilter()"></i></span>

                </a>

              </li>

							<li :class="[(lang_locale === 'ar') ? 'me-auto' : 'ms-auto']">
										
								<ticket-status v-if="tic_status == 1 && ticketId.length" :layout="layout" :updateStatus="updateStatus" :ticketIds="ticketId">
											
								</ticket-status>

							</li>

						</ul>

          </div>

						<div class="tab-content">

							<div class="active tab-pane" id="activity">
									
								<div id="my_tic">

									<my-tickets-table :tickets="ticketsData" :apiUrl="apiUrl" :loggedInId="auth.user_data.id"
                                    alert-component-name="dataTableModal" :layout="layout" :key="currentTabId" :inputStyle="inputStyle">
								
									</my-tickets-table>

								</div>

							</div>

						</div>

				</template>

				<div v-if="!hasDataPopulated || loading" class="row">

					<client-panel-loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
				</div>
			</div>
		</div>

		<transition  name="modal">
				
			<change-status-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :ticketIds="ticketId" 
				:status="change_status" :layout="layout">
							
			</change-status-modal>

		</transition>

	</div>

</template>

<script>
	
	import axios from 'axios'

	import  { getApiParamsFromArray } from '../../../../helpers/extraLogics';
    import ClientTicketsTable from "./MiniComponents/ClientTicketsTable.vue";
    import ChangeStatus from "./MiniComponents/ChangeStatus.vue";
    import DataTableFilter from "../../../Extra/DataTableFilter.vue";
    import ChangeStatusModal from "./MiniComponents/ChangeStatusModal.vue";

	export default {

		name : 'client-tickets-table',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},

			from : { type : String, default : '' },

			orgId : { type : [String, Number], default : '' },

			ticketTabData : { type : [Number, String], default : ''},
		},

		data () {

			return {

				hasDataPopulated : false,

				loading : false,

				lang_locale : this.layout.language,

				tic_status : this.layout.user_set_ticket_status.status,

				inputStyle: {
					borderColor : this.layout.portal.client_input_field_color,
				},

				change_status : '',

				showModal : false,

				isShowFilter : false,

				appliedFilters : {},

				filterOptions: [
				{
					section : [
						{ 
							name: 'ticket-ids',
					 		url: '/api/dependency/client-tickets',
					 		label: 'ticket_id-subject',
				  		},

				  		{ 
							name: 'owner-ids',
					 		url: '/api/dependency/client-requesters',
					 		label: 'requester',
				  		},
				  		{ 
							name: 'collaborator-ids',
					 		url: '/api/dependency/client-requesters',
					 		label: 'collaborator',
				  		}
					]
				},
				{
					section : [
						{ 
							name: 'status-ids',
					 		url: this.from ? 'api/dependency/ticket-status-tabs?limit=all&supplements[]='+this.orgId : '/api/dependency/ticket-status-tabs',
					 		label: 'status',
				  		},
						{ 
							name: 'created-at',
							type: 'date',
							label: ['created_at', 'created_within_last'],
							timeOptions:{  start: '00:00', step: '00:30',  end: '23:30' },
							pickers : false,
							range : true
						},
					]
				}],

				filterList : [],

				currentTabId : '',

				ticketId:[],

				apiUrl : '',

        isShowTabs: true,

        isShowFilterTab: false,
			}
		},

		beforeMount () {

			this.getFilterTabs();

			this.filterData();
		},

		created() {

			window.emitter.on('updateFilter',this.updateFilter);

			window.emitter.on('updateTicketCount',this.getFilterTabs);
		},

		methods : {

			updateFilter(data) {

				this.filterOptions.map(function (obj) { 
				  
				  obj.section.map(function(row){

				  		if(data.name == row.name) {
				  			
				  			 row.value = data.value;
				  		}
				  })
				});
			},
			
			filterData(){

				let class_name =  this.from ? 'col-sm-6' : 'col-sm-4';

				this.filterOptions.map(function (obj) { 
			  
				  obj.section.map(function(row){

						row.elements = [];
				  		row.isMultiple = true;
				  		row.isPrepopulate = false;
				  		row.value = '';
				  		row.className = class_name;
				  	})
				});
			},

			selectedFilters(value){ 

				if(value === 'closeEvent') {

					this.resetFilter();

          return this.isShowFilter = false;

				}
				if(value === 'resetEvent') {

					return this.resetFilter();

				}
				
				return this.applyFilter(value)

			},

			resetFilter(){

        this.isShowFilterTab = false;

        this.isShowTabs = true;

				this.apiUrl = '/api/client/ticket-list?filter_id='+this.currentTabId;
				
				let class_name =  this.from ? 'col-sm-6' : 'col-sm-4';

		  		this.filterOptions = this.filterOptions.map(function (obj) { 
				  
				  	obj.section.map(function(row){

						row.elements = [];
				  		row.isMultiple = true;
				  		row.isPrepopulate = false;
				  		row.value = '';
				  		row.className = class_name;
				  	})
				  return obj;

				});
			},

			applyFilter(value){
				
				this.appliedFilters = value;
        
        		let params = getApiParamsFromArray(this.filterOptions,value);

        		if(params[params.length-1] === '&') {
         
          			params = params.slice(0, -1);

              this.isShowTabs = false;

              this.isShowFilterTab = true;

        		}else{

              this.isShowTabs = true;

              this.isShowFilterTab = false;
            }

        		let baseUrlForFilter = params ? '/api/client/ticket-list?' : '/api/client/ticket-list?filter_id='+this.currentTabId;

        		this.apiUrl = baseUrlForFilter + params;
        
        		this.isShowFilter = false;

      		},

			onClose(){
				
				this.showModal = false;
				
				this.$store.dispatch('unsetValidationError');
			},

			updateStatus(status){

				this.showModal = true
				
				this.change_status = status;
			},

			ticketsData(data){
		
				this.ticketId = data
			},

			tickets(category){
				
				this.currentTabId = category.id;
				
				this.ticketId = [];
				
				this.appliedFilters = {};

				this.resetFilter();

				// this.getTabCount()
			},

			getTabCount () {

				axios.get('/api/client/ticket-filter').then(res=>{

					this.filterList = res.data.data.filters.data;

				}).catch(err=>{

					this.filterList = [];
				})
			},

			toggleFilterView() {

				this.isShowFilter = !this.isShowFilter;
			},

			getFilterTabs () {

				localStorage.setItem('redirectPath','');

				this.loading = true;

        this.isShowTabs = true;

				axios.get('/api/client/ticket-filter').then(res=>{

					this.filterList = res.data.data.filters.data;

          this.currentTabId = this.ticketTabData || this.currentTabId || this.filterList[0].id;

          this.apiUrl = `/api/client/ticket-list?filter_id=${this.currentTabId}`;

					this.loading = false;

					this.hasDataPopulated = true;

				}).catch(err=>{

					this.loading = false;

					this.hasDataPopulated = true;
				})
			},

		},

		components : {
			
			'my-tickets-table' : ClientTicketsTable,

			'ticket-status': ChangeStatus,

			'change-status-modal' : ChangeStatusModal,

			'client-ticket-filter': DataTableFilter
		}
	};
</script>

<style scoped>
	
	.tickets_tab .active { color: blue !important; }

	.tickets_cursor_tab { cursor: pointer; }

	.tab-content { margin-top: 15px !important; }

	.tab_count {
		background: #ddd;
	    color: #000;
	}
</style>