<template>
	
	<div class="col-sm-12" id="filter-settings">
	
		<alert componentName="dataTableModal"/>

		<div class="card card-light ">
	
			<div class="card-header">
				
				<h3 id="client-filter-list" class="card-title">{{trans('client-filter-list')}}</h3>

				<div class="card-tools" v-if="!isEditMode && totalFilters !== 5">

					<a class="btn btn-tool" href="javascript:;" v-tooltip="trans('client-filter-create')" @click="toggleFilterView">

						<i class="glyphicon glyphicon-plus"> </i>
					</a>
				</div>
			</div>

			<div class="card-body" id="my_client_filter_list">

				<ticket-filter  v-if="isShowFilter" :showFilter="isShowFilter" :closeFilterView="closeFilterView" from="clientFilter"
					:isEditMode="isEditMode" :selectedId="selectedId" divId="my_client_filter_body" :totalFilters="totalFilters">

				</ticket-filter>

				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="client-filter-list"></data-table>
			</div>
		</div>
	</div>
</template>

<script type="text/javascript">

	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

    import {useStore} from 'vuex';
    import {computed} from "vue";

	import { scrollToElement } from '../../../../helpers/extraLogics'

    import TicketFilter from "../../../Agent/tickets/filters/TicketFilter.vue";

	export default {

		name : 'client-filter-list',

        setup() {

            const store = useStore();

            return {
                // getter
                formattedTime: computed(() => store.getters.formattedTime)
            };
        },

		data: () => ({

			columns: ['name', 'created_at', 'updated_at', 'action'],

			options: {},

			apiUrl:'/api/client/ticket-filter',

			isShowFilter : false,

			isEditMode : false,

			selectedId : 0,

			totalFilters : 0
		}),

		created () {

			window.emitter.on('filterToggleClicked',this.editFilter);

			window.emitter.on('ticketFilterSaved',this.updateTable);
		},

		beforeMount() {

			const self = this;

			this.options = {

				headings: {

          name: this.trans('name'),

          created_at : this.trans('created_at'),

          updated_at : this.trans('updated_at'),

          action: this.trans('actions')
				},
				
				columnsClasses : {

					name: 'filter-name', 

					created_at: 'filter-time',

					updated_at: 'filter-time',

					action: 'filter-action',
				},

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},

				texts: { filter: '', limit: '' },

				templates: {

					created_at(h, row) {

						return self.formattedTime(row.created_at);
					},

					updated_at(h, row) {

						return self.formattedTime(row.updated_at);
					},

                    action: function(createElement, row) {

                        return self.h(DataTableActions, {

                            data: row,
                        })
                    }
				},

				sortable:  ['name', 'created_at', 'updated_at'],
				
				filterable:  ['name'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
	      
	        return {
	          
	          'sort-field' : data.orderBy ? data.orderBy : 'id',
	          
	          'sort-order' : data.ascending ? 'desc' : 'asc',
	          
	          'search-query' : data.query.trim(),
	          
	          page : data.page,
	          
	          limit : data.limit,
	        }
	      },

			 	responseAdapter({data}) {

					self.totalFilters = data.data.filters.total;

					return {
						
						data: data.data.filters.data.map(data => {

							data.filter_toggle_url = true;

							data.delete_url = self.basePath() + '/api/agent/ticket-filter/' + data.id;

							return data;
						}),
						count: data.data.filters.total
					}
				},

				orderBy: { column: 'id', ascending: true },
			}
		},

		methods:{
			
			toggleFilterView() {

				this.isShowFilter = !this.isShowFilter;

				this.isEditMode = false;

				this.selectedId = 0;
			},

			closeFilterView() {

				this.isShowFilter = false;

				this.isEditMode = false;

				this.selectedId = 0;
			},

			editFilter(value) {

				this.scrollToTarget('filter-settings')

				if(this.isShowFilter) {

					this.isShowFilter = false;

					setTimeout(()=>{

						this.isShowFilter = true;
					},1000)

				} else {
					
					this.isShowFilter = true;
				}

				this.isEditMode = true;

				this.selectedId = value.id;
			},

			scrollToTarget(id){

				return scrollToElement(id)
			},

			updateTable() {

				this.isShowFilter = false;

				this.isEditMode = false;

				this.selectedId = 0;

				window.emitter.emit('refreshData');
			}
		},

		components : {

			'ticket-filter': TicketFilter,
		}
	};
</script>

<style type="text/css">
	
	.filter-name,.filter-time,.filter-action{
		max-width: 250px; word-break: break-all;
	}
	
	#my_client_filter_list .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_client_filter_list .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}

	#my_client_filter_body { padding: 0.75rem !important; }
</style>
