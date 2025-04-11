import "./bootstrap"

import 'es6-promise/auto';

import store from "../store";

import {createApp} from "vue";
import DatabaseUpdates from "./components/HeaderNavigation/Updates/DatabaseUpdates.vue";

const childApp = createApp({ components : { 'database-updates' : DatabaseUpdates }})

Object.assign(childApp._context, app._context)

childApp.mount('#header-container')