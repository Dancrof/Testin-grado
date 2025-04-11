<template>
  <div class="col-sm-12">
    <!--loader-->
    <div class="row" v-if="hasDataPopulated === false || loading === true">
      <custom-loader></custom-loader>
    </div>

    <alert/>

    <faveo-box :title="lang('third_party_app')" v-if="hasDataPopulated">

		<template #headerMenu>

			<status-switch name="status" :value="status" :onChange="onChange"
						   classname="pull-right" :bold="true">
			</status-switch>
		</template>

      <template v-if="pageType === 'oauth' || auth === lang('oauth_authentication')">
        <div class="row" v-focus-first-input>

          <!-- Name -->
          <text-field :label="trans('name')" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" :value="name"
                      classname="col-lg-4" name="name"></text-field>

          <!-- App Id -->
          <text-field :label="trans('app_id')" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" :value="app_id"
                      classname="col-lg-4" name="app_id"></text-field>

          <!-- App Secret -->
          <text-field :label="trans('app_secret')" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" :value="app_secret"
                      classname="col-lg-4"
                      name="app_secret"></text-field>
        </div>

        <div class="row">

          <!-- Authentication Endpoint-->
          <text-field :label="trans('authentication_endpoint')" :onChange="onChange" :placehold="lang('enter_a_value')"
                      :required="true" :hint="lang('authentication_tooltip')"
                      :value="authentication_endpoint" classname="col-lg-4" name="authentication_endpoint"></text-field>

          <!-- Token Endpoint-->
          <text-field :label="trans('token_endpoint')" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" :value="token_endpoint"
                      :hint="trans('token_tooltip')" classname="col-lg-4" name="token_endpoint"></text-field>

          <!-- Token Endpoint-->
          <text-field :label="trans('identity_endpoint')" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" :value="identity_endpoint"
                      :hint="trans('identity_tooltip')" classname="col-lg-4" name="identity_endpoint"></text-field>
        </div>

        <div class="row">

          <!-- Scopes Endpoint-->
          <text-field :label="trans('scopes')" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true"
                      :hint="lang('scope_tooltip')" :value="scopes" classname="col-lg-4" name="scopes"></text-field>

          <div class="col-sm-4">
            <label>Redirect URL</label>
            <div class="input-group">
              <input type="text" class="form-control" v-model="app_url" name="app_url" disabled>
                    <span class="input-group-text uri-copy" v-tooltip="copied ? lang('clipboard-copy-message') : lang('click-url-copy')" @click.prevent="copyToClipboard">
                      <i :class="copied ? 'glyphicon glyphicon-ok text-success' : 'fa fa-clipboard'"></i></span>
            </div>
          </div>


        </div>

        <table id="faveo-attribute-list" class="faveo-table table">
          <thead class="thead-default">
          <tr>
            <th class="bg-light">
              {{trans('faveo_attributes')}}
              <tool-tip :message="lang('faveo_attributes-tooltip')" size="small"></tool-tip>
            </th>
            <th class="bg-light">
              {{trans('third_party_attributes')}}
              <tool-tip :message="lang('third_party_attributes-tooltip')" size="small"></tool-tip>
            </th>

          </tr>
          </thead>

          <tbody v-for="(element, index) in user_map" class="faveo-attribute-elements">
          <tr>
            <td class="padding-top-12">
              <span :id="'faveo-attribute-label-'+index">{{trans(element.faveo_attribute_label)}}</span>
              <span v-if="element.required" class="text-danger">*</span>
              <tool-tip :message="lang('third-party-'+element.faveo_attribute_label)" size="small"></tool-tip>

            </td>

            <td>
              <input type="text" class="form-control col col-lg-4" v-model="element.third_party_attribute"/>
            </td>
          </tr>
          </tbody>
        </table>
      </template>

      <template v-if="pageType === 'basic' || auth === lang('basic_authentication')">

        <div class="row" v-focus-first-input>

          <!-- Name -->
          <text-field :label="trans('name')" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" :value="name"
                      classname="col-sm-6" name="name"></text-field>

          <text-field :label="trans('authentication_endpoint')" :onChange="onChange" :placehold="lang('enter_a_value')"
                      :required="true" :hint="lang('authentication_tooltip')"
                      :value="authentication_endpoint" classname="col-sm-6" name="authentication_endpoint"></text-field>

        </div>

        <div class="row">
          <radio-button :options="lang(methodOption)" :label="lang('method')" name="apiMethod" :value="apiMethod" :onChange="onChange"
                        classname="form-group col-sm-6">

          </radio-button>

          <radio-button :options="lang(DataOption)" label="" name="dataMethod" :value="dataMethod" :onChange="onChange"
                        classname="form-group col-sm-6">

          </radio-button>
        </div>

        <div v-if="showShortcode" class="row">
          <div class="col-md-12">
            <div class="card card-light">
              <div class="card-header">
                <h3 class="card-title">{{trans('list-of-available-shot-codes')}}</h3>
                <div class="card-tools">
                  <button class="btn btn-tool" data-card-widget="collapse" data-bs-toggle="tooltip" v-tooltip="trans('collapse-list')"><i class="fas fa-minus"></i></button>
                </div><!-- /.box-tools -->
              </div><!-- /.box-header -->
              <div class="card-body col-md-12">
                <div class="alert alert-info alert-dismissable">
                  <i class="fas  fa-info-circle"></i>&nbsp;
                  <span>{{trans('template-short-code-tips')}}</span>
                  <button type="button" class="btn-close float-end" data-bs-dismiss="alert" aria-label="Close" ></button>
                </div>
                <div>
                  <ul class="list-inline" v-if="template">
                    <li v-for="(value) in template" class="list-inline-item" style="width: 49%"><span v-tooltip.right="trans(value)" data-placement="right">{{value}}</span></li>
                  </ul>
                </div>
              </div><!-- /.box-body -->
            </div>
          </div>
        </div>

        <table v-if="showTable" id="faveo-attribute-list" class="faveo-table table">
          <thead class="thead-default">
          <tr>
            <th class="bg-light">
              {{trans('faveo_attributes')}}
              <tool-tip :message="lang('faveo_attributes-tooltip')" size="small"></tool-tip>
            </th>
            <th class="bg-light">
              {{trans('third_party_attributes')}}
              <tool-tip :message="lang('third_party_attributes-tooltip')" size="small"></tool-tip>
            </th>

          </tr>
          </thead>

          <tbody v-for="(element, index) in payloadData" class="faveo-attribute-elements">
          <tr>
            <td class="padding-top-12">
              <span :id="'faveo-attribute-label-'+index">{{trans(element.faveo_attribute_label)}}</span>
              <span v-if="element.required" class="text-danger ps-1">*</span>
              <tool-tip :message="lang('third-party-'+element.faveo_attribute_label)" size="small"></tool-tip>

            </td>

            <td>
              <input type="text" class="form-control col col-lg-4" v-model="element.third_party_attribute"/>
            </td>
          </tr>
          </tbody>
        </table>

        <div v-if="showField" class="input-box__sbl">
          <div class="row">
            <span><label class="params ms-1">{{ lang('url_parameters')}}:</label></span> &nbsp;&nbsp;
            <input type="text" class="form-control col-sm-2" v-model="userParameters" id="userParameters">
              <span class="slash">/</span>
            <input type="text" class="form-control col-sm-2" v-model="passParameters" id="passParameters">
          </div>
        </div>

      </template>

		<template #actions>

			<div class="card-footer">
				<button :disabled="loading" class="btn btn-primary" type="button" v-on:click="onSubmit">
          <i :class="iconClass"></i> {{trans(btnName)}}
				</button>
			</div>

		</template>
    </faveo-box>
  </div>
</template>


<script>
import axios from "axios";
import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
import {getIdFromUrl} from '../../../../helpers/extraLogics';
import copy from 'clipboard-copy';
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import Switch from "../../../MiniComponent/FormField/Switch.vue";
import ToolTip from "../../../MiniComponent/ToolTip.vue";
import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";

export default {
  name: "third-party-app",

  beforeMount() {
    this.setMode();
    this.getInitialValues();
    this.shortcode();

    let paramsSearch = new URLSearchParams(window.location.search);

    this.pageType = paramsSearch.get("page_type")
  },

  data: () => ({
    id: null,
    name: '',
    app_id: '',
    app_secret: '',
    authentication_endpoint: '',
    token_endpoint: '',
    identity_endpoint: '',
    scopes: '',
    login_label: '',
    status: 1,
    loading: true,
    hasDataPopulated: false,
    mode: "create",
    user_map: [],
    app_url: '',
    app_url_bkp :'',
    copied : false,
    template:null,
    pageType: '',
    methodOption:[{name:'get',value:'get'},{name:'post',value:'post'}],
    DataOption:[{name:'payload',value:'payload'},{name:'url_parameter',value:'parameter'}],
    labelStyle: {display: 'none'},
    dataMethod: 'payload',
    apiMethod: 'get',
    auth:'',
    userParameters: '',
    passParameters: '',
    showTable: true,
    showField: false,
    showShortcode: false,
    payloadData:[
        {
          faveo_attribute: "user_name",
          faveo_attribute_label: "user_name",
          required: true,
          third_party_attribute: ""
        },
      {
        faveo_attribute: "password",
        faveo_attribute_label: "password",
        required: true,
        third_party_attribute: ""
      }
    ],

    iconClass : 'fas fa-save',

    btnName : 'save',
  }),

  methods: {

    copyToClipboard() {
        copy(this.app_url);
        this.copied = true;
        this.showCopyIconAfterCopying()
    },

    showCopyIconAfterCopying() {
        //for showing copy icon after 5 seconds.
        setTimeout(() => {
            this.copied = false;
        }, 5000)
    },

    setMode() {
      const path = window.location.pathname;
      this.mode = path.indexOf("edit") >= 0 ? "edit" : "create";
    },

    /**
     * gets initial state of states defined in this component
     * @return {void}
     */
    getInitialValues() {
      this.loading = true;

      if (this.mode === "edit") {

        this.iconClass =  'fas fa-sync';

        this.btnName = 'update';

        //match from the end
        const path = window.location.pathname;
        const id = getIdFromUrl(path);

        axios
            .get(`/api/admin/third-party-apps/${id}`)
            .then(res => {
              this.updateStatesWithData(res.data.data.formattedElement);
              this.app_url_bkp = res.data.data.url + '/';
              this.auth = res.data.data.formattedElement.auth;
              this.hasDataPopulated = true;
              this.loading = false;
            })
            .catch(err => {
              errorHandler(err)
              this.hasDataPopulated = true;
              this.loading = false;
            });

      } else {

        axios.get('/api/admin/faveo-attributes').then(res => {
          this.user_map = res.data.data.formattedElement;
          this.app_url = res.data.data.url;
          this.app_url_bkp = res.data.data.url + '/';
          // for creating a new email
          this.hasDataPopulated = true;
          this.loading = false;
        });
      }
    },

    /**
     * updates state data for this component
     * @param {Object} data    settings data object (from backend)
     * */
    updateStatesWithData(data) {
      this.id = data.id;
      this.name = data.name;
      this.app_id = data.app_id;
      this.app_secret = '';
      this.authentication_endpoint = data.authentication_endpoint;
      this.token_endpoint = data.token_endpoint;
      this.identity_endpoint = data.identity_endpoint;
      this.login_label = data.login_label;
      this.scopes = data.scopes;
      this.status = data.status;
      this.user_map = data.user_map;
      this.app_url = data.app_url;

      if (data.auth === 'Basic authentication') {
        this.dataMethod = data.argument_as;
        this.apiMethod = data.method;

        for (const element of this.payloadData) {
          if (element.faveo_attribute_label === "user_name") {
            element.third_party_attribute = data.basic_format?.user_name || '';
          }
          if (element.faveo_attribute_label === "password") {
            element.third_party_attribute = data.basic_format?.password || '';
          }
        }

        if (data.basic_format && data.basic_format.length >= 2) {
          [this.userParameters, this.passParameters] = data.basic_format;
        }

        this.showTable = this.dataMethod === 'payload';
        this.showField = this.dataMethod === 'parameter';
        this.showShortcode = this.dataMethod === 'parameter';
      }
    },

    /**
     * sends an ajax request to server after validating it
     * */
    onSubmit() {
      this.loading = true;

      let payload;
      if (this.pageType === 'oauth' || this.auth === 'Oauth authentication') {
        payload = {
          id: this.id,
          name: this.name,
          app_id: this.app_id,
          app_url: this.app_url,
          app_secret: this.app_secret,
          authentication_endpoint: this.authentication_endpoint,
          token_endpoint: this.token_endpoint,
          identity_endpoint: this.identity_endpoint,
          login_label: this.login_label,
          scopes: this.scopes,
          status: this.status,
          user_map: this.user_map,
        };
      } else if (this.pageType === 'basic' || this.auth === 'Basic authentication') {
        if (this.dataMethod === 'payload') {

          const argumentAsPairs = {};
          this.payloadData.forEach(element => {
            const label = element.faveo_attribute_label === "UserName" ? "userName" : element.faveo_attribute_label;
            argumentAsPairs[label] = element.third_party_attribute;
          });

          payload = {
            id: this.id,
            is_basic : 1,
            status: this.status,
            name: this.name,
            authentication_endpoint: this.authentication_endpoint,
            method: this.apiMethod,
            argument_as: 'payload',
            basic_format: argumentAsPairs
          };
        } else if (this.dataMethod === 'parameter') {
          payload = {
            id: this.id,
            is_basic : 1,
            status: this.status,
            name: this.name,
            authentication_endpoint: this.authentication_endpoint,
            method: this.apiMethod,
            argument_as: 'parameter', // Assuming this.parameters is an object containing the URL parameters
            basic_format: this.userParameters&&this.passParameters ? this.userParameters+'/'+this.passParameters : ''
          };
        } else {
          // Handle other cases or raise an error if needed
          this.loading = false;
          return;
        }
      } else {
        // Handle other cases or raise an error if needed
        this.loading = false;
        return;
      }
      axios
          .post("/api/admin/third-party-apps", payload)
          .then(res => {
            this.loading = false;
            successHandler(res);
            this.redirectIfNeeded();
            this.$store.dispatch('unsetValidationError');
          })
          .catch(err => {
            this.loading = false;
            errorHandler(err);
          });
    },

    /**
     * redirects to index page, if needed
     */
    redirectIfNeeded() {
      if (this.mode === "create") {
        setTimeout(() => {
          this.$router.push({ name : "ThirdPartyApps Index" })
        }, 3000)
      } else {
        this.getInitialValues();
      }
    },

    /**
     * populates the states corresponding to 'name' with 'value'
     * @param  {string} value
     * @param  {[type]} name
     * @return {void}
     */
    onChange(value, name) {
      this[name] = value;

      if(value === 'payload'){
        this.showTable = true;
        this.showField = false;
        this.showShortcode = false;

        if(this.mode === 'create'){
          this.userParameters = '';
          this.passParameters = '';
        }
      }

      if(value === 'parameter'){
        this.showTable = false;
        this.showField = true;
        this.showShortcode = true;

        if(this.mode === 'create'){
          this.payloadData.forEach(item => {
            item.third_party_attribute = '';
          });
        }
      }

      if (name === 'name') {
        // Remove spaces from the value
        const processedValue = value.replace(/\s/g, '');
        // Set the app_url with the processed value
        this.app_url = this.app_url_bkp + processedValue;
      }
    },

    shortcode(){
      axios.get('api/admin/third-party-apps-short-code').then(res=>{
        this.template = res.data;
        this.parameters = this.template.join("/");
      }).catch(err=>{
        //err
      })
    }
  },

  components: {
    RadioButton,
    "text-field": TextField,
    "status-switch": Switch,
    "tool-tip": ToolTip,
  }
};
</script>
<style type="text/css" scoped>
input .form-control {
  border-radius: 30px !important;
}

.with-switch {
  padding-bottom: 0px !important;
  margin-bottom: -3px;
}

.with-switch > h3 {
  margin-top: 2px !important;
}

.params{
  margin-top: 6px;
}

.pointer-none {
  pointer-events: none;
}

.slash {
  font-size: 35px; /* Set the desired font size */
  font-weight: 300;
  color: darkgrey;
  margin-top: -10px !important;
  margin-left: 2px;
  margin-right: 2px;
}

.uri-copy{
  cursor: pointer;
}
</style>
