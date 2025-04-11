<template>
  
  <div :class="{'rtl align1' : lang_locale == 'ar'}">
    
    <meta-component :dynamic_title="lang('user_invoices')" :layout="layout" >
        
    </meta-component>

    <alert componentName="UserInvoice"/>
    
    <header class="archive-header" id="invoices" :class="{align1 : lang_locale == 'ar'}">
          
      <h3 class="archive-title">{{lang('user_invoices')}}</h3>
    </header>

    <data-table v-if="dataTableOptions" :url="apiUrl" :dataColumns="dataTableColumns" :option="dataTableOptions"
      :color="layout.portal.client_header_color" :inputStyle="inputStyle" scroll_to="invoices">
      
    </data-table>
  </div>
</template>


<script type="text/javascript">

  import { lang } from '../../../helpers/extraLogics';
  
  import { currencyFormatter } from '../../../helpers/extraLogics';
  
  import { mapGetters } from 'vuex'

  import DataTable from "../../Extra/DataTable.vue";
  import DataTableActions from "../../MiniComponent/DataTableComponents/DataTableActions.vue";

  export default {
    
    name: "user-invoice",
    
    description: "will list all the invoices of an user",

    props : {

      layout : { type : Object, default : ()=>{}},

      inputStyle : { type : Object, default : ()=>{}},

      auth : { type : Object, default : ()=>{}},
    },

    data(){
  		
      return {
        
        apiUrl: "bill/package/get-user-invoice",

        dataTableColumns: ["name", "created_at", "due_by", "total_amount", "status", "action"],

        dataTableOptions: null,

        lang_locale : this.layout.language,

	      inputStyle: {

		      borderColor : this.layout.portal.client_input_field_color,
	      },
      }
    },

    computed:{
    
      ...mapGetters(['formattedTime','formattedDate'])
    },

    beforeMount() {
      const self = this;
      this.$Progress.start();

      let _this = this;

      this.dataTableOptions = {

      	headings: {

          name: lang("invoice_id"),

          created_at: lang("created_at"),

          due_by : lang("due_by"),

          status: lang("status"),

          total_amount: lang("total_amount"),

          action: lang("action")
        },

        sortIcon: {

          base : 'glyphicon',

          up: 'glyphicon-chevron-down',

          down: 'glyphicon-chevron-up'
        },

				templates: {

          type(h,row){

          	return row.type.name
          },

          created_at(h, row) {

            return _this.formattedTime(row.created_at);
          },

          due_by(h, row) {

            return _this.formattedTime(row.due_by);
          },

          status: function(createElement, row) {

              let span = _this.h('span', {
                  'class' : row.order.status === 1 ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'
              },row.order.status === 1 ? 'Paid' : 'Unpaid');

              return _this.h('a', {
                  class: 'pointer_normal'
                  }, [span]
              )
          },
          action: (f, row) => {
            if (row.order.status !== 1) {
              return self.h(DataTableActions, { data: row });
            } else {
              return self.h(DataTableActions, { data: row, isAdminEditOrDeleteEnabled: true, });
            }
          },

          name: function(createElement, row) {

            return _this.h('a', {
                href : 'javascript:;',
                onClick(event) {
                    _this.$router.push('/invoice/' + row.id)
                },
                style : `color:${_this.layout.portal.client_header_color}`,
                id : 'bill_invoice_link'+row.id
            }, "Invoice#" + row.id);
          }
				},

        sortable: ["name", "created_at", "due_by", "total_amount", "status"],

        filterable: ["name", "created_at", "due_by", "total_amount"],

        pagination:{chunk:5,nav: 'fixed',edge:true},

        texts: { filter: '', limit: ''},

				requestAdapter(data) {

          return {

          	'sort-field': data.orderBy ? data.orderBy : 'name',

          	'sort-order': data.ascending ? 'desc' : 'asc',

          	'search-query':data.query.trim(),

          	page:data.page,

          	limit:data.limit,
					}
				},

        responseAdapter({data}) {

          this.$Progress.finish();

          return {

            data: data.data.data.map(data => {

              data.total_amount = _this.getFormattedCurrency(data.total_amount)

              data.delete_url = `bill/delete-user-invoice?invoice_ids=${data.id}`;

              data.alertComponentName= 'UserInvoice';

              return data;
            }),

            count: data.data.total
          }
        },

	      orderBy: { column: 'name', ascending: true },
      }
    },

    methods: {
      getFormattedCurrency(value) {
        return currencyFormatter(value, this.layout.billing_settings.currency, this.layout.language,)
      },
    },

    components: {

      'data-table' : DataTable
    },
  };
</script>

<style scoped>

</style>
