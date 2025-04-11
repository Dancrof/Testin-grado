import './bootstrap';

import 'es6-promise/auto';

import store from '../store';

import faveoAutomator from './../store/modules/faveoAutomator';

import formBuilderStore from './../store/modules/formBuilderStore';

store.registerModule('faveoAutomator', faveoAutomator);

store.registerModule('formBuilderStore', formBuilderStore);

import AdminPanelRenderer from "./components/Master/AdminPanelRenderer.vue";
import DraggableFormFieldItem from "./components/Admin/Manage/FormBuilder/DraggableFormFieldItem.vue";
import FormRenderer from "./components/Common/NewForm/FormRenderer.vue";
import Alert from './components/MiniComponent/Alert.vue';
import Modal from './components/Common/Modal.vue';
import Loader from './components/Extra/Loader.vue';
import CustomLoader from './components/MiniComponent/Loader.vue';
import ReuseLoader from './components/Client/Pages/ReusableComponents/Loader.vue';
import FaveoBox from './components/MiniComponent/FaveoBox.vue';
import FaveoImageElement from "./components/Common/FaveoImageElement.vue";
import DataTable from './components/Extra/DataTable.vue';

app.component('admin-panel-renderer', AdminPanelRenderer);
app.component('draggable-form-field-item', DraggableFormFieldItem);
app.component('form-renderer', FormRenderer);
app.component('alert', Alert);
app.component('modal', Modal);
app.component('loader', Loader);
app.component('custom-loader', CustomLoader);
app.component('reuse-loader', ReuseLoader);
app.component('faveo-box', FaveoBox);
app.component('faveo-image-element', FaveoImageElement);
app.component("data-table", DataTable)

// router setup
import router from './router/adminRouter';

router.beforeEach((to, from, next) => {

    if(sessionStorage.getItem('user_role') == 'admin') {

        next();

    } else {
        let redirectTo = window.axios.defaults.baseURL;
        /**
         * If route is "panel/thread/X" for a user with role user we pass controll to backend
         * so backend can handle it and redirect user to check tiket page
         *
         * @todo Temporary redirection till users receive correct link for tickets in the mail
         */
        if(to.fullPath.includes('/thread/')) {
            redirectTo += to.fullPath;
        }
        window.location.href = redirectTo
    }
})

setTimeout(()=>{
    app.use(router);
    app.use(store);
    app.mount('#app-admin')
},1000)

router.beforeEach((to, from, next) => {
    app.config.globalProperties.$Progress.start()
    next()
});

router.afterEach(() => {

    setTimeout(()=>{

        app.config.globalProperties.$Progress.finish()
    },1000)
});
import fileManagerStore from './components/Common/Media/store';

import FileManager from './components/Common/Media/FileManager.vue';

app.component('file-manager', FileManager)

store.registerModule('fm', fileManagerStore);

import FileManagerContainer from "./components/Agent/Filemanager/FileManagerContainer.vue";
app.component('file-manager-container', FileManagerContainer);
