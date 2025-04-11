<template>
	<div class="order-pack">
    
    <!-- <div v-if="orderIds.length > 0" class="row" id="delete_btn">
     
      <button class="btn btn-danger pull-right" @click="deleteInvoices()"> 

        <i class="fa fa-trash"> </i> {{lang('delete')}}
      </button>
    </div> -->

    <data-table :url="apiEndpoint" :dataColumns="columns"  :option="options" scroll_to="packages_title" :tickets="orderData"
                @loaderState="handelLoader" :disableLoader="disableLoader" ></data-table>

    <transition name ="modal" >
      
      <orders-modal v-if="showModal" title="order_details" :onClose="onClose" :showModal="showModal" :id="order_id">
        
      </orders-modal>
    </transition>

	</div>
</template>

<script>

import {useStore} from 'vuex'

  import { lang } from "../../../../../../../../resources/assets/js/helpers/extraLogics";
import {computed} from "vue";
import {RouterLink} from "vue-router";
import OrdersModal from "./MiniComponents/OrdersModal.vue";

	export default {
		
    name : 'orders-table',

		description : 'Orders table page',

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

        columns : ['name','invoice','credit_type','credit','total_amount','period_expiry_date','expiry_date'],

        orderIds : [],

        order_id : 0,

        showModal :false
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


        columnsClasses : {

          invoice : 'order-invoice',

          credit_type : 'order-type',

          credit: 'order-credit',

          total_amount: 'order-amount',

          period_expiry_date: lang("period_expiry_date"),

          name: 'order-name',

          expiry_date: 'order-date',

        },

        texts : { 

          filter : '', 

          limit : ''
        },
        
        templates: {
			
	        invoice: function(createElement, row) {
		
		        return self.h(RouterLink, {

				        to :'/bill/package/'+row.id+'/user-invoice'

		          }, '#'+row.id);
	        },

          credit_type(h,row){
          
            return row.credit_type
          },

          credit(h,row){
            
            return row.credit
          },

          name(createElement,row){
            
            return self.h(RouterLink, {

                to : '/bill/order/'+row.id,

            }, row.package.name);
          },

          expiry_date(createElement,row){

            let currentDate = new Date();

            let expiry = self.formattedTime(row.expiry_date)

            let date;
            
            if(currentDate > expiry){

              date = self.h('span', {

                   class : 'text-danger'

              }, self.formattedTime(row.expiry_date));
            } else {

              date = self.h('span', {

                  class : 'text-green'

              }, self.formattedTime(row.expiry_date));
            }

            return date
          },

          total_amount(h,row){

            return row.invoice.total_amount
          },

          period_expiry_date(h, row) {

            return row.period_expiry_date ? self.formattedTime(row.period_expiry_date) : '---';
          },
				},
        
        sortable:  ['credit_type','credit','total_amount','expiry_date','status'],
            
        filterable:  ['credit_type','credit','total_amount','expiry_date','status'],
        
        pagination:{chunk:5,nav: 'scroll'},

        headings : {
          name : this.trans('package_name'),
          invoice : this.trans('invoice'),
          credit_type : this.trans('credit_type'),
          credit: this.trans('credit'),
          total_amount: this.trans('total_amount'),
          period_expiry_date: this.trans('period_expiry_date'),
          expiry_date: this.trans('expiry_date'),
        },
        
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
        
        this.orderIds = data
      },

      onClick(row){

        this.order_id = row.id;

        this.showModal = true;
      },

      onClose(){
      
        this.showModal = false;
      
        this.$store.dispatch('unsetValidationError');
      },

      deleteInvoices(){

        prompt('Are you sure to delete this','yes ')
      },

      handelLoader(value){
        this.$emit('loaderValue',value);
      }
		},

		components : {

      'orders-modal' : OrdersModal
		}
	};
</script>

<style type="text/css">
  .order-type{
    /*width:15% !important;*/
    word-break: break-all;
  }
  .order-credit{
    /*width:10% !important;*/
    word-break: break-all;
  }
  .order-amount{
    /*width:15% !important;*/
    word-break: break-all;
  }
  .order-name{
    /*width:20% !important;*/
    word-break: break-all;
  } 
  .order-date{
     /*width:15% !important;*/
    word-break: break-all;
  }
  .order-status{
     /*width:10% !important;*/
    word-break: break-all;
  }

  .order-pack .VueTables .table-responsive {
    overflow-x: scroll;
  }

  .order-pack .VueTables .table-responsive > table{
    width : max-content;
    min-width : 100%;
    max-width : max-content;
  }
  #delete_btn{
    margin-right: 10px !important;
  }
</style>