import AgentLayout from "../components/Agent/AgentPanelLayout.vue";

import Dashboard from '../components/Agent/Views/Dashboard/DashboardPage.vue';

import NotFound from "../components/Agent/Views/NotFound/NotFound.vue";

import AgentProfile from '../components/Agent/Views/Profile/AgentProfile.vue';

// import FaveoForm from '../components/Common/Form/FormGenerator.vue';
import FaveoForm from "../components/Common/NewForm/FormGenerator.vue";

import TicketsIndex from '../components/Agent/Inbox/InboxLayout.vue';

import TicketTimeline from '../components/Agent/Inbox/View/TicketTimeline.vue';

import UserDirectory from '../components/Agent/User/UserDirectory.vue';

import UserExport from '../components/Agent/User/UserExport.vue';

import UserView from '../components/Agent/User/UserView.vue';

import AgentEdit from '../components/Admin/Staff/Agent/CreateUpdateAgent.vue';

import OrganizationDirectory from '../components/Agent/Organization/OrganizationDirectory.vue';

import OrganizationView from '../components/Agent/Organization/OrganizationView.vue';

import CannedResponse from '../components/Agent/Tools/Canned/CannedResponse.vue';

import CannedCreateEdit from '../components/Agent/Tools/Canned/CannedCreateEdit.vue';

import KBArticleIndex from '../components/Agent/kb/article/index.vue';

import KBArticleCreateEdit from '../components/Agent/kb/article/Create/Article.vue';

import KBArticleRevision from '../components/Agent/kb/article/Create/KBArticleRevision.vue';

import KBArticleComments from '../components/Agent/kb/comment/comments.vue';

import KBArticleTemplate from '../components/Agent/kb/article/ArticleTemplate/ArticleTemplate.vue';

import KBArticleTemplateIndex from '../components/Agent/kb/article/ArticleTemplate/ArticleTemplateIndex.vue';

import KBSettings from '../components/Agent/kb/settings/kbSettings.vue';

import KBCategoryIndex from '../components/Agent/kb/Category/CategoryIndex.vue';

import KBCategoryCreateEdit from '../components/Agent/kb/Category/Category.vue';

import KBPageIndex from '../components/Agent/kb/Pages/PagesIndex.vue';

import KBPageCreateEdit from '../components/Agent/kb/Pages/Pages.vue';

import RecurringTickets from '../components/Agent/Tools/Recurring/RecurringTicketsIndex.vue';

import SearchResults from "../components/Agent/Search/SearchResults.vue";

import CreateEditSchedule from "../../../../app/FaveoReport/views/js/components/Common/CreateEditSchedule.vue";

let kbCannedMenu = {

    path: '/canned',

    component: AgentLayout,

    name: 'CannedResponse',

    redirect: '/canned/list',

    children : [

        {

            path: 'list',

            name: 'Canned Response Index',

            component: CannedResponse,

            meta: { title : 'canned_response', crumb : { link: { name : 'dashboard', to : '/' }, active : 'canned_response' } }
        },

        {

            path: 'create',

            name: 'Canned Response Create',

            component: CannedCreateEdit,

            meta: { title : 'canned_response', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'canned_response', to : '/canned' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'Canned Response Edit',

            component: CannedCreateEdit,

            meta: { title : 'canned_response', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'canned_response', to : '/canned' }, active : 'edit' } }
        },
    ]
}

let kbCategoryMenu = {

    path: '/category',

    component: AgentLayout,

    name: 'Category',

    redirect: '/category/list',

    children : [

        {

            path: 'list',

            name: 'KB Category Index',

            component: KBCategoryIndex,

            meta: { title : 'category', crumb : { link: { name : 'dashboard', to : '/' }, active : 'category' } }
        },

        {

            path: 'create',

            name: 'KB Category Create',

            component: KBCategoryCreateEdit,

            meta: { title : 'category', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'category', to : '/category' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'KB Category Edit',

            component: KBCategoryCreateEdit,

            meta: { title : 'category', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'category', to : '/category' }, active : 'edit' } }
        },
    ]
}

let kbArticlesMenu = {

    path: '/article',

    component: AgentLayout,

    name: 'Knowledgebase',

    redirect: '/article/list',

    children: [

        {

            path: 'list',

            name: 'KB Article',

            component: KBArticleIndex,

            meta: { title : 'article', crumb : { link: { name : 'dashboard', to : '/' }, active : 'article' } }
        },

        {

            path: 'create',

            name: 'KB Article Create',

            component: KBArticleCreateEdit,

            meta: { title : 'article', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'article', to : '/article' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'KB Article Edit',

            component: KBArticleCreateEdit,

            meta: { title : 'article', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'article', to : '/article' }, active : 'edit' } }
        },

        {

            path: 'revision/:articleId/:versionId',

            name: 'KB Article Revision',

            component: KBArticleRevision,

            meta: { title : 'article', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'article', to : '/article' }, active : 'revisions' } }
        },

        {

            path: 'comment',

            name: 'KB Article Comments',

            component: KBArticleComments,

            props: true,

            meta: { title : 'comments', crumb : { link: { name : 'dashboard', to : '/' }, active : 'comments' } }
        },

        {

            path: 'create/template',

            name: 'KB Article Template Create',

            component: KBArticleTemplate,

            meta: { title : 'article_template', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'article_template', to : '/article/alltemplate/list' }, active : 'create' } }
        },

        {

            path: 'template/:id/edit',

            name: 'KB Article Template Edit',

            component: KBArticleTemplate,

            meta: { title : 'article_template', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'article_template', to : '/article/alltemplate/list' }, active : 'edit' } }
        },

        {

            path: 'alltemplate/list',

            name: 'KB Article Template List',

            component: KBArticleTemplateIndex,

            meta: { title : 'article_template', crumb : { link: { name : 'dashboard', to : '/' }, active : 'article_template' } }
        },
    ]
}

let kbPagesMenu = {

    path: '/page',

    component: AgentLayout,

    name: 'KB Page',

    redirect: '/page/list',

    children : [

        {

            path: 'list',

            name: 'KB Pages Index',

            component: KBPageIndex,

            meta: { title : 'pages', crumb : { link: { name : 'dashboard', to : '/' }, active : 'pages' } }
        },

        {

            path: 'create',

            name: 'KB Page Create',

            component: KBPageCreateEdit,

            meta: { title : 'pages', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'pages', to : '/page' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'KB Page Edit',

            component: KBPageCreateEdit,

            meta: { title : 'pages', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'pages', to : '/page' }, active : 'edit' } }
        },
    ]
}

let kbSettingsMenu = {

    path: '/kb',

    component: AgentLayout,

    name: 'Knowledgebase Settings',

    redirect: '/kb/settings',

    children: [

        {

            path: 'settings',

            name: 'KB Settings',

            component: KBSettings,

            meta: { title : 'kb-settings', crumb : { link: { name : 'dashboard', to : '/' }, active : 'settings' } }
        }
    ]
}

let usersMenu = {

    path: '/user',

    component: AgentLayout,

    name: 'Users',

    redirect: '/user/list',

    children: [

        {

            path: 'list',

            name: 'User Directory',

            component: UserDirectory,

            meta: { title : 'user_directory', crumb : { link: { name : 'dashboard', to : '/' }, active : 'user_directory' } }
        },

        {

            path: 'create',

            name: 'User Create',

            component: FaveoForm,

            props: { category : 'requester', panel : 'agent' },

            meta: { title : 'user', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'user_directory', to : '/user' }, active : 'create' } }
        },

        {

            path: 'export',

            name: 'User Export',

            component: UserExport,

            meta: { title : 'export_user', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'user_directory', to : '/user' }, active : 'export_user' } }
        },

        {

            path: ':id',

            name: 'User View',

            component: UserView,

            meta: { title : 'profile', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'user_directory', to : '/user' }, active : 'viewing_as_user_profile' } }
        },

        {

            path: ':id/edit',

            name: 'User Edit',

            component: FaveoForm,

            props: { category : 'requester', panel : 'agent', showViewButton : true },

            meta: { title : 'user', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'user_directory', to : '/user' }, active : 'edit' } }
        },
    ]
}

let organizationMenu = {

    path: '/organizations',

    component: AgentLayout,

    name: 'Organizations',

    redirect: '/organizations/list',

    children: [

        {

            path: 'list',

            name: 'Organization Directory',

            component: OrganizationDirectory,

            meta: { title : 'organization_directory', crumb : { link: { name : 'dashboard', to : '/' }, active : 'organization_directory' } }
        },

        {

            path: 'create',

            name: 'Organization Create',

            component: FaveoForm,

            props: { category : 'organisation', panel : 'agent' },

            meta: { title : 'organisation', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'organization_directory', to : '/organizations' }, active : 'create' } }
        },

        {

            path: ':id',

            name: 'Organization View',

            component: OrganizationView,

            meta: { title : 'organization_profile', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'organization_directory', to : '/organizations' }, active : 'organization_profile' } }
        },

        {

            path: ':id/edit',

            name: 'Organizations Edit',

            component: FaveoForm,

            props: { category : 'organisation', panel : 'agent', showViewButton : true },

            meta: { title : 'organisation', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'organization_directory', to : '/organizations' }, active : 'edit' } }
        },
    ]
}

let scheduleReport ={

    path: '/reports/schedule/',

    component: AgentLayout,

    name: 'Schedule',

    redirect: 'add/:type/:id',

    children:[

        {
            path: 'add/:type/:id',

            name: 'Schedule Add',

            component: CreateEditSchedule,

            meta:{title:'Schedule', crumb:{link:{name:'dashboard', to:'/'}, active:'create'}}
        },

        {
            path: ':type/:id/edit/:id',

            name: 'Schedule Edit',

            component: CreateEditSchedule,

            meta:{title:'Schedule', crumb:{link:{name:'dashboard', to:'/'},active:'edit'}}
        }
    ]
}

let routes = [

    {

        path: '/',

        component: AgentLayout,

        redirect: '/dashboard',

        name: 'Dashboard Layout',

        children: [

            {

                path: 'dashboard',

                name: 'Dashboard',

                component: Dashboard,

                meta: { title : 'dashboard', crumb : { active : 'dashboard' } }
            },

            {

                path: 'agent/recur/list',

                name: 'Recurring Tickets',

                component: RecurringTickets,

                meta: { title : 'recurring', crumb : { link: { name : 'dashboard', to : '/' }, active : 'ticket_recurring' } }
            },

            {

                path: 'agent/ticket/recur',

                name: 'Recurring Tickets Create',

                component: FaveoForm,

                props: { category : 'ticket', panel : 'agent', scenario : 'recur', recur_mode : 'create' },

                meta: { title : 'ticket_recurring', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'ticket_recurring', to : '/agent/recur/list' }, active : 'create' } }
            },

            {

                path: 'agent/recur/:id/edit',

                name: 'Recurring Tickets Edit',

                component: FaveoForm,

                props: { category : 'ticket', panel : 'agent', scenario : 'recur', recur_mode : 'edit' },

                meta: { title : 'ticket_recurring', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'ticket_recurring', to : '/agent/recur/list' }, active : 'edit' } }
            },

            {

                path: 'profile',

                name: 'Profile',

                component: AgentProfile,

                meta: { title : 'view-profile', crumb : { link: { name : 'dashboard', to : '/' }, active : 'my_profile' } }
            },

            {
                path: 'newticket',

                name: 'NewTicket',

                component: FaveoForm,

                props: { category : 'ticket', panel : 'agent' },

                meta: { title : 'tickets', crumb : { link: { name : 'dashboard', to : '/' }, root : 'tickets', active : 'create_ticket' } }
            },

            {

                path: 'tickets',

                name: 'Tickets Index',

                component: TicketsIndex,

                meta: { title : '', crumb : { link: { name : 'dashboard', to : '/' }, root : 'tickets' } }
            },

            {

                path: 'tickets/:type/:id',

                name: 'Tickets widget Index',

                component: TicketsIndex,

                props : { from : 'filter' },

                meta: { title : 'from_report', crumb : { link: { name : 'dashboard', to : '/' }, active:'from_report' } }
            },

            {

                path: 'thread/:id',

                name: 'Tickets Timeline',

                component: TicketTimeline,

                props : { from : 'timeline' },

                meta: { title : 'ticket-details', crumb : { link: { name : 'dashboard', to : '/' }, root : 'tickets' } }
            },

            {

                path: 'tickets/filter/:id',

                name: 'Filter Tickets Index',

                component: TicketsIndex,

                props : { from : 'filter' },

                meta: { title : 'filter', crumb : { link: { name : 'dashboard', to : '/' }, root : 'tickets' } }
            },

            {

                path: 'agent/:id',

                name: 'Agent View',

                component: UserView,

                meta: { title : 'profile', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'user_directory', to : '/user' }, active : 'viewing_as_agent_profile' } }
            },

            {

                path: 'agent/:id/edit',

                name: 'Agent Edit',

                component: AgentEdit,

                props: { isCalledFromUserDirectoryPage : true },

                meta: { title : 'user', crumb : { link: { name : 'dashboard', to : '/' }, root_link: { name : 'user_directory', to : '/user' }, active : 'edit' } }
            },

            {

                path: 'search-results',

                name: 'Search Results',

                component: SearchResults,

                meta: { title : 'search', crumb : { active : 'search' } }
            },

        ]
    },

    usersMenu,

    organizationMenu,

    kbCannedMenu,

    kbArticlesMenu,

    kbSettingsMenu,

    kbCategoryMenu,

    kbPagesMenu,

    scheduleReport,

    {
        path: '/:pathMatch(.*)*',
        name:"404",
        component: NotFound
    }
];

export default routes;
