<template>
	
	<div id="labels-list" class="col-sm-12">
		
		<alert componentName="dataTableModal" />

		<faveo-box :title="trans('list_of_labels')">

            <template #customActions>

                <div class="card-tools">

                    <router-link class="btn btn-tool" to="/label/create" v-tooltip="trans('create_label')">

                        <i class="glyphicon glyphicon-plus"> </i>
                    </router-link>

                    <div class="btn-group">

                        <button type="button" class="btn btn-tool dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">

                            <i class="glyphicon glyphicon-filter"></i>
                        </button>

                        <div class="dropdown-menu dropdown-menu-right" role="menu" x-placement="bottom-end">

                            <a v-for="action in actions" href="javascript:;" class="dropdown-item" @click="updateTable(action)">

                                {{trans(action)}}
                            </a>
                        </div>
                    </div>
                </div>
            </template>

			<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="labels-list">
					
			</data-table>
		</faveo-box>
	</div>
</template>

<script>

import {lang, renderLabelWithEmoji} from '../../../../helpers/extraLogics'
    import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";
	
	export default {

		name : 'labels-index',

		data () {

			return {

				columns : ['title', 'order', 'visible_to', 'status', 'action'],

				apiUrl : '/api/label-list',

				action : 'all',

				actions : ['all','active','inactive'],

				options : {}
			}
		},

		beforeMount () {

			const self = this;

			this.options = {

        headings : {
          title : this.trans('title'),

          order : this.trans('order'),

          visible_to : this.trans('visible_to'),

          status: this.trans('status'),

          action : this.trans('actions')
        },


        texts: { filter: "", limit: "" },

				templates: {
		  
		  			action: (f,row) =>{

                          return self.h(DataTableActions,{
                              data : row
                          })
                    },

		  			visible_to(h,row) {

						if(row.visible_to) {

							let arr = [];

							 row.visible_to.split(',').forEach((value)=>{ arr.push(lang(value)) })

							return arr.toString();
						} else {

							return '--'
						}
					},

		  			title: function(createElement, row) {
				
			 			let span = self.h('span', {
				
							style: { color: '#FFF', backgroundColor: row.color, fontSize: '12px' },

							class : 'badge'

			 			}, self.loadLabel(row.title));
						
			 			return self.h('a', {

                            href : self.basePath()+'/panel/tickets?show%5B%5D=inbox&departments%5B%5D=All&filter-by-url=1&category=all&label-ids[]=' + row.id

			 			}, [span]);
		  			},

		  			status: function(createElement, row) {
            
			         let span = self.h('span', {
			              'style' : 'cursor:auto',
			              'class' : row.status ? 'btn btn-success btn-sm' : 'btn btn-danger btn-sm'
			         }, row.status ? 'Active' : 'Inactive');
			                  
			         return self.h('a', {

			         }, [span]);
			      },
				},
				
				sortable: [ "title", "status", "order" ],

				filterable: ["title", "status", "order"],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
			  	
			  		return {
				 		
				 		'sort-field': data.orderBy ? data.orderBy : "order",
				 		
				 		'sort-order': data.ascending ? "asc" : "desc",
				 		
				 		'search-query': data.query.trim(),
				 		
				 		page: data.page,
				 		
				 		limit: data.limit
			  		};
				},

				responseAdapter({ data }) {  

			  		return {
				 		
				 		data: data.data.data.map(data => {
							
							data.edit_url = "/label/" + data.id + '/edit';
							
							data.delete_url = self.basePath() + "/api/label-delete/" + data.id;

							data['is_linked'] = true;

							data['dependency'] = 'label'
							
							return data;
				 		}),
				 		
				 		count: data.data.total
			  		};
				},

				orderBy: { column: 'order', ascending: true },
		 	};
		},

		methods : {
			
			updateTable(value) {
			
				switch(value) {
					
					case 'all':
						
						this.apiUrl = '/api/label-list';
						break;
					
					case 'active':
						
						this.apiUrl = '/api/label-list?status=1';
						break;

					case 'inactive':
						
						this.apiUrl = '/api/label-list?status=0';
						break;
				}
			},

      loadLabel(label) {
        return renderLabelWithEmoji(label);
      }
		}
	};
</script>