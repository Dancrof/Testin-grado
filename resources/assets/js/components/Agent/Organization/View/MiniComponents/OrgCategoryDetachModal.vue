<template>
  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

    <template #title>
      <h4 class="modal-title">{{trans(`detach_organization_form`)}}</h4>
    </template>

    <template #fields>

      <div v-if="!loading">
        <span>{{trans(`category_detach_confirmation_message`)}}</span>
      </div>

      <div v-if="loading" class="row">
        <reuse-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
      </div>
    </template>

    <template #controls>
      <button type="button" id="submit_btn" @click = "onSubmit()" class="btn btn-secondary" :disabled="isDisabled">
        <i class="fa fa-unlink"></i>&nbsp; {{ trans('detach')}}
      </button>
    </template>
  </modal>

</template>

<script>

import axios from "axios";

import {errorHandler,successHandler} from "../../../../../helpers/responseHandler";
export default {
  name: "OrgDetachModal",

  props: {
    showModal : { type : Boolean, default : false },
    onClose : { type : Function },
    categoryId : { type : Number, required: true},
    orgId : { type : Number, required: true}
  },

  data() {
    return {
      containerStyle : { width : '500px' },
      isDisabled: false,
      loading: false,
    }
  },

  methods: {
    onSubmit(){
      this.loading = true
      this.isDisabled = true

      axios.delete('/form-category/detach-org/'+this.categoryId +'/' + this.orgId ).then(res=>{
        successHandler(res,'org-view');
        window.emitter.emit('hideOrganizationForms');
        this.onClose()
        this.loading = false;
        this.isDisabled = false;
      }).catch(err => {
        this.loading = false;
        this.isDisabled = false;
        this.onClose()
        errorHandler(err,'org-view')
        window.emitter.emit('hideOrganizationForms');
      })
    }
  }
}
</script>