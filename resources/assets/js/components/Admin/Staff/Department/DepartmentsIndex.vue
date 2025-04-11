<template>
	
	<div class="col-sm-12" id="departments-table">
	
		<alert componentName="dataTableModal"/>

		<div class="card card-light">

			<div class="card-header">
	
				<h3 class="card-title">{{trans('list_of_departments')}}</h3>
					
				<div class="card-tools">
	
					<router-link class="btn btn-tool" to="/department/create" v-tooltip="trans('create_department')">

						<i class="glyphicon glyphicon-plus"> </i>
					</router-link>
				</div>
			</div>
			
			<div class="card-body" id="my_depts">
				
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="departments-table"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

    import DepartmentManagers from "./DepartmentManagers.vue";
    import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

	export default {
		
		name : 'departments-index',

		description : 'Departments table component',

		data(){

			return {

			columns: ['name', 'type', 'managers', 'actions'],
				
			options: {},
		
			apiUrl:'/api/admin/departments-list',
			}
		},

		beforeMount(){

			const self = this;

			this.options = {

				sortIcon: {

          		base : 'glyphicon',

          		up: 'glyphicon-chevron-down',

          		down: 'glyphicon-chevron-up'
        		},
        
				texts : { 'filter' : '', 'limit' : ''},

        headings : {
          name : this.trans('name'),

          managers : this.trans('managers'),

          type : this.trans('type'),

          actions : this.trans('actions')
        },
				
				columnsClasses : { 

					name : 'dept-name', 

					managers : 'dept-manager',

					type : 'dept-type',

					actions : 'dept-actions'
				},
				
				templates: {

                    actions : function (createElement,row){

                        return self.h(DataTableActions,{
                            data : row
                        })
                    },

					managers : function (createElement,row){

                        return self.h(DepartmentManagers,{
                            data : row
                        })
                    },
					
					type(h,row){
						
						return row.type.name
					}
				},
				
				sortable:  ['name', 'type'],
				
				filterable:  ['name', 'type', 'managers'],
				
				pagination:{chunk:5,nav: 'scroll'},
				
				requestAdapter(data) {
					
					return {
						
						'sort-field': data.orderBy ? data.orderBy : 'id',
						
						'sort-order': data.ascending ? 'desc' : 'asc',
						
						'search-query':data.query,
						
						page:data.page,
						
						limit:data.limit,
					}
				},
				
				responseAdapter({data}) {
					
					return {
					
						data: data.data.data.map(data => {
						
							data.edit_url = '/department/' + data.id + '/edit';

							data.view_url = '/department/' + data.id ;

							data.delete_url = self.basePath() + '/api/admin/delete-department/' + data.id;

							return data;
						}),
						count: data.data.total
					}
				},

				orderBy: { column: 'id', ascending: true },
			}
		}
	};
</script>

<style>
	
	.dept-name,.dept-manager,.dept-type,.dept-actions{ max-width: 250px; word-break: break-all;}
	
	#my_depts .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_depts .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>