import lodash from 'lodash-core';

window._ = lodash;

import '../css/common.scss';

import '../css/dynamicSelectCommon.css';

import '../css/popover.css';

import 'vue-select/dist/vue-select.css';
import 'vue-datepicker-next/index.css';
import 'vue3-treeselect/dist/vue3-treeselect.css'
import '../css/currency-flags.css'
import 'intl-tel-input/build/css/intlTelInput.css';

import { createApp } from 'vue'

import './echo.js';

const app = createApp({})

window.app = app;

import globalMixins from '../js/mixins/globalMixin'

app.mixin(globalMixins)

import { ScrollAjax } from "./components/directive/scrollAjax";
app.directive('scroll-ajax', ScrollAjax)

import { VTooltip } from 'floating-vue';

function getDynamicContent(value) {

    value = String(value); // Convert value to string

    const language = sessionStorage.getItem('app_language');
    const isSpecialLanguage = ['kr', 'zh-hans', 'zh-hant'].includes(language);
    const isSpecialLanguage2 = ['vi', 'id', 'no','ar','pt','ru','de'].includes(language);
    const hasLineBreak = /<br\s*\/?>/.test(value);
    const hasSpecialCharacters = /[!@#$%^&*(),.?":{}|<>]/.test(value);

    let lengthCondition;
    switch (true) {
        case isSpecialLanguage:
            lengthCondition = 40;
            break;
        case isSpecialLanguage2:
            lengthCondition = 85;
            break;
        case hasLineBreak:
            lengthCondition = 47;
            break;
        case hasSpecialCharacters && (language ==='en' || language === 'en-gb'):
            lengthCondition = 85;
            break;
        default:
            lengthCondition = 90;
    }

    const breakCount = (value.match(/<br\s*\/?>/g) || []).length;

    return (breakCount >= 2) || (value.length >= lengthCondition)
        ? `<p class="text-start m-0">${value}</p>`
        : value;
}

const CustomTooltip = {
    beforeMount(el, binding) {
        if (binding.value) {
            const content = getDynamicContent(typeof binding.value === 'object' && binding.value.content ? binding.value.content : binding.value);
            const updatedBindingValue = {
                ...binding.value,
                content,
                html: true
            };

            el.setAttribute('title', content);
            VTooltip.beforeMount(el, {...binding, value: updatedBindingValue});
        }
    }
};

app.directive('tooltip', CustomTooltip);

import VueScrollTo from "vue-scrollto";
app.directive('scroll-to', VueScrollTo)

import 'floating-vue/dist/style.css'

import mitt from 'mitt';
const emitter = mitt();
app.config.globalProperties.emitter = emitter;
window.emitter = emitter;

import Pagination from 'v-pagination-3';
app.component('uib-pagination', Pagination);

import InfiniteLoading from "v3-infinite-loading";
import "v3-infinite-loading/lib/style.css"
app.component("infinite-loading", InfiniteLoading);

import Popper from "vue3-popper";
app.component("popover", Popper);

import Toggle from '@vueform/toggle'
app.component("toggle", Toggle);

import 'es6-promise/auto';

import store  from '../store';

import { boolean, lang, getSubStringValue } from '../js/helpers/extraLogics';

/**
 * We'll load jQuery and the Bootstrap jQuery plugin which provides support
 * for JavaScript based Bootstrap features such as modals and tabs. This
 * code may be modified to fit the specific needs of your application.
 */

try {

    window.$ = window.jQuery = jQuery;

} catch (e) { }

document.addEventListener('keydown', function(event) {
    if ((event.ctrlKey || event.metaKey )&& event.shiftKey && event.key === 'E') {
        event.preventDefault();
        let selectedText = '';
        if(window.getSelection()){
            selectedText = window.getSelection().toString().trim();
        }

        window.askElea(selectedText);
    }
});


import VueProgressBar from "@aacassandra/vue3-progressbar";

const options = {
    color: "rgb(0, 154, 186)",
    failedColor: "red",
    thickness: "3px",
    transition: {
        speed: "2s",
        opacity: "0.6s"
    },
    autoRevert: true,
    location: "top",
    inverse: false,
    autoFinish: false
};

app.use(VueProgressBar, options)

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
let totalAxiosRequests = 0;
let successfulResponses = 0;
let loaderStarted = false;
let setLoader = false;
let progressStatus = 0;
let stopClearAxiosCount = true;
let fromSetLoader = false;

/**
 * Clear the request cache object after 500 miliseconds
 */
let clearRequestCache = function() {
  setTimeout(() => {
    requestObjectCache = null;
  }, 500);
}

// Function to clear Axios count and finish loader
let ClearAxiosCount = ()=>{
    stopClearAxiosCount = true;
    setTimeout(()=>{
        if(stopClearAxiosCount){
            progressStatus = app.config.globalProperties.$Progress.get()
            if(progressStatus !== 0){
                    app.config.globalProperties.$Progress.finish()
                    stopClearAxiosCount = false;
                    totalAxiosRequests = 0;
                    successfulResponses = 0;
                    loaderStarted = false;
            }
        }
    }, 90000)
}

// Function to start the loader if not already started
const startLoader = () => {
    if (!loaderStarted) {
        app.config.globalProperties.$Progress.start();
        if(!fromSetLoader){
            successfulResponses = 0;
        }
        loaderStarted = true;
        setLoader = true;
        fromSetLoader = false;
        ClearAxiosCount();
    }
};

/**
 * AXIOS Request Interceptor
 * 
 * This interceptor is used for rejecting duplicating API call
 * The time window is 250 miliseconds
 * 
 */
window.axios.interceptors.request.use((request) => {

    /**
     * Set Content-Security-Policy headers
     */
    request.headers['Content-Security-Policy'] = `
        default-src 'self';
        img-src 'self';
        connect-src 'self';
        form-action 'self';
        frame-ancestors 'self';
        script-src 'self';
        style-src 'self';
    `.replace(/\s+/g, ' ').trim();


    /**
   * Allow request if
   * 1. it's first API call of the App
   * 2. request object doesn't match the cache object 
   * 3. requested same API after 250 miliseconds
   */

  if (requestObjectCache === null || JSON.stringify(request) !== requestObjectCache || request.url.includes('http://')  || request.url.includes('https://')) {
    requestObjectCache = JSON.stringify(request);
    clearRequestCache();
      totalAxiosRequests++
      startLoader();
    return request;
  } else { // Reject the API call
    return Promise.reject({
      duplicateRequestRejection: true,
      message: 'Request rejected because of duplicate API call'
    });
  }
});

window.axios.interceptors.response.use((response) => {

        if(totalAxiosRequests !== 0) {
            successfulResponses++;
        }

            // Finish loader and reset counters if all requests are successful
            if ((successfulResponses === totalAxiosRequests) && response.status === 200) {

                if(successfulResponses === 1 && totalAxiosRequests === 1){
                    app.config.globalProperties.$Progress.finish()
                }else{
                    setTimeout(() => app.config.globalProperties.$Progress.finish(), 500);
                }
                if (stopClearAxiosCount) {
                    stopClearAxiosCount = false; // Reset the flag
                }
                successfulResponses = 0;
                totalAxiosRequests = 0;
                loaderStarted = false;
            } else if (setLoader) {
                // Set loader progress based on the total number of requests
                const progressValue = totalAxiosRequests <= 3 ? 60 : (totalAxiosRequests <= 6 ? 50 : 30);
                app.config.globalProperties.$Progress.set(progressValue);
                setLoader = false;
            }else if(successfulResponses > totalAxiosRequests){
                // Finish loader if more successful responses than expected
                setTimeout(() => app.config.globalProperties.$Progress.finish(), 100);
                if (stopClearAxiosCount) {
                    stopClearAxiosCount = false; // Reset the flag
                }
                successfulResponses = 0;
                totalAxiosRequests = 0;
                loaderStarted = false;
            }
            else{
                // Increase loader progress based on the total number of requests
                progressStatus = app.config.globalProperties.$Progress.get()
                if(progressStatus === 0){
                    loaderStarted = false;
                    fromSetLoader = true;
                    startLoader()
                }
                const increaseValue = totalAxiosRequests <= 3 ? 5 : (totalAxiosRequests <= 6 ? 4 : 3);
                app.config.globalProperties.$Progress.increase(increaseValue);
            }

	    return response

},function (error) {

    // Handle errors, finish loader, and handle specific error statuses
    app.config.globalProperties.$Progress.finish()

    if (stopClearAxiosCount) {
        stopClearAxiosCount = false; // Reset the flag
    }
    successfulResponses = 0;
    totalAxiosRequests = 0;
    loaderStarted = false;

	if (error.response.status === 401) {

		store.dispatch('setAlert', { type: 'danger', message: 'Unauthorized!', component_name: 'layout' });

		setTimeout(()=>{

			window.location = window.axios.defaults.baseURL;
		},2000);
        // Decrement the total count for non-200 responses
        totalAxiosRequests--;

		return Promise.reject(error);
	}else if(error.response.status !== 200){
        totalAxiosRequests--;
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
export const injectComponentIntoView = (componentName ,componentInstance, eventName, containerId, panel = 'agent', elementType = 'div') => {

    // let routePanel = panel === 'admin' ? adminRouter : 'agentRouter';

    // register an event, as soon as that event comes, append the component into it
    window.emitter.on( eventName, (data) => {
        // console.log('========',eventName, componentName ,componentInstance, eventName, containerId)
        // what to do if extra parameters is passed with the event ?
        // SOLUTION 1 : emit another event with that data that can be observed by the component
        // SOLUTION 2 : pass that as prop (prefer more)

        // making the appending asychronous so that appending happens only after div is present in the DOM
        setTimeout(()=>{

          let container = document.getElementById(containerId);

          // so that it appends only once
          if(container !== null && document.getElementById(componentName) === null){
              let parentNode = document.createElement(elementType);
              parentNode.setAttribute('id', componentName);

            let node = document.createElement(componentName);

            // before appending make sure to pass props
            node.setAttribute('data', JSON.stringify(data));

              parentNode.appendChild(node);
              container.appendChild(parentNode);

            let component = {};

            component[componentName] = componentInstance;

              let expose = null

              const childApp = createApp({ render: () => expose = h(componentInstance, { data : JSON.stringify(data)}) })

              // childApp.use(routePanel);

              Object.assign(childApp._context, app._context)

              childApp.mount('#'+componentName)
          }
        },100)

    });
}

/**
 * Injects a Vue component into elements with a specified class when a specific event is triggered.
 *
 * @param {String} componentName - The name of the component to inject.
 * @param {Object} componentInstance - The Vue component instance to inject.
 * @param {String} eventName - The name of the event that triggers the injection.
 * @param {String} containerClass - The class of the container elements where the component will be injected.
 * @param {String} [panel='agent'] - The panel type, default is 'agent'.
 */
export const injectComponentIntoViewByClass = (componentName, componentInstance, eventName, containerClass, panel = 'agent') => {

    // Listen for the specified event
    window.emitter.on(eventName, (data) => {

        // Delay the execution to ensure the container is available in the DOM
        setTimeout(() => {

            // Get all elements with the specified class
            const containers = document.getElementsByClassName(containerClass);

            // Iterate over each container
            Array.from(containers).forEach(container => {

                // Check if the container exists and does not already contain the component
                if (container && !container.querySelector(`.${componentName}`)) {

                    // Create a parent span element with the component's class name
                    const parentNode = document.createElement('span');
                    parentNode.className = componentName;

                    // Create the component element and set its data attribute
                    const node = document.createElement(componentName);
                    node.dataset.data = JSON.stringify(data);

                    // Append the component to the parent node and the parent node to the container
                    parentNode.appendChild(node);
                    container.appendChild(parentNode);

                    // Create a new Vue app instance and mount it to the parent node
                    const childApp = createApp({ render: () => h(componentInstance, { data: JSON.stringify(data) }) });
                    // Inherit the context from the main app
                    Object.assign(childApp._context, app._context);
                    // Mount the child app to the parent node
                    childApp.mount(parentNode);
                }
            });
        }, 100);
    });
}

import {h} from 'vue';

app.config.globalProperties.h = h;

app.config.globalProperties.$filters = {

    checkValue(value,length) {

        if (!value) return '---'

        return value.name ? getSubStringValue(value.name,length) : getSubStringValue(value,length)
    }
}

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

import vClickOutside from 'v-click-outside';

const { bind, unbind } = vClickOutside.directive;

app.directive('click-outside', {
    mounted(el, bindling) {
        bind(el, { value: bindling.value });
    },
    beforeUnmount(el) {
        unbind(el);
    },
});

app.directive('focus-first-input', {
    mounted(el) {
        const firstField = el.querySelector('input, textarea, select');
        if (firstField) {
            firstField.focus();
        }
    }
});
//=============================================== vee-validate start ===============================================//

import { Form, Field, ErrorMessage, defineRule, configure } from 'vee-validate';

import { localize } from '@vee-validate/i18n';

import AllRules from '@vee-validate/rules';

Object.keys(AllRules).forEach(rule => {
    defineRule(rule, AllRules[rule]);
});

configure({

    generateMessage: localize({

        en: {
            messages: {

                required: () => lang('this_field_is_required'),

                email: () => lang('invalid_email'),

                numeric : () => lang('invalid_number'),

                date_format: () => lang('invalid_date_format'),

                max: () => lang('max_length_exceeded'),

                regex: () => lang('invalid_field_format'),

                phone: () => lang('invalid_mobile'),

                min: (ctx) => `${lang('this_field_must_be_at_least')} ${ctx.rule.params[0]} ${lang('characters')}`,
            }
        }
    }),
})

app.component('ValidationObserver', Form);
app.component('ValidationProvider', Field);
app.component('ErrorMessage', ErrorMessage);

//=============================================== vee-validate end ===============================================//

// Install components globally
import TinyMCE from './components/Common/tinyMCE/TinyMCE.vue';
import TinyMCEWithValidation from './components/Common/tinyMCE/TinyMCEWithValidation.vue';
import FormRenderer from "./components/Common/NewForm/FormRenderer.vue";
import Alert from "./components/MiniComponent/Alert.vue";
app.component('tiny-editor', TinyMCE)
app.component('tiny-editor-with-validation', TinyMCEWithValidation)
app.component('form-renderer', FormRenderer)
app.component('alert', Alert)

// Observer for Infinite Scrolling

import { ObserveVisibility } from 'vue-observe-visibility';

app.directive('observe-visibility', {
    beforeMount: (el, binding, vnode) => {
        vnode.context = binding.instance;
        ObserveVisibility.bind(el, binding, vnode);
    },
    update: ObserveVisibility.update,
    unmounted: ObserveVisibility.unbind,
});

import FaveoFormClientPanel from "./components/Client/FaveoFormClientPanel.vue";
app.component('faveo-form-client-panel', FaveoFormClientPanel)

import FormGenerator from "./components/Common/Form/FormGenerator.vue";
app.component('FormGenerator',FormGenerator);

import FormSectionRenderer from "./components/Common/NewForm/FormSectionRenderer.vue";
import {chrome} from "codemirror/src/util/browser";
app.component('FormSectionRenderer', FormSectionRenderer);