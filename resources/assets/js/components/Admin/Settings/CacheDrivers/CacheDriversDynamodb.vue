<template>
  <div class="col-sm-12">

    <alert componentName="CacheDriversDynamodb"/>

    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans('Dynamodb')}}</h3>
      </div>

      <div class="card-body">

        <div class="row" v-if="!hasDataPopulated || loading">

          <reuse-loader :animation-duration="4000" :size="60"/>
        </div>

        <template v-if="hasDataPopulated && !loading">

          <div class="row" v-focus-first-input>
            <!-- Text input fields for DynamoDB configuration -->
            <text-field id="endpoint" :label="trans('endpoint')" type="text" name="endpoint" :value="endpoint"
                        classname="col-sm-6" :onChange="onChange" :required="true" :placehold="lang('endpoint')">

            </text-field>

            <text-field id="key" :label="trans('key')" type="text" name="key" :value="key"
                        classname="col-sm-6" :onChange="onChange" :required="true" :placehold="lang('id')">

            </text-field>

            <text-field id="region" :label="trans('region')" type="text" name="region" :value="region"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="usa">

            </text-field>

            <text-field id="secret" :label="trans('secret')" type="text" name="secret" :value="secret"
                        classname="col-sm-6" :onChange="onChange" :required="true" :placehold="lang('secret')">

            </text-field>

            <text-field id="table" :label="trans('table')" type="text" name="table" :value="table"
                        classname="col-sm-6" :onChange="onChange" :required="true" :placehold="lang('cache')">

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
import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
import { validateDynamoDriver } from "../../../../helpers/validator/dynamodbDriverRules";

export default {
  name: "CacheDriversDynamodb",

  data () {

    return {

      loading : false,

      hasDataPopulated : false,

      pageLoad : false,

      endpoint:'',

      key:'',

      region:'',

      secret:'',

      table:'',

      driver:''
    }
  },

  // Fetch data before component is mounted
  beforeMount() {

    this.getData();
  },

  methods : {
    // Validate form data
    isValid() {

      const { errors, isValid } = validateDynamoDriver(this.$data);

      return isValid;
    },

    // Fetch initial data
    getData() {

      this.loading = true;

      axios.get('api/get/cache-driver/dynamodb').then(res => {

        this.driver=res.data.data.driver;

        this.fillFieldsInfo(res.data.data);

        this.loading = false;

        this.hasDataPopulated = true;

      }).catch(err => {

        this.hasDataPopulated = true;

        this.loading = false;

        errorHandler(err,'CacheDriversDynamodb');
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

        let data = {};

        data['default'] = this.driver;

        data['aws_access_key_id'] = this.key;

        data['aws_secret_access_key'] = this.secret;

        data['dynamodb_cache_table'] = this.table;

        data['dynamodb_endpoint'] = this.endpoint;

        data['aws_default_region'] = this.region;

        axios.post('api/post/cache-driver',data).then(res => {

          this.pageLoad = false;

          successHandler(res,'CacheDriversDynamodb');

          setTimeout(() => {

            return this.$router.push({name: 'Cache Driver Index'});

          }, 3000)

        }).catch(err => {

          this.pageLoad = false;

          errorHandler(err,'CacheDriversDynamodb');
        });
      }

    },

    // Update form field values on change
    onChange(value, name) {

      this[name] = value;
    },
  },

  components: {
    'text-field' : TextField
  },
}
</script>