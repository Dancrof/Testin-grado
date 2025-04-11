import "../../../../resources/assets/js/bootstrap"

import 'es6-promise/auto';

import store from "../../../../resources/assets/store";

// NOTE: ADDING ROUTES TO ADMIN PANEL ROUTES

import adminRouter from "../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import LocationsIndex from "./components/LocationsIndex.vue";

import LocationCreateEdit from "./components/LocationCreateEdit.vue";

let locationMenu = {

    path: '/location',

    component: AdminPanelLayout,

    name: 'Locations',

    redirect: '/location/list',

    children: [

        {

            path: 'list',

            name: 'Location Index',

            component: LocationsIndex,

            meta: { title : 'location', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'location' }}
        },

        {

            path: 'create',

            name: 'Location Create',

            component: LocationCreateEdit,

            meta: { title : 'location', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'location', to : '/location' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Location Edit',

            component: LocationCreateEdit,

            meta: { title : 'location', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'location', to : '/location' }, active : 'edit' }}
        }
    ]
}

adminRouter.addRoute(locationMenu);

store.dispatch('deleteUser');

store.dispatch('updateUser');
