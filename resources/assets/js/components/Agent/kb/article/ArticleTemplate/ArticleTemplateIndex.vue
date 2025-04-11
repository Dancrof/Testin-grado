<template>
	
	<div id="template-index" class="col-sm-12">
	
		<alert componentName="dataTableModal"/>

		<div class="card card-light ">
	
			<div class="card-header">
		
				<h3 class="card-title">{{lang('list_of_article_template')}}</h3>

				<div class="card-tools">
	
					<router-link class="btn-tool" to="/article/create/template" v-tooltip="lang('create_template')">
						
						<i class="glyphicon glyphicon-plus"> </i>
					</router-link>
				</div>
			</div>
			
			<div class="card-body" id="my_art_templates">
				
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="template-index"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

	import DataTableActions from "../../../../MiniComponent/DataTableComponents/DataTableActions.vue";
	import DataTableStatus from "../../../../MiniComponent/DataTableComponents/DataTableStatus.vue";

	export default {
		
		name : 'article-template-index',

		description : 'Article template table component',

		data: () => ({

			columns: ['name', 'status', 'action'],
				
			options: {},

			apiUrl:'/articletemplate/index',				
		}),

		beforeMount(){

			const self = this;

			this.options = {

				sortIcon: {
					base: "glyphicon",
					down: "glyphicon-chevron-up",
					up: "glyphicon-chevron-down",
				},
				
				texts : { 'filter' : '', 'limit': ''},

        headings : {
          name: this.trans('name'),

          action : this.trans('actions'),

          status: this.trans('status')
        },
				
				templates: {
				
					status: (f,row)=>{
						return self.h(DataTableStatus,{ data : row})
					},
				
					action: (f,row)=>{
						return self.h(DataTableActions,{ data : row})
					}
				},

				columnsClasses : {

					name: 'template-name',

					status: 'template-status',

					action: 'template-action',
				},
				
				sortable:  ['name', 'status'],
				
				filterable:  ['name', 'status'],
				
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

						data.edit_url = '/article/template/' + data.id + '/edit';

						data.delete_url = self.basePath()+'/article/deletetemplate/' + data.id;
				
						data.active = (data.active == '1') ? 'active' : 'inactive';

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

<style type="text/css">

	.template-status,.template-name,.template-action{
		max-width: 250px; word-break: break-all;
	}
	
	#my_art_templates .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_art_templates .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>