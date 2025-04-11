<template>
	
	<div class="col-sm-12" id="topics-list">
		
		<alert componentName="dataTableModal" />

		<faveo-box :title="trans('list_of_help_topics')">

            <template #customActions>

                <div class="card-tools">

                    <router-link class="btn btn-tool" to="/helptopic/create" v-tooltip="trans('create_new_help_topic')">

                        <i class="glyphicon glyphicon-plus"> </i>
                    </router-link>

                    <button type="button" class="btn btn-tool dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">

                        <i class="glyphicon glyphicon-filter"></i>
                    </button>

                    <div class="dropdown-menu dropdown-menu-right" role="menu" x-placement="bottom-end">

                        <a v-for="action in actions" href="javascript:;" class="dropdown-item" @click="updateTable(action)">

                            {{trans(action)}}
                        </a>
                    </div>
                </div>
            </template>

			<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="topics-list">
					
			</data-table>
		</faveo-box>
	</div>
</template>

<script>
	
	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

    export default {

		name : 'labels-index',

		data () {

			return {

				columns : ['topic', 'status', 'type', 'department', 'action'],

				apiUrl : '/api/admin/helptopic-list',

				options : {},

				action : 'all',

				actions : ['all','active','inactive']
			}
		},

		beforeMount () {

			const self = this;

			this.options = {
			
				headings : {
          topic: this.trans('topic'),
          status: this.trans('status'),
          type: this.trans('type'),
          department: this.trans('department'),
          action : this.trans('actions')
        },

				texts: { filter: "", limit: "" },

				sortIcon: {

					base : 'glyphicon',

					up: 'glyphicon-chevron-down',

					down: 'glyphicon-chevron-up'
				},

				templates: {
		  
		  			action: function(createElement,row){

                          return self.h(DataTableActions,{
                              data : row
                          })
                    },

		  			status: function(createElement, row) {
            
			         let span = self.h('span', {

                        'class' : row.status ? 'btn btn-success btn-sm' : 'btn btn-danger btn-sm',

                        'style' : 'cursor:default !important'

			         }, row.status ? this.trans('active') : this.trans('inactive'));
			                  
			         return self.h('a', {
			                    
			         }, [span]);
			      },

			      type: function(createElement, row) {
            
			         let span = self.h('span', {

                        'class' : row.type ? 'btn btn-success btn-sm' : 'btn btn-danger btn-sm',

                        'style' : 'cursor:default !important'

			         }, row.type ? this.trans('public') : this.trans('private'));
			                  
			         return self.h('a', {
			                    
			         }, [span]);
			      },

			      department(h, row) {
			                  
			         return row.department ? row.department.name  : '--';
			      }
				},
				
				sortable: [ 'topic', 'status', 'type', 'department' ],

				filterable: [ 'topic', 'status', 'type', 'department' ],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
			  	
			  		return {
				 		
				 		'sort-field': data.orderBy ? data.orderBy : "id",
				 		
				 		'sort-order': data.ascending ? "desc" : "asc",
				 		
				 		'search-query': data.query.trim(),
				 		
				 		page: data.page,
				 		
				 		limit: data.limit
			  		};
				},

				responseAdapter({ data }) {  

			  		return {
				 		
				 		data: data.data.data.map(data => {
							
							data.edit_url = "/helptopic/" + data.id + '/edit';
							
							data.delete_url = self.basePath() + "/api/admin/helptopic-delete/" + data.id;
							
							data['is_linked'] = true;

							data['dependency'] = 'help-topic'
							
							return data;
				 		}),
				 		
				 		count: data.data.total
			  		};
				},

				orderBy: { column: 'id', ascending: true },
		 	};
		},

		methods : {
			
			updateTable(value) {
			
				switch(value) {
					
					case 'all':
						
						this.apiUrl = '/api/admin/helptopic-list';
						break;
					
					case 'active':
						
						this.apiUrl = '/api/admin/helptopic-list?status=1';
						break;
					case 'inactive':
						
						this.apiUrl = '/api/admin/helptopic-list?status=0';
						break;
				}
			}
		}
	};
</script>