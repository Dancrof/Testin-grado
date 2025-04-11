<template>
  <div>
    <loader v-if="submitFormInProgress || isChildFormLoading"/>

    <modal :showModal="show" :onClose="closeModal">
      
      <template #title><h4>{{ panel === 'client' ? lang('register') : lang('create_user') }}</h4></template>

		<template #fields>
			<div v-show="!isChildFormLoading" id="user-form-modal-body" :class="formId == 'chat-widget' ? 'ps-2' : ''">

				<alert componentName="user-form-modal"/>

				<form-with-captcha :loading="!isChildFormLoading" btnClass='btn btn-custom pull-right text-white' btnName="submit"
								   componentName="user-form-modal" :btnStyle="btnStyle"
								   btn_id="user-submit" :formSubmit="formSubmit" :page="formId == 'chat-widget' ? '' : 'user_create_agent'"
								   recaptchaContainerClass="col offset-md-2 col-md-10" :inputStyle="inputStyle" :disableSubmit="submitFormInProgress">

					<template #fields>

						<div class="row">

							<ValidationObserver ref="faveoFormObserver" v-slot="{ values, errors, validate }">
								<form-renderer
									category="user"
									fetchFormFieldApi="api/form/render"
									scenario="create"
									:panel="panel"
									:formUniqueKey="formUniqueKey"
									:isChildForm="true"
									:inputStyle="inputStyle"
									:btnStyle="btnStyle"
                                    :apiKey="apiKey"
								>
								</form-renderer>
							</ValidationObserver>
						</div>
					</template>
				</form-with-captcha>
			</div>
		</template>

		<template v-show="!isChildFormLoading" #controls>
			<button type="button" class="btn"
					:class="[panel === 'client' ? 'btn-custom text-white' : 'btn-primary', 'pull-right']"
					:disabled="submitFormInProgress"
					@click="popUpSubmit()"
					:style="btnStyle">
				<span><i class="fas fa-save"></i></span>&nbsp;&nbsp;{{ trans('submit') }}
			</button>
		</template>
    </modal>
  </div>
</template>

<script>
import {faveoFormCommons} from '../../../mixins/faveoFormCommons';
import Modal from '../../../components/Common/Modal.vue';
import Alert from "../../MiniComponent/Alert.vue";
import Loader from "../../MiniComponent/Loader.vue";
import FormWithCaptcha from "./FormWithCaptcha.vue";

export default {
  name: 'user-form-modal',

  props: {
    show: {type: Boolean, default: false},
    closeModal: {type: Function, required: true},
    updateNewRequester: {type: Function, required: true},
    panel: {type: String, default: 'agent'},
	  btnStyle : { type : Object, default : ()=>{}},
	  inputStyle : { type : Object, default : ()=>{}},
      formId: { type: String, default: '' },
      apiKey: { type: String, default: '' }
  },

  data: () => {
    return {
      formUniqueKey: '',
      submitFormInProgress: false
    }
  },

  mixins: [faveoFormCommons],

  methods: {
    /**
     * it clicks the button, it clicks the button in FormWithCaptcha which in change triggers formSubmit.
     * Reason for this workaround is to hide the submit button coming from FormWithCaptcha without breaking
     * the functionality
     */
    popUpSubmit() {
      document.getElementById('user-submit').click();
    },

    formSubmit(key, value) {
      this.$store.dispatch('setRecaptchaKey', value)
      this.onSubmit();
    },

    afterSubmit(data) {
      
      window.emitter.emit('reset-captcha');
      
      let requesterData = data.data.data;

      if(!requesterData.email){

        requesterData['name'] = requesterData.full_name;
      }

      this.updateNewRequester(requesterData);

      this.closeModal();

      if(this.panel=== 'client'){
        window.emitter.emit('updateTicketCategory','from_register')
      }
    },

    afterError() {
      this.closeModal();
    }
  },

  components: {
    'modal': Modal,
    'alert': Alert,
    'loader': Loader,
    "form-with-captcha": FormWithCaptcha
  }
}
</script>

<style scoped>
#user-form-modal-body {
  max-height: 300px;
  overflow-y: auto;
  overflow-x: hidden;
    padding-top: 10px;
}
</style>

<style>

#user-submit{
  display: none;
}
</style>