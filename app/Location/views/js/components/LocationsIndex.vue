<template>
	
	<div id="locations-list" class="col-sm-12">
		
		<alert componentName="dataTableModal" />

		<faveo-box :title="trans('list_of_locations')">

			<template #customActions>
				<div class="card-tools">

					<router-link class="btn btn-tool" to="/location/create" v-tooltip="{content: trans('create_location'), placement: 'left'}">

						<i class="glyphicon glyphicon-plus"> </i>
					</router-link>
				</div>
			</template>

			<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="locations-list">
					
			</data-table>
		</faveo-box>
	</div>
</template>

<script>
	
	import DataTableActions
		from "../../../../../resources/assets/js/components/MiniComponent/DataTableComponents/DataTableActions.vue";

	export default {

		name : 'locations-index',

		data () {

			return {

				columns : ['title', 'phone', 'address', 'action'],

				apiUrl : '/api/location-list',

				options : {}
			}
		},

		beforeMount () {

			const self = this;

			this.options = {

        headings : {
          title : this.trans('title'),
          phone : this.trans('phone'),
          address : this.trans('address'),
          action : this.trans('actions')
        },
				
				texts: { filter: "", limit: "" },

				templates: {

      phone(h,row){

        return row.phone && row.phone_country_code
            ? '+' + row.phone_country_code + ' ' + row.phone : row.phone ? row.phone : '--';

      },

      address(h, row) {

						return row.address ? row.address : '--'
					},

		  			action: (f,row) => {
						  return self.h(DataTableActions,{ data : row})
					},
				},
				
				sortable: [ 'title', 'phone' ],

				filterable: [ 'title', 'phone', 'address' ],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
			  	
			  		return {
				 		
				 		'sort-field': data.orderBy ? data.orderBy : "id",
				 		
				 		'sort-order': data.ascending ? "asc" : "desc",
				 		
				 		'search-query': data.query.trim(),
				 		
				 		page: data.page,
				 		
				 		limit: data.limit
			  		};
				},

				responseAdapter({ data }) {  

			  		return {
				 		
				 		data: data.data.locations.map(data => {
							
							data.edit_url = "/location/" + data.id + '/edit';
							
							data.delete_url = self.basePath() + "/api/location/delete/" + data.id;
							
							return data;
				 		}),
				 		
				 		count: data.data.total
			  		};
				},

				orderBy: { column: 'id', ascending: true }
		 	};
		}
	};
</script>