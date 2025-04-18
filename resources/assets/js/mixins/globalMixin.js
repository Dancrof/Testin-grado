import {boolean, lang, sessionItems} from '../helpers/extraLogics'

import axios from "axios";

import store from "../../store/index"

window.axios = axios;

// Debounce function to limit the frequency of function calls
function debounce(func, wait) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}

export default {

    data() {

        return {

            lang : lang,

            isRtlLayout: boolean(sessionItems.isRtlLayout),

            headerColor: sessionItems.headerColor,

            recaptchaSiteKey: sessionItems.recaptchaSiteKey,

            recaptchaVersion: sessionItems.recaptchaVersion,

            recaptchaApplyfor: sessionItems.recaptchaApplyfor,

            isUserLoggedIn: sessionItems.isUserLoggedIn,

            loggedUserName: sessionItems.loggedUserName,

            loggedUserMail: sessionItems.loggedUserMail,

            loggedUserRole: sessionItems.loggedUserRole,

            appVersion: sessionItems.appVersion,

            appLanguage: sessionItems.appLanguage,
        }
    },

    mounted() {
        this.debouncedHandleScroll = debounce(this.handleScroll, 10);
        window.addEventListener('scroll', this.debouncedHandleScroll);
        this.checkTOC();
    },

    beforeUnmount() {

        window.removeEventListener('scroll', this.handleScroll);
    },

    methods: {

        basePath: () => (window.axios.defaults.baseURL),

        basePathVersion() {
            return window.axios.defaults.baseURL + '/' + sessionItems.appVersion;
        },

        trans: (string) => lang(string),

        boolean: (value) => (boolean(value)),

        currentPath: () => (window.location.pathname),

        redirect: (path) => {
            if (window.axios && window.axios.defaults && window.axios.defaults.baseURL) {
                window.location.assign(window.axios.defaults.baseURL + path);
            } else {
                // Handle the error gracefully
                console.error('Error: axios defaults not set');
            }
        },

        sleep: (ms) => new Promise(resolve => setTimeout(resolve, ms)),

        getSubString(str, len) {

            if (str) {
                if (str.length > len) {
                    return str.substring(0, len) + '...';
                } else {
                    return str;
                }
            }
        },

        // Handle the scroll event and tooltip display behaviour
        handleScroll() {
            // Select all elements with the tooltip class
            const tooltips = document.querySelectorAll('.v-popper__popper');
            tooltips.forEach((tooltip) => {
                // Removes all the tooltip element
                tooltip.remove();
            });

            const poppers = document.querySelectorAll('.popper');
            poppers.forEach((popper) => {
                // Adds the 'fade-leave-active' class to the popper element
                popper.classList.add('fade-leave-active', 'fade-leave-to');
            });

        },

        checkTOC() {

            if (document && document.getElementsByClassName('toc_link').length) {

                document.getElementsByClassName('toc_link').forEach((element) => {
                    element.addEventListener('click', (event) => {
                        event.preventDefault();
                        const target = document.querySelector(element.getAttribute('href'));
                        target.scrollIntoView({behavior: 'smooth'});
                    });
                })
            }
        },

        isEleaAssistant() {
            axios.get('/elea-assistant/elea-settings-active-list').then(res => {
                this.$store.dispatch('setAiAssistOptions', res.data.data);

            }).catch(error => {

                const defaultSettings = [
                    {setting_name: "sentiment_analysis_key", active: 0},
                    {setting_name: "conversation-widget", active: 0},
                    {setting_name: "summarize_ticket_key", active: 0},
                    {setting_name: "better_ticket_reply_key", active: 0},
                    {setting_name: "translate_ticket_content_key", active: 0},
                    {setting_name: "grammar_spell_check", active: 0}
                ];
                this.$store.dispatch('setAiAssistOptions', defaultSettings);
            });
        },

        isSettingActive(settingName) {
            const eleaSettings = this.$store.getters.getAiAssistOptions;
            const setting = eleaSettings.find(s => s.setting_name === settingName);
            return setting ? setting.active === 1 : false;
        },

        decodeHtml(html) {
            if (!html) {
                return null;
            }
            const txt = document.createElement("textarea");
            txt.innerHTML = html;
            return txt.value;
        }
    }
}