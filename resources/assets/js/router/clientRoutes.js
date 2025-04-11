import store from '../../store'

import ClientLayout from '../../js/components/Client/ClientPanelLayout.vue';

import  NotFound from '../../js/components/Client/Pages/NotFound/404.vue'

import NotFoundComponent from '../../js/components/Client/Pages/NotFound/NotFoundComponent.vue'

import ServerError from '../../js/components/Client/Pages/NotFound/500.vue'

import Home from '../../js/components/Client/Pages/Index.vue';

import Login from '../../js/components/Client/Pages/Auth/LoginPage.vue';

import ForgotPassword from '../../js/components/Client/Pages/Auth/ForgotPassword.vue';

import PasswordReset from '../../js/components/Client/Pages/Auth/PasswordReset.vue';

import EmailActivation from '../../js/components/Client/Pages/EmailActivation.vue';

import EmailVerify from '../../js/components/Client/Pages/EmailVerify.vue';

import UserProfile from '../../js/components/Client/Pages/UserProfile.vue';

import Knowledgebase from '../../js/components/Client/Pages/Kb/Knowledgebase.vue';

import ArticleList from '../../js/components/Client/Pages/Kb/KbArticlesList.vue';

import CategoryList from '../../js/components/Client/Pages/Kb/KbCategoryList.vue';

import kbPages from '../../js/components/Client/Pages/Kb/KbPages.vue';

import TagsById from '../../js/components/Client/Pages/Kb/KbTagDetails.vue';

import ArticleById from '../../js/components/Client/Pages/Kb/KbArticleDetails.vue';

import CategoryById from '../../js/components/Client/Pages/Kb/KbCategoryDetails.vue';

import SearchResult from '../../js/components/Client/Pages/Kb/KbSearchResult.vue';

import MyTickets from '../../js/components/Client/Pages/Tickets/MyTicketsIndex.vue';

import CheckTicket from '../../js/components/Client/Pages/Tickets/ClientTicketTimeline.vue';

import ShowTicket from '../../js/components/Client/Pages/Tickets/ShowTicket.vue';

import Organization from '../../js/components/Client/Pages/Tickets/Organization.vue';

import CreateUser from '../../js/components/Client/Pages/Tickets/OrganizationMembersCreate.vue';

import EditUser from '../../js/components/Client/Pages/Tickets/OrganizationMembersCreate.vue';

import Register from '../../js/components/Client/Pages/Auth/Register.vue';

import ClientPanelCreateTicket from '../../js/components/Client/Pages/Tickets/ClientPanelCreateTicket.vue';

import TicketForm from "../components/Client/Pages/Tickets/TicketForm.vue";

import ApprovalTicketConversation from '../../js/components/Client/Pages/ApprovalTicketConversation/ApprovalTicketConversation.vue';

import TicketConversation from '../../js/components/Client/Pages/Tickets/TicketConversation.vue';

import TicketRating from '../../js/components/Client/Pages/TicketRating/TicketRating.vue';

import Verify2FA from '../../js/components/Client/Pages/Auth/Verify2FA.vue';

/***********************************
 * Billing
 */

import OrderInfo from '../../js/components/Client/Billing/OrderInfo.vue';

import PackageList from '../../js/components/Client/Billing/PackageList.vue';

import UserInvoice from '../../js/components/Client/Billing/UserInvoice.vue';

import UserPackage from '../../js/components/Client/Billing/UserPackage.vue';

import PackageView from '../../js/components/Client/Billing/PackageView.vue';

import CheckoutPage from '../../js/components/Client/Billing/CheckoutPage.vue';

import InvoiceView from '../../js/components/Client/Billing/InvoiceView.vue';
import LinkExpired from "../components/Client/Pages/NotFound/LinkExpired.vue";

import OAuthLogInPage from "../components/Client/Pages/OAuth/OAuthLogInPage.vue";

import OAuthForgotPasswordPage from "../components/Client/Pages/OAuth/OAuthForgotPasswordPage.vue";

import OAuthVerify2FA from "../components/Client/Pages/OAuth/OAuthVerify2FA.vue";

import OAuthEmailVerify from "../components/Client/Pages/OAuth/OAuthEmailVerify.vue";

import OAuthLayout from "../components/Client/Pages/OAuth/OAuthLayout.vue";

import SecretMessage from "../components/Client/Pages/Tickets/MiniComponents/SecretMessage.vue";

import verificationCompleted from "../../../../app/Plugins/SMS/views/js/components/Client/VerificationCompleted.vue";

let routes = [

    {
        path: '/',

        component: ClientLayout,

        redirect: '/home',

        name: 'Client Layout',

        children:[

            {
                path: 'home',
                component: Home,
                name: 'Home',
                meta: { breadcrumb: [{text:'home'}]}
            },

            {
                path: 'client/home',
                component: Home,
                name: 'Home Page',
                redirect: 'home',
                meta: { breadcrumb: [{text:'home'}]}
            },

            {
                path: 'auth/login/',
                component: Login,
                name: 'Login',
                meta: { breadcrumb: [{to:'/',text:'home'},{to:'/auth/register',text:'create_account'},{text:'login'}] }
            },

            {
                path: 'social/login/:provider',
                component: Login,
                name: 'SocialCallback',
                meta: { breadcrumb: [{to:'/',text:'home'},{to:'/auth/register',text:'create_account'},{text:'login'}] }
            },

            {
                path: 'auth/register', component: Register, name: 'Register',
                meta: { breadcrumb: [{ to: '/', text: 'home' }, { text: 'register' }] }
            },

            {
                path: 'create-ticket', component: TicketForm, name: 'TicketForm',
                props: { category : 'ticket', panel : 'client' },
                beforeEnter: requireAuth,
                meta: { breadcrumb: [{ to: '/', text: 'home' }, { text: 'submit_a_ticket' }] }
            },

            {
                path: 'password/email',
                component: ForgotPassword,
                name: 'ForgotPassword',
                meta: { breadcrumb: [{text:'forgot_password'}]}
            },

            {
                path: 'reset/password/:id',
                component: PasswordReset,
                name: 'PasswordReset',
                meta: {
                    breadcrumb: [{text:'reset_password'}]
                }
            },

            {
                path: 'client-profile',
                component: UserProfile,
                name: 'UserProfile',
                beforeEnter: requireAuth,
                meta: {
                    breadcrumb: [{text:'my_profile'}],
                }
            },

            {
                path: 'knowledgebase',
                component: Knowledgebase,
                name: 'Knowledgebase',
                meta: { breadcrumb: [{text:'knowledge_base'}]}
            },

            {
                path: 'category-list',
                component: CategoryList,
                name: 'CategoryList',
                meta: {
                    breadcrumb: [{to:'/knowledgebase',text:'knowledge_base'},{text:'Category List'}]
                }
            },

            {
                path: 'article-list',
                component: ArticleList,
                name: 'ArticleList',
                meta: {
                    breadcrumb: [{to:'/knowledgebase',text:'knowledge_base'},{text:'Article List'}]
                }
            },

            {
                path: 'show/:slug',
                component: ArticleById,
                name: 'Articles',
                meta: {
                    page : 'article',
                    breadcrumb: [{text:'knowledge_base',to:'/knowledgebase'}, {text:'Article List',to:'/article-list'}]
                }
            },

            {
                path: 'category-list/:slug',
                component: CategoryById,
                name: 'Category',
                meta: {
                    view : 'category',
                    breadcrumb: [{text:'knowledge_base', to:'/knowledgebase'}, {text:'Category List',to:'/category-list'}]
                }
            },

            {
                path: 'kb-tag-articles/:tag_id',
                component: TagsById,
                name: 'Tags',
                meta: {
                    breadcrumb: [{text:'knowledge_base', to:'/knowledgebase'}, {text:'Tag'}]
                }
            },

            {
                path: 'organization/:org_id',
                component: Organization,
                name : 'Organizations',
                beforeEnter: requireAuth,
                props:true,
                meta: {
                    breadcrumb:  [{to:'/',text:'home'},{text:'Organization'}],
                }
            },

            {
                path: 'create/user',
                component: CreateUser,
                name : 'Create User',
                beforeEnter: requireAuth,
                props:true,
                meta: {
                    breadcrumb: [{to:'/',text:'home'},{text:'create_user'}],
                }
            },

            {
                path: 'edit/user/:id',
                component: EditUser,
                name : 'EditUser',
                beforeEnter: requireAuth,
                props:true,
                meta: {
                    breadcrumb: [{to:'/',text:'home'},{text:'edit_user'}],
                }
            },

            {
                path: 'pages/:slug',
                component: kbPages,
                name : 'Pages',
                props:true,
                meta: {
                    breadcrumb: [{to:'/knowledgebase',text:'knowledge_base'},{text:'Pages'}]
                }
            },

            {
                path: 'mytickets/:ticketTabData?',
                component: MyTickets,
                name: 'MyTickets',
                beforeEnter: requireAuth,
                props: true,
                meta: {
                    breadcrumb: [{text:'my_tickets'}],
                }
            },

            {
                path: 'check-ticket/:id',
                component: CheckTicket,
                name: 'CheckTicket',
                beforeEnter: requireAuth,
                meta: {
                    breadcrumb: [{to:'/mytickets',text:'myticket'},{text:'check_ticket'}],
                }
            },

            {
                path: 'show-ticket/:hash',
                component: ShowTicket,
                name: 'ShowTicket',
                meta: {
                    breadcrumb: [{text:'show_ticket'}],
                }
            },

            {
                path: 'search',
                component: SearchResult,
                name: 'SearchResult',
                meta: {
                    breadcrumb: [{to:'/',text:'home'},{text:'Search Results'}]
                }
            },

            {
                path: 'ticket-conversation/:id',
                component: ApprovalTicketConversation,
                name: 'ApprovalTicketConversation',
                meta: {
                    breadcrumb: [{to:'/',text:'home'},{text:'Approval Ticket Conversation'}]
                }
            },

            {
                path: 'ticket-conversation-guest/:id',
                component: TicketConversation,
                name: 'TicketConversation',
                meta: {
                    breadcrumb: [{to:'/',text:'home'},{text:'Ticket Conversation'}]
                }
            },

            {
                path: 'rating/:id',
                component: TicketRating,
                name: 'TicketRating',
                meta: {
                    breadcrumb: [{to:'/',text:'home'},{text:'Ticket Rating'}]
                }
            },


            {
                path: 'verify-email',
                name:"EmailVerify",
                component: EmailVerify,
                props:true,
                meta: {
                    breadcrumb: [{text: 'email_verify_lang_key'}]
                }
            },
            {
                path: 'client-secret/show/:id',
                name:"SecretMessage",
                component: SecretMessage,
                beforeEnter: requireAuth,
                props:true,
                meta: {
                    breadcrumb: [{text: 'secret_content'}]
                }
            },

            {
                path: 'verify-2fa/:pp/:remember',
                name:"Verify2FA",
                component: Verify2FA,
                props:true,
                meta: {
                    breadcrumb: [{text:'Two Factor Verification'}]
                }
            },

            {
                path: 'server-error',
                name:"ServerError",
                component: ServerError,
                meta: {breadcrumb: [{text:'500'}]}
            },

            {
                path: 'not-found',
                name:"NotFound",
                component: NotFoundComponent,
                props : true,
                meta: {breadcrumb: [{text:'404'}]}
            },

            {
                path: '404',
                name:"404",
                component: NotFound,
                props : true,
                meta: {breadcrumb: [{text:'404'}]}
            },

            {
                path : 'link-expired',
                name:'LinkExpired',
                component: LinkExpired,
                props: true,
                meta: {breadcrumb: [{text:'Link Expired'}]}
            },

            {
                path: 'account/activation/:id',
                name:"EmailActivation",
                component: EmailActivation,
                props:true,
                meta: {breadcrumb: [{text:'Email Activation'}]}
            },

            // For client bilinng module

            {
                path: 'billing-user-packages',
                component: UserPackage,
                beforeEnter: requireAuth,
                name: 'MyPackaage',
                meta: { breadcrumb: [{to:'/', text:'home'},{text:'my_packages'}]}
            },

            {
                path: 'billing-user-invoices',
                component: UserInvoice,
                beforeEnter: requireAuth,
                name: 'UserInvoice',
                meta: { breadcrumb: [{to:'/', text:'home'},{text:'my_invoices'}]}
            },

            {
                path: 'billing-order-info/:id',
                component: OrderInfo,
                beforeEnter: requireAuth,
                name: 'OrderInfo',
                meta: { breadcrumb: [{to:'/', text:'home'},{text:'order_info'}]}
            },

            {
                path: 'billing-package-list',
                component: PackageList,
                name: 'PackageList',
                meta: { breadcrumb: [{to:'/', text:'home'},{text:'packages'}] }
            },

            {
                path: 'package/:id',
                component: PackageView,
                beforeEnter: requireAuth,
                name: 'PackageView',
                meta: { breadcrumb: [{to:'/',text:'home'}, {text:'package'}]}
            },

            {
                path: 'checkout/:id',
                component: CheckoutPage,
                beforeEnter: requireAuth,
                name: 'CheckoutPage', props: true,
                meta: { breadcrumb: [{to:'/',text:'home'}, {text:'checkout'}]}
            },

            {
                path: 'invoice/:id',
                component: InvoiceView,
                beforeEnter: requireAuth,
                name: 'InvoiceView',
                meta: { breadcrumb: [{to:'/',text:'home'}, {text:'invoice'}]}
            },
        ]
    },

    {
        path: '/verification-completed',

        component: ClientLayout,

        name: 'VerificationCompletedMain',

        redirect : '/verification-completed',

        children : [
            {
                path: '',

                component: verificationCompleted,

                name: 'VerificationCompleted',

                meta: { breadcrumb: [ { text : 'Verification Completed' } ] }
            },
        ],
    },

    {
        path: '/:pathMatch(.*)*',
        component: NotFound,
        name: 'NotFound Layout'
    },

    {
        path:'/oauth',
        component: OAuthLayout,
        redirect: '/oauth/login',
        name: 'OAuthLayout',

        children: [
            {
                path: '/oauth/login',
                component: OAuthLogInPage,
                name: 'OAuthLogInPage',
            },

            {
                path: '/oauth/for-pass',
                component: OAuthForgotPasswordPage,
                name: 'OAuthForgotPasswordPage'
            },

            {
                path: '/oauth/verify-2fa/:pp/:remember',
                component: OAuthVerify2FA,
                name: 'OAuthVerify2FA',
                props:true,
            },

            {
                path: '/oauth/verify-email',
                name:"OAuthEmailVerify",
                component: OAuthEmailVerify,
                props:true,
            }
        ]
    }

];
/*
    This will check to see if the user is authenticated or not.
*/
function requireAuth (to, from, next) {
    if (to.path.includes('/auth/auth')) {
        const correctedPath = to.path.replace('/auth/auth', '/auth');
        next(correctedPath + '/login');
    } else if (!Array.isArray(store.getters.getUserData.user_data)) {
        next();
    } else if (store.getters.getCreateTicketStatus === 1)
    {
        next();
    }
    else if(Array.isArray(store.getters.getUserData.user_data || store.getters.getCreateTicketStatus === 0)) {
        next('/auth/login');
    }
}

export default routes