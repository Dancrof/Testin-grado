<template>

  <!-- Main container for the OAuth login -->
  <div class="oauth-login">

    <div class="login-content-area pb-0">

      <div id="content" class="site-content">

        <!-- Logo container -->
        <div v-if="!loading" class='logo-container'>
<!--          <img alt="Faveo Helpdesk" width="100" height="50" :src="base+imageUrl">-->

          <div v-if="layout && layout.company && layout.company.use_logo == '1'">
            <img :src="layout.company.logo" alt="User Image" style="max-width: 300px; max-height: 127px;">
          </div>
          <div id="client_logo_title" class="content-link" v-else>
            {{layout && layout.system && layout.system.name !== '' ? layout.system.name : 'SUPPORT CENTER'}}
          </div>

        </div>

        <!-- Router view for rendering authentication components -->
        <router-view :auth="auth" :layout="layout" :language="selectedLanguage"></router-view>

        <!-- Vue progress bar component -->
        <vue-progress-bar class="color-shift-progress-bar"></vue-progress-bar>

        <!-- Language selection dropdown -->
        <div v-if="!loading" class="text-start pt-3">

          <select  class="form-select-sm bg-transparent border-0 text-secondary text-small" :class="selectedLanguage === 'ar' ? 'float-end': ''"
                   @change="changeLang($event)" v-model="selectedLanguage" aria-label="form-select-sm">

            <option v-for="language in langSorted" :value="language.locale" :key="language.key" :id="'client_lang_'+language.locale" >
              {{language.name}}&nbsp;{{'('+ language.translation +')'}}
            </option>
          </select>

        </div>
      </div>

    </div>

    <!-- Footer container -->
    <span class="footer-container pb-2">

      	<p class="text-secondary text-center text-small">{{ lang('copyright') }} © {{moment().year()}}

		<a :href="layout && layout.company ? layout.company.website : '#'" class="content-link" target="_blank" id="copyright_link">
        {{ layout && layout.company ? layout.company.company_name : '' }}.
    </a>

    <template v-if="whiteLabel"> {{ trans('all_rights_reserved') }}. </template>

    <template v-else>

      {{ trans('all_rights_reserved') }}. {{ trans('powered_by') }} <a class="content-link" id="copyright_link" href="https://www.faveohelpdesk.com/" target="_blank">Faveo</a>
    </template>
	</p>
      </span>
  </div>

</template>

<script setup>

import { ref, onBeforeMount, computed , getCurrentInstance} from 'vue';

import axios from "axios";

import moment from 'moment';

const props = defineProps({

  layout : { type : Object, default : ()=> {}},

  auth : { type : [Object, Array], default : ()=> []},

  whiteLabel : { type : Boolean , default : false},
})

const base = ref('');
const languages = ref([]);
const selectedLanguage = ref([]);
const imageUrl = ref('');
const loading = ref(false);

onBeforeMount(()=>{

  // base URL
  base.value = props.auth.system_url;

  // image URL based on whether it's a white label or not
  imageUrl.value = props.whiteLabel ? '/themes/default/common/images/whitelabel.png' : '/themes/default/common/images/installer/faveo.png'

  // selected language
  selectedLanguage.value = props.layout.language;

  loading.value = true;

  // Fetch available languages
  axios.get('api/dependency/languages?meta=true').then(response => {

    languages.value=response.data.data.languages;

    loading.value = false;
  }).catch(error=>{});
})

// Computed property to sort languages alphabetically
const langSorted = computed(() => {
  return languages.value.slice().sort((a, b) => {
    return a.name.localeCompare(b.name);
  });
});

const changeLang = (event) => {

  // Get selected language
  let locale = event.target.value;

  // Update's user's language preference
  axios.post('api/user-language?locale='+locale).then(res=>{


    // Reload page to apply language changes
    window.location.reload();
  })
};

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

.oauth-login{
  background-color: #fcfcfc;
  color: initial !important;
  border: none !important;
}

.footer-container {
  background-color: #fcfcfc;
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
}

.content-link{
  color: rgb(0, 154, 186);
}

.color-shift-progress-bar {
  width: 100%;
  height: 5px;
  background: linear-gradient(90deg, transparent 0, #00e1ff 200px, transparent 0);
  background-size: 200% 10px;
  animation: color-move-animation 2s linear infinite;
}

@keyframes color-move-animation {
  0% {
    background-position: 100% 0;
  }
  100% {
    background-position: -100% 0;
  }
}

#client_logo_title {
  font-size: 32px !important;
  font-weight : 600 !important;
  text-decoration: none !important;
}

</style>