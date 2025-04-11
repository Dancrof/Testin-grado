<template>
		
	<div id="list_of_recur" class="col-sm-12">
		
		<alert componentName="dataTableModal"/>

		<div class="card card-light ">
		
			<div class="card-header">
			
				<h3 class="card-title">{{lang('list_of_recur')}}</h3>

				<div class="card-tools">
					
					<router-link v-if="from == 'admin'" to="/recur/create" class="btn-tool" v-tooltip="{ content: lang('create_recur'), placement: 'left' }">

						<i class="glyphicon glyphicon-plus"> </i>
					</router-link>

					<router-link v-else :to="panel+'/ticket/recur'" class="btn-tool" v-tooltip="lang('create_recur')">
          
		          	<i class="glyphicon glyphicon-plus"> </i>
		        </router-link>
				</div>
			</div>
			
			<div class="card-body" id="my_recurs">

				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="list_of_recur"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

	import {useStore} from "vuex";
	import {computed} from "vue";
	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

	export default {

		name : 'recurring-tickets',

		description : 'Recurring tickets list',

		setup() {

			const store = useStore();

			return {

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},

		props : {

			from : { type : String, default : '' }
		},

		data() {

			return {

				columns: ['name', 'interval', 'start_date', 'end_date', 'action'],

				options: {},

				apiUrl:null,

				panel:null,
			}
		},

		beforeMount(){


			const self= this;

			this.options = {

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},

				headings: {

          name: self.lang('name'),

          interval : self.lang('interval'),

          start_date : self.lang('start_date'),

          end_date : self.lang('end_date'),

          action:self.lang('action')
				},

				columnsClasses : {
          
         	name: 'recur-name', 

					interval : 'recur-interval', 

					start_date : 'recur-start',

					end_date : 'recur-end', 
					
					action : 'recur-action', 
        },
				
				texts: { filter: '', limit: '' },

				templates: {
						
          start_date : function(h,row){
				
				return row.start_date && row.start_date != '0000-00-00 00:00:00' ? self.formattedDate(row.start_date) : '--'
          },

          end_date : function(h,row){

          	return row.end_date && row.end_date != '0000-00-00 00:00:00' ? self.formattedDate(row.end_date) : '--'
          },
					
					action: (f,row)=>{

			  			return self.h(DataTableActions,{ data : row})
					}
				},

				sortable: ['name', 'interval', 'start_date', 'end_date'],

				filterable: ['name', 'interval', 'start_date', 'end_date'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
	      
	        return {
	      
	          'sort-field': data.orderBy ? data.orderBy : 'updated_at',
	      
	          'sort-order': data.ascending ? 'desc' : 'asc',
	      
	          'search-query':data.query.trim(),
	      
	          page:data.page,
	      
	          limit:data.limit,
	        }
	      },

			 	responseAdapter({data}) {
			 		
					return {
					
						data: data.data.data.map(data => {

							data.from = self.panel ? 'agent' : '';
;
							data.edit_url = self.panel ? self.panel + '/recur/' + data.id + '/edit' : '/recur/' + data.id + '/edit';;

							data.delete_url =  self.basePath() + '/api/recur-delete/' + data.id ;

						return data;
					}),
						count: data.data.total
					}
				},

				orderBy: { column: 'updated_at', ascending: true },
			}
		},

		created(){
			this.panel = window.location.pathname.split('/').includes('agent') ? '/agent' : '';
			this.apiUrl = 'api' + this.panel + '/recur-list';
		}
	};
</script>

<style>

	.recur-name,.recur-start,.recur-end,.recur-interval,.recur-action{
		max-width: 250px; word-break: break-all;
	}
	
	#my_recurs .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_recurs .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>