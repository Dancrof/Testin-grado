import { createWebHistory, createRouter } from "vue-router";

import routes from './agentRoutes';

// configure router
const router = createRouter({

  history: createWebHistory(),

  inkActiveClass: '',

  linkExactActiveClass :'exact-active',

  routes,

  scrollBehavior(to, from, savedPosition) {
    return { top: 0 };
  },
})

export default router;
