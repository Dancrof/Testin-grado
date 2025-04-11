<template>

	<div class="col-sm-12">

		<alert componentName="dataTableModal"/>

		<div class="card card-light worktime-type-table">

			<div class="card-header">

				<h3 id="worktime-type-list" class="card-title">{{trans('list_of_worktime_types')}}</h3>

				<div class="card-tools">

					<router-link class="btn btn-tool" to="/time-track/worktime-type/create" v-tooltip="trans('add-worktime-type')">

						<span class="glyphicon glyphicon-plus"> </span>
					</router-link>
				</div>
			</div>

			<div class="card-body" id="worktime-type-table">

				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="license-type-list">

				</data-table>
			</div>
		</div>
	</div>
</template>

<script>

    import DataTableActions
		from "../../../../../../resources/assets/js/components/MiniComponent/DataTableComponents/DataTableActions.vue";

    import { useStore } from 'vuex';
	import {computed} from "vue";

    export default {

        name : 'worktime-type-list',

        description : 'Worktime type lists table component',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime)
			}
		},

        data: () => ({

            columns: ['name', 'created_at', 'updated_at', 'action'],

            options: {},

            apiUrl:'/api/worktime-type-list?meta=1',
        }),

        beforeMount() {

            const self = this;

            this.options = {

                sortIcon: {

                    base : 'glyphicon',

                    up: 'glyphicon-chevron-down',

                    down: 'glyphicon-chevron-up'
                },

                texts: { filter: '', limit: '' },

                columnsClasses : {

                    name : 'worktime-type-name',

                    created_at: 'worktime-type-created',

                    updated_at : 'worktime-type-updated'
                },

                templates: {

                    created_at(h,row){

                        return self.formattedTime(row.created_at)
                    },

                    updated_at(h,row){

                        return self.formattedTime(row.updated_at)
                    },

                    action: (f,row)=>{

						return self.h(DataTableActions, { data : row })
					}
                },

                sortable:  ['name', 'created_at', 'updated_at'],

                filterable:  ['name', 'created_at', 'updated_at'],

                pagination:{chunk:5,nav: 'fixed',edge:true},

                requestAdapter(data) {

                    return {

                        'sort-field' : data.orderBy ? data.orderBy : 'id',

                        'sort-order' : data.ascending ? 'desc' : 'asc',

                        'search-query' : data.query.trim(),

                        page : data.page,

                        limit : data.limit,
                    }
                },

                responseAdapter({data}) {

                    return {

                        data: data.data.data.map(data => {

                            data.edit_url = '/time-track/worktime-type/' + data.id + '/edit';

                            data.delete_url = self.basePath() + '/api/worktime-type/' + data.id;

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

<style type="text/css">

	.worktime-type-name {
		width:25%;
		word-break: break-all;
	}

	.worktime-type-created{
		width:25%;
		word-break: break-all;
	}

	.worktime-type-updated{
		width:25%;
		word-break: break-all;
	}
</style>