<template>

  <div v-if="pageLoad">

    <custom-loader :duration="4000" :color="layout.portal.client_header_color" :size="60"/>
  </div>

  <modal v-if="loginModal" :showModal="loginModal" :showbuttonName="buttonName"  :onClose="onClose" :containerStyle="{}">

    <template #title>
      <h4>{{lang('session_limit_reached_title')}}</h4>
    </template>
    <template #fields>
      <p class="alert alert-warning"><i class="fas fa-warning"></i>&nbsp;{{errorMessage}}</p>

    </template>

    <template #controls>
      <button type="button" @click = "onProceed" class="btn btn-primary"><i class="fa fa-save"></i> {{lang('proceed')}}</button>
    </template>

  </modal>
  <!-- Login card -->
  <div v-if="!pageLoad" class="card oauth-login-card shadow-lg mt-3">

    <div class="card-body pb-1">

      <h4 class="login_title text-secondary" slot="title" >{{ title }}</h4>

      <!-- Alert component -->
      <alert :component-name="componentName"/>

      <!-- Form with captcha -->
      <form-with-captcha btnClass="login-button oauth-login-btn btn btn-block btn-flat mt-2 p-2"
                         :btnStyle="buttonStyle" btnName="login" iconClass="" :formSubmit="onSubmit" page="login_page"
                         :componentName="componentName" btn_id="default-login-button">

        <template #fields>

          <div class="row">

            <div class="col-sm-12" v-focus-first-input>

              <!-- Username field -->
              <text-field :layout="layout" :inputStyle="inputStyle"  :labelStyle="labelStyle" :label="lang('username')" :value="user_name"
                          type="text" name="user_name" :keyupListener="triggerEvent" :onChange="onChange" defaultKey="user_name"
                          :placehold="lang('email_username_placeholder')" classname="" :required="true" id="login_form_user_name" page="oauth-login">

              </text-field>

              <!-- Password field -->
              <text-field :labelStyle="labelStyle" :layout="layout" :inputStyle="inputStyle"  :label="lang('password')" :value="password"
                          type="password" name="password" :keyupListener="triggerEvent" :onChange="onChange"
                          :placehold="lang('password')" classname="" :required="true" id="login_form_password" page="oauth-login">

              </text-field>

              <!-- Remember me checkbox and forgot password link -->
              <div class="row text-small pb-3">
                <div class="col-sm-6" :class="[ 'pull-left',{'forgot-class' : selectedLanguage === 'ar'}]" id="remember_me">

                  <input type="checkbox" v-model="remember" name="remember" id="login_form_remeber"> {{ lang('remember') }}
                </div>

                <div class="col-sm-6 text-end" :class="{'forgot-text-class' : selectedLanguage === 'ar'}" id="default-login">

                  <router-link :to="'/oauth/for-pass?application='+application" id="default-forgot-password" class="content-link"
                               :class="{float1 : selectedLanguage === 'ar'}">{{ lang('forgot_password') }}?
                  </router-link>
                </div>
              </div>
            </div>

            <!-- Loader -->
            <div v-if="loading" id="login_loader">

              <custom-loader :duration="4000" :color="layout.portal.client_header_color" :size="60"/>
            </div>
          </div>
        </template>

        <template #actions>

          <div class="form-group">

            <div v-if="isAnyProviderData" class="row pt-3 ps-3 pe-3">
              <div class="col-sm-4">
                <hr>
              </div>
              <div class="col button-divider">
                OR
              </div>
              <div class="col-sm-4">
                <hr>
              </div>
            </div>

            <!-- Login box -->
            <div id="login-box" class="pt-1" :class="!providerData ? 'pb-3':''" v-if="isLoginBoxVisible">{{loginBoxVisible()}}</div>

            <!-- Third-party login buttons -->
            <div class="saml-auth d-grid" v-if="providerData.saml_meta_settings && providerData.saml_meta_settings.directory_settings" v-for="data in providerData.saml_meta_settings.directory_settings">
              <button class="btn btn-light link-dark btn-block btn-flat border-0 p-2 oauth-config"
                      @click="oneLoginRedirect(data)" id="OneLogin"><strong>{{data.login_button_label}} login</strong></button>
            </div>

            <div v-if="providerData.basic_auth_providers">

              <div class="d-grid" v-for="data in providerData.basic_auth_providers">
                <button class="btn btn-light link-dark btn-block btn-flat border-0 p-2 oauth-config"
                        @click="thirdpartyLogin('third_party_basic', data)" id="OneLogin"><strong>{{data}} login</strong></button>
              </div>
            </div>

            <!-- Social login buttons -->
            <div class="d-grid" v-if="!loading" v-for="provider in providerData.providers" :style="socialLoginBoxStyle">

              <ul class="list-unstyled" :class="{'padd' : selectedLanguage === 'ar'}" style="width: 100%;">

                <li :id="'social-'+provider">

                  <button  :class="'btn btn-block btn-light link-dark btn-flat p-2 oauth-config'"  @click="socialRedirect(provider)" :id="'client_signin_provider-'+provider">

                    <span :class="'fab fa-'+(provider === 'linkedin-openid' ? 'linkedin' : provider)" :style="{color :'btn btn-social btn'+(provider === 'linkedin-openid' ? 'linkedin' : provider)}"></span> <strong>{{ lang('sign_in_with') }} {{ provider === 'linkedin-openid' ? 'LinkedIn' : provider }}</strong>

                  </button>
                </li>
              </ul>
            </div>
          </div>
        </template>
      </form-with-captcha>
    </div>
  </div>
</template>

<script setup>

import { ref, onBeforeMount, computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useStore } from "vuex";
import { errorHandler } from '../../../../helpers/responseHandler'
import { validateLoginSettings } from "../../../../helpers/validator/loginRules";
import axios from 'axios'
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import FormWithCaptcha from "../../../Common/Form/FormWithCaptcha.vue";
import { lang } from '../../../../helpers/extraLogics'

const props = defineProps({

  layout : { type : Object, default : ()=> {}},

  auth : { type : [Object, Array], default : ()=> []},

  language : { type : String, default : ()=> ''},
})

const router = useRouter();
const store = useStore();
const isDisabled = ref(false);
const base = ref('');
const providerData = ref([]);
const user_name = ref('');
const password = ref('');
const redirectUrl = ref('');
const loading = ref(false);
const pageLoad = ref(false);
const allow_register = ref(false);
const redirectPath = ref('');
const componentName = ref('oauth-page-login');
const labelStyle = ref({ display:'none' });
const remember = ref(true);
const socialLoginBoxStyle =  ref({});
const buttonStyle = ref({});
const inputStyle = ref({});
const selectedLanguage = ref([]);
const isLoginBoxVisible = ref(false);
const route = useRoute();
const title = ref('');
const application = ref('');
const loginModal = ref(false);
const errorMessage = ref('');
const buttonName = ref('');


onBeforeMount(()=>{

  if(props.auth.user_data.length !== 0){
    router.push({ path: '/not-found'});
  }

  const loginTo = lang('Sign in to ');

  application.value =  route.query.application;

// Set the title value using the extracted application parameter and the localized string
  title.value = `${loginTo}${route.query.application ? route.query.application : props.layout.company.company_name}`;
  // base URL
  base.value = props.auth.system_url;

  // selected language
  selectedLanguage.value = props.language;

  allow_register.value = props.layout.user_registration.status;

  // button style
  buttonStyle.value = {

    color: '#fff',

    backgroundColor : '#099fdc'
  };
  
  inputStyle.value = {

    borderColor : props.layout.portal.client_input_field_color

  };


  loading.value=true;

  pageLoad.value = true;

  // Fetch's provider data
  axios.get('api/active-providers').then(response => {

    providerData.value = response.data.data;

    loading.value = false;

    pageLoad.value = false;

    isLoginBoxVisible.value = true;

  }).catch(error=>{

    loading.value=false;

    pageLoad.value = false;

    isLoginBoxVisible.value = false;
  });

  // Listen for login box loader event
  window.emitter.on("login-box-loader", (loading) => {
    loading.value = loading;
  });

  buttonName.value = lang('cancel');
})

// make's login box visible
const loginBoxVisible = () => {
  window.emitter.emit('login-box-mounted', {providerData: providerData.value, 'login_type': 'oAuth' });
}

//  handle's change in form fields
const onChange = (value, name) => {
  if (name === 'user_name' || name === 'password') {
    name === 'user_name' ? user_name.value = value : password.value = value;
  }
}

// check's if form inputs are valid
const isValid = () => {
  const { errors, isValid } = validateLoginSettings({ user_name: user_name.value, password: password.value });

  return isValid;
}

// redirect to social login provider
const socialRedirect = (provider) => {

  window.location.href=base.value +'/social/login/redirect/' + provider;
}

// redirect to OneLogin
const oneLoginRedirect = (data) => {

  window.location.href= data.login_url
}

// onSubmit function
const onSubmit = (key, value, thirdPartyData) => {
  if (isValid()) {
    isDisabled.value = true;
    loading.value = true;

    const params = { email: user_name.value, password: password.value, remember: remember.value }
    params[key] = value;

    if (thirdPartyData) {
      params['third_party_basic'] = thirdPartyData;
    }

    window.emitter.emit('login-data-submitting', params);

    axios.post('login', params).then(handleSuccess).catch(handleError);
  }
}

// Function to handle successful login
const handleSuccess = (res) => {
  redirectUrl.value = res.data.data.redirect_url;
  isDisabled.value = true;
  loading.value = false;
  redirectPath.value = localStorage.getItem('redirectPath');

  switch (true) {
    case (redirectUrl.value == 'verify-2fa'):


      router.push({ name: 'OAuthVerify2FA', path: '/oauth/verify-2fa', params: { pp: JSON.stringify(res.data.data.PPAuth), remember: remember.value } });
      break;
    case (redirectPath.value && redirectPath.value.includes('/rating/')):
      window.location.href = redirectPath.value;
      break;
    case (redirectPath.value):
      window.location.href = base.value + '/mytickets';
      break;
    case (redirectUrl.value == '/'):
      window.location.href = base.value;
      break;
    case (redirectUrl.value == 'verify-email'):
      store.dispatch('setEmail', res.data.data.email);
      router.push({ path: '/oauth/verify-email', name: 'OAuthEmailVerify' });
      break;
    case (redirectUrl.value === 'panel/dashboard'):
      window.location.href = base.value + '/' + redirectUrl.value;
      break;
    case (redirectUrl.value.includes('authorize')):
      window.location.href = base.value + '/oauth/' + redirectUrl.value;
      break;
    default:
      router.push({ path: '/' + redirectUrl.value });
      break;
  }

  window.emitter.emit('login-success', res);
}

// Function to handle login error
const handleError = (error) => {
  isDisabled.value = false;
  loading.value = false;
  errorHandler(error, componentName.value);

  if(error.message){
    errorMessage.value = error.response.data?.message || 'An unknown error occurred.';

    if(error.response.status === 403){
      loginModal.value = true;
    }

    if(error.response.data?.message?.['g-recaptcha-response']){
      store.dispatch('setAlert', {
        type: 'danger', message: 'Invalid ReCaptcha', component_name: componentName.value
      });
    }
  }else{
    errorMessage.value = error.message || 'Network error occurred.';
  }

  window.emitter.emit('login-failure', error);
}

const onProceed = () => {
  onSubmitForLogin('proceed');
}

const onClose = () => {
  loginModal.value = false;
  onSubmitForLogin('reject');
}

const onSubmitForLogin = (action) => {
  loginModal.value = false;

  const url = action === 'proceed'? '/login/proceed' : '/login/reject';

  axios.post(url)
      .then(res =>{
        if(action === 'proceed'){
          if(res.data.data.redirect_url === 'verify-2fa'){
            router.push({ name: 'OAuthVerify2FA', path: '/oauth/verify-2fa', params: { pp: JSON.stringify(res.data.data.PPAuth), remember: remember.value } });
          }else{
            window.location.href = base.value + '/' + response.data.data.redirect_url;
          }
        }
      }).catch(error =>{
        console.info(error)
  }).finally(()=>{
    loginModal.value = false;
  })
}

// Trigger's form submission on enter key press
const triggerEvent = (event) => {
  var key = event.which || event.keyCode;
  if (key === 13) { // 13 is enter

    window.emitter.emit('logging-in-with-enter-key');

    // if default button is visble then press it
    let defaultLogin = document.getElementById('default-login-button');
    if(defaultLogin.style.display != 'none'){
      defaultLogin.click();
    }
  }
}

// handle's third-party login
const thirdpartyLogin = (thirdPartyData,value) => {

  // Register the event listener before triggering the click
  window.emitter.on("login-data-submitting", (params) => {
    if (thirdPartyData) {
      params['third_party_basic'] = value;
    }
  });

  // Trigger the default login button click
  document.getElementById('default-login-button').click();
}

const isAnyProviderData = computed(() => {
  return providerData.value.providers.length > 0 ||
      providerData.value.saml_meta_settings.directory_settings.length > 0 ||
      providerData.value.basic_auth_providers.length > 0;
});

</script>

<style scoped>

#login_loader{
  margin: auto !important;
  margin-bottom: 20px !important;
}

.login_title {
  margin-top:0px;margin-bottom: 21px;text-align: center;
}

.oauth-login-card {
  max-width: 450px !important;
  min-width: 400px !important;
}

@media screen and (max-width: 900px) {
  .oauth-login-card{
    min-width: 200px !important;
    max-width: 350px !important;
  }
}

.content-link{
  color: rgb(0, 154, 186);
}

#OneLogin{
  margin-top: 5px;
  margin-bottom: 10px;
}

.content-link:hover{
  color: #337ab7;
}

.fa-facebook{
  color:#3b5998 !important;
}

.fa-google{
  color:#dd4b39 !important;
}

.fa-github{
  color:#333 !important;
}

.fa-twitter{
  color: #55acee !important;
}

.fa-linkedin{
  color: #0976b4 !important;
}

.button-divider{
  padding-left: 50px;
}

.oauth-config{
  border-radius: 4px !important;
  border-width: 1px !important;
  border-color: #BDC1CAFF !important;
  border-style: solid !important;
}

.padd{
  padding-right: 0!important;
}

.forgot-class{
  padding-left: 120px !important;
}

.forgot-text-class{
  padding-right: 40px !important;
}

</style>
