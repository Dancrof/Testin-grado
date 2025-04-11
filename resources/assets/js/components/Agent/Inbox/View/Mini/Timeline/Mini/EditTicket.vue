<template>

	<div>

		<CustomLoader v-if="submitFormInProgress"/>

		<Modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

			<template #title>

				<h4 class="modal-title">{{ lang(title) }}</h4>
			</template>

			<template #fields>

				<CustomLoader v-if="showLoader"/>

				<div id="ticket_modal_body">

					<!-- Alert component for displaying messages -->
					<Alert componentName="faveo-form"/>

					<!-- Conditional alert for status-related messages -->
					<div v-if="from === 'status' || from === 'inboxReply'" class="alert alert-warning">
						<!-- Display message if there are multiple closure tickets -->
						<span v-if="closureTickets.length > 1">
              {{ (unResolvedTickets !== 0 ? unResolvedTickets : totalTickets)  + trans('of')+ totalTickets + ' ' +trans('ticket_could_not_be_closed') +' '+ trans('please_fill_required_fields_try_again')}}
            </span>

						<!-- Display message if there is only one closure ticket -->
						<span v-else>{{trans("please_fill_required_fields_try_again")}}</span>
					</div>

					<div class="row">

						<!-- Column for closure tickets list -->
						<div v-if="(from === 'status' || from === 'inboxReply') && closureFormLoaded" class="col-sm-3 pe-0">
							<div class="card ms-2">
								<div class="closure-list">
									<div class="card-body">
										<!-- Loop through closure tickets and display each ticket -->
										<div v-for="item in closureTickets"
										     @click="handleClosureTicketClick(item)"
										     :key="item.ticket_number"
										     :class="{'active-ticket': activeTicket && activeTicket.ticket_number === item.ticket_number}"
										     class="card p-3 mb-2 cursor-pointer">
											<!-- Display ticket number -->
											{{'#'+item.ticket_number}}
										</div>
									</div>

									<!-- Infinite loading for fetching more closure tickets -->
									<infinite-loading v-if="next_page" @infinite="getClosureTicketList">
										<template #spinner><span></span></template>
										<template #complete><span></span></template>
									</infinite-loading>

									<!-- Loader for closure tickets -->
									<div v-if="loader" class="mb-3">
										<reuse-loader  :animation-duration="4000" :size="20"/>
									</div>
								</div>
							</div>
						</div>

						<!-- Column for form or content based on status -->
						<div v-if="(from === 'status' && closureFormLoaded) || from !== 'status'" :class="(from === 'status' || from === 'inboxReply') ? 'col-sm-9 px-0 status-from-list' : 'col-sm-12' " >

							<template v-if="formUniqueKey && formSelected">
								<FormWithCaptcha :loading="!showLoader" btnClass='btn btn-primary pull-right' btnName="submit"
								                 componentName="faveo-form"
								                 btn_id="edit-ticket-submit" :formSubmit="formSubmit" page="ticket_edit_agent"
								                 recaptchaContainerClass="mt-2" :disableSubmit="submitFormInProgress">

									<template #fields>

										<ValidationObserver ref="faveoFormObserver" v-slot="{ values, errors, validate }">

											<FormRenderer
                          v-if="fetchFormFieldApi"
                          category="ticket"
												:fetchFormFieldApi="fetchFormFieldApi"
												:scenario="scenario"
												:panel="panel"
												:isInlineForm="false"
												:formUniqueKey="formUniqueKey"
												:selectDependencyId="ticket_id"
												selectDependencyKey="id"
												:callingFrom="(from === 'status' || from === 'inboxReply') ? 'changeTicketStatus':'editTicket'"
											>
												<template v-slot:ticketedit>

													<!-- Button to toggle the dropdown menu for form categories -->
													<button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="true"
													        id="dropdown-menu-columns" @click="getInitialFormCategory" v-tooltip="trans('selected_form')" :disabled="(from === 'status' || from === 'inboxReply') ? true : false">
														<!-- Display the selected form name, truncated to 15 characters -->
														<i class="fas fa-file-alt">&nbsp;</i>{{subString(selectedForm.name, 15)}}
													</button>

													<!-- Dropdown menu for selecting form categories -->
													<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right pb-2"
													     aria-labelledby="dropdown-menu-columns" id="form-list-scrollable-ul">

														<!-- Loop through the form categories and display each as a dropdown item -->
														<template v-for="item in formCategoryList">

															<!-- Display the form category name, truncated to 30 characters, with a tooltip if the name is longer than 30 characters -->
															<a class="dropdown-item ticket-category"  @click="onChange(item, 'selectedForm')">
																<i v-if="this.selectedForm.id === item.id" class="fas fa-check"></i>&nbsp;
																<span class="search-text" v-tooltip="item.name.length > 30 ? item.name : ''" :class="this.selectedForm.id !== item.id ? 'ms-3' : ''">{{subString(item.name, 30)}}</span>
															</a>
														</template>

														<!-- Infinite loading component for fetching more form categories -->
														<infinite-loading v-if="form_next_page" @infinite="getFormCategoryList">
															<template #spinner><span></span></template>
															<template #complete><span></span></template>
														</infinite-loading>

														<!-- Loader for form categories -->
														<div v-if="showFormLoader" class="mb-3">
															<reuse-loader  :animation-duration="4000" :size="20"/>
														</div>
													</div>
												</template>
											</FormRenderer>
										</ValidationObserver>
									</template>
								</FormWithCaptcha>
							</template>
						</div>
					</div>
				</div>
			</template>

			<template #controls>

				<div class="pull-right">

					<button v-if="!showLoader" type="button" class="btn btn-primary" :disabled="submitFormInProgress"
					        @click="popUpSubmit()">

						<i class="fas fa-sync"></i> {{ trans('update') }}
					</button>

				</div>
			</template>
		</Modal>
	</div>
</template>

<script>

import {faveoFormCommons} from "../../../../../../../mixins/faveoFormCommons";
import FormWithCaptcha from "../../../../../../Common/NewForm/FormWithCaptcha.vue";
import Modal from "../../../../../../Common/Modal.vue";
import CustomLoader from "../../../../../../MiniComponent/Loader.vue";
import Loader from "../../../../../../Extra/Loader.vue";
import Alert from "../../../../../../MiniComponent/Alert.vue";
import FormRenderer from "../../../../../../Common/NewForm/FormRenderer.vue";
import DynamicSelect from "../../../../../../MiniComponent/FormField/DynamicSelect.vue";
import axios from "axios";
import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";
import StaticSelect from "../../../../../../MiniComponent/FormField/StaticSelect.vue";
import { getSubStringValue } from "../../../../../../../helpers/extraLogics";

export default {
	name: 'edit-ticket-modal',
	description: 'Edit Ticket modal Component',

	props: {
		showModal: {type: Boolean, default: false},
		onClose: {type: Function},
		ticketId: {type: [String, Number, Array], default: ''}, // Prop for ticket ID, can be a string, number, or array
		reloadTickets : { type : Function, default: () => {} }, // Prop for function to reload tickets
		selectedFormData: { type: Object, default : ()=> {}}, // Prop for selected form data, default is an empty object
		from: {type: String, default: ''},  // Prop for the source of the component, default is an empty string
		componentTitle : { type : String, default :'inbox'},  // Prop for the title of the component, default is 'inbox'
		reloadDetails : { type : Function,  default: () => {}}, // Prop for function to reload details
	},

	data() {
		return {
			formUniqueKey: '',
			submitFormInProgress: false,
			scenario: 'edit',
			panel: 'agent',
			category:'ticket',
			selectedForm: {},
			formSelected: true,
			ticket_id: '',
			fetchFormFieldApi : '',
			checkValidation : false,
			closureTickets: [],
			changeTicketDetails: {},
			title: '',
			activeTicket: null,
			closureFormLoaded: false,
			ticketList: [],
			page: 1,
			next_page: false,
			loader: false,
			totalTickets: 0,
			unResolvedTickets: 0,
			initialLoad: false,
			form_page: 1,
			formCategoryList: [],
			form_next_page: false,
			showFormLoader: false,
			formRefreshed: false
		}
	},

	mixins: [faveoFormCommons],

	created() {
		window.emitter.on('updateTicketCategory', this.updateTicketCategory);

		// Listen for the 'validateEditForm' event and set formRefreshed to true
		window.emitter.on('validateEditForm',() => this.formRefreshed = true);
	},

	beforeMount() {
		// Check if the component is loaded from 'status' or 'inboxReply' (for send and change status)
		if (this.from === 'status' || this.from === 'inboxReply') {
			this.title = 'close_ticket'; // Set title for closing ticket
			this.getInitialTicketList(); // Fetch initial list of tickets
			this.initialLoad = true; // Mark initial load as true
		} else {
			this.title = 'edit_ticket'; // Set title for editing ticket
			this.ticket_id = this.ticketId; // Assign ticket ID
			this.fetchFormFieldApi = `api/agent/edit-mode-ticket-details/${this.ticket_id}`; // Set API endpoint for fetching ticket details
			this.selectedForm = this.selectedFormData; // Assign selected form data
		}
	},

	methods: {

		updateTicketCategory() {

			window.emitter.emit('storeCategoryId', this.selectedForm.id);
		},

		onChange(value, name) {

			this[name] = value;

			this.formSelected = false;

			this.updateFetchApi();
		},

		updateFetchApi() {

			this.$store.dispatch('destroyFormInsatnce', this.formUniqueKey);

			this.$store.dispatch('unsetValidationError');

			this.fetchFormFieldApi = '/api/agent/edit-mode-ticket-details/' + this.ticket_id + '?form_category_id=' + this.selectedForm.id;

			setTimeout(() => {

				this.$store.dispatch('createNewFormInstance', {formUniqueKey: this.formUniqueKey, scenario: this.scenario});

				this.formSelected = true;
			}, 1)
		},
		/**
		 * it clicks the button, it clicks the button in FormWithCaptcha which in change triggers formSubmit.
		 * Reason for this workaround is to hide the submit button coming from FormWithCaptcha without breaking
		 * the functionality
		 */
		popUpSubmit() {
			document.getElementById('edit-ticket-submit').click();
		},

		formSubmit(key, value) {
			this.$store.dispatch('setRecaptchaKey', value)
			this.onSubmit();
		},

		afterSubmit(data) {

			if (this.from === 'status' || this.from === 'inboxReply') {
				// If the source is 'status', change the ticket status after a delay of 1 second
				setTimeout(() => {
					this.changeTicketStatus()
				}, 1000);
			}else {
				window.emitter.emit('reset-captcha');
				setTimeout(() => {
					window.emitter.emit('refreshTableAndData', true);
					this.reloadDetails('edit');
					this.onClose();
				}, 1000);
			}
		},

		triggerValidation() {
			// Delay the validation trigger to ensure the form observer is ready
			setTimeout(() => {
				// If the form observer exists, trigger validation
				this.$refs.faveoFormObserver ? this.$refs.faveoFormObserver.validate() : '';
			}, 100);
		},

		getInitialTicketList() {

			// Initialize the ticket list for closure
			this.closureTickets = [];

			this.page = 1;

			// Fetch the initial list of closure tickets
			this.getClosureTicketList(null, true);
		},

		// Fetch the list of closure tickets
		async getClosureTicketList($state, isRefresh = false) {

			if (this.loader) return;
			this.loader = true;

			let params = { page: this.page }

			try {
				const res = await axios.get('api/agent/ticket-closure/', { params: params });

				if (isRefresh) {
					// Refresh the closure tickets list
					this.closureTickets = res.data.data;
					this.totalTickets = res.data.total;
				} else {
					// Append new tickets to the existing list
					this.closureTickets.push(...res.data.data);
					this.unResolvedTickets = res.data.total;
				}

				if (this.closureTickets.length > 0) {
					// Load the form for the first ticket and set it as active
					await this.loadClosureForm(this.closureTickets[0]); // Set the first ticket as active
				}else{
					// Close the modal if no tickets are available
					this.onClose();
				}

				// Update pagination and state
				this.next_page = res.data.next_page_url !== null;
				if (this.next_page) {
					this.page++;
				}
				$state && $state.loaded();
				if (!this.next_page) {
					$state && $state.complete();
				}

				// Update the ticket list
				this.ticketList = this.closureTickets.map(ticket => ticket.ticket_id);
			} catch (err) {
				errorHandler(err, 'faveo-form');
			} finally {
				this.loader = false;
			}
		},

		getInitialFormCategory(){
			// Initialize the form category list
			this.formCategoryList = [];
			// Set the initial page number for form categories
			this.form_page = 1;

			this.getFormCategoryList(null, true);
		},

		// Fetch the list of form categories
		async getFormCategoryList($state, isRefresh = false) {
			// Prevent multiple requests if a loader is already active
			if (this.showFormLoader) return;
			this.showFormLoader = true;

			const params = { page: this.form_page };

			try {
				// Make an API call to fetch form categories
				const res = await axios.get('/api/ticket/forms', { params });

				if (isRefresh) {
					// Refresh the form category list
					this.formCategoryList = res.data.data.data;
				} else {
					// Append new categories to the existing list
					this.formCategoryList.push(...res.data.data.data);
				}

				// Update pagination and state
				this.form_next_page = res.data.data.next_page_url !== null;
				if (this.form_next_page) {
					this.form_page++;
				}
				$state && $state.loaded();
				if (!this.form_next_page) {
					$state && $state.complete();
				}
			} catch (err) {
				// Handle errors
				errorHandler(err, 'faveo-form');
			} finally {
				// Update the loader status
				this.showFormLoader = false;
			}
		},

		handleClosureTicketClick(item) {
			// Check if the clicked ticket is already active
			if (this.activeTicket?.ticket_number === item.ticket_number) {
				return;
			}

			// Load the closure form for the selected ticket
			this.loadClosureForm(item);
		},

		loadClosureForm(data) {

			this.$refs.faveoFormObserver ? this.$refs.faveoFormObserver.resetForm() : '';

			// Unset any existing validation errors
			this.$store.dispatch('unsetValidationError');

			// Update ticket details and selected form information
			this.changeTicketDetails = data;
			this.ticket_id = data.ticket_id;
			this.selectedForm = {
				id: data.form_category.id,
				name: data.form_category.name,
			};

			// Set the active ticket and fetch the form fields
			this.activeTicket = data;

			// Set the API endpoint for fetching form fields
			this.fetchFormFieldApi = '/api/agent/edit-mode-ticket-details/' + this.ticket_id + '?form_category_id=' + this.selectedForm.id + '&checkTicketStatus=' + true;

			// Emit event to change ticket status if not the initial load
			if (!this.initialLoad) {
				setTimeout(() => {
					window.emitter.emit('editTicketChangeStatus');
				}, 1);
			} else {
				this.initialLoad = false;
			}

			// Mark the closure form as loaded
			this.closureFormLoaded = true;
		},

		changeTicketStatus() {
			// Extract ticket details from changeTicketDetails
			const { ticket_id, status_id, comment, 'as-reply': as_reply } = this.changeTicketDetails;

			// Filter out the current ticket from the ticket list
			const ticketList = this.ticketList.filter(id => id !== ticket_id);

			// Prepare the payload for the API request
			const payload = {
				'comment': comment,
				'as-reply': as_reply,
				'status_changed': true,
				'unprocessed_tickets': ticketList
			};

			// Make an API call to change the ticket status
			axios.post(`/ticket/change-status/${ticket_id}/${status_id}`, payload)
				.then(res => {
					if (this.closureTickets.length === 1) {
						// Close the modal if there is only one closure ticket
						this.triggerRefreshEvent();
						successHandler(res, this.componentTitle);
            if(this.from === 'inboxReply') {
              window.emitter.emit('changeStatusAndReply');
            }
					} else {
						// Refresh the closure tickets list
						this.closureTickets = [];
						this.page = 1;
						this.getClosureTicketList();
						successHandler(res, 'faveo-form');
					}
				})
				.catch(err => {
					// Handle errors and close the modal
					this.onClose();
				});
		},

		onClose() {

			// Check if the source is 'status' and there are closure tickets
			if (this.from === 'status' && this.closureTickets.length) {
				this.triggerRefreshEvent();
			} else {
				// Close the modal
				this.onClose();
			}
		},

		triggerRefreshEvent(){

			this.onClose();
			// Emit events to refresh various components and data after the modal is closed
			this.$nextTick(() => {
				// Emit events to refresh various components and data
				window.emitter.emit(this.componentTitle + 'refreshData');
				window.emitter.emit(this.componentTitle + 'uncheckCheckbox');
				window.emitter.emit('refreshUserReport');
				window.emitter.emit('refreshOrgReport');
				window.emitter.emit('closeTimelineActions');
				window.emitter.emit('updateAgentSidebar');
				// Reload details or tickets based on the component title
				this.componentTitle === 'index' ? this.reloadDetails('edit') : this.reloadTickets('status');
			});
		},

		subString(value, length = 15) {
			// Return a substring of the given value up to the specified length
			return getSubStringValue(value, length)
		}
	},

	watch:{

		// Watcher for formRefreshed to trigger validation when it changes to true
		formRefreshed(newValue, oldValue){
			if(newValue === true){
				this.triggerValidation()
				this.formRefreshed = false;
			}
		}
	},

	computed: {
		// Computed property to determine the container style based on the source
    containerStyle() {
      return this.from === 'status'
          ? { width: 'calc(85vw - 5rem) !important', maxWidth: 'calc(90vw - 5rem) !important', height: 'calc(90vh - 3rem) !important', maxHeight: 'calc(95vh - 3rem) !important' }
          : { width: 'calc(80vw - 3rem) !important', maxWidth: 'calc(85vw - 3rem) !important', height: 'calc(90vh - 3rem) !important', maxHeight: 'calc(95vh - 3rem) !important' };
    },
	},

	beforeDestroy() {
		this.$store.dispatch('unsetAlert');
	},

	components: {
		StaticSelect,
		DynamicSelect,
		Alert,
		Modal,
		CustomLoader,
		Loader,
		FormWithCaptcha,
		FormRenderer
	}
}
</script>

<style scoped>
#ticket_modal_body {
	max-width: calc(85vw - 3rem) !important;
	max-height: calc(88vh - 12rem) !important;
	overflow-y: auto;
	overflow-x: hidden;
  padding-bottom: 5px;
}

.closure-list{
	max-height: calc(85vh - 12rem) !important;
	overflow-y: auto;
	overflow-x: hidden;
}

.status-from-list{
	max-height: calc(85vh - 12rem) !important;
	max-width: calc(80vw - 3rem) !important;;
	overflow-y: auto;
	overflow-x: hidden;
}

.status-from-list::-webkit-scrollbar-track,
.closure-list::-webkit-scrollbar-track,
#form-list-scrollable-ul::-webkit-scrollbar-track {
	background-color: #f1f1f1;
	border-radius: 10px;
}

.status-from-list::-webkit-scrollbar,
.closure-list::-webkit-scrollbar,
#form-list-scrollable-ul::-webkit-scrollbar {
	width: 6px;
	background-color: #f1f1f1;
}

.status-from-list::-webkit-scrollbar-thumb,
.closure-list::-webkit-scrollbar-thumb,
#form-list-scrollable-ul::-webkit-scrollbar-thumb {
	background-color: #c1c1c1;
	border-radius: 10px;
}

.form_select {
	margin-left: 1em;
	margin-right: 1em;
}

.form-list{
	max-height: 500px !important;
	overflow-y: auto;
	overflow-x: hidden;
}

.cursor-pointer{
	cursor: pointer;
}

.active-ticket{
	background-color: #f3f3f3;
}

#form-list-scrollable-ul{
	max-height: 250px;
	overflow-y: auto;
	overflow-x: hidden;
	border: 1px solid gainsboro;
	padding: 10px 10px 0 10px;
}

.active-selected-from{
	background-color: #3c8dbc !important;
	color: #fff !important;
}

.ticket-category{

	cursor: pointer;
	padding-left: 10px !important;
	max-width: 450px !important;
	width: 300px !important;
}
</style>

<style>

#edit-ticket-submit{
	/*for hiding submit button of FormWithCaptcha component*/
	display: none;
}

/*.modal-mask { z-index: 9999 !important;}*/
</style>