
<template>
	
	<div class="col-sm-12">

		<alert componentName="dataTableModal"/>

		<div class="card card-light">
	
			<div class="card-header">
		
				<h3 class="card-title ">{{lang('widget-settings')}}</h3>
			</div>
				
			<div class="card-body">		
					
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="widget-list"></data-table>
			</div>
		</div>
	</div>
</template>

<script type="text/javascript">

	import WidgetTableActions from "./WidgetTableActions.vue";

	export default
	 	
	 	{
			
			name : 'widget-list',
			
			description : 'Widget list table component',
		
			data: () => {
      		
                return {

                    apiUrl : 'api/list-widgets/footer',

                    columns: ['name','title','action'],

                    options : {},
                }
			},
		
			beforeMount(){

				const self = this;
			
				this.options = {

          headings : {
            name: this.trans('name'),

            title: this.trans('title'),

            action: this.trans('action'),
          },
				
					columnsClasses : {

						name: 'widget-name',

						title: 'widget-title',

						action: 'widget-action',
					},
					
					texts: { filter: '', limit: '' },
			
					templates: {

                        action: function(createElement, row) {

                            return this.h(WidgetTableActions, {

                                data: row,
                            })
                        },
					},

					sortable: ['name','title'],

					filterable: ['name', 'title'],

					requestAdapter(data) {
						
						return {
							
							'sort-field': data.orderBy ? data.orderBy : 'name',
							
							'sort-order': data.ascending ? 'asc' : 'desc',
							
							'search-query': data.query.trim(),
							
							page: data.page,
							
							limit: data.limit,
						}
					},
					
					responseAdapter({data}) {
					
						return {
						
							data: data.data.widgets,
							
							count: data.data.total
						}
					},

					orderBy: { column: 'name', ascending: true },
				}
			}
		};
</script>

<style type="text/css">
	
	.widget-name{ width:30%; word-break: break-word;}

	.widget-title{ width:30%; word-break: break-word;}

	.widget-value{white-space: nowrap;}

	.widget-action{ white-space: nowrap;}
</style>