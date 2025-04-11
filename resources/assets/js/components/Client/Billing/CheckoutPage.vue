<template>

  <div id="main-div" :class="{rtl : lang_locale == 'ar'}">

    <meta-component :dynamic_title="lang('checkout')" :layout="layout" >

    </meta-component>

    <div class="row" v-if="renderingData">

      <loader :animation-duration="4000" :size="60" :color="layout.portal.client_header_color"/>
    </div>

    <alert componentName="CheckoutPage" />

    <section class="section" v-if="!renderingData">

      <header class="archive-header" :class="{align1 : lang_locale == 'ar'}">

        <h3 class="archive-title">{{'#'+invoiceDetail.id}}</h3>
      </header>

      <div class="row">

        <div class="col-md-12 check_out">

          <button type="button" :class="{left : lang_locale == 'ar'}" class="btn btn-custom"
            @click="printDiv('printablediv')" :style="btnStyle" id="bill_checkout_print">

            <i class="fa fa-print"></i> {{lang("print")}}
          </button>

          <button type="button" :class="{left1 : lang_locale == 'ar'}" class="btn btn-custom" @click="downloadPDF()"
            :style="btnStyle" id="bill_checkout_pdf">

            <i class="far fa-file-pdf"></i> {{lang("generate_pdf")}}
          </button>
        </div>

        <div class="col-md-12" id="printablediv">

          <div class="d-flex" id="check_row">

            <div class="col-md-4">

              <div class="widget-area" id="check_wid">

                <section id="section-about" class="section">

                  <h2 class="section-title h4 clearfix" :class="{align1 : lang_locale == 'ar'}">

                    <i class="line" :style="lineStyle"></i>{{lang("from")}}
                  </h2>

                  <div class="textwidget" :class="{align1 : lang_locale == 'ar'}">

                    <p><b>{{invoiceDetail.from.name ? invoiceDetail.from.name : 'Helpdesk'}}</b></p>

                    <p><b>{{ lang("phone") }} : </b>
                      <span v-if="invoiceDetail.from.phone">
                        {{ invoiceDetail.from.phone_country_code ? '+' + invoiceDetail.from.phone_country_code : '' }} {{ invoiceDetail.from.phone }}
                      </span>
                      <span v-else>
                        {{ lang('not_mentioned') }}
                      </span>
                    </p>

                    <p><b>{{lang("address")}} : </b>

                      <span v-if="invoiceDetail.from.address" v-html="invoiceDetail.from.address"></span>

                      <span v-else>{{ lang('not_mentioned') }}</span>
                    </p>
                  </div>
                </section>
              </div>
            </div>

            <div class="col-md-4">

              <div class="widget-area" id="check_wid">

                <section id="section-about" class="section">

                  <h2 class="section-title h4 clearfix" :class="{align1 : lang_locale == 'ar'}">

                    <i class="line" :style="lineStyle"></i>{{lang("to")}}
                  </h2>

                  <div class="textwidget" :class="{align1 : lang_locale == 'ar'}">

                    <p><b>{{getClientName}}</b></p>

                    <p><b>{{lang("email")}} : </b>
                      <span> {{getEmailAdd ? getEmailAdd : lang('not_mentioned')}}</span>
                    </p>

                    <p><b>{{lang("phone")}} : </b>
                      <span> {{getPhoneNumber ? getPhoneNumber : lang('not_mentioned')}}</span>
                    </p>
                  </div>
                </section>
              </div>
            </div>

            <div class="col-md-4">

              <div class="widget-area" id="check_wid">

                <section id="section-about" class="section">

                  <h2 class="section-title h4 clearfix" :class="{align1 : lang_locale == 'ar'}">

                    <i class="line" :style="lineStyle"></i>{{lang("invoice_details")}}
                  </h2>

                  <div class="textwidget" :class="{align1 : lang_locale == 'ar'}">

                    <p v-if="!invoiceDetail.order.status" class="text-danger"><b id="f-30">{{lang("unpaid")}}</b>
                    </p>

                    <p v-else class="text-success"><b id="f-30">{{lang("paid")}}</b></p>

                    <p><b>{{lang("invoice_id")}} : </b> <span>{{'#'+invoiceDetail.id}}</span></p>

                    <p><b>{{lang("creation-date")}} : </b><span>{{formattedTime(invoiceDetail.created_at)}}</span></p>

                    <p><b>{{lang("due_date")}} : </b><span>{{formattedTime(invoiceDetail.due_by)}}</span></p>

                    <p v-if="invoiceDetail.order.status == 1">
                      <b>{{lang("paid_date")}} : </b><span>{{invoiceDetail.paid_date ? formattedTime(invoiceDetail.paid_date) : formattedTime(invoiceDetail.created_at)}}</span>
                    </p>
                  </div>
                </section>
              </div>
            </div>
            <div class="clearfix"></div>
            <hr>
          </div>

          <div class="d-flex" id="check_row">

            <div class="well table-responsive">

              <h4 class="text-uppercase" id="check_pack" :class="{align1 : lang_locale == 'ar'}">{{lang('package')}}</h4>

              <table class="table table-strip" :class="{align1 : lang_locale == 'ar'}">

                <thead>
                  <tr>
                    <th :class="{align1 : lang_locale == 'ar'}">{{lang('name')}}</th>
                    <th :class="{align1 : lang_locale == 'ar'}">{{lang('description')}}</th>
                    <th :class="{align1 : lang_locale == 'ar'}">{{lang('validity')}}</th>
                    <th :class="{align1 : lang_locale == 'ar'}">{{lang('price')}}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td id="pack_data">{{invoiceDetail.order.package.name}}</td>
                    <td id="pack_data">{{invoiceDetail.order.package.description}}</td>
                    <td  id="pack_data">
                      {{ invoiceDetail.order.package.validity? invoiceDetail.order.package.validity == 'semi_annually' ? 'Semi annually' : invoiceDetail.order.package.validity : lang('one_time') }}
                    </td>
                    <td id="pack_data">{{getFormattedCurrency(invoiceDetail.total_amount)}}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div class="d-flex" id="check_row">

            <div class="well table-responsive">

              <h4 id="check_pack" class="text-uppercase" :class="{align1 : lang_locale == 'ar'}">{{lang('payment_details')}}</h4>

              <table class="table" :class="{align1 : lang_locale == 'ar'}">

                <tbody>

                  <tr>
                    <th style="width: 50%;" :class="{align1 : lang_locale == 'ar'}">{{lang('paid_amount')}} : </th>
                    <td>{{getFormattedCurrency(invoiceDetail.amount_paid)}}</td>
                  </tr>

                  <tr>
                    <th style="width: 50%;" :class="{align1 : lang_locale == 'ar'}">{{lang('balance')}} : </th>
                    <td>{{getFormattedCurrency(invoiceDetail.total_amount - invoiceDetail.amount_paid)}}</td>
                  </tr>

                  <tr>
                    <th :class="{align1 : lang_locale == 'ar'}">{{lang('total')}} :</th>
                    <td>{{getFormattedCurrency(invoiceDetail.total_amount)}}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div class="row form-inline" :class="[(lang_locale === 'ar') ? 'float-start' : 'float-end']" >

            <div v-if="invoiceDetail.order.status == 0">

              <select name="paymen-gettway" class="form-select payment-select d-inline" @change="updateSelectedGateWay($event)"
              :style="inputStyle" id="bill_pay_ways">

                <option selected >{{lang("select_payment_method")}}</option>

                <option v-for="item in paymentGetwayArr" :value="item.gateway_name ? item.gateway_name : item.name"
                  :key="item.name" :id="'bill_pay'+item.gateway_name">{{item.name}}
                </option>
              </select>

              <a class="btn btn-custom ms-2" :href="checkoutLink" :class="{ 'disabled': disablePay  }" :disabled="disablePay" id="bill_invoice_pay_now" :style="btnStyle">
                <i class="far fa-money-bill-alt ms-2"></i> &nbsp;{{lang("pay_now")}}
              </a>


            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>

  import axios from 'axios';

  import { errorHandler } from "../../../helpers/responseHandler";

  import { currencyFormatter } from '../../../helpers/extraLogics';

  import { mapGetters } from 'vuex'

  export default {

    props :{

      layout : { type : Object, default : ()=>{}},

      auth : { type : Object, default : ()=>{}},
    },

    data(){
      return {

        packageId: this.$route.params.id,

        orgId : this.$route.query.orgId,

        renderingData: true,

        invoiceDetail: {},

        paymentGetwayArr: {},

        selectedPaymentGetWay: '',

        transaction_id: '',

        checkoutLink: '',

        disablePay: true,

        lang_locale : this.layout.language,

      btnStyle : {

          borderColor : this.layout.portal.client_button_border_color,
            color : this.layout.portal.client_button_font_color + ' !important',
          backgroundColor : this.layout.portal.client_button_color,
        },

        inputStyle: {

          borderColor : this.layout.portal.client_input_field_color
        },

        lineStyle: {

          borderColor : this.layout.portal.client_header_color
        },
      }
    },

    computed: {

      getClientName: function() {

        let name = this.auth.user_data.full_name;

        if (name && name === "") {

          name = this.auth.user_data.user_name;
        }
        return " " + name;
      },

      getEmailAdd: function() {

        let email = this.auth.user_data.email;

        return email ? " " +  email : "";
      },

      getPhoneNumber: function() {
        let phone = this.auth.user_data.phone_number;
        let phone_country_code = this.auth.user_data.phone_country_code;
        let ext = this.auth.user_data.ext;
        let formattedPhone = phone && phone !== "Not available"
            ? "+" + (phone_country_code && phone_country_code !== "Not available" ? phone_country_code + " " : "") + phone + (ext ? '-' + ext : '')
            : "";
        return formattedPhone;
      },

      ...mapGetters(['formattedTime','formattedDate'])
    },

    beforeMount() {

      this.$Progress.start();

      this.getDataFromAPi();
    },

    methods: {


      getDataFromAPi(){

        axios.get('bill/get-gateways-list', { params:{ "active": 1, }}).then(res => {

          this.paymentGetwayArr = res.data.data.data;

          this.paymentGetwayArr.forEach(element => {

            if(element.is_default === 1) {

              this.paymentGetWayName = element.gateway_name;
            }
          });

          if(!this.selectedPaymentGetWay) {

            this.paymentGetWayName = this.paymentGetwayArr[0].gateway_name;
          }
        })
        .catch(err => {

          errorHandler(err);

          this.$Progress.fail();
        })
        axios.get('bill/package/user-checkout', {
          params: this.apiParams()
        }).then(res => {
          this.invoiceDetail = res.data.data;

          this.transaction_id = res.data.data.transaction_id;

          this.renderingData = false;

          this.$Progress.finish();
        }).catch(err => {

          this.renderingData = false;

          errorHandler(err,'CheckoutPage')

          this.$Progress.fail();
        })
      },

      getFormattedCurrency(value) {

        return currencyFormatter(value, this.layout.billing_settings.currency, this.lang_locale,)
      },

      printDiv(divName){

        var winPrint = window.open('', '', 'left=0,top=0,width=800,height=600,toolbar=0,scrollbars=0,status=0');

        winPrint.document.write(document.getElementById(divName).innerHTML);

        winPrint.document.close();

        winPrint.focus();

        winPrint.print();
        //Setting timeout to avoid conflict created by extensions which crashes the window before printing
        setTimeout(function(){
          winPrint.close();
        }, 5)
      },

      downloadPDF() {

        axios.get(window.axios.defaults.baseURL + '/invoice/pdf/' + this.invoiceDetail.id)

            .then(res=>{

              res? window.open(window.axios.defaults.baseURL + '/invoice/pdf/' + this.invoiceDetail.id) : '';

            }).catch(err =>{

          errorHandler(err,'CheckoutPage');
        })
      },

      apiParams(){
        let params = {
          "package_id": this.packageId.split("-")[1],
          "user_id": this.auth.user_data.id,
        }

        if(this.orgId && this.orgId != ''){
          params.organization_id = this.orgId;
        }

        return params;
      },

      updateSelectedGateWay(event) {
        this.paymentGetWayName = event.target.value;

        this.checkoutLink = window.axios.defaults.baseURL + "/checkout/" + this.paymentGetWayName + "/" + this.transaction_id;

        this.disablePay = (this.paymentGetWayName === 'Bank Transfer' || this.paymentGetWayName === 'Cash') ? false : true;
      }
    }
  };
</script>

<style scoped>
  .form-control{
    display: inline-block;
    width: 20%;
  }
  .check_out{
    margin-bottom: 20px !important;
    text-align: right !important;
  }
  h2{
    margin: 0px 0px 10px 0px !important;
  }
  #inv_address{
    word-break: break-all;
  }
  #pack_data{
    width: 25% !important;
    word-break: break-all;
  }
  #pay{
    margin-top: -5px !important;
  }
  #check_row{
    background: #f2f2f2;
    border-radius: 5px;
    margin-bottom: 20px;
  }
  #check_wid{
    padding: 10px;
	  padding-top: 20px;
	  padding-left: 20px;
  }
  #check_pack{
    padding-top: 10px;
    padding-left: 10px;
  }
  .table-strip{
    border-collapse: collapse !important;
  }
  #f-30{
    font-size: 30px;
  }
  .disabled {
    pointer-events: none;
    opacity: 0.5;
    cursor: not-allowed;
  }

  .form-inline .payment-select{
    width: auto;
  }

</style>