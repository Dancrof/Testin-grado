<template>
	
	<div class="col-sm-12">
		
		<alert componentName="dataTableModal"/>

		<div class="card card-light">
		
			<div class="card-header">

				<h3 class="card-title">{{lang('list_of_business_hours')}}</h3>
				
				<div class="card-tools">

					<router-link class="btn btn-tool" to="/business-hour/create" v-tooltip="lang('create_business_hour')">

						<i class="glyphicon glyphicon-plus"> </i>
					</router-link>
				</div>
			</div>

			<div class="card-body">
			
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

	import DataTableStatus from "../../../MiniComponent/DataTableComponents/DataTableStatus.vue";
    import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

    export default {

		name : 'business-hours-index',

		description : 'Business hours table component',

		data() {

            return {

                /**
                 * columns required for datatable
                 * @type {Array}
                 */
                columns: ['name', 'status', 'action'],

                options: {
	                sortIcon: {
		                base: "glyphicon",
		                down: "glyphicon-chevron-up",
		                up: "glyphicon-chevron-down",
	                },
                    texts: {
                        filter: '',
                        limit: ''
                    },
                    templates: {
                        status: function(func,row){

                            return this.h(DataTableStatus,{
                                data : row
                            })
                        },
                        action: function(func,row){

                            return this.h(DataTableActions,{
                                data : row
                            })
                        }
                    },
                  headings: { name: this.trans('name'), status: this.trans('status'), action: this.trans('action')},

                  sortable:  ['name', 'status'],
                    filterable:  ['name', 'status'],
                    pagination:{chunk:5,nav: 'fixed',edge:true},
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

                                data.edit_url = '/business-hour/' + data.id + '/edit';

                                data.delete_url = window.axios.defaults.baseURL + '/sla/business-hours/delete/' + data.id;

                                data.active = (data.active == '1') ? 'active' : 'inactive';

                                return data;
                            }),
                            count: data.message.total
                        }
                    },

	                orderBy: { column: 'id', ascending: true },
                },

                /**
                 * api url for ajax calls
                 * @type {String}
                 */
                apiUrl:'/sla/business-hours/getindex/',

            }
    }
	};
</script>
