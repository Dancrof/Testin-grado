<template>
	<div class="col-sm-12">
		<faveo-box :title="trans(title)">

			<alert componentName="faveo-automator" />

			<custom-loader v-if="showLoader || submitFormInProgress" :duration="4000" />

			<template v-if="!showLoader">

				<status-switch slot="headerMenu" class="pull-right" name="status" :title="status ? trans('active') : trans('inactive')" :value="status" :onChange="onChange" />

				<ValidationObserver ref="faveoAutomatorForm">

					<div v-focus-first-input>

						<text-field id="name" type="text" :label="trans('name')" name="name" classname="col-sm-6" :value="name" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true" rules="required" />
					</div>

					<action-performer v-if="category === 'listener'" :pageType="pageType" />

					<event-list v-if="category === 'listener'" :pageType="pageType" />

					<rule-list :categories="formCategories" :pageType="pageType"/>
<!--					<rule-list :formFields="formFields.rules" :categories="formCategories" :pageType="pageType"/>-->

<!--					<action-list :formFields="formFields.actions" />-->
					<action-list :actionEndpoint="actionEndpoint"/>

					<text-field :label="trans('internal_note')" type="textarea" name="internal_notes" :value="internal_notes" :onChange="onChange" :placehold="lang('enter_a_value')"
								:length="255" :show-word-limit="true" :rows="2" />

					<div class="form-group row" v-if="!showLoader">
						<div class="col-md-12">
							<button type="button" class="btn btn-primary" @click="onSubmit()" :disabled="submitFormInProgress">
								<span v-if="!editId"><i class="fas fa-save"></i></span>
								<span v-else><i class="fas fa-sync"></i></span>
								{{ editId ? trans('update') : trans('submit') }}
							</button>
						</div>
					</div>

				</ValidationObserver>

			</template>

		</faveo-box>

		<!-- confirmation pop-up -->
		<transition name="modal">
		<modal v-if="showDeleteModal" :showModal="true" :onClose="() => showDeleteModal = false" :containerStyle="{width:'400px'}">

			<template #title>

				<h4 class="modal-title">{{lang('delete')}}</h4>
			</template>

			<template #fields>

				<reuse-loader v-if="loading"></reuse-loader>

				<span v-if="!loading">{{lang('are_you_sure_you_want_to_delete')}}</span>
			</template>

			<template #controls>
				<button id="approval-action-confirm" type="button" @click = "doDelete()" class="btn btn-secondary">
					<i class="fas fa-trash-alt" aria-hidden="true"></i>&nbsp;{{lang('confirm')}}
				</button>
			</template>
		</modal>
		</transition>
	</div>
</template>

<script>
import { getIdFromUrl, boolean } from '../../../helpers/extraLogics';
import { validateFormData } from '../../../helpers/formUtils';
import { FaveoAutomator, getEnforcerInstanceList, getEvenInstancetList, getEnforcerDataByPropertyForSubmit, getEventDataForSubmit, isLocalElement } from '../../../helpers/AutomatorUtils';
import { errorHandler, successHandler } from "../../../helpers/responseHandler";
import {useStore} from "vuex";
import {computed} from "vue";
import RuleList from "./RuleList.vue";
import ActionList from "./ActionList.vue";
import EventList from "./EventList.vue";
import TextField from "../../MiniComponent/FormField/TextField.vue";
import Switch from "../../MiniComponent/FormField/Switch.vue";
import ActionPerformer from "./ActionPerformer.vue";

export default {

  name: 'faveo-automator',

    setup(){

      const store = useStore()

        return {
            showLoader : computed(()=>store.getters.showLoader)
        }
    },

  data: () => {
    return {
      title: '',
      name: '',
      status: true,
      internal_notes: '',
      editId: 0,
      formFields: {},
      submitEndpoint: '',
      rules: [],
      actions: [],
      events: [],
      formCategories:[],
      submitFormInProgress: false,
	    showDeleteModal :false,
	    deleteType : '',
	    deleteIndex : '',
	    deleteId : '',
	    loading : false,
	    pageType : ''
    }
  },

  props: {
    category: { type: String, required: true },
  },

  beforeMount () {

	  let paramsSearch = new URLSearchParams(window.location.search);
	  
	  this.pageType = paramsSearch.get("page_type") ? paramsSearch.get("page_type") : 'ticket';
	  
    this.getAutomatorData();

    this.editId = getIdFromUrl(this.currentPath());

    boolean(this.editId) ? this.handleEditCase() : this.handleCreateCase();

  },

  created () {
    window.emitter.on('deleteItem', this.deleteItem);
  },

  methods: {

    handleCreateCase () {
      this.title = 'create_' + this.category;
      this.$store.dispatch('createNewAutomatorInstance');
    },

    handleEditCase () {
      this.title = 'edit_' + this.category;
      this.getAutomatorEditData();
    },

    onChange (value, name) {
      this[name] = value
    },

    getAutomatorData () {
      this.$store.dispatch('startLoader', 'getAutomatorData');

      axios.get('api/form/automator', { params: { category: this.category, 'type' : this.pageType }})
      .then((response) => {
        // this.formFields = response.data.data.form_fields
        this.formCategories = response.data.data.form_categories
        this.submitEndpoint = response.data.data.submit_endpoint
        this.actionEndpoint = response.data.data.action_endpoint
      })
      .catch((error) => {
        errorHandler(error, 'faveo-automator')
      })
      .finally(() => {
        this.$store.dispatch('stopLoader', 'getAutomatorData');
      })
    },

    getAutomatorEditData () {
      this.$store.dispatch('startLoader', 'getAutomatorEditData');

      axios.get('api/get-enforcer/' + this.category + '/' + this.editId)
      .then((response) => {

        const DATA = response.data.data;

        this.name = DATA.name;
        this.status = DATA.status;
        this.internal_notes = DATA.internal_notes;

        const faveoAutomator = new FaveoAutomator(DATA.id, getEnforcerInstanceList(DATA.rules, 'rule'), getEnforcerInstanceList(DATA.actions, 'action'), getEvenInstancetList(DATA.events), DATA.matcher, DATA.triggered_by);

        this.$store.dispatch('createNewAutomatorInstance', faveoAutomator);
      })
      .catch((error) => {
        errorHandler(error, 'faveo-automator')
      })
      .finally(() => {
        this.$store.dispatch('stopLoader', 'getAutomatorEditData');
      })
    },

    async onSubmit () {

      const isValid = await validateFormData(this.$refs.faveoAutomatorForm);

      if (isValid) {

        this.submitFormInProgress = true;
  
        const automatorData = this.$store.getters.getAutomatorData;

        let params = {
          type: this.category,
          data: {
	          'category_type' : this.pageType,
            id: automatorData.id,
            matcher: automatorData.matcher,
            triggered_by: automatorData.actionsPerformer,
            name: this.name,
            status: this.status,
            internal_notes: this.internal_notes,
            rules: this.updatedRuleList(getEnforcerDataByPropertyForSubmit(automatorData.rules, 'rules')),
            actions: getEnforcerDataByPropertyForSubmit(automatorData.actions, 'actions'),
            events: getEventDataForSubmit(automatorData.events)
          }
        };

        axios.post(this.submitEndpoint, params )
          .then((response) => {
            successHandler(response, 'faveo-automator');

            if (!boolean(this.editId)) {
              setTimeout(() => {
                this.$router.push({ path : '/automator', query: { type : this.category }});
              }, 3000);
            } else {
              this.getAutomatorEditData();
            }
          })
          .catch((error) => {
			  
			  if(error?.response?.status === 412 && error?.response?.data?.message) {
				 
				  let formattedErr = {};

				  Object.keys(error.response.data.message).forEach(key => {

					  let splitKey = key.split('.');


					  let dynamicKey = params.data;

					  for (let i = 1; i < splitKey.length - 1; i++) {
						  dynamicKey = dynamicKey[splitKey[i]];
					  }

					  let newKey = dynamicKey.field + dynamicKey._id;

					  formattedErr[newKey] = error.response.data.message[key];
				  });
				  
				  error.response.data.message = formattedErr;
				  
				  errorHandler(error, 'faveo-automator');
				  
				  return
			  }
			  
            errorHandler(error, 'faveo-automator');
          })
          .finally(() => {
            this.submitFormInProgress = false;
          })
      }
    },

    updatedRuleList(value) {

      for( let i in value) {

        this.loopedVal(value[i].category,value[i]);
      }

      return value;
    },

    loopedVal(p_val,value) {

      for(let i in value.rules) {

        value.rules[i].category = p_val;

        if(value.rules[i].rules.length) {

          this.loopedVal(p_val,value.rules[i])
        }      
      }

      return value;
    },

    deleteItem ({type, index, id}) {

		this.showDeleteModal = true;

		this.deleteType = type;
		this.deleteIndex = index;
		this.deleteId = id;
    },

	  doDelete() {

		  if (isLocalElement(this.deleteId)) { this.deleteItemFromStore(this.deleteType, this.deleteIndex); return };

		  this.loading = true;
		  axios.delete(`api/delete-enforcer/${this.deleteType}/${this.deleteId}`)
			  .then((response) => {
				  this.deleteItemFromStore(this.deleteType, this.deleteIndex);
				  this.showDeleteModal = false;
				  this.loading = false;
				  successHandler(response, 'faveo-automator')
			  })
			  .catch((error) => {
				  this.showDeleteModal = false;
				  this.loading = false;
				  errorHandler(error, 'faveo-automator')
			  })
	  },

    deleteItemFromStore (type, index) {
		this.showDeleteModal = false;
	    this.loading = false;
      this.$store.dispatch('deleteElementFromAutomator', { key: type, index: index })
		window.emitter.emit('deletedItem');
    },

  },

  beforeDestroy() {
    this.$store.dispatch('forceStopLoader')
    this.$store.dispatch('destroyAutomatorInstance')
  },

  components: {
    'rule-list': RuleList,
    'action-list': ActionList,
    'event-list': EventList,
    'text-field': TextField,
    'status-switch': Switch,
    'action-performer': ActionPerformer
  }
}
</script>

<style>

</style>