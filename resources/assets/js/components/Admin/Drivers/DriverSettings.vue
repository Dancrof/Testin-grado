<template>

  <div class="col-sm-12">

    <alert componentName="driver_settings"/>

    <custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

    <div class="card card-light">

      <div class="card-header">

        <h3 class="card-title">{{trans(driverName)}}</h3>
      </div>

      <div class="card-body">

        <div class="row" v-if="!hasDataPopulated || loading">

          <reuse-loader :animation-duration="4000" :size="60"/>
        </div>

        <template v-if="hasDataPopulated && !loading">

          <div class="row">

            <template v-for="(field,index) in fields">

              <form-field-template :label="trans(field.key)" :name="field.key" classname="col-sm-6" :required="true">

                <input class="form-control" :placeholder="field.placeholder" :name="field.key" type="text" v-model="field.value">
              </form-field-template>
            </template>
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

import {errorHandler, successHandler} from "../../../helpers/responseHandler";
import axios from 'axios'
import {getIdFromUrl} from "../../../helpers/extraLogics";
import FormFieldTemplate from "../../MiniComponent/FormField/FormFieldTemplate.vue";

export default {

  name : 'drivers-settings',

  description: "drivers settings configuration component",

  data () {

    return {

      loading : false,

      hasDataPopulated : false,

      pageLoad : false,

      driverId : '',

      fields : [],

      driverName : ''
    }
  },

  beforeMount() {

    this.driverId = getIdFromUrl(window.location.pathname);

    this.getData();
  },

  methods : {

    getData() {

      this.loading = true;

      axios.get('/api/get/search-driver-details/'+this.driverId).then(res => {

        this.fields = res.data.data.formDetails;

        this.driverName = res.data.data.driverName;

        this.loading = false;

        this.hasDataPopulated = true;

      }).catch(err => {

        this.hasDataPopulated = true;

        this.loading = false;

        this.fields = [];

        errorHandler(err,'driver_settings');
      });
    },

    onSubmit() {

      const data = {};

      this.fields.forEach((obj)=>{

        data[obj.key] = obj.value;
      });


      data['driver'] = this.driverName

      data['status'] = 1

      this.pageLoad = true;

      axios.post('api/post/search-driver', data).then(res => {

        this.pageLoad = false;

        successHandler(res,'driver_settings');

        setTimeout(() => {

          return this.$router.push({name: 'Drivers Index'});

        }, 3000)

        this.$store.dispatch('unsetValidationError');

      }).catch(err => {

        this.pageLoad = false;

        errorHandler(err,'driver_settings');
      });

    }
  },

  components : {

    'form-field-template': FormFieldTemplate,
  }
};
</script>