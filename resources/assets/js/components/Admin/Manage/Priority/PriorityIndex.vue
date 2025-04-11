<template>
	
	<div id="priority-list" class="col-sm-12">
		
		<alert componentName="dataTableModal" />

		<faveo-box :title="trans('list_of_ticket_priority')">

            <template #customActions>

                <div class="card-tools">

                    <router-link class="btn btn-tool" to="/ticket/priority/create" v-tooltip="{content:trans('create_ticket_priority'), placement:'left'}">

                        <i class="glyphicon glyphicon-plus"> </i>
                    </router-link>

                </div>

            </template>

			<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="priority-list">
					
			</data-table>
		</faveo-box>
	</div>
</template>

<script>
	
	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

    export default {

		name : 'priority-index',

		data () {

			return {

				columns : ['name', 'priority_desc', 'priority_color', 'action'],

				apiUrl : '/api/priority-list',

				options : {}
			}
		},

		beforeMount () {

			const self = this;

			this.options = {

        headings: { name : this.trans('priority'), priority_desc : this.trans('priority_desc'), priority_color : this.trans('priority_color'), action : this.trans('actions') },

				columnsClasses : {

					name: 'priority-name',

					priority_desc : 'priority-desc',

					priority_color: 'priority-color',

					action: 'priority-action',
				},

        sortIcon: {

          base : 'glyphicon',

          up: 'glyphicon-chevron-up',

          down: 'glyphicon-chevron-down'
        },

				texts: { filter: "", limit: "" },

				templates: {

					priority_color: function(createElement, row) {
						
						return self.h('div', {
							
							style: {
								width: '25px',
								height: '15px',
								background: row.priority_color
							  },
						});
					},

					action: (func,row)=>{

                        return self.h(DataTableActions,{
                            data : row
                        })
                    },
				},
				
				sortable: [ 'name', 'priority_desc' ],

				filterable: [ 'name', 'priority_desc' ],
				
				pagination: { chunk: 5, nav: "scroll" },
				
				requestAdapter(data) {
				
					return {
						
						'sort-field': data.orderBy ? data.orderBy : "id",
						
						'sort-order': data.ascending ? "desc" : "asc",
						
						'search-query': data.query.trim(),
						
						page: data.page,
						
						limit: data.limit
					};
				},

				responseAdapter({ data }) {  

					return {
						
						data: data.data.priorities.map(data => {
							
							data.edit_url = "/ticket/priority/" + data.id + '/edit';
							
							data.delete_url = self.basePath() + "/api/priority/delete/" + data.id;
							
							return data;
						}),
						
						count: data.data.total
					};
				},

				orderBy: { column: 'id', ascending: true },
			};
		}
	};
</script>

<style>
	
	.priority-name,.priority-desc,.priority-color,.priority-status,.priority-action{ max-width: 250px; word-break: break-all;}
	
	#priority-list .VueTables .table-responsive {
		overflow-x: auto;
	}

	#priority-list .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>