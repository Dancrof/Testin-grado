<template>
		
	<data-table :url="apiUrl" :dataColumns="columns" :inputStyle="inputStyle" :option="options" scroll_to="org_members"
		:color="layout.portal.client_header_color">
			
	</data-table>
</template>

<script>

	import { mapGetters } from 'vuex';
	import DataTableActions from "../../DataTableComponents/DataTableActions.vue";

	import DataTable from "../../../../Extra/DataTable.vue";
	export default {

		name : 'org-members-index',

		description : 'Organization members table component',

		props : {

			org_id : { type : [String, Number], default : ''},

			layout : { type : Object, default : ()=>{}},

			inputStyle : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},
		},

		data() {

			return {

				base:window.axios.defaults.baseURL,

				columns: ['full_name', 'user_name', 'email', 'mobile', 'updated_at', 'action'],

				options: {},

				apiUrl:'/organization/userdata/'+this.org_id,
			}
		},

		computed :{

			...mapGetters(['formattedTime','formattedDate'])
		},

		beforeMount(){

			this.$Progress.start();

			const self= this;

			this.options = {

				sortIcon:{
				   
				  base:'glyphicon',
				   
				  up: 'glyphicon-chevron-down',
          
          down: 'glyphicon-chevron-up'
				},

				headings: { 
					
					user_name: this.trans('user_name'),

					full_name: this.trans('name'),

					email : this.trans('email'),

					mobile : this.trans('mobile'),
					
					updated_at : this.trans('last_activity'),
					
					action: this.trans('action')
				},

				columnsClasses : {
          
         	user_name: 'org-name', 

					email : 'org-email',

					mobile : 'org-mobile',
        },
				
				texts: { filter: '', limit: '' },

				templates: {

          updated_at : function(h,row){

          	return self.formattedTime(row.updated_at)
          },
					
					mobile : function(h,row){

          	return row.mobile === 'Not available' || !row.mobile ? '---' : row.mobile
          },

          email : function(h,row){

          	return row.email ? row.email : '---'
          },

					action: (f,row)=>{

			  return self.h(DataTableActions,{data:row})
					}
				},

				sortable:  ['user_name', 'email', 'mobile', 'updated_at'],

				filterable:  ['user_name', 'email', 'mobile','updated_at'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
	      
	        return {
	      
	          'sort-field': data.orderBy ? data.orderBy : 'updated_at',
	      
	          'sort-order': data.ascending ? 'desc' : 'asc',
	      
	          'search-query':data.query.trim(),
	      
	          'page':data.page,
	      
	          'limit':data.limit,
	        }
	      },

			 	responseAdapter({data}) {

			 		self.$Progress.finish();

					return {
					
						data: data.message.data.map(data => {

							if(self.auth.user_data.id !== data.id){

								data.edit_url = { name : 'EditUser', params : { id : data.id}};

								data.deactivate_url = true;

								data.layout = self.layout;

								data.auth = self.auth
							}
						return data;
					}),
						count: data.message.total
					}
				},

				orderBy: { column: 'updated_at', ascending: true },
			}
		},
		components:{

			'data-table' : DataTable
		},


	};
</script>

<style type="text/css">

	 .org-name,.org-email{ 
	 	width: 200px; 
	 	word-break: break-word;
	 }

	 .org-phone,.org-mobile{ 
	 	width: 150px; 
	 	word-break: break-word;
	 }


	 #org_members .VueTables .table-responsive {
		overflow-x: auto;
	}

	#org_members .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
	}
</style>
