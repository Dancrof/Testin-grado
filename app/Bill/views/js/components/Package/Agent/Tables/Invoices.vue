<template>
	<div class="invoice-pack">
    
   <!--  <div v-if="orderIds.length > 0" class="row" id="delete_btn">
     
      <button class="btn btn-danger pull-right" @click="deleteOrders()"> 
        <i class="fa fa-trash"> </i> {{lang('delete')}}
      </button>
      
    </div> -->
    
    <data-table :url="apiEndpoint" :dataColumns="columns"  :option="options" scroll_to="packages_title" :tickets="orderData"
                @loaderState="handelLoader" :disableLoader="disableLoader" ></data-table>
	</div>
</template>

<script>

import {mapGetters, useStore} from 'vuex'

  import { lang } from "../../../../../../../../resources/assets/js/helpers/extraLogics";
  import {RouterLink} from "vue-router";
import {computed} from "vue";

  export default {
		
    name : 'invoices-table',

		description : 'Invoices table page',

	  setup() {

		  const store = useStore();

		  return {

			  formattedTime : computed(()=>store.getters.formattedTime),

			  formattedDate : computed(()=>store.getters.formattedDate)
		  }
	  },

		props : {

    	category : { type : String, default : ''},

      apiEndpoint : { type:String , default : ''},

      disableLoader : {type: Boolean, default: false}
    },

		data() {
			return {

        base:window.axios.defaults.baseURL,
        
        options : {},

        apiUrl: this.apiEndpoint,

        columns : ['name','created_at','due_by','total_amount', 'payment_mode', 'status'],

        orderIds : []
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

        headings: {
          name : lang('name'),
          created_at : lang('created_at'),
          total_amount : lang('total_amount'),
          status : lang('status'),
          payment_mode: lang('payment_mode'),
					due_by : lang('due_by'),
		    },

        columnsClasses : {

          name: 'invoice-name',

          created_at : 'order-create',

          due_by: 'order-due',

          total_amount: 'order-amount',

          status: 'order-status'
        },


        texts : { 

          filter : '', 

          limit : ''
        },
        
        templates: {
								
					status: function(createElement, row) {
            
            let span = self.h('span', {

                'class' : row.order.status === 1 ? 'btn btn-success btn-sm' : 'btn btn-danger btn-sm'

            }, row.order.status === 1 ? 'Paid' : 'Unpaid');
            
            return self.h('a', {
              
            }, [span]);
          },

          created_at(h,row){
            
            return self.formattedTime(row.created_at)
          },

          due_by(h,row){
            
            return self.formattedTime(row.due_by)
          },
          payment_mode(h,row){
            return lang(row.payment_mode)
          },

					name: function(createElement, row) {
            
            return self.h(RouterLink, {

                to :'/bill/package/'+row.id+'/user-invoice'

            }, '#'+row.name);
          },
				},
        
        sortable:  ['name','created_at','due_by','total_amount', 'payment_mode', 'status'],
            
        filterable:  ['name','created_at','due_by','total_amount', 'payment_mode'],
        
        pagination:{chunk:5,nav: 'scroll'},
        
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
        
            count: data.data.total
          }
        },

	      orderBy: { column: 'id', ascending: true }
      }

    },

		methods :{

      orderData(data){

        this.orderIds = data;
      },

      deleteOrders(){
        prompt('Are you sure to delete this','yes')
      },

      handelLoader(value){
        this.$emit('loaderValue',value);
      }
		}
	};
</script>

<style type="text/css">

  .invoice-name,.invoice-create,.invoice-due,.invoice-amount,.invoice-status{ max-width: 250px; word-break: break-all;}

  .invoice-pack .VueTables .table-responsive {
    overflow-x: auto;
  }

  .invoice-pack .VueTables .table-responsive > table{
    width : max-content;
    min-width : 100%;
    max-width : max-content;
    overflow: auto !important;
  }
</style>