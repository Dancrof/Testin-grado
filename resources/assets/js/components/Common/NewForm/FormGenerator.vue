<template>

	<div class="col-sm-12">

		<div id="faveo-form">

			<div class="card card-light">

				<div v-if="showViewButton" class="card-header">
					
					<h3 class="card-title">{{ trans('edit') }}</h3>
					
					<div class="card-tools">
						
						<router-link :to="'/' + viewId + '/' +  editId" id="form_view_btn" class="btn btn-tool text-dark" v-tooltip="trans('view')">
							
							<i class="fas fa-eye"></i>
						</router-link>
					</div>
				</div>
				
				<div class="card-body">

					<Alert componentName="faveo-form"/>

					<Loader v-if="showLoader || submitFormInProgress" :duration="4000"/>

					<div v-if="category === 'ticket' && formsLength > 1"  class="row">

						<DynamicSelect :label="trans('select_form')" :multiple="false" name="selectedForm"
						   classname="col-sm-12" :apiEndpoint="'/from/forms/'+category" :value="selectedForm"
						   :onChange="onChange" :clearable="false" :label-style="{ display : 'none' }">

						</DynamicSelect>
					</div>

					<template v-if="formUniqueKey && formSelected">

						<FormWithCaptcha :loading="!showLoader" btnClass='btn btn-primary pull-right' btnName="submit"
						 	componentName="faveo-form"
						 	btn_id="form-submit" :formSubmit="formSubmit" :page="page"
						 	recaptchaContainerClass="mt-2" :disableSubmit="submitFormInProgress">

							<template #fields>

								<ValidationObserver ref="faveoFormObserver" v-slot="{ values, errors, validate }">

									<FormRenderer
										:key="formUniqueKey"
										:fetchFormFieldApi="fetchFormApi"
										:formUniqueKey="formUniqueKey"
										:scenario="scenario || mode"
										:category="category"
										:panel="panel"
										:recur_mode="recur_mode"
										:template_mode="template_mode"
										:selectDependencyId="editId">
									</FormRenderer>
								</ValidationObserver>
							</template>
						</FormWithCaptcha>
					</template>
				</div>
			</div>
		</div>
	</div>
</template>

<script>

	import {getIdFromUrl} from "../../../helpers/extraLogics";
	import {getApiForFetchingFormFields, getFormUniqueKey} from "../../../helpers/formUtils";
	import {errorHandler} from "../../../helpers/responseHandler";
	import {faveoFormCommons} from "../../../mixins/faveoFormCommons";
	import FaveoBox from "../../MiniComponent/FaveoBox.vue";
	import Alert from "../../MiniComponent/Alert.vue";
	import Loader from "../../MiniComponent/Loader.vue";
	import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
	import FormRenderer from "./FormRenderer.vue";
	import FormWithCaptcha from "./FormWithCaptcha.vue";

	export default {

		name: 'faveo-form',

		/**
		 * Props passed to the component:
		 * - recur_mode: Specifies the mode for recurring events. Default is an empty string.
		 * - template_mode: Specifies the mode for templates. Default is an empty string.
		 * - category: The category of the component. Required.
		 * - panel: The panel type of the component. Default is 'agent'.
		 * - scenario: The scenario of the component. Default is an empty string.
		 * - showViewButton: Boolean flag to determine whether to show the view button. Default is false.
		 */
		props: {

			recur_mode : { type : String, default : '' },

			template_mode : { type : String, default : '' },

			category: {type: String, required: true},

			panel: {type: String, default: 'agent'},

			scenario: {type: String, default: ''},

			showViewButton: {type: Boolean, default: false}
		},

		/**
		 * Data properties of the component:
		 * - fetchFormFieldApi: API endpoint for fetching form field data.
		 * - formUniqueKey: Unique key for the form.
		 * - submitFormInProgress: Boolean flag indicating whether form submission is in progress.
		 * - editId: ID of the form being edited.
		 * - selectedForm: Name or ID of the selected form.
		 * - formSelected: Boolean flag indicating whether a form is selected.
		 */
		data() {

			return {

				baseEndpoint: 'render/form',
				
				fetchFormFieldApi: '',

				formUniqueKey: null,

				submitFormInProgress: false,

				editId: '',

				selectedForm: '',

				formSelected: false,

				formsLength: 0
			}
		},

		mixins: [faveoFormCommons],

		/**
		 * Executes before the component is mounted:
		 * - Sets the fetchFormFieldApi to 'render/form'.
		 * - Sets the editId by extracting it from the current URL path.
		 * - If the mode is 'edit', updates the fetchFormFieldApi based on the scenario or category and editId.
		 * - If not in edit mode, invokes getDefaultFormValue().
		 */
		beforeMount() {

			this.fetchFormFieldApi = this.baseEndpoint;

			this.editId = getIdFromUrl(this.currentPath());

			if (this.mode === 'edit') {

				let key = this.scenario || this.category;

				this.fetchFormFieldApi = getApiForFetchingFormFields(key, this.editId);
				
				this.baseEndpoint = getApiForFetchingFormFields(key, this.editId);

				this.formSelected = true;

			} else {

				this.getDefaultFormValue();
			}
		},
		
		created() {
			
			window.emitter.on('updateTicketCategory', this.updateTicketCategory);
			
			window.emitter.on('updateSelectedForm', (value) => {
				
				this.selectedForm = value
			})
		},
		
		computed: {

			/**
			 * Computes the mode based on the current URL path:
			 * - Returns 'edit' if the current path contains 'edit', otherwise returns 'create'.
			 */
			mode() {

				return this.currentPath().indexOf('edit') !== -1 ? 'edit' : 'create';
			},

			/**
			 * Computes the view ID based on the category:
			 * - If the category is 'organisation', returns 'organizations', otherwise returns the category itself.
			 */
			viewId() {
				const categoryMap = {
					'organisation': 'organizations',
					'requester': 'user'
				};
				
				return categoryMap[this.category] || this.category;
			},
			
			/**
			 * Computes the page identifier based on the scenario, category, and panel:
			 * - If a scenario is present, returns the concatenation of category, scenario, and panel.
			 * - If no scenario is present, returns the concatenation of category, mode, and panel.
			 */
			page() {

				if(this.scenario){

					return this.category + '_' + this.scenario + '_' + this.panel;
				}

				return this.category + '_' + this.mode + '_' + this.panel;
			},

			/**
			 * Computes the fetchFormApi value.
			 */
			fetchFormApi() {

				return this.fetchFormFieldApi;
			}
		},

		methods: {
			
			updateTicketCategory() {
				
				window.emitter.emit('storeCategoryId', this.selectedForm.id)
			},
			/**
			 * Handles the change event for form fields.
			 * Updates the value of the field, sets formSelected to false, and updates the fetch API.
			 * @param {any} value - The new value of the form field.
			 * @param {string} name - The name of the form field.
			 */
			onChange (value, name) {

				this[name] = value;

				this.formSelected = false;

				this.updateFetchApi();
			},

			/**
			 * Retrieves the default form value for the category.
			 * Fetches the first form data for the category from the server and updates the fetch API.
			 */
			getDefaultFormValue () {

				this.showLoader = true;

				axios.get('/from/forms/'+this.category).then(res=>{

					this.selectedForm = res.data.data.data[0];

					this.formsLength = res.data.data.data.length;

					this.showLoader = false;

					this.updateFetchApi()

				}).catch(err=>{

					this.showLoader = false;

					errorHandler(err,'faveo-form')
				})
			},

			/**
			 * Updates the fetch API after selecting a form or changing form data.
			 * Destroys the existing form instance in the store, unsets validation errors, and sets the new fetch API.
			 */
			updateFetchApi() {

				this.$store.dispatch('destroyFormInsatnce', this.formUniqueKey);

				this.$store.dispatch('unsetValidationError');

				let formKey = this.baseEndpoint.includes('render/form') ? 'id' : 'form_category_id';
				
				this.fetchFormFieldApi = this.baseEndpoint + '?' + formKey + '=' + this.selectedForm.id + '&mode=render'

				setTimeout(()=>{

					this.$store.dispatch('createNewFormInstance', { formUniqueKey: this.formUniqueKey, scenario: this.scenario || this.mode });

					this.formSelected = true;
				},1)
			},

			/**
			 * Handles actions after submitting the form.
			 * Redirects to the 'Recurring Tickets' page if in 'recur' scenario and 'create' mode.
			 * Updates the agent sidebar, destroys the existing form instance, creates a new form instance,
			 * resets the form unique key, and resets the CAPTCHA.
			 * @param {any} data - The data returned after form submission.
			 */
			afterSubmit(data) {

				if((this.scenario === 'recur' || this.scenario === 'template') && this.mode === "create"){

					setTimeout(()=>{
						
						return this.scenario === 'recur' ? this.$router.push({name:'Recurring Tickets'}) : this.$router.push({name:'Ticket Templates Index'})
					},3000)

				} else {

					window.emitter.emit('updateAgentSidebar');

					this.$store.dispatch('destroyFormInsatnce', this.formUniqueKey);

					let formUniqueKey = getFormUniqueKey(this.category);

					this.$store.dispatch('createNewFormInstance', {formUniqueKey, scenario: this.scenario || this.mode});

					this.formUniqueKey = formUniqueKey;

					window.emitter.emit('reset-captcha');

					if (this.mode === 'create') {

            let id = data.data.data.id;

						const routeMap = {
							'requester': '/user/',
							'organisation': '/organizations/',
							'ticket': '/thread/'
						};
						
						setTimeout(() => {
							const route = routeMap[this.category];
							if (route) {
								this.$router.push(route + id);
							}
						}, 3000);
					}
				}
			},

			/**
			 * Submits the form after setting the reCAPTCHA key.
			 */
			formSubmit(key, value) {

				this.$store.dispatch('setRecaptchaKey', value)

				this.onSubmit();
			}
		},

		components: {
			FaveoBox,
			Alert,
			Loader,
			FormWithCaptcha,
			DynamicSelect,
			FormRenderer
		}
	}
</script>

<style>

	#form_view_btn { margin-right: 0px !important; }
</style>
