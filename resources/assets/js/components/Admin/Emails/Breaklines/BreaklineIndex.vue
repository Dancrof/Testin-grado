<template>

	<div class="col-sm-12">

		<alert componentName="dataTableModal"></alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 id="breakline-index" class="card-title">

          {{ trans('list_of_breaklines') }}

				</h3>

				<div class="card-tools">

					<router-link class="btn btn-tool" to="/breakline/create" v-tooltip="trans('create_breakline')">

						<i class="glyphicon glyphicon-plus"></i>
          			</router-link>

					<a v-if="showTable && total_records > 1" class="btn btn-tool" href="javascript:;"
					   	@click="reorderMethod" v-tooltip="lang('reorder')">

						<span class="fas fa-bars"> </span>
					</a>
        		</div>
      		</div>

      		<div class="card-body" id="breakline_index">

				<data-table v-if="apiUrl !== '' && showTable" :url="apiUrl" :dataColumns="columns" :option="options"
          			scroll_to="breakline-index">

				</data-table>

        		<breakline-reorder v-if="!showTable" :onClose="onClose" :url="apiUrl+'?type=breakline&meta=true&sort=display_order&sort_order=asc'" reorder_type="breakline">

				</breakline-reorder>
      		</div>
    	</div>
  	</div>
</template>

<script>

    import BreaklineReorder from "../Breaklines/Reorder.vue"

    import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue"

	export default {

		name: "breakline-index",

		description: "Breakline table component",

		data() {

			return {

				columns: ["breakline", "order", "is_active", "actions"],

				options: {},

				apiUrl: "/api/breakline-list",

				total_records : 0,

				showTable: true,
    		};
  		},

  		beforeMount() {

			const self = this;

    		this.options = {

				sortIcon: {
        			base: "glyphicon",
        			down: "glyphicon-chevron-up",
        			up: "glyphicon-chevron-down",
      			},

      			columnsClasses: {
        			breakline: "name-breakline",
					display_order: "displayOrder-breakline",
					is_active: "isActive-breakline",
					actions: "breakline-action",
      			},

          headings: {

            breakline: this.lang("breakline"),
            display_order: "Display Order",
            is_active: this.lang("status"),
            actions: this.lang("action"),
            order: this.lang("display_order"),

          },

      			texts: { filter: "", limit: "" },

      			templates: {

					is_active: function (createElement, row) {

						let span = self.h('span', {

                            'class' : row.is_active ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'

                        }, row.is_active ? 'Active' : 'Inactive');

						return self.h('a',{class:'pointer_normal'},[span]);
					},

        			breakline: function (createElement, row) {

						let style = self.h("span", {

                            style: "min-width : 100%;width: min-content;overflow: hidden; display: inline-block; white-space: word-wrap;",

						}, [row.breakline]);

						return style;
        			},

        			actions: function (createElement,row) {

                        return self.h(DataTableActions,{

                            data : row
                        })
                    },
      			},

      			filterable: ["breakline"],

				sortable: ["breakline", "display_order", "is_active"],

				pagination: { chunk: 5, nav: "fixed", edge: true },

				requestAdapter(data) {

					return {

						"sort-field": data.orderBy,

						"sort-order": data.ascending ? "asc" : "desc",

          				"search-query": data.query.trim(),

						page: data.page,

						limit: data.limit,
        			};
      			},

      			responseAdapter({ data }) {

					self.total_records = data.message.total;

        			return {

						data: data.message.breakline.map((data) => {

							data.edit_url = "/breakline/" + data.id + "/edit";

							data.delete_url = self.basePath() + "/api/delete-breakline/" + data.id;

							return data;
          				}),

						count: data.message.total,
        			};
      			},
    		};
  		},

  		methods : {

			reorderMethod() {

				this.showTable = false;

				this.title = "reorder";
			},

          	onClose() {

				this.showTable = true;

				this.title = "list_of_breaklines";
			}
  		},

  		components: {

			BreaklineReorder,
		},
	};
</script>

<style  type="text/css">
	.breakline-action,
	.displayOrder-breakline,
	.isActive-breakline {
	  max-width: 250px;
	  word-break: break-all;
	}
	#breakline_index .VueTables .table-responsive {
	  overflow-x: auto;
	}

	#breakline_index .VueTables .table-responsive > table {
	  width: max-content;
	  min-width: 100%;
	  max-width: max-content;
	  overflow: auto !important;
	}
</style>
