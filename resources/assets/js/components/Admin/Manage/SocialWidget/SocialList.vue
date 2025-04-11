
<template>

    <div class="col-sm-12">

        <alert componentName="dataTableModal"/>

	    <div class="card card-light">
		
			<div class="card-header" id="social-widget-list">
				
				<h3 class="card-title ">{{lang('social-widget-settings')}}</h3>
			</div>

			<div class="card-body">		
				
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="social-widget-list"></data-table>
			</div>
		</div>
	</div>
</template>

<script type="text/javascript">

    import SocialWidgetTableActions from "./SocialWidgetTableActions.vue";

	export default {

        name : 'social-widget-list',

        description : 'Widget list table component',

		data: () => {

             return {

                 apiUrl : 'api/list-widgets/social-icon',

                 columns: ['name','value','action'],

                 options : {},
             }
	    },

		beforeMount(){

			const self = this;
			
			this.options = {

				headings: {

          name: this.trans('name'),

          value: this.trans('link'),

          action: this.trans('action')
				},

        columnsClasses : {

					name: 'widget-name',

					title: 'widget-title',

					action: 'widget-action',
				},

        texts: { filter: '', limit: '' },

        sortable: ['name','Link'],

				filterable: ['name', 'Link'],

				templates: {

                    action: function(createElement, row) {

                        return self.h(SocialWidgetTableActions, {

                            data: row,
                        })
                    },
                },

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
			};
		},
    };
</script>

<style type="text/css" scoped>
.widget-name{
		width:30% ;
		word-break: break-word;
	}
	.widget-title{
		width:30%;
		word-break: break-word;
	}

	.widget-value{
		white-space: nowrap;
	}
		.widget-action{
		white-space: nowrap;
	}
</style>