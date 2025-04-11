<template>
	<div class="col-sm-12">
		
		<alert componentName="dataTableModal"/>

		<div class="card card-light">

			<div class="card-header">
				
				<h3 class="card-title" id="payment-title">{{lang('list_of_payment_gateways')}}</h3>
			</div>
			
			<div class="card-body">
				
				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="payment-title"></data-table>
			</div>

			<transition name="modal">
		
		 	<payment-settings-modal v-if="showModal" title="settings" :onClose="onClose" :showModal="showModal" :data="data">
		 	</payment-settings-modal>
		</transition>

		</div>	
	</div>
</template>

<script>

	import DataTableStatus
		from "../../../../../../resources/assets/js/components/MiniComponent/DataTableComponents/DataTableStatus.vue";

	import DataTableIsDefault
		from "../../../../../../resources/assets/js/components/MiniComponent/DataTableComponents/DataTableIsDefault.vue";
	import PaymentSettingsModal from "./PaymentSettingsModal.vue";

	export default {

		name : 'payments',

		description : 'Payments data table component',

		data(){

			return {

				base:window.axios.defaults.baseURL,
				
				columns: ['name', 'gateway_name', 'is_default', 'status', 'action'],

				options : {},
		
				apiUrl:'/bill/get-gateways-list',

				showModal : false,

				data : {}
			}
		},

		beforeMount(){
			
			const self = this;

			this.options = {

        headings: {
          name : this.trans('name'),
          gateway_name : this.trans('gateway_name'),
          is_default : this.trans('is_default'),
          status : this.trans('status'),
          action : this.trans('action')
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

						return self.h(DataTableStatus,{ data : row})
					},
						
					action: function(createElement, row) {
            
            let i = self.h('i', {
               	'class' : 'fa fa-cogs'
            });
            
            return self.h('button', {

                class : 'btn btn-primary btn-sm',

				onClick(event) {
					self.onClick(row)
				}
            }, [i]);
          },
					
					is_default : (f,row)=>{
						return self.h(DataTableIsDefault,{ data : row })
					}
				},
					
				sortable:  [ 'name', 'gateway_name', 'is_default', 'status' ],
					
				filterable:  [ 'name', 'gateway_name', 'is_default', 'status' ],
					
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
							
							data: data.data.data,
							
							count: data.data.data.length
						}
					},

					orderBy: { column: 'id', ascending: true }
				}
		},

		methods : {
			onClick(data){

				this.data = data;
				
				this.showModal = true
			},

			onClose(){
				this.showModal = false;
				this.$store.dispatch('unsetValidationError');
			}
		},

		components : {

			'payment-settings-modal' : PaymentSettingsModal
		}
	};
</script>