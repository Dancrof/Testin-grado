<template>

	<div>

		<CustomLoader v-if="submitFormInProgress"></CustomLoader>

		<Modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="{ width : '1200px', maxWidth: '1200px !important'}">

		  	<template #title>

				<h4 class="modal-title">{{ lang('fork_ticket') }}</h4>
		  	</template>

			<template #fields>

				<Loader v-if="showLoader" />

				<div id="ticket_fork_body">

					<Alert componentName="faveo-form" />

					<FormWithCaptcha :loading="!showLoader" btnClass='btn btn-primary pull-right' btnName="submit"
					   	componentName="faveo-form"
					   	btn_id="fork-ticket-submit" :formSubmit="formSubmit" page="ticket_fork_agent"
					   	recaptchaContainerClass="mt-2" :disableSubmit="submitFormInProgress">

						<template #fields>

							<ValidationObserver ref="faveoFormObserver" v-slot="{ values, errors, validate }">
								<FormRenderer
									category="ticket"
									:fetchFormFieldApi="'api/agent/edit-mode-ticket-details/' + this.ticketId"
									:scenario="scenario"
									:panel="panel"
									:isInlineForm="false"
									:formUniqueKey="formUniqueKey"
									:selectDependencyId="ticketId"
									selectDependencyKey="id"
								>
								</FormRenderer>
							</ValidationObserver>
						</template>
					</FormWithCaptcha>

					<div class="row ms-0 p-2" v-if="!showLoader">

						<RadioButton :options="radioOptions"
					  		:label="trans('ticket_fork_keep_status_of_parent_ticket_as_open_after_forking')"
					  		name="keepTicketStatusOpenAfterFork" :value="keepTicketStatusOpenAfterFork"
					  		:onChange="onChange" classname="col-sm-6"
						/>
						<br>
						<RadioButton :options="radioOptions"
						  	:label="trans('parent_ticket_thread')"
						  	name="Parent" :value="Parent"
						  	:onChange="onChange" classname="col-sm-6"
						/>
					</div>
					<!-- commenting sla out for now need to uncomment once we are planning to implement this -->
					<!--<br>
					<div class="row ml-0" v-if="!showLoader">
					  <radio-button :options="radioOptions"
									:label="trans('enforce_sla')"
									name="Sla" :value="Sla"
									:onChange="onChange" classname="col-sm-6"
					  />
					</div>-->
				</div>
			</template>

      		<template #controls>

				<button v-if="!showLoader" type="submit" class="btn btn-primary pull-right" @click="popUpSubmit()" :disabled="submitFormInProgress" >

					<span><i class="fas fa-code-branch"></i></span>&nbsp;&nbsp;{{ trans('ticket-fork') }}
        		</button>
      		</template>
    	</Modal>
  	</div>
</template>

<script>

import { faveoFormCommons } from "../../../../../../../mixins/faveoFormCommons";
import FormWithCaptcha from "../../../../../../Common/NewForm/FormWithCaptcha.vue";
import RadioButton from "../../../../../../MiniComponent/FormField/RadioButton.vue";
import CustomLoader from "../../../../../../MiniComponent/Loader.vue";
import Loader from "../../../../../../Extra/Loader.vue";
import Modal from "../../../../../../Common/Modal.vue";
import Alert from "../../../../../../MiniComponent/Alert.vue";
import FormRenderer from "../../../../../../Common/NewForm/FormRenderer.vue";

export default {

  name: 'fork-ticket-modal',

  description: 'Fork Ticket modal Component',

  props: {
    showModal: { type: Boolean, default: false },
    onClose: { type: Function },
    ticketId: { type: [String, Number], default: '' },
    componentTitle: { type: String, default: '' },
    reloadDetails : { type : Function},
	  selectedFormData: { type: Object, default : ()=> {}}
  },

  data: () => {
    return {
      formUniqueKey: null,
      submitFormInProgress: false,
      scenario: 'fork',
      panel: 'agent',
	    category:'ticket',
      keepTicketStatusOpenAfterFork: 1,
      Parent: 1,
      //Sla: 1,
      radioOptions:[{name:'yes',value:1},{name:'no',value:0}]
    }
  },

  mixins: [faveoFormCommons],
	
	created() {
		
		window.emitter.on('updateTicketCategory', this.updateTicketCategory)
	},
	
  methods: {
	  
	  updateTicketCategory() {
		  
		  window.emitter.emit('storeCategoryId', this.selectedFormData.id)
	  },
    /**
     * it clicks the button, it clicks the button in FormWithCaptcha which in change triggers formSubmit.
     * Reason for this workaround is to hide the submit button coming from FormWithCaptcha without breaking
     * the functionality
     */
    popUpSubmit() {
      document.getElementById('fork-ticket-submit').click();
    },

    formSubmit(key, value) {
      this.$store.dispatch('setRecaptchaKey', value)
      this.onSubmit({'keep_status_of_parent_ticket_as_open_after_forking' : this.keepTicketStatusOpenAfterFork,'parent_ticket_thread_copy' : this.Parent/*,'enforce_sla' : this.Sla*/});
    },

    onChange(value,name){
      this[name] = value
    },

    afterSubmit (data) {
      window.emitter.emit('reset-captcha');
      setTimeout(() => {
        let id = data.data.data.id;
        this.$router.push('/thread/'+id);
        window.emitter.emit('refreshTableAndData', true);
        this.reloadDetails('fork');
        this.onClose();
      }, 1000);
    },
  },

  beforeDestroy() {
    this.$store.dispatch('unsetAlert');
  },

  components: {
    	FormWithCaptcha,
	  RadioButton,
	  CustomLoader,
	  Loader,
	  Alert,
	  FormRenderer,
	  Modal
  }
};
</script>

<style scoped>

#ticket_fork_body {
  max-height: 550px;
  overflow-y: auto;
  overflow-x: hidden;
}
</style>

<style>

#fork-ticket-submit{
  /*for hiding submit button of FormWithCaptcha component*/
  display: none;
}

.modal-mask { z-index: 9999 !important;}
</style>