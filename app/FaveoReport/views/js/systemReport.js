import "../../../../resources/assets/js/bootstrap"

import '../css/reportCommon.css';

import 'es6-promise/auto';

import agentRouter from "../../../../resources/assets/js/router/agentRouter";

import AgentPanelLayout from "../../../../resources/assets/js/components/Agent/AgentPanelLayout.vue";

import ReportHomePage from "./components/ReportHomePage.vue";

import ReportEntryPage from "./components/ReportEntryPage.vue";

import ReportDownload from "../../../../resources/assets/js/components/Agent/Report/Exports.vue";

import ReportSettings from "./components/ReportSettings.vue";

import AllScheduleList from "./components/Common/AllScheduleList.vue";

import SDReport from "../../../Plugins/ServiceDesk/views/js/components/Report/SDReports.vue"

let reportAgentRoutes = [
      {
            path: '/reports',

            component: AgentPanelLayout,

            name: 'Helpdesk Reports',

            redirect : '/reports/get',

            children : [
            	{

            		path: 'get',

                    component: ReportHomePage,

                    name: 'Reports Index',

                    meta: { title : 'reports', crumb : { active : 'reports' } }
                },

                {

                    path: ':type',

                    component: ReportHomePage,

                    name: 'Reports Index Individual',

                    meta: { title : 'reports', crumb : { active : 'reports' } }
                },

            	{

            		path: ':type/:id',

                    component: ReportEntryPage,

                    name: 'Reports Entry',

                    meta: { title : 'from_report', crumb : { link: { name : 'reports', to : '/reports/get' }, active : 'from_report' } }
                },

                {
                    path: ':type/:module/:id',

                    component: SDReports,

                    name: 'SD Reports',

                    meta: {title : 'from_report', crumb: {link:{name: 'reports', to: '/reports/get'}, active: 'from_report'}},

                    props: true
                },

                {

                    path: 'activity-download',

                    component: ReportDownload,

                    name: 'Reports Download',

                    meta: { title : 'activity-download', crumb : { active : 'activity-download' } }
                },

                {

                    path: 'settings',

                    component: ReportSettings,

                    name: 'Reports Settings',

                    meta: { title : 'report-settings', crumb : { active : 'report-settings' } }
                },

                {
                    path: 'schedules',

                    component: AllScheduleList,

                    name:'AllScheduleList',

                    meta: {title: 'schedule_list', crumb : {active: 'schedule_list'}}
                }
            ]
      }
];

reportAgentRoutes.forEach(function(route){
    agentRouter.addRoute(route);
});

import adminRouter from "../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import DailyReportSettings from "./components/Admin/DailyReportSettings.vue";
import SDReports from "../../../Plugins/ServiceDesk/views/js/components/Report/SDReports.vue";

let reportAdminRoutes = [
    {
        path: '/daily-report',

        component: AdminPanelLayout,

        name: 'Daily Report Settings',

        redirect : '/daily-report/settings',

        children : [

            {

                path: 'settings',

                component: DailyReportSettings,

                name: 'DailyReport Settings',

                meta: { title : 'daily_reports', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'daily_reports' } }
            },
        ]
    }
];

reportAdminRoutes.forEach(function(route){
    adminRouter.addRoute(route);
});
