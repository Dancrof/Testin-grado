import AdminLayout from '../components/Master/AdminPanelLayout.vue';

import AdminSettings from "../components/Admin/AdminSettings.vue"

import NotFound from '../components/Agent/Views/NotFound/NotFound.vue';

import FormBuilderMain from '../components/Admin/Manage/FormBuilder/FormBuilderMain.vue';

import WidgetsSettings from '../components/Admin/Manage/Widgets/WidgetList.vue';

import TicketSettings from '../components/Admin/Tickets/Settings/TicketSettings.vue';

import CloseTicketWorkflow from '../components/Admin/Tickets/CloseTicketWorkflow/CloseTicketWorkflow.vue';

import CompanySettings from '../components/Admin/Settings/Company/CompanySettings.vue';

import SystemSettings from '../components/Admin/Settings/System/SystemSettings.vue';

import UserOptions from '../components/Admin/Settings/UserOptions/UserOptions.vue';

import LanguagesIndex from '../components/Admin/Settings/Languages/LanguagesIndex.vue';

import CRONSettings from '../components/Admin/Settings/CRON/CRONSettings.vue';

import SecuritySettings from '../components/Admin/Settings/Security/SecuritySettings.vue';

import FileSystemSettings from '../components/Admin/Settings/FileSystem/FileSystemSettings.vue';

import SystemBackupList from '../components/Admin/Settings/SystemBackup/SystemBackupList.vue';

import SocialIcon from '../components/Admin/Manage/SocialWidget/SocialList.vue';

import ApiSettings from '../components/Admin/Settings/Api/ApiSettings.vue';

import WebSocketSettings from '../components/Admin/Settings/WebSocket/WebSocketIndex.vue';

import WebHookSettings from '../components/Admin/Settings/WebHook/WebHookSettings.vue';

import ImportUpload from '../components/Admin/Import/Upload.vue';

import ReCaptchaSettings from '../components/Admin/Settings/ReCaptcha/ReCaptchaSettings.vue';

import LoginLogsSettings from '../components/Admin/Settings/LoginLogs/LoginLogsSettings.vue';

import ClientFilterSettings from '../components/Admin/Settings/ClientFilter/ClientFilterSettings.vue';

import PluginsIndex from '../components/Admin/Plugins/AllPlugins.vue';

import ModulesIndex from '../components/Admin/AddOns/Modules/ModulesIndex.vue';

import ErrorDebug from '../components/Admin/Settings/ErrorLogs/ErrorDebug.vue';

import SystemLevelActivityLog from "../components/Admin/Settings/SystemLevelLogs/SystemLevelActivityLog.vue";

import UpdatesList from '../components/Agent/LayoutComponents/Mini/Updates/UpdatesList.vue';

import CleanDummyData from '../components/Admin/CleanDummyData.vue';

import TriggerAutomator from "../components/Admin/Workflow/AutomatorsList.vue";

// AGENTS CRUD ROUTES===================================================================================================
import AgentsIndex from '../components/Admin/Staff/Agent/AgentList.vue';

import AgentCreateEdit from '../components/Admin/Staff/Agent/CreateUpdateAgent.vue';

let agentsMenu = {

    path: '/agent',

    component: AdminLayout,

    name: 'Agents',

    redirect: '/agent/list',

    children : [

        {

            path: 'list',

            name: 'Agents Index',

            component: AgentsIndex,

            meta: { title : 'agents', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'agents' } }
        },

        {

            path: 'create',

            name: 'Agents Create',

            component: AgentCreateEdit,

            meta: { title : 'agents', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'agents', to : '/agent' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'Agent Edit',

            component: AgentCreateEdit,

            meta: { title : 'agents', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'agents', to : '/agent' }, active : 'edit' } }
        },
    ]
}
// END AGENTS CRUD ROUTES===============================================================================================

// DEPARTMENTS CRUD ROUTES==============================================================================================
import DepartmentsIndex from '../components/Admin/Staff/Department/DepartmentsIndex.vue';

import DepartmentCreateEdit from '../components/Admin/Staff/Department/DepartmentCreateEdit.vue';

import DepartmentView from '../components/Admin/Staff/Department/DepartmentView.vue';

let departmentsMenu = {

    path: '/department',

    component: AdminLayout,

    name: 'Departments',

    redirect: '/department/list',

    children : [

        {

            path: 'list',

            name: 'Departments Index',

            component: DepartmentsIndex,

            meta: { title : 'departments', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'departments' } }
        },

        {

            path: 'create',

            name: 'Department Create',

            component: DepartmentCreateEdit,

            meta: { title : 'departments', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'departments', to : '/department' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'Department Edit',

            component: DepartmentCreateEdit,

            meta: { title : 'departments', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'departments', to : '/department' }, active : 'edit' } }
        },

        {

            path: ':id',

            name: 'Department View',

            component: DepartmentView,

            meta: { title : 'departments', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'departments', to : '/department' }, active : 'view' } }
        },
    ]
}
// END DEPARTMENTS CRUD ROUTES==========================================================================================

// TEAM CRUD ROUTES=====================================================================================================
import TeamsIndex from '../components/Admin/Staff/Team/TeamsIndex.vue';

import TeamCreateEdit from '../components/Admin/Staff/Team/TeamCreateEdit.vue';

import TeamView from '../components/Admin/Staff/Team/TeamView.vue';

let teamsMenu = {

    path: '/team',

    component: AdminLayout,

    name: 'Teams',

    redirect: '/team/list',

    children : [

        {

            path: 'list',

            name: 'Teams Index',

            component: TeamsIndex,

            meta: { title : 'teams', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'team' } }
        },

        {

            path: 'create',

            name: 'Team Create',

            component: TeamCreateEdit,

            meta: { title : 'teams', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'teams', to : '/team' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'Team Edit',

            component: TeamCreateEdit,

            meta: { title : 'teams', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'teams', to : '/team' }, active : 'edit' } }
        },

        {

            path: ':id',

            name: 'Team View',

            component: TeamView,

            meta: { title : 'teams', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'teams', to : '/team' }, active : 'view' } }
        },
    ]
}
// END TEAMS CRUD ROUTES================================================================================================

// EMAILS CRUD ROUTES===================================================================================================
import EmailsIndex from '../components/Admin/Emails/EmailsIndex.vue';

import EmailSettings from '../components/Admin/Emails/EmailSettings.vue';

import EmailDiagnostics from '../components/Admin/Emails/Diagnostics/EmailDiagnostics.vue';

import EmailAuth from '../components/Admin/Emails/EmailAuth/EmailAuth.vue';

import EmailAuthSettings from '../components/Admin/Emails/EmailAuth/EmailAuthSettings.vue';

let emailsMenu = {

    path: '/email',

    component: AdminLayout,

    name: 'Emails',

    redirect: '/email/list',

    children : [

        {

            path: 'list',

            name: 'Emails Index',

            component: EmailsIndex,

            meta: { title : 'emails', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'emails' } }
        },

        {

            path: 'getdiagno',

            name: 'EmailDiagnostics',

            component: EmailDiagnostics,

            meta: { title : 'email_diagnostic', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'email_diagnostic' } }
        },

        {

            path: 'oauth',

            name: 'EmailAuth',

            component: EmailAuth,

            meta: { title : 'oauth_integration', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'oauth_integration' } }
        },
        {

            path: 'oauth/:id',

            name: 'EmailAuthSettings',

            component: EmailAuthSettings,

            meta: { title : 'oauth_integration_settings', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'oauth_integration', to : '/email/oauth' }, active : 'oauth_integration_settings' } }
        },


        {

            path: 'create',

            name: 'Email Create',

            component: EmailSettings,

            meta: { title : 'emails', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'emails', to : '/email' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'Email Edit',

            component: EmailSettings,

            meta: { title : 'emails', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'emails', to : '/email' }, active : 'edit' } }
        }
    ]
}
// END EMAILS CRUD ROUTES===============================================================================================

// BREAK LINES CRUD ROUTES==============================================================================================
import BreakLinesIndex from '../components/Admin/Emails/Breaklines/BreaklineIndex.vue';

import BreakLineCreateEdit from '../components/Admin/Emails/Breaklines/CreateUpdateBreakline.vue';

let breaklinesMenu = {

    path: '/breakline',

    component: AdminLayout,

    name: 'Breaklines',

    redirect: '/breakline/list',

    children : [

        {

            path: 'list',

            name: 'Breaklines Index',

            component: BreakLinesIndex,

            meta: { title : 'breaklines', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'breaklines' } }
        },

        {

            path: 'create',

            name: 'Breakline Create',

            component: BreakLineCreateEdit,

            meta: { title : 'breaklines', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'breaklines', to : '/breakline' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'Breakline Edit',

            component: BreakLineCreateEdit,

            meta: { title : 'breaklines', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'breaklines', to : '/breakline' }, active : 'edit' } }
        }
    ]
}
// END BREAK LINES CRUD ROUTES==========================================================================================

// HELP TOPIC CRUD ROUTES===============================================================================================
import HelpTopicsIndex from '../components/Admin/Manage/HelpTopic/HelpTopicsIndex.vue';

import HelpTopicCreateEdit from '../components/Admin/Manage/HelpTopic/HelpTopicCreateEdit.vue';

let helptopicMenu = {

    path: '/helptopic',

    component: AdminLayout,

    name: 'Helptopic',

    redirect: '/helptopic/list',

    children : [

        {

            path: 'list',

            name: 'Helptopic Index',

            component: HelpTopicsIndex,

            meta: { title : 'help_topics', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'help_topics' } }
        },

        {

            path: 'create',

            name: 'Helptopic Create',

            component: HelpTopicCreateEdit,

            meta: { title : 'help_topics', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'help_topics', to : '/helptopic' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'Helptopic Edit',

            component: HelpTopicCreateEdit,

            meta: { title : 'help_topics', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'help_topics', to : '/helptopic' }, active : 'edit' } }
        }
    ]
}
// END HELP TOPIC CRUD ROUTES===========================================================================================

// SLA CRUD ROUTES======================================================================================================
import SlaIndex from '../components/Admin/Manage/SlaPlans/SlaIndex.vue';

import SlaCreateEdit from '../components/Admin/Manage/SlaPlans/SlaCreateEdit.vue';

let slaMenu = {

    path: '/sla',

    component: AdminLayout,

    name: 'SLA',

    redirect: '/sla/list',

    children : [

        {

            path: 'list',

            name: 'SLA Index',

            component: SlaIndex,

            meta: { title : 'sla-plans', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'sla-plans' } }
        },

        {

            path: 'create',

            name: 'SLA Create',

            component: SlaCreateEdit,

            meta: { title : 'sla-plans', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'sla-plans', to : '/sla' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'SLA Edit',

            component: SlaCreateEdit,

            meta: { title : 'sla-plans', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'sla-plans', to : '/sla' }, active : 'edit' } }
        }
    ]
}
// END SLA CRUD ROUTES==================================================================================================

// BUSINESS HOURS CRUD ROUTES===========================================================================================
import BusinessHoursIndex from '../components/Admin/Manage/BusinessHours/BusinessHoursIndex.vue';

import BusinessHourCreateEdit from '../components/Admin/Manage/BusinessHours/BusinessHours.vue';

let businessHoursMenu = {

    path: '/business-hour',

    component: AdminLayout,

    name: 'BusinessHours',

    redirect: '/business-hour/list',

    children : [

        {

            path: 'list',

            name: 'BusinessHours Index',

            component: BusinessHoursIndex,

            meta: { title : 'business_hours', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'business_hours' } }
        },

        {

            path: 'create',

            name: 'BusinessHour Create',

            component: BusinessHourCreateEdit,

            meta: { title : 'business_hours', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'business_hours', to : '/business-hour' }, active : 'create' } }
        },

        {

            path: ':id/edit',

            name: 'BusinessHour Edit',

            component: BusinessHourCreateEdit,

            meta: { title : 'business_hours', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'business_hours', to : '/business-hour' }, active : 'edit' } }
        }
    ]
}
// END BUSINESS HOURS CRUD ROUTES=======================================================================================

// FORM GROUPS CRUD ROUTES==============================================================================================
import FormGroupList from '../components/Admin/Manage/FormGroups/FormGroupList.vue';

import FormGroupCreateEdit from '../components/Admin/Manage/FormBuilder/FormBuilderMain.vue';

let formGroupsMenu = {

    path: '/form-group',

    component: AdminLayout,

    name: 'FormGroups',

    redirect: '/form-group/list',

    children : [

        {

            path: 'list',

            name: 'FormGroups Index',

            component: FormGroupList,

            meta: { title : 'form-groups', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'form-groups' } }
        },

        {

            path: 'create',

            name: 'FormGroup Create',

            component: FormGroupCreateEdit,

            props : {
                "form-name-obj" : { id: 'name' , className: 'col-md-4', label: 'form_group_name', placeholder: 'name_your_form_group', value: '', submitFormParamKey: 'name' },
                "form-linker" : [{ id: 'departments', className: 'col-md-4', apiEndpoint: '/api/dependency/departments?config=true', label: 'department', value: [], submitFormParamKey: 'department_ids' }, { id: 'help_topics', className: 'col-md-4', apiEndpoint: '/api/dependency/help-topics?config=true', label: 'helptopic', value: [], submitFormParamKey: 'help_topic_ids' }],
                "post-from-group-api" : "api/post-form-group",
                "edit-form-group-api" : "api/get-form-group",
                "form-category-type" : "group"
            },

            meta: { title : 'form-groups', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'form-groups', to : '/form-group' }, active : 'create' }}
        },

        {

            path: 'edit/:id',

            name: 'FormGroup Edit',

            component: FormGroupCreateEdit,

            props : {
                "form-name-obj" : { id: 'name' , className: 'col-md-4', label: 'form_group_name', placeholder: 'name_your_form_group', value: '', submitFormParamKey: 'name' },
                "form-linker" : [{ id: 'departments', className: 'col-md-4', apiEndpoint: '/api/dependency/departments?config=true', label: 'department', value: [], submitFormParamKey: 'department_ids' }, { id: 'help_topics', className: 'col-md-4', apiEndpoint: '/api/dependency/help-topics?config=true', label: 'helptopic', value: [], submitFormParamKey: 'help_topic_ids' }],
                "post-from-group-api" : "api/post-form-group",
                "edit-form-group-api" : "api/get-form-group",
                "form-category-type" : "group"
            },

            meta: { title : 'form-groups', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'form-groups', to : '/form-group' }, active : 'edit' }}
        }
    ]
}
// END FORM GROUPS CRUD ROUTES==========================================================================================

// WORKFLOW CRUD ROUTES=================================================================================================
import WorkflowIndex from '../components/Admin/Workflow/WorkflowIndex.vue';

import WorkflowCreateEdit from '../components/Admin/Automator/FaveoAutomator.vue';

let workFlowMenu = {

    path: '/workflow',

    component: AdminLayout,

    name: 'Workflow',

    redirect: '/automator?type=workflow',

    children: [

        {

            path: 'create',

            name: 'Workflow Create',

            component: WorkflowCreateEdit,

            props : { category : "workflow" },

            meta: { title : 'workflow', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'workflow', to : '/automator?type=workflow' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Workflow Edit',

            component: WorkflowCreateEdit,

            props : { category : "workflow" },

            meta: { title : 'workflow', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'workflow', to : '/automator?type=workflow' }, active : 'edit' }}
        }
    ]
}
// END WORKFLOW CRUD ROUTES=============================================================================================

// APPROVAL WORKFLOW CRUD ROUTES========================================================================================
import ApprovalWorkflowIndex from '../components/Admin/ApprovalWorkflow/ApprovalWorkflowIndex.vue';

import ApprovalWorkflowCreateEdit from '../components/Admin/ApprovalWorkflow/ApprovalWorkflow.vue';

let approvalWorkFlowMenu = {

    path: '/approval-workflow',

    component: AdminLayout,

    name: 'Approval Workflow',

    redirect: '/approval-workflow/list',

    children: [

        {

            path: 'list',

            name: 'Approval Workflow Index',

            component: ApprovalWorkflowIndex,

            meta: { title : 'approval_workflow', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'approval_workflow' }}
        },

        {

            path: 'create',

            name: 'Approval Workflow Create',

            component: ApprovalWorkflowCreateEdit,

            meta: { title : 'approval_workflow', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'approval_workflow', to : '/approval-workflow' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Approval Workflow Edit',

            component: ApprovalWorkflowCreateEdit,

            meta: { title : 'approval_workflow', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'approval_workflow', to : '/approval-workflow' }, active : 'edit' }}
        }
    ]
}
// END APPROVAL WORKFLOW CRUD ROUTES====================================================================================

// PRIORITY CRUD ROUTES=================================================================================================
import PriorityIndex from '../components/Admin/Manage/Priority/PriorityIndex.vue';

import PriorityCreateEdit from '../components/Admin/Manage/Priority/PriorityCreateEdit.vue';

let priorityMenu = {

    path: '/ticket/priority',

    component: AdminLayout,

    name: 'Ticket Priority',

    redirect: '/ticket/priority/list',

    children: [

        {

            path: 'list',

            name: 'Priority Index',

            component: PriorityIndex,

            meta: { title : 'priority', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'priority' }}
        },

        {

            path: 'create',

            name: 'Priority Create',

            component: PriorityCreateEdit,

            meta: { title : 'priority', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'priority', to : '/ticket/priority' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Priority Edit',

            component: PriorityCreateEdit,

            meta: { title : 'priority', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'priority', to : '/ticket/priority' }, active : 'edit' }}
        }
    ]
}
// END PRIORITY CRUD ROUTES=============================================================================================

// TICKET TYPE CRUD ROUTES==============================================================================================
import TicketTypesIndex from '../components/Admin/Manage/TicketType/TicketTypesIndex.vue';

import TicketTypeCreateEdit from '../components/Admin/Manage/TicketType/TicketTypeCreateEdit.vue';

let ticketTypeMenu = {

    path: '/ticket-type',

    component: AdminLayout,

    name: 'Ticket Types',

    redirect: '/ticket-type/list',

    children: [

        {

            path: 'list',

            name: 'Ticket Type Index',

            component: TicketTypesIndex,

            meta: { title : 'ticket_type', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'ticket_type' }}
        },

        {

            path: 'create',

            name: 'Ticket Type Create',

            component: TicketTypeCreateEdit,

            meta: { title : 'ticket_type', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket_type', to : '/ticket-type' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Ticket Type Edit',

            component: TicketTypeCreateEdit,

            meta: { title : 'ticket_type', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket_type', to : '/ticket-type' }, active : 'edit' }}
        }
    ]
}
// END TICKET TYPE CRUD ROUTES==========================================================================================

// LISTENER CRUD ROUTES=================================================================================================
import ListenerIndex from '../components/Admin/Workflow/ListenerIndex.vue';

import ListenerCreateEdit from '../components/Admin/Automator/FaveoAutomator.vue';

let listenerMenu = {

    path: '/listener',

    component: AdminLayout,

    name: 'Listener',

    redirect: '/automator?type=listener',

    children: [

        {

            path: 'create',

            name: 'Listener Create',

            component: ListenerCreateEdit,

            props : { category : "listener" },

            meta: { title : 'listeners', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'listeners', to : '/automator?type=listener' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Listener Edit',

            component: ListenerCreateEdit,

            props : { category : "listener" },

            meta: { title : 'listeners', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'listeners', to : '/automator?type=listener' }, active : 'edit' }}
        }
    ]
}
// END LISTENER CRUD ROUTES=============================================================================================

// STATUS CRUD ROUTES===================================================================================================
import StatusIndex from '../components/Admin/Tickets/Status/StatusIndex.vue';

import StatusCreateEdit from '../components/Admin/Tickets/Status/StatusCreateEdit.vue';

let statusMenu = {

    path: '/status',

    component: AdminLayout,

    name: 'Status',

    redirect: '/status/list',

    children: [

        {

            path: 'list',

            name: 'Status Index',

            component: StatusIndex,

            meta: { title : 'status', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'status' }}
        },

        {

            path: 'create',

            name: 'Status Create',

            component: StatusCreateEdit,

            meta: { title : 'status', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'status', to : '/status' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Status Edit',

            component: StatusCreateEdit,

            meta: { title : 'status', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'status', to : '/status' }, active : 'edit' }}
        }
    ]
}
// END STATUS CRUD ROUTES===============================================================================================

// RATING CRUD ROUTES===================================================================================================
import RatingIndex from '../components/Admin/Settings/Ratings/RatingIndex.vue';

import RatingCreateEdit from '../components/Admin/Settings/Ratings/RatingCreateEdit.vue';

let ratingMenu = {

    path: '/rating',

    component: AdminLayout,

    name: 'Rating',

    redirect: '/rating/list',

    children: [

        {

            path: 'list',

            name: 'Rating Index',

            component: RatingIndex,

            meta: { title : 'ratings_settings', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'ratings_settings' }}
        },

        {

            path: 'create',

            name: 'Rating Create',

            component: RatingCreateEdit,

            meta: { title : 'create_rating', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ratings_settings', to : '/rating' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Rating Edit',

            component: RatingCreateEdit,

            meta: { title : 'edit_rating', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ratings_settings', to : '/rating' }, active : 'edit' }}
        }
    ]
}
// END RATING CRUD ROUTES===============================================================================================

// LABEL CRUD ROUTES====================================================================================================
import LabelsIndex from '../components/Admin/Tickets/Labels/LabelsIndex.vue';

import LabelCreateEdit from '../components/Admin/Tickets/Labels/LabelCreateEdit.vue';

let labelsMenu = {

    path: '/label',

    component: AdminLayout,

    name: 'Labels',

    redirect: '/label/list',

    children: [

        {

            path: 'list',

            name: 'Labels Index',

            component: LabelsIndex,

            meta: { title : 'labels', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'labels' }}
        },

        {

            path: 'create',

            name: 'Label Create',

            component: LabelCreateEdit,

            meta: { title : 'labels', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'labels', to : '/label' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Label Edit',

            component: LabelCreateEdit,

            meta: { title : 'labels', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'labels', to : '/label' }, active : 'edit' }}
        }
    ]
}
// END LABEL CRUD ROUTES================================================================================================

// TAG CRUD ROUTES======================================================================================================
import TagsIndex from '../components/Admin/Tickets/Tags/TagsIndex.vue';

import TagCreateEdit from '../components/Admin/Tickets/Tags/TagCreateEdit.vue';

let tagsMenu = {

    path: '/tag',

    component: AdminLayout,

    name: 'Tags',

    redirect: '/tag/list',

    children: [

        {

            path: 'list',

            name: 'Tags Index',

            component: TagsIndex,

            meta: { title : 'tags', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'tags' }}
        },

        {

            path: 'create',

            name: 'Tag Create',

            component: TagCreateEdit,

            meta: { title : 'tags', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'tags', to : '/tag' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Tag Edit',

            component: TagCreateEdit,

            meta: { title : 'tags', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'tags', to : '/tag' }, active : 'edit' }}
        }
    ]
}
// END TAG CRUD ROUTES==================================================================================================

// SOURCE CRUD ROUTES===================================================================================================
import SourceIndex from '../components/Admin/Tickets/Source/SourceIndex.vue';

import SourceCreateEdit from '../components/Admin/Tickets/Source/SourceCreateEdit.vue';

let sourceMenu = {

    path: '/source',

    component: AdminLayout,

    name: 'Source',

    redirect: '/source/list',

    children: [

        {

            path: 'list',

            name: 'Source Index',

            component: SourceIndex,

            meta: { title : 'source', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'source' }}
        },

        {

            path: 'create',

            name: 'Source Create',

            component: SourceCreateEdit,

            meta: { title : 'source', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'source', to : '/source' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Source Edit',

            component: SourceCreateEdit,

            meta: { title : 'source', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'source', to : '/source' }, active : 'edit' }}
        }
    ]
}
// END SOURCE CRUD ROUTES===============================================================================================

// RECUR CRUD ROUTES====================================================================================================
import RecurringTickets from '../components/Agent/Tools/Recurring/RecurringTicketsIndex.vue';

import RecurCreateEdit from '../components/Common/NewForm/FormGenerator.vue';

let recurMenu = {

    path: '/recur',

    component: AdminLayout,

    name: 'Recurring',

    redirect: '/recur/list',

    children: [

        {

            path: 'list',

            name: 'Recurring Tickets',

            component: RecurringTickets,

            props : { from : 'admin' },

            meta: { title : 'ticket_recurring', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'ticket_recurring' }}
        },

        {

            path: 'create',

            name: 'Recurring Create',

            component: RecurCreateEdit,

            props: { category : 'ticket', panel : 'admin', scenario : 'recur', recur_mode : 'create' },

            meta: { title : 'ticket_recurring', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket_recurring', to : '/recur' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Recurring Edit',

            component: RecurCreateEdit,

            props: { category : 'ticket', panel : 'admin', scenario : 'recur', recur_mode : 'edit' },

            meta: { title : 'ticket_recurring', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket_recurring', to : '/recur' }, active : 'edit' }}
        }
    ]
}
// END RECUR CRUD ROUTES================================================================================================

// TICKET TEMPLATE CRUD ROUTES==========================================================================================
import TicketTemplatesIndex from '../components/Admin/Tickets/Templates/TicketTemplatesIndex.vue';

import TicketTemplateCreateEdit from '../components/Common/NewForm/FormGenerator.vue';

let ticketTemplateMenu = {

    path: '/ticket-template',

    component: AdminLayout,

    name: 'Ticket Templates',

    redirect: '/ticket-template/list',

    children: [

        {

            path: 'list',

            name: 'Ticket Templates Index',

            component: TicketTemplatesIndex,

            meta: { title : 'ticket_template', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'ticket_template' }}
        },

        {

            path: 'create',

            name: 'Ticket Template Create',

            component: TicketTemplateCreateEdit,

            props: { category : 'ticket', panel : 'admin', scenario : 'template', template_mode : 'create' },

            meta: { title : 'ticket_template', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket_template', to : '/ticket-template' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Ticket Template Edit',

            component: TicketTemplateCreateEdit,

            props: { category : 'ticket', panel : 'admin', scenario : 'template', template_mode : 'edit' },

            meta: { title : 'ticket_template', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket_template', to : '/ticket-template' }, active : 'edit' }}
        }
    ]
}
// END TICKET TEMPLATE CRUD ROUTES======================================================================================

// TICKET PDF TEMPLATE CRUD ROUTES======================================================================================
import TicketPDFTemplatesIndex from "../components/Admin/Tickets/PDFTemplates/TicketPDFTemplatesIndex.vue";

import TicketPDFTemplateCreateEdit from '../components/Admin/Tickets/PDFTemplates/TicketPDFTemplateCreateEdit.vue';

let ticketPDFTemplateMenu = {

    path: '/ticket-pdf-template',

    component: AdminLayout,

    name: 'Ticket PDF Templates',

    redirect: '/ticket-pdf-template/list',

    children: [

        {

            path: 'list',

            name: 'Ticket PDF Templates Index',

            component: TicketPDFTemplatesIndex,

            meta: { title : 'ticket_pdf_template', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'ticket_pdf_template' }}
        },

        {

            path: 'create',

            name: 'Ticket PDF Template Create',

            component: TicketPDFTemplateCreateEdit,

            meta: { title : 'ticket_pdf_template', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket_pdf_template', to : '/ticket-pdf-template' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Ticket PDF Template Edit',

            component: TicketPDFTemplateCreateEdit,

            meta: { title : 'ticket_pdf_template', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket_pdf_template', to : '/ticket-pdf-template' }, active : 'edit' }}
        }
    ]
}
// END TICKET PDF TEMPLATE CRUD ROUTES==================================================================================

// SOCIAL LOGIN CRUD ROUTES=============================================================================================
import SocialLoginIndex from '../components/Admin/Settings/SocialLogin/Index.vue';

import SocialLogin from '../components/Admin/Settings/SocialLogin/Settings.vue';

let socialMenu = {

    path: '/social/media',

    component: AdminLayout,

    name: 'Social Login',

    redirect: '/social/media/list',

    children: [

        {

            path: 'list',

            name: 'Social Login Index',

            component: SocialLoginIndex,

            meta: { title : 'social-login', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'social-login' }}
        },

        {

            path: ':provider',

            name: 'Social Login Provider',

            component: SocialLogin,

            meta: { title : 'social-login', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'social-login', to : '/social/media' }, active : 'settings' }}
        }
    ]
}
// END SOCIAL LOGIN CRUD ROUTES=========================================================================================

// QUEUES CRUD ROUTES===================================================================================================
import QueueIndex from '../components/Admin/Emails/Queue/QueueIndex.vue';

import QueueSettings from '../components/Admin/Emails/Queue/QueueSettings.vue';

let queueMenu = {

    path: '/queue',

    component: AdminLayout,

    name: 'Queue',

    redirect: '/queue/list',

    children: [

        {

            path: 'list',

            name: 'Queue Index',

            component: QueueIndex,

            meta: { title : 'queues', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'queues' }}
        },

        {

            path: ':id',

            name: 'Queue Settings',

            component: QueueSettings,

            meta: { title : 'queues', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'queues', to : '/queue' }, active : 'settings' }}
        }
    ]
}
// END QUEUES CRUD ROUTES===============================================================================================

// THIRD PARTY APPS CRUD ROUTES=========================================================================================
import ThirdPartyAppsIndex from '../components/Admin/Manage/ThirdPartyApp/ThirdPartyAppIndex.vue'

import ThirdPartyAppCreateEdit from '../components/Admin/Manage/ThirdPartyApp/ThirdPartyApp.vue'

let thirdPartyAppsMenu = {

    path: '/third-party-app',

    component: AdminLayout,

    name: 'ThirdPartyApps',

    redirect: '/third-party-app/list',

    children: [

        {

            path: 'list',

            name: 'ThirdPartyApps Index',

            component: ThirdPartyAppsIndex,

            meta: { title : 'third_party_apps', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'third_party_apps' }}
        },

        {

            path: 'create',

            name: 'ThirdPartyApp Create',

            component: ThirdPartyAppCreateEdit,

            meta: { title : 'third_party_apps', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'third_party_apps', to : '/third-party-app' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'ThirdPartyApp Edit',

            component: ThirdPartyAppCreateEdit,

            meta: { title : 'third_party_apps', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'third_party_apps', to : '/third-party-app' }, active : 'edit' }}
        }
    ]
}
// END THIRD PARTY APPS CRUD ROUTES=====================================================================================

// SAML CRUD ROUTES=====================================================================================================
import SamlCreateEdit from "../components/Admin/Settings/SAML/SamlCreateEdit.vue";

import SamlIndex from "../components/Admin/Settings/SAML/SamlIndex.vue";

import SamlView from "../components/Admin/Settings/SAML/SamlView.vue";

let SAML={

    path:'/single-sign-on/settings',

    component:AdminLayout,

    name: 'SAML 2.0 Integration',

    redirect: '/single-sign-on/settings/index',

    children:[
        {
            path:'index',

            name: 'SAML index',

            component: SamlIndex,

            meta:{title:'SAML_Integration', crumb :{link:{name:'admin_panel',to:'/'},active:'SAML_Integration'}}
        },

        {
            path: 'add',

            name: 'SAML Add',

            component: SamlCreateEdit,

            meta:{title:'SAML_Integration', crumb :{link:{name:'admin_panel',to:'/'},root_link:{name:'SAML_Integration', to:'/single-sign-on/settings/index'},active:'Add'}}

        },

        {

            path: ':id',

            name: 'SAML View',

            component: SamlView,

            meta: { title : 'SAML_Integration', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'SAML_Integration', to : '/single-sign-on/settings/index' }, active : 'View' } }
        },

        {

            path: ':id/edit',

            name: 'SAML Edit',

            component: SamlCreateEdit,

            meta: { title : 'SAML_Integration', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'SAML_Integration', to : '/single-sign-on/settings/index' }, active : 'edit' } }
        },
    ]
}


//END SAML CRUD ROUTES==================================================================================================

//CACHE DRIVERS ROUTES==================================================================================================
import CacheDriversIndex from "../components/Admin/Settings/CacheDrivers/CacheDriversIndex.vue";

import CacheDriversRedis from "../components/Admin/Settings/CacheDrivers/CacheDriversRedis.vue";

import CacheDriversMemcached from "../components/Admin/Settings/CacheDrivers/CacheDriversMemcached.vue";

import CacheDriversDynamodb from "../components/Admin/Settings/CacheDrivers/CacheDriversDynamodb.vue";

let CacheDriversMenu ={

    path: '/cache-driver',

    component: AdminLayout,

    name: 'Cache Drivers',

    redirect: '/cache-driver/list',

    children:[
        {
            path:'list',

            name:'Cache Driver Index',

            component: CacheDriversIndex,

            meta:{title:'cache-driver', crumb :{link:{name:'admin_panel',to:'/'},active:'cache-driver'}}
        },
        {
            path:'redis',

            name:'Redis Configs',

            component: CacheDriversRedis,

            meta:{title:'cache-driver', crumb :{link:{name:'admin_panel',to:'/'},root_link:{name:'Cache Drivers', to:'/cache-driver/list'},active:'redis_config'}}
        },
        {
            path:'memcached',

            name:'Memcached Config',

            component: CacheDriversMemcached,

            meta:{title:'cache-driver', crumb :{link:{name:'admin_panel',to:'/'},root_link:{name:'Cache Drivers', to:'/cache-driver/list'},active:'Memcached Config'}}
        },
        {
            path:'dynamodb',

            name:'Dynamodb Config',

            component: CacheDriversDynamodb,

            meta:{title:'cache-driver', crumb :{link:{name:'admin_panel',to:'/'},root_link:{name:'Cache Drivers', to:'/cache-driver/list'},active:'Dynamodb Config'}}
        }

    ]


}

//Form Builder Routes

import FormsIndex from "../components/Admin/Manage/FormBuilder/Builder/FormsIndex.vue";

import FormBuilder from "../components/Admin/Manage/FormBuilder/Builder/FormBuilder.vue";

let FormData = {

    path: '/forms',

    component: AdminLayout,

    name: 'forms',

    redirect: '/forms',

    children: [

        {

            path: '',

            name: 'Forms Index',

            component: FormsIndex,

            meta: { title : 'forms', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'forms' }}
        },

        {

            path: ':type/edit',

            name: 'form-builder-ui',

            component: FormBuilder,

            meta: { title : 'forms', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'forms', to : '/forms' }, active : 'edit' }}
        }
    ]
}


import UserImport from "../components/Admin/Import/UserImport.vue";
 import AdminPanelLayout from "../components/Master/AdminPanelLayout.vue";

let userImportMenu = {

    path: '/view/import-tracking-details',

    component: AdminPanelLayout,

    name: 'User Import Progress',

    redirect : '/view/import-tracking-details',

    children : [
        {
            path: ':id',

            component: UserImport,

            name: 'User Import Progress Page',

            props : {
            },

            meta: { title : 'user_import', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'user_import' } }
        },
    ]
}

//END CACHE DRIVERS ROUTES==============================================================================================


// search-drivers CRUD ROUTES===========================================================================================

import DriversIndex from "../components/Admin/Drivers/DriversIndex.vue";

import DriverSettings from "../components/Admin/Drivers/DriverSettings.vue";

let driversSettingsMenu = {

    path: '/search-driver/settings',

    component: AdminLayout,

    name: 'search-drivers',

    redirect: '/search-driver/settings/list',

    children: [

        {

            path: 'list',

            name: 'Drivers Index',

            component: DriversIndex,

            meta: { title : 'search-drivers', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'search-drivers' }}
        },

        {

            path: ':id',

            name: 'Drivers Settings',

            component: DriverSettings,

            meta: { title : 'search-drivers', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'search-drivers', to : '/search-driver/settings/list' }, active : 'settings' }}
        }
    ]
}
// END search-drivers CRUD ROUTES=======================================================================================
//Socket DRIVERS ROUTES==================================================================================================

import SocketDriverRedis from "../components/Admin/Settings/WebSocket/SocketDriversRedis.vue";

import SocketDriversAbly from "../components/Admin/Settings/WebSocket/SocketDriversAbly.vue";

import SocketDriversPusher from "../components/Admin/Settings/WebSocket/SocketDriversPusher.vue";

import SocketDriversReverb from "../components/Admin/Settings/WebSocket/SocketDriversReverb.vue";

let SocketDriversMenu ={

    path: '/websockets',

    component: AdminLayout,

    name: 'Socket Drivers',

    redirect: '/websockets/settings',

    children:[
        {

            path: 'settings',

            name: 'WebSocket Settings',

            component: WebSocketSettings,

            meta: { title : 'websockets', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'websockets' }}
        },
        {
            path:'redis',

            name:'Redis Config',

            component: SocketDriverRedis,

            meta:{title:'websockets', crumb :{link:{name:'admin_panel',to:'/'},root_link:{name:'websockets', to:'/websockets/settings'},active:'redis_config'}}
        },
        {
            path:'ably',

            name:'Ably Config',

            component: SocketDriversAbly,

            meta:{title:'websockets', crumb :{link:{name:'admin_panel',to:'/'},root_link:{name:'websockets', to:'/websockets/settings'},active:'Ably Config'}}
        },
        {
            path:'pusher',

            name:'Pusher Config',

            component: SocketDriversPusher,

            meta:{title:'websockets', crumb :{link:{name:'admin_panel',to:'/'},root_link:{name:'websockets', to:'/websockets/settings'},active:'Pusher Config'}}

        },
        {
            path:'reverb',

            name:'Revern Config',

            component: SocketDriversReverb,

            meta:{title:'websockets', crumb :{link:{name:'admin_panel',to:'/'},root_link:{name:'websockets', to:'/websockets/settings'},active:'Reverb Config'}}

        }

    ]


}
//End Socket DRIVERS ROUTES==================================================================================================

// PERSONAL ACCESS TOKENS CRUD ROUTES=========================================================================================

import TokensIndex from "../components/Admin/DeveloperSettings/PersonalAccessTokens/TokensIndex.vue";

import TokenForm from "../components/Admin/DeveloperSettings/PersonalAccessTokens/TokenForm.vue";

let tokenMenu = {

    path: '/personal-access-token',

    component: AdminLayout,

    name: 'personal_access_token',

    redirect: '/personal-access-token/list',

    children: [

        {

            path: 'list',

            name: 'personal_access_token.index',

            component: TokensIndex,

            meta: { title : 'personal_access_token', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'personal_access_token' }}
        },

        {

            path: 'create',

            name: 'personal_access_token.create',

            component: TokenForm,

            meta: { title : 'personal-access-token', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'personal_access_token', to : '/personal-access-token' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'personal_access_token.edit',

            component: TokenForm,

            meta: { title : 'personal-access-token', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'personal_access_token', to : '/personal-access-token' }, active : 'edit' }}
        }
    ]
}

// Triggers CRUD ROUTES=================================================================================================
import TriggerIndex from "../components/Admin/Workflow/TriggerIndex.vue";

import TriggerCreateEdit from '../components/Admin/Automator/FaveoAutomator.vue';

let triggerMenu = {

    path: '/trigger',

    component: AdminLayout,

    name: 'Trigger',

    redirect: '/trigger/list',

    children: [

        {

            path: 'create',

            name: 'Trigger Create',

            component: TriggerCreateEdit,

            props : { category : "trigger" },

            meta: { title : 'trigger', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'trigger', to : '/automator?type=trigger' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'Trigger Edit',

            component: TriggerCreateEdit,

            props : { category : "trigger" },

            meta: { title : 'trigger', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'trigger', to : '/automator?type=trigger' }, active : 'edit' }}
        }
    ]
}
// END Triggers CRUD ROUTES=============================================================================================


// END PERSONAL ACCESS TOKENS CRUD ROUTES=====================================================================================

//NEW Form Builder Routes

import NewFormsIndex from "../components/Admin/Manage/NewFormBuilder/FormsIndex.vue"
import NewFormBuilder from "../components/Admin/Manage/NewFormBuilder/FormBuilder.vue";
import FormsEntry from "../components/Admin/Manage/NewFormBuilder/FormsEntry.vue";

let newFormMenu = {

    path: '/new/forms',

    component: AdminLayout,

    name: 'new.forms.index',

    redirect: '/new/forms/index',

    children: [

        {
            path: 'index',

            name: 'forms.index',

            component: FormsEntry,

            meta: { title : 'forms_index', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'forms_index' }}
        },

        {
            path: ':type/list',

            name: 'forms.list',

            component: NewFormsIndex,

            meta: { title : 'forms', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'forms_index', to : '/new/forms/index' }, active : 'forms' }}
        },

        {
            path: ':type/:id/edit',

            name: 'forms.builder',

            component: NewFormBuilder,

            beforeEnter: (to, from, next) => {

                const type = to.params.type;

                to.meta.crumb.root_link.to = type === 'ticket' ? `/new/forms/${type}/list` : '/new/forms/index';

                next();
            },

            meta: { title : 'forms', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'forms', to: '' }, active : 'edit' }}
        }
    ]
}

//END NEW FORM BUILDER ROUTES==============================================================================================

// TICKET FIELDS ROUTES

import TicketFieldsIndex from "../components/Admin/Tickets/Fields/TicketFieldsIndex.vue";
import TicketFieldsForm from "../components/Admin/Tickets/Fields/TicketFieldsForm.vue";
import TicketSectionsForm from "../components/Admin/Tickets/Fields/TicketSectionsForm.vue";

let ticketFieldsMenu = {

    path: '/ticket-fields',

    component: AdminLayout,

    name: 'ticket.fields',

    redirect: '/ticket-fields/list',

    children: [

        {

            path: '/ticket-fields/list',

            name: 'ticket.fields.index',

            component: TicketFieldsIndex,

            meta: { title : 'tickets', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'ticket-fields' }}
        },

        {

            path: '/ticket-fields/formFields/create',

            name: 'ticket.fields.create',

            component: TicketFieldsForm,

            meta: { title : 'forms', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket-fields', to : '/ticket-fields' }, active : 'create' }}
        },

        {

            path: '/ticket-fields/edit/formFields/:type/:id',

            name: 'ticket.fields.edit',

            component: TicketFieldsForm,

            meta: { title : 'forms', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket-fields', to : '/ticket-fields' }, active : 'edit' }}
        },

        {

            path: '/ticket-fields/sections/create',

            name: 'ticket.sections.create',

            component: TicketSectionsForm,

            meta: { title : 'forms', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket-fields', to : '/ticket-fields' }, active : 'create' }}
        },

        {

            path: '/ticket-fields/edit/sections/:type/:id',

            name: 'ticket.sections.edit',

            component: TicketSectionsForm,

            meta: { title : 'forms', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'ticket-fields', to : '/ticket-fields' }, active : 'edit' }}
        }
    ]
}
// TICKET FIELDS ROUTES ==============================================================================================

// OAuth 2.0 CRUD ROUTES=========================================================================================

import OauthIndex from "../components/Admin/DeveloperSettings/OAuth2.0/OauthIndex.vue";

import OauthForm from "../components/Admin/DeveloperSettings/OAuth2.0/OauthForm.vue";

import OauthFormEdit from "../components/Admin/DeveloperSettings/OAuth2.0/OauthFormEdit.vue";
import WebHookList from "../components/Admin/Settings/WebHook/WebHookList.vue";
import WebHookCreateEdit from "../components/Admin/Settings/WebHook/WebHookCreateEdit.vue";
import WebHookLogs from "../components/Admin/Settings/WebHook/WebHookLogs.vue";
import IframeIndex from "../components/Admin/DeveloperSettings/IframeConfigure/IframeIndex.vue";
import IframeCreateEdit from "../components/Admin/DeveloperSettings/IframeConfigure/IframeCreateEdit.vue";
import IframeParameterSettings from "../components/Admin/DeveloperSettings/IframeConfigure/IframeParameterSettings.vue";

let oauthMenu = {

    path: '/oauth',

    component: AdminLayout,

    name: 'oauth_2_0',

    redirect: '/oauth/list',

    children: [

        {

            path: 'list',

            name: 'oauth.index',

            component: OauthIndex,

            meta: { title : 'oauth_2_0', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'oauth_2_0' }}
        },

        {

            path: 'create',

            name: 'oauth.create',

            component: OauthForm,

            meta: { title : 'oauth-client', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'oauth_2_0', to : '/oauth/list' }, active : 'create' }}
        },

        {

            path: ':id/edit',

            name: 'oauth.edit',

            component: OauthFormEdit,

            meta: { title : 'oauth-client', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'oauth_2_0', to : '/oauth/list' }, active : 'edit' }}
        },
    ]
}

// END OAuth 2.0 CRUD ROUTES=====================================================================================

let routes = [

    {

        path: '/',

        component: AdminLayout,

        redirect: '/home',

        name: 'Admin Layout',

        children: [

            {

                path: 'home',

                name: 'Admin Index',

                component: AdminSettings,

                meta: { title : 'admin_panel', crumb : { active : 'admin_panel' } }
            },

            {

                path: 'dashboard',

                name: 'Admin Dashboard',

                component: AdminSettings,

                redirect : 'home',

                meta: { title : 'admin_panel', crumb : { active : 'admin_panel' } }
            },

            {

                path: 'admin',

                name: 'Admin Index Page',

                component: AdminSettings,

                redirect : 'home',

                meta: { title : 'admin_panel', crumb : { active : 'admin_panel' } }
            },

            {

                path: 'widgets',

                name: 'Widgets',

                component: WidgetsSettings,

                meta: { title : 'widgets', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'widgets' }}
            },

            {

                path: '/getticket',

                name: 'TicketSettings',

                component: TicketSettings,

                meta: { title : 'ticket_settings', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'ticket_settings' }}
            },

            {

                path: '/close-workflow',

                name: 'Close Ticket Workflow',

                component: CloseTicketWorkflow,

                meta: { title : 'close_ticket_workflow', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'close_ticket_workflow' }}
            },

            {

                path: '/getcompany',

                name: 'CompanySettings',

                component: CompanySettings,

                meta: { title : 'company', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'company' }}
            },

            {

                path: '/getsystem',

                name: 'SystemSettings',

                component: SystemSettings,

                meta: { title : 'system', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'system' }}
            },

            {

                path: '/user-options',

                name: 'UserOptions',

                component: UserOptions,

                meta: { title : 'user-options', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'user-options' }}
            },

            {

                path: '/languages',

                name: 'Languages',

                component: LanguagesIndex,

                meta: { title : 'language', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'language' }}
            },

            {

                path: '/job-scheduler',

                name: 'CRONSettings',

                component: CRONSettings,

                meta: { title : 'cron', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'cron' }}
            },

            {

                path: '/security',

                name: 'SecuritySettings',

                component: SecuritySettings,

                meta: { title : 'security', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'security' }}
            },

            {

                path: '/file-system-settings',

                name: 'FileSystem',

                component: FileSystemSettings,

                meta: { title : 'settings_file_system', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'settings_file_system' }}
            },

            {

                path: '/system-backup',

                name: 'SystemBackup',

                component: SystemBackupList,

                meta: { title : 'system-backup', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'system-backup' }}
            },

            {

                path: 'social-icon',

                name: 'Widgets Social Icon',

                component: SocialIcon,

                meta: { title : 'social-icon-links', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'social-icon-links' }}
            },

            {

                path: 'settings-api',

                name: 'API Settings',

                component: ApiSettings,

                meta: { title : 'api', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'api' }}
            },

            {

                path: 'iframe-injection',

                name: 'Iframe',

                redirect: '/iframe-injection/list',

                children: [
                    {
                        path: 'list',

                        name: 'Iframe Configuration',

                        component: IframeIndex,

                        meta : { title : 'iframe-configuration', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'iframe-configuration' } }
                    },
                    {
                        path: 'create',

                        name: 'Add Iframe Configuration',

                        component: IframeCreateEdit,

                        meta: { title : 'create_iframe_configuration', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'iframe-configuration', to : '/iframe-injection' }, active : 'create' } }
                    },
                    {
                        path: ':id/edit',

                        name: 'Edit Iframe Configuration',

                        component: IframeCreateEdit,

                        meta: { title : 'edit_iframe_configuration', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'iframe-configuration', to : '/iframe-injection' }, active : 'edit' } }
                    },
                    {
                        path: ':id/settings',

                        name: 'Iframe Parameter Settings',

                        component: IframeParameterSettings,

                        meta: { title : 'iframe_parameter_settings', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'iframe-configuration', to : '/iframe-injection' }, active : 'iframe_parameter_settings' } }
                    },

                ],
            },

            {

                path: 'webhook',

                name: 'Webhook',

                redirect: '/webhook/list',

                children: [
                    {
                        path: 'list',

                        name: 'Webhook List',

                        component: WebHookList,

                        meta : { title : 'webhooks', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'webhooks' } }
                    },
                    {
                        path: 'add',

                        name: 'Add Webhook',

                        component: WebHookCreateEdit,

                        meta: { title : 'webhooks', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'webhooks', to : '/webhook' }, active : 'add' } }
                    },
                    {
                        path: ':id/edit',

                        name: 'Edit Webhook',

                        component: WebHookCreateEdit,

                        meta: { title : 'webhooks', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'webhooks', to : '/webhook' }, active : 'edit' } }
                    },
                    {
                        path: ':id/logs',

                        name: 'Webhook Logs',

                        component: WebHookLogs,

                        meta: { title : 'webhooks', crumb : { link: { name : 'admin_panel', to : '/' }, root_link: { name : 'webhooks', to : '/webhook' }, active : 'logs' } }
                    }

                ],
            },

            {

                path: 'importer',

                name: 'Import Upload',

                component: ImportUpload,

                meta: { title : 'importer_user_import', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'importer_user_import' }}
            },

            {

                path: 'recaptcha',

                name: 'Recaptcha',

                component: ReCaptchaSettings,

                meta: { title : 'recaptcha', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'recaptcha' }}
            },

            {

                path: 'login-log-setting',

                name: 'LoginLogs',

                component: LoginLogsSettings,

                meta: { title : 'login-log-setting', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'login-log-setting' }}
            },

            {

                path: 'client/ticket-filter',

                name: 'ClientFilter',

                component: ClientFilterSettings,

                meta: { title : 'client-filter', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'client-filter' }}
            },

            {

                path: 'plugins',

                name: 'Plugins',

                component: PluginsIndex,

                meta: { title : 'plugins', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'plugins' }}
            },

            {

                path: 'modules',

                name: 'Modules',

                component: ModulesIndex,

                meta: { title : 'modules', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'modules' }}
            },

            {

                path: 'error-and-debugging-options',

                name: 'ErrorDebug',

                component: ErrorDebug,

                meta: { title : 'error-debug-settings', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'error-debug-settings' }}
            },

            {

                path: 'system-level-activity-logs',

                name: 'System Level Activity Logs',

                component: SystemLevelActivityLog,

                meta: { title : 'system-level-activity-logs', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'system-level-activity-logs' }}

            },

            {

                path: 'check-updates',

                name: 'System Updates',

                component: UpdatesList,

                meta: { title : 'application_updates', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'application_updates' }}
            },

            {

                path: 'clean-dummy-data',

                name: 'DummyData',

                component: CleanDummyData,

                meta: { title : 'delete_dummy_data', crumb : { link: { name : 'admin_panel', to : '/' }, active : 'delete_dummy_data' }}
            },

            {
                path: 'automator',

                name: 'TriggerAutomator',

                component: TriggerAutomator,

                meta: {title: 'automator', crumb: { link: {name:'admin_panel', to:'/'}, active: 'automator'}}
            }
        ]
    },

    agentsMenu,

    departmentsMenu,

    teamsMenu,

    emailsMenu,

    breaklinesMenu,

    helptopicMenu,

    slaMenu,

    businessHoursMenu,

    formGroupsMenu,

    workFlowMenu,

    approvalWorkFlowMenu,

    priorityMenu,

    ticketTypeMenu,

    listenerMenu,

    statusMenu,

    labelsMenu,

    tagsMenu,

    sourceMenu,

    recurMenu,

    socialMenu,

    queueMenu,

    thirdPartyAppsMenu,

    ratingMenu,

    ticketTemplateMenu,

    ticketPDFTemplateMenu,

    SAML,

    userImportMenu,

    CacheDriversMenu,

    FormData,

    driversSettingsMenu,

    SocketDriversMenu,

    tokenMenu,

    oauthMenu,
    triggerMenu,

    newFormMenu,

    ticketFieldsMenu,

    {
        path: '/:pathMatch(.*)*',
        name:"404",
        component: NotFound
    }
];

export default routes;