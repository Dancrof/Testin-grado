<template>

	 <aside class="app-sidebar bg-body-secondary shadow fs-6" data-bs-theme="dark" :class="callingFrom == 'admin' ? portal.admin_sidebar_color : portal.agent_sidebar_color">

       <div class="sidebar-brand" v-if="callingFrom == 'admin'" :class="portal.admin_header_color != 'navbar-light' ? portal.admin_header_color : ''">

         <a :href="company.website" class="brand-link text-center" v-bind:style="{ top: alertData ? alertWrapper +'px !important' : '' }">

           <img :src="portal.logo" alt="AdminLTE Logo" class="brand-image">
         </a>
       </div>

       <div v-else class="sidebar-brand"  :class="portal.agent_header_color != 'navbar-light' ? portal.agent_header_color : ''">

         <a :href="company.website" class="brand-link text-center" v-bind:style="{ top: alertData ? alertWrapper +'px !important' : '' }">

           <img :src="portal.logo" alt="AdminLTE Logo" class="brand-image">
         </a>
       </div>


     <template v-if="callingFrom == 'admin'">

       <admin-navigation-bar :auth="auth" from="admin"></admin-navigation-bar>

     </template>

     <template v-else>

       <agent-navigation-bar :auth="auth" from="agent"></agent-navigation-bar>

     </template>
   </aside>
</template>

<script>

    import AgentNavigationBar from "../../Navigation/AgentNavigationBar.vue";
    import AdminNavigationBar from "../../Navigation/AdminNavigationBar.vue";

	export default {

		name : 'admin-agent-sidebar',

		props : {

			company : { type : Object, default : ()=> {} },

			portal : { type : Object, default : ()=> {} },

			auth : { type : Object, default : ()=> {} },

			callingFrom : { type : String, default : '' },

      alertData : { type : Object, default :()=>{} },

      alertWrapper : { type : [Boolean, Number], default : '' }
		},

		components : {

			AgentNavigationBar,

			AdminNavigationBar,
		}
	};
</script>

<style type="scoped">

/*.main-sidebar{
  z-index: 9999;
}*/

.app-sidebar{
  font-size: .875rem !important;
}

.brand-image{
  max-width: 60px !important;
}

.sidebar-brand{
  height: 3.1rem;
}

</style>