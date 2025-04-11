<template>

  <div class="col-sm-12">

    <!-- Alert component -->
    <alert componentName="dataTableModal" />

    <div class="card card-light">

      <!-- Card header -->
      <div class="card-header">

        <h3 class="card-title">{{lang(title)}}</h3>

        <!-- Card tools section -->
        <div class="card-tools">

          <!-- Router link for creating a trigger -->
            <router-link class="btn btn-tool" v-tooltip="lang('create_trigger')" to="/trigger/create?page_type=ticket">
              <span class="glyphicon glyphicon-plus"> </span>
            </router-link>

          <!-- Button for reordering if conditions met -->
          <a v-if="showTable && total_records > 1" class="btn btn-tool" href="javascript:;" v-tooltip="lang('reorder')"
             @click="reorderMethod">
            <span class="fas fa-bars"> </span>
          </a>
        </div>
      </div>

      <!-- Card body -->
      <div class="card-body" id="trigger-index-table">

        <!-- Data table component -->
        <data-table v-if="apiUrl !== '' && showTable" :url="apiUrl" :dataColumns="columns"  :option="options"></data-table>

        <!-- Trigger reorder component if not showing table -->
        <TriggerReorder v-if="!showTable" :onClose="onClose" :url="apiUrl+'?type=trigger&meta=true&sort=order&sort_order=asc'"
                          reorder_type="trigger">

        </TriggerReorder>

      </div>
    </div>
  </div>
</template>

<script setup>

import {useStore} from "vuex";
import {computed, ref, onBeforeMount, h} from "vue";
import DataTableActions from "../../MiniComponent/DataTableComponents/DataTableActions.vue";
import TriggerReorder from "./Reorder.vue";
import {lang} from '../../../helpers/extraLogics';
import DataTableStatus from "../../MiniComponent/DataTableComponents/DataTableStatus.vue";

    const store = useStore();

    const formattedTime = computed(()=>store.getters.formattedTime);

    const columns = ref([ "name", "status", "order", "category_type", "created_at", "updated_at", "action"]);

    const apiUrl = "api/get-enforcer-list/";

    const base = window.axios.defaults.baseURL;

    const options = ref({});

    const title = ref("list_of_triggers");

    const showTable = ref(true);

    const total_records = ref(0);

    // Function to render actions template
    const renderActions = (row) => h(DataTableActions, { data: row });

    // Function to render status template
    const statusTemplate = (row) =>h(DataTableStatus, {data: row});


    onBeforeMount((self )=> {

      // Set up options for data table
      options.value = {

        texts: {
          filter: "",
          limit: ""
        },

        // Headings for table columns
        headings: {
          name: lang("name"),
          status: lang("status"),
          order: lang("order"),
          category_type: lang("category_type"),
          created_at: lang("created"),
          updated_at: lang("updated"),
          action: lang("action")
        },

        // CSS classes for table columns
        columnsClasses : {
          name: "trigger-index-name",
          status: "trigger-index-status",
          order: "trigger-index-order",
          category_type: "trigger-category-type",
          created_at: "trigger-index-created",
          updated_at: "trigger-index-updated",
          action: "trigger-index-action"
        },

        // Templates for rendering custom components
        templates: {

          // Render actions template
          action(h,row){
            return renderActions(row);
          },

          // Render status template
          status(h, row) {
            return statusTemplate(row);
          },

          // Render category type template
          category_type(h, row) {
            return row.category_type.charAt(0).toUpperCase() + row.category_type.slice(1);
          },

          // Format created_at time
          created_at(h, row) {
            return formattedTime.value(row.created_at)
          },

          // Format updated_at time
          updated_at(h, row) {
            return formattedTime.value(row.updated_at)
          },
        },

        // sortable columns
        sortable: ["name", "status", "order", "created_at", "updated_at", "category_type"],

        // filterable columns
        filterable: ["name", "created_at", "updated_at"],

        // Pagination settings
        pagination: { chunk: 5, nav: "scroll" },

        // Adapter for request data
        requestAdapter(data) {
          return {
            type: "trigger",
            'sort': data.orderBy ? data.orderBy : "order",
            'sort_order': data.ascending ? "asc" : "desc",
            'search': data.query,
            page: data.page,
            limit: data.limit
          };
        },

        // Adapter for response data
        responseAdapter({ data }) {

          total_records.value = data.data.total;

          return {
            data: (data.data.data).map((data) => {

              let basePageUrl = "/trigger/" ;

              data.edit_url =  basePageUrl + data.id + "/edit?page_type=" + data.category_type;
              data.delete_url = window.axios.defaults.baseURL + "/api/delete-enforcer/trigger/" + data.id;
              return data;
            }),
            count: data.data.total,
          };
        },

	      orderBy: { column: 'order', ascending: true },
      };
    });

    // Function to switch to reorder view
    const reorderMethod = () => {
      showTable.value = false;
      title.value = "reorder";
    };

    // Function to close reorder view and return to table view
    const onClose = () => {
      showTable.value = true;
      title.value = "list_of_triggers";
    };

</script>

<style type="text/css">

.trigger-index-name, .trigger-category-type, .trigger-index-created, .trigger-index-updated, .trigger-index-status, .trigger-index-action, .trigger-index-order {
  max-width: 250px; word-break: break-all;
}

#trigger-index-table .VueTables .table-responsive {
  overflow-x: auto;
}

#trigger-index-table .VueTables .table-responsive > table{
  width : max-content;
  min-width : 100%;
  max-width : max-content;
  overflow: auto !important;
}

</style>
