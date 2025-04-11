<template>

  <div class="col-sm-12">

    <alert componentName="pusher"/>

    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans('Pusher')}}</h3>
      </div>

      <div class="card-body">

        <div class="row" v-if="!hasDataPopulated || loading">

          <reuse-loader :animation-duration="4000" :size="60"/>
        </div>

        <template v-if="hasDataPopulated && !loading">

          <!-- Text input fields for Memcached configuration -->
          <div class="row" v-focus-first-input>

            <text-field :label="trans('websocket_server_host')" type="text" name="websocket_server_host" :value="websocket_server_host"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="127.0.0.1" :hint="trans('pusher_host')">

            </text-field>

            <text-field :label="trans('websocket_server_port')" type="text" name="websocket_server_port" :value="websocket_server_port"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('pusher_port')">

            </text-field>

            <text-field :label="trans('pusher_app_id')" type="text" name="pusher_app_id" :value="pusher_app_id"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('pusher_app_id_info')">

            </text-field>
            <text-field :label="trans('pusher_app_key')" type="text" name="pusher_app_key" :value="pusher_app_key"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('pusher_app_key_info')">

            </text-field>

            <text-field :label="trans('pusher_app_secret')" type="text" name="pusher_app_secret" :value="pusher_app_secret"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('pusher_app_secret_info')">

            </text-field>

            <text-field :label="trans('pusher_app_cluster')" type="text" name="pusher_app_cluster" :value="pusher_app_cluster"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="" :hint="trans('pusher_app_cluster_info')">

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

  name: "SocketDriversPusher",

  data () {

    return {

      loading : false,

      hasDataPopulated : false,

      pageLoad : false,

      driver:'',

      websocket_server_host:'',

      websocket_server_port:'',

      pusher_app_id:'',

      pusher_app_key:'',

      pusher_app_secret:'',

      pusher_app_cluster:'',

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

      axios.get('api/get/socket-driver/pusher').then(res => {

        this.driver=res.data.data.driver;

        this.loading = false;

        this.hasDataPopulated = true;

        this.fillFieldsInfo(res.data.data);

      }).catch(err => {

        this.hasDataPopulated = true;

        this.loading = false;

        errorHandler(err,'pusher');
      });
    },

    // Fill fields with data
    fillFieldsInfo(data){

      const {driver,websocket_server_host,websocket_server_port,pusher_app_id, pusher_app_key, pusher_app_secret, pusher_app_cluster, ssl_crt_path, ssl_prvt_key, ssl_passphrase} = data;
      this.driver = driver
      this.websocket_server_host = websocket_server_host;
      this.websocket_server_port = websocket_server_port;
      this.pusher_app_id = pusher_app_id;
      this.pusher_app_key = pusher_app_key;
      this.pusher_app_secret = pusher_app_secret;
      this.pusher_app_cluster = pusher_app_cluster;
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
          'websocket_server_host': this.websocket_server_host,
          'websocket_server_port': this.websocket_server_port,
          'pusher_app_id': this.pusher_app_id,
          'pusher_app_key': this.pusher_app_key,
          'pusher_app_secret' : this.pusher_app_secret,
          'pusher_app_cluster' : this.pusher_app_cluster,
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

          successHandler(res,'pusher');

          setTimeout(() => {

            return this.$router.push({name: 'WebSocket Settings'});

          }, 3000)

        }).catch(err => {

          this.pageLoad = false;

          errorHandler(err,'pusher');
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
