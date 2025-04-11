<template>

  <!-- Card for forgot password -->
  <div class="card oauth-fp-card shadow-lg mt-3">

    <div class="card-body pb-1">

      <div :class="{forgot_align : selectedLanguage === 'ar'}">

        <meta-component :dynamic_title="lang('password-email-title')" :dynamic_description="lang('password-email-description')" :layout="layout" >

        </meta-component>

        <h3 id="h3" class="mb-10 text-center text-secondary">{{ lang(title) }}</h3>

        <!-- Alert component for password -->
        <alert componentName="oauth-password"/>

        <!-- Loader when loading -->
        <div v-if="loading">

          <loader :animation-duration="4000" :color="layout.portal.client_header_color" :size="50"/>
        </div>

        <!-- Input field for email -->
        <div :class="{ align1 : selectedLanguage === 'ar'}" v-focus-first-input>

          <TextField v-if="!loading" :label="lang('email')" :value="email_address" id="forgot_pass_email"
                     type="email" name="email_address" :keyupListener="triggerEvent" :onChange="onChange" :placehold="lang('enter_a_value')" classname="" :required="true" rules="email">

          </TextField>
        </div>

        <div v-if="!loading" class="row pb-3">

          <!-- Link to login page -->
          <div class="col-sm-6 col-md-8" :class="{align1 : selectedLanguage === 'ar'}">

            <router-link :to="'/oauth/login?application='+application" class="content-link" id="forgot_to_login">{{ lang('i_know_my_password') }}</router-link>
          </div>

          <!-- Button to submit -->
          <div class=" col-sm-6 col-md-4 float-end" :class="{left : selectedLanguage === 'ar'}">

            <div class="d-grid">

              <button class="btn oauth-fp-btn btn-block btn-flat" @click="onSubmit()" id="forgot_pass_action">
                <strong>{{ lang('send') }}</strong>

              </button>
            </div>
          </div>
        </div>

      </div>
    </div>

  </div>
</template>

<script setup>

import { ref, onBeforeMount, computed } from "vue";

import TextField from "../../../MiniComponent/FormField/TextField.vue";

import axios from 'axios';

import {useRoute, useRouter} from "vue-router";

import { validateResetPasswordSettings } from "../../../../helpers/validator/passwordResetRules";

import {errorHandler, successHandler} from "../../../../helpers/responseHandler";

const props = defineProps({

  layout : { type : Object, default : ()=> {}},

  auth : { type : [Object, Array], default : ()=> []},

  language : { type : String, default : ()=> ''},
})

const selectedLanguage = ref([]);
const router = useRouter();
const route = useRoute();
const title = ref('forgot_password');
const loading = ref(false);
const email_address = ref('');
const isDisabled = ref(false);
const application = ref('');


onBeforeMount(()=>{

  // Redirect to login page if user data is not an array
  if(!Array.isArray(props.auth.user_data)){
    router.push({path:'oauth/login', name: 'OAuthLogInPage'});
  }

  selectedLanguage.value = props.language;

  application.value = route.query.application;
})

// handle's input change
const onChange  = (value, name) => {
 email_address.value = value;
}

// check's form validity
const isValid = () => {

  const { errors, isValid } = validateResetPasswordSettings({email_address : email_address.value});

  if (!isValid) {

    return false;
  }
  return true;
}

// handle's form submission
const onSubmit = () =>{

  if (isValid()) {

    isDisabled.value=true;

    loading.value=true;

    const data = 'email=' + email_address.value;

    axios.post('api/password/email',data).then(response =>{

      initialState();

      successHandler(response,'oauth-password');

      setTimeout(()=>{

        router.push({ path:'/oauth/login',name: 'OAuthLogInPage'});
      },3000)

    }).catch(error=>{

      initialState();

      errorHandler(error,'oauth-password')
    })
  }
}

// reset's initial state
const initialState = () => {

  window.scrollTo(0, 0);

  isDisabled.value = false;

  loading.value = false;
}

// trigger's event on key press
const triggerEvent = (event) => {

  var key = event.which || event.keyCode;

  if (key === 13) {

    onSubmit()
  }
}

</script>

<style scoped>

.oauth-fp-btn{
  color: rgb(255, 255, 255);
  background-color: rgb(9, 159, 220);
}

  .oauth-fp-card{
    max-width: 900px !important;
    min-width: 500px !important;
  }

  @media screen and (max-width: 900px) {
    .oauth-fp-card{
      max-width: 500px !important;
      min-width: 300px !important;
    }
  }

.content-link{
  color: rgb(0, 154, 186);
}

.content-link:hover{
  color: #337ab7;
}

</style>