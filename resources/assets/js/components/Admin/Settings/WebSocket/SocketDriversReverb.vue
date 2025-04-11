<template>

  <div class="col-sm-12">

    <alert componentName="reverb"/>

    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans('Reverb')}}</h3>
      </div>

      <div class="card-body">

        <div class="row" v-if="!hasDataPopulated || loading">

          <reuse-loader :animation-duration="4000" :size="60"/>
        </div>

        <template v-if="hasDataPopulated && !loading">

          <!-- Text input fields for Memcached configuration -->
          <div class="row" v-focus-first-input>

            <text-field :label="trans('reverb_server_host')" type="text" name="reverb_server_host" :value="reverb_server_host"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="127.0.0.1" :hint="trans('reverb_server_host_hint')">

            </text-field>

            <text-field :label="trans('reverb_server_port')" type="text" name="reverb_server_port" :value="reverb_server_port"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('reverb_server_port_hint')">

            </text-field>

            <text-field :label="trans('reverb_host')" type="text" name="reverb_host" :value="reverb_host"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="127.0.0.1" :hint="trans('reverb_host_hint')">

            </text-field>

            <text-field :label="trans('reverb_port')" type="text" name="reverb_port" :value="reverb_port"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('reverb_port_hint')">

            </text-field>

            <text-field :label="trans('reverb_app_id')" type="text" name="reverb_app_id" :value="reverb_app_id"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('reverb_app_id_info')">

            </text-field>
            <text-field :label="trans('reverb_app_key')" type="text" name="reverb_app_key" :value="reverb_app_key"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('reverb_app_key_info')">

            </text-field>

            <text-field :label="trans('reverb_app_secret')" type="text" name="reverb_app_secret" :value="reverb_app_secret"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('reverb_app_secret_info')">

            </text-field>

            <text-field :label="trans('ssl_crt_path')" type="text" name="ssl_crt_path" :value="ssl_crt_path"
                        classname="col-sm-6" :onChange="onChange" placehold="" :hint="trans('ssl_crt_path_info')">

            </text-field>

            <text-field :label="trans('ssl_prvt_key')" type="text" name="ssl_prvt_key" :value="ssl_prvt_key"
                        classname="col-sm-6" :onChange="onChange" placehold="" :hint="trans('ssl_prvt_key_info')">

            </text-field>

            <text-field :label="trans('ssl_passphrase')" type="text" name="ssl_passphrase" :value="ssl_passphrase"
                        classname="col-sm-6" :onChange="onChange" :required="false" placehold="" :hint="trans('ssl_passphrase_info')">

            </text-field>


          </div>
        </template>
      </div>

      <div class="card-footer" v-if="hasDataPopulated">

        <button type="button" class="btn btn-primary" @click="onSubmit" :disabled="pageLoad">

          <i class="fas fa-save"></i> {{trans('save')}}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import axios from "axios";
import {errorHandler, successHandler} from "../../../../helpers/responseHandler";
import { validatePusherDriver } from "../../../../helpers/validator/WebSocketPusherRules";

export default {

  name: "SocketDriversReverb",

  data () {

    return {

      loading : false,

      hasDataPopulated : false,

      pageLoad : false,

      driver:'',

      reverb_server_host:'',

      reverb_server_port:'',

      reverb_app_id:'',

      reverb_app_key:'',

      reverb_app_secret:'',

      reverb_port:'',

      reverb_host:'',

      ssl_crt_path:'',

      ssl_prvt_key:'',

      ssl_passphrase:'',

    }
  },

  // Fetch data before component is mounted
  beforeMount() {

    this.getData();
  },

  methods : {

    // Validate form data
    isValid() {

      const { errors, isValid } = validatePusherDriver(this.$data);

      return isValid;
    },

    // Fetch initial data
    getData() {

      this.loading = true;

      axios.get('api/get/socket-driver/reverb').then(res => {

        this.driver=res.data.data.driver;

        this.loading = false;

        this.hasDataPopulated = true;

        this.fillFieldsInfo(res.data.data);

      }).catch(err => {

        this.hasDataPopulated = true;

        this.loading = false;

        errorHandler(err,'reverb');
      });
    },

    // Fill fields with data
    fillFieldsInfo(data){

      const {driver,reverb_server_host,reverb_server_port, reverb_host,reverb_port,reverb_app_id, reverb_app_key, reverb_app_secret, ssl_crt_path, ssl_prvt_key, ssl_passphrase} = data;
      this.driver = driver
      this.reverb_server_host = reverb_server_host;
      this.reverb_server_port = reverb_server_port;
      this.reverb_host = reverb_host;
      this.reverb_port = reverb_port;
      this.reverb_app_id = reverb_app_id;
      this.reverb_app_key = reverb_app_key;
      this.reverb_app_secret = reverb_app_secret;
      this.ssl_crt_path = ssl_crt_path;
      this.ssl_prvt_key = ssl_prvt_key;
      this.ssl_passphrase = ssl_passphrase;
    },

    // Submit form data
    onSubmit() {
      if(this.isValid()){

        this.pageLoad = true;

        const payload = {
          'default': this.driver,
          'reverb_server_host': this.reverb_server_host,
          'reverb_server_port': this.reverb_server_port,
          'reverb_host' : this.reverb_host,
          'reverb_port' : this.reverb_port,
          'reverb_app_id': this.reverb_app_id,
          'reverb_app_key': this.reverb_app_key,
          'reverb_app_secret' : this.reverb_app_secret,
          'ssl_crt_path' : this.ssl_crt_path,
          'ssl_prvt_key' : this.ssl_prvt_key,
          'scheme' : 'https',
        };

        const optionalFields = {
          'ssl_passphrase' : this.ssl_passphrase,
        };

        for (const [field, value] of Object.entries(optionalFields)) {
          if (value !== '') {
            payload[field] = value;
          }
        }

        axios.post('api/post/socket-driver',payload).then(res => {

          this.pageLoad = false;

          successHandler(res,'reverb');

          setTimeout(() => {

            return this.$router.push({name: 'WebSocket Settings'});

          }, 3000)

        }).catch(err => {

          this.pageLoad = false;

          errorHandler(err,'reverb');
        });
      }

    },

    onChange(value, name) {
      this[name] = value;
    }
  },

  components: {

    'text-field': TextField
  },
}
</script>
