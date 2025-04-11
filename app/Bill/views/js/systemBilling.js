import "../../../../resources/assets/js/bootstrap"

import {injectComponentIntoView} from "../../../../resources/assets/js/bootstrap";

import 'es6-promise/auto';

import store from "../../../../resources/assets/store";

import agentRouter from "../../../../resources/assets/js/router/agentRouter";

import AgentPanelLayout from "../../../../resources/assets/js/components/Agent/AgentPanelLayout.vue";

import PackageInvoice from "./components/Package/Agent/PackageInvoice.vue";

import BillingInvoice from "./components/Billing/Invoices.vue";

import OrderDetails from "./components/Package/Agent/OrderDetails.vue";

let billAgentRoutes = [
    {

        path: '/bill',

        component: AgentPanelLayout,

        name: 'Packages',

        redirect : '/bill/package/:id/user-invoice',

        children : [

            {

                path: 'package/:id/user-invoice',

                component: PackageInvoice,

                name: 'Package Invoice',

                meta : { title : 'user_invoice', crumb : { active : 'user_invoice'}}
            },

            {

                path: 'order/:id/',

                component: OrderDetails,

                name: 'Order Details',

                meta : { title : 'order_details', crumb : { active : 'order_details'}}
            }
        ]
    },

    {

        path: '/billing',

        component: AgentPanelLayout,

        name: 'Invoices',

        redirect : '/billing/invoices',

        children : [

            {

                path: 'invoices',

                component: BillingInvoice,

                name: 'Billing Invoice',

                meta : { title : 'invoices', crumb : { active : 'invoices'}}
            }
        ]
    }
];

billAgentRoutes.forEach(function (route) {
    agentRouter.addRoute(route);
});

import BillingPackages from "./components/Package/Agent/BillingPackages.vue";

import PendingInvoices from "./components/Billing/PendingInvoices.vue";

injectComponentIntoView('billing-packages', BillingPackages,'user-page-mounted','user-page-table');

injectComponentIntoView('billing-packages', BillingPackages,'org-page-mounted','org-page-div');

injectComponentIntoView('pending-invoices', PendingInvoices,'navbar-mounted','nav-id');

// NOTE: ADDING ROUTES TO ADMIN PANEL ROUTES

import adminRouter from "../../../../resources/assets/js/router/adminRouter";

import AdminPanelLayout from "../../../../resources/assets/js/components/Master/AdminPanelLayout.vue";

import BillOptions from "./components/Billing/BillOptions.vue";

import PaymentIndex from "./components/Payment/PaymentIndex.vue";

let billingMenu = {

    path: '/billing',

    component: AdminPanelLayout,

    name: 'Billing',

    redirect : '/billing/settings',

    children : [
        {
            path: 'settings',

            component: BillOptions,

            name: 'BillOptions',

            meta: { title : 'bill', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'bill' }}
        },

        {
            path: 'payment-gateways',

            component: PaymentIndex,

            name: 'PaymentIndex',

            meta: { title : 'payment_gateway', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'payment_gateway' }}
        }
    ]
}

import PackageIndex from "./components/Package/PackageIndex.vue";

import PackageCreateEdit from './components/Package/Package.vue';

let billPackagesMenu = {

    path: '/billing/package',

    component: AdminPanelLayout,

    name: 'Billing Packages',

    redirect : '/billing/package/list',

    children : [
        {
            path: 'list',

            component: PackageIndex,

            name: 'Packages Index',

            meta: { title : 'packages', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'packages' }}
        },

        {
            path: 'create',

            component: PackageCreateEdit,

            name: 'Package Create',

            meta: { title : 'packages', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'packages', to : '/billing/package' }, active : 'packages' }}
        },

        {
            path: ':id/edit',

            component: PackageCreateEdit,

            name: 'Package Edit',

            meta: { title : 'packages', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'packages', to : '/billing/package' }, active : 'packages' }}
        }
    ]
}

let billAdminRoutes = [billingMenu, billPackagesMenu]
billAdminRoutes.forEach(function (route) {
    adminRouter.addRoute(route);
});

store.dispatch('deleteUser');
store.dispatch('updateUser');
