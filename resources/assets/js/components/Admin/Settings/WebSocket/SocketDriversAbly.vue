<template>
  <div class="col-sm-12">

    <alert componentName="SocketDriversAbly"/>

    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans('Ably')}}</h3>
      </div>

      <div class="card-body">

        <div class="row" v-if="!hasDataPopulated || loading">

          <reuse-loader :animation-duration="4000" :size="60"/>
        </div>

        <template v-if="hasDataPopulated && !loading">

          <div class="row" v-focus-first-input>

            <text-field id="key" :label="trans('ably_key')" type="text" name="key" :value="key"
                        classname="col-sm-6" :onChange="onChange" :required="true" placehold="id" :hint="trans('ably_key_info')">

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
  name: "SocketDriversAbly",

  data () {

    return {

      loading : false,

      hasDataPopulated : false,

      pageLoad : false,

      key:'',
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

      axios.get('api/get/socket-driver/ably').then(res => {

        this.driver=res.data.data.driver;

        this.fillFieldsInfo(res.data.data);

        this.loading = false;

        this.hasDataPopulated = true;

      }).catch(err => {

        this.hasDataPopulated = true;

        this.loading = false;

        errorHandler(err,'SocketDriversAbly');
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

        data['ably_key'] = this.key;

        axios.post('api/post/socket-driver',data).then(res => {

          this.pageLoad = false;

          successHandler(res,'SocketDriversAbly');

          setTimeout(() => {

            return this.$router.push({name: 'WebSocket Settings'});

          }, 3000)

        }).catch(err => {

          this.pageLoad = false;

          errorHandler(err,'SocketDriversAbly');
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