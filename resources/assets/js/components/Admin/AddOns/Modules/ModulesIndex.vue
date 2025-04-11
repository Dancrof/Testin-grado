<template>
	
	<div class="col-sm-12">
	
		<alert componentName="dataTableModal"/>

		<div class="card card-light" id="modules-list">

			<div class="card-header">
				
				<h3 class="card-title"> {{ lang('list_of_modules') }}</h3>        
			</div>

			<div class="card-body modules_list">

				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="modules-list"></data-table>    
			</div>
		</div>
	</div>
</template>

<script>

    import ModuleActions from "./ModuleActions.vue";

    import ModuleName from "./ModuleName.vue";

	export default {

		name : 'modules-index',

		data() {
			
			return {
				
				apiUrl:'/api/getmodules',
				
				columns: ['name', 'version', 'action'],
				
				options: {

          headings : {
            name: this.trans('name'),

            version: this.trans('version'),

            action: this.trans('action')
          },

          columnsClasses : {

						name: 'mod-name', 
					
						version: 'mod-version',

						action: 'mod-action'
					},

					sortIcon: {
						
						base : 'glyphicon',
							
						up: 'glyphicon-chevron-down',
							
						down: 'glyphicon-chevron-up'
					},
				
					texts: { filter: '', limit: '' },
					
					filterable:  false,

					sortable: [],
					
					pagination:{chunk:5,nav: 'fixed',edge:true},

					templates : {

                        name : function(createElement,row) {

                            return this.h(ModuleName, {

                                data: row,
                            })
                        },

                        action: function(createElement, row) {

                            return this.h(ModuleActions, {

                                data: row,
                            })
                        },
					},
				
					requestAdapter(data) {

						return {
							
							'sort-field' : data.orderBy ? data.orderBy : 'status',
							
							'sort-order' : data.ascending ? 'desc' : 'asc',
							
							'search-query' : data.query.trim(),
							
							page : data.page,

							limit : data.limit,	
						}
					},

					responseAdapter({data}) {
            return {

              data: data.data,

              count: data.data.length
            }

					},

					orderBy: { column: 'status', ascending: true },
				},
			}
		},
	};
</script>

<style>
	
	.name,.version,.action{ max-width: 250px; word-break: break-all;}

	.modules_list .VueTables .table-responsive {
		overflow-x: auto;
	}

	.modules_list .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>