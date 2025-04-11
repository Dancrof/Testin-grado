import "../../../../resources/assets/js/bootstrap"

import store from "../../../../resources/assets/store";

// NOTE: ADDING ROUTES TO ADMIN PANEL ROUTES

import adminRouter from "../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import DashboardOptimize from "./components/DashboardOptimize.vue";

let optimizeMenu = {

    path: '/optimize',

    component: AdminPanelLayout,

    name: 'Dashboard Optimize',

    redirect : '/optimize/dashboard',

    children : [
        {
            path: 'dashboard',

            component: DashboardOptimize,

            name: 'DashboardOptimize',

            meta: { title : 'optimize', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'optimize' }}
        }
    ]
}

adminRouter.addRoute(optimizeMenu);
