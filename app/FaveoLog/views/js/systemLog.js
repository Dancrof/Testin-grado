import "../../../../resources/assets/js/bootstrap"

import 'es6-promise/auto';

// NOTE: ADDING ROUTES TO ADMIN PANEL ROUTES

import adminRouter from "../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import LogsIndex from "./components/LogsIndex.vue";

import Entry from "./components/HealthCheck/Entry.vue";

let logsMenu = {

    path: '/system-logs',

    component: AdminPanelLayout,

    name: 'System Logs',

    redirect : '/system-logs/list',

    children : [
        {
            path: 'list',

            component: Entry,

            name: 'LogsIndex',

            meta: { title : 'system-logs', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'system-logs' }}
        }
    ]
}

adminRouter.addRoute(logsMenu);
