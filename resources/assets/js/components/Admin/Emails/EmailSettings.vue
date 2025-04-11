<template>
  <div class="col-sm-12">
    <!--loader-->
    <div class="row" v-if="hasDataPopulated === false || loading === true">
      <custom-loader :duration="loadingSpeed"></custom-loader>
    </div>

    <!-- alert message which only gets mounted when vuex has non empty alert values -->
    <alert />
	  <alert componentName="email-setting"></alert>
    <!--mail info-->
    <!-- will be visible only when component is mounted -->

    <faveo-box :title="lang('email_settings')" v-if="hasDataPopulated">

	    <template #headerMenu>

		    <div class="card-tools">

			    <button v-if="validMail() && discoveredData" href="javascript:;" class="btn-tool update-btn border" @click="getData">

				    <i class="fas fa-cog"></i>&nbsp;{{ lang('auto_discovery') }}
			    </button>
		    </div>
	    </template>
	    
      <faveo-box :title="lang('email_info')">

<!--          <template #headerMenu>-->

<!--              <div class="card-tools switch-pos">-->

<!--                  <status-switch name="auto_discovery" :value="auto_discovery" :onChange="onChange"-->
<!--                                 classname="btn-tool" :bold="true">-->
<!--                  </status-switch>-->
<!--              </div>-->
<!--          </template>-->

          <div class="row mb-2">
		
		      <radio-button :options="radioOptions" :label="lang('is_oauth')" name="is_oauth" :value="is_oauth"
		                    :onChange="onChange" classname="form-group col-sm-5" optionClass="col-sm-6"
		      :labelStyle="{display : 'none'}">
			     
		      </radio-button>
	      </div>
        <div class="row" v-focus-first-input>

          <!-- email address -->
          <text-field :label="lang('email')" :value="email_address" type="email" name="email_address" defaultKey="email" :onChange="onChange" :placehold="lang('enter_a_value')"
            classname="col-sm-3" :required="true" :disabled="mailDisabled"></text-field>

          <!-- email address -->
          <text-field :label="lang('user_name')" :value="user_name" type="email" name="user_name" defaultKey="email" :onChange="onChange" :placehold="lang('enter_a_value')"
            classname="col-sm-3" :hint="lang('user_name_hint')" :disabled="userNameDisabled"></text-field>

          <!-- email name -->
          <text-field :label="lang('name')" :value="email_name" name="email_name" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-3"
            :hint="lang('email_name_hint')" :required="true" :disabled="emailNameDisabled"> </text-field>

          <!-- password : if selected sending_protocol is phpmail and fetch mail is disabled,
                    there should be no password block-->
          <text-field v-if="hasPassword && !is_oauth" :label="lang('password')" type="password" :value="password" name="password"
            :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-3" :required="true" > </text-field>
        </div>
	      <div class="row">
		
		      <div v-if="is_oauth" id="o_auth" class="col-sm-12">
			
			      <ul v-if="providerList.length">
				
				      <template v-for="(provider, index) in providerList" :key="index">
					
					      <li>
						
						      <a href="javascript:;">
							
							      <input type="checkbox" id="oauth-check" v-model="oauth_check" :disabled="security_hash"/>
							
							      <label for="oauth-check" id="oauth-check-label">
								
								      <img :src="basePathVersion()+'/themes/default/common/images/msoffice.png'"/>
								
								      <p class="text-dark">{{provider}}</p>
							      </label>
							      
							      <button v-if="oauth_check && !security_hash" type="button" class="btn btn-light btn-block w-100" @click="onMS(provider)">
								      <i class="fab fa-microsoft"></i>&nbsp; {{lang('sign_with_microsoft')}}
							      </button>
							
							      <button v-if="oauth_check && security_hash" type="button" class="btn btn-light btn-block w-100" @click="onMSSignout(provider)">
								      <i class="fab fa-microsoft"></i>&nbsp; {{lang('sign_out')}}
							      </button>
						      </a>
					      </li>
				      </template>
			      </ul>
		      </div>
	      </div>
      </faveo-box>

        <template v-if="discoveredData || !auto_discovery">

            <faveo-box :title="lang('ticket_settings')">
                <template #headerTooltip>

                    <tool-tip :message="lang('ticket_settings_note')" size="medium"></tool-tip>
                </template>

                <div class="row">
                    <!--departments-->
                    <dynamic-select :label="lang('department')" :multiple="false" name="department"
                                    classname="col-sm-4" apiEndpoint="/api/dependency/departments" :value="department" :onChange="onChange">
                    </dynamic-select>

                    <!--help topics-->
                    <dynamic-select :label="lang('help_topic')" :multiple="false" name="helptopic"
                                    classname="col-sm-4" apiEndpoint="/api/dependency/help-topics" :value="helptopic" :onChange="onChange">
                    </dynamic-select>

                    <!--priority-->
                    <dynamic-select :label="lang('priority')" :multiple="false" name="priority"
                                    classname="col-sm-4" apiEndpoint="/api/dependency/priorities" :value="priority" :onChange="onChange">
                    </dynamic-select>
                </div>

            </faveo-box>

            <faveo-box :title="lang('incoming_email')">

                <template #headerTooltip>

                    <tool-tip :message="lang('incoming_emails_note')" size="medium"></tool-tip>
                </template>

                <template #headerMenu>

                    <div class="card-tools switch-pos">

                        <status-switch name="fetching_status" :value="fetching_status" :onChange="onChange"
                                       classname="btn-tool" :bold="true">
                        </status-switch>
                    </div>
                </template>

                <!--for incoming mails-->
                <fetching-protocol :onChange="onChange" :fetching_protocol="fetching_protocol"
                                   :fetching_encryption="fetching_encryption" :fetching_host="fetching_host" :fetching_port="fetching_port"
                                   :fetching_status="fetching_status" :delete_email="delete_email" :use_new_imap_package="use_new_imap_package"
                                   :show_checkbox_for_use_new_imap_package="show_checkbox_for_use_new_imap_package"
                                   :version="version">
                </fetching-protocol>

            </faveo-box>

            <faveo-box :title="lang('outgoing_email')">

                <template #headerTooltip>

                    <tool-tip :message="lang('outgoing_emails_note')" size="medium"></tool-tip>
                </template>

                <template #headerMenu>

                    <div class="card-tools switch-pos">

                        <status-switch  name="sending_status" :value="sending_status" :onChange="onChange"
                                        classname="btn-tool" :bold="true">
                        </status-switch>
                    </div>
                </template>

                <!--for outgoing mails-->

                <sending-protocol type="send" :onChange="onChange" :sending_protocol="sending_protocol"
                                  :sending_encryption="sending_encryption" :sending_host="sending_host" :sending_port="sending_port"
                                  :sending_status="sending_status" :api_key="api_key" :secret="secret" :domain="domain" :region="region"
                                  :version="version">
                </sending-protocol>

                <div class="row">
                    <!-- internal notes -->
                    <text-field :label="lang('internal_notes')" :value="internal_notes" type="textarea" name="internal_notes" :onChange="onChange" classname="col-sm-12"/>
                    <checkbox name="inline_as_cids" :value="inline_as_cids" :label="lang('send_inline_images_as_cids')" :onChange="onChange" classname="col-lg-12"/>
                </div>
                <div class="row">
                    <!-- make system default email -->
                    <checkbox name="is_system_default" :value="is_system_default" :label="lang('make_system_default_mail')" :onChange="onChange" classname="col-sm-12"/>
                </div>

            </faveo-box>

        </template>

        <template #actions>

            <div class="card-footer">

	            <template v-if="!discoveredData">

		            <a v-if="validMail()" href="javascript:;" class="update-btn" @click="onChange(!auto_discovery,'auto_discovery')">

			            <b><i class="fas fa-cog"></i>&nbsp;{{ lang('configure_manually') }}</b>
		            </a>

		            <button type="button" v-on:click="getData" class="btn btn-primary update-btn float-end">

			            {{lang('continue')}} <span class="fas fa-arrow-right"></span>&nbsp;
		            </button>
	            </template>

                <button v-if="discoveredData" type="button" v-on:click="onSubmit" :disabled="loading" class="btn btn-primary update-btn float-end">

                    <span :class="iconClass"></span>&nbsp;{{lang(btnName)}}
                </button>
            </div>
        </template>
    </faveo-box>
  </div>
</template>


<script>
import axios from "axios";
import {errorHandler,successHandler} from "../../../helpers/responseHandler";
import {
  validateEmailSettings,
  shallPasswordBeVisble,
    discoverEmailSettings
} from "../../../helpers/validator/emailSettingsRules";
import {getIdFromUrl} from '../../../helpers/extraLogics';
import TextField from "../../MiniComponent/FormField/TextField.vue";
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
import FetchingProtocol from "./FetchingProtocol.vue";
import SendingProtocol from "./SendingProtocol.vue";
import Switch from "../../MiniComponent/FormField/Switch.vue";
import Checkbox from "../../MiniComponent/FormField/Checkbox.vue";
import ToolTip from "../../MiniComponent/ToolTip.vue";
import RadioButton from "../../MiniComponent/FormField/RadioButton.vue";

export default {
  name: "email-settings",

  description: "email settings page",

  beforeMount() {
      this.setMode();
      this.getInitialValues();
    let urlParams = new URLSearchParams(window.location.search);

    if(urlParams.get('error')){

      this.$store.dispatch('setAlert',{type:'danger',message:urlParams.get('error'), component_name : 'email-setting'})

    }
  },

  data: () => ({
	
	  oauth_check : false,
	  
	  is_oauth : 0,
	  
	  radioOptions:[{name:'basic_auth',value:0, disabled : false},{name:'oauth_auth',value:1, disabled : false}],
	  
    id: null,

    department: "", //selected department
    priority: "", //selected priority
    helptopic: "", //selected helptopic
    email_address: "", //typed email
    email_name: "", //types email_name
    user_name: "",
    password: "", // typed password

    fetching_status: true,
    fetching_protocol: "",
    fetching_encryption: "",
    fetching_host: "",
    fetching_port: "",

    sending_status: true,
    sending_protocol: "",
    sending_encryption: "",
    sending_host: "",
    sending_port: "",


    api_key: "",
    secret: "",
    region: "",
    domain: "",
    version: "",

    is_system_default: false,
    delete_email: false,
    inline_as_cids:false,

    loading: true,
    loadingSpeed: 4000,
    internal_notes: "",
    hasDataPopulated: false,
    mode : "create",
    iconClass : 'fas fa-save',
    btnName : 'save',
	
	  emailNameDisabled : false,
	  userNameDisabled : false,
	  mailDisabled : false,
	  providerList : [],
	  oauth_active : true,
	  security_hash : '',

      auto_discovery : true,
      discoveredData : false,
      autoDiscoveryData : ''
  }),

  methods: {

      validMail() {
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          return emailRegex.test(this.email_address);
      },

      getData() {

          if (this.isDiscoverValid()) {

              this.loading = true;

	          const params = {};

	          if (this.is_oauth) {
		          params.is_oauth = 1;
	          }

              axios.get('/show/email/connections/'+this.email_address, { params }).then(res=>{

                  this.discoveredData = true;

                  this.loading = false;

                  this.autoDiscoveryData = res.data.data;

	              this.fetching_encryption = this.autoDiscoveryData.fetching_encryption?.toLowerCase() || this.fetching_encryption;
	              this.fetching_host = this.autoDiscoveryData.fetching_host ?? this.fetching_host;
                  this.fetching_port = this.autoDiscoveryData.fetching_port ?? this.fetching_port;
                  this.fetching_protocol = this.autoDiscoveryData.fetching_protocol ?? this.fetching_protocol;
                  this.sending_encryption = this.autoDiscoveryData.sending_encryption?.toLowerCase() || this.sending_encryption;
                  this.sending_host = this.autoDiscoveryData.sending_host ?? this.sending_host;
                  this.sending_port = this.autoDiscoveryData.sending_port ?? this.sending_port;
                  this.sending_protocol = this.autoDiscoveryData.sending_protocol ?? this.sending_protocol;
                  this.version = this.autoDiscoveryData.version ?? this.version;

              }).catch(err=>{

                  this.loading = false;

				  errorHandler(err, 'email-setting');
              });
          }
      },


	  getProviders() {
		
		  this.loading = true;
		  
		  axios.get('/get/oauth-user-providers').then(res=>{
			  
			  this.providerList = res.data.providers;
			  
			  this.oauth_active = res.data.oauth_active;
			  
			  this.radioOptions = [{name:'basic_auth',value:0, disabled : this.security_hash},{name:'oauth_auth',value:1, disabled : !this.oauth_active}]
			
			  this.loading = false;
			  
		  }).catch(err=>{
			
			  this.loading = false;
			  
			  this.providerList = [];
		  });
	  },
	
	  onMS(provider) {
		
		  if(this.email_name && this.email_address) {
			
			  this.loading = true;
			  
			  let data = {};
			
			  data['key'] = provider;

			  data['email_id'] = getIdFromUrl(window.location.pathname);

			  data['email'] = this.email_address;
			
			  data['user_name'] = this.user_name;
			
			  data['name'] = this.email_name;
			
			  axios.post('/api/email/oauth-settings',data).then(res=>{
				
				  successHandler(res);
				  
				  setTimeout(()=>{
					
					  location.href = res.data.data.url;
					  
				  },2000);
				
				  this.loading = false;
				  
			  }).catch(err=>{

          errorHandler(err);

				  this.loading = false;
			  });
			
		  } else {
			
			  this.$store.dispatch('setAlert',{type:'danger',message:'Email address and Name are required fields', component_name : 'email-setting'});
		  }
	  },
	
	  onMSSignout() {
		
		  this.loading = true;
		  
		  let endPoint = this.mode != 'edit' ? '/oauth/sign-out/'+this.security_hash : '/oauth/sign-out/'+this.security_hash + '/' + getIdFromUrl(window.location.pathname);
		  
		  axios.get(endPoint).then(res=>{
			
			  this.security_hash = "";
			  
			  successHandler(res);
			  
			  setTimeout(()=>{
				
				  if (this.mode === "edit") {
					
					  this.getInitialValues();
					  
				  } else{
					
					  this.$router.push({name:'Email Create'});
				  }
				  
			  },2000);
			
			  this.loading = false;
			  
		  }).catch(err=>{
			
			  errorHandler(err);
			
			  this.loading = false;
		  });
	  },
		
	  checkValues(from = "") {
		  
		  this.getProviders();
		  
		  if(this.security_hash) {
			
			  this.password = "password";
			
			  this.radioOptions = [{name:'basic_auth',value:0, disabled : this.security_hash},{name:'oauth_auth',value:1, disabled : !this.oauth_active}]
			
			  this.loading = true;
			  
			  let apiEndpoint = this.mode != 'edit' ? '/get/security-hash/'+this.security_hash : '/get/security-hash/'+this.security_hash + '/' + getIdFromUrl(window.location.pathname);
			  
			  axios.get(apiEndpoint).then(res=>{
				
				  let urlParam = new URLSearchParams(window.location.search);
				
				  if(urlParam.get('security_hash')) {
					
					  successHandler(res);
				  }
				  
				  window.emitter.emit('makeEwsDefault');
				  
				  this.sending_protocol = "ews";
				  
				  this.fetching_protocol = "ews";
				  
				  this.is_oauth = res.data.data.is_oauth ? 1 : 0;
				  
				  this.oauth_check = res.data.data.key ? true : false;
				  
				  if(res.data.data.email){
					  
					  this.email_address = res.data.data.email;
					
					  this.mailDisabled = true;
					
				  } else {
					
					  this.mailDisabled = false;
				  }
				
				  if(res.data.data.user_name){
					
					  this.user_name = res.data.data.user_name;
					
					  this.userNameDisabled = true;
					
				  } else {
					
					  this.userNameDisabled = false;
				  }
				
				  if(res.data.data.name){
					
					  this.email_name = res.data.data.name;
					
					  this.emailNameDisabled = true;
					
				  } else {
					
					  this.emailNameDisabled = false;
				  }
				
				  this.loading = false;
				  
			  }).catch(err=>{
				  
				  this.loading = false;
				  
				  errorHandler(err);
				  
				  setTimeout(()=>{
					  
					  this.$router.push({name:'Email Create'});
					  
				  },2000);
			  });
		  } else {
			
			  this.password = "";
			
			  this.is_oauth = 0;
			
			  this.radioOptions = [{name:'basic_auth',value:0, disabled : this.security_hash},{name:'oauth_auth',value:1, disabled : !this.oauth_active}]
			
			  window.emitter.emit('makeEwsNotDefault');
			
			  this.oauth_check = false;
			  
			  this.mailDisabled = false;
			
			  this.userNameDisabled = false;
			  
			  this.emailNameDisabled = false;
			  
			  if(from != 'edit') {
				  
				  this.user_name = '';
				
				  this.email_name = '';
				
				  this.sending_protocol = "";
				
				  this.fetching_protocol = "";
				
				  this.email_address = '';
			  }
		  }
	  },
	  
      setMode(){
          const path = window.location.pathname;
          this.mode = path.indexOf("edit") >= 0 ? "edit" : "create";
          if(this.mode == 'edit') {
              this.auto_discovery  = false;
			  this.discoveredData = true;
          }
      },

      /**
     * gets initial state of states defined in this component
     * @return {void}
     */
    getInitialValues() {
      this.loading = true;

      if (this.mode === "edit") {

        this.iconClass = 'fas fa-sync';
        this.btnName = 'update';
        //match from the end
        const path = window.location.pathname;
        const emailSettingsId = getIdFromUrl(path);

        axios
          .get(`/api/email-settings/${emailSettingsId}`)
          .then(res => {
            this.updateStatesWithData(res.data.data);
            this.hasDataPopulated = true;
            this.loading = false;
	
	          let urlParams = new URLSearchParams(window.location.search);
			  
	          this.security_hash = urlParams.get('security_hash') ? urlParams.get('security_hash') : res.data.data.security_hash;
			  
			  this.checkValues('edit');
          })
          .catch(err => {
            errorHandler(err)
            this.hasDataPopulated = true;
            this.loading = false;
          });

      } else {
        // for creating a new email
        this.hasDataPopulated = true;
        this.loading = false;
		
	      let urlParams = new URLSearchParams(window.location.search);
	
	      this.security_hash = urlParams.get('security_hash');
	    
	      this.checkValues();
      }
    },

    /**
     * updates state data for this component
     * @param {Object} emailSettingsData    settings data object (from backend)
     * */
    updateStatesWithData(emailSettingsData) {
      const self = this;
      const stateData = this.$data;
      Object.keys(emailSettingsData).map(key => {
        //if vue state has a property with name same as 'key'
        if (stateData.hasOwnProperty(key)) {
          self[key] = emailSettingsData[key];
        }
      });
      // backend sends api_key as `key`, but `key` is a reserved word in javascript so it cannot be used
      // so we change its name to `api_key`
      self['api_key'] = emailSettingsData['key'];
    },

    /**
     * checks if the given form is valid
     * @return {Boolean} true if form is valid, else false
     * */
    isValid() {
      const { errors, isValid } = validateEmailSettings(this.$data);
      if (!isValid) {

        return false;
      }
      return true;
    },

      isDiscoverValid() {
          const { errors, isValid } = discoverEmailSettings(this.$data);
          if (!isValid) {

              return false;
          }
          return true;
      },

    /**
     * sends an ajax request to server after validating it
     * */
    onSubmit() {

      if (this.isValid()) {
        this.loadingSpeed = 8000;
        this.loading = true;
        axios
          .post("/api/admin/email-settings", {
              auto_discovery:this.auto_discovery ? 1 : 0,
            id: this.id,
            department: this.department !== null ? this.department.id : null,
            priority: this.priority !== null ? this.priority.id : null,
            help_topic: this.helptopic !== null ? this.helptopic.id : null,
            email_address: this.email_address,
            user_name: this.user_name,
            email_name: this.email_name,
            password: this.password,

            fetching_status: this.fetching_status,
            fetching_protocol: this.fetching_protocol,
            fetching_encryption: this.fetching_encryption,
            fetching_host: this.fetching_host,
            fetching_port: this.fetching_port,
            delete_email: this.delete_email,

            sending_status: this.sending_status,
            sending_protocol: this.sending_protocol,
            sending_encryption: this.sending_encryption,
            sending_host: this.sending_host,
            sending_port: this.sending_port,

            key: this.api_key,
            secret: this.secret,
            region: this.region,
            domain: this.domain,
            version: this.version,

            is_system_default: this.is_system_default,
            internal_notes: this.internal_notes,
            inline_as_cids: this.inline_as_cids,
	          is_oauth : this.is_oauth,
	          
          })
          .then(res => {
            this.loading = false;
            successHandler(res);
            this.redirectIfNeeded()
          })
          .catch(err => {
            this.loading = false;
            errorHandler(err);
          });
      }
    },

      /**
       * redirects to index page, if needed
       */
      redirectIfNeeded() {
          if(this.mode === "create"){
              setTimeout(() => {
				  this.$router.push({name:'Emails Index'});
              }, 3000)
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

      if (name == 'fetching_protocol') {
        if (['imap', 'pop3'].includes(value)) {
          this.show_checkbox_for_use_new_imap_package = true;
        } else if (value == 'ews') {
          this.show_checkbox_for_use_new_imap_package = false;
        }
      }
        if(name == 'auto_discovery') {
            this.discoveredData = !this.auto_discovery;
            window.emitter.emit('makeEwsNotDefault');
        }
    }
  },

  computed: {
    /**
     * @return {Boolean}    whether password field should be visible
     * */
    hasPassword() {
      return shallPasswordBeVisble(this.$data);
    }
  },

  components: {
      "text-field": TextField,
      "dynamic-select": DynamicSelect,
      "fetching-protocol": FetchingProtocol,
      "sending-protocol": SendingProtocol,
      "status-switch": Switch,
      "checkbox": Checkbox,
      "tool-tip": ToolTip,
      'radio-button': RadioButton,
  }
};
</script>
<style type="text/css">
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

.pointer-none {
  pointer-events: none;
}

.switch-pos{position: relative; top: 6px;}

#o_auth ul {
	list-style-type: none;
	padding-left : 0;
}

#o_auth li {
	display: inline-block;
	text-align: center;
	width: 200px;
}

input[type="checkbox"][id="oauth-check"] {
	display: none;
}

#oauth-check-label {
	border: 1px solid #fff;
	padding: 10px;
	display: block;
	position: relative;
	/*margin: 10px;*/
	cursor: pointer;
}

#oauth-check-label:before {
	background-color: white;
	color: white;
	content: " ";
	display: block;
	border-radius: 50%;
	border: 1px solid grey;
	position: absolute;
	top: -5px;
	left: -5px;
	width: 25px;
	height: 25px;
	text-align: center;
	line-height: 28px;
	transition-duration: 0.4s;
	transform: scale(0);
}

#oauth-check-label img {
	height: 70px;
	width: 70px;
	transition-duration: 0.2s;
	transform-origin: 50% 50%;
}

:checked + #oauth-check-label {
	border-color: #ddd;
}

:checked + #oauth-check-label:before {
	content: "✓";
	background-color: grey;
	transform: scale(1);
}

:checked + #oauth-check-label img {
	transform: scale(0.9);
	z-index: -1;
}

</style>
