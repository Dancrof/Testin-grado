<template>

	<div class="col-sm-12">

		<alert componentName="user-options"></alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{trans('contact_and_organization_settings')}}</h3>
			</div>

			<div class="card-body">

				<div class="row" v-if="!hasDataPopulated || loading">

					<reuse-loader :animation-duration="4000" :size="60"/>
				</div>

				<template v-if="hasDataPopulated">

					<div class="card card-light">

						<div class="card-header">

							<h3 class="card-title">{{trans('user-options')}}</h3>
						</div>

						<div class="card-body">

              <div class="alert alert-warning alert-dismissable show fade" role="alert" v-if="show_unauthenticated_tickets_message">
                {{trans('unauthenticated_tickets_message')}}
                <button type="button" @click="closeAlert" aria-hidden="true" :class="['btn-close mb-3', { 'float-end': appLanguage !== 'ar', 'float-start': appLanguage === 'ar' }]"></button>
              </div>

							<div class="row mb-3">

								<radio-button :options="radioOptions" :label="trans('allow_unverified_contacts_to_create_ticket')"
									name="allow_users_to_create_ticket"  :value="allow_users_to_create_ticket" :onChange="onChange"
									classname="form-group col-sm-6" :hint="trans('unauth_user_ticket_create_info')">

								</radio-button>

								<radio-button :options="radioOptions" :label="trans('contact_set_ticket_status')" name="user_set_ticket_status"
									:value="user_set_ticket_status" :onChange="onChange" classname="form-group col-sm-6"
									:hint="trans('user_set_ticket_status_info')">

								</radio-button>

							</div>


              <div class="row mb-3">

                <radio-button :options="radioOptions" :label="trans('contact_show_cc_ticket')" name="user_show_cc_ticket"
                              :value="user_show_cc_ticket" :onChange="onChange" classname="form-group col-sm-6"
                              :hint="trans('user_show_cc_ticket_info')">

                </radio-button>

                <radio-button :options="radioOptions" :label="trans('allow_contacts_registration')" name="user_registration"
                              :value="user_registration" :onChange="onChange" classname="form-group col-sm-6"
                              :hint="trans('allow_users_registration_info')">

                </radio-button>
              </div>

              <div class="row mb-3">

                <check-box :options="checkboxOptions" name="login_restrictions" :value="login_restrictions"
                           :label="trans('contact-account-activation-and-verifcation')" :onChange="onChange" classname="col-md-4 col-sm-6"
                           :hint="trans('contact-account-activation-and-verifcation_info')">

                </check-box>
              </div>
						</div>
					</div>

					<div class="card card-light">

						<div class="card-header">

							<h3 class="card-title">{{trans('organization-options')}}</h3>
						</div>

						<div class="card-body">

							<div class="row mb-3">

								<radio-button :options="radioOptions" :label="trans('allow_users_to_show_organization_tickets')"
									name="user_show_org_ticket" :value="user_show_org_ticket" :onChange="onChange" classname="form-group col-sm-6"
									:hint="trans('allow_users_to_show_organization_tickets_info')">

								</radio-button>

								<radio-button :options="radioOptions" :label="trans('allow_users_to_reply_organization_tickets')"
									name="user_reply_org_ticket" :value="user_reply_org_ticket" :onChange="onChange" classname="form-group col-sm-6"
									:hint="trans('allow_users_to_reply_organization_tickets_info')">

								</radio-button>
							</div>
						</div>
					</div>
				</template>
			</div>

			<div class="card-footer">

				<button class="btn btn-primary" @click="onSubmit()">

					<i class="fas fa-save"></i> {{trans('save')}}
				</button>
			</div>
		</div>

		<div class="row" v-if="pageLoad">

			<custom-loader :duration="4000"></custom-loader>
		</div>
	</div>
</template>

<script>

	import {errorHandler, successHandler} from "../../../../helpers/responseHandler";

    import axios from 'axios'
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import CheckBoxComponent from "../../../MiniComponent/FormField/CheckBoxComponent.vue";

	export default {

		name : 'close-ticket-workflow',

		data () {

			return {

				radioOptions:[{name:'yes',value:1},{name:'no',value:0}],

				user_set_ticket_status : '',

				user_registration : '',

				user_show_org_ticket : '',

				user_reply_org_ticket : '',

				allow_users_to_create_ticket : '',

				user_show_cc_ticket : '',

				login_restrictions : [],

				checkboxOptions : [],

				loading : true,

				hasDataPopulated : false,

				pageLoad : false,

        show_unauthenticated_tickets_message : false
			}
		},

		beforeMount(){

			this.getValues();
		},

		methods : {

			getValues(id){

				axios.get('/api/admin/get-user-options').then(res=>{

					this.loading = false;

					this.hasDataPopulated = true;

					let values = res.data.data;

					this.user_set_ticket_status = values.user_set_ticket_status;

					this.user_registration = values.user_registration;

					this.user_show_org_ticket = values.user_show_org_ticket;

					this.user_reply_org_ticket = values.user_reply_org_ticket;

					this.user_show_cc_ticket = values.user_show_cc_ticket;

					this.allow_users_to_create_ticket = values.allow_users_to_create_ticket;

					// this.login_restrictions = values.login_restrictions;

					this.checkboxOptions = values.login_restrictions;

					values.login_restrictions.forEach(item => {
						if(item.status) {
							this.login_restrictions.push(item.value);
						}
					});
				}).catch(error=>{

					this.loading = false;

					this.hasDataPopulated = true;
				});
			},


			onChange(value, name) {

				this[name] = value;

        if(name === 'allow_users_to_create_ticket') {
          value === 1 ? this.show_unauthenticated_tickets_message = true : this.closeAlert();
        }
			},

      closeAlert() {
        this.show_unauthenticated_tickets_message = false;
      },

			onSubmit() {

				this.pageLoad = true;

				const data = {};

				data['user_set_ticket_status'] = this.user_set_ticket_status;

				data['user_registration'] = this.user_registration;

				data['user_show_org_ticket'] = this.user_show_org_ticket;

				data['user_reply_org_ticket'] = this.user_reply_org_ticket;

				data['allow_users_to_create_ticket'] = this.allow_users_to_create_ticket;

				data['user_show_cc_ticket'] = this.user_show_cc_ticket;

				data['login_restrictions'] = this.login_restrictions;

				axios.post('/api/admin/user-options', data).then(res => {

					this.pageLoad = false;

					successHandler(res,'user-options');

          this.closeAlert()

					this.getValues()

				}).catch(err => {

					this.pageLoad = false;

					errorHandler(err,'user-options');
				});
			}
		},

		components : {

			'radio-button': RadioButton,

			'check-box': CheckBoxComponent
		}
	};
</script>
