<template>
  <div class="col-sm-12" id="main-div">
  
    <alert componentName="dataTableModal" />
  
    <div class="card card-light" id="box-primary">
  
      <div class="card-header">

        <h3 class="card-title" id="box-title-1"> {{ lang('form_group_list') }} </h3>

        <div class="card-tools">

          <a href="javascript:;" class="btn-tool dropdown-toggle" data-bs-toggle="dropdown" v-tooltip="lang('add_fields')">
        
              <i class="glyphicon glyphicon-plus"> </i>
            </a>

            <div class="dropdown-menu dropdown-menu-right" role="menu" v-show="showDrop">
              
              <span id="form-group-create-button">{{formGroupListMounted()}}</span>

              <router-link id="add-fg-link" class="dropdown-item" to="/form-group/create">
                {{ lang('new_ticket_form_group') }}
              </router-link>
            </div>
        </div>
      </div>
      <div class="card-body">
        <data-table url="api/form-group-list" :dataColumns="columns" :option="options"></data-table>
      </div>
    </div>
  </div>
</template>

<script>

import {computed} from "vue";
import {useStore} from "vuex";
import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

export default {
  name: "form-group-list",
  description: "List down the form groups",

    setup() {

      const store = useStore()

        return {

          formattedTime : computed( ()=> store.getters.formattedTime )
        }
    },

  data: () => ({

    /**
     * columns required for datatable
     * @type {Array}
     */
    columns: ["name", "created_at", "group_type", "action"],

    options: {},

    showDrop : false
    
  }),

  beforeMount() {

    setTimeout(()=>{

      this.showDrop = true;
    },1000);
    
    let that = this;

    this.options = {
      headings: {
        name: this.trans("name"),
        created_at: this.trans("creation-date"),
        group_type: this.trans("form_group_type"),
        action: this.trans("action")
      },

      texts: {
        filter: "",
        limit: "",
        filterPlaceholder: "Search"
      },

      templates: {
        action: function(func,row) {
           return that.h(DataTableActions,{
                data : row
            })
        }
      },

      sortable: ["name", "created_at", "group_type"],
      filterable: ["name", "created_at", "group_type"],
      pagination: {
        chunk: 5,
        nav: "fixed",
        edge: true
      },

      requestAdapter(data) {
        return {
          "sort-field": data.orderBy ? data.orderBy : "created_at",
          "sort-order": data.ascending ? "asc" : "desc",
          "search-query": data.query,
          page: data.page,
          limit: data.limit
        };
      },

      responseAdapter({ data }) {

        return {
          data: data.data.data.map(data => {

            data.edit_url = data.edit_url;

            data.delete_url =
              that.basePath() + '/api/form-group/' + data.id;

            data.created_at = that.formattedTime(data.created_at);

            return data;
          }),
          count: data.data.total
        };
      }
    }
  },

  methods : {

    formGroupListMounted() {

      window.emitter.emit('create-form-group-button-mounted');
    }
  }
};
</script>
