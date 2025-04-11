<template>
    <div id="create-org" class="float-end">
    <custom-loader v-if="submitFormInProgress"/>
      <a data-bs-toggle="modal" @click="showModalMethod" href="javascript:;" type="button" data-bs-target="#modal_body" class="btn btn-link ps-0 pe-0" v-tooltip="lang('create')">&nbsp;&nbsp;
        <i class="fas fa-edit"></i> |&nbsp;</a>

      <modal v-if="showForm" :showModal="showForm" :onClose="onClose">
        <template #title>
          <h4>{{ lang('create_organization') }}</h4>
        </template>

		  <template #fields>

			  <loader v-if="showLoader"/>

			  <div id="modal_body">
				  <alert componentName="faveo-form"/>

				  <form-with-captcha v-if="formUniqueKey && formSelected" :loading="!showLoader" btnClass='btn btn-primary pull-right' btnName="submit"
									 componentName="faveo-form"
									 btn_id="organization-submit-button" :formSubmit="formSubmit" page="organisation_create_agent"
									 recaptchaContainerClass="mt-2" :disableSubmit="submitFormInProgress">

					  <template #fields>
						  
						  <ValidationObserver ref="faveoFormObserver" v-slot="{ values, errors, validate }">
							  <form-renderer
								  :key="formUniqueKey"
								  :fetchFormFieldApi="fetchFormFieldApi"
								  category="organisation"
								  :scenario="scenario"
								  :panel="panel"
								  :isInlineForm="false"
								  :formUniqueKey="formUniqueKey">
							  </form-renderer>
						  </ValidationObserver>
					  </template>
				  </form-with-captcha>
			  </div>
		  </template>

        <template #controls>
          <button v-if="!showLoader" type="button" class="btn btn-primary pull-right" :disabled="submitFormInProgress"
                  @click="popUpSubmit()">
            <i class="fas fa-sync"></i>
            {{ trans('update') }}
          </button>
        </template>

      </modal>
    </div>
</template>

<script>

import {faveoFormCommons} from "../../../../../mixins/faveoFormCommons";
import FormWithCaptcha from "../../../../Common/NewForm/FormWithCaptcha.vue";
import {errorHandler} from "../../../../../helpers/responseHandler";

export default {
  name: 'edit-ticket-modal',
  description: 'Edit Ticket modal Component',

  props: {
    showModal: {type: Boolean, default: false},
    userId: {type: [String, Number], default: ''},
  },

  data() {
    return {
      formUniqueKey: '',
      submitFormInProgress: false,
      scenario: 'create',
      panel: 'agent',
      showForm: false,
	    formSelected: false,
	    fetchFormFieldApi: '',
	    selectedForm: '',
    }
  },
	
	beforeMount() {
		
		this.getDefaultFormValue();
	},
	
  mixins: [faveoFormCommons],

  methods: {
	  
	  /**
	   * Retrieves the default form value.
	   */
	  getDefaultFormValue () {
		  
		  axios.get('/from/forms/organisation').then(res=>{
			  
			  this.selectedForm = res.data.data.data[0];
			  
			  this.updateFetchApi()
			  
		  }).catch(err=>{
			  
			  errorHandler(err,'faveo-form')
		  })
	  },
	  /**
	   * Updates the API endpoint for fetching form fields.
	   */
	  updateFetchApi() {
		  
		  this.$store.dispatch('destroyFormInsatnce', this.formUniqueKey);
		  
		  this.$store.dispatch('unsetValidationError');
		  
		  this.fetchFormFieldApi = '/render/form?id=' + this.selectedForm.id + '&mode=render'
		  
		  setTimeout(()=>{
			  
			  this.$store.dispatch('createNewFormInstance', { formUniqueKey: this.formUniqueKey, scenario: this.scenario || 'create' });
			  
			  this.formSelected = true;
		  },1)
	  },
	  
    /**
     * it clicks the button, it clicks the button in FormWithCaptcha which in change triggers formSubmit.
     * Reason for this workaround is to hide the submit button coming from FormWithCaptcha without breaking
     * the functionality
     */
    popUpSubmit() {
      document.getElementById('organization-submit-button').click();
    },

    formSubmit(key, value) {
      this.$store.dispatch('setRecaptchaKey', value)
      this.onSubmit({user_id: this.userId});
    },

    afterSubmit(data) {
      window.emitter.emit('reset-captcha');
      setTimeout(() => {
        window.emitter.emit('refreshUserData', true);
        this.onClose();
      }, 1000);
    },

    showModalMethod() {

      this.showForm = true;
    },
    onClose(){

      this.showForm = false;
    }
  },

  beforeDestroy() {
    this.$store.dispatch('unsetAlert');
  },

  components: {
    "form-with-captcha": FormWithCaptcha
  }
};
</script>

<style scoped>
#modal_body {
  max-height: 300px;
  overflow-y: auto;
  overflow-x: hidden;
}


#create-org {
  display: inline-block;
}

</style>

<style>

#organization-submit-button{
/* hiding main button because there already is a button exists in the popup */
  display: none;
}

.modal-backdrop {
	display: none !important;
}

.modal-backdrop.show {
	opacity: 0 !important;
	z-index: unset !important;
}

.modal-dialog{
	max-width: unset !important;
}
</style>