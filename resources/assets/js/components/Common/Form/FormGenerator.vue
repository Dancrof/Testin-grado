<template>

  	<div class="col-sm-12">

		<div id="faveo-form">

			<faveo-box :title="trans(mode)" cardBodyClass="p-2">

				<alert componentName="faveo-form"/>

        		<custom-loader v-if="showLoader || submitFormInProgress" :duration="4000"/>

				<template #headerMenu>

					<span v-if="showViewButton" class="pull-right">

						<router-link :to="'/' + viewId + '/' +  editId" class="btn btn-tool has-tooltip" v-tooltip="trans('view')">
							<span><i class="fas fa-eye"></i></span>
						</router-link>
					</span>
				</template>

				<DynamicSelect :label="trans('select_form')" :multiple="false" name="selectedForm"
				   classname="col-sm-4" :apiEndpoint="'/from/forms/'+category" :value="selectedForm"
				   :onChange="onChange" :clearable="false" :label-style="{ display : 'none' }">

				</DynamicSelect>
				{{fetchFormApi}}
        		<template v-if="formUniqueKey && formSelected">

          			<form-with-captcha :loading="!showLoader" btnClass='btn btn-primary pull-right' btnName="submit"
					   componentName="faveo-form"
					   btn_id="form-submit" :formSubmit="formSubmit" :page="page"
					   recaptchaContainerClass="col offset-md-2 col-md-10" :disableSubmit="submitFormInProgress">

            			<template #fields>

							<ValidationObserver ref="faveoFormObserver" v-slot="{ values, errors, validate }">

								<form-renderer
									:key="formUniqueKey"
									:fetchFormFieldApi="fetchFormApi"
									:formUniqueKey="formUniqueKey"
									:scenario="scenario || mode"
									:category="category"
									:panel="panel"
									:recur_mode="recur_mode"
									:template_mode="template_mode">
                				</form-renderer>
              				</ValidationObserver>
            			</template>
          			</form-with-captcha>
        		</template>
      		</faveo-box>
    	</div>
  	</div>
</template>

<script>

import FaveoBox from '../../../components/MiniComponent/FaveoBox.vue';
import {getIdFromUrl} from '../../../helpers/extraLogics';
import {getApiForFetchingFormFields, getFormUniqueKey} from '../../../helpers/formUtils';
import {faveoFormCommons} from '../../../mixins/faveoFormCommons';
import Alert from "../../MiniComponent/Alert.vue";
import Loader from "../../MiniComponent/Loader.vue";
import FormWithCaptcha from "./FormWithCaptcha.vue";
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
import {errorHandler} from "../../../helpers/responseHandler";

export default {

  	name: 'faveo-form',

	props: {

  		recur_mode : { type : String, default : '' },

  		template_mode : { type : String, default : '' },

		// category is for categorizing the FaveoForm; may be ticket, user, organization, etc
		category: {type: String, required: true},

		// One category may be present in differnet panels(admin/client/agent)
		panel: {type: String, default: 'agent'},

		// scenario will be the mode of the FaveoForm Category; may be create/edt/recur etc
		scenario: {type: String, default: ''},

		// if true one button with link("basePath() + '/' + category + '/' +  editId") will be shown on the card header
		showViewButton: {type: Boolean, default: false}
  	},

  	data() {

		return {
			fetchFormFieldApi: '',
			formUniqueKey: null,
			submitFormInProgress: false,
			editId: '',
			selectedForm: '',
			formSelected: false
		}
  	},

  	mixins: [faveoFormCommons],

	beforeMount() {

		this.getDefaultFormValue();

		this.fetchFormFieldApi = 'render/form';

		this.editId = getIdFromUrl(this.currentPath());

		if (this.mode === 'edit') {

			// In case of edit, get API Endpoint to fetch the form field on basis of category/scenario
			let key = this.scenario || this.category;
			this.fetchFormFieldApi = getApiForFetchingFormFields(key, this.editId);
		}
	},

  	computed: {

    	mode() {

			return this.currentPath().indexOf('edit') !== -1 ? 'edit' : 'create';
    	},

    	viewId() {

      		return this.category === 'organisation' ? 'organizations' : this.category;
    	},

    	page() {

      		if(this.scenario){

			  	return this.category + '_' + this.scenario + '_' + this.panel;
      		}

      		return this.category + '_' + this.mode + '_' + this.panel;
    	},

		fetchFormApi() {

			return this.fetchFormFieldApi;
		}
  	},

	methods: {

		onChange (value, name) {

			this[name] = value;

			this.formSelected = false;

			this.updateFetchApi();
	  	},

	  	getDefaultFormValue () {

		  	this.showLoader = true;

		  	axios.get('/from/forms/'+this.category).then(res=>{

			  	this.selectedForm = res.data.data.data[0];

			  	this.showLoader = false;

				  this.updateFetchApi()

		  	}).catch(err=>{

			  	this.showLoader = false;

			  	errorHandler(err,'faveo-form')
		  	})
	  	},

		updateFetchApi() {

			this.fetchFormFieldApi = '/render/form?id=' + this.selectedForm.id + '&mode=render'

			this.formSelected = true;
		},

    // After form submited to the server perform these operations
    afterSubmit(data) {

      if((this.scenario === 'recur' || this.scenario === 'template' )&& this.mode === "create"){
        // recur is present both in admin and in agent panel
        // the one contains "agent" in the url will be redirected to agent panel
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

       let id = data.data.data.id;

        if (this.mode === 'create') {
          const routeMap = {
            'user': '/user/',
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

    formSubmit(key, value) {

      this.$store.dispatch('setRecaptchaKey', value)

      this.onSubmit();
    }

  },

  components: {
    'faveo-box': FaveoBox,
    'alert': Alert,
    'loader': Loader,
    "form-with-captcha": FormWithCaptcha,
	  DynamicSelect
  },
}
</script>
