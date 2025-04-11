<template>

  <div class="col-sm-12">

    <alert componentName="mem-cached"/>

    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans('memcached')}}</h3>
      </div>

      <div class="card-body">

        <div class="row" v-if="!hasDataPopulated || loading">

          <reuse-loader :animation-duration="4000" :size="60"/>
        </div>

        <template v-if="hasDataPopulated && !loading">

          <!-- Text input fields for Memcached configuration -->
          <div class="row" v-focus-first-input>

            <text-field :label="trans('host')" type="text" name="host" :value="host"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="127.0.0.1">

            </text-field>

            <text-field :label="trans('port')" type="text" name="port" :value="port"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="11211">

            </text-field>

            <text-field :label="trans('persistent_id')" type="text" name="persistent_id" :value="persistent_id"
                        classname="col-sm-6" :onChange="onChange" :placehold="lang('id')">

            </text-field>

            <text-field :label="trans('user_name')" type="text" name="user_name" :value="user_name"
                        classname="col-sm-6" :onChange="onChange" :placehold="lang('username')">

            </text-field>

            <text-field :label="trans('password')" type="text" name="password" :value="password"
                        classname="col-sm-6" :onChange="onChange" :placehold="lang('password')">

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
import { validateMemcachedDriver } from "../../../../helpers/validator/memcachedDriverRules";

export default {

  name: "CacheDriversMemcached",

  data () {

    return {

      loading : false,

      hasDataPopulated : false,

      pageLoad : false,

      driver:'',

      host:'',

      port:'',

      persistent_id:'',

      user_name:'',

      password:''
    }
  },

  // Fetch data before component is mounted
  beforeMount() {

    this.getData();
  },

  methods : {

    // Validate form data
    isValid() {

      const { errors, isValid } = validateMemcachedDriver(this.$data);

      return isValid;
    },

    // Fetch initial data
    getData() {

      this.loading = true;

      axios.get('api/get/cache-driver/memcached').then(res => {

        this.driver=res.data.data.driver;

        this.loading = false;

        this.hasDataPopulated = true;

        this.fillFieldsInfo(res.data.data);

      }).catch(err => {

        this.hasDataPopulated = true;

        this.loading = false;

        errorHandler(err,'mem-cached');
      });
    },

    // Fill fields with data
    fillFieldsInfo(data){

      const { driver, servers, persistent_id, sasl } = data;
      this.driver = driver
      this.host = servers[0].host;
      this.port = servers[0].port;
      this.persistent_id = persistent_id;
      this.user_name = sasl[0];
      this.password = sasl[1];
    },

    // Submit form data
    onSubmit() {

      if(this.isValid()){

        this.pageLoad = true;

        const payload = {
          'default': this.driver,
          'memcached_host': this.host,
          'memcached_port': this.port
        };

        const optionalFields = {
          'memcached_username': this.user_name,
          'memcached_persistent_id': this.persistent_id,
          'memcached_password': this.password
        };

        for (const [field, value] of Object.entries(optionalFields)) {
          if (value !== '') {
            payload[field] = value;
          }
        }

        axios.post('api/post/cache-driver',payload).then(res => {

          this.pageLoad = false;

          successHandler(res,'mem-cached');

          setTimeout(() => {

            return this.$router.push({name: 'Cache Driver Index'});

          }, 3000)

        }).catch(err => {

          this.pageLoad = false;

          errorHandler(err,'mem-cached');
        });
      }

    },

    // Update form field values on change
    onChange(value, name) {

      this[name] = value;
    },
  },

  components: {

    'text-field': TextField
  },
}
</script>
