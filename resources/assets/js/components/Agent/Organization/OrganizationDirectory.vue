<template>
	
	<div id="org-list" class="col-sm-12">

		<alert componentName="dataTableModal"/>
		
		<div class="card card-light ">
		
			<div class="card-header">
				
				<h3 class="card-title ">{{lang('organization_list')}}</h3>

				<div class="card-tools">
					
					<router-link class="btn-tool" v-tooltip="lang('create_organization')" to="/organizations/create">

						<i class="glyphicon glyphicon-plus"></i>
					</router-link>
				</div>
			</div>
				
			<div class="card-body" id="my_orgs">
						
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="org-list"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

	import {useStore} from 'vuex'

	import DataTableActions from "../../MiniComponent/DataTableComponents/DataTableActions.vue";

	import {computed} from "vue";
	import {RouterLink} from "vue-router";
  import {renderLabelWithEmoji} from "../../../helpers/extraLogics";

	export default {

		name : 'organizations-directory',

		description : 'Organization list component',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},


		data() {

			return {

				apiUrl : '/org-list-data' ,

				columns: ['name', 'phone', 'active_users_count', 'labels','created_at', 'updated_at', 'action'],

				options : {},
			}
		},

		beforeMount(){

			const self = this;
			
			this.options = {

				headings: {

          name: this.trans('name'),

          phone: this.trans('phone'),

          active_users_count : this.trans('members_count'),

          labels : this.trans('labels'),

          created_at : this.trans('created_at'),

          updated_at : this.trans('updated_at'),

          action: this.trans('actions'),
				},

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},

				columnsClasses : {

					name: 'organization-name',

					phone: 'organization-phone',

					active_users_count : 'organization-members',

          labels :  'Labels',

					created_at : 'organization-created',

					updated_at : 'organization-updated',

					action: 'organization-action',
				},

				texts: { filter: '', limit: '' },

				templates: {

					created_at(h, row) {

						return self.formattedTime(row.created_at);
					},

					updated_at(h, row) {

						return self.formattedTime(row.updated_at);
					},

					phone(h, row) {

						return row.phone === ' Not available' ? '---' : row.phone;
					},

					name: function(createElement, row) {
						
						return self.h(RouterLink, {

								to: '/organizations/' + row.id,

						}, row.name);
					},

					member_count: function(h, row) {
						return row.active_users_count
					},

					labels : function(createElement, row) {
						let labels = '';
						row.labels.map(function(label) {
							labels = labels + label.title + ', ';
						});
						labels = labels.slice(0,-2);
            return self.h('span', {
            // Set the innerHTML of the span element to the processed label
               innerHTML: self.loadLabel(labels)
            });
					},

					action : (f,row)=>{

						return self.h(DataTableActions,{data:row})
					},

				},

				sortable: ['name', 'phone', 'active_users_count', 'created_at', 'updated_at'],

				filterable: ['name', 'phone','created_at', 'updated_at'],

				pagination:{chunk:5,nav: 'fixed',edge:true},

				requestAdapter(data) {

					return {

						'sort-by': data.orderBy,

						'order': data.ascending ? 'desc' : 'asc',

						'search-query':data.query.trim(),

						page:data.page,

						limit:data.limit,

					}
				},
				responseAdapter({data}) {
					return {

						data: data.message.data.map(data => {
							
							data.from = 'agent';

							data.edit_url = '/organizations/' + data.id + '/edit';
							
							data.view_url = '/organizations/' + data.id ;

							data.delete_url = self.basePath() +'/org/delete/' + data.id;
							
							return data;
						}),
						
						count: data.message.total
					}
				},
			}
		},

    methods : {

      loadLabel(label) {
        // Processes the given label to include emojis.
        return renderLabelWithEmoji(label);
      }
    }
	};
</script>

<style>
	
	.organization-name,.organization-phone,.organization-created,.organization-updated,.organization-action{
		max-width: 250px; word-break: break-all;
	}
	
	#my_orgs .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_orgs .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>