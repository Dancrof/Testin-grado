<template>

  <!-- Card for email verification -->
  <div class="card oauth-ev-card shadow-lg mt-3">

    <div class="card-body pb-3">

      <div class="email-verify">

        <alert componentName="oauth-email"/>

        <div v-if="getVerifyEmail" :class="{verify_align : selectedLanguage === 'ar'}">

          <meta-component :dynamic_title="lang('verify-email-title')" :layout="layout"
                          :dynamic_description="lang('verify-email-description')" >

          </meta-component>

          <div id="content" class="site-content col-md-12 " >

            <!-- Alert component for email verification -->
            <alert componentName="oauth-updateEmail"/>

            <template v-if="!updateEmail">


              <h4 v-if="!loading" class="box-title text-secondary" align="center"><p>{{lang('hello')}}</p>

                <span id="message-resend" style="font-size: .8em; display: none;">

								{{lang('activation-link-message')}}
							</span>

                <span id="message" style="font-size: .8em">

								{{lang('activation_link_sent')}} {{email_address}}. {{lang('click_link_to_activate')}}
							</span>
              </h4>

              <div v-if="!loading" align="center">

                <div class="d-grid">

                  <button class="btn oauth-ev-btn btn-block btn-flat" @click="resendLink" id="verify_mail_resend">

                    <strong>{{lang('resend_activation_link') }}</strong>
                  </button>
                </div>

                <p class="para-divider p-0" id="or">or</p>

                <a id="update_email" class="content-link text-small"  href="javascript:void(0)" @click="showField()">
                  {{ lang('update-email-address') }}</a>
              </div>

              <!-- Loader when loading -->
              <div v-if="loading">

                <loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="50"/>
              </div>
            </template>

            <!-- =============================================== -->

            <template v-if="updateEmail">


              <h3 id="h3" class="text-muted text-center">{{ lang(title) }}</h3>

              <p v-if="!loading">{{ trans('update-verification-message') }}</p>

              <div :class="{align1 : selectedLanguage === 'ar'}" v-focus-first-input>
                <text-field v-if="!loading" :label="lang('new_email_address')" :value="email_address" :input-style="inputStyle" type="email" name="email_address" :onChange="onChange" :placehold="lang('enter_a_value')" classname="" :required="true" id="new_email_address"></text-field>

                <text-field v-if="!loading" :label="lang('current_password')" :value="password" :input-style="inputStyle" type="password" name="password" :keyupListener="triggerEvent" :onChange="onChange" :placehold="lang('enter_a_value')" classname="" :required="true" id="current_password"></text-field>
              </div>

              <!-- Loader when loading -->
              <div v-if="loading">

                <loader :animation-duration="4000" :color="layout.portal.client_header_color" :size="50"/>
              </div>

              <!-- Button for login and updating email -->
              <div v-if="!loading" class="row">

                <div class="col-xs-6 col-sm-6 col-md-8" :class="{align1 : selectedLanguage === 'ar'}">

                  <router-link to="/oauth/login" class="content-link" id="email_verify_login_link">{{ lang('account_activated') }}</router-link>
                </div>

                <div class="col-xs-6 col-sm-6 col-md-4 float-end" :class="{left : selectedLanguage === 'ar'}">

                  <div class="d-grid">

                    <button id="email_update_btn" class="btn oauth-ev-btn btn-block btn-flat" @click="onSubmit" >{{ lang('update') }}</button>
                  </div>
                </div>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>

  </div>

</template>

<script setup>

import TextField from "../../../MiniComponent/FormField/TextField.vue";
import { errorHandler, successHandler} from "../../../../helpers/responseHandler";
import { validateResetPasswordSettings} from "../../../../helpers/validator/passwordResetRules";
import axios from 'axios';
import { useStore } from "vuex";
import { useRouter } from "vue-router";
import {computed, onBeforeMount, ref} from "vue";
import {lang} from "../../../../helpers/extraLogics";

const props = defineProps({

  layout : { type : Object, default : ()=> {}},

  auth : { type : [Object, Array], default : ()=> []},

  language : { type : String, default : ()=> ''},
})

const loading = ref(false);
const selectedLanguage = ref([]);
const isDisabled = ref(false);
const email_address = ref("");
const password = ref("");
const updateEmail = ref(false);
const title = ref('update_email');
const store = useStore();
const router =  useRouter();
const inputStyle = ref({});

// Computed property for getting verify email status
const getVerifyEmail = computed(() => store.getters.getVerifyEmail);

onBeforeMount(()=>{

  selectedLanguage.value = props.language;

  inputStyle.value = {

    borderColor : props.layout.portal.client_input_field_color

  };

  email_address.value = getVerifyEmail.value;

  // Redirecting to login if no email address found
  if(!email_address.value){

    store.dispatch('setAlert',{type:'danger', message: lang('no_account_email_contact_admin'), component_name:'oauth-email'});

    setTimeout(()=>{

      router.push('/oauth/login');
    }, 3000)
  }
})

// handle's input changes
const onChange = (value, name) => {

  name === 'email_address' ? email_address.value = value : password.value = value;
}

// check's form validity
const showField = () =>{

  updateEmail.value = true;
}

// check's form validity
const isValid = () => {

  const {errors, isValid} = validateResetPasswordSettings({email_address : email_address.value});

  if(!isValid){

    return false;
  }
  return true;
}

// form submission function
const onSubmit = () => {

  if(isValid()){

    isDisabled.value = true;

    loading.value = true;

    const data = { oldEmail: getVerifyEmail.value, email_address: email_address.value, password: password.value }

    axios.post('api/update-email-verification',data).then(response =>{

      initialState();

      successHandler(response,'oauth-updateEmail');

      setTimeout(()=>{

        router.push({ path:'/oauth/login'});
      },4000)
    }).catch(error=>{

      initialState();

      errorHandler(error,'oauth-updateEmail')
    })

  }
}

// reset's initial state
const initialState = () => {

  window.scrollTo(0,0);

  isDisabled.value = false;

  loading.value = false;
}

// trigger's event on key press
const triggerEvent = (event) => {

  var key = event.which || event.keyCode;

  if (key === 13) { // 13 is enter
    onSubmit()
  }
}

// resend's verification link
const resendLink = () =>{

  isDisabled.value=true;

  loading.value=true;

  const data = { email: getVerifyEmail.value }

  axios.post('api/send-email-verification-link',data).then(response =>{

    initialState();

    successHandler(response,'oauth-updateEmail');

    setTimeout(()=>{

      router.push({ path:'/oauth/login'});
    },4000)
  }).catch(error=>{

    initialState();

    errorHandler(error,'updateEmail');
  })
}

</script>

<style scoped>

.content-link{
  color: rgb(0, 154, 186);
}

.content-link:hover{
  color: #337ab7;
}

.oauth-ev-btn{
  color: rgb(255, 255, 255);
  background-color: rgb(9, 159, 220);
}

.oauth-ev-card{
  max-width: 600px !important;
  min-width: 500px !important;
}

@media screen and (max-width: 900px) {
  .oauth-ev-card{
    min-width: 250px !important;
    max-width: 370px !important;
  }
}

.para-divider{
  margin-top: 10px !important;
  margin-bottom: 10px !important;
}

</style>