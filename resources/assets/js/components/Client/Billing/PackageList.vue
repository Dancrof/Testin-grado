<template>
  
  <div id="main-div" :class="{rtl : lang_locale == 'ar'}">

    <meta-component :dynamic_title="lang('packages')" :layout="layout" >
        
    </meta-component>

    <div v-if="renderingData" class="row">

      <loader :animation-duration="4000" :size="60" :color="layout.portal.client_header_color"/>
    </div>

    <div v-if="pageChange" class="row">

      <client-panel-loader :size="60" :color="layout.portal.client_header_color"></client-panel-loader>
    </div>

    <alert componentName="PackageList" />

    <div v-if="!renderingData" class="row" id="filter">

      <div class="col-md-6">

        <div class="col-md-3 col-sm-3" v-if="bigTotalItems > 10" :class="{right : lang_locale == 'ar'}">

          <select class="form-control" v-model="itemPerPage" @change="handleCount(itemPerPage)" :style="inputStyle" id="bill_pack_list_count">

            <option value="10">10</option>
            <option value="25">25</option>
            <option value="50">50</option>
            <option value="100">100</option>
          </select>
        </div>
      </div>
      
      <div class="col-md-5 offset-1">

        <div class="col-md-10 col-sm-10 float-end" :class="{left : lang_locale == 'ar'}">

          <input type="text" :placeholder="lang('search_here')" class="form-control search-field" v-model="searchText" v-on:keyup.enter="searchPackage()" :style="inputStyle" id="bill_package_search">

          <span class="fa fa-search searchh" :class="{left1 : lang_locale == 'ar'}"></span>
        </div>
      </div>
    </div>

    <div v-if="!renderingData" class="row">

      <div class="container">

        <div class="features row">

          <div class="col-sm-3" v-for="(item,index) in packageListArr" :class="{float1 : lang_locale == 'ar'}"
            :key="index" >

            <div class="banner-wrapper text-center custom-pkg-wrapper">

              <span class="fa-stack fa-3x">

                <i>
                  <!--Faveo ke purvajon Bhagwaan iskliye tumhe kabhi maaf nhi krega-->
                  <img :src="item?.attach?.view_url||defaultImage" alt="" class="img-circle pack_image">
                </i>
              </span><br> 

              <h4 class="package_name text-break mt-4">{{(item.name)}}</h4>

              <div class="banner-content">

              
                <p :title="getFormattedCurrency(item.price)">{{lang("price")}}:
                  <b>{{subString(getFormattedCurrency(item.price),10)}}</b>
                </p>
                
                <p>{{lang("validity")}}: <b>{{item.validity ? lang(item.validity) : lang('one_time')}}</b></p>
                
                <p :title="item.allowed_tickets" class="h-40">{{lang("allowed_tickets")}}: <b>{{item.allowed_tickets}}</b>&nbsp;{{item.period}}</p>
              
              </div>
                <div>
                  <div @click="handleBuyNowClick(item.id)" :id="'bill_pack_buy-'+index">
                    <router-link :to="!Array.isArray(auth.user_data) ? '/package/'+item.id : 'auth/login'" class="btn btn-custom" :style="btnStyle">
                      <span class="fa fa-cart-plus"></span>&nbsp;{{lang('buy_now')}}
                    </router-link>
                  </div>
                </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="!renderingData && packageListArr.length === 0">
      
      <h3 style="text-align:center">{{lang('no-data-to-show')}}</h3>
    </div>

    <div :class="{left: lang_locale == 'ar'}" class="float-end" v-if="bigTotalItems > 8 && !renderingData">
              
      <uib-pagination :records="bigTotalItems" v-model="paginationObj" class="pagination" :boundary-links="true" :per-page="itemPerPage" @paginate="pageChanged()" :options="{chunk:3, chunksNavigation:'scroll'}">
                
      </uib-pagination>
    </div>
  </div>
</template>

<script>

import axios from 'axios';

import { errorHandler } from "../../../helpers/responseHandler";

import { currencyFormatter, lang, customDelay, getSubStringValue } from '../../../helpers/extraLogics';

import Loader from '../../../components/Client/ClientPanelLayoutComponents/ReusableComponents/Loader.vue';

export default {

  name : '',

  description : '',

  props : {

    layout : { type : Object, default : ()=>{}},

    auth : { type : Object, default : ()=>{}},
  },

  components: {

    'client-panel-loader' : Loader,

  },

  data(){
    return {
      
      pageChange : false,

      renderingData: true,
      
      paginationObj: 1,
      
      bigTotalItems: 0,
      
      itemPerPage: 10,
      
      packageListArr: [],
      
      searchText: '',
      //Faveo ke purvajon Bhagwaan iskliye tumhe kabhi maaf nhi krega
      defaultImage:'',

      btnStyle : {

        borderColor : this.layout.portal.client_button_border_color,
	      color : this.layout.portal.client_button_font_color + ' !important',
        backgroundColor : this.layout.portal.client_button_color,
      },

      inputStyle: {
      
        borderColor : this.layout.portal.client_input_field_color
      },

      lang_locale : this.layout.language
    }
  },

  beforeMount() {

    this.$Progress.start();

    this.getDataFromAPi();

    this.defaultImage = this.basePathVersion()+"/themes/default/client/images/package.png";
  },

  methods: {

    handleBuyNowClick(packageId) {
      const path =  '/package/' + packageId
      localStorage.setItem('redirectPath', path);
    },

    subString(value,length = 5){
      
      return getSubStringValue(value,length)
    },

    getPackageImageUrl(imageName){
    
     if(imageName){

        return this.commonPath + "/" + imageName;
    
      } else {

        return this.basePathVersion()+"/themes/default/client/images/package.png";
      }
    },

    getFormattedCurrency(value) {
      return value==0 ? lang('free'): currencyFormatter(value, this.layout.billing_settings.currency, this.lang_locale,)
    },

    getDataFromAPi(){
      this.$Progress.start();
      axios.get('bill/package/get-active-packages', {
        params: {
          "sort-field": "display_order",
          "sort-order": "asc", // 'asc' or 'desc'
          "search-query": this.searchText,
          page: this.paginationObj,
          limit: this.itemPerPage
        }
      })
      .then(res => {
        this.packageListArr = res.data.data.data;
        this.bigTotalItems = res.data.data.total;
        this.commonPath = res.data.data.imageurl;
        this.renderingData = false;
        this.pageChange = false;
        this.$Progress.finish();
      })
      .catch(err => {
        this.renderingData = false;
        this.pageChange = false;
        errorHandler(err)
        this.$Progress.fail();
      })
    },

    searchPackage() {

      this.pageChange = true;
      
      this.paginationObj = 1;

      let _this = this;

      customDelay(function(){ _this.getDataFromAPi() }, 1000);
    },

    handleCount(payload){
      
      this.pageChange = true;

      this.paginationObj = 1;
        
      this.itemPerPage = parseInt(payload);

      this.getDataFromAPi();
    },

    pageChanged() {
        
      this.pageChange = true;

      this.paginationObj=this.paginationObj;
      
      this.getDataFromAPi();

      var elmnt = document.getElementById('filter');
        
      elmnt.scrollIntoView({ behavior : "smooth"});
    },
  }
};
</script>

<style scoped>
  #filter{
    margin-left: -30px;
    margin-right: -30px;
  }
  .pack_image{
    width: 100px !important;
    height: 100px !important;
    border: 2px solid #d4d1d1;
  }

  .features .banner-wrapper:hover {
      border-color: #b1aeae !important;
  }

  .features .banner-wrapper {
    background-color: #f5f2f2 !important;
  }
  .searchh{
    margin-top: -24px;
    margin-right: 15px;
    color: #afb2b4 !important;
    float : right;
  }
  .img-circle {
    border-radius: 50%;
  }
  .banner_h3{
    margin-top: 20px;
    word-break: break-word;
  }
  .package_name{
    height: 57px;
  }

  .h-40{ height: 40px; }

  .custom-pkg-wrapper {
	  height: 390px;
  }
</style>


