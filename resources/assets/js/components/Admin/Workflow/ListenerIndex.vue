<template>

	<div class="col-sm-12">

		<alert componentName="dataTableModal" />

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{lang(title)}}</h3>

				<div class="card-tools">
					
					<a href="javascript:;" class="btn-tool dropdown-toggle" data-bs-toggle="dropdown" v-tooltip="lang('create_listener')">
						
						<i class="glyphicon glyphicon-plus"> </i>
					</a>
					
					<div class="dropdown-menu dropdown-menu-right" role="menu" v-show="showDrop">
						
						<span id="listener-create-button">{{listenerListMounted()}}</span>
						
						<router-link id="create" class="dropdown-item" to="/listener/create?page_type=ticket">
							{{ lang('new_ticket_listener') }}
						</router-link>
					</div>
					
					<a v-if="showTable && total_records > 1" class="btn btn-tool" href="javascript:;" @click="reorderMethod"
							v-tooltip="lang('reorder')">
						<span class="fas fa-bars"> </span>
					</a>
				</div>
			</div>

			<div class="card-body" id="listener-index-table">
				<data-table v-if="apiUrl !== '' && showTable" :url="apiUrl" :dataColumns="columns"  :option="options"></data-table>

				<listener-reorder v-if="!showTable" :onClose="onClose" :url="apiUrl+'?type=listener&meta=true&sort=order&sort_order=asc'" reorder_type="listener">

				</listener-reorder>
			</div>
		</div>
	</div>
</template>

<script>

    import {useStore} from "vuex";
    import {computed} from "vue";
    import DataTableActions from "../../MiniComponent/DataTableComponents/DataTableActions.vue";
    import Reorder from "./Reorder.vue";

	export default {

		name : 'listener-index',

		description : 'Listener table component',

        setup() {

            const store = useStore();

            return {

                formattedTime : computed(()=> store.getters.formattedTime)
            }
        },

		data: () => ({
			/**
			* base url of the application
			* @type {String}
			*/
			base:window.axios.defaults.baseURL,

			columns:[],

			options:{},

			/**
			 * api url for ajax calls
			 * @type {String}
			 */
			apiUrl:'api/get-enforcer-list/',

			total_records : 0,

			showTable: true,
			
			showDrop : false,

      title: 'list_of_listeners'

		}),

		beforeMount(){
			
			setTimeout(()=>{
				
				this.showDrop = true;
			},1000);

			const self = this;

			/**
			* columns required for datatable
			* @type {Array}
			*/
			this.columns= ['name', 'status', 'order', 'category_type', 'created_at', 'updated_at', 'action']

			this.options= {

				texts: {  filter: '', limit: ''},

        headings: {
          name: this.trans('name'), status: this.trans('status'),
          order: this.trans('order'), created_at: this.trans('created'),
          category_type: this.trans('category_type'),
          updated_at: this.trans('updated'), action: this.trans('action')
        },

        // CSS classes for table columns
        columnsClasses : {
          name: "listener-index-name",
          status: "listener-index-status",
          order: "listener-index-order",
          category_type: "listener-category-type",
          created_at: "listener-index-created",
          updated_at: "listener-index-updated",
          action: "listener-index-action"
        },

				templates: {

					action: (f,row) => {

                        return self.h(DataTableActions,{
                            data : row
                        })
                    },

					status: function(createElement, row) {

			            let span = self.h('span', {

			                'class' : row.status ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'

			            }, row.status ? this.trans('active') : this.trans('inactive'));

			            return self.h('a', {
                        class:'pointer_normal'
			            }, [span]);
			        },
					
					category_type(h, row) {
						return row.category_type.charAt(0).toUpperCase() + row.category_type.slice(1);
					},

					created_at(h, row) {
						return self.formattedTime(row.created_at)
			        },
			        updated_at(h, row) {
						return self.formattedTime(row.updated_at)
					},
				},

				sortable:  ['name', 'status', 'order', 'rules', 'target','created_at', 'updated_at', 'category_type'],

				filterable: ['name', 'created_at', 'updated_at'],

				pagination:{chunk:5,nav: 'scroll'},

				requestAdapter(data) {
			        return {
			        	type : 'listener',
			          sort: data.orderBy ? data.orderBy : 'order',
			          sort_order: data.ascending ? 'asc' : 'desc',
			          search:data.query.trim(),
			          page:data.page,
			          limit:data.limit,
			        }
			    },

			 	responseAdapter({data}) {

			 		self.total_records = data.data.total;

					return {
						data: data.data.data.map(data => {
							
							let basePageUrl = data.category_type != 'ticket' ? "/service-desk/listener/" : "/listener/" ;
							
							data.edit_url =  basePageUrl + data.id + "/edit?page_type=" + data.category_type;
							
						data.delete_url = window.axios.defaults.baseURL + '/api/delete-enforcer/listener/'+ data.id;
						return data;
					}),
						count: data.data.total
					}
				},

				orderBy: { column: 'order', ascending: true },
			}
		},

		methods :{

			reorderMethod() {
	      this.showTable = false;
	      this.title = "reorder";
	    },

	    onClose() {
	      this.showTable = true;
	      this.title = "list_of_listeners";
	    },
			
			listenerListMounted() {
				
				window.emitter.emit('create-listener-button-mounted');
			},
		
		},

		components:{

			"listener-reorder": Reorder
		}
	};
</script>

<style type="text/css">

.listener-index-name, .listener-category-type, .listener-index-created, .listener-index-updated, .listener-index-status, .listener-index-action, .listener-index-order {
  max-width: 250px; word-break: break-all;
}

#listener-index-table .VueTables .table-responsive {
  overflow-x: auto;
}

#listener-index-table .VueTables .table-responsive > table{
  width : max-content;
  min-width : 100%;
  max-width : max-content;
  overflow: auto !important;
}

</style>