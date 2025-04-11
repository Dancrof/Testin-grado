<template>
  <div class="col-sm-12">

    <alert componentName="CacheDriversRedis"/>

    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans('redis')}}</h3>
      </div>

      <div class="card-body">

        <div class="row" v-if="!hasDataPopulated || loading">

          <reuse-loader :animation-duration="4000" :size="60"/>
        </div>
        <!-- Display form fields if data is populated and not loading -->
        <template v-if="hasDataPopulated && !loading">

          <div class="row" v-focus-first-input>

            <text-field :label="trans('connection')"  name="connection" :value="connection"
                        classname="col-sm-6" :onChange="onChange" :required="true" :placehold="lang('default')">

            </text-field>
          </div>
        </template>
      </div>

      <div class="card-footer" v-if="hasDataPopulated">
        <!-- Button to submit form -->
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
import { validateRedisDriver} from "../../../../helpers/validator/redisDriverRules";
export default {
  name: "CacheDriversRedis",

  data () {

    return {

      loading : false,

      hasDataPopulated : false,

      pageLoad : false,

      driver:'',  // Driver info

      connection:'',
    }
  },
  // Fetch data before component is mounted
  beforeMount() {

    this.getData();
  },

  methods : {

    // Validate form data
    isValid() {

      const { errors, isValid } = validateRedisDriver(this.$data);

      return isValid;
    },

    // Fetch initial data
    getData() {

      this.loading = true;

      axios.get('api/get/cache-driver/redis').then(res => {

        this.driver=res.data.data.driver;

        this.loading = false;

        this.hasDataPopulated = true;

        this.fillFieldsInfo(res.data.data);

      }).catch(err => {

        this.hasDataPopulated = true;

        this.loading = false;

        errorHandler(err,'CacheDriversRedis');
      });
    },

    // Fill fields with data
    fillFieldsInfo(data){

      const self =  this;

      const stateData = this.$data;

      Object.keys(data).map(key => {

        if (stateData.hasOwnProperty(key)) {

          self[key] = data[key];
        }

      });
    },

    // Submit form data
    onSubmit() {

      if(this.isValid()){
        this.pageLoad = true;

        axios.post('api/post/cache-driver',{

          'default': this.driver,
          'connection_redis': this.connection

        }).then(res => {

          this.pageLoad = false;

          successHandler(res,'CacheDriversRedis');

          setTimeout(() => {

            return this.$router.push({name: 'Cache Driver Index'});

          }, 3000)

        }).catch(err => {

          this.pageLoad = false;

          errorHandler(err,'CacheDriversRedis');
        });
      }

    },

    // Update form field values on change
    onChange(value, name) {

      this[name] = value;
    },
  },

  components: {
    'text-field' :TextField,
  },
}
</script>