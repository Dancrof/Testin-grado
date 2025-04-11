<template>

	<div class="col-sm-12">

		<alert componentName="agentList" />

    	<faveo-box :title="trans('list_of_agents')" boxClass="card-light">

            <template #headerMenu>

                <div class="card-tools">

                    <a class="btn btn-tool" @click="toggleFilterView" v-tooltip="trans('filter')">

                        <i class="glyphicon glyphicon-filter" ></i>
                    </a>

                    <router-link class="btn btn-tool" to="/agent/create" v-tooltip="{content:trans('create_agent'), placement:'left'}" id="add-agent-link">

                        <i class="glyphicon glyphicon-plus" aria-hidden="true"> </i>
                    </router-link>
                </div>
            </template>

            <div id="my_agents">

                <advance-filter id="filter-box" v-show="isShowFilter" :metaData="filterOptions"
                    @selectedFilters="selectedFilters" />

                <data-table :url="apiUrl" :dataColumns="columns" :option="options" scroll_to="agents-list"></data-table>
            </div>
        </faveo-box>
    </div>
</template>

<script type="text/javascript">

    import { computed }  from 'vue';
    import { useStore } from 'vuex';

	import UserTableActions from "../../../Agent/User/UserTableActions.vue";

    import DataTableStatuses from "../../../MiniComponent/DataTableComponents/DataTableStatuses.vue";

	import AdvanceFilter from "../../../Extra/AdvanceFilter.vue";

	export default {

		name : 'agent-list',

		description : 'Agent list table component',

        setup() {

            const store = useStore();

            return {
                // getter
                formattedTime: computed(() => store.getters.formattedTime)
            };
        },

		components:{

			AdvanceFilter,
		},

		data: () => {

			return {

        		isShowFilter: false,

				/**
				 * api url for ajax calls
				 * @type {String}
				 */
				apiUrl:'api/admin/get-users-list?roles[0]=admin&roles[1]=agent&active=1',

				/**
				* columns required for datatable
				* @type {Array}
				*/
				columns: ['name', 'user_name', 'email', 'phone', 'info', 'action'],

				/* filterOptions object contains different filter option like
				*  1. usetType (from elements property)
				*  2. departments (from api call)
				*  3. teams (from api call)
				*/
        filterOptions: [
          {
            section: [
              {
                name: 'userType',
                url: '',
                elements: [
                  {id:'all', name:'All', queryPerm:'roles[0]=admin&roles[1]=agent'},
                  {id:'active_admin_agent', name:'Active Admins and Agents', queryPerm:'roles[0]=admin&roles[1]=agent&active=1'},
                  {id:'deactive_admin_agent', name:'Deactivated Admins and Agents', queryPerm:'roles[0]=admin&roles[1]=agent&active=0'},
                  {id:'active_admin', name:'Active Admins', queryPerm:'roles[0]=admin&active=1'},
                  {id:'deactive_admin', name:'Deactivated Admins', queryPerm:'roles[0]=admin&active=0'},
                  {id:'all_admin', name:'All Admins', queryPerm:'roles[0]=admin'},
                  {id:'active_agent', name:'Active Agents', queryPerm:'roles[0]=agent&active=1'},
                  {id:'deactive_agent', name:'Deactivated Agents', queryPerm:'roles[0]=agent&active=0'},
                  {id:'all_agent', name:'All Agents', queryPerm:'roles[0]=agent'}
                ],
                isMultiple: false,
                isPrepopulate: false,
                label: 'user_type',
                value: {id: 'active_admin_agent', name: 'Active Admins and Agents', queryPerm: 'roles[0]=admin&roles[1]=agent&active=1'},
                className: 'col-sm-4'
              },

              {
                name: 'departments',
                url: 'api/dependency/departments',
                elements: [],
                isMultiple: true,
                isPrepopulate: false,
                label: 'departments',
                value: '',
                className: 'col-sm-4'
              },

              {
                name: 'teams',
                url: 'api/dependency/teams',
                elements: [],
                isMultiple: true,
                isPrepopulate: false,
                label: 'teams',
                value: '',
                className: 'col-sm-4'
              },
            ],
          }
				],
        
				/**
				* Options required for datatable
				* @type {Object}
				*/
				options: {},
      		}
    	},

    	beforeMount() {

			const self = this;

      		this.options = {

				headings: {

          name: this.trans('name')  ,

          user_name: this.trans('user_name'),

          email: this.trans('email'),

          phone: this.trans('phone'),

          info: this.trans('account_info'),

          action: this.trans('actions')

          		},
          
          		columnsClasses: {
					name: 'name__agentList',
					user_name: 'username__agentList',
					email:'email__agentList',
					phone: 'phone__agentList',
					info: 'active__agentList',
					action: 'action__agentList'
				},

          		texts: { filter: '', limit: '' },

				templates: {

					name: function(createElement, row) {

						return self.h('a', {
                            'href': self.basePath() + '/panel/user/' + row.id,
                            'target': "_blank"
						}, row.name);
					},

					phone(h, row) {

						return row.phone === ' Not available' || row.phone === ' ' || !row.phone ? '--' : row.phone;
					},

					action: function(createElement,row) {

                        return self.h(UserTableActions,{
                            data : row
                        })
                    }, // template for the ACTION column

                    info: function(createElement,row) {

                        return self.h(DataTableStatuses,{
                            data : row
                        })
                    },

					type(h,row){

						return row.type.name
					},
				},

				sortable: ['name', 'user_name', 'email'], // sortable columns

            filterable: ['name', 'user_name', 'email'],

            pagination: { chunk: 5, nav: 'scroll' },

				requestAdapter(data) {

      				return {
        				'sort-field': data.orderBy ? data.orderBy : 'name',
						'sort-order': data.ascending ? 'asc' : 'desc',
						'search-query': data.query.trim(),
						page: data.page,
						limit: data.limit,
					}
    			},

				responseAdapter({data}) {

					if(data) {

						return {
  							data: data.data.users.map(data => {

								data.edit_url =  '/agent/' + data.id + '/edit';

								data.view_url = self.basePath() + '/panel/user/' + data.id ;

								data.agent_view_url = self.basePath() + '/panel/agent/' + data.id ;

								data.from = 'admin';

								return data;
							}),

  							count: data.data.total
  						}
          			}
         		},

		        orderBy: { column: 'name', ascending: true },
        	}
    	},

		methods: {

			selectedFilters(value){ //teams userType departments

				if(value === 'closeEvent') {

					this.isShowFilter = false;

					return;

				} else if(value === 'resetEvent') {

					this.resetFilter();

					return;
        		}

				let baseUrlForFilter = 'api/admin/get-users-list?';

				let params = '';

        		if(value.userType) { //userType

					this.filterOptions[0].value = value.userType;

					params = value.userType.queryPerm + '&';

				} else {

					params = "roles[0]=admin&roles[1]=agent&";
        		}

        		if(value.departments) { //departments

              this.filterOptions[0].section[1].value = value.departments;

					value.departments.forEach(function(element, index) {

						params +=  'dept-ids[' + index + ']=' + element.id + '&'
            		});
        		}

        		if(value.teams) { //teams

              this.filterOptions[0].section[2].value = value.teams;

					value.teams.forEach(function(element, index) {

						params +=  'team-ids[' + index + ']=' + element.id + '&'
            		});
        		}

				if(params[params.length-1] === '&') {

					params = params.slice(0, -1);
        		}

				this.apiUrl = baseUrlForFilter + params;

				this.isShowFilter = false;
      		},

      		resetFilter() {

				this.filterOptions.forEach(function(element){

					element.value = '';
        		});

				this.apiUrl = 'api/admin/get-users-list?roles[0]=admin&roles[1]=agent';
      		},

      		toggleFilterView() {

				this.isShowFilter = !this.isShowFilter;
      		},
		},
	};
</script>

<style type="text/css">
	.name__agentList,.username__agentList,.email__agentList,.phone__agentList,.active__agentList{
	  max-width: 250px; word-break: break-all;
	}
	.role__agentList { text-transform: capitalize; }

	#my_agents .VueTables .table-responsive {
	  overflow-x: auto;
	}
	#my_agents .VueTables .table-responsive > table{
	  width : max-content;
	  min-width : 100%;
	  max-width : max-content;
	  overflow: auto !important;
	}
</style>