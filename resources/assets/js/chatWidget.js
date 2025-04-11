import "./bootstrap"

import 'es6-promise/auto';

import store from "../store";

import {createApp} from "vue";

import ChatWidget from "./components/ChatWidget/ChatWidget.vue";

const childApp = createApp({ components : {
    'chat-widget' : ChatWidget
}})

Object.assign(childApp._context, app._context)

childApp.use(store).mount('#chat-widget')