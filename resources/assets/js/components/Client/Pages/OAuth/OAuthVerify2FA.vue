<template>

  <!-- Card for 2FA authentication -->
  <div class="card oauth-2fa-card shadow-lg mt-3">

    <div class="card-body pb-1">

      <transition name="page" mode="out-in">

        <div :class="{fa_align : selectedLanguage === 'ar'}">

          <div id="content" class="site-content col-md-12 " >

            <!-- Alert component -->
            <alert componentName="oauth-2fa"/>

            <div class="row">

              <div class="col-sm-12 text-center">
                <!-- Title based on showRecovery value -->
                <h3 id="head3" class="text-secondary">{{ showRecovery ? lang('2_factor_auth') : lang('recovery_factor_auth') }}</h3>
                <router-link to="/oauth/login" class="content-link text-small float-end">{{ lang('back_to_login') }}</router-link>
              </div>

            </div>

            <!-- Text field for OTP -->
            <TextField :label="lang('enter_code')" :value="otp" id="2fa_otp" :autofocus="true"
                       type="text" name="otp" :keyupListener="triggerEvent" :input-style="inputStyle" :onChange="onChange" classname="" :required="true">

            </TextField>

            <!-- Message based on showRecovery value -->
            <p class="text-sm text-muted">{{ showRecovery ? lang('2fa-message') : lang('recovery_factor_message') }}</p>

            <!-- Loader when loading is true -->
            <div v-if="loading && layout">

              <Loader :animation-duration="4000" :color="layout.portal.client_header_color" :size="50"></Loader>
            </div>

            <div class="row pb-3">

              <!-- Section for recovery code link -->
              <div class="col-sm-8" v-if="showRecovery">

                <div :class="{'float-end' : language === 'ar'}">

                  <span class="text-muted"><b>Having problems?</b></span>

                  <p><a href="javascript:;" class="content-link text-sm" @click="showRecovery=false">Login using recovery code</a></p>

                </div>
              </div>

              <!-- Section for Authenticator passcode link -->
              <div class="col-sm-8" v-if="!showRecovery">

                <div :class="{'float-end' : language === 'ar'}">
                  <p><a href="javascript:;" class="content-link text-sm" @click="showRecovery=true">Login using Authenticator passcode</a></p>
                </div>
              </div>

              <div class="col-sm-4" :class="{left : selectedLanguage === 'ar'}">

                <div class="d-grid">

                  <!-- Submit button -->
                  <button class="btn oauth-2fa-btn btn-block btn-flat" :class="{'float-end' : selectedLanguage !== 'ar'}" @click="onSubmit()" :disabled="otp ? false : true"
                          id="2fa_otp_verify">
                    {{ lang('verify') }}

                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </div>

  </div>

</template>

<script setup>

import { ref, computed, onBeforeMount, watch } from 'vue';
import { useRouter } from "vue-router";
import { useStore } from "vuex";
import { errorHandler} from "../../../../helpers/responseHandler";
import axios from 'axios';
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import Loader from "../../../MiniComponent/Loader.vue";

const props = defineProps({

  layout : { type : Object, default : ()=> {}},

  auth : { type : [Object, Array], default : ()=> []},

  pp : { type : [Object, String], default : ''},

  remember : { type : Boolean, default : false},

  language : { type : String, default : ()=> ''},
})

const loading  = ref(false);
const otp = ref('');
const p_auth = ref('');
const inputStyle = ref({});
const isDisabled = ref(false);
const showRecovery = ref(true);
const router = useRouter();
const store = useStore();
const selectedLanguage = ref([]);
const base = ref('');

onBeforeMount(()=>{

  //URL parameters
  let params = new URLSearchParams(window.location.search);

  //selected language
  selectedLanguage.value = props.language;

  // base URL
  base.value = props.auth.system_url;

  // Get PPAuth value from URL params or props
  let p_auth_value = params.get("PPAuth");

  // Parse PPAuth value
  if(p_auth_value) {
    let splitVal = p_auth_value.split(',');

    let objVal = {};

    objVal[splitVal[0]] = splitVal[1];

    p_auth.value =objVal;

  } else {
    p_auth.value = props.pp ? JSON.parse(props.pp) : '';
  }

  // Redirect according to the authtype
  if(!Array.isArray(props.auth.user_data)){

    router.push({name:'Home'})

  } else if(!p_auth.value){

    router.push({path:'oauth/login', name: 'OAuthLogInPage'})
  }
})

// Watch for changes in showRecovery value
watch (showRecovery ,(newVal, oldVal) =>{

  otp.value = '';

  store.dispatch('unsetValidationError');

  store.dispatch('unsetAlert');
})

// handle's change in OTP input
const onChange = (value, name) => {
  otp.value = value;
}

// verify factor (either OTP or recovery code)
const verifyFactor = () => {

  isDisabled.value = true;

  loading.value = true;

  const data = {};
  data['rec_code'] = otp.value;

  axios.post('/verify-recovery-code', data).then(response => {

    afterSuccess(response);

  }).catch(error => {

    afterFailure(error)
  })
}

// handle's form submission
const onSubmit = ()=> {

  if(!showRecovery.value){

    return verifyFactor();
  }

  isDisabled.value = true;

  loading.value =true;

  const data = {};

  data['totp'] = otp.value;

  data['PPAuth'] = p_auth.value ? p_auth.value : '';

  data['remember'] = JSON.parse(props.remember);

  axios.post('/2fa/loginValidate',data).then(response =>{

    afterSuccess(response);

  }).catch(error=>{

    afterFailure(error)
  })
}

// handle success after API call
const afterSuccess = (response) => {

  isDisabled.value = false;

  loading.value = false;

  let redirectUrl = response.data.data.redirect_url;

  let redirectPath = localStorage.getItem('redirectPath');

  if (redirectPath) {

    window.location.href = router.push({path:'/mytickets'});

  } else {
    if (redirectUrl == '/') {
      window.location.href = props.auth.system_url;
    } else if(redirectUrl.includes('authorize')){
      window.location.href = base.value + '/oauth' + redirectUrl;
    } else if(redirectUrl === '/panel/dashboard'){
      window.location.href= base.value+redirectUrl;
    } else{
      router.push({ path: '/' + redirectUrl });
    }
  }
}

// handle failure after API call
const afterFailure = (error) => {

  if(error.response.status === 422){

    setTimeout(()=>{

      router.push({name:'Login'})
    },2000);
  } else {

    store.dispatch('setValidationError', {'otp' : 'Wrong code. Try again'})
  }

  isDisabled.value=false;

  loading.value=false;

  errorHandler(error,'oauth-2fa');
}

// trigger's form submission on enter key press
const triggerEvent = (event) => {
  var key = event.which || event.keyCode;
  if (key === 13) // 13 is enter
    if(document.getElementById("2fa_otp").value !== "")
    {
      onSubmit();
    }
}

</script>


<style scoped>

.login-content-area, .logo-container{
  display: flex;
  justify-content: center;
}

.login-content-area {
  align-items: center; /* Vertically center */
  min-height: 80vh !important; /* Full height of the viewport */
  padding-top: 100px;
  padding-bottom: 100px !important;
}

.footer-container {
  background-color: #fcfcfc;
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
}

.oauth-2fa-btn{
  color: rgb(255, 255, 255);
  background-color: rgb(9, 159, 220);
}

.oauth-2fa-card{
  max-width: 650px !important;
  min-width: 500px !important;
}

.content-link{
  color: rgb(0, 154, 186);
}

.content-link:hover{
  color: #337ab7;
}

@media screen and (max-width: 900px) {
  .oauth-2fa-card{
    min-width: 200px !important;
    max-width: 350px !important;
  }
}

.fa_align{
  direction: rtl;
}

#head3{
  margin-top: 0px !important;
}

</style>