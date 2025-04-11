<template>
	
	<div class="col-sm-12" id="teams-table">
	
		<alert componentName="dataTableModal"/>

		<div class="card card-light">

			<div class="card-header">
	
				<h3 class="card-title">{{trans('list_of_teams')}}</h3>
					
				<div class="card-tools">
	
					<router-link class="btn btn-tool" to="/team/create" v-tooltip="{content:trans('create_a_team'), placement: 'left'}">

						<i class="glyphicon glyphicon-plus"> </i>
					</router-link>
				</div>
			</div>
			
			<div class="card-body" id="my_teamss">
				
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="teams-table"></data-table>
			</div>
		</div>
	</div>
</template>

<script>

import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

export default {
		
		name : 'teams-index',

		description : 'Teams table component',

		data(){

			return {

			columns: ['name', 'team_size', 'status', 'lead', 'actions'],
				
			options: {},
		
			apiUrl:'/api/admin/team-list',
			}
		},

		beforeMount(){

			const self = this;

			this.options = {

				sortIcon: {

          		base : 'glyphicon',

          		up: 'glyphicon-chevron-down',

          		down: 'glyphicon-chevron-up'
        		},
        
				texts : { 'filter' : '', 'limit' : ''},

        headings : {
          name : this.trans('name'),

          team_size : this.trans('team_size'),

          status : this.trans('status'),

          lead : this.trans('lead'),

          actions : this.trans('actions')
        },
				
				columnsClasses : { 

					name : 'team-name', 

					team_size : 'team-size',

					status : 'team-status',

					lead : 'team-lead',

					actions : 'team-actions'
				},
				
				templates: {
					
					actions: function(createElement, row) {

                        return self.h(DataTableActions,{
                            data : row
                        })
                    },
					
					lead: function(createElement, row) {
						
						if(row.lead){

							return self.h('a', {

                                href : self.basePath() + '/panel/user/'+row.lead.id,

                                target : '_blank'

							}, row.lead.full_name);

						} else {return '--'}
					},

					status: function(createElement, row) {
						
						let span = self.h('span', {

                            'class' : row.status ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'

						}, row.status ? 'Active' : 'Inactive');
						
						return self.h('a', { class : 'pointer_normal'}, [span]);
					},
				},
				
				sortable:  ['name', 'team_size', 'status'],
				
				filterable:  ['name', 'team_size', 'status', 'lead'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
					
					return {
						
						'sort-field': data.orderBy ? data.orderBy : 'id',
						
						'sort-order': data.ascending ? 'desc' : 'asc',
						
						'search-query':data.query,
						
						page:data.page,
						
						limit:data.limit,
					}
				},
				
				responseAdapter({data}) {
					
					return {
					
						data: data.data.data.map(data => {
						
							data.edit_url = '/team/' + data.id + '/edit';

							if(data.status) {

								data.view_url = '/team/' + data.id ;
							}

							data.delete_url = self.basePath() + '/api/admin/delete-team/' + data.id;

							return data;
						}),
						count: data.data.total
					}
				},

				orderBy: { column: 'id', ascending: true },
			}
		}
	};
</script>

<style>
	
	.team-name,.team-status,.team-lead,.team-size,.team-actions{ max-width: 250px; word-break: break-all;}
	
	#my_teams .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_teams .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>