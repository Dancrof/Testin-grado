<template>
	
	<div id="category-index" class="col-sm-12">
	
		<alert componentName="dataTableModal"/>

		<div class="card card-light ">
	
			<div class="card-header">
		
				<h3 class="card-title">{{lang('all_category')}}</h3>

				<div class="card-tools">
	
					<router-link class="btn-tool" to="/category/create" v-tooltip="lang('create_category')">
						
						<i class="glyphicon glyphicon-plus"> </i>
					</router-link>
				</div>
			</div>
			
			<div class="card-body" id="my_category">
				
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="category-index"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";
	import DataTableStatus from "../../../MiniComponent/DataTableComponents/DataTableStatus.vue";

	export default {
		
		name : 'category-index',

		description : 'Category table component',

		data: () => ({

			columns: ['name', 'description', 'status', 'display_order','action'],
				
			options: {},
	
			apiUrl:'/api/get-category-data',			
		}),

		beforeMount(){

			const self = this;

			this.options = {

				texts : { 'filter' : '', 'limit': ''},

        headings : {

          name: this.trans('name'),

          description: this.trans('description'),

          action : this.trans('actions'),

          display_order: this.trans('display_order'),

          status: this.trans('status')
        },

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},
				
				templates: {
					
					description: function(createElement, row) {
						
						return self.h('div', {

								title : row.description.replace(/(<([^>]+)>)/g, ""),

						    	innerHTML: row.description.length > 100 ? row.description.substring(0, 100)+'...' : row.description

						});
					},

					status: (f,row)=>{
						return self.h(DataTableStatus,{data:row})
					},
				
					action: (f,row)=>{
						return self.h(DataTableActions,{data:row})
					}
				},

				columnsClasses : {

					name: 'category-name',

					description: 'category-desc',

					action : 'category-action',

					display_order: 'category-order',

					status: 'category-status'
				},
				
				sortable:  ['name', 'description', 'status','display_order'],
				
				filterable:  ['name', 'description', 'status','display_order'],
				
				pagination:{chunk:5,nav: 'scroll'},

				requestAdapter(data) {
				
					return {
				
						sort: data.orderBy ? data.orderBy : 'id',
				
						order: data.ascending ? 'desc' : 'asc',
				
						search:data.query.trim(),
				
						page:data.page,
				
						limit:data.limit,
					}
				},
				
				responseAdapter({data}) {
				
					return {
				
						data: data.message.data.map(data => {

							data.from = 'agent';

							data.client_view_url = data.status ? self.basePath() + '/category-list/' + data.slug : 'javascript:;';
							
							data.edit_url = '/category/' + data.id + '/edit';

							data.delete_url =  '/category/delete/' + data.id;

							return data;
						
						}),
					
						count: data.message.total
					}
				},

				orderBy: { column: 'id', ascending: true },
			}
		}
	};
</script>

<style>

	.category-name,.category-desc,.category-order,.category-status,.category-action{ max-width: 250px; word-break: break-all;}

	#my_category .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_category .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>