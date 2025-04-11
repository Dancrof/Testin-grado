<template>

  <modal :showModal="true" :onClose="onClose">

    <template #title>

      <h4 class="modal-title">
        <!-- Conditionally render the title based on the mode -->
        {{ mode === 'save' ? trans('save_filter') : (mode === 'update' ? trans('update_filter') : trans('delete_filter')) }}
      </h4>
    </template>

    <template #alert>

      <alert :componentName="this.$options.name"/>
    </template>

    <template #fields>

      <custom-loader v-if="loading"></custom-loader>

      <div class="row" v-if="mode != 'delete'" v-focus-first-input>

        <text-field name="name" :label="trans('name')" :value="name" :onChange="onChange" :required="true" classname="col-md-6">

        </text-field>

      </div>

      <div v-if="mode != 'delete'" class="row">
        <div class="col-sm-4" style="line-height: 2">
          <input type="checkbox" name="isDashboardWidget" id="isDashboardWidget" v-model="isDashboardWidget">
          <label for="isDashboardWidget" class="ms-1" >{{lang('display_this_filter_on_dashboard')}}</label>
        </div>
      </div>

      <div v-if="mode != 'delete'" class="row">
        <div class="col-sm-6">
          <label for="dashboard-widget-bg-color"> {{ lang('icon_color') }} </label>
<!--          <label class="is-danger" v-if="isDashboardWidget">*</label>-->
          <tool-tip :message="lang('dashboard_icon_background_color_hint')" size="small"></tool-tip>
          <color-picker id="dashboard-widget-bg-color" name="iconColor" :color="iconColor"
                        :onColor="onChange"/>
        </div>
        <dynamic-select name="iconClass" :label="trans('icon_class')" :value="iconClass" :onChange="onChange"
                        classname="col-md-6" :elements="iconList" :multiple="false" option-label="icon_class" :required="true"
                        :clearable="false" :hint="trans('dashboard_icon_class_hint')">
        </dynamic-select>
      </div>

      <section v-if="mode != 'delete'">

        <div class="row">

          <div class="col-sm-4" style="line-height: 2">

            <span><strong>{{trans('share_with') + ':'}}</strong></span>

            <tool-tip :message="trans('share_filter_tooltip_message')" size="small" placement="right"></tool-tip>

          </div>
        </div>

        <div class="row">

          <dynamic-select name="agents" :label="trans('agents')" :value="agents" :onChange="onChange"
            classname="col-md-6" apiEndpoint="/api/dependency/agents" :multiple="true">
          </dynamic-select>

          <dynamic-select name="departments" :label="trans('departments')" :value="departments" :onChange="onChange"
            classname="col-md-6" apiEndpoint="/api/dependency/departments" :multiple="true">
          </dynamic-select>
        </div>
      </section>

		<div v-if="mode == 'delete'">

			<span>{{trans('delete_filter_with_name')}} <strong>{{filterName}}</strong>{{trans('created_by_you_confirm')}}</span>
		</div>
    </template>

    <template #controls>
      <div class="controls-div">

		  <button v-if="showSave()" type="button" @click="saveFilter('update')" class="btn btn-primary">
			  <i class="fas fa-sync" aria-hidden="true"></i>&nbsp;{{trans('update')}}
		  </button>

		  <button v-if="showSaveAsNew()" type="button" @click="saveFilter('create')" class="btn btn-primary">
			  <i class="fas fa-save" aria-hidden="true"></i>&nbsp;{{trans('save_as_new')}}
		  </button>

		  <button v-if="showDelete()" type="button" @click="deleteFilter()" class="btn btn-secondary">
			  <i class="fas fa-trash" aria-hidden="true"></i>&nbsp;{{trans('delete')}}
		  </button>
	  </div>
    </template>
  </modal>
</template>

<script>

  import {successHandler, errorHandler} from '../../helpers/responseHandler';

  import {extractOnlyId, boolean, getFormattedFilterValues} from '../../helpers/extraLogics';

  import axios from 'axios';

  import { validateSaveFilterSettings } from '../../helpers/validator/saveFilterSettings'
  import TextField from "../MiniComponent/FormField/TextField.vue";
  import DynamicSelect from "../MiniComponent/FormField/DynamicSelect.vue";
  import ToolTip from "../MiniComponent/ToolTip.vue";
  import ColorPicker from "../MiniComponent/FormField/ColorPicker.vue";

  export default {

    name:'save-table-filter',

    props:{

      showModal : { type : Boolean, default : false },

      filterName : { type : String, default : '' },

      icon : { type : [Object, String], default :'' },

      filterValues : { type : Object, default : ()=>{} },

      filterId : { type : [String, Number], default : '' },

      toggleFilterPopUp : { type : Function, default : ()=>{} },

      source : { type : String, default : '' },

      filterArray : { type : Array, default : ()=>[] },

      initialAgents:{type:Array, default:()=>[]},

      intitialDepartments:{type:Array, default:()=>[]},

      mode : { type : String, default : 'save' },

      redirectTo : { type : String, default :'' },

      deleteUrl : { type : String, default :'' },

      closeFilter : { type : Function, default : ()=>{} },

      save_endpoint : { type : String, default : '' },

      dashboardWidget : {type : boolean, default : false},

      icon_color : {type : String, default : ''},

      is_default: {type: boolean, default : false},

      updateFilterData : {type: Function, default : ()=>{}}
    },

    data(){

      return{

        loading : false,

        name : this.filterName,

        iconClass: this.icon,

        iconList: [],

        agents: this.initialAgents,

        departments: this.intitialDepartments,

        isDashboardWidget : this.is_default ? false : this.dashboardWidget,

        iconColor : this.icon_color ? this.icon_color : '#00C0EF'
      }
    },

    beforeMount () {

      if(this.mode != 'delete'){ this.getIconList(); }
    },

    methods:{

      isValid() {

        const { errors, isValid } = validateSaveFilterSettings(this.$data);

        return isValid
      },

      saveFilter(type){

        if(this.isValid()){

          this.$store.dispatch('unsetValidationError');

          this.loading = true;

          axios.post(this.save_endpoint, this.getApiParams(type) ).then(res=>{

            this.loading = false;

            successHandler(res, this.$options.name);

            this.$emit('updateFilterData');

            setTimeout(()=>{

              this.toggleFilterPopUp(false);

              this.closeFilter()

            }, 2000)

            window.emitter.emit('updateAgentSidebar');

          }).catch(err=>{

            this.loading = false;

            errorHandler(err,this.$options.name);
          });
        }
      },

      getApiParams(type) {

        const filId = (type == 'create') ? 0 : this.filterId;

        let params = {

          id: filId,

          name: this.name ,

          source : this.source,

          icon_class: this.iconClass.icon_class,

          agents: extractOnlyId(this.agents),

          departments: extractOnlyId(this.departments),

          fields: this.formattedFilterData(),

          is_dashboard_widget : this.isDashboardWidget,

          icon_color : this.iconColor
        }

        return params;
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

      getIconList() {

        axios.get('/json/icon-list.json').then((response) => {

          this.iconList = response.data.data;

        }).catch((error) => {

          this.iconList = [];
        })
      },

      deleteFilter(){

        this.loading = true;

        axios.delete(this.deleteUrl).then(res=>{

          this.loading = false;

          successHandler(res, this.$options.name);

          setTimeout(()=>{

            this.toggleFilterPopUp(false, false);

            this.$router.push(this.redirectTo);
          }, 2000)

          window.emitter.emit('updateAgentSidebar');

        }).catch(err=>{

          this.loading = false;

          errorHandler(err,this.$options.name);
        });
      },

      onClose(){

        this.$store.dispatch('unsetValidationError');

        this.$store.dispatch('unsetAlert');

        this.toggleFilterPopUp(false);
      },

      onChange(value, name){

        this[name] = value
      },

      showSaveAsNew(){
        return this.mode !== 'delete'
      },

      showSave(){
          return this.mode !== 'delete' && this.filterId != 0 && !this.is_default;
      },

      showDelete(){
        return this.mode === 'delete'
      }
    },

    components:{

      'text-field':TextField,

      'dynamic-select': DynamicSelect,

      "tool-tip": ToolTip,

      'color-picker': ColorPicker,
    }
  }
</script>