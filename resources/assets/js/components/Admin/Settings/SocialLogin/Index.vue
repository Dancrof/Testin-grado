<template>
    <div class="col-sm-12">

		<alert componentName="dataTableModal"/>

		<div class="card card-light assets-type-table">

			<div class="card-header">

				<h3 id="cmdb-list" class="card-title">{{lang('social-login-page-title')}}</h3>
				
			</div>

			<div class="card-body" id="cmdb-table">

				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="cmdb-relationship-list">

				</data-table>
			</div>
		</div>
        
    </div>
</template>

<script>

import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

export default {

    data(){
        return{
          columns: ['provider', 'status',	'action'],
			options: {},
			apiUrl:'/api/admin/social/media-list',

        }
    },

	beforeMount() {
		const self = this;

		this.options = {
			sortIcon: {
					
				base : 'glyphicon',
					
				up: 'glyphicon-chevron-down',
					
				down: 'glyphicon-chevron-up'
			},
			texts: { filter: '', limit: '' },

      headings : {
        provider: this.trans('provider'),

        status : this.trans('status'),

        action : this.trans('action')
      },

			columnsClasses : {
				provider: 'provider',
				status : 'status'
			},
			templates: {
        provider(h, row) {
          return row.provider === 'Linkedin-openid' ? 'LinkedIn' : (row.provider ? row.provider : '--');
        },
        status(f,row){
					if( row.value == 1 ){

						return self.h('p', { style: { color: 'green' } }, this.lang('active'));

					} else {
						
						return self.h('p', { style: { color: 'red' } }, this.lang('inactive'));
					}
				},
				action: (f,row)=>{

					return self.h(DataTableActions,{ data : row})
				}
			},
			sortable:  '',
			
			filterable:  '',
			
			pagination:{chunk:5,nav: 'fixed',edge:true},
			
			requestAdapter(data) {
				
				return {
	
					'sort-order' : data.ascending ? 'desc' : 'asc',
					
					'search-query' : data.query.trim(),
					
					page : data.current_page,
					
					limit : data.per_page,
				}
			},
			responseAdapter({data}) {

				return {
					data: data.data.map(data => {

						if( data.provider === 'External Login')
							data.settings_url = '/social/external-login';
						else
							data.settings_url = '/' +data.url_setting;

						return data;
					}),
					count: data.data.length
				}
			},
		}
	}
}
</script>

<style scoped>

</style>