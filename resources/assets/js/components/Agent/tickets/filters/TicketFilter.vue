<template>

	<div class="inbox-tic-filter">

		<custom-loader v-if="loading"></custom-loader>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{lang('apply_filter')}}</h3>

					<!-- Custom Field Filter -->
				<custom-field-filter :selectedFilters="customFieldFilters" v-on:custom="getCustomFields" :customFilters="filter" :defaultFiltersObj="filterObjects"
					:updatedFieldValues="getUpdatedFilter" ref="custom_filter" :showLoader="visibleLoader" :filterId="selectedFilterId">

				</custom-field-filter>

				<save-filter v-if="showFilterPopUp" :filterName="filterName" :filterValues="filter" :filterObjects="filterObjects"
					:filterId="selectedFilter" :toggleFilterPopUp="toggleFilterPopUp" :mode="filterMode"
					:intitialDepartments="departments" :initialAgents="agents" :initial-teams="teams" :postFilterSaveAction="applyFilter"
					:dashboard-config="dashboardConfig" :from="from" :totalFilters="totalFilters" :source="source">

				</save-filter>
			</div>

			<div class="card-body" :id="divId">

				<template v-if="showFilter">

					<template v-if="from === 'clientFilter'">

						<div class="row">

							<common-api-filter :label="lang('ticket_id-subject')" :api="'tickets'" :base="'dependency'" :reset="reset"
								:keyname="'ticket-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['ticket-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('requester')" :api="'users'" :meta="true" :keyname="'owner-ids'"
								:reset="reset" :base="'dependency'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['owner-ids']">
							</common-api-filter>

							<common-filter :label="lang('category')" :filterArray="categoryClientFilterValue"
								:keyname="'category'" :reset="reset"
								v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['category']">
							</common-filter>

							<common-api-filter :label="lang('status')" :api="'statuses?client_visibility=1&client_filter=1'"
								:keyname="'status-ids'" :base="'dependency'"
								:reset="reset" :meta="true" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['status-ids']">
							</common-api-filter>

							<time-range-filter
								v-if="!loading"
								:labels="['created_within_last', 'created_in']"
								:options="timeFilterOptions"
								v-on:selected="filtervalue"
								:identifier="'created-at'"
								:value="filterObjects['created-at']"
								:reset="reset">
							</time-range-filter>
						</div>
					</template>

					<template v-else>

						<div class="row">

							<common-api-filter :label="lang('ticket_id-subject')" :api="'tickets'" :base="'dependency'" :reset="reset"
								:keyname="'ticket-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['ticket-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('requester')" :api="'users'" :meta="true" :keyname="'owner-ids'"
								:reset="reset" :base="'dependency'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['owner-ids']">
							</common-api-filter>

							<common-filter :label="lang('category')" :filterArray="categoryFilterValue" :keyname="'category'" :reset="reset"
								v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['category']">
							</common-filter>
						</div>

						<div class="row">
							<common-api-filter :label="lang('organization')" :api="'organizations'" :base="'dependency'" :reset="reset"
								:keyname="'organization-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['organization-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('department')" :api="'departments'" :base="'dependency'" :reset="reset"
								:keyname="'dept-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['dept-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('help_topic')" :api="'help-topics'" :base="'dependency'" :reset="reset"
								:keyname="'helptopic-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['helptopic-ids']">
							</common-api-filter>
						</div>

						<div class="row">
							<common-api-filter :label="lang('type')" :api="'types'" :base="'dependency'" :keyname="'type-ids'" :reset="reset"
								v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['type-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('source')" :api="'sources'" :base="'dependency'" :keyname="'source-ids'"
								:reset="reset" v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['source-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('priority')" :api="'priorities'" :base="'dependency'" :reset="reset"
								:keyname="'priority-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['priority-ids']">
							</common-api-filter>
						</div>

						<div class="row">

							<common-api-filter :label="lang('status')" :api="'statuses'" :keyname="'status-ids'" :base="'dependency'"
								:reset="reset" :meta="true" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['status-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('labels')" :api="'labels?limit-by-status=false'" :keyname="'label-ids'" :base="'dependency'"
								:reset="reset" v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['label-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('tags')" :api="'tags'" :base="'dependency'" :keyname="'tag-ids'" :reset="reset"
								v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['tag-ids']">
							</common-api-filter>
						</div>

						<div class="row">
							<common-filter :label="lang('is_resolved')" :filterArray="booleanFilters" :keyname="'is-resolved'" :reset="reset"
											v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['is-resolved']">
							</common-filter>

							<common-filter :label="lang('has-resolution-sla-met')" :filterArray="slaMetFilters" :keyname="'has-resolution-sla-met'" :reset="reset"
								v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['has-resolution-sla-met']" ref="has_resolution_sla_met_filter">
							</common-filter>

							<common-filter :label="lang('has-response-sla-met')" :filterArray="slaMetFilters" :keyname="'has-response-sla-met'" :reset="reset"
								v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['has-response-sla-met']" ref="has_response_sla_met_filter">
							</common-filter>

						</div>

						<div class="row">
							<common-filter :label="lang('is_assigned_agent')" :filterArray="booleanFilters" :keyname="'assigned_agent'" :reset="reset"
								v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['assigned_agent']">
							</common-filter>

              <common-filter :label="lang('is_assigned_team')" :filterArray="booleanFilters" :keyname="'assigned_team'" :reset="reset"
                             v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['assigned_team']">
              </common-filter>

							<common-filter :label="lang('is_answered')" :filterArray="booleanFilters" :keyname="'answered'" :reset="reset"
								v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['answered']">
							</common-filter>

						</div>

						<div class="row">

              <common-filter :label="lang('is_reopened')" :filterArray="booleanFilters" :keyname="'reopened'" :reset="reset"
                             v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['reopened']">
              </common-filter>

							<common-api-filter :label="lang('creator')" :api="'users'" :meta="true" :base="'dependency'" :reset="reset"
								:keyname="'creator-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['creator-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('assigned_to_agent')" :meta="true" :api="'agents'" :base="'dependency'"
								:reset="reset" :keyname="'assignee-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['assignee-ids']">
							</common-api-filter>

						</div>

						<div class="row">

              <common-api-filter :label="lang('assigned_to_team')" :api="'teams'" :base="'dependency'" :reset="reset"
                                 :keyname="'team-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
                                 :value="filterObjects['team-ids']">
              </common-api-filter>

							<common-api-filter :label="lang('location')" :api="'locations'" :base="'dependency'" :reset="reset"
								:keyname="'location-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
								:value="filterObjects['location-ids']">
							</common-api-filter>

							<common-api-filter :label="lang('sla_plan')" :api="'sla-plans'" :base="'dependency'" :reset="reset"
												:keyname="'sla-plan-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
												:value="filterObjects['sla-plan-ids']">
							</common-api-filter>

						</div>

						<div class="row">

              <common-api-filter :label="lang('collaborator')" :api="'users'" :meta="true" :base="'dependency'" :reset="reset"
                                 :keyname="'collaborator-ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
                                 :value="filterObjects['collaborator-ids']">
              </common-api-filter>

							<time-range-filter
								v-if="!loading"
								:labels="['created_within_last', 'created_in']"
								:options="timeFilterOptions"
								v-on:selected="filtervalue"
								:identifier="'created-at'"
								:value="filterObjects['created-at']"
								:reset="reset">
							</time-range-filter>

							<time-range-filter
								v-if="!loading"
								:labels="['modified_within_last', 'modified_in']"
								:options="timeFilterOptions"
								v-on:selected="filtervalue"
								:identifier="'updated-at'"
								:value="filterObjects['updated-at']"
								:reset="reset">
							</time-range-filter>

						</div>

            <div class="row">

              <time-range-filter
                  v-if="!loading"
                  :labels="['due_within_next', 'due_in']"
                  :options="timeFilterOptions"
                  v-on:selected="filtervalue"
                  :identifier="'due-on'"
                  :value="filterObjects['due-on']"
                  :reset="reset">
              </time-range-filter>

	            <template v-if="showRatingFilter">

		            <common-api-filter :label="trans('ticket_filter_rating')" api="rating-types" base="dependency"
		                               :keyname="'rating_ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
		                               :value="filterObjects['rating_ids']" :reset="reset"
		            />

		            <common-filter :label="trans('ticket_filter_rating_impact')" :filterArray="ratingImpactFilters" keyname="rating_impact" :reset="reset"
		                           v-on:selected="filtervalue" :updateFilter="updateFilter" :value="filterObjects['rating_impact']"
		            />
	            </template>
            </div>

						<div class="row">
							<common-api-filter :label="lang('forms')" :api="'forms'" :base="'ticket'" :reset="reset"
																 :keyname="'form_category_ids'" v-on:selected="filtervalue" :updateFilter="updateFilter"
																 :value="filterObjects['form_category_ids']">
							</common-api-filter>
						</div>

					</template>
				</template>

				<hr v-if="customFieldFilters.length>0" class="hr" />

				<div v-if="!reset" class="row">

					<div class="col-sm-4" v-for="(value,index) in customFieldFilters">

						<custom-form-fields :formField="value" :allFields="customFieldFilters" v-on:updated="updatedCustomFields" key="index"></custom-form-fields>
					</div>
				</div>

				<div v-if="reset" class="row">

					<custom-loader></custom-loader>
				</div>
			</div>

		  	<div class="card-footer">

				<template v-if="from === 'clientFilter'">

					<button id="edit-filter" type="button" @click = "saveFilter()" class="btn btn-primary">

						<span v-if="!isEditMode"><i class="fas fa-save" aria-hidden="true"></i>&nbsp;{{lang('save')}}</span>

						<span v-else><i class="fas fa-sync" aria-hidden="true"></i>&nbsp;{{lang('update')}}</span>
					</button>

				</template>

				<template v-else>

					<button id="apply-filter" type="button" @click = "applyFilter(true)" class="btn btn-primary">

						<i class="fas fa-check" aria-hidden="true"></i>&nbsp;{{lang('apply')}}
					</button>

					<!-- should not be visible in apply-only mode -->

          <button id="edit-filter" v-if="!isApplyOnlyMode && source === 'open_tickets'" type="button" @click = "saveFilter('save')" class="btn btn-primary">

            <span><i class="fas fa-save" aria-hidden="true"></i>&nbsp;{{lang('save')}}</span>

          </button>

					<button id="edit-filter" v-if="!isApplyOnlyMode && showUpdateBtn" type="button" @click = "saveFilter()" class="btn btn-primary">

						<span v-if="selectedFilter === 0 && !isApplyOnlyMode"><i class="fas fa-save" aria-hidden="true"></i>&nbsp;{{lang('save')}}</span>

						<span v-else> <span class="fas fa-sync"></span>&nbsp; {{ lang('update')}}</span>
					</button>

					<slot name="filter-operation-btn-group"></slot>

					<button id="delete-filter" v-if="(selectedFilter !== 0 && !isDefaultFilter && source !== 'open_tickets') || (isDefaultFilter && isDeleteable)" type="button" @click = "saveFilter('delete')"
						class="btn btn-secondary">

						<i class="fas fa-trash" aria-hidden="true"></i>&nbsp;{{lang('delete')}}
					</button>
				</template>

				<button id="reset-filter" type="button" @click = "resetFilter()" class="btn btn-primary">

					<i class="fas fa-undo" aria-hidden="true"></i>&nbsp;{{lang('reset')}}
				</button>

				<button id="close-filter" type="button" @click = "closeFilter()" class="btn btn-secondary">

					<i class="fas fa-times" aria-hidden="true"></i>&nbsp;{{lang('cancel')}}
				</button>
			</div>
	  	</div>

	  	<custom-loader v-if="appendLoad"></custom-loader>
 	</div>
</template>
<script>

	import { boolean, getIdFromUrl } from "../../../../helpers/extraLogics";

    import { errorHandler } from "../../../../helpers/responseHandler";

    import axios from 'axios';
    import commonApiFilter from "./commonApiFilter.vue";
    import commonFilter from "./commonFilter.vue";
    import CustomFieldFilter from "./CustomFieldFilter.vue";
    import SaveFilter from "./SaveFilter.vue";
    import TimeRangeFilter from "./TimeRangeFilter.vue";
    import CustomFields from "./CustomFields.vue";

	export default {

		props: {

			// In apply only mode, save filter functionality will not be available
			isApplyOnlyMode: {
				type: Boolean,
				default: false
			},

			/**
			 * Fill the filter fields value
			 * May be used to show default filters in some other module
			 */
			prefilledFilterObject: {
				type: Object,
				default: () => undefined
			},

			/**
			 * Api endpoint to get applied filter object to fill the filter list
			 */
			filterDependenciesApiEndpoint: {
				type: String,
				default: ''
			},

			/**
			 * Filter button icon class
			 */
			iconClass: {
				type: String,
				default: 'fas fa-filter'
			},

			showFilter : { type : Boolean, default : true },
			
			closeFilterView : { type : Function , default : ()=> {} },

			from : { type : String, default : '' },

			isEditMode : { type : Boolean, default : false },

			selectedId : { type : [String, Number], default : 0 },

			divId : { type : String, default : '' },

			totalFilters : { type : Number, default : 0},
			
			filterNumber: { type: [String,Number], default: '' }
		},

		data(){
			return{
				 booleanFilters:[{'id':1,'text':'Yes'},{'id':0,'text':'No'}],
				 ratingImpactFilters:[{id:'positive',text:'Positive'},{id :'negative', text :'Negative'}, {id: 'neutral', text: 'Neutral'}],
				 slaMetFilters: [{'id':'met','text':'Met'}, {'id':'notmet','text':'Not met'}, {'id':'pending','text':'Pending'}],
				 categoryFilterValue:[
						 {'id':'all','text':this.trans("all")},
						 {'id':'inbox','text':this.trans("inbox")},
						 {'id':'mytickets','text':this.trans("mytickets")},
						 {'id':'unassigned','text':this.trans("unassigned")},
						 {'id':'overdue','text':this.trans("overdue")},
						 {'id':'unapproved','text':this.trans("unapproved")},
						 {"id": "waiting-for-approval", "text": this.trans("waiting-for-approval")},
						 {'id':'closed','text':this.trans("closed")},
						 {'id':'deleted','text':this.trans("deleted")},
						 {'id':'spam','text':this.trans("spam")}
					 ],
				categoryClientFilterValue:[
						 {'id':'all','text':this.trans("all")},
						 {'id':'inbox','text':this.trans("open")},
						 {'id':'closed','text':this.trans("closed")},
						 {'id':'deleted','text':this.trans("deleted")},
						 {'id':'waiting-for-approval','text':this.trans("waiting-for-approval")}
					 ],
				 filter:{},
				 customFieldFilters:[],
				 isRtl:true,

				 /**
				  * If the loader is loading
				  * @type {Boolean}
				  */
				 loading: false,

				 /**
				  * Complete filter objects which can be injected into the filters without
				  * worrying about API calls
				  * @type {Object}
				  */
				 filterObjects:{},

				 /**
				  * Filter that has been selected
				  * @type {Number}
				  */
				 selectedFilter:this.selectedId,

				 /**
				  * Show filter popup or not
				  * @type {[type]}
				  */
				 showFilterPopUp : false,

				 /**
				  * Name of the filter to be saved
				  * @type {String}
				  */
				 filterName : '',

				 /**
				  * Mode of the filter `save`, `share_only` or `delete`
				  * @type {String}
				  */
				 filterMode:'',

				 /**
				  * Departments with which filter is shared
				  * @type {Array}
				  */
				 departments:[],

         teams : [],

				 /**
				  * Agents with which filter is shared
				  * @type {Array}
				  */
				 agents:[],

				 /**
				  * If we want to reset all the filters
				  * @type {Boolean}
				  */
				 reset:false,

				 filterId : '',

				timeFilterOptions: [
					{ id: 'minute', value: 'unit_minute' },
					{ id: 'hour', value: 'unit_hour' },
					{ id: 'day', value: 'unit_day' },
					{ id: 'month', value: 'unit_month' }
				],

				/** If true saved filter will be displayed on the dashboard */
				dashboardConfig: {
					displayOnDashboard: false,
          isDisplayUnderDefault: false,
				iconColor: '#00C0EF',
				iconClass: {
				  "icon_class": "fas fa-ticket"
				},
          created_by:[],
          created_at:'',
          canViewCreatorProfile: true,
          display_order: ''
				},

				appendLoad : false,

        isDefaultFilter: false,

        isDeleteable: false,

        source: '',

        refreshFilter: false,

				selectedFilterId: ''
			}
		},
		computed: {

			showUpdateBtn() {

				return this.$route?.query?.category !== "archived";
			},

	      showRatingFilter() {
	      	let url = window.location.pathname;
	       	let urlArray = url.split("/");

      		 if(urlArray[urlArray.length - 3] == 'reports'){
      		 	 return false;
      		 } else {
      		 	 return true;
      		 }

	      }
    	},
		beforeMount() {

			this.openFilter();
		},

		mounted(){
		this.handleTooltip();
		},
		
		created() {
			window.emitter.on('performApplyAction', this.applyFilter);
			window.emitter.on('updateFilterApi', this.closeFilter);
		},

		methods:{
			updatedCustomFields(value) {

				this.customFieldFilters = value;
			},

			closeFilter() {

				this.closeFilterView()
			},

			/**
			 * NOTE: it is using jquery and native methods of jquery cannot be mocked,
			 * so putting that in a different method and mocking that instead
			 * handler tooltip and related css
			 * @return {undefined}
			 */
			handleTooltip(){
				setTimeout(()=>{
						$('.ticket-filter').tooltip();

						//is rtl
						if(this.$store.state.auth.user.user_language=='ar'){
													 this.isRtl = false;
						}
				},2000)
			},

			/**
			 * Hides/Shows the filter popup component
			 * @param  {Boolean} visiblity
			 * @return {undefined}
			 */
			toggleFilterPopUp(visiblity, isClosePopupClicked){
				/**
				 * Don't clear the fileds if close button is clicked
				 */
				if(this.filterMode == 'delete' && !isClosePopupClicked){
					this.filterObjects = {};
					this.filter = {};
					this.filterName = '';
					this.selectedFilter = 0;
					this.resetDashboardConfig();
					this.resetFilter();
				}
				this.showFilterPopUp = visiblity;
			},

			/**
			 * Gets list of ticket filters
			 * @param {Number} id   id of the filter
			 * @return {undefined}
			 */
			getTicketFilterById(id){

				this.loading = true

				//removing old filter altogether
				this.resetFilter();

				let url = boolean(id) ? '/api/agent/ticket-filter/' + id : '/api/agent/filter-dependencies';

				// If `filterDependenciesApiEndpoint` passed form child component use that endpoint
				if(this.filterDependenciesApiEndpoint) {
					url = this.filterDependenciesApiEndpoint;
				}

				let params = {};

				if(!boolean(id)){
					params = this.getParamsFromUrl();

					if(!params){
						return;
					}
				}

				// Fill the filterObjects, if `prefilledFilterObject` has some filter field's value
				if(typeof this.prefilledFilterObject !== 'undefined') {
					params = this.prefilledFilterObject;
				}

				axios.get(url, {params: params}).then(res => {

					let filtersFromBackend = {};

					// Clear custom field filters in case if it not report filter
					if(typeof this.prefilledFilterObject !== 'undefined') {
						this.customFieldFilters = [];
					}

					let editArr = []
					//push everything into filters(thats the tricky part)
					res.data.data.fields.map(element => {
						// if custom field
						if(element.key.indexOf('custom_') !== -1){
							editArr.push(element);
						} else {

							if(this.from === 'clientFilter' && element.key === 'category') {

								if(element.value === 'inbox') {

									element['value_meta'] = {id: "inbox", text: "Open"}
								}
							}

							// default fields
							filtersFromBackend[element.key] = element.value_meta;
						}
					})
					if(editArr.length){
						this.appendCustomFieldFilter(editArr);
					} else {
						this.loading = false;
					}

					//if we put `this.filterObjects` inside map, it will be changed on every loop
					//causing watcher to work abnormally. So store the object in a variable and then assign
					//it to `this.filterObjects`
					this.filterObjects = filtersFromBackend;

					if(boolean(id) && !this.filterDependenciesApiEndpoint){ // && filterDependenciesApiEndpoint is not passed from the child component
						this.selectedFilter = res.data.data.id;
						this.filterName = res.data.data.name;
						this.departments = res.data.data.departments;
						this.teams = res.data.data.teams;
						this.agents = res.data.data.agents;
						this.dashboardConfig.displayOnDashboard = res.data.data.display_on_dashboard;
            this.dashboardConfig.isDisplayUnderDefault = res.data.data.display_on_navigation_bar;
            this.dashboardConfig.created_by = res.data.data.created_by[0];
            this.dashboardConfig.created_at = res.data.data.created_at;
            this.dashboardConfig.canViewCreatorProfile = res.data.data.canViewCreatorProfile;
            this.dashboardConfig.display_order = res.data.data.display_order;
						if(res.data.data.icon_class) {
							this.dashboardConfig.iconClass.icon_class = res.data.data.icon_class;
							this.dashboardConfig.iconColor = res.data.data.icon_color;
						} else {
							this.resetDashboardConfig()
						}
            this.isDefaultFilter = res.data.data.is_default ? true : false;

            this.isDeleteable = res.data.data.is_deletable ? true : false;

            this.source = res.data.data.source;
					}
				})
				.catch(err => {
          this.loading = false;
					errorHandler(err);
				})
			},

			/**
			 * Gets URL parameters from URL
			 * @return {Object}
			 */
			getParamsFromUrl(){
				try{
					let search = location.search.substring(1);
					return JSON.parse('{"' + decodeURI(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"').replace(/%2F/g, '\/') + '"}')
				}catch(err){
					// in case of invalid json
					return {};
				}
			},

			/**
			 * Appends filter data coming from backend to custom field array
			 * @return {undefined}
			 */
			appendCustomFieldFilter(element){
				// let customFieldFilterObject = {};
				// customFieldFilterObject.label = element.label;
				// customFieldFilterObject.value = element.value;
				// customFieldFilterObject.selected = 1;
				// customFieldFilterObject.id = element.key.replace('custom_','');
				// this.customFieldFilters.push(customFieldFilterObject);
				this.$refs.custom_filter.valuesInEdit = element;
				// this.$refs.custom_filter.getCustomFields()
				
				setTimeout(()=>{
					this.loading = false;
				},1000)
			},

			/**
			 * Sends the filter along with its name to the backend and then filter the results accordingly
			 * @param {String} mode		can be `share_only`, `save` and `delete`
			 * @return {undefined}
			 */
			saveFilter(mode){
				this.filterMode = mode;

				this.customFieldFilters.map(field => {
					if(field.value){
						// should change it to just filters once backend starts calculating the
						// selected field
						this.filterObjects['custom_' + field.id] = field.value;
					}
				});

				//bring a pop-up with options: name and share options
				this.showFilterPopUp = true;
			},

			/**
			 * Updates filter object in `filterObjects`, which will be saved as filter later on
			 * @param  {[type]} filterObject {filterName: value} => value can be a string or an array of objects
			 * @return {undefined}
			 */
			updateFilter(filterObject){
				//payload(`filterObject`) can vary depeding on where it is getting called from. And all the keys will be appended to
				this.filterObjects[Object.keys(filterObject)[0]] = filterObject[Object.keys(filterObject)[0]];
				
				window.emitter.emit('onFilterSelected', this.filterObjects);
			},

			/**
			 * Updates local state variables
			 * @param  {String|Object|Number} value   value of the changed field
			 * @param  {String}               name    name of the changed field
			 * @return {undefined}
			 */
			onChange(value, name){
				this[name] = value
			},

			//filter menu open
			openFilter(){
				

						 let filterId = getIdFromUrl(this.currentPath());

						 this.selectedFilterId = this.filterNumber ? this.filterNumber : filterId;
						 if(this.isEditMode) { filterId = this.selectedFilter }

						 // instead of mounted, this API call should happen when filter is clicked
						 // if filter is not there, still it should read from URL and send all the paramaters
						 this.getTicketFilterById(filterId);
					
			},

			resetDashboardConfig() {
				this.dashboardConfig.displayOnDashboard = false;
        this.dashboardConfig.isDisplayUnderDefault = false;
				this.dashboardConfig.iconClass = { "icon_class": "fas fa-ticket" };
				this.dashboardConfig.iconColor = '#00C0EF'
        this.dashboardConfig.created_by = [];
        this.dashboardConfig.created_at = '';
        this.dashboardConfig.display_order = '';
			},

			visibleLoader(value) {
				this.appendLoad = value;
			},

			/**
			 * Resets the state of the component back to normal
			 * @return {undefined}
			 */
			resetFilter(){
				this.reset = true;
				this.filter = {};
				this.filterObjects = {};
				this.agents = [];
				this.departments = [];

				// resetting values of each field
				this.customFieldFilters.map(field => {
					field.value = "";
				});

				//we are giving 2 second window for all filters to reset their states
				setTimeout(()=>{
					this.reset = false;
				}, 2000)

			},

			filtervalue(payload){
				if (payload.isTimeRangeFilter) {
					const timeRangeFilterObj = payload.data;
					for (const key in timeRangeFilterObj) {
						if (timeRangeFilterObj.hasOwnProperty(key)) {
							this.filter[key] = timeRangeFilterObj[key];
							this.filterObjects[key] = timeRangeFilterObj[key];
						}
					}
				} else {
						for(var i in payload){
						this.filter[i]=payload[i];
					};
				}
			},

			applyFilter(scroll = false){

				if(this.customFieldFilters.length>0){

					this.customFieldFilters.map(field => {
						
						let value = typeof field.value === 'string' ? field.value.trim() : field.value;
						
						this.filter['custom_' + field.id] = value;
					});

					this.$emit('filter',this.filter, scroll);
				}
				else{
					if(this.filter.category == ''){
						this.filter.category == [];
					}
					// last paramater is `isApplyClicked`
					this.$emit('filter',this.filter, scroll, true);
				}
			},

			getUpdatedFilter(payload){

				this.filter = payload;
			},

			getCustomFields(payload){

			 this.customFieldFilters = payload;
			}
		},

    watch:{
      refreshFilter(newValue, oldValue) {

        if (newValue === true) {
          this.openFilter();
        }

        this.refreshFilter = false;
      }
    },

		components: {

            'common-api-filter': commonApiFilter,

            'common-filter': commonFilter,

            'custom-field-filter': CustomFieldFilter,

            'save-filter': SaveFilter,

            'time-range-filter': TimeRangeFilter,

            'custom-form-fields': CustomFields,
	  },
	};
</script>
<style scoped>
	.selected-filter-mark{
		position: absolute;
		right: 20px;
		margin-top: -30px;
	}
</style>
