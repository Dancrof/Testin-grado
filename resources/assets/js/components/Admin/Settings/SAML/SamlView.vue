<template>

  <div class="col-sm-12">

    <alert componentName="Single_Sign_On-View" />

    <div class="row" v-if="loading">

      <custom-loader :duration="4000"></custom-loader>

    </div>

    <div v-else>

      <faveo-box :title='typeof this.provider === "string" ? this.provider.charAt(0).toUpperCase() + this.provider.slice(1) +" Settings" : "Provider not set"'>
	      <template #headerTooltip>

		      <tool-tip :message="lang('SSO_note')" size="small"></tool-tip>
	      </template>

          <div class="row">
            <text-field id="provider" :label="lang('provider')" :value="provider" :onChange="onChange" :placehold="lang('enter_a_value')" type="text" name="provider" :disabled="true"
                        classname="col-sm-6" >

            </text-field>

            <text-field id="entity_id" :label="lang('entity_id')" :value="entity_id" :onChange="onChange" :placehold="lang('enter_a_value')" type="text" name="entity_id" :disabled="true"
                        classname="col-sm-6" >

            </text-field>

          </div>

          <div class="row">

            <text-field id="sso_url" :label="lang('sso_url')" :value="sso_url" :onChange="onChange" :placehold="lang('enter_a_value')" type="text" name="sso_url" :disabled="true"
                        classname="col-sm-6" >

            </text-field>

            <text-field id="slo_url" :label="lang('slo_url')" :value="slo_url" :onChange="onChange" :placehold="lang('enter_a_value')" type="text" name="slo_url"
                        :disabled="true" classname="col-sm-6" >

            </text-field>

          </div>

          <div class="row mb-3">

            <radio-button :options="lang(radioOptions)" :label="lang('Status')" name="status" :value="status"
                          :disabled="true" :onChange="onChange" classname="form-group col-sm-6" ></radio-button>
          </div>

          <div class="row">



          </div>

          <div class="row">

            <text-field id="logoutTime" :label="lang('logout_time')" :value="logout_time" :onChange="onChange" :placehold="lang('enter_a_value')" type="text" name="logout_time"
                        :disabled="true" classname="col-sm-6">
            </text-field>


            <text-field id="SP_entity_id" :label="lang('SP_entity_id')" :hint="lang('SP_entity_hint')" :value="SP_entity_id" :onChange="onChange" :placehold="lang('enter_a_value')" type="text" name="SP_entity_id"
                        :disabled="true" classname="col-sm-5">

            </text-field>

	          <div class="col-sm-1 ps-0">

		          <a class="btn btn-light entity-copy" @click.prevent="onCopy('SP_entity_id', 'copiedEntity')"
		             v-tooltip="!copiedEntity ? trans('click-to-copy') : trans('clipboard-copy-message')">

								<span :class="copiedEntity ? 'fas fa-check text-success' : 'fa fa-clipboard'" id="eye">

								</span>
		          </a>
	          </div>

          </div>

          <div class="row">

            <text-field id="SP_ACS_url" :label="lang('SP_ACS_url')" :hint="lang('SP_ACS_hint')" :value="SP_ACS_url"  :onChange="onChange" :placehold="lang('enter_a_value')" type="text" name="SP_ACS_url"
                        :disabled="true" classname="col-sm-5" >

            </text-field>

	          <div class="col-sm-1 ps-0">

		          <a class="btn btn-light acs-copy" @click.prevent="onCopy('SP_ACS_url', 'copiedAsc')"
		             v-tooltip="!copiedAsc ? trans('click-to-copy') : trans('clipboard-copy-message')">

								<span :class="copiedAsc ? 'fas fa-check text-success' : 'fa fa-clipboard'" id="eye">

								</span>
		          </a>
	          </div>
          </div>
      </faveo-box>
    </div>
  </div>
</template>

<script>

import axios from 'axios';

import {errorHandler} from "../../../../helpers/responseHandler";
import FaveoBox from "../../../MiniComponent/FaveoBox.vue";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
import ToolTip from "../../../MiniComponent/ToolTip.vue";
import copy from "clipboard-copy";


export default {
  name: "View.vue",

  description : 'View component',

  components : {
    "faveo-box":FaveoBox,

    "text-field": TextField,

    "radio-button": RadioButton,

    "tool-tip": ToolTip,
  },
  data(){

    return{
      loading: false,

      header: 'Single Sign On',

      provider: '',

      entity_id: '',

      sso_url: '',

      slo_url: '',

      certificate: '',

      status : 1,

      logout_time : '',

      SP_entity_id : '',

      SP_ACS_url : '',

      // login_url : '',

      id : this.$route.params.id,

      radioOptions:[{name:'enable',value:1},{name:'disable',value:0}],

	    copiedEntity: false,

	    copiedAsc: false,

	    copiedLogin: false,
    }
  },

  beforeMount(){
    this.getIntialValue(this.id)
  },

  methods:{

    onChange(value, name) {

      this[name] = value;
    },

	  onCopy(fieldId, copiedId) {
		  const fieldValue = this[fieldId];
		  copy(fieldValue);
		  this[copiedId] = true;
		  setTimeout(() => {
			  this[copiedId] = false;
		  }, 5000);
	  },

    getIntialValue(id){

		this.loading = true;

      axios.get(`/api/SSO/edit/`+id).then(res =>{

        this.loading = false;

        this.fillFieldsInfo(res.data.data);

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

      if(data.logout_time === 0) {
        this.logout_time = "Not Set"
      }

    }
  },

}
</script>

<style scoped>

.entity-copy { margin-top: 29px; }
.acs-copy { margin-top: 29px; }
.login-copy { margin-top: 29px; }

</style>