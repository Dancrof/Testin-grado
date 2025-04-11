<template>

  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

    <template #title>

      <h4 class="modal-title">{{trans('attach_contacts')}}</h4>

    </template>

	  <template #fields>

		  <div v-if="!loading" class="row">

			  <dynamic-select :label="trans('select_contact')" :multiple="true" name="users" data_key="users" option-label="meta_name"
							  classname="col-sm-12" apiEndpoint="/api/admin/get-users-list?roles[0]=user&active=1" :value="users" :onChange="onChange">
			  </dynamic-select>

		  </div>

		  <div v-if="loading" class="row">

			  <reuse-loader :animation-duration="4000" :size="60" />

		  </div>
	  </template>

    <template #controls>

      <button type="button" @click.prevent="onSubmitUser()" class="btn btn-primary" id="submit_btn" :disabled="isDisabled"><i class="fas fa-check"></i> {{trans('attach')}}

      </button>
    </template>
  </modal>
</template>

<script>

import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

import axios from "axios";
import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";

export default {

  name : 'org-user-modal',

  description : 'Add User to Organization Modal Component',

  props:{

    showModal:{type:Boolean,default:false},

    orgId : { type : [String,Number], default : '' },

    onClose:{type: Function},

    usersList : { type : Array, default : ()=>[] },
  },


  data(){

    return {

      isDisabled:true,

      containerStyle:{ width:'600px' },

      loading:false,

      users : this.usersList
    }
  },
  methods:{

    onChange(value, name){

      this[name]= value;

      this.isDisabled = value === '' ? true : false;
    },

    onSubmitUser(){

      this.loading = true

      this.isDisabled = true

      let obj = {};

      obj['user'] = this.users.map(a=>a.id);

      axios.post('api/org-user-assign/'+this.orgId, obj).then(res=>{

        this.loading = false;

        this.isDisabled = true

        successHandler(res,'org-view');

        window.emitter.emit('OrgMembersrefreshData');

        this.onClose();
      }).catch(err => {

        this.loading = false;

        this.isDisabled = false

        errorHandler(err,'org-view');

        this.onClose();
      })
    },
  },
  components:{

    "dynamic-select": DynamicSelect,
  }
};
</script>

