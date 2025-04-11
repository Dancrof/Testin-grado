import "../../../../../resources/assets/js/bootstrap"

import 'es6-promise/auto';

import store from "../../../../../resources/assets/store";

// NOTE: ADDING ROUTES TO ADMIN PANEL ROUTES

import adminRouter from "../../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import TimeTrackSettings from "./components/TimeTrackSettings.vue";

import WorktimeTypeIndex from "./components/WorktimeTypeIndex.vue";

import WorktimeTypeCreateEdit from "./components/WorktimeTypeCreateEdit.vue";

let timeTrackMenu = {

    path: '/time-track',

    component: AdminPanelLayout,

    name: 'TimeTrack',

    redirect : '/time-track/settings',

    children : [
        {
            path: 'settings',

            component: TimeTrackSettings,

            name: 'TimeTrack Settings',

            meta: { title : 'time-track', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'time-track' }}
        },

        {
            path: 'worktime-type',

            component: WorktimeTypeIndex,

            name: 'WorktimeType Index',

            meta: { title : 'worktime_type', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'worktime_type' }}
        },

        {
            path: 'worktime-type/create',

            component: WorktimeTypeCreateEdit,

            name: 'WorktimeType Create',

            meta: { title : 'worktime_type', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'worktime_type', to : '/time-track/worktime-type' }, active : 'create' }}
        },

        {
            path: 'worktime-type/:id/edit',

            component: WorktimeTypeCreateEdit,

            name: 'WorktimeType Edit',

            meta: { title : 'worktime_type', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'worktime_type', to : '/time-track/worktime-type' }, active : 'edit' }}
        }
    ]
}

adminRouter.addRoute(timeTrackMenu);

store.dispatch('deleteUser');

store.dispatch('updateUser');
