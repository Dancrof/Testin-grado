import lodash from 'lodash-core';

window._ = lodash;

import '../css/common.scss';

import '../css/dynamicSelectCommon.css';

import '../css/tooltip.css';

import "vue-select/src/scss/vue-select.scss";

import "@riophae/vue-treeselect/dist/vue-treeselect.css";

import { createApp } from 'vue'

const app = createApp({})

window.app = app;

// window.eventHub = new Vue();

import 'es6-promise/auto';

// import agentRouter from './router/agentRouter';
//
// import adminRouter from './router/adminRouter';

import { store } from '../store/store';

import { boolean, lang, getSubStringValue } from '../js/helpers/extraLogics';

/**
 * We'll load jQuery and the Bootstrap jQuery plugin which provides support
 * for JavaScript based Bootstrap features such as modals and tabs. This
 * code may be modified to fit the specific needs of your application.
 */

import jquery from 'jquery';

try {

    window.$ = window.jQuery = jquery;

} catch (e) { }

import VueProgressBar from 'vue-progressbar';

app.use(VueProgressBar, { color: '#f8f9fa', failedColor: 'red', height: '2px'});

/**
 * We'll load the axios HTTP library which allows us to easily issue requests
 * to our Laravel back-end. This library automatically handles sending the
 * CSRF token as a header based on the value of the "XSRF" token cookie.
 */

import axios from 'axios';

window.axios = axios;

/**
 * Cache object for the request object
 */
let requestObjectCache = null;

/**
 * Clear the request cache object after 500 miliseconds
 */
let clearRequestCache = function() {
    setTimeout(() => {
        requestObjectCache = null;
    }, 500);
}

/**
 * AXIOS Request Interceptor
 *
 * This interceptor is used for rejecting duplicating API call
 * The time window is 250 miliseconds
 *
 */
window.axios.interceptors.request.use((request) => {

    this.$Progress.start()
    /**
     * Allow request if
     * 1. it's first API call of the App
     * 2. request object doesn't match the cache object
     * 3. requested same API after 250 miliseconds
     */
    if (requestObjectCache === null || JSON.stringify(request) !== requestObjectCache || request.url.includes('http://')  || request.url.includes('https://')) {
        requestObjectCache = JSON.stringify(request);
        clearRequestCache();
        return request;
    } else { // Reject the API call
        return Promise.reject({
            duplicateRequestRejection: true,
            message: 'Request rejected because of duplicate API call'
        });
    }
});

window.axios.interceptors.response.use((response) => {

    return response

},function (error) {

    if (error.response.status === 401) {

        store.dispatch('setAlert', { type: 'danger', message: 'Unauthorized!', component_name: 'layout' });

        setTimeout(()=>{

            window.location = window.axios.defaults.baseURL;
        },2000);

        return Promise.reject(error);
    }

    return Promise.reject(error);

});

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

window.axios.defaults.baseURL = document.head.querySelector('meta[name="api-base-url"]').content;


/*
  uncomment these lines once modularity is implemented.
  this will add auth token to the header of each request sent from the code
  SOME ASSUMPTIONS WHICH CAN BE CONSIDERED :
 */

// window.axios.defaults.headers.common['Auth-Token'] = getAuthToken();

/**
 * gets token from localStorage
 * WARNING : storing tokens in cookies are vulnerable to csrf attacks, so store it in localstorage
 * Localstorage is vulnerable to XSS attacks.
 *
 * Our current architecture doesn't have much xss vulnerabilities(and will be gone in future)
 * as we are using vue, and even if someone injects javascipt in the DB it will not be rendered
 * as javascript until it is explicitly mentioned in the code
 *
 * @return {string}   auth token
 */
// function getAuthToken(){
//  //get from localStorage
// }


// update token every 30 mins
setInterval(keepPageAlive, 30 * 60 * 1000); // every 30 mins it will regenate the csrf token even if page is idle

function keepPageAlive() {
    axios.post("/keep-page-alive");
}


/**
 * injects components into a container when passed event is triggered
 * NOTE: Will be used to inject html and javascipt code into existing view. Most important used for bilding faveo plugins
 *
 * @param  {String} componentName     Name of the component that you want to inject
 * @param  {Any} componentInstance    Vue component instance. For eg. require('path/to/the/component')
 * @param  {String} eventName         Name of the event to which this component has to be injected
 * @param  {String} containerId     Id of the container(for eg. id of the div) where component has to be injected
 * @return undefined
 */
// export const injectComponentIntoView = (componentName ,componentInstance, eventName, containerId, panel = 'agent') => {
//
//     let routePanel = panel === 'admin' ? adminRouter : agentRouter;
//
//     // register an event, as soon as that event comes, append the component into it
//     window.emitter.on( eventName, (data) => {
//         // console.log('========',eventName, componentName ,componentInstance, eventName, containerId)
//         // what to do if extra parameters is passed with the event ?
//         // SOLUTION 1 : emit another event with that data that can be observed by the component
//         // SOLUTION 2 : pass that as prop (prefer more)
//
//         // making the appending asychronous so that appending happens only after div is present in the DOM
//         setTimeout(()=>{
//
//           let container = document.getElementById(containerId);
//
//           // so that it appends only once
//           if(container !== null && document.getElementById(componentName) === null){
//               let parentNode = document.createElement('div');
//               parentNode.setAttribute('id', componentName);
//
//             let node = document.createElement(componentName);
//
//             // before appending make sure to pass props
//             node.setAttribute('data', JSON.stringify(data));
//
//               parentNode.appendChild(node);
//               container.appendChild(parentNode);
//
//             let component = {};
//             component[componentName] = componentInstance;
//
//             console.log(new Vue({
//                 el: '#'+ componentName,
//                 store: store,
//                 components: component,
//                 router : routePanel
//             }));
//           }
//         },100)
//
//     });
// }


//fetching language file from server and declaring that as global prop
//if file doesn't have the passed key, it is going to return string

app.config.globalProperties.lang = lang;

// gives basePath
app.config.globalProperties.basePath = () => (window.axios.defaults.baseURL)

// gives if something is true of false based on PHP creteria
app.config.globalProperties.boolean = (value) => (boolean(value))

app.mixin({
    methods: {
        currentPath: () => (window.location.pathname),
        basePath : () => (window.axios.defaults.baseURL),
        redirect : (path) => {window.location = window.axios.defaults.baseURL + path},
        sleep :  (ms) => new Promise(resolve => setTimeout(resolve, ms)),
        trans: (string) => lang(string)
    },

    data: () =>({
        isRtlLayout : boolean(sessionStorage.getItem('is_rtl')),
        headerColor:  sessionStorage.getItem('header_color'),
        recaptchaSiteKey: sessionStorage.getItem('siteKey'),
        recaptchaVersion: sessionStorage.getItem('version'),
        recaptchaApplyfor: sessionStorage.getItem('applyfor'),
        isUserLoggedIn: sessionStorage.getItem('userLoggedIn'),
        loggedUserName: sessionStorage.getItem('full_name'),
        loggedUserMail: sessionStorage.getItem('logged_in_user_mail'),
    })
});

app.filter('checkValue', function (value,length) {

    if (!value) return '---'

    return value.name ? getSubStringValue(value.name,length) : getSubStringValue(value,length)
})

/**
 * For show/hide Recaptcha in pages
 */
app.directive("captcha", function(el, binding, vnode) {

    let value = binding.value;

    if(value) {

        if(sessionStorage.getItem('applyfor').includes(value)) {

            el.style.display = "block";

        } else { el.style.display = "none";  }

    } else {

        el.style.display = "block";
    }
});


//=============================================== vee-validate start ===============================================//

//
// import { ValidationObserver, ValidationProvider, extend, localize } from 'vee-validate';
// import * as rules from 'vee-validate/dist/rules';
//
// import { configure } from 'vee-validate';
//
// configure({
//   classes: {
//     invalid: 'field-danger',
//   }
// })
//
// Object.keys(rules).forEach(rule => {
//   extend(rule, rules[rule]);
// });

// localize({
//   en: {
//     messages: {
//       required: () => lang('this_field_is_required'),
//       email: () => lang('invalid_email'),
//       numeric : () => lang('invalid_number'),
//       date_format: () => lang('invalid_date_format'),
//       max: () => lang('max_length_exceeded'),
//       regex: () => lang('invalid_field_format')
//     }
//   }
// });
//
// // Install components globally
// Vue.component('ValidationObserver', ValidationObserver);
// Vue.component('ValidationProvider', ValidationProvider);

//=============================================== vee-validate end ===============================================//



import 'tinymce';
import 'tinymce/themes/silver';
import 'tinymce/plugins/advlist';
import 'tinymce/plugins/fullscreen';
import 'tinymce/plugins/wordcount';
import 'tinymce/icons/default';
import 'tinymce/plugins/image';
import 'tinymce/plugins/autolink';
import 'tinymce/plugins/lists';
import 'tinymce/plugins/link';
import 'tinymce/plugins/charmap';
import 'tinymce/plugins/print';
import 'tinymce/plugins/preview';
import 'tinymce/plugins/anchor';
import 'tinymce/plugins/searchreplace';
import 'tinymce/plugins/visualblocks';
import 'tinymce/plugins/code';
import 'tinymce/plugins/insertdatetime';
import 'tinymce/plugins/media';
import 'tinymce/plugins/table';
import 'tinymce/plugins/paste';
import 'tinymce/plugins/help';
import 'tinymce/plugins/importcss';
import 'tinymce/plugins/autosave';
import 'tinymce/plugins/directionality';
import 'tinymce/plugins/visualchars';
import 'tinymce/plugins/hr';
import 'tinymce/plugins/pagebreak';
import 'tinymce/plugins/nonbreaking';
import 'tinymce/plugins/toc';
import 'tinymce/plugins/imagetools';
import 'tinymce/plugins/textpattern';
import 'tinymce/plugins/noneditable';
import 'tinymce/plugins/quickbars';
import 'tinymce/plugins/template';
import 'tinymce/plugins/codesample';

// Install components globally
import TinyMCE from './components/Common/tinyMCE/TinyMCE.vue';
import TinyMCEWithValidation from './components/Common/tinyMCE/TinyMCEWithValidation.vue';
Vue.component('tiny-editor', TinyMCE)
Vue.component('tiny-editor-with-validation', TinyMCEWithValidation)

// Observer for Infinite Scrolling
import { ObserveVisibility } from 'vue-observe-visibility'

Vue.directive('observe-visibility', ObserveVisibility)

import fileManagerStore from './components/Common/Media/store';

import FileManager from './components/Common/Media/FileManager';

Vue.component('file-manager', FileManager)

store.registerModule('fm', fileManagerStore);

import FileManagerContainer from "./components/Agent/Filemanager/FileManagerContainer";
Vue.component('file-manager-container', FileManagerContainer);
