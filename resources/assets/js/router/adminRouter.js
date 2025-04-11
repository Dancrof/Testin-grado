import { createWebHistory, createRouter } from "vue-router";

import routes from './adminRoutes';

// configure router
const router = createRouter({

    history: createWebHistory(),

    inkActiveClass: '',

    linkExactActiveClass :'active exact-active',

    routes,

    scrollBehavior(to, from, savedPosition) {
        return { top: 0 };
    },
})

export default router;
