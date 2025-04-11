<template>

  <div class="col-sm-12" :key="counter">

    <alert componentName="dashboard-page"/>

<!--    <custom-loader :duration="4000" v-if="showLoader" />-->

    <template v-if="editDash">

      <dashboard-edit :closeEditDash="closeEditView"></dashboard-edit>
    </template>

    <template v-else>

      <div class="row mb-3 d-none">

        <div class="col-sm-12">

          <button class="btn bth-default" id="dashboard_refresh" @click="reloadDashboard"><i class="fas fa-sync"></i></button>
        </div>
      </div>

      <div class="row" v-if="hasDataPopulated">

        <div v-if="widgetKeys.includes('ticket-widget')" class="col-md-12">
          <dashboard-top-widgets :top-widget-count="topWidgetCount"></dashboard-top-widgets>
        </div>

        <div v-if="widgetKeys.includes('immediate-action')" class="col-md-6">
          <dashboard-requires-immediate-action></dashboard-requires-immediate-action>
        </div>

        <div v-if="widgetKeys.includes('todo')" class="col-md-6">
          <dashboard-todo></dashboard-todo>
        </div>

	  <div v-if="widgetKeys.includes('agent-summary')" class="col-md-6">
		<dashboard-agent-summary></dashboard-agent-summary>
	  </div>
	  <div v-if="widgetKeys.includes('department-summary')" class="col-md-6">
		<dashboard-department-summary></dashboard-department-summary>
	  </div>

        <div v-if="widgetKeys.includes('recent-activities')" class="col-md-6">
          <dashboard-recent-activities></dashboard-recent-activities>
        </div>
        <div v-if="widgetKeys.includes('agent-performance')" class="col-md-6">
          <dashboard-agent-performance-widget></dashboard-agent-performance-widget>
        </div>

        <div class="col-md-6" v-if="widgetKeys.includes('system-summary')">
          <dashboard-system-analysis></dashboard-system-analysis>
        </div>
      </div>

		<div id="dashboard-chart-container" v-if="widgetKeys.includes('dashboard-charts')"> {{dashboardMounted()}} </div>

      <div v-if="loading" class="row">

      	<reuse-loader :animation-duration="4000" :size="60"/>
	  </div>
	</template>
  </div>
</template>

<script>

import {useStore} from "vuex";

import axios from 'axios';
import {computed} from "vue";
import DasboardTopWidgets from "./DasboardTopWidgets.vue";
import DashboardRecentActivities from "./DashboardRecentActivities.vue";
import DashboardTodo from "./DashboardTodo.vue";
import DashboardSystemAnalysis from "./DashboardSystemAnalysis.vue";
import DashboardRequiresImmediateAction from "./DashboardRequiresImmediateAction.vue";
import AgentsSummary from "./ManagerView/AgentsSummary.vue";
import DepartmentSummary from "./ManagerView/DepartmentSummary.vue";
import DashboardAgentPerformanceWidget from "./DashboardAgentPerformanceWidget.vue";

import {errorHandler, successHandler} from "../../../../helpers/responseHandler";
import DashboardEdit from "./DashboardEdit.vue";

export default {

  name: 'dashboard-page',

	setup() {

		const store = useStore();

		return {

			showLoader : computed(()=>store.getters.showLoader)
		}
	},

  data: () => {
    return {
      /** Array of user roles -- used to decide which widget to show/hide */
      userRoles : [],

      topWidgetCount : 3,

      hasDataPopulated : false,

      loading : false,

      counter : 0,

      widgetKeys : [],

      editDash : false,

      isAdminEnabled : true
    }
  },

  beforeMount() {

    this.getDashData()
  },

  created(){
    window.emitter.on('editDash',(value) => {
      this.editDash = value;
    });
  },

  methods : {

	  dashboardMounted(){

		  window.emitter.emit('dashboard-mounted');
	  },

    closeEditView(reload = false) {

      this.editDash = false;

      window.emitter.emit('edit-dashboard', true);

      if(reload) {

        this.getDashData();
      }
    },

    reloadDashboard() {
      this.counter +=1;
    },

    getDashData() {

      this.loading = true;

      axios.get('/api/agent/dashboard-data/'+this.$route.meta.title).then(res=>{

        this.userRoles = res.data.data.roles;

        this.widgetKeys = res.data.data.widget.map(item => item['key']);

        this.topWidgetCount = res.data.data.count;
        
        this.isAdminEnabled = res.data.data.is_enabled ? true : false;

        window.emitter.emit('isAdminEnabled', this.isAdminEnabled);

        this.hasDataPopulated = true;

        this.loading = false;

      }).catch(err=>{

        this.hasDataPopulated = true;

        this.userRoles = [];

        this.topWidgetCount = 0;

        this.loading = false;

      })
    }
  },

  beforeDestroy() {
    this.$store.dispatch('forceStopLoader');
  },

  components: {
    'dashboard-top-widgets': DasboardTopWidgets,
    'dashboard-recent-activities': DashboardRecentActivities,
    'dashboard-todo': DashboardTodo,
    'dashboard-system-analysis': DashboardSystemAnalysis,
    'dashboard-requires-immediate-action': DashboardRequiresImmediateAction,
    'dashboard-agent-summary': AgentsSummary,
    'dashboard-department-summary': DepartmentSummary,
    'dashboard-agent-performance-widget': DashboardAgentPerformanceWidget,
  	'dashboard-edit': DashboardEdit
  }
};
</script>

<style type="text/css" scoped>
.hidden { visibility: hidden !important;}
</style>
