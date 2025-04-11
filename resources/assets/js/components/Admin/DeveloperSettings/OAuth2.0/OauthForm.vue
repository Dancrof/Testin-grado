<template>
  <div class="col-sm-12">

    <alert componentName="oauth-form"/>

    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans('oauth-clients-create')}}</h3>
      </div>

      <div class="card-body">

        <div class="row" v-if="loading">

          <reuse-loader :animation-duration="4000" :size="60"/>
        </div>

        <template v-if="!loading">

          <div class="row" v-focus-first-input>

            <text-field id="app_name" :label="trans('app_name')" type="text" name="app_name" :value="app_name"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="app_name" :hint="trans('app_name_info')">

            </text-field>

            <text-field id="callback" :label="trans('callback_url')" type="text" name="callback_url" :value="callback_url"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="callback_url" :hint="trans('callback_url_info')">

            </text-field>

            <text-field id="homepage_url" :label="trans('homepage_url')" type="text" name="homepage_url" :value="homepage_url"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="homepage_url" :hint="trans('homepage_url_info')">

            </text-field>

            <text-field :label="lang('description')" :placehold="lang('enter_a_value')"
                :value="description" type="textarea" name="description"
                classname="col-sm-6 " :onChange="onChange" :hint="lang('description_info')"
                id="description" :disabled="false"/>

          </div>
        </template>
      </div>

      <div class="card-footer">

        <button type="button" class="btn btn-primary" @click="onSubmit" :disabled="pageLoad">

          <i class="fas fa-save"></i> {{trans('save')}}
        </button>
      </div>
    </div>
    <modal v-if="showTokenModal" :showModal="showTokenModal" :onClose="onClose" :containerStyle="containerStyle" class="scrollable-area">
      <template #alert>
        <alert componentName="oauth-modal-form"/>
      </template>

      <template #title>

        <h4 class="modal-title">{{ trans('oauth-client-id-secret')}}</h4>
      </template>

      <template #fields>
      <div class="row">
        <div class="col-sm-3">
          <lable>{{trans('client_id')}}</lable>
          <div class="input-group mb-3">
            <input type="number" class="form-control" :value="client_id" disabled>
          </div>
        </div>
        <div class="col-sm-9">
          <lable>{{trans('client_secret')}}</lable>
          <div class="input-group mb-3">
            <input type="password" class="form-control" :value="client_secret" disabled>
          </div>
        </div>
      </div>
      </template>

      <template #controls>
        <button type="button" @click="copyToken" class="btn btn-primary" :disabled="copied">
          <i :class="copied ? 'fas fa-check' : 'fa fa-clipboard'"></i> {{ !copied ? trans('copy') : trans('clipboard-copy-message') }}
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
import copy from "clipboard-copy";
import Modal from "../../../Common/Modal.vue";
import globalMixin from "../../../../mixins/globalMixin";
import {validateOauthFormFields} from "../../../../helpers/validator/validateOauthFormFields";
export default {

  mixins: [globalMixin],

  name: "oauth-form",

  data () {

    return {

      loading : false,

      pageLoad : false,

      app_name:'',

      callback_url:'',

      homepage_url:'',

      showTokenModal : false,

      onClose: { type: Function},

      client_id: '',

      client_secret: '',

      description: '',

      copied: false,

      containerStyle: { width:'600px' },

    }
  },

  methods : {
    // Validate form data
    isValid() {

      const { errors, isValid } = validateOauthFormFields(this.$data);

      return isValid;
    },

    // Submit form data
    onSubmit() {

      if(this.isValid()){

        this.pageLoad = true;

        let data = {};

        data['app_name'] = this.app_name;

        data['callback_url'] = this.callback_url;

        data['homepage_url'] = this.homepage_url;

        data['description']  = this.description;

        axios.post('generate/oauth/client',data).then(res => {

          this.pageLoad = false;

          this.client_id = res.data.data.client_id

          this.client_secret = res.data.data.client_secret;

          this.showTokenModal = true;

          successHandler(res,'oauth-modal-form');

        }).catch(err => {

          this.pageLoad = false;

          errorHandler(err,'oauth-form');
        });
      }

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
    }
  },

  components: {
    Modal,
    'text-field' : TextField
  },
}
</script>