import { config } from '@vue/test-utils'

import axios from "axios";

import mitt from 'mitt';
window.emitter = mitt()

import globalMixin from "./resources/assets/js/mixins/globalMixin";
import { TextEncoder, TextDecoder } from 'text-encoding';

global.TextEncoder = TextEncoder;
global.TextDecoder = TextDecoder;
config.global.mixins = [globalMixin]
config.global.mocks = {
    axios,
    $Progress : {
        start : jest.fn(),
        fail : jest.fn()
    },
    $router :{
        push : jest.fn()
    }
}
config.global.directives = { 'scroll-ajax' : jest.fn(), 'scroll-to' : jest.fn(),tooltip : jest.fn(), captcha : jest.fn(), 'focus-first-input' : jest.fn() }

config.global.stubs = [
    'router-link',
    'reuse-loader',
    'modal',
    'loader',
    'custom-loader',
    'data-table',
    'faveo-image-element',
    'popover',
    'faveo-box',
    'alert',
    'ValidationObserver','ValidationProvider','ErrorMessage',
    'tiny-editor',
    'draggable-form-field-item',
    'tiny-editor-with-validation',
    'client-panel-loader',
    'form-field-template',
    'tool-tip',
    'svg-icon-handler',
    'v-tooltip',
    'transition',
]

jest.mock('./resources/assets/js/helpers/responseHandler');

jest.mock('epic-spinners', () => ({
    FulfillingBouncingCircleSpinner: () => null, // Provide a dummy implementation
}));

jest.mock('intl-tel-input', () => ({
    default: jest.fn().mockImplementation(() => ({
        isValidNumber: jest.fn(),
        getSelectedCountryData: jest.fn(() => ({ dialCode: '91', iso2: 'in' })),
        addEventListener: jest.fn(), // Mock addEventListener
    })),
}));

jest.mock('intl-tel-input/i18n', () => ({
    ar: jest.fn(),
    bs: jest.fn(),
    de: jest.fn(),
    en: jest.fn(),
    es: jest.fn(),
    fr: jest.fn(),
    id: jest.fn(),
    it: jest.fn(),
    ko: jest.fn(),
    nl: jest.fn(),
    pt: jest.fn(),
    ru: jest.fn(),
    zh: jest.fn(),
}));

// tinyMce themes mock
jest.mock('tinymce/themes/silver', () => ({}));

// tinyMCE media jest mock
window.matchMedia = window.matchMedia || function() {
    return {
        matches: false,
        addListener: function() {},
        removeListener: function() {}
    };
};

import { createStore } from 'vuex';
import { createRouter, createMemoryHistory } from 'vue-router';

// Mock store
global.mockStore = createStore({
    // Vuex store configuration
});

// Mock router instance
global.mockRouter = createRouter({
    history: createMemoryHistory(),
    routes: [
        {path: '/', component: {}}
    ],
});