<template>
	
	<div id="source-list" class="col-sm-12">
		
		<alert componentName="dataTableModal" />

		<faveo-box :title="trans('list_of_source')">

            <template #customActions>

                <div class="card-tools">

                    <router-link class="btn btn-tool" to="/source/create" v-tooltip="{content:trans('create_source'), placement: 'left'}">

                        <i class="glyphicon glyphicon-plus"> </i>
                    </router-link>
                </div>
            </template>

			<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="source-list">
					
			</data-table>
		</faveo-box>
	</div>
</template>

<script>
	
	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

    export default {

		name : 'source-index',

		data () {

			return {

				columns : ['name', 'value', 'description', 'action'],

				apiUrl : '/api/source-list',

				options : {}
			}
		},

		beforeMount () {

			const self = this;

			this.options = {

        headings: {
          name: this.trans('name'),

          description : this.trans('description'),

          value : this.trans('display_name'),

          action : this.trans('actions')
        },

				columnsClasses : {

					name: 'source-name',

					value : 'source-display',

					description : 'source-desc',

					action: 'source-action',
				},

				texts: { filter: "", limit: "" },

				templates: {

					description(h,row) {

						return row.description ? row.description : '--'
					},

		  			action: (f,row) =>{

                        return self.h(DataTableActions,{
                            data : row
                        })
                    },
				},
				
				sortable: [ 'name', 'value', 'description' ],

				filterable: [ 'name', 'value', 'description' ],
				
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
				 		
				 		data: data.data.ticketSources.map(data => {
							
							data.edit_url = "/source/" + data.id + '/edit';
							
							data.delete_url = self.basePath() + "/api/source-delete/" + data.id;

							data.replace = true;

							data.dependency = "sources";

							data.title = "select_different_ticket_source_to_delete";
							
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
	
	.source-name,.source-desc,.source-display,.source-action{ max-width: 250px; word-break: break-all;}
	
	#source-list .VueTables .table-responsive {
		overflow-x: auto;
	}

	#source-list .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>