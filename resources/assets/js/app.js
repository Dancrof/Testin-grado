import './bootstrap';

import moment from 'moment';

import 'es6-promise/auto';

import store from '../store';

import { FulfillingBouncingCircleSpinner } from 'epic-spinners';

import StarRating from 'vue-star-rating';

app.component('star-rating', StarRating);

import router from './router/clientRouter';

app.component('fulfilling-bouncing-circle-spinner', FulfillingBouncingCircleSpinner);

import { createHead } from "@vueuse/head"

const head = createHead()

app.use(head);

import Loader from './components/Client/Pages/ReusableComponents/Loader.vue';
import CustomLoader from "./components/MiniComponent/Loader.vue";
import ClientPanelRenderer from './components/Client/ClientPanelRenderer.vue';
import PasswordReset from './components/Client/Pages/Auth/PasswordReset.vue';
import MetaComponent from './components/Client/Pages/MetaComponent.vue';
import LicenseError from './components/Client/Pages/NotFound/LicenseError.vue';
import FormRenderer from "./components/Common/NewForm/FormRenderer.vue";
import Alert from './components/MiniComponent/Alert.vue';
import Modal from './components/Common/Modal.vue';
import ClientPanelLoader from "./components/Client/ClientPanelLayoutComponents/ReusableComponents/Loader.vue";
import DataTable from "./components/Extra/DataTable.vue";
import FaveoBox from "./components/MiniComponent/FaveoBox.vue";
import ReuseLoader from './components/Client/Pages/ReusableComponents/Loader.vue';
import FaveoImageElement from "./components/Common/FaveoImageElement.vue";

app.component('faveo-image-element', FaveoImageElement);

app.component('reuse-loader', ReuseLoader);

app.component('faveo-box', FaveoBox);

app.component('loader', Loader);

app.component('custom-loader', CustomLoader);

app.component('client-panel-renderer', ClientPanelRenderer);

app.component('client-panel-loader', ClientPanelLoader);

app.component('reset-password', PasswordReset);

app.component('meta-component', MetaComponent);

app.component('license-error', LicenseError);

app.component('form-renderer', FormRenderer);

app.component('alert', Alert);

app.component('modal', Modal);

app.component("data-table", DataTable)

app.config.globalProperties.$filters = {

  truncate(str, max) {
    return str.length > max ? str.substr(0, max - 1) + '…' : str;
  }
}


setTimeout(()=>{

  app.use(router);
  app.use(store);
  app.mount('#app-client-panel')

}, 1000);

/**
 * Should be called to inject routes from outside the bundle
 * @param {Array} wildCardRoutes
 */
window.addRoutes = (wildCardRoutes) => {
	
  router.addRoutes(wildCardRoutes);
}

import fileManagerStore from './components/Common/Media/store';

import FileManager from './components/Common/Media/FileManager.vue';

app.component('file-manager', FileManager)

store.registerModule('fm', fileManagerStore);

import FileManagerContainer from "./components/Agent/Filemanager/FileManagerContainer.vue";
app.component('file-manager-container', FileManagerContainer);
