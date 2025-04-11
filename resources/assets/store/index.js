/**
 * Its a vuex store. It is implemeted to avoid sending multiple requests to backend and store repeated data at client-side instead.
 * It can alose be used to ease data management in nested components by simply writing component state to vuex and directly reading
 * from it instead of passing it to components
 * */

import { createStore } from "vuex";

import auth from './modules/auth';

import alert from './modules/alert';

import ticketSettings from './modules/ticketSettings';

import formBuilder from './modules/formBuilder';

import clientSettings from './modules/clientSettings';

import axiosLoader from './modules/axiosLoader';

import systemSettings from './modules/systemSettings';

import formRender from './modules/formRender';

import sdAssociates from './modules/sdAssociates';

import VuexPersist from 'vuex-persist';

const vuexLocalStorage = new VuexPersist({
    // storage: window.localStorage,
    reducer: state => ({
        clientSettings: state.clientSettings
    })
})

const store = createStore({

    modules : {
        /**
         * contain logged in user's details
         */
        auth,

        /**
         * contains ticket settings  related data on agent panel
         */
        ticketSettings,

        /**
         * contains client panel settings data
         */
        clientSettings,

        /**
         * contains sucess/failure alert and validation errors
         */
        alert,

        /**
         * data required for form builder
         */
        formBuilder,

        /**
         * contains general system settings
         */
        systemSettings,

        /*
         * Use single instance of loader for multiple axios calls
         */
        axiosLoader,

        formRender,

        sdAssociates
    },

    plugins: [vuexLocalStorage.plugin]
});

export default store;
