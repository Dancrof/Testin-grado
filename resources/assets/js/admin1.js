import Vue from 'vue';

require('./bootstrap');

var moment = require('moment');

import 'es6-promise/auto';

import { store } from 'store';

import faveoAutomator from './../store/modules/faveoAutomator';
import formBuilderStore from './../store/modules/formBuilderStore';
store.registerModule('faveoAutomator', faveoAutomator);
store.registerModule('formBuilderStore', formBuilderStore);

import { lang } from 'helpers/extraLogics'

import CKEditor from '@ckeditor/ckeditor5-vue';

Vue.use(CKEditor);

Vue.use(require('vddl'));

import VTooltip from 'v-tooltip'

Vue.use(VTooltip, {
  defaultBoundariesElement: 'window',
});

// Vue.component('form-group-list', require('components/Admin/Manage/FormGroups/FormGroupList.vue'));

// Vue.component('form-builder-main', require('./components/Admin/Manage/FormBuilder/FormBuilderMain.vue'));

// Vue.component('faveo-automator', require('./components/Admin/Automator/FaveoAutomator.vue'));

// Vue.component('faveo-form', require('./components/Common/Form/FormGenerator.vue'));
//
// Vue.component('form-renderer', require('./components/Common/Form/FormRenderer'));

// Vue.component('email-settings', require('./components/Admin/Emails/EmailSettings.vue'));

// for time track settings component
Vue.component('timetrack-settings', require('./components/Admin/TimeTrack/TimeTrackSettings.vue'));

// for business hours create
// Vue.component('business-hours', require('./components/Admin/Manage/BusinessHours/BusinessHours.vue'));

// for business hours table
// Vue.component('business-hours-index', require('./components/Admin/Manage/BusinessHours/BusinessHoursIndex.vue'));

// for approval workflow component
// Vue.component('approval-workflow-index', require('./components/Admin/ApprovalWorkflow/ApprovalWorkflowIndex.vue'));

// for workflow component
// Vue.component('workflow-index', require('./components/Admin/Workflow/WorkflowIndex.vue'));

// for listener component
// Vue.component('listener-index', require('./components/Admin/Workflow/ListenerIndex.vue'));
//
// Vue.component('approval-workflow', require('./components/Admin/ApprovalWorkflow/ApprovalWorkflow.vue'));

// registering agent-list component
// Vue.component('agent-list', require('./components/Admin/Staff/Agent/AgentList.vue'));

// registering create-update-agent component
// Vue.component('create-update-agent', require('./components/Admin/Staff/Agent/CreateUpdateAgent.vue'));

//Company settings page
// Vue.component('company-settings', require('./components/Admin/Settings/Company/CompanySettings.vue'));

// System backup component
// Vue.component('system-backup-list', require('./components/Admin/Settings/SystemBackup/SystemBackupList.vue'));

// Vue.component('draggable-form-field-item', require('./components/Admin/Manage/FormBuilder/DraggableFormFieldItem.vue'));

// Vue.component('sla-index', require('./components/Admin/Manage/SlaPlans/SlaIndex.vue'));
//
// Vue.component('sla-create-edit', require('./components/Admin/Manage/SlaPlans/SlaCreateEdit.vue'));

// Vue.component('plugins-page', require('./components/Admin/Plugins/PluginsPage.vue'));

// Vue.component('import-upload', require('./components/Admin/Import/Upload.vue'));

// Vue.component('widget-list', require('./components/Admin/Manage/Widgets/WidgetList.vue'));

// Vue.component('social-widget-list', require('./components/Admin/Manage/SocialWidget/SocialList.vue'));

// Vue.component('recaptcha-settings', require('./components/Admin/Settings/ReCaptcha/ReCaptchaSettings.vue'));

// Vue.component('web-socket-settings', require('./components/Admin/Settings/WebSocket/WebSocketIndex.vue'));

// Vue.component('close-ticket-workflow', require('./components/Admin/Tickets/CloseTicketWorkflow/CloseTicketWorkflow.vue'));

//TICKET SETTINGS
// Vue.component('ticket-settings', require('./components/Admin/Tickets/Settings/TicketSettings.vue'))

//Emails
// Vue.component('emails-index', require('./components/Admin/Emails/EmailsIndex.vue'));

// Vue.component('email-diagnostics', require('./components/Admin/Emails/Diagnostics/EmailDiagnostics.vue'));

// Vue.component('form-renderer', require('./components/Common/Form/FormRenderer'))

// Vue.component('web-socket-settings', require('./components/Admin/Settings/WebSocket/WebSocketIndex.vue'))
// Vue.component('labels-index', require('./components/Admin/Tickets/Labels/LabelsIndex.vue'));
//
// Vue.component('label-create-edit', require('./components/Admin/Tickets/Labels/LabelCreateEdit.vue'));

//LABELS

// Vue.component('third-party-app', require('./components/Admin/Manage/ThirdPartyApp/ThirdPartyApp.vue'));
//
// Vue.component('third-party-app-index', require('./components/Admin/Manage/ThirdPartyApp/ThirdPartyAppIndex.vue'));


// Vue.component('file-system-settings', require('./components/Admin/Settings/FileSystem/FileSystemSettings'));

//User Options
// Vue.component('user-options', require('./components/Admin/Settings/UserOptions/UserOptions.vue'));
// Vue.component('tags-index', require('./components/Admin/Tickets/Tags/TagsIndex.vue'));
//
// Vue.component('tag-create-edit', require('./components/Admin/Tickets/Tags/TagCreateEdit.vue'));

// Vue.component('api-settings', require('./components/Admin/Settings/Api/ApiSettings.vue'));

// Vue.component('web-hook-settings', require('./components/Admin/Settings/WebHook/WebHookSettings.vue'));

//Source
// Vue.component('source-index', require('./components/Admin/Tickets/Source/SourceIndex.vue'));
//
// Vue.component('source-create-edit', require('./components/Admin/Tickets/Source/SourceCreateEdit.vue'));
//System settings page
// Vue.component('system-settings', require('./components/Admin/Settings/System/SystemSettings.vue'));
//Ticket Priority
// Vue.component('priority-index', require('./components/Admin/Manage/Priority/PriorityIndex.vue'));
//
// Vue.component('priority-create-edit', require('./components/Admin/Manage/Priority/PriorityCreateEdit.vue'));

// Vue.component('updates-list', require('./components/HeaderNavigation/Updates/UpdatesList.vue'));

//SOCIAL LOGIN 

// Vue.component('social-login-index', require('./components/Admin/Settings/SocialLogin/Index.vue'))
//
// Vue.component('social-login-external', require('./components/Admin/Settings/SocialLogin/External.vue'));
//
// Vue.component('social-login-settings', require('./components/Admin/Settings/SocialLogin/Settings.vue'));

// Vue.component('languages-index', require('./components/Admin/Settings/Languages/LanguagesIndex.vue'));

//CRON settings page
// Vue.component('cron-settings', require('./components/Admin/Settings/CRON/CRONSettings.vue'));
// Vue.component('ticket-type-index', require('./components/Admin/Manage/TicketType/TicketTypesIndex.vue'));
//
// Vue.component('ticket-type-create-edit', require('./components/Admin/Manage/TicketType/TicketTypeCreateEdit.vue'));

// Vue.component('queue-index', require('./components/Admin/Emails/Queue/QueueIndex.vue'));

//Error and Debugging page
// Vue.component('error-debug', require('./components/Admin/Settings/ErrorLogs/ErrorDebug.vue'));

// DEPARTMENTS
// Vue.component('departments-list', require('components/Admin/Staff/Department/DepartmentsIndex.vue'));
//
// Vue.component('department-create-edit', require('components/Admin/Staff/Department/DepartmentCreateEdit.vue'));
//
// Vue.component('department-view', require('components/Admin/Staff/Department/DepartmentView.vue'));

// Vue.component('modules-index',require('./components/Admin/AddOns/Modules/ModulesIndex.vue'));
// Vue.component('queue-settings', require('./components/Admin/Emails/Queue/QueueSettings.vue'));

// Vue.component('login-log-settings', require('./components/Admin/Settings/LoginLogs/LoginLogsSettings.vue'));

//System settings page
// Vue.component('system-settings', require('./components/Admin/Settings/System/SystemSettings.vue'));

//HelpTopics
// Vue.component('help-topics-index',require('./components/Admin/Manage/HelpTopic/HelpTopicsIndex'));
//
// Vue.component('help-topic-create-edit',require('./components/Admin/Manage/HelpTopic/HelpTopicCreateEdit'));


//Security settings page
// Vue.component('security-settings', require('./components/Admin/Settings/Security/SecuritySettings.vue'));

//Admin Index page
// Vue.component('admin-settings', require('./components/Admin/AdminSettings.vue'));
//TICKET SETTINGS
// Vue.component('status-index', require('components/Admin/Tickets/Status/StatusIndex.vue'));
//
// Vue.component('status-create-edit', require('components/Admin/Tickets/Status/StatusCreateEdit.vue'));

// Vue.component('breakline-index', require('./components/Admin/Emails/Breaklines/BreaklineIndex.vue'));
//
// Vue.component('create-upate-breakline', require('./components/Admin/Emails/Breaklines/CreateUpdateBreakline.vue'));

// Vue.component('client-filter-settings', require('./components/Admin/Settings/ClientFilter/ClientFilterSettings.vue'))

//TEAMS
// Vue.component('teams-index', require('./components/Admin/Staff/Team/TeamsIndex.vue'));
//
// Vue.component('team-create-edit', require('./components/Admin/Staff/Team/TeamCreateEdit.vue'));
//
// Vue.component('team-view', require('./components/Admin/Staff/Team/TeamView.vue'));

new Vue({
    el: '#app-admin',
    store: store
});
