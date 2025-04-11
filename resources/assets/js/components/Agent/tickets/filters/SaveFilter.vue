<template>

  <!-- A filter pop-up that should appear while saving a filter -->
  <modal :showModal="true" :onClose="onClose">

    <!-- if mode is delete, we only show the confirmation message that if they really want to delete -->
    <template #title>
      <!-- should change according to saving or sharing -->
      <h4 class="modal-title" v-if="mode !== 'delete'">{{lang(source === 'open_tickets' && mode !== 'save' ? 'update_filter' : 'save_filter')}}</h4>
      <h4 v-else class="modal-title">{{lang('are_you_sure_you_want_to_delete')}}</h4>
    </template>

    <template #alert>

      <alert :componentName="this.$options.name"/>
    </template>

      <template #fields>

          <div v-if="mode !== 'delete'" class="save-filter-modal-body">

              <custom-loader v-if="loading"></custom-loader>

              <div class="row" v-focus-first-input>

                  <text-field name="name" :label="lang('name')" :value="name" :onChange="onChange" :required="true" classname="col-md-6">
                  </text-field>

                <div v-if="filterId !== 0 && this.mode !== 'save'" class="col-sm-6 ps-0 filter-info">
                  <div v-if="created_by" class="col-sm-12">
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
              <section>
                  <div v-if="checkFromWhere()" class="row">

                    <div class="col-sm-6">

                      <checkbox id="isDisplayOnDashboard" name="isDisplayOnDashboard" :value="isDisplayOnDashboard" :disabled="isDisabled" :class="isDisabled ? 'cursor-none' : ''" :label="trans('display_this_filter_on_dashboard')"
                                :onChange="onChange" classname="col-sm-12">
                      </checkbox>
                    </div>

                    <div v-if="!isShared" class="col-sm-6">

                      <checkbox id="isDisplayUnderDefault" name="isDisplayUnderDefault" :value="isDisplayUnderDefault" :disabled="isDisabled" :class="isDisabled ? 'cursor-none' : ''" :label="trans('display_filter_in_sidebar')"
                                :onChange="onChange" classname="col-sm-12">
                      </checkbox>
                    </div>
                  </div>

                  <div class="row">
                      <div class="col-sm-6">
                          <label for="dashboard-widget-bg-color"> {{ lang('icon_color') }} </label>
                          <label class="is-danger" v-if="isDisplayOnDashboard">*</label>
                          <tool-tip :message="lang('dashboard_icon_background_color_hint')" size="small"></tool-tip>
                          <color-picker id="dashboard-widget-bg-color" name="iconColor" :color="iconColor" :disabled="!isDisplayOnDashboard && from !== 'clientFilter'"
                                        :onColor="onChange"/>
                      </div>

                      <dynamic-select  name="iconClass" :label="lang('icon_class')" :value="iconClass" :onChange="onChange"
                                      classname="col-md-6" :elements="iconList" :disabled="!isDisplayOnDashboard && from !== 'clientFilter'" :multiple="false" option-label="icon_class" :required="isDisplayOnDashboard" :clearable="false" :hint="lang('dashboard_icon_class_hint')">
                      </dynamic-select>
                  </div>
              </section>

              <section v-if="checkFromWhere() && !isDisplayUnderDefault">
                  <div class="row">
                      <div class="col-sm-4" style="line-height: 2">
                          <span><strong>{{lang('share_with') + ':'}}</strong></span><tool-tip :message="lang('share_filter_tooltip_message')" size="small"></tool-tip>
                      </div>
                  </div>

                  <div class="row">
                      <dynamic-select name="agents" :label="lang('agents')" :value="agents" :onChange="onChange"
                                      classname="col-md-6" apiEndpoint="/api/dependency/agents" :multiple="true">
                      </dynamic-select>

                      <dynamic-select name="departments" :label="lang('departments')" :value="departments" :onChange="onChange"
                                      classname="col-md-6" apiEndpoint="/api/dependency/departments" :multiple="true">
                      </dynamic-select>
                  </div>

              </section>

              <section>
                <div class="row">
                  <dynamic-select v-if="checkFromWhere() && !isDisplayUnderDefault" name="teams" :label="lang('teams')" :value="teams" :onChange="onChange"
                                  classname="col-md-6" apiEndpoint="/api/dependency/teams" :multiple="true">
                  </dynamic-select>

                  <!-- Display order for tickets sidebar -->
                  <number-field v-if="checkFromWhere()" :label="lang('display_order')" :value="display_order"
                                name="display_order" classname="col-sm-6"
                                :onChange="onChange" placeholder="n" type="number" :required="true">

                  </number-field>

                </div>
              </section>
          </div>

          <!-- body for deleting confirmation -->
          <div v-else>
              <span>You are about to delete a filter with name <strong>{{filterName}}</strong>
                created by you. Please confirm</span>
          </div>
      </template>

    <template #controls>
        <div>
            <button v-if="showSave() && mode !== 'save'" type="button" @click = "saveFilter('update')" class="btn btn-primary">
                <i class="fas fa-sync" aria-hidden="true"></i>&nbsp;{{lang('update')}}</button>

            <template v-if="from === 'clientFilter'">

                <button v-if="showSaveNew()" type="button" @click = "saveFilter('create')" class="btn btn-primary">
                    <i class="fas fa-save" aria-hidden="true"></i>&nbsp;{{lang('save_as_new')}}</button>
            </template>

            <template v-else>

              <button v-if="source === 'open_tickets' && mode === 'save'" type="button" @click = "saveFilter('create')" class="btn btn-primary">
                <i class="fas fa-save" aria-hidden="true"></i>&nbsp;{{lang('save')}}</button>

                <button v-if="showSaveAsNew() && source !== 'open_tickets' && mode !== 'save'" type="button" @click = "saveFilter('create')" class="btn btn-primary">
                    <i class="fas fa-save" aria-hidden="true"></i>&nbsp;{{lang('save_as_new')}}</button>

            </template>

            <button v-if="showDelete()" type="button" @click = "deleteFilter()" class="btn btn-secondary"><i class="fas fa-trash" aria-hidden="true"></i>&nbsp;{{lang('delete')}}</button>

        </div>
    </template>

  </modal>
</template>

<script type="text/javascript">

  import {successHandler,errorHandler} from "../../../../helpers/responseHandler";
  import {extractOnlyId, boolean, getSubStringValue} from '../../../../helpers/extraLogics';
  import { validateSaveFilter } from "../../../../helpers/validator/SaveFilterRules";
  import axios from 'axios';
  import TextField from "../../../MiniComponent/FormField/TextField.vue";
  import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
  import ToolTip from "../../../MiniComponent/ToolTip.vue";
  import Checkbox from "../../../MiniComponent/FormField/Checkbox.vue";
  import ColorPicker from "../../../MiniComponent/FormField/ColorPicker.vue";
  import {useStore} from 'vuex';
  import {computed} from 'vue';
  import NumberField from "../../../MiniComponent/FormField/NumberField.vue";

  export default {

    name:'save-filter',

    description:'Save filter pop-up in ticket filters',

    setup() {

      const store = useStore();

      return {

        formattedTime : computed(()=>store.getters.formattedTime),
      }
    },

    props:{

      /**
       * Name of the filter. If passed from parent, it will reflect here. else it will update to parent
       * @type {Object}
       */
      filterName:{ type:String, default:'' },

      /**
       * Filter data that has to be sent to the backend in detailed format
       * for eg. for first helptopic it will be {id:1, name: 'test_helptopic'}
       * @type {Object}
       */
      filterObjects:{ type:Object, required:true },

      /**
       * Filter data that has to be sent to the backend with just the IDs or final value,
       * for eg. for first helptopic it will be 1
       * @type {Object}
       */
      filterValues:{ type:Object, required:true },

      /**
       * Id of the filter. if a new filter is getting created, it will be zero
       * @type {Object}
       */
      filterId:{ type:Number, default: 0 },

      /**
       * Toggles the visibility of the filter
       * @param showHidePopup
       * @param isClosePopupClicked
       */
      toggleFilterPopUp: { type:Function, required:true },

      /**
       * It can be either of `delete`, `share_only` or `save`
       * @type {Object}
       */
      mode: {type: String, default:''},

      /**
       * Initial lists of agents
       * @type {Array}
       */
      initialAgents:{type:Array, default:()=>[]},

      /**
       * Initial list of agents
       * @type {Array}
       */
      intitialDepartments:{type:Array, default:()=>[]},


      initialTeams : { type : Array, default : () => []},

      /**
       * Applies filter
       * @type {Object}
       */
      postFilterSaveAction: {type: Function, required: true},

      from : { type : String, default : '' },

      totalFilters: { type : Number, default : 0},

      dashboardConfig: {
        type: Object,
        default: function () {
          return {
            displayOnDashboard: false,
            isDisplayUnderDefault: false,
            iconColor: '#00C0EF',
            iconClass: {
              "icon_class": "fas fa-ticket"
            },
            created_at: '',
            created_by: [],
            canViewCreatorProfile: true,
            display_order:''
          }
        }
      },

      source : { type : String, default : '' },
    },

    data(){
      return{
        /**
         * Name of the filter
         * @type {String}
         */
        name:'',

        /**
         * agents with which filters are/will be shared
         * @type {Array}
         */
        agents: [],

        /**
         * Departments with which filters will be shared
         * @type {Array}
         */
        departments: [],

        /**
         * Whether filter should be visible or not
         * @type {Boolean}
         */
        shallFilterBeVisible:true,

        /**
         * If an Api response has been made and it is still loading
         * @type {Boolean}
         */
        loading:false,


        /**
         * If true this report will be displayed on the dashboard
         */
        isDisplayOnDashboard: false,

        iconColor: '',

        iconClass: '',

        iconList: [],

        isDisplayUnderDefault: false,

        created_by:[],

        created_at:'',

        canViewCreatorProfile: true,

        display_order: '',

        teams : []
      }
    },

    beforeMount() {
      const isConditionMet = this.source === 'open_tickets' && this.mode === 'save';

      this.isDisplayOnDashboard = isConditionMet ? false : this.dashboardConfig.displayOnDashboard;
      this.isDisplayUnderDefault = isConditionMet ? false : this.dashboardConfig.isDisplayUnderDefault;
      this.iconColor = isConditionMet ? '#00C0EF' : this.dashboardConfig.iconColor;
      this.iconClass = isConditionMet ? { "icon_class": "fas fa-ticket" } : this.dashboardConfig.iconClass;
      this.created_at = isConditionMet ? '' : this.dashboardConfig.created_at;
      this.created_by = isConditionMet ? [] : this.dashboardConfig.created_by;
      this.canViewCreatorProfile = isConditionMet ? true : this.dashboardConfig.canViewCreatorProfile;
      this.departments = isConditionMet ? [] : this.intitialDepartments;
      this.agents = isConditionMet ? [] : this.initialAgents;
      this.teams = isConditionMet ? [] : this.initialTeams;
      this.name = isConditionMet ? '' : this.filterName;
      this.display_order = isConditionMet ? '' : this.dashboardConfig.display_order;

      this.mode !== 'delete' ? this.getIconList() : '';
    },

    methods:{

      checkFromWhere() {

        return  this.from === 'clientFilter' ? false : true;
      },
  			/**
  			 * Updates a filter or creates a new one at backend
  			 * @param  {String} type 	type can be either `create` or `update`
  			 * @return {undefined}
  			 */

        isValid(){
          if (this.from !== 'clientFilter') {
            const { errors, isValid } = validateSaveFilter(this.$data);
            return isValid;
          }
          return true;
        },

  			saveFilter(type){

          if(this.isValid()){

            //removing all previous validation errors
            this.$store.dispatch('unsetValidationError');

            this.loading = true;

  					axios.post('/api/agent/ticket-filter', this.getApiParams(type) )
  					.then(res=>{
  						// this.selectedFilter = res.data.data.id
              this.loading = false;
  						successHandler(res, this.$options.name);


              // takes post filter save actions after it gets saved successfully
              this.postFilterSaveAction();

              setTimeout(()=>{
                this.toggleFilterPopUp(false, false);

                window.emitter.emit('ticketFilterSaved');
                window.emitter.emit('updateFilterApi');
              }, 2000)

              // sidebar has to be updated as soon as filter gets updated
              window.emitter.emit('updateNavActive'); // emiter for sidebar order update
              window.emitter.emit('updateSideNav');
              window.emitter.emit('updateAgentSidebar');

  					}).catch(err=>{
              this.loading = false;
              errorHandler(err,this.$options.name);
  					});
          }
        },
        
        getApiParams(type) {
  				const ticketId = (type == 'create') ? 0 : this.filterId;
          let params = {
            id: ticketId,
            name: this.name ,
            fields: this.getFormattedFilterData(),
            agents: this.isDisplayUnderDefault ? [] :  extractOnlyId(this.agents),
            departments: this.isDisplayUnderDefault ? [] : extractOnlyId(this.departments),
            teams :  this.isDisplayUnderDefault ? [] : extractOnlyId(this.teams),
            display_on_dashboard: this.isDisplayOnDashboard,
            display_on_navigation_bar: this.isDisplayUnderDefault,
            icon_class: this.iconClass.icon_class && this.iconClass.icon_class === 'fa fa-minus-circle'  ? 'fas fa-minus-circle' : this.iconClass.icon_class,
            icon_color: this.iconColor,
            display_order: this.display_order,
            clientFilter: this.from === 'clientFilter',
          }

          params['is_Edited'] = !(this.source === 'open_tickets' && type !== 'create');

          params['type'] = this.from === 'clientFilter' ? 'admin' : 'agent';

          return params;
        },


        /**
         * Fetch all the icon-classes 
         */
        getIconList() {
          axios.get('/json/icon-list.json')
          .then((response) => {
            this.iconList = response.data.data;
          })
          .catch((error) => {
            this.iconList = [];
          })
        },

        getFormattedFilterData(){
          const timeRangeFilterOptions = ['due-on', 'created-at', 'updated-at'];

          return Object.keys(this.filterObjects)
          .filter(keyOne => {
            return boolean(this.filterObjects[keyOne])
          })
          .map(key => {
            let value = (this.filterValues[key] !== undefined)? this.filterValues[key] : this.filterObjects[key];
            return {key: key, value: value}
          })
        },

        deleteFilter(){
          //removing all previous validation errors
          this.$store.dispatch('unsetValidationError');

          this.loading = true;

          axios.delete('/api/agent/ticket-filter/' + this.filterId).then(res=>{
            // this.selectedFilter = res.data.data.id
            this.loading = false;
            successHandler(res, this.$options.name);
            setTimeout(()=>{

              this.toggleFilterPopUp(false, false)
              // redirect it to inbox after deleting the filter
              this.$router.push('/tickets/filter/'+res.data.data.filter_id);
            }, 2000)

          }).catch(err=>{
            this.loading = false;
            errorHandler(err,this.$options.name);
          });

        },

        /**
         * Updates local state variables
         * @param  {String|Object|Number} value   value of the changed field
         * @param  {String}               name    name of the changed field
         * @return {undefined}
         */
        onChange(value, name){
          this[name] = value
        },

        /**
         * Closes the ticket save filter pop-up
         * @return {String} [description]
         */
        onClose(){
          this.$store.dispatch('unsetValidationError');
          this.$store.dispatch('unsetAlert');
          this.toggleFilterPopUp(false, true);
        },

        /**
         * If `save as new` button should be visible
         * @return {Boolean}
         */
        showSaveAsNew(){
          return this.mode !== 'delete'
        },

        /**
         * If `save as new` button should be visible
         * @return {Boolean}
         */
        showSaveNew(){
          return this.mode !== 'delete' && this.totalFilters != 5;
        },

        /**
         * If save button should be visible
         * @return {Boolean}
         */
        showSave(){
            return this.mode !== 'delete' && this.filterId != 0
        },

        /**
         * if delete button should be visible
         * @return {Boolean}
         */
        showDelete(){
          return this.mode === 'delete'
        },

         subString(value,length = 25){

           return getSubStringValue(value,length)
         },

    },

    computed: {
      isDisabled() {
        return this.source === 'open_tickets' && this.mode !== 'save';
      },

      isShared(){
        return this.departments.length > 0 || this.agents.length > 0;
      }
    },

    watch: {

      /**
       * Watching `isDisplayOnDashboard` to decide whether to make an API call or not
       * if `isDisplayOnDashboard` is true and iconList is empty then only fetch the list json
       */
      isDisplayOnDashboard: function() {
        if(this.isDisplayOnDashboard && this.iconList.length === 0) {
          this.getIconList();
        }
      }
    },

    components:{
      'text-field': TextField,
      'dynamic-select': DynamicSelect,
      "tool-tip": ToolTip,
      'checkbox' : Checkbox,
      'color-picker': ColorPicker,
      'number-field': NumberField
    }
  }

</script>

<style scoped>
  .center-of-page {
    position: absolute !important;
    left: 11% !important;
  }

.mailinbox input[type="checkbox"] {
  display: inline;
}

  .filter-info{
    font-size:13px;
    padding-top: 30px;
  }

  .permission-update{
    cursor: not-allowed;
  }

  .creater-info, .permission-update{
    color: rgb(60, 141, 188) !important;
  }

  .cursor-none{
    cursor: not-allowed;
  }
</style>
