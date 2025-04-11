<template>

  	<div class="col-sm-12">

		<div v-if="loading" class="row">

			<custom-loader :duration="4000" />
    	</div>

		<alert componentName="createUpdateAgent" />

    	<faveo-box :title="lang(title)" v-if="hasDataPopulated" id="form-main-box" boxClass="card-light">

      		<faveo-box :title="lang('agent_info')" boxClass="card-light">

				<div class="row" v-focus-first-input>

					<text-field id="email" :label="lang('email')" type="text" name="email" classname="col-sm-6" :value="email"
            			:onChange="onChange" :placehold="lang('enter_a_value')" :required="true" defaultKey="email">
          			</text-field>

					<text-field id="user_name" :label="lang('user_name')" type="text" name="user_name"
						classname="col-sm-6" :value="user_name" :onChange="onChange" :placehold="lang('enter_a_value')" defaultKey="user_name" :required="true">
					</text-field>
				</div>

        		<div class="row">

          			<text-field id="first_name" :label="lang('firstname')" type="text" name="first_name" classname="col-sm-4"
            			:value="first_name" :onChange="onChange" :placehold="lang('enter_a_value')" :required="true">
          			</text-field>

          			<text-field id="last_name" :label="lang('lastname')" type="text" name="last_name" classname="col-sm-4"
            			:onChange="onChange" :placehold="lang('enter_a_value')" :value="last_name" :required="false">
          			</text-field>

          			<dynamic-select id="location" name="location" classname="col-sm-4" apiEndpoint="/api/dependency/locations"
            			:multiple="false"  :label="lang('location')" :value="location" :required="false"
            			:onChange="onChange">
          			</dynamic-select>
        		</div>

        		<div class="row">

			        <phoneWithCountryCode id="phone_number" classname="col-sm-4" name="phone_number" :onChange="onChange" :value="phone_number"
			                              :countryCode="phone_country_code" :countryIso="phone_iso" @countCode="getPCountCode" @countIso="getPCountIso"
			                              labelName="phone_number" :apiUrl="'/api/dependency/country-codes?time='+Date.now()" @validPhoneNumber="checkValidity"
                                    fieldType="FIXED_LINE_OR_MOBILE">
			        </phoneWithCountryCode>

          			<text-field id="ext" :label="lang('ext')" type="number" name="ext" class="col-sm-2" :value="ext"
            			:onChange="onChange" :placehold="lang('enter_a_value')" @input="validateExtension">
          			</text-field>

					<phoneWithCountryCode id="mobile" classname="col-sm-4" name="mobile" :onChange="onChange" :value="mobile"
            			:countryCode="country_code" :countryIso="iso" @countCode="getCountCode" @countIso="getCountIso" @validPhoneNumber="checkValidity"
                                fieldType="FIXED_LINE_OR_MOBILE">
          			</phoneWithCountryCode>

          			<dynamic-select id="time-zone" name="agent_tzone" classname="col-sm-4"
            			apiEndpoint="/api/dependency/time-zones" :label="lang('agent_time_zone')" :value="agent_tzone"
            			:required="true" :multiple="false"  :onChange="onChange">
          			</dynamic-select>

              <text-field v-if="showCcoId" id="cco_id" classname="col-sm-4" :label="lang('cco_id')" type="text" name="cco_id"
                          :value="cco_id" :onChange="onChange" :placehold="lang('enter_a_value')">
              </text-field>
        		</div>
      		</faveo-box>

      		<faveo-box :title="lang('account_status_setting')" boxClass="card-light">

				<div class="row">

					<dynamic-select id="departments" name="departments" classname="col-sm-6" :removeVal="false"
              			apiEndpoint="/api/dependency/departments" :label="lang('department')" :hint="lang('primary_department')"
              			:value="departments" :required="true" :multiple="true"  :onChange="onChange" :api-parameters="getDeptParameters">
            		</dynamic-select>

					<radio-button id="role" name="role" classname="form-group col-sm-6" :options="lang(roleRadioOptions)"
            			:label="lang('role')" :value="role" :onChange="onChange">
            		</radio-button>
        		</div>

        		<div class="row">

					<dynamic-select id="teams" name="teams" classname="col-sm-6" apiEndpoint="/api/dependency/teams"
              			:label="lang('team')" :hint="lang('assigned_team')" :value="teams" :required="false" :multiple="true"
               			:onChange="onChange" :api-parameters="getApiParameters" :removeVal="false">
            		</dynamic-select>

					<dynamic-select id="type" name="type" classname="col-sm-6" apiEndpoint="/api/dependency/types"
               			:label="lang('type')" :hint="lang('ticket_type')" :value="type" :onChange="onChange"
              			:required="false" :multiple="true">
            		</dynamic-select>
        		</div>
      		</faveo-box>

      		<template v-if="role === 'agent'">

        		<faveo-box :title="lang('access-permissions')" boxClass="card-light">

					<div class="row">

						<div class="col-sm-4" id="assign_groups"  v-for="item in permissionsList" :key="item.id">

							<checkbox :name="item.key" :value="item.checked" :disabled="item.disabled" :label="item.key"
                				:title="item.name" :onChange="checkBoxOperations" :id="item.key">
              				</checkbox>
            			</div>
          			</div>
        		</faveo-box>

        		<div id="permission-list-box"></div>
      		</template>

      		<faveo-box :title="lang('agent_sign')" boxClass="card-light">

				<div>

					<tiny-editor
						:value="agent_sign"
						type="text"
						:onChange="onChange"
						name="agent_sign" label=""
						:lang="'en'"
						width="100%"
          id="agent-update-editor">

					</tiny-editor>
        		</div>
      		</faveo-box>

            <template #actions>
                <div class="card-footer">

                    <button id="agent-submit" class="btn btn-primary" type="button" @click="onSubmit">

                        <span :class="iconClass" id="submit-btn"></span>&nbsp; {{ lang(submitButton)}}
                    </button>
                </div>
            </template>
    	</faveo-box>
  	</div>
</template>

<script>

  import axios from "axios";

  import {getIdFromUrl,flatten, boolean} from "../../../../helpers/extraLogics";

  import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

  import { validateCreateAgentFormFields } from "../../../../helpers/validator/createAgentFormValidations.js";
  import TextField from "../../../MiniComponent/FormField/TextField.vue";
  import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
  import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
  import PhoneWithCountryCode from "../../../MiniComponent/FormField/PhoneWithCountryCode.vue";
  import Checkbox from "../../../MiniComponent/FormField/Checkbox.vue";

  export default {

	  name: "create-update-agent",

	  description: "Agent create and update page",

	  props : {

		  isCalledFromUserDirectoryPage : { type : Boolean, default : false }
	  },

	  components: {

		  'text-field': TextField,

		  'radio-button': RadioButton,

		  'dynamic-select': DynamicSelect,

		  'phoneWithCountryCode': PhoneWithCountryCode,

		  'checkbox': Checkbox,
	  },

	  data: () => ({
		  loading: true,
		  hasDataPopulated: false,
		  title: 'create_an_agent',
		  iconClass: 'fas fa-save',
		  submitButton: 'save',
		  agentId: 0,
		  first_name: '',
		  last_name: '',
		  user_name: '',
		  email: '',
		  ext: '', // extention of phone_number number
		  phone_number: '',
		  country_code: null,
		  mobile: '',
		  phone_country_code: null,
		  phone_iso :'',
		  role: 'admin', // Admin or Agent
		  roleRadioOptions: [{name:'admin', value: 'admin'}, {name:'agent', value: 'agent' }],
		  teams: [],
		  permissions: '',
		  agent_sign: '',
		  departments: [],
		  type: [],
		  location: '',
		  agent_tzone: '', // ex- {"id": "81", "name": "(GMT+05:30) Asia/Kolkata"}
		  permissionsList: [],
		  selectedPermissionList: [],
		  selectedPermissionIdsSD: '',
		  iso : '',
		  sdAgentPermissions : [],
      phoneValidityStatus: {
        phone_number: true,
        mobile: true
      },
      showCcoId : false,
      cco_id : '',
	  }),

	  beforeMount() {

		  this.getInitialValue();
	  },

	  created() {
      axios.get('/api/plugin-status-check/SmartBonding').then(res =>{
        this.showCcoId = res.data.data.status;
      }).catch(err => {
        errorHandler(err)
      })
		  // listen the event `selected-permission-list` fired from external script
		  window.emitter.on("selected-permission-list", (data) => {

			  this.selectedPermissionIdsSD = data;
		  })
	  },

	  computed : {

		  getApiParameters(){

			  return {
				  'department_ids': this.departments.map(obj=>obj.id),
			  };
		  },

		  getDeptParameters(){

			  return {

				  'team_ids': this.teams.map(obj=>obj.id),
			  };
		  },

      isPhoneValid() {
        return this.phoneValidityStatus.phone_number && this.phoneValidityStatus.mobile;
      }
	  },

	  methods: {
		  /**
		   * The function which will be called whaen value of the field changes.
		   * @param {value}
		   * `value` will be the updated value of the field
		   * @param {name}
		   * `name` will be thw name of the state in the parent class
		   * @return {Void}
		   */
		  onChange(value, name){

			  this[name] = value;

			  if(name === 'role') {

				  if(value === 'agent') {

					  this.updatePermissions();

					  this.showSdPermissionListBox(this.sdAgentPermissions)
				  }
			  }
		  },

		  getCountCode(value){

			  this.country_code = value;
		  },

		  getCountIso(value){

			  this.iso = value;
		  },

          getPCountCode(value){

			   this.phone_country_code = value;
		  },

		  getPCountIso(value){

			  this.phone_iso = value;
		  },

		  /** Get permission list
		   *  Adding `checked` & `disabled` properties
		   * Call agent info if edit agent page
		   */
		  getInitialValue() {
			  // Getting permission list
			  axios.get('api/dependency/permissions?limit=all', {})
            .then(res => {

				  this.permissionsList = flatten(res.data.data);

				  this.updatePermissions();

				  if (this.isEditAgent(window.location.pathname)) {// if it is an edit agent call

					  this.agentEditMode();

				  } else {

					  this.showSdPermissionListBox();

					  this.hasDataPopulated = true;

					  this.loading = false;
				  }
			  }).catch(err=>{

				  errorHandler(err)
			  })
		  },

		  updatePermissions() {
			  this.permissionsList.forEach(function(element) {
				  element.checked = false ;
				  element.disabled = false;
				  element.title = ""
				  if(element.key === "global_access"){
					  element.title = "Restricted access will be disabled if global access is checked."
				  } else if(element.key === "restricted_access"){
					  element.title = "Global access will be disabled if restricted access is checked."
				  }else if(element.key === "edit_articles_created_by_others"){
            element.disabled = true;
            //element.checked = true ;
          }
			  });
		  },

		  /**
		   * Scenarios for agent edit mode
		   */
		  agentEditMode(){

			  this.title = 'edit_an_agent';

			  this.iconClass = 'fas fa-sync'

			  this.submitButton = 'update'

			  this.getAgentInfo(this.agentId);
		  },

		  /**
		   * This method fetch the agent info
		   * @param {agentId}
		   * @return {Void}
		   */
		  getAgentInfo(agentId) {

			  this.loading = true;
			  // api request of specific agent info
			  axios.get('/api/admin/agent/' + agentId).then(res => {
          this.showCcoId = res.data.data.isCcoIdVisible
				  this.fillAgentInfo(res.data.data.agent);
			  }).catch(err => {
				  errorHandler(err)
				  this.loading = false;
				  this.hasDataPopulated = true
			  });
		  },

		  /**
		   * This method fill the view for update agent
		   * @param {agentInfo}
		   * @return {Void}
		   */
		  fillAgentInfo(agentInfo) {

			  try {

				  this.email = agentInfo.email ? agentInfo.email : ''

				  this.first_name = agentInfo.first_name ? agentInfo.first_name : ''

				  this.last_name = agentInfo.last_name ? agentInfo.last_name : ''

				  this.user_name = agentInfo.user_name ? agentInfo.user_name : ''

				  this.agent_sign = agentInfo.agent_sign ? agentInfo.agent_sign : ''

				  this.location = boolean(agentInfo.location) ? agentInfo.location: ''

				  this.role = agentInfo.role ? agentInfo.role : ''

				  this.ext = agentInfo.ext ? agentInfo.ext : ''

				  this.country_code = agentInfo.country_code ? agentInfo.country_code.id: null

				  this.phone_country_code = agentInfo.phone_country_code ? agentInfo.phone_country_code.id: null

				  this.iso = agentInfo.iso ? agentInfo.iso: this.iso;

				  this.phone_iso = agentInfo.phone_iso ? agentInfo.phone_iso: this.phone_iso;

				  this.mobile = (agentInfo.mobile && agentInfo.mobile !== 'Not available') ? agentInfo.mobile : ''

          this.cco_id = this.showCcoId ? agentInfo.cco_id : '';

          this.phone_number = (agentInfo.phone_number && agentInfo.phone_number !== 'Not available') ? agentInfo.phone_number : ''

				  this.agent_sign = agentInfo.agent_sign ? agentInfo.agent_sign  : ''

				  this.agent_tzone = agentInfo.agent_tzone ? agentInfo.agent_tzone : ''

				  this.type = agentInfo['type'] ? agentInfo['type']: ''

				  this.departments = agentInfo.departments ? agentInfo.departments: ''

				  this.teams = agentInfo.teams ? agentInfo.teams : ''

				  var that = this;

				  var ctr = 0;

				  var _tempVal = undefined

				  agentInfo.permissions.forEach(function(element, index, array){

					  ctr++;

					  if(element.key === 'global_access' || element.key === 'restricted_access') {

						  _tempVal = element.key

					  }

					  that.checkBoxOperations(true, element.key, true)

					  if(ctr===array.length && _tempVal){

						  that.handleGlobalResMode(true, _tempVal);
					  }
				  });

				  this.sdAgentPermissions = agentInfo.sd_permissions;

				  this.showSdPermissionListBox(agentInfo.sd_permissions);

				  this.loading = false;

				  this.hasDataPopulated = true

			  } catch (e) {

				  console.error('error in fillAgentInfo method ', e);
			  }
		  },

		  checkBoxOperations(value, selectedId, isEdit) {

			  let that = this;

			  this.permissionsList.forEach(function(element) {

				  if(element.key == selectedId) {

					  element.checked = value;

					  return;
				  }

				  that.handleGlobalResMode(value, selectedId);
			  });
		  },

		  handleGlobalResMode(value, selectedId) {

			  if(this.role === 'agent'){

				  setTimeout(()=> {

					  if(selectedId == 'global_access' || selectedId == 'restricted_access'){

						  let restrictedId = selectedId == 'global_access' ? 'restricted_access' : 'global_access';

						  if(this.permissionsList.find(obj => obj.key == selectedId).checked){

							  if(this.permissionsList.find(obj => obj.key == restrictedId).checked){

								  this.permissionsList.find(obj => obj.key == restrictedId).checked = false;

								  this.permissionsList.find(obj => obj.key == restrictedId).disabled = true;
							  }
						  }

						  document.getElementById(restrictedId).checked = false;

						  document.getElementById(restrictedId).disabled = value;

						  document.getElementById('view_all_tickets').checked = false;
						  document.getElementById('view_all_tickets').disabled = value;
					  }


            else if(selectedId == 'access_kb' ){
              if(this.permissionsList.find(obj => obj.key == 'access_kb').checked){

                document.getElementById('edit_articles_created_by_others').disabled = false;
              }else {
                document.getElementById('edit_articles_created_by_others').disabled = true;
                document.getElementById('edit_articles_created_by_others').checked = false;
              }

            }

				  },500)
			  }
		  },

		  /**
		   * Check if url contains edit
		   * @return {Boolean}
		   */
		  isEditAgent(path){

			  if(path.indexOf("edit") >= 0) {

				  this.agentId = getIdFromUrl(path); // Getting agent id from url

				  return true

			  } else {

				  return false;
			  }
		  },

      checkValidity(name, value) {
        this.phoneValidityStatus[name] = value;
      },

		  /**
		   * This method makes api call
		   * @param {agentInfo}
		   * @return {Void}
		   */
		  onSubmit() {

			  this.agent_sign = this.getAgentSign();

			  if(this.isValidInputs() && this.isPhoneValid) {

				  this.loading = true;

				  let params = this.getSubmitParams();

				  axios.post('api/admin/agent/', params).then(res => {

					  this.loading = false;

					  successHandler(res,'createUpdateAgent');

					  if(!this.isCalledFromUserDirectoryPage){

						  this.redirectToAgentListPage();

					  }
				  }).catch(err => {

					  this.loading = false;

					  errorHandler(err,'createUpdateAgent');
				  });
			  }
		  },

		  getSubmitParams() {

			  let params = {

				  email: this.email,

				  user_name: this.user_name,

				  first_name: this.first_name,

				  agent_tzone_id: this.agent_tzone ? this.agent_tzone.id : '',

				  role: this.role,

				  department_ids: this.departments.map(d => d.id),

				  id: this.agentId,

				  last_name: this.last_name,

				  type_ids: this.type ? this.type.map(t => t.id) : '',

				  location_id:this.location ? this.location.name : '',

				  permission_ids: this.role === 'agent' ? this.permissionsList.filter(perm => perm.checked).map(p => p.id) : [],

				  team_ids: this.teams ? this.teams.map(tm => tm.id) : '',

				  agent_sign: this.agent_sign,

				  ext: this.ext,
			  };

        if (this.showCcoId) {
          params['cco_id'] = this.cco_id || '';
        }

			  if(this.phone_country_code !== null){

				  params['phone_number'] = this.phone_number;

				  params['phone_country_code'] = this.phone_country_code;

				  params['phone_iso'] = this.phone_iso;
			  }

			  if(this.country_code !== null) {

				  params['mobile'] = this.mobile;

				  params['country_code'] = this.country_code;

				  params['iso'] = this.iso;
			  }

			  if(this.selectedPermissionIdsSD){

				  params['sd_permission_ids'] = this.role === 'agent' ? this.selectedPermissionIdsSD : [];
			  }

			  return params;
		  },

		  // redirect to agent list page
		  redirectToAgentListPage() {

			  if(window.location.href.indexOf('user') > -1) {

				  window.location.href = window.axios.defaults.baseURL + '/panel/user';

			  }  else if (!this.agentId && !window.location.href.includes('edit')) {

          setTimeout(() => {

            this.$router.push({ name: 'Agents Index' });

          }, 3000);
        }
		  },

		  getAgentSign() {

			  return this.agent_sign;
		  },

		  /**
		   * This method validates the user input for mandatory fields
		   * @return {Boolean}
		   */
		  isValidInputs() {

			  const {errors, isValid} = validateCreateAgentFormFields(this.$data);

			  return isValid;
		  },

		  /**
		   * For any external script to be able to inject some javascript on sd permission box
		   * @return {undefined}
		   */
		  showSdPermissionListBox(data) {

			  window.emitter.emit("permission-list-box-mounted", data);

		  },
      validateExtension() {
        this.ext = this.ext.replace(/[^0-9]/g, '');
      }
	  },
  };
</script>

<style>
input[type="number"]::-webkit-inner-spin-button,
input[type="number"]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type="number"] {
  -moz-appearance: textfield;
}
</style>