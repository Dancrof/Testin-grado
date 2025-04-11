<template>
	<div class="col-sm-12">
		<alert componentName="dataTableModal"/>
	<div class="card card-light ">
		<div class="card-header">
			<h3 class="card-title">{{lang('reports')}}</h3>
		</div>
		
		<div class="card-body">
			
			<data-table :url="apiUrl" :dataColumns="columns"  :option="options"></data-table>
		</div>
	</div>
</div>
</template>

<script>

	import DataTableActions from "../../MiniComponent/DataTableComponents/DataTableActions.vue";

	import {useStore} from "vuex";
	import {computed} from "vue";
	import DataTableUser from "../../MiniComponent/DataTableComponents/DataTableUser.vue";
	export default {
		
		name : 'report-exports',

		description : 'Exports table component',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime)
			}
		},

		data(){

			let url_params = new URLSearchParams(window.location.search);

		    const self = this;

		    return {

			/**
			* base url of the application
			* @type {String}
			*/
			base:window.axios.defaults.baseURL,

			/**
			* columns required for datatable
			* @type {Array}
			*/
			columns: ['file', 'ext', 'type', 'user', 'created_at', 'action'],
				
			options: {
				texts : { filter : '', limit : ''},
        	headings: {
            file: this.trans('filename'), ext: this.trans('format'), type: this.trans('type'), user : this.trans('user'), created_at: this.trans('created_at'), action: this.trans('action')          },
				templates: {
					action: (f,row)=>{
						return self.h(DataTableActions,{data : row})
					},
					user : (f,row)=>{
						return self.h(DataTableUser,{data : row})
					},
					created_at : (h, row) => {
						return self.formattedTime(row.created_at)
					},
				    ext(h,row){
				    	return row.ext.toUpperCase() ;
				    }
				},
				sortable:  ['file', 'ext', 'type', 'created_at'],
				filterable:  ['file', 'ext', 'type', 'created_at'],
				pagination:{chunk:5,nav: 'scroll'},
				requestAdapter(data) {
	        return {
	          sort_by: data.orderBy ? data.orderBy : 'created_at',
	          order: data.ascending ? 'desc' : 'asc',
	          search:data.query.trim(),
	          page:data.page,
	          per_page:data.limit,
	          type : url_params.get("type"),
	          'user-filter' : url_params.get("user-filter")
	        }
	      },
			 	responseAdapter({data}) {
					return {
						data: data.data.data.map(data => {
						
						data.delete_url = window.axios.defaults.baseURL + '/report/api/agent/export/delete/' + data.id;

						data.download_check_url = '/report/api/agent/export/download/' + data.hash;

            data.deleteMessage = 'are_you_sure_you_want_to_delete_this_report';

						return data;
					}),
						count: data.data.total
					}
				},
				orderBy: { column: 'created_at', ascending: true },
			},
			
			/**
			 * api url for ajax calls
			 * @type {String}
			 */
			apiUrl:'/report/api/agent/exports/',

				
		}
		},
	};
</script>

<style type="text/css" scoped>
	.box-header h3{
		font-family: Source Sans Pro !important
	}
	.box.box-primary {
		padding: 0px !important;
	}
	.right{
		float: right;
	}
</style>