import '../../../../resources/assets/js/bootstrap'

import 'es6-promise/auto';

// NOTE: ADDING ROUTES TO ADMIN PANEL ROUTES

import adminRouter from "../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import TemplateSettings from './components/Templates/TemplateSettings.vue';

import TemplateSetList from './components/Templates/TemplateSetList.vue';

import TemplatesList from './components/Templates/TemplatesList.vue';

import TemplateEdit from './components/Templates/TemplateEdit.vue';

import AlertSettings from './components/AlertSettings.vue';

import InAppSettings from './components/InAppSettings.vue';

let NotifyMenu = {

    path: '/notify/manage',

    component: AdminPanelLayout,

    name: 'Notify',

    redirect : '/notify/manage/alerts',

    children : [
        {
            path: 'channels',

            component: TemplateSettings,

            name: 'TemplateSettings',

            meta: { title : 'channels', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'channels'}}
        },
        {
            path: 'channels/:channel/template-sets',

            component: TemplateSetList,

            name: 'TemplateSetList',

            meta: {
                identifier: "template_sets", title : 'template-sets', crumb : { link: { name : 'admin_panel', to : '/' }, parent_link: { name : 'channels', to : '/notify/manage/channels' }, active : ':channel'}
            }
        },
        {
            path: 'channels/:channel/template-sets/:id/templates',

            component: TemplatesList,

            name: 'TemplatesList',

            meta: {
                identifier: "templates", title : 'template-sets', crumb : { link: { name : 'admin_panel', to : '/' }, root_link:{ name : 'channels', to : '/notify/manage/channels' }, parent_link: { name : ':channel', to : '/notify/manage/channels/:channel/template-sets' }, active : 'set :id' }
            }
        },
        {
            path: 'channels/:channel/template-sets/:set/templates/:id',

            component: TemplateEdit,

            name: 'TemplateEdit',

            meta: {
                identifier: "template_edit", title : 'templates', crumb : { link: { name : 'admin_panel', to : '/' }, root_link:{ name : 'channels', to : '/notify/manage/channels' },parent_link: { name : 'set :set', to : '/notify/manage/channels/:channel/template-sets/:set/templates' }, active : 'template :id' }
            }
        },

        {
            path: 'alerts',

            component: AlertSettings,

            name: 'AlertSettings',

            meta: { title : 'alerts-settings', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'alerts-settings' }}
        },
        {
            path: 'in-app',

            component : InAppSettings,

            name : 'InAppSettings',

            meta: { title: 'manage-in-app-logs', crumb:  { link: { name : 'admin_panel', to : '/' }, active : 'manage-in-app-logs'}}
        }
    ]
}

adminRouter.addRoute(NotifyMenu);

/**
 * 10000
 * 
 */
adminRouter.beforeEach((to, from, next) => {
    if(to.meta.identifier !== undefined) {
            let baseCrumbs = {
                template_sets: { link: { name : 'admin_panel', to : '/' }, parent_link: { name : 'channels', to : '/notify/manage/channels' }, active : ':channel'},
                templates: { link: { name : 'admin_panel', to : '/' }, root_link:{ name : 'channels', to : '/notify/manage/channels' }, parent_link: { name : ':channel', to : '/notify/manage/channels/:channel/template-sets' }, active : 'set :id' },
                template_edit: { link: { name : 'admin_panel', to : '/' }, root_link:{ name : 'channels', to : '/notify/manage/channels' },parent_link: { name : 'set :set', to : '/notify/manage/channels/:channel/template-sets/:set/templates' }, active : 'template :id' },
            }
            to.meta.crumb = baseCrumbs[to.meta.identifier]
            Object.keys(to.params).forEach((key)=>{
                replaceDynamicValuesInMeta(':'+key, to.params[key], to.meta)
            })
    }
    next()
});

function replaceDynamicValuesInMeta(search, replace, obj)
{
    Object.keys(obj).forEach((key)=>{
        if(typeof obj[key] == 'string') {
            obj[key]= obj[key].replace(search, replace);
        } else if(typeof obj[key] == 'object'){
            replaceDynamicValuesInMeta(search, replace, obj[key])
        }
    })
}
