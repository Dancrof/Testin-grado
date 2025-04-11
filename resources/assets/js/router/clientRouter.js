import { createWebHistory, createRouter } from "vue-router";

import routes from './clientRoutes';

const router = createRouter({

  history: createWebHistory(),

  inkActiveClass: '',

  linkExactActiveClass :'active exact-active',

  routes
})

export default router;
