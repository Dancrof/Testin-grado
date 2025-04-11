<template>

	<transition name="page" mode="out-in">

		<div>

			<meta-component :dynamic_title="lang('submit_a_ticket-page-title')"
				:dynamic_description="lang('submit_a_ticket-page-description')" :layout="layout" >

			</meta-component>

			<div class="row">

				<div id="content" class="site-content col-md-9">
          <div v-if="showOrgSelection" class="card mb-3">
              <h2 class="section-title h4 clearfix mb-0 lineOrg">
                <i class="line" :style="lineStyle"></i>{{lang('select_organisation')}}
              </h2>
            <div class="card-body">
              <div class="row">
                <div class="col-md-12">
                  <dynamic-select
                      :label="lang('select_organisation')"
                      :multiple="false"
                      name="organization"
                      :prePopulate="true"
                      apiEndpoint="/api/dependency/organizations?having_form_categories=1"
                      :value="organization"
                      :inputStyle="inputStyle"
                      :onChange="onChange"
                  ></dynamic-select>
                </div>
              </div>
            </div>
          </div>


          <article class="hentry">

						<div v-if="selectedOrganization" id="form-border" class="comment-respond form-border" style="background : #fff">

		          <section id="section-ticket" class="section">

								<h2 class="section-title h4 clearfix mb-0">

									<i class="line" :style="lineStyle"></i>{{lang('submit_a_ticket')}}
								</h2>
                <div  class="row">

                </div>
								<div class="row mt-4">
									<faveo-form-client-panel panel="client" :category="category" :updateCount="updateTicketCount"
									                         :inputStyle="inputStyle" :layout="layout" :auth="auth"></faveo-form-client-panel>
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

								<text-field :label="lang('ticket_number')" :value="ticket_number" type="text" name="ticket_number"
									:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-12" :required="true" :inputStyle="inputStyle" id="have_ticket_number"></text-field>

								<text-field :label="lang('email_address')" :value="email_address" type="text" name="email_address"
									:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-12" :required="true" :inputStyle="inputStyle" id="have_ticket_mail"></text-field>

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

								<i class="line" :style="lineStyle"></i>{{lang('ticket_summary')}}
							</h2>

							<div v-if="loading" class="row">

								<loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="30"/>
							</div>

							<div v-else class="row">

								<ul class="nav nav-pills nav-stacked nav-categories ticket-count">

									<li class="d-flex justify-content-between align-items-center" v-for="(section,index) in ticketsCount">

										<a class="list-group-item list-group-item-action" href="javascript:;" @click="onClick(section)" :id="'ticket_list_'+index">

											<span class="badge rounded-pill float-end" :style="badgeStyle">{{section.ticket_count}}</span>
                      {{lang(section.name) + " " + lang('tickets')}}
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
  import {mapActions, mapGetters} from 'vuex';
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import FaveoFormClientPanel from "../../FaveoFormClientPanel.vue";
  import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},
		},

		data(){

			return {

        category : 'ticket',

        showOrgSelection : false,

				ticket_number : '',

				email_address : '',

				lang_locale :  this.layout.language,

				isDisabled : false,

				btnStyle : {

					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color,
				},

				lineStyle: {

					borderColor : this.layout.portal.client_header_color,
				},

				badgeStyle: { backgroundColor : this.layout.portal.client_header_color },

				inputStyle : { borderColor : this.layout.portal.client_input_field_color},

				loading : false,

				ticketsCount : '',

        organization : '',

        selectedOrganization: false,
			}
		},

		beforeMount(){

			this.$Progress.start();

			var create_ticket = parseInt(this.layout.allow_users_to_create_ticket.status);

			// if create_ticket is not allowed AND user is not logged in, should redirect to home page
			if(create_ticket != 1 && Array.isArray(this.auth.user_data)){
				this.$router.push('/')
			}

			this.updateTicketCount();
		},

		computed: { ...mapGetters(['showLoader']),
      ...mapActions(['updateCategory']), // Map the `updateCategory` action

    },

    mounted() {
      this.checkOrgSelection();
    },

    methods : {

      async checkOrgSelection() {
        try {
          const response = await axios.get('/before-ticket-creation/getActiveForm');
          const { shouldSelectOrganizationFirst, activeForm } = response.data.data;

          this.showOrgSelection = shouldSelectOrganizationFirst;
          this.selectedOrganization = !this.showOrgSelection;

          if (this.selectedOrganization) {
            this.category = activeForm.category;
          }
        } catch (error) {
          console.error('Error fetching active form data:', error);
        }
      },

      updateTicketCount() {

				if(!Array.isArray(this.auth.user_data)){

					this.loading = true;

					this.getTicketCount();
				}
			},

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

			onClick(section){

				this.$router.push({name: 'MyTickets', params: {ticketTabData:section.id }});
			},

			onChange(value,name){

        if(name === 'organization') {
          this.category = value.form_category;
          this.selectedOrganization = true;
          this.$store.dispatch('updateCategory', this.category);
        }

				this[name] = value;
			},

			isValid() {

				const { errors, isValid } = validateHaveTicketSettings(this.$data);

				if (!isValid) {
					return false;
				}
				return true;
			},

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

			"text-field": TextField,

			'faveo-form-client-panel': FaveoFormClientPanel
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
