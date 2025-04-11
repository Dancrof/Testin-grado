<template>
  
  <div class="col-sm-12">
  
	  <alert componentName="dataTableModal" />

	  <div class="card card-light">

		  <div class="card-header">
			   
			  <h3 class="card-title">{{lang(title)}}</h3>

			  <div class="card-tools">

				  <a href="javascript:;" class="btn-tool dropdown-toggle" data-bs-toggle="dropdown" v-tooltip="lang('create_workflow')">

					  <i class="glyphicon glyphicon-plus"> </i>
				  </a>

				  <div class="dropdown-menu dropdown-menu-right" role="menu" v-show="showDrop">

					  <span id="workflow-create-button">{{workflowListMounted()}}</span>

					  <router-link id="add-fg-link" class="dropdown-item" to="/workflow/create?page_type=ticket">
						  {{ lang('new_ticket_workflow') }}
					  </router-link>
				  </div>

          <a v-if="showTable && total_records > 1" class="btn btn-tool" href="javascript:;" v-tooltip="lang('reorder')"
            @click="reorderMethod">
            <span class="fas fa-bars"> </span>
          </a>
        </div>
		</div>

    <div class="card-body" id="workflow-index-table">
		  <data-table v-if="apiUrl !== '' && showTable" :url="apiUrl" :dataColumns="columns"  :option="options"></data-table>
		<workflow-reorder v-if="!showTable" :onClose="onClose" :url="apiUrl+'?meta=true&sort=order&sort_order=asc'" 
      reorder_type="workflow">
      
    </workflow-reorder>

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
  name: "workflow-index",

  description: "Workflow table component",

    setup(){

      const store = useStore();

      return {

          formattedTime : computed(()=>store.getters.formattedTime)
      }
    },

  data: () => ({
    /**
     * base url of the application
     * @type {String}
     */
    base: window.axios.defaults.baseURL,

    columns: [],

    options: {},

    /**
     * api url for ajax calls
     * @type {String}
     */
    apiUrl: "api/get-enforcer-list/",

    title: "list_of_workflows",

    showTable: true,

    total_records : 0,

	  showDrop : false
  }),

  beforeMount() {

	  setTimeout(()=>{

		  this.showDrop = true;
	  },1000);

    const self = this;
    /**
     * columns required for datatable
     * @type {Array}
     */
    this.columns = [
        "name",
        "status",
        "order",
	    "category_type",
        "created_at",
        "updated_at",
        "action"
    ];

    this.options = {
      
      texts: {
        filter: "",
        limit: ""
      },
      headings: {
        name: this.trans("name"),
        status: this.trans("status"),
        order: this.trans("order"),
        category_type: this.trans("category_type"),
        created_at: this.trans("created"),
        updated_at: this.trans("updated"),
        action: this.trans("action")
      },

	  columnsClasses : {
		  name: "workflow-index-name",
		  status: "workflow-index-status",
		  order: "workflow-index-order",
		  category_type: "workflow-category-type",
		  created_at: "workflow-index-created",
		  updated_at: "workflow-index-updated",
		  action: "workflow-index-action"
	  },

      templates: {
        
        action: function(func,row){

            return self.h(DataTableActions,{
                data : row
            })
        },

        status: function(createElement, row) {
            
          let span = self.h('span', {
            
            'class' : row.status ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'

          }, row.status ? 'Active' : 'Inactive');
                  
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
      sortable: [
        "name",
        "status",
        "order",
        "created_at",
        "updated_at",
	      "category_type"
      ],
      filterable: ["name", "created_at", "updated_at"],
      pagination: { chunk: 5, nav: "scroll" },
      requestAdapter(data) {
        return {
          type: "workflow",
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
			  
			  let basePageUrl = data.category_type != 'ticket' ? "/service-desk/workflow/" : "/workflow/" ;
			  
            data.edit_url =  basePageUrl + data.id + "/edit?page_type=" + data.category_type;
            data.delete_url =
              window.axios.defaults.baseURL +
              "/api/delete-enforcer/workflow/" +
              data.id;
            return data;
          }),
          count: data.data.total
        };
      },

	    orderBy: { column: 'order', ascending: true },
    };
  },

  methods: {

	  workflowListMounted() {

		  window.emitter.emit('create-workflow-button-mounted');
	  },

    reorderMethod() {
      this.showTable = false;
      this.title = "reorder";
    },
    onClose() {
      this.showTable = true;
      this.title = "list_of_workflows";
    }
  },

  components: {
    "workflow-reorder": Reorder,
  }
};
</script>

<style type="text/css">

.workflow-index-name, .workflow-category-type, .workflow-index-created, .workflow-index-updated, .workflow-index-status, .workflow-index-action, .workflow-index-order {
    max-width: 250px; word-break: break-all;
  }
  
  #workflow-index-table .VueTables .table-responsive {
    overflow-x: auto;
  }

  #workflow-index-table .VueTables .table-responsive > table{
    width : max-content;
    min-width : 100%;
    max-width : max-content;
    overflow: auto !important;
  }

</style>
