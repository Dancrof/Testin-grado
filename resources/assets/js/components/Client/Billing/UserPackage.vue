<template>

  <div :class="{'rtl align1' : lang_locale == 'ar'}">

    <meta-component :dynamic_title="lang('user_packages')" :layout="layout" >

    </meta-component>

    <alert componentName="UserPackage"/>

    <header class="archive-header" :class="{align1 : lang_locale == 'ar'}">

      <h3 class="archive-title">{{lang('my_packages')}}</h3>
    </header>


    <div :class="[{'card card-light ' : !from}]">

      <div v-if="from != 'tab'" class="card-header">

        <h3 class="card-title">{{lang('personal_packages')}}</h3>
      </div>

      <div class="my_bill_table" :class="[{'card-body' : !from}]">

        <data-table v-if="dataTableOptions" :url="apiUrl" :dataColumns="dataTableColumns" :option="dataTableOptions"
                    :color="layout.portal.client_header_color" :input-style="{ borderColor : layout.portal.client_input_field_color}" >

        </data-table>
        <div v-if="loading" class="row">

          <loader :animation-duration="4000" color="#1d78ff" :size="60"/>

        </div>
      </div>
    </div>

    <br><br>

    <div :class="[{'card card-light ' : !from}]">

      <div v-if="from != 'tab'" class="card-header">

        <h3 class="card-title">{{lang('org_packages')}}</h3>
      </div>

      <div class="my_bill_table" :class="[{'card-body' : !from}]">

        <data-table v-if="dataTableOptions" :url="apiEndPoint" :dataColumns="dataTableColumns" :option="dataTableOptions"
                    :color="layout.portal.client_header_color" :input-style="{ borderColor : layout.portal.client_input_field_color}" >

        </data-table>
        <div v-if="loading" class="row">

          <loader :animation-duration="4000" color="#1d78ff" :size="60"/>

        </div>
      </div>
    </div>

    <transition  name="modal">

      <order-info-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :id="id" :layout="layout">

      </order-info-modal>
    </transition>
  </div>
</template>

<script type="text/javascript">

  import { lang } from '../../../helpers/extraLogics';

  import { mapGetters } from 'vuex'

  import DataTable from "../../Extra/DataTable.vue";

  import OrderInfo from "./OrderInfo.vue";

  export default {

    name: "package-list",

    description: "will list all the packages available",

    props : {
      from : { type : String, default : '' },

      layout : { type : Object, default : ()=>{}},

      auth : { type : Object, default : ()=>{}},
    },

    data(){
		  return {

        apiUrl: "bill/package/get-user-packages",

        apiEndPoint:"bill/package/get-organization-packages",

        dataTableColumns: ["name", "invoice_id", "validity", "credit_type", "credit", "expiry_date",'period_expiry_date', "orderId"],

        dataTableOptions: null,

        showModal : false,

        loading:false,

        id : null,

        lang_locale : this.layout.language
      }
    },

    computed:{

      ...mapGetters(['formattedTime','formattedDate'])
    },

    beforeMount() {

      this.$Progress.start();

      if(this.$route.query && this.$route.query.error){

        this.$store.dispatch('setAlert',{type:'danger',message:this.$route.query.error, component_name : 'UserPackage'})

      } else if(this.$route.query && this.$route.query.success){

        this.$store.dispatch('setAlert',{type:'success',message:this.$route.query.success,component_name:'UserPackage'})
      }

      let _this = this;

      this.dataTableOptions = {

        headings: {

          name: lang("name"),

          validity: lang("billing_cycle"),

          expiry_date: lang("expiry_date"),

          period_expiry_date: lang("period_expiry_date"),

          credit_type : lang("credit_type"),

          credit: lang("ticket_credit"),

          invoice_id: lang("invoice_id"),

          orderId: lang("order")
        },

        templates: {

          invoice_id: function(createElement, row) {

            return _this.h('a', {
                href:'javascript:;',
                onClick(event) {
                    _this.$router.push('/invoice/' + row.invoice.id)
                },
                style : `color:${_this.layout.portal.client_header_color}`

            }, "#" + row.invoice.id);
          },

          orderId: function(createElement, row) {

            return _this.h('a', {
                href: 'javascript:;',
                style : `color:${_this.layout.portal.client_header_color};text-decoration:underline`,
                onClick(event){
                   _this.showModal = true;
                  _this.id = row.id
                }
            }, lang('view_order'));
          },

          expiry_date(h, row) {

            return _this.formattedTime(row.expiry_date);
          },

            period_expiry_date(h, row) {

            return row.period_expiry_date ? _this.formattedTime(row.period_expiry_date) : '--';
          },
          validity(h, row) {

            return row.validity === "semi_annually" ? "Semi annually" : row.validity;
          },
        },

        sortIcon: {

          base : 'glyphicon',

          up: 'glyphicon-chevron-down',

          down: 'glyphicon-chevron-up'
        },

        sortable: ["credit", "expiry_date"],

        filterable: false,

        pagination:{chunk:5,nav: 'fixed',edge:true},

        texts: { filter: '', limit: ''},

        requestAdapter(data) {

          return {

            'sort-field': data.orderBy ? data.orderBy : 'id',

            'sort-order': data.ascending ? 'desc' : 'asc',

            'search-query': data.query.trim(),

            page:data.page,

            limit:data.limit,
          }
        },

        responseAdapter({data}) {


          _this.$Progress.finish();

          return {

            data: data.data.data.map(data => {

            data["credit"] = data.credit;

            data["name"] = data.package.name;

            data["validity"] = data.package.validity ? data.package.validity : lang("one_time");

            data["expiry_date"] = data.expiry_date;

            return data;
          }),

          count: data.data.total
          }
        },

	      orderBy: { column: 'id', ascending: true },
      }
    },

    methods : {

      onClose(){

        this.showModal = false;
      },
    },

    components: {

      'data-table' : DataTable,

      'order-info-modal' : OrderInfo,
    },
  };
</script>

<style>

.my_bill_table .VueTables .table-responsive {
	overflow-x: auto;
}

.my_bill_table .VueTables .table-responsive > table{
	width : max-content;
	min-width : 100%;
	max-width : max-content;
	overflow: auto !important;
}
</style>


