<template>
	<div id="main-div" class="col-sm-12">
		<alert componentName="dataTableModal"/>

		<faveo-box :title="lang('list_of_approval_workflow')">

            <template #headerMenu>

                <div class="card-tools">
                    <router-link class="btn btn-tool" to="/approval-workflow/create" v-tooltip="{ content: lang('create_approval_workflow'), placement: 'left' }">
                        <span class="glyphicon glyphicon-plus"> </span>
                    </router-link>
                </div>
            </template>

			<div id="apply-workflow-table">
				<data-table v-if="apiUrl !== ''" :url="apiUrl" :dataColumns="columns"  :option="options"></data-table>
			</div>

		</faveo-box>
	</div>
</template>

<script>

import {useStore} from "vuex";
import {computed} from "vue";
import DataTableActions from "../../MiniComponent/DataTableComponents/DataTableActions.vue";


export default {

	name : 'approval-workflow-index',

	description : 'Approval workflow table component',

    setup(){

        const store = useStore()

        return {
            formattedTime : computed(()=>store.getters.formattedTime)
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
		apiUrl:'/api/admin/approval-workflow/',

	}),

	beforeMount(){

		/**
		 * columns required for datatable
		 * @type {Array}
		 */
		this.columns= ['name', 'created_at', 'updated_at', 'action']

		this.options= {
			texts: {
				filter: '',
				limit: ''
			},

      headings: { name: this.trans('name'), created_at: this.trans('created_at'), updated_at: this.trans('updated_at'), action: this.trans('action')},

			columnsClasses : {
				name: "apply-workflow-index-name",
				created_at: "apply-workflow-index-created",
				updated_at: "apply-workflow-index-updated",
				action: "apply-workflow-index-action"
			},
			templates: {
				action: (func,row) =>{
                    return this.h(DataTableActions,{
                        data : row
                    })
                },
				created_at: (h, row) => {
					return this.formattedTime(row.created_at)
				},
				updated_at: (h, row) => {
					return this.formattedTime(row.updated_at)
				},
			},
			sortable:  ['name', 'created_at', 'updated_at'],
			filterable: ['name', 'created_at', 'updated_at'],
			pagination:{chunk:5,nav: 'fixed',edge:true},
			requestAdapter(data) {
				return {
          'sort_by': data.orderBy ? data.orderBy : 'name',
					order: data.ascending ? 'asc' : 'desc',
					search:data.query.trim(),
					page:data.page,
					limit:data.limit,
				}
			},
			responseAdapter({data}) {
				return {
					data: data.data.data.map(data => {
						data.edit_url = '/approval-workflow/' + data.id + '/edit';
						data.delete_url = window.axios.defaults.baseURL + '/api/admin/approval-workflow/' + data.id + '/workflow/';
						return data;
					}),
					count: data.data.total
				}
			},

			orderBy: { column: 'name', ascending: true },
		}
	}
};
</script>

<style type="text/css">
.apply-workflow-index-name, .apply-workflow-index-created, .apply-workflow-index-updated, .apply-workflow-index-action{
	max-width: 250px; word-break: break-all;
}


#apply-workflow-table .VueTables .table-responsive {
	overflow-x: auto;
}

#apply-workflow-table .VueTables .table-responsive > table{
	width : max-content;
	min-width : 100%;
	max-width : max-content;
	overflow: auto !important;
}
</style>
