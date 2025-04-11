<template>
  <div class="col-sm-12">
    <alert componentName="oauth-form" />
    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>
    <div class="card card-light">
      <div class="card-header">
        <h3 class="card-title">{{ trans('oauth-edit-form') }}</h3>
        <div class="card-tools">

          <button class="btn btn-tool" @click="showModal = true; revokingTokens=false;"
              v-tooltip="trans('regenerate-client-secret')">
            <i class="glyphicon glyphicon-refresh"></i>
          </button>
          <button
              class="btn btn-tool"
              @click="showModal = true; revokingTokens=true;"
              v-tooltip="trans('revoke-tokens')">
            <i class="glyphicon glyphicon-ban-circle"></i>
          </button>

        </div>
      </div>

      <div class="card-body">
        <div class="row" v-if="!hasDataPopulated || loading">
          <reuse-loader :animation-duration="4000" :size="60" />
        </div>
        <template v-if="hasDataPopulated && !loading">
          <div class="row" v-focus-first-input>
            <div class="text-center col-sm-6">
              <image-upload
                  :label="lang('profile_pic')"
                  :value="profile_pic"
                  name="profile_pic"
                  :onChange="onProfile"
                  :labelStyle="labelStyle"
                  :labelCss="labelCss"
                  buttonName="Change"
              ></image-upload>
            </div>
            <text-field
                :label="lang('description')"
                :placehold="lang('enter_a_value')"
                :value="description"
                type="textarea"
                name="description"
                classname="col-sm-6 "
                :onChange="onChange"
                :hint="lang('description_info')"
                id="description"
                :disabled="false"
                rows="5"
                cols="40"
            ></text-field>
            <text-field
                id="app_name"
                :label="trans('app_name')"
                type="text"
                name="app_name"
                :value="app_name"
                classname="col-sm-6"
                :onChange="onChange"
                :required="true"
                placehold="app_name"
                :hint="trans('app_name_info')"
            ></text-field>
            <text-field
                id="callback"
                :label="trans('callback_url')"
                type="text"
                name="callback_url"
                :value="callback_url"
                classname="col-sm-6"
                :onChange="onChange"
                :required="true"
                placehold="callback_url"
                :hint="trans('callback_url_info')"
            ></text-field>
            <text-field
                id="id"
                :label="trans('homepage_url')"
                type="text"
                name="homepage_url"
                :value="homepage_url"
                classname="col-sm-6"
                :onChange="onChange"
                :required="true"
                placehold="homepage_url"
                :hint="trans('homepage_url_info')"
            ></text-field>
            <text-field
                id="id"
                :label="trans('client_id')"
                type="text"
                name="id"
                :value="id"
                classname="col-sm-6"
                :onChange="onChange"
                :required="true"
                placehold="id"
                :hint="trans('client_id_info')"
                disabled
            ></text-field>

          </div>
        </template>
      </div>
      <div class="card-footer" v-if="hasDataPopulated">
        <button type="button" class="btn btn-primary" @click="onSubmit" :disabled="pageLoad">
          <i class="fas fa-save"></i> {{ trans('update') }}
        </button>
      </div>
    </div>
    <modal
        v-if="showModal"
        :show-modal="showModal"
        :onClose="onClose"
        :containerStyle="containerStyle"
    >
      <template #title>
        <h4 class="modal-title" v-if="revokingTokens">{{ trans('revoke-tokens') }}</h4>
        <h4 class="modal-title" v-else>{{ trans('regenerate-client-secret') }}</h4>
      </template>
      <template #fields>
        <div class="row modal-body" v-if="revokingTokens">
          <div>
          <p v-if="!modalLoading">{{ trans('do-you-want-to-revoke-all-tokens') }}</p>
          </div>
        </div>
        <div class="row modal-body" v-else>
          <div>
          <p v-if="!modalLoading">{{ trans('do-you-want-to-regenrate-client-secret') }}</p>
          </div>
        </div>
        <div v-if="modalLoading" class="row">
          <Loader></Loader>
          <reuse-loader :animation-duration="4000" :size="60" />
        </div>
      </template>
      <template #controls>
        <button type="button" @click="onRevokeIt" class="btn btn-secondary" v-if="revokingTokens">
          <i class="fas fa-sync-alt"></i> {{ trans('Revoke') }}
        </button>
        <button type="button" @click="onUpdate" class="btn btn-secondary" v-else>
          <i class="fas fa-sync-alt"></i> {{ trans('Generate') }}
        </button>
      </template>
    </modal>
    <modal
        v-if="showTokenModal"
        :showModal="showTokenModal"
        :onClose="onClose"
        :containerStyle="containerStyle"
        class="scrollable-area"
    >
      <template #alert>
        <alert componentName="oauth-modal-form" />
      </template>
      <template #title>
        <h4 class="modal-title">{{ trans('oauth-client-id-secret') }}</h4>
      </template>
      <template #fields>
        <div class="row">
          <div class="col-sm-3">
            <lable>{{ trans('client_id') }}</lable>
            <div class="input-group mb-3">
              <input type="number" class="form-control" :value="client_id" disabled />
            </div>
          </div>
          <div class="col-sm-9">
            <lable>{{ trans('client_secret') }}</lable>
            <div class="input-group mb-3">
              <input type="password" class="form-control" :value="client_secret" disabled />
            </div>
          </div>
        </div>
      </template>
      <template #controls>
        <button type="button" @click="copyToken" class="btn btn-primary" :disabled="copied">
          <i :class="copied ? 'fas fa-check' : 'fa fa-clipboard'"></i>
          {{ !copied ? trans('copy') : trans('clipboard-copy-message') }}
        </button>
      </template>
    </modal>
  </div>
</template>

<script>
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import axios from "axios";
import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
import { validateDynamoDriver } from "../../../../helpers/validator/dynamodbDriverRules";
import globalMixin from "../../../../mixins/globalMixin";
import {useRoute, useRouter} from "vue-router";
import copy from "clipboard-copy";
import ImageUpload from "../../../MiniComponent/FormField/ImageUpload.vue";
import {validateOauthFormFields} from "../../../../helpers/validator/validateOauthFormFields";
const router = useRouter();


export default {

  mixins:[globalMixin],

  name: "oauth-form",

  data () {

    return {

      loading : false,

      hasDataPopulated : false,

      pageLoad : false,

      app_name : '',

      callback_url : '',

      id: '',

      showModal:false,

      containerStyle: { width:'600px' },

      modalLoading:false,

      showTokenModal : false,

      onClose: { type: Function},

      client_id: '',

      client_secret: '',

      copied: false,

      labelStyle : { display : 'none' },

      labelCss : { visibility : 'hidden', margin : 'auto'},

      profile_pic: '',

      selectedImage:'',

      homepage_url:'',

      description: '',

      revokingTokens: false,
    }
  },

  // Fetch data before component is mounted
  beforeMount() {

    this.getData();
  },

  methods : {
    // Validate form data
    isValid() {

      const { errors, isValid } = validateOauthFormFields(this.$data);

      return isValid;
    },

    // Fetch initial data
    getData() {

      this.loading = true;
      const route = useRoute();


      axios.get('edit/oauth/'+ route.params.id).then(res => {

        this.id = res.data.data.id;

        this.app_name=res.data.data.name;

        this.callback_url=res.data.data.redirect;

        this.homepage_url = res.data.data.homepage_url;

        this.description = res.data.data.description;

        this.profile_pic = res.data.data.profile_pic

        this.fillFieldsInfo(res.data.data);

        this.loading = false;

        this.hasDataPopulated = true;

      }).catch(err => {

        this.hasDataPopulated = true;

        this.loading = false;

        errorHandler(err,'oauth-form');
      });
    },

    // Fill fields with data
    fillFieldsInfo(data){

      const self =  this;

      const stateData = this.$data;

      Object.keys(data).map(key => {

        if (stateData.hasOwnProperty(key)) {

          self[key] = data[key] === null ? '' : data[key];
        }

      });
    },

    // Submit form data
    onSubmit() {

      if(this.isValid()){

        this.pageLoad = true;

        var fd = new FormData();

        fd.append('id', this.id);

        fd.append('app_name', this.app_name);

        fd.append('callback_url', this.callback_url);

        fd.append('homepage_url', this.homepage_url);

        fd.append('description', this.description);

        if(this.selectedImage) {
          fd.append('profile_pic', this.selectedImage.file, this.selectedImage.name);
        }

        fd.append('_method', "POST");


       axios.post('update/oauth/app-name/callback-url',fd).then(res => {

          this.pageLoad = false;

          successHandler(res,'oauth-form');

          setTimeout(() => {

            return this.$router.push({name: 'oauth.index'});

          }, 3000)

        }).catch(err => {

          this.pageLoad = false;

          errorHandler(err,'oauth-form');
        });
      }

    },

     onUpdate(){

        this.showModal= true;

        this.modalLoading = true;

        let data = {};

        data['id'] = this.id;

       axios.post('re-generate/oauth/client-secret', data).then(res=>{

          this.modalLoading = false;

          this.showModal = false

          if(res.data.data && res.data.data.client_secret) {

            this.client_id = res.data.data.client_id;

            this.client_secret = res.data.data.client_secret;

            this.showTokenModal = true;

            successHandler(res, 'oauth-modal-form');

          } else {

            successHandler(res, 'oauth-form');
          }

        }).catch(err=>{

          errorHandler(err, 'oauth-form');

          this.modalLoading = false;

         this.showModal = false;

       })

    },

    onRevokeIt(){

      this.showModal= true;

      this.modalLoading = true;

      let data = {};

      data['id'] = this.id;

      axios.post('revoke/oauth/client-tokens', data).then(res=>{

        this.modalLoading = false;

        this.showModal= false;

        successHandler(res, 'oauth-form');

        setTimeout(() => {

          return this.$router.push({name: 'oauth.index'});

        }, 3000)

      }).catch(err=>{

        errorHandler(err, 'oauth-form');

        this.modalLoading = false;

        this.showModal = false;

      })

    },

    // Update form field values on change
    onChange(value, name) {

      this[name] = value;
    },

    copyToken(){

      let copyElement = 'Client-Id: '+this.client_id+ '\nClient-Secret: '+this.client_secret;

      copy(copyElement);

      this.copied = true;

      setTimeout(()=>{

        this.copied = false;

        this.showTokenModal = false;

        return this.$router.push({name: 'oauth.index'});

      },3000)
    },

    onProfile(value, name) {

      name === 'profile_pic' ? (this.profile_pic = value.image , this.selectedImage = value) : (this[name] = value);
    },

    onClose(){
      this.showModal = false;
    }

  },

  components: {
    'text-field' : TextField,
    'image-upload' : ImageUpload
  },
}
</script>