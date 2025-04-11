<template>
	
	<div id="pages-index" class="col-sm-12">
	
		<alert componentName="dataTableModal"/>

		<div class="card card-light ">
	
			<div class="card-header">
				
				<h3 class="card-title">{{lang('list_of_pages')}}</h3>

				<div class="card-tools">
	
					<router-link class="btn-tool" to="/page/create" v-tooltip="lang('create_pages')">
						
						<i class="glyphicon glyphicon-plus"> </i>
					</router-link>
				</div>
			</div>
			
			<div class="card-body" id="my_pages">

				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="pages-index"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

	import {useStore} from 'vuex'
	import {computed} from "vue";

	export default {
		
		name : 'pages-index',

		description : 'Pages table component',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},

		data: () => ({

			columns: ['name', 'status', 'created_at','action'],
			
			options: {},
			
			apiUrl:'api/get-pages-data',	
		}),

		beforeMount(){
			
			const self = this;

			this.options = {
				
				texts : { 'filter' : '', 'limit': ''},

        headings : {
          name: this.trans('name'),

          action : this.trans('actions'),

          status: this.trans('status'),

          created_at : this.trans('created_at')
        },
				columnsClasses : {

					name: 'page-name',

					action : 'page-action',

					created_at: 'page-created',

					status: 'page-status'
				},

				templates: {
				
					status: function(createElement, row) {
					
						let span = self.h('span', {

							'class' : row.status === 1 ? 'btn btn-success btn-sm' : 'btn btn-danger btn-sm'

						}, row.status === 1 ? 'published' : 'draft');
						
						return self.h('a', {}, [span]);
					},
				
					action: (f,row) =>{
						return self.h(DataTableActions,{data:row})
					},

					created_at(h, row) {
						
						return self.formattedTime(row.created_at)
					},
				
				},
				
				sortable:  ['name', 'status','created_at'],
				
				filterable:  ['name', 'status','created_at'],
				
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

							data.from = 'agent'

							data.client_view_url = data.status ? self.basePath() + '/pages/' + data.slug : 'javascript:;';
							
							data.edit_url = '/page/' + data.id + '/edit';

							data.delete_url = '/page/delete/' + data.id;

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

	.page-name,.page-created,.page-status,.page-action{
		max-width: 250px; word-break: break-all;
	}
	
	#my_pages .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_pages .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>