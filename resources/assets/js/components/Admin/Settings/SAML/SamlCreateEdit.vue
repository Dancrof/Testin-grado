<template>
  <div class="col-sm-12">

    <div class="row" v-if="loading">

      <custom-loader :duration="4000"></custom-loader>

    </div>

    <alert componentName="SingleSignOn"/>

      <div class="card card-light" v-if="hasDataPopulated">

        <div class="card-header">

          <h3 class="card-title">  {{ trans(title) }}</h3>

          <div class="card-tools">

            <a v-if="buttonVisible" id="view_sso" class="btn btn-tool" type="button"
               :href= "basePath()+ '/admin/single-sign-on/settings/'+id" :target="''"
               v-tooltip="trans('view')">

              <i class="fas fa-eye"> </i>
            </a>
          </div>
        </div>

        <div class="card-body">

          <div class="row" v-focus-first-input>

            <text-field id="provider" :label="lang('provider')" :hint="lang('provider_hint')" :value="provider" type="text" name="provider" :onChange="onChange" :placehold="lang('enter_a_value')"
                        classname="col-sm-6" :required="true">

            </text-field>

            <text-field id="entity_id" :label="lang('entity_id')" :hint="lang('entity_hint')" :value="entity_id" type="text" name="entity_id" :onChange="onChange" :placehold="lang('enter_a_value')"
                        classname="col-sm-6" :required="true">

            </text-field>

          </div>

          <div class="row">

            <text-field id="sso_url" :label="lang('sso_url')" :hint="lang('SSO_hint')" :value="sso_url" type="text" name="sso_url" :onChange="onChange" :placehold="lang('enter_a_value')"
                        classname="col-sm-6" :required="true">

            </text-field>

            <text-field id="entity_id" :label="lang('slo_url')" :hint="lang('SLO_hint')" :value="slo_url" type="text" name="slo_url" :onChange="onChange" :placehold="lang('enter_a_value')"
                        classname="col-sm-6" :required="true">

            </text-field>

          </div>

          <div class="row">

            <text-field id="certificate" :label="lang('certificate')" :value="certificate" type="text" name="certificate" :onChange="onChange" :placehold="lang('enter_a_value')"
                        classname="col-sm-6" :required="true">

            </text-field>

            <radio-button :options="radioOptions" :label="lang('status')" name="status" :value="status"
                          :onChange="onChange" classname="form-group col-sm-6" ></radio-button>
          </div>

          <div class="row">
            <div class="form-group col-sm-6">
                  <label for="status"> {{trans('automatic_logout')}} </label>
                  <status-switch name="automatic_logout" :value=this.automatic_logout :onChange="onChange" :bold="true">
                  </status-switch>
            </div>

            <div v-if="automatic_logout" class="col-sm-6">
              <text-field id="logoutTime" :label="lang('logout_time')" :value="logout_time" type="number" name="logout_time" :onChange="onChange" :placehold="lang('enter_a_value')"
                          :required="true">
              </text-field>
            </div>
          </div>
        </div>

        <div class="card-footer">

          <button id="submit_btn" class="btn btn-primary" @click="onSubmit()">
            <i :class="iconClass"></i> {{trans(btnName)}}
          </button>
        </div>
      </div>
    </div>

</template>

<script>

import { successHandler, errorHandler } from "../../../../helpers/responseHandler";

import {getIdFromUrl} from "../../../../helpers/extraLogics";

import axios from 'axios';

import { validateSingleSignOn } from "../../../../helpers/validator/singleSignOn";

import StatusSwitch from "../../../MiniComponent/FormField/Switch.vue";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
export default {
  name: "SamlCreateEdit",

  description : 'Saml create and edit page',

  components : {

    'status-switch' : StatusSwitch,

    "text-field": TextField,

    "radio-button": RadioButton,

  },
  data(){

    return{
      automatic_logout : false,

      logout_time: 0,

      loading: false,

      hasDataPopulated: false,

      id:'',

      iconClass : 'fas fa-save',

      btnName : 'save',

      provider:'',

      entity_id:'',

      sso_url:'',

      slo_url:'',

      certificate:'',

      status : 1,

      SP_entity_id : '',

      SP_ACS_url : '',

      login_url : '',

      buttonVisible : false,

      radioOptions:[{name:'enable',value:1},{name:'disable',value:0}],

      Edit : false,

	  providerName : null,

      url: '/api/SSO/create/'

    }
  },

  beforeMount(){

    const path = window.location.pathname;

    this.getValues(path);


  },

  methods:{

    getValues(path){

      const id = getIdFromUrl(path);

      if(path.indexOf('edit') >=0 ){

        this.iconClass =  'fas fa-sync';

        this.btnName = 'update';

        this.Edit = 'true';

        this.url = '/api/SSO/create/'+this.id;

        this.buttonVisible = true;

        this.getInitialValue(id);

      } else {

        this.loading = false;

        this.hasDataPopulated = true;
      }

    },

    onChange(value, name) {

      this[name] = value;

      if(name === 'automatic_logout' && value === false) {

        this.logout_time = 0;
      }

    },

    isValid() {

      const { errors, isValid } = validateSingleSignOn(this.$data);

      if (!isValid) {

        return false;
      }
      return isValid;
    },

    getInitialValue(id){

      this.loading = true;

      axios.get('/api/SSO/edit/'+id).then(res =>{

        this.hasDataPopulated = true;

	    this.loading = false;

        this.fillFieldsInfo(res.data.data);

		this.providerName = res.data.data.provider;

      }).catch(err=>{

        this.loading = false;

        errorHandler(err)
      })
    },


    fillFieldsInfo(data){

      const self =  this;

      const stateData = this.$data;

      Object.keys(data).map(key => {

        if (stateData.hasOwnProperty(key)) {

          self[key] = data[key];
        }

      });

	  this.loading = false;

      if(data.logout_time > 0){
        this.automatic_logout = true;
        this.logout_time = data.logout_time
      }
    },

    onSubmit() {

      if (this.isValid()) {

        this.loading = true;

        let data = {};

        if (this.id) {

          data['id'] = parseInt(this.id)

        }

        data['provider'] = this.provider;

        data['entity_id'] = this.entity_id;

        data['sso_url'] = this.sso_url;

        data['slo_url'] = this.slo_url;

        data['certificate'] = this.certificate;

        data['status'] = this.status;

        data['logout_time'] = this.logout_time;

        axios.post(this.url, data).then(res => {

          this.loading = false;

          successHandler(res, 'SingleSignOn')

          if(!this.id){

            setTimeout(() => {

              let id = res.data.data.id;
              return this.$router.push('/single-sign-on/settings/'+id);

            }, 3000)

          } else {
            this.getInitialValue(this.id)
          }

        }).catch(err => {

          this.loading = false

          errorHandler(err, 'SingleSignOn')
        });
      }
    }
  },

  computed:{
	  title() {
		  if (this.Edit) {
			  return this.providerName ? this.provider.charAt(0).toUpperCase() + this.provider.slice(1) +" Settings" : 'SAML 2.0 Integration';
		  }
		  return 'SAML 2.0 Integration';
	  },
  },

}
</script>

<style>

</style>