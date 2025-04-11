/**
 * Contains all Navigation related components
 * REASON :  if we put these components inside agent or admin bundle and if a plugin
 * is loading, we don't need rest of the data in the bundle so keeping this seperate makes
 * it more efficient
 * We cannot load navigation dynamically because it will be required on each and every page,
 * so better to load this bundle before any bundle for better user experience
 * @author avinash kumar <avinash.kumar@ladybirdweb.com>
 */

import './bootstrap';

import 'es6-promise/auto';

import store from "../store";

import AdminNavigationBar from "./components/Navigation/AdminNavigationBar.vue";
import AgentNavigationBar from "./components/Navigation/AgentNavigationBar.vue";

app.component('admin-navigation-bar', AdminNavigationBar);
app.component('agent-navigation-bar', AgentNavigationBar);

new Vue({
    el: '#navigation-container',
    store: store
});
