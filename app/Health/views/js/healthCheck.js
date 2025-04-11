import "../../../../resources/assets/js/bootstrap"

import {injectComponentIntoView} from "../../../../resources/assets/js/bootstrap";

import 'es6-promise/auto';

import store from "../../../../resources/assets/store";

import HealthMonitor from "./components/HealthMonitor.vue";

injectComponentIntoView('health-monitor', HealthMonitor,"layout-loaded",'monitoring-system-status');

// NOTE: ADDING ROUTES TO ADMIN PANEL ROUTES

import adminRouter from "../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import SystemHealth from "./components/SystemHealth.vue";

import HealthAlerts from "./components/HealthAlerts.vue";

import HealthPHPInfo from "./components/HealthPHPInfo.vue";

let healthMenu = {

    path: '/health-check',

    component: AdminPanelLayout,

    name: 'Health',

    redirect: '/health-check/settings',

    children: [

        {

            path: 'settings',

            name: 'Health Check Settings',

            component: SystemHealth,

            meta: { title : 'health-check', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'health-check' }}
        },

        {

            path: 'alerts',

            name: 'Health Check Alerts',

            component: HealthAlerts,

            meta: { title : 'health-check-alerts', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'health-check-alerts' }}
        },

        {

            path: 'php-info',

            name: 'Health Check PHP Info',

            component: HealthPHPInfo,

            meta: { title : 'health-check', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'health-check', to : '/health-check/settings' }, active : 'php-info' } }

        }
    ]
}

adminRouter.addRoute(healthMenu);

store.dispatch('deleteUser');

store.dispatch('updateUser');
