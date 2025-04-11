<template>
		
	<div id="canned_response" class="col-sm-12">
		
		<alert componentName="dataTableModal"/>

		<div class="card card-light ">
		
			<div class="card-header">
			
				<h3 class="card-title">{{lang('canned_response')}}</h3>

				<div class="card-tools">
					
					<router-link to="/canned/create" class="btn-tool" v-tooltip="lang('create_canned_response')">
          
          			<i class="glyphicon glyphicon-plus"></i>
        			</router-link>
				</div>
			</div>
			
			<div class="card-body" id="my_canned">
			
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" :componentTitle="componentName" scroll_to="canned_response"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

	import {useStore} from 'vuex';

	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

	import {computed} from "vue";
  import auth from "../../../../../store/modules/auth";
  import {RouterLink} from "vue-router";
  import PermissionDenied from "../../../Common/PermissionDenied.vue";
	export default {

		name : 'canned-list',

		description : 'Canned response list',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},

		props : {

			auth : { type : Object, default : ()=> {} }
		},

		data() {

			return {

				columns: ['title', 'created_by', 'created_at','updated_by', 'updated_at', 'action'],

				options: {},

				apiUrl:'api/canned/list',

        componentName: 'canned-response-index'
			}
		},

		beforeMount(){

			const self= this;

			this.options = {

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},

				headings: {

          title: this.trans('name'),

          created_at : this.trans('created_at'),

          updated_at : this.trans('updated_at'),

          created_by : this.trans('created_by'),

          updated_by : this.trans('updated_by'),

          action: this.trans('action')
				},

				columnsClasses : {

         	title: 'canned-name',

          created_by : 'canned-author',

          created_at : 'canned-created',

          updated_by : 'canned-update',

					updated_at : 'canned-updated', 

					action : 'canned-action'
        },
				
				texts: { filter: '', limit: '' },

				templates: {

          created_by: function(createElement, row) {
            const isAdmin = self.auth.user_data.role === "admin";
            const isAuthor = self.auth.user_data.id === row.user_id;
            if(isAdmin || isAuthor) {
              return row.created_by ? self.h(RouterLink, {to: '/user/' + row.user_id}, row.created_by) : "--";
            }else {
              return row.created_by ? self.h(PermissionDenied, {
                  name: row.created_by,
                  tooltipContent: self.trans('access_denied_now')
              }) : "--";}
          },

          updated_by: function(h, row) {
              const isAdmin = self.auth.user_data.role === "admin";
              const isUpdater = self.auth.user_data.id === row.updated_by_id;
              if(isAdmin || isUpdater) {
                return row.updated_by ? self.h(RouterLink, {to: '/user/' + row.updated_by_id}, row.updated_by) : "--";
              }else{
                return row.updated_by ? self.h(PermissionDenied, {
                  name: row.updated_by,
                    tooltipContent: self.trans('access_denied_now')
                }) : "--";}
          },

          updated_at : function(h,row){

          	return self.formattedTime(row.updated_at)
          },

          created_at : function(h,row){

          	return self.formattedTime(row.created_at)
          },

          action: (h,row)=>{
            const isAdmin = self.auth.user_data.role === "admin";
            if(isAdmin || self.auth.user_data.id === row.user_id)
            {
              return self.h(DataTableActions, { data: row, componentTitle: this.componentName});
            }
            else
            {
              return self.h(DataTableActions,{data:row,isAuthorAdminEditOrDeleteEnabled: true ,componentTitle: this.componentName})
            }
          },
        },

				sortable:  ['title', 'created_by', 'updated_by', 'created_at', 'updated_at'],

				filterable:  ['title', 'created_by','updated_by', 'created_at', 'updated_at'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
	      
	        return {
	      
	          'sort-field': data.orderBy ? data.orderBy : 'updated_at',
	      
	          'sort-order': data.ascending ? 'desc' : 'asc',
	      
	          'search-query':data.query.trim(),
	      
	          page:data.page,
	      
	          limit:data.limit,
	        }
	      },

			 	responseAdapter({data}) {

					return {
					
						data: data.data.data.map(data => {

							data.from = 'agent';

							data.canned_edit_url = '/canned/' + data.id + '/edit';
							
							data.delete_url = self.basePath() + '/api/canned/delete/' + data.id ;

							if(self.auth.user_data.id !== data.user_id) {

								data.is_not_deletable = true;

								data.delete_tip = 'you_cant_delete' ;
							}

						return data;
					}),
						count: data.data.total
					}
				},

				orderBy: { column: 'updated_at', ascending: true },
			}
		}
	};
</script>

<style>
	 
	.canned-name,.canned-author,.canned-created,.canned-update.canned-updated, .canned-action{
		max-width: 250px; word-break: break-all;
	}

	#my_canned .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_canned .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>