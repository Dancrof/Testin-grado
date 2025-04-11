<template>
	
	<div class="col-sm-12">
	
		<alert componentName="dataTableModal" />

		<div class="card card-light">
			
			<div class="card-header">
				
				<h3 class="card-title">{{lang(title)}}</h3>

				<div class="card-tools">
						
					<router-link class="btn btn-tool" to="/sla/create" v-tooltip="lang('create_SLA')">

						<span class="glyphicon glyphicon-plus"> </span> 
					</router-link>
						
					<a id="reorder" v-if="showTable && total_records > 1" class="btn btn-tool" href="javascript:;" 
						@click="reorderMethod" v-tooltip="lang('reorder')">

						<span class="fas fa-bars"> </span>
					</a>
				</div>
			</div>

			<div class="card-body" id="sla-table">
				
				<data-table v-if="apiUrl !== '' && showTable" :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="sla-table">
					
				</data-table>
				
				<sla-reorder v-if="!showTable" :onClose="onClose" :url="apiUrl+'?type=sla&meta=true&sort=order&sort_order=asc'" 
					reorder_type="sla">
			
				</sla-reorder>
			</div>
		</div>
	</div>
</template>

<script>

	import { mapGetters } from 'vuex'

	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

    import {useStore} from "vuex";
    import {computed} from "vue";
    import Reorder from "../../Workflow/Reorder.vue";

    export default {
		
		name: "sla-index",

		description: "SLA table component",

        setup() {

            const store = useStore();

            return {

                formattedTime : computed(()=> store.getters.formattedTime)
            }
        },

		data(){

			return {

				columns: [ "name", "status", "order", "created_at", "updated_at", "action"],

				options: {},

				apiUrl: "api/get-enforcer-list/",

				title: "list_of_SLA_plans",

				showTable: true,

				total_records : 0,
			}
		},

		beforeMount() {

			const self = this;

			this.options = {
			
				texts: { filter: "", limit: "" },
	
				headings: {

          name: this.trans('name'),

          status : this.trans('status'),

          order : this.trans('order'),

          created_at: this.trans('created'),

          updated_at: this.trans('updated'),

          action: this.trans('action')

				},

				columnsClasses : {

					name: 'sla-name',

					status : 'sla-status',

					order : 'sla-order',

					updated_at : 'sla-updated',

					created_at : 'sla-created'
				},

				templates: {
				
					action: function(createElement, row) {

                        return self.h(DataTableActions,{

                            data : row
                        })
                    },

					status: function(createElement, row) {
						
						let span = self.h('span', {

                            'class' : row.status ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'

						}, row.status ? 'Active' : 'Inactive');
									
						return self.h('a', {class:'pointer_normal'}, [span]);
					},

					created_at(h, row) {

						return self.formattedTime(row.created_at)
					},

					updated_at(h, row) {
						
						return self.formattedTime(row.updated_at)
					},
				},
				
				sortable: [ "name", "status", "order", "created_at", "updated_at"],

				filterable: ["name", "created_at", "updated_at"],
				
				pagination: { chunk: 5, nav: "scroll" },
				
				requestAdapter(data) {
					
					return {
						
						type: "sla",
						
						sort: data.orderBy ? data.orderBy : "order",
						
						sort_order: data.ascending ? "asc" : "desc",
						
						search: data.query.trim(),
						
						page: data.page,
						
						limit: data.limit
					};
				},

				responseAdapter({ data }) {  

					self.total_records = data.data.total;      
				
					return {
						
						data: data.data.data.map(data => {
							
							data.edit_url = "/sla/" + data.id + '/edit';
							
							data.delete_url = self.basePath() + "/api/delete-enforcer/sla/" + data.id;
							
							return data;
						}),
						
						count: data.data.total
					};
				},

				orderBy: { column: 'order', ascending: true },
			};
		},

		methods: {
			
			reorderMethod() {
				
				this.showTable = false;
				
				this.title = "reorder";
			},
			
			onClose() {
				
				this.showTable = true;
				
				this.title = "list_of_SLA_plans";
			}
		},

		components: {

			"sla-reorder": Reorder
		}
	};
</script>

<style>

	.sla-name,.sla-order,.sla-status,.sla-created,.sla-updated{
		max-width: 250px; word-break: break-all;
	}
	
	#sla-table .VueTables .table-responsive {
		overflow-x: auto;
	}

	#sla-table .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>
