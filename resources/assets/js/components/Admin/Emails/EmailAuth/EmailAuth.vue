<template>
	<div class="col-sm-12">
		
		<alert componentName="dataTableModal"/>
		
		<div class="card card-light oauth-table">
			
			<div class="card-header">
				
				<h3 id="oauth-list" class="card-title">{{lang('oauth_integration')}}</h3>
			
			</div>
			
			<div class="card-body" id="oauth-table">
				
				<data-table :url="apiUrl" :dataColumns="columns" :option="options" scroll_to ="oauth-list">
				
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
			
			columns: ['provider', 'is_active',	'action'],
			
			options: {},
			
			apiUrl:'/get/oauth-integration',
			
		}
	},
	
	beforeMount() {
		const self = this;
		
		this.options = {
			
			texts: { filter: '', limit: '' },
			
			columnsClasses : {
			
				provider: 'oauth-provider',
			
				is_active : 'oauth-status'
			},
			
			headings : {
        provider: this.lang('provider'),

        is_active : this.lang("status") ,

        action : this.lang('action')
      },
			
			templates: {
				
				provider(h,row){
				
					return row.provider ? row.provider : '--';
				},
				
				is_active(obj,row){
					
					if( row.is_active){
						
						return self.h('p', { style: { color: 'green' } }, 'Active');
						
					} else {
						
						return self.h('p', { style: { color: 'red' } }, 'Inactive');
					}
				},
				
				action: function (createElement,row) {

                    return self.h(DataTableActions,{
                        data : row
                    })
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
					
					data: data.map(data => {
						
						data.settings_url = '/email/oauth/' +data.id;
						
						return data;
					}),
					
					count: data.length
				}
			},
		}
	}
}
</script>

<style scoped>

</style>