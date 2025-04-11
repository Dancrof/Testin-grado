<template>
		
	<div id="team_members">
	
		<div class="card card-light ">
		
			<div class="card-header">
			
				<h3 class="card-title">{{trans('list_of_team_members')}}</h3>

        <div v-if="loading" class="card-tools">

          <button type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

            <i class="fas fa-sync-alt"></i>
          </button>
        </div>
			</div>
			
			<div class="card-body">
			
				<data-table :url="apiUrl" :dataColumns="columns" @loaderState="handelLoader" :option="options" :disableLoader="disableLoader" scroll_to="team_members">
					
				</data-table>
			</div>
		</div>
	</div>
</template>

<script>

    import DataTableStatuses from "../../../../MiniComponent/DataTableComponents/DataTableStatuses.vue";

    export default {

		name : 'team-members',

		description : 'Team memebers list',

		props : { 

			id : { type : [String,Number], default : ''},

      disableLoader : {type: Boolean, default: false}
		},

		data() {

			return {

				columns: ['name', 'email', 'info', 'action'],

				options: {},

				apiUrl:'/api/admin/get-users-list?team-ids[]='+this.id,

        loading: true,
			}
		},

		beforeMount(){

			const self= this;

			this.options = {

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},

				headings: {

          name: this.trans('name'),

          email : this.trans('email'),

          info: this.trans('account_info'),

          action: this.trans('actions')
				},

				columnsClasses : {
          
         		name: 'team-member-name', 

					email : 'team-member-email', 
					
					info : 'team-member-status',

					action : 'team-member-action'
        		},
				
				texts: { filter: '', limit: '' },

				templates: {
					
					name: function(createElement, row) {
						
						return self.h('a', {
                            target : '_blank',
                            href: self.basePath()+'/panel/user/' + row.id,
						}, row.name);
					},

					email(h, row) {

						return row.email ? row.email : '--';
					},

					info : function(createElement,row) {

                        return self.h(DataTableStatuses,{
                            data : row
                        })
                    },

					action: function(createElement, row) {

						let span = self.h('i', { 'class' : 'fas fa-eye' });

						return self.h('a', {

                            target : '_blank',

                            href: self.basePath()+'/panel/user/' + row.id,

                            class : 'btn btn-light table_btn'

						}, [span]);
					},
				},

				sortable:  ['name', 'email'],

				filterable:  ['name', 'email'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
	      
	        		return {

	          		'sort-field': data.orderBy ? data.orderBy : 'id',
	      
	          		'sort-order': data.ascending ? 'desc' : 'asc',
	      
	          		'search-query':data.query.trim(),
	      
	          		page:data.page,
	      
	          		limit:data.limit,
	        		}
	      	},

			 	responseAdapter({data}) {

					return {
					
						data: data.data.users,

						count: data.data.total
					}
				},

				orderBy: { column: 'id', ascending: true },
			}
		},

    methods:{
      handelLoader(loader){
          this.loading = loader;
      }
    }
	};
</script>

<style scoped>
	.team-member-name,.team-member-email,.team-member-status, .team-member-action{ 
	 	min-width: 150px;; word-break: break-all;
	}

	#team_members .VueTables .table-responsive {
		overflow-x: auto;
	}

	#teaam_members .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
	}

  @keyframes rotate {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  /* Apply the rotation animation when the button has a class of "rotating" */
  .btn-tool.rotating i {
    animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
  }
</style>