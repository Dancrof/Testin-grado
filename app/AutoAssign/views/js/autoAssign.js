import "../../../../resources/assets/js/bootstrap"

import 'es6-promise/auto';

import store from "../../../../resources/assets/store";

// NOTE: ADDING ROUTES TO ADMIN PANEL ROUTES

import adminRouter from "../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import AutoAssign from './components/AutoAssign.vue';

let autoAssignMenu = {

    path: '/auto-assign',

    component: AdminPanelLayout,

    name: 'Auto Assign Setting',

    redirect : '/auto-assign/settings',

    children : [
        {
            path: 'settings',

            component: AutoAssign,

            name: 'AutoAssign Settings',

            meta: { title : 'auto_assign', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'auto_assign' }}
        }
    ]
}

adminRouter.addRoute(autoAssignMenu);

store.dispatch('deleteUser');

store.dispatch('updateUser');
