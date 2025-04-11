<template>

	<div id="org-dept-user-list"> 
	
		<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

			<template #title>
			
				<h4 class="modal-title">{{lang('list_of_users')}}</h4>
			</template>

			<template #fields>

				<div class="height-limit">
					
					<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="org-dept-user-list"
					componentTitle="OrgDeptUserList">
			
					</data-table>	
				</div>
			</template>
		</modal>
	</div>
</template>

<script>

	import {RouterLink} from "vue-router";

	export default {
		
		name : 'org-dept-user-modal',

		description : 'Organization department user modal component',

		props:{

			showModal:{type:Boolean,default:false},

			onClose:{type: Function, default : ()=>{}},

			orgId : { type : [Number, String], default  : ''},

			deptId : { type : [Number, String], default  : ''}
		},

		data(){
			
			return {

				isDisabled:false,

				containerStyle:{ width:'950px' },

				loading:false,

				size: 60,

				apiUrl : '/org-dept-user-list/'+this.orgId+'/'+this.deptId,

				columns: ['first_name', 'email'],
				
				options: {},
			}
		},

		beforeMount(){

			const self = this;
	
			this.options = {

				texts : { 'filter' : '', 'limit': ''},

				headings: { first_name: this.lang('name'), email: this.lang('email') },

				templates: {

					first_name(createElement,row){
						
						return self.h(RouterLink, {

							to: '/user/' + row.id,

						}, row.full_name ? row.full_name : row.user_name);
					}
				},

				sortable:  ['first_name', 'email'],

				filterable:  ['first_name', 'email'],

				pagination:{chunk:5,nav: 'scroll'},

				requestAdapter(data) {

					return {
						
						'sort-by': data.orderBy ? data.orderBy : 'id',
						
						'order': data.ascending ? 'desc' : 'asc',
						
						'search-query':data.query.trim(),
						
						page:data.page,
						
						limit:data.limit,
					}
				},

				responseAdapter({data}) {
					
					return {
						
						data: data.message.data.map(data => {

						data.detach = true;

						return data;
					}),
					
						count: data.message.total
					}
				},

				orderBy: { column: 'id', ascending: true },
			}
		}
	};
</script>

<style>
	.height-limit{
		overflow-y: auto;
		max-height: 300px;
		overflow-x: hidden;
	}

	.table-striped thead:first-child tr {
	    background: transparent !important;
	}
</style>