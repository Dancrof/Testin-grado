<template>

	<transition name="page" mode="out-in">

		<div>

			<MetaComponent :dynamic_title="lang('submit_a_ticket-page-title')"
						   :dynamic_description="lang('submit_a_ticket-page-description')" :layout="layout" >

			</MetaComponent>

			<div class="row">

				<div id="content" class="site-content col-md-9">

					<article class="hentry">

						<div id="form-border">

							<section id="section-ticket" class="section">

								<h2 class="section-title h4 clearfix mb-3">

									<i class="line" :style="lineStyle"></i>{{lang('submit_a_ticket')}}
								</h2>

								<div class="row">

									<FaveoFormClientPanel :panel="panel" :category="category" :updateCount="updateTicketCount"
									  	:inputStyle="inputStyle" :layout="layout" :auth="auth"></FaveoFormClientPanel>
								</div>

							</section>
						</div>
					</article>
				</div>

				<div v-if="Array.isArray(auth.user_data)" id="sidebar" class="site-sidebar col-md-3">

					<div id="form-border" class="comment-respond form-border" style="background : #fff">

						<alert componentName="haveTicket"/>

						<section id="section-haveticket" class="section">

							<h2 class="section-title h4 clearfix">

								<i class="line" :style="lineStyle"></i>{{lang('have_a_ticket')}}
							</h2>

							<div v-if="loading" class="row">

								<loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
							</div>

							<div v-else class="row">

								<TextField :label="lang('ticket_number')" :value="ticket_number" type="text" name="ticket_number"
										   :onChange="onChange" classname="col-sm-12" :required="true" :inputStyle="inputStyle" id="have_ticket_number"></TextField>

								<TextField :label="lang('email_address')" :value="email_address" type="text" name="email_address"
										   :onChange="onChange" classname="col-sm-12" :required="true" :inputStyle="inputStyle" id="have_ticket_mail"></TextField>

								<div class="col-sm-12">

									<button :class="{left:lang_locale=='ar'}" @click="findTicket()" class="btn btn-custom"  id="have_ticket_action"
											:style="btnStyle" :disabled="isDisabled">

										<i class="fa fa-save">&nbsp;&nbsp;</i>{{lang('submit')}}
									</button>
								</div>
							</div>
						</section>
					</div>
				</div>

				<div v-if="!Array.isArray(auth.user_data)" id="sidebar" class="site-sidebar col-md-3">

					<div id="form-border" class="comment-respond form-border" style="background : #fff">

						<alert componentName="haveTicket"/>

						<section id="section-summary" class="section">

							<h2 class="section-title h4 clearfix">

								<i class="line" :style="lineStyle"></i>

								<dt class="text-truncate">{{lang('ticket_summary')}}</dt>
							</h2>

							<div v-if="loading" class="row">

								<loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="30"/>
							</div>

							<div v-else class="row">

								<ul class="nav nav-pills nav-stacked nav-categories ticket-count">

									<li class="d-flex justify-content-between align-items-center" v-for="(section,index) in ticketsCount">

										<a class="list-group-item list-group-item-action" href="javascript:;" @click="onClick(section)" :id="'ticket_list_'+index">

											<span class="badge rounded-pill float-end" :style="badgeStyle">{{section.ticket_count}}</span>
											{{section.name + ' tickets'}}
										</a>
									</li>
								</ul>
							</div>
						</section>
					</div>
				</div>
			</div>
		</div>
	</transition>
</template>

<script>

	import {errorHandler, successHandler} from '../../../../helpers/responseHandler'
	
	import { validateHaveTicketSettings } from "../../../../helpers/validator/haveTicketRules";
	
	import axios from 'axios';
	import {mapGetters} from 'vuex';
	import TextField from "../../../MiniComponent/FormField/TextField.vue";
	import FaveoFormClientPanel from "../../FaveoFormClientPanel.vue";
	import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
	import MetaComponent from "../MetaComponent.vue";

	export default {
		/**
		 * Props passed to the component:
		 * - layout: The layout object containing styling and configuration data. Default is an empty object.
		 * - auth: The authentication object containing user authentication data. Default is an empty object.
		 * - category: The category of the component. Required.
		 * - panel: The panel type of the component. Default is 'agent'.
		 */
		props : {
			layout : { type : Object, default : ()=>{}},
			auth : { type : Object, default : ()=>{}},
			category: {type: String, required: true},
			panel: {type: String, default: 'agent'},
		},
		/**
		 * Data properties for the component:
		 * - ticket_number: The ticket number. Default is an empty string.
		 * - email_address: The email address. Default is an empty string.
		 * - lang_locale: The language locale based on layout configuration.
		 * - isDisabled: Boolean flag indicating if the component is disabled. Default is false.
		 * - btnStyle: Style object for buttons, with border color and background color properties based on layout configuration.
		 * - lineStyle: Style object for lines, with border color property based on layout configuration.
		 * - badgeStyle: Style object for badges, with background color property based on layout configuration.
		 * - inputStyle: Style object for input fields, with border color property based on layout configuration.
		 * - loading: Boolean flag indicating if loading is in progress. Default is false.
		 * - ticketsCount: The count of tickets. Default is an empty string.
		 */
		data(){
			return {
				ticket_number : '',
				email_address : '',
				lang_locale :  this.layout.language,
				isDisabled : false,
				btnStyle : {
					borderColor : this.layout.portal.client_button_border_color,
					backgroundColor : this.layout.portal.client_button_color,
				},
				lineStyle: {
					borderColor : this.layout.portal.client_header_color,
				},
				badgeStyle: { backgroundColor : this.layout.portal.client_header_color },
				inputStyle : { borderColor : this.layout.portal.client_input_field_color},
				loading : false,
				ticketsCount : ''
			}
		},
		
		/**
		 * Lifecycle hook called before the component is mounted.
		 * Starts the progress bar.
		 * Checks if the user is allowed to create a ticket based on layout configuration and authentication data.
		 * If not allowed, redirects to the home page.
		 * Updates the ticket count.
		 */
		beforeMount(){
	
			this.$Progress.start();
	
			var create_ticket = parseInt(this.layout.allow_users_to_create_ticket.status);
	
			if(create_ticket !== 1 && Array.isArray(this.auth.user_data)){
	
				this.$router.push('/')
			}
	
			this.updateTicketCount();
		},
	
		computed: {
			...mapGetters(['showLoader'])
		},
	
		methods : {
			/**
			 * Updates the ticket count if the user is not authenticated.
			 * Calls the getTicketCount method to fetch the ticket count data.
			 */
			updateTicketCount() {
	
				if(!Array.isArray(this.auth.user_data)){
	
					this.loading = true;
	
					this.getTicketCount();
				}
			},
			/**
			 * Fetches the ticket count data from the server.
			 * Updates the loading status, ticket count, and progress bar accordingly.
			 */
			getTicketCount(){
	
				this.$Progress.start();
	
				axios.get('/api/client/ticket-filter').then(res=>{
	
					this.loading = false;
	
					this.ticketsCount = res.data.data.filters.data;
	
					this.$Progress.finish();
	
				}).catch(error=>{
	
					this.loading = false;
	
					this.$Progress.fail();
				})
			},
			/**
			 * Redirects the user to the 'MyTickets' page with the specified ticketTabData.
			 * @param {Object} section - The section object containing the ticket tab data.
			 */
			onClick(section){
	
				this.$router.push({name: 'MyTickets', params: {ticketTabData:section.id }});
			},
			/**
			 * Updates the value of the specified property.
			 * @param {*} value - The new value.
			 * @param {string} name - The name of the property to update.
			 */
			onChange(value,name){
	
				this[name] = value;
			},
			/**
			 * Validates the form data.
			 * Calls the validateHaveTicketSettings method and returns true if the form is valid, false otherwise.
			 * @returns {boolean} - True if the form is valid, false otherwise.
			 */
			isValid() {
	
				const { errors, isValid } = validateHaveTicketSettings(this.$data);
	
				if (!isValid) {
					return false;
				}
				return true;
			},
			/**
			 * Initiates the process of finding a ticket.
			 * If the form is valid, sends a request to the server to check the ticket.
			 * Updates the loading status, resets form fields, and handles success or error responses accordingly.
			 */
			findTicket(){
	
				if (this.isValid()) {
	
					this.$Progress.start();
	
					this.loading = true;
	
					const data = {};
	
					data['email_address'] = this.email_address;
	
					data['ticket_number'] = this.ticket_number;
	
					axios.post('/checkmyticket',data).then(res=>{
	
						this.loading = false;
	
						this.email_address = this.ticket_number = '';
	
						successHandler(res,'haveTicket');
	
						this.$Progress.finish();
					}).catch(error=>{
	
						this.loading = false;
	
						errorHandler(error,'haveTicket');
	
						this.$Progress.fail();
					});
				}
			},
		},
	
		components: {
			DynamicSelect,
			MetaComponent,
			TextField,
			FaveoFormClientPanel
		},
	};
</script>

<style scoped>

.border_2{
	border : 1px solid #e9ecef;
	margin-left: -4px;
	margin-bottom: 0px;
}

.mandatory{
	color : #dc3545 !important;
}

.box-container .box-header.with-border {
	padding-bottom: 0 !important;
	background-color: transparent !important;
	display: none;
}

.modal-content .box-container .box-header.with-border {
	padding-bottom: 0px !important;
	background-color: #eee !important;
	display: block !important;
	border-radius: 2px;
}

.modal-content .box-container .box-header.with-border h3 {
	font-size: 20px !important;
	font-family: inherit !important;
	padding: 13px !important;
}

.box-container {
	margin: 0 !important;
	border: 0 !important;
}
.modal-backdrop {
	display: none !important;
}
.has-success .form-control {
	border-color: #3c763d !important;
}
.modal-dialog{
	max-width: unset !important;
}
.modal-backdrop.show {
	opacity: 0 !important;
	z-index: unset !important;
}
.input-group {
	-ms-flex-wrap: nowrap !important;
	flex-wrap: nowrap !important;
}
.list-group-item {
	padding: 6px 7px !important;
}
.ticket-create{
	margin-top: -28px;
}

#form-border{
	background: transparent !important;
}
.input-group .form-control:first-child{

	border-top-right-radius: 4px !important;
	border-bottom-right-radius: 4px !important;
}
.form-dynamic-select .v-select .dropdown-toggle{

	border-radius: 4px !important;
	height: calc(1.5em + .75rem + 2px) !important;
}

.req-button[data-v-3adefd27] {
	background: #eee !important;
	border-radius: 4px !important;
	height: 38px !important;
}

button.close{
	margin: 6px !important
}
.form-control-feedback {
	position: absolute;
	top: 10px !important;
	right: 10px !important;
}
.ticket-count{
	padding:14px;
	padding-top: 0;
	padding-bottom: 0px;
}
#custom-form-submit-button {
	background-color: transparent !important;
}
#section-ticket,#section-summary,#section-haveticket{
	margin-bottom: 0px !important;
}
.lineOrg{
	margin: 15px!important;
}


</style>
