<template>

  <div id="main-div" :class="{rtl : lang_locale == 'ar'}">
    
    <meta-component :dynamic_title="lang('package')" :layout="layout" >
        
    </meta-component>

    <div class="row" v-if="renderingData">

      <loader :animation-duration="4000" :size="60" :color="layout.portal.client_header_color"/>
    </div>
    
    <alert componentName="Packageview"/>

    <div v-if="!renderingData" id="content" class="site-content col-md-12">
      
      <header class="archive-header" :class="{align1 : lang_locale === 'ar'}">
        
        <h1 class="archive-title">{{lang('selected_package')}}</h1>
      </header>

      <div class="archive-list archive-news">

        <article class="hentry">
      
          <header class="entry-header">
            
            <img :src="packDetail.package_pic.path ? packDetail.package_pic.path : defaultImage"
              alt="" class="pack_img entry-thumbnail float-start" :class="{float1 : lang_locale === 'ar'}">
            
            <h2 class="entry-title h3" :class="{align1 : lang_locale === 'ar'}">
              <a :style="linkStyle" rel="bookmark">{{packDetail.name}}</a>
            </h2>
          </header>

          <footer class="entry-footer" :class="{align1 : lang_locale === 'ar'}">
            
            <div class="entry-meta text-muted">
              
              <small class="date"><i class="far fa-calendar fa-fw icon_space"></i>

                <time datetime="2013-10-22T20:01:58+00:00">{{formattedTime(packDetail.updated_at)}}</time>
              </small>

              <small :title="lang('validity')" class="date"><i class="far fa-clock fa-fw icon_space"></i>

                <time>{{lang(packDetail.validity ? packDetail.validity : 'one_time')}}</time>
              </small>

              <small :title="lang('allowed_tickets')" class="date"><i class="fa fa-ticket fa-fw icon_space"></i>

                <time>{{packDetail.allowed_tickets}}</time>
              </small>

              <small :title="lang('price')" class="date"><i class="far fa-money-bill-alt icon_space"></i>

                <time datetime="2013-10-22T20:01:58+00:00">{{getFormattedCurrency(packDetail.price)}}</time>
              </small>
              
            </div>
          </footer>

          <div class="entry-summary clearfix">
            
            <p :class="{align1 : lang_locale === 'ar'}">{{packDetail.description}}</p>
            
			  <p :class="[(lang_locale === 'ar') ? 'text-end' : 'text-start']"></p>


            <div class="container">
                 <input id= "org-check" type="checkbox" class="cursor-pointer" v-on:click="toggleOrganizationSelectFieldVisibility()" title=" Order for whole Organization"> &nbsp;{{lang('purchase_for_an_organization')}}


            <div  v-if="orgOrder" class="row">
                   <dynamic-select placeholder= "Select an Organization" class="col-md-8"  :multiple="false" name="orgId" :prePopulate="true"
                                   apiEndpoint="/bill/package/get-organization-list" :value="orgName" :inputStyle="inputStyle" :onChange="onChange">
                   </dynamic-select>

               </div>
            </div>

              <template v-if="packDetail.kb_link">

                <input type="checkbox" v-on:click="checkboxClickEvent()" title="Accept terms & conditions" 
                v-model="checkboxStatus" id="bill_terms">&nbsp;
              
                <a :href="packDetail.kb_link" target="_blank" :style="linkStyle" id="bill_kb_link">{{lang("terms_conditions")}}</a>
  
              </template>
              
              <router-link tag="button" :to="'/checkout/' + 'CO-' + packageId + '?orgId=' + orgId " >
				<button :disabled="!(checkboxStatus && orgSelectionStatus)" class="btn btn-custom float-end check_btn" id="bill_pack_checkout" :style="btnStyle" :class="{left : lang_locale == 'ar'}">
					<i class="fa fa-forward"></i> {{lang("checkout")}}&nbsp;
				</button>
              </router-link>
          </div>
        </article>
	  </div>
	</div>
  </div>
</template>

<script>
  
  import axios from 'axios';
  
  import { errorHandler } from "../../../helpers/responseHandler";
  
  import { currencyFormatter, lang } from '../../../helpers/extraLogics';

  import { mapGetters } from 'vuex';
  import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";

  import Loader from '../../../components/MiniComponent/Loader.vue'

  export default {

    props : {

      layout : { type : Object, default : ()=>{}},

      auth : { type : Object, default : ()=>{}},

      someUnrelatedVar : { type : [String, Number], default : ''},
    },

    components: {
      DynamicSelect,
     
      "custom-loader": Loader
    },

    data(){
     
      return {
     
        packageId: this.$route.params.id,

        orgId : '',

        orgName : '',

        orgOrder : false,

        renderingData: true,
     
        packDetail: '',
     
        checkboxStatus: false,

        defaultImage : '',

        lang_locale : this.layout.language,

        btnStyle : {

          borderColor : this.layout.portal.client_button_border_color,
	        color : this.layout.portal.client_button_font_color + ' !important',
          backgroundColor : this.layout.portal.client_button_color,
        },

	    inputStyle: {
		      borderColor : this.layout.portal.client_input_field_color,
	    },

        linkStyle : {
          color : this.layout.portal.client_header_color,
        },

        orgSelectionStatus : true,
      }
    },

    computed : {

      ...mapGetters(['formattedTime'])
    },

    beforeMount() {
      
      this.$Progress.start();

      this.getDataFromAPi();

      this.defaultImage = this.auth.system_url +'/'+ this.appVersion  + '/themes/default/client/images/package.png';
    },

    methods: {
      
      getDataFromAPi(){

        axios.get('bill/package/user-package-info/' + this.packageId, {}).then(res => {

          this.packDetail = res.data.data;
          
          if(!this.packDetail.kb_link){
            
            this.checkboxStatus = true;
          }
          
          this.renderingData = false;

          this.$Progress.finish();
        }).catch(err => {
          
          this.renderingData = false;
          
          errorHandler(err,'PackageList');
          
          this.$router.push({ path:'/billing-package-list'});

          this.$Progress.fail();
        })
      },

      getFormattedCurrency(value) {
        
        return value==0 ? lang('free'): currencyFormatter(value,this.layout.billing_settings.currency,this.lang_locale,)
      },

      checkboxClickEvent(){
        
        this.checkboxStatus = this.checkboxStatus;
      },

      toggleOrganizationSelectFieldVisibility(){
        this.orgSelectionStatus = !this.orgSelectionStatus;
        this.orgOrder = !this.orgOrder;
        this.orgId = '';
        this.orgName = '';
      },

      onChange(value) {
        this.orgSelectionStatus = !(value === null);
        this.orgId = value.id;
        this.orgName = value.name
      },
    },
  };
</script>

<style scoped>

  .img-circle{
    border: 2px solid #ccccc8 !important;
    width: 130px !important;
    height: 130px !important;
    border-radius: 0px !important;
  }
  .control-label {
    font-weight: 500;
    text-align: left;
    word-break: break-all;
  }

  .pack_img{
    width: 200px;
    height: 200px;
  }

  .check_btn{
    margin-bottom: 20px;
  }

  .icon_space{
    margin-right: 2px;
  }
  
  .cursor-pointer{
    cursor: pointer;
  }
</style>


