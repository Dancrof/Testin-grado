<template>
	<div class="col-sm-12">
		
		<alert componentName="dataTableModal"/>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title" id="pack-title">{{lang('list_of_packages')}}</h3>

				<div class="card-tools">

					<router-link class="btn btn-tool" to="/billing/package/create" v-tooltip="lang('create-package')">

						<span class="glyphicon glyphicon-plus"> </span> 
					</router-link>
					
					<a v-if="selectedData.length > 0" class="btn btn-tool" @click="deletePackage()" v-tooltip="lang('delete-package')">

						<span class="fas fa-trash"> </span> 
					</a>
				</div>
			</div>
			
			<div class="card-body">
				<!-- datatable -->
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="pack-title"  :tickets="packages"></data-table>
			</div>

			<transition name="modal">

			 	<delete-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :deleteUrl="deleteUrl" ></delete-modal>
			</transition>

		</div>	
	</div>
</template>

<script>

	import {lang} from "../../../../../../resources/assets/js/helpers/extraLogics";
	import DataTableActions
		from "../../../../../../resources/assets/js/components/MiniComponent/DataTableComponents/DataTableActions.vue";

	import DataTableStatus
		from "../../../../../../resources/assets/js/components/MiniComponent/DataTableComponents/DataTableStatus.vue";
	import DeleteModal
		from "../../../../../../resources/assets/js/components/MiniComponent/DataTableComponents/DeleteModal.vue";

	export default {

		name : 'pacakges',

		description : 'Pacakges data table component',

		data(){

			return {

				base:window.axios.defaults.baseURL,
				
				columns: ['id', 'name', 'validity', 'allowed_tickets', 'price', 'status', 'action'],

				options : {},
		
				apiUrl:'/bill/package/get-inbox-data',

				selectedData : [],

				showModal : false,

				deleteUrl : '',
			}
		},

		beforeMount(){
			
			const self = this;

			this.options = {
				
				headings: {

          id : this.trans('id'),

          name: this.trans('name'),

          validity : this.trans('validity'),

          allowed_tickets : this.trans('incident_credit'),

          price : this.trans('price'),

          status: this.trans('status'),

          action: this.trans('action')
				},
					
				texts: {
					
					filter: '',
					
					limit: ''
				},

				sortIcon: {
						
					base : 'glyphicon',
						
					up: 'glyphicon-chevron-down',
						
					down: 'glyphicon-chevron-up'
				},
					
				templates: {
						
					status: (f,row)=>{
						return self.h(DataTableStatus,{ data : row })
					},
						
					action: (f,row)=>{
						return self.h(DataTableActions,{ data : row })
					},

					validity(h,row){
						
						return row.validity === null ? lang('one_time') : lang(row.validity);
					}
				},
					
				sortable:  [ 'name', 'validity', 'allowed_tickets', 'price', 'status' ],
					
				filterable:  [ 'name', 'validity', 'allowed_tickets', 'price', 'status' ],
					
				pagination:{chunk:5,nav: 'fixed',edge:true},
					
				requestAdapter(data) {
					
					return {

						'sort-field': data.orderBy ? data.orderBy : 'id',
        
            'sort-order': data.ascending ? 'desc' : 'asc',
        
            'search-query':data.query.trim(),
        
            'page':data.page,
        
            'limit':data.limit,
						}
					},
					
					responseAdapter({data}) {
						
						return {
							
							data: data.message.data.map(data => {

								data.edit_url = '/billing/package/'+data.id+'/edit';

								return data;
							}),
							
							count: data.message.total
						}
					},

					orderBy: { column: 'id', ascending: true }
				}
		},

		methods : {
			packages(data){

				this.selectedData = data;
			},

			deletePackage(){

				this.deleteUrl = 'bill/package/delete?package_ids=' + this.selectedData

				this.showModal = true
			},

			onClose(){
		    
		    this.showModal = false;
		    
		    this.$store.dispatch('unsetValidationError');
		  },
		},

		components : {

			'delete-modal': DeleteModal,
		}
	};
</script>