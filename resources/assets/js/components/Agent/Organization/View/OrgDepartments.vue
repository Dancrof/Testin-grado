<template>
		
	<div id="org_departments">
		
		<alert componentName="OrgDepartmentsdataTableModal"/>

		<div class="card card-light ">
		
			<div class="card-header">
			
				<h3 class="card-title">{{lang('list_of_org_department')}}</h3>

				<div class="card-tools">

          <button v-if="cardOpen && loading" type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

            <i class="fas fa-sync-alt"></i>
          </button>
					
					<a v-if="cardOpen" class="btn-tool" @click="showModal = true" href="javascript:;" v-tooltip="lang('add_department')">
          
		          	<i class="glyphicon glyphicon-plus"> </i>
		        </a>

		        <button type="button" class="btn btn-tool" @click="toggleCard">

                  <i :class="{'fas fa-angle-up' : cardOpen, 'fas fa-angle-down' : !cardOpen }" class="fs-25"></i>
              </button>
				</div>
			</div>
			
			<div v-if="cardOpen" class="card-body">
			
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="org_departments" 
				componentTitle="OrgDepartments" :disableLoader="disableLoader" @loaderState="handelLoader">
					
				</data-table>
			</div>

			<transition name="modal">

				<org-dept-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :orgId="id">

				</org-dept-modal>
			</transition>
		</div>
	</div>
</template>

<script>

	import OrgDeptActions from "./MiniComponents/OrgDeptActions.vue";
	import {RouterLink} from "vue-router";
	import OrgDeptModal from "./MiniComponents/OrgDeptModal.vue";

  import { lang } from "../../../../helpers/extraLogics";

	export default {

		name : 'org-departments',

		description : 'Organization departments list',

		props : { 

			id : { type : [String,Number], default : ''},

      disableLoader : {type: Boolean, default: false}
		},

		data() {

			return {

				columns: ['org_deptname', 'business_hours_id', 'org_dept_manager', 'action'],

				options: {},

				apiUrl:'/org-dept-list/'+this.id,

				showModal : false,

				cardOpen : false,

        loading : true
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
					
					org_deptname : self.lang('list_of_org_department'),

					business_hours_id : self.lang('business_hours'),

					org_dept_manager : self.lang('organization_department_manager'),

					action: self.lang('actions')
				},

				columnsClasses : {
          
         	org_deptname : 'org-dept', 

					business_hours_id : 'org-hours',

					org_dept_manager : 'org-dept-manger',
        },
				
				texts: { filter: '', limit: '' },

				templates: {
					
					business_hours_id(h,row){

						return row.business_hour ? row.business_hour.name : '---'
					},

					org_dept_manager(createElement,row){

						if(row.manager){

							return self.h(RouterLink, {

									to: '/user/' + row.manager.id,

							}, row.manager.full_name);
						} else {

							return '---'
						}
					},

					action: (f,row)=>{

						return self.h(OrgDeptActions,{ data : row})
					}
				},

				sortable:  ['org_deptname', 'business_hours_id', 'org_dept_manager'],

				filterable:  ['org_deptname', 'business_hours_id', 'org_dept_manager'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
	      
	        return {
	      
	          'sort-by': data.orderBy ? data.orderBy : 'updated_at',
	      
	          order: data.ascending ? 'desc' : 'asc',
	      
	          'search-query':data.query.trim(),
	      
	          page:data.page,
	      
	          limit:data.limit,
	        }
	      },

			 	responseAdapter({data}) {

					return {
					
						data: data.message.data.map(data => {
							
							data.delete_url = self.basePath()+'/delete-org-dept/' + data.id ;

							data.orgId = self.id;

						return data;
					}),
						count: data.message.total
					}
				},

				orderBy: { column: 'updated_at', ascending: true },
			}
		},

		methods : {

			toggleCard() {
          
             this.cardOpen = !this.cardOpen;
         },

			onClose(){

				this.showModal = false;

				this.$store.dispatch('unsetValidationError');
			},

      handelLoader(loader){
        this.loading = loader;
      }
		},

		components : {

			'org-dept-modal' : OrgDeptModal
		}
	};
</script>

<style>
	 .org-dept,.org-hours,.org-dept-manager{ min-width: 150px;; word-break: break-all;}

	 #org_departments .VueTables .table-responsive {
		overflow-x: auto;
	}

	#org_departments .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
	}

	.fs-25{ font-size: 25px; }
</style>