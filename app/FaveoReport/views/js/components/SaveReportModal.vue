<template>

    <modal :showModal="true" :onClose="onClose">

      <template #title>
        <h4 class="modal-title">{{lang(title)}}</h4>
      </template>

      <template #alert>

        <alert componentName="save-report-modal"/>
      </template>

		<template #fields>

			<div v-if="isLoading">

				<custom-loader></custom-loader>
			</div>

			<div class="save-report" v-focus-first-input>

        <div class="row">
          <text-field
              id="name"
              :label="lang('name')"
              type="text"
              name="name"
              classname="col-md-6"
              :value="name"
              :onChange="onPropertyChange"
              :placehold="lang('enter_a_value')"
              :required="true">
          </text-field>

          <div v-if="isEditing" class="col-sm-6 ps-0 filter-info mt-4">
            <div class="col-sm-12">
              <b>{{lang('created_by')}}:</b>&nbsp;
              <span>
                <a v-if="canViewCreatorProfile" target="_blank" class="creater-info" v-tooltip="trans(created_by.full_name)" :href="basePath()+'/panel/user/'+created_by.id">{{subString(created_by.full_name)}}</a>
                <span v-else class="permission-update"  v-tooltip="trans('access_denied_now')">{{subString(created_by.full_name)}}</span>
              </span>
            </div>

            <div class="col-sm-12">
              <b>{{trans('created_at')}}:</b>&nbsp;<span v-tooltip="formattedTime(created_at)">{{formattedTime(created_at)}}</span>
            </div>
          </div>
        </div>


				<text-field
					id="description"
					:label="lang('description')"
					type="textarea"
					name="description"
					classname="col-md-12"
					:value="description"
					:onChange="onPropertyChange"
          :placehold="lang('enter_a_value')"
					:required="true"
          :show-word-limit="true"
          length="180">
				</text-field>

			</div>

      <div class="row">
        <div class="col-sm-4 col-md-4">
          <label for="dashboard-widget-bg-color"> {{ lang('icon_color') }} </label>
          <tool-tip :message="lang('dashboard_icon_background_color_hint')" size="small"></tool-tip>
          <color-picker id="dashboard-widget-bg-color" name="iconColor" :color="iconColor"
                        :onColor="onPropertyChange"/>
        </div>

        <dynamic-select  name="iconClass" :label="lang('icon_class')" :value="iconClass" :onChange="onPropertyChange"
                         classname="col-md-4" :elements="iconList" :multiple="false" option-label="icon_class" :clearable="false" :hint="lang('report_icon_class_hint')">
        </dynamic-select>

        <number-field :label="lang('display_order')" :value="display_order"
                      name="display_order" classname="col-sm-4"
                      :onChange="onPropertyChange" placeholder="n" type="number"
                      :required="true">

        </number-field>
      </div>

      <checkbox
          name="isPrivate"
          :value="isPrivate"
          :label="lang('make_this_report_private')"
          :onChange="onPropertyChange"
          classname="col-md-12"
          id="allow-only-ldap-login">
      </checkbox>

      <div v-if="renderSharingOption">
        <div class="row">
          <div class="col-sm-4" style="line-height: 2">
            <span><strong>{{lang('share_with') + ':'}}</strong></span><tool-tip :message="lang('report_filter_share_hint')" size="small"></tool-tip>
          </div>
        </div>

        <div class="row">

          <dynamic-select :label="lang('agents')" :multiple="true" name="agents" :prePopulate="true" class="col-md-12"
                          apiEndpoint="/api/dependency/agents" :value="agents" :onChange="onPropertyChange">

          </dynamic-select>
        </div>

        <div class="row">

          <dynamic-select :label="lang('departments')" :multiple="true" name="departments" :prePopulate="true" class="col-md-6"
                          apiEndpoint="/api/dependency/departments" :value="departments" :onChange="onPropertyChange">

          </dynamic-select>

          <dynamic-select :label="lang('teams')" :multiple="true" name="teams" :prePopulate="true" classname="col-md-6"
                          apiEndpoint="/api/dependency/teams" :value="teams" :onChange="onPropertyChange">

          </dynamic-select>

        </div>
      </div>

		</template>

      <template #controls>
        <button class="btn btn-primary" id="new-report-submit" @click="onSubmit" :disabled="isLoading">
          <span><i :class="modalMode === 'fork' ? 'fas fa-save' : 'fas fa-sync-alt'"></i></span>
          {{ trans(modalMode === 'fork' ? 'save' : 'update') }}
        </button>
      </template>

    </modal>
</template>

<script>
import axios from 'axios';
import {errorHandler,successHandler} from "../../../../../resources/assets/js/helpers/responseHandler";
import {
  boolean,
  getFormattedFilterValues,
  getIdFromUrl,
  getSubStringValue
} from "../../../../../resources/assets/js/helpers/extraLogics";
import TextField from "../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";
import Checkbox from "../../../../../resources/assets/js/components/MiniComponent/FormField/Checkbox.vue";
import DynamicSelect from "../../../../../resources/assets/js/components/MiniComponent/FormField/DynamicSelect.vue";
import ToolTip from "../../../../../resources/assets/js/components/MiniComponent/ToolTip.vue";
import ColorPicker from "../../../../../resources/assets/js/components/MiniComponent/FormField/ColorPicker.vue";
import {useStore} from "vuex";
import {computed} from "vue";
import NumberField from "../../../../../resources/assets/js/components/MiniComponent/FormField/NumberField.vue";
import { validateSaveFilter } from "../../../../../resources/assets/js/helpers/validator/SaveFilterRules";

export default {

    name:'save-report-modal',

  setup() {

    const store = useStore();

    return {

      formattedTime : computed(()=>store.getters.formattedTime),
    }
  },

    props: {

      // fork(new report) or update existing one
      modalMode: {
        type: String,
        required: true
      },

      // report data oject need to be saved
      reportDataObj: {
        type: Object,
        required: true
      },

      // on clodse modal fn
      onClose: {
        type: Function,
        required: true
      },

      from: {
        type: String,
        default: ''
      },

      filterValues:{
        type: Object,
        default: () => {}
      },

      filterArray : { type : Array, default : ()=>[] },

      chartType: {type: String, default: ''}
    },

    data() {
      return {
        title: '', // modal heading
        name: '', // report name
        description: '', // report description
        isPublic: true, // is public/private report
        isLoading: false,
        renderSharingOption : false,
        teams : [],
        departments : [],
        agents : [],
        iconColor: '#00C0EF',
        iconClass: "fas fa-life-ring",
        isPrivate : false,
        iconList : [],
        canViewCreatorProfile : true,
        created_by : [],
        created_at : null,
        isEditing : false,
        display_order : '',
      }
    },

    beforeMount() {
      this.setUpComponentPropertiesBasisOfMode();
      this.getIconList();
    },

    methods: {

      getIconList() {

        axios.get('/json/icon-list.json').then((response) => {

          this.iconList = response.data.data;

        }).catch((error) => {

          this.iconList = [];
        })
      },

      subString(value,length = 25){

        return getSubStringValue(value,length)
      },

      setUpComponentPropertiesBasisOfMode() {
        if(this.modalMode === 'fork') {
          this.title = 'save_filter';
        } else if(this.modalMode === 'update') {
          this.isEditing = true
          this.name = this.reportDataObj.name;
          this.description = this.reportDataObj.description;
          this.isPrivate = !this.reportDataObj.is_public;
          this.title = 'update_this_report';
          this.renderSharingOption = this.isPrivate

          this.iconClass = this.reportDataObj.iconClass ?? 'fas fa-life-ring'
          this.iconColor = this.reportDataObj.iconColor ?? '#6C757d'
          this.created_at = this.reportDataObj.created_at
          this.created_by = this.reportDataObj.creator?.[0];
          this.display_order = this.reportDataObj.display_order

          if (this.reportDataObj.shareAbles) {
            this.agents = this.reportDataObj.shareAbles.agents
            this.departments = this.reportDataObj.shareAbles.departments
            this.teams = this.reportDataObj.shareAbles.teams
          }
        }
      },

      isValid(){
          const { errors, isValid } = validateSaveFilter(this.$data);
          return isValid;
      },

      onSubmit() {

        if(this.isValid()){

          this.$store.dispatch('unsetValidationError');

          this.isLoading = true;

          // if creating,
          let postConfigUrl

          postConfigUrl = this.from === 'sd_report' || this.from === 'sd_report_home' ? 'service-desk/api/fork/sd-report' : 'api/agent/report-config';

          if(this.modalMode === 'fork'){
            // if forking, we need parent id
            postConfigUrl = this.from === 'sd_report' || this.from === 'sd_report_home' ? postConfigUrl : postConfigUrl + "/" + getIdFromUrl(window.location.pathname);
          }

          axios.post(postConfigUrl, this.from === 'sd_report' || this.from === 'sd_report_home' ? this.getSdReportParams() : this.getSaveReportParams())
              .then(res => {
                setTimeout(() => this.onClose(), 1000); // close the modal after 1 second
                successHandler(res, 'save-report-modal');
                if(this.modalMode === 'fork') { // redirect to report list page only if the case of `fork`
                  this.redirectToReporListPage();
                } else { // refresh the entry page while update completion
                  window.emitter.emit(this.from === 'sd_report' ? 'refreshSdReport' :
                      this.from === 'report-list' || this.from === 'sd_report_home' ? 'refreshReportHomePage' :
                          'refreshReportEntryPage');
                }

                window.emitter.emit('updateAgentSidebar');
              }).catch(err => {
            errorHandler(err, 'save-report-modal');
          }).finally(res => {
            this.isLoading = false;
          });
        }
      },

      /**
       * Get the parameters to be saved for the report
       */
      getSaveReportParams() {
        const clonedReportDataObj = JSON.parse(JSON.stringify(this.reportDataObj));
        if(this.modalMode === 'fork') { // assign null to report id to create a fresh new report
          clonedReportDataObj.id = null;
        }
        clonedReportDataObj.name = this.name;
        clonedReportDataObj.description = this.description;
        clonedReportDataObj.is_public = !this.isPrivate;

        clonedReportDataObj.shareAbles = {
          agents : this.agents, departments : this.departments, teams : this.teams
        }

        clonedReportDataObj.iconClass = this.iconClass
        clonedReportDataObj.iconColor = this.iconColor
        clonedReportDataObj.display_order = this.display_order

        return clonedReportDataObj;
      },

      getSdReportParams(){

        const sdReportForkData = {}

        const fromFilterReport = JSON.parse(JSON.stringify(this.reportDataObj))
        if(this.modalMode === 'update') { // assign null to report id to create a fresh new report
          sdReportForkData.id = fromFilterReport.id;
        }

        sdReportForkData.name = this.name;
        sdReportForkData.description = this.description;
        sdReportForkData.chart_type = this.chartType;
        sdReportForkData.filters = this.formattedFilterData();
        sdReportForkData.is_plugin = 1;
        sdReportForkData.type = parseInt(fromFilterReport.type);
        sdReportForkData.is_default = 0;
        sdReportForkData.parentId = fromFilterReport.id;

        sdReportForkData.is_public = !this.isPrivate;

        sdReportForkData.shareAbles = {
          agents : this.agents, departments : this.departments, teams : this.teams
        }

        sdReportForkData.iconClass = this.iconClass
        sdReportForkData.iconColor = this.iconColor
        sdReportForkData.display_order = this.display_order

        return  sdReportForkData;
      },

      formattedFilterData(){

        let val = getFormattedFilterValues(this.filterArray,this.filterValues);

        return Object.keys(val)
            .filter(keyOne => {
              return boolean(val[keyOne])
            })
            .map(key => {
              let value = val[key];
              return {key: key, value: value}
            })
      },

      redirectToReporListPage() {
        setTimeout(() => this.$router.push({ name : 'Reports Index'}), 1000); // close the modal after 1 second
      },

      // Assign value to component properties
      onPropertyChange(value, property) {
        this[property] = value;

        if (property === 'isPrivate') {
          this.renderSharingOption = value;
        }

        if (property === 'iconClass') {
          this.iconClass = value.icon_class
        }
      },
    },

    components: {
      'number-field': NumberField,
      ColorPicker,
      ToolTip,
      DynamicSelect,
      'text-field': TextField,
      'checkbox': Checkbox
    }
  }

</script>

<style>
.filter-info{
  font-size:13px;
}
</style>
