<template>

  <!-- Display a loader while the data is being fetched -->
  <div v-if="loading">

    <custom-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
  </div>

  <!-- Container for the plugins list -->
	<div class="col-sm-12">

    <!-- Alert component for displaying messages -->
		<alert componentName="dataTableModal"/>

		<div class="card card-light" id="plugins-list">

			<div class="card-header">

        <!-- title -->
				<h3 class="card-title">
					{{ lang('plugins-list') }}
				</h3>

        <div class="card-tools">
          <button class="btn btn-tool" @click="checkAllUpdate()" v-tooltip="lang('check_available_plugin_update')"><i class="fas fa-refresh pe-1"></i></button>
        </div>

      </div> <!--header-->

			<div class="card-body" id="plugins_list">

        <!-- Section for the data table -->
        <section>

          <!-- Button for bulk update of plugins -->
          <button v-if="action" ref="buttonToMove" type="button" class="btn btn-default ms-2" v-tooltip="lang('update_all_plugins')" @click="bulkUpdate()">
            <i class="fas fa-circle-up text-muted"></i>
          </button>

          <!-- Data table for displaying the plugins list -->
          <data-table :url="apiUrl" :dataColumns="columns" :tickets="selectPlugin" :show_pagination="show_pagination" :option="options" scroll_to ="plugins-list"></data-table>
        </section>

      </div> <!--card-body-->
		</div> <!--card-->
	</div>
</template>


<script>

import PluginActions from "./PluginActions.vue";
import PluginsName from "./PluginsName.vue";
import {errorHandler, successHandler} from "../../../helpers/responseHandler";
import axios from "axios";

export default {

  // Defining props for the component
  props:{
    whiteLabel : { type : Boolean, default : false },
  },

  // Registering child components
  components: {PluginActions, PluginsName },

  // Defining data properties for the component
	data() {

		return {

			apiUrl:'/getplugin',

			columns: ['id','name', 'description', 'activate'],

			options: {

        headings: {id : this.trans('id'), name: this.trans('plugin'), description : this.trans('description'), activate: this.trans('action'),},

				columnsClasses : {

          id : 'id',

					name: 'name',

					description: 'description',

					activate: 'activate'

				},
				
				perPage:25,

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},
				
				texts: { filter: '', limit: '' },

				sortable:  ['display_name','version'],
				
				filterable:  ['display_name'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},

				templates : {

           activate: function(createElement, row) {

               return this.h(PluginActions, {
                   data: row,
               })
           },

           name: (createElement, row) => {

             return this.h(PluginsName, {
                 data: row, from: 'name'
             })
					},

          description: (createElement, row) => {

            return this.h(PluginsName, {
              data: row, whiteLabel: this.whiteLabel, from: 'description'
            })
          },
				},
				
				requestAdapter(data) {
					return {
						
						'sort_field' : data.orderBy ? data.orderBy : 'status',
						
						'sort_order' : data.ascending ? 'desc' : 'asc',
						
						'search_query' : data.query.trim(),

						limit : data.limit,

					}
				},

				responseAdapter({data}) {
					return {

						data: data.data.plugin,
						count: data.data.total
					}
				},

				orderBy: { column: 'status', ascending: true },
			},

      plugin_action: ['update'],

      selectedAction:'update',

      selectedPlugin:[],

      action: false,

      loading: false,

      pluginsDetails: [],

      show_pagination: true,
		}
	},

  methods: {

    // Handle's plugin selection
    selectPlugin(data) {

      this.selectedPlugin = data
    },

    // Handle's bulk update of plugins
    bulkUpdate(){

      this.loading = true;

      axios.post('plugin/all/update', {plugin: this.selectedPlugin})
          .then((res) => {
            this.loading = false;
            successHandler(res,'dataTableModal');
            setTimeout(()=>{
              window.location.reload();
            },10);
          })
          .catch((err) => {
            this.loading = false;
            errorHandler(err,'dataTableModal');
          })
    },

    // Select and Deselect all plugins
    toggleSelectAll(){

      this.selectAll = !this.selectAll;

      this.selectAll ? this.selectedPlugin = this.pluginsDetails.map(plugin => plugin.path) : this.selectedPlugin = []
    },

    checkAllUpdate(){

      this.loading = true;

      axios.post('/plugin/all/check/update').then(res=>{

        this.loading = false;

        successHandler(res,'dataTableModal');
        window.emitter.emit('refreshData');
      }).catch(err=>{

        errorHandler(err,'dataTableModal');

        this.loading = false;
      });
    }

  },

  watch: {

    // Watch for changes in the selectedPlugin to display the update button
    selectedPlugin(newVal, oldVal) {

      this.action = this.selectedPlugin.length !== 0;

      this.$nextTick(() => {
        // Selects the vueTable_limit button
        let vueTableLimitButton = document.querySelector('#plugins-list .VueTables .VueTables__limit');

        // Selects the button want to move
        let buttonToMove = this.$refs.buttonToMove;

        // Check if both elements exist and the button is not already in the correct position
        if (vueTableLimitButton && buttonToMove && vueTableLimitButton.nextSibling !== buttonToMove) {
          // Insert the button after the vueTable_limit button
          vueTableLimitButton.parentNode.insertBefore(buttonToMove, vueTableLimitButton.nextSibling);
        }
      });

    }
  },

};
</script>

<style>

	.id,.name,.description,.website,.version,.author{ max-width: 250px; word-break: break-word;}

	#plugins_list .VueTables .table-responsive {
		overflow-x: auto;
	}

  #plugins_list .id{
    width: 60px;
  }


  #plugins_list .name{
    width: 400px;
  }


  #plugins_list .activate{
    width: 300px;
  }

	#plugins_list .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}

</style>