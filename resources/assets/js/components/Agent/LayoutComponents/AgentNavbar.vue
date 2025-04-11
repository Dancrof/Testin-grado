<template>
  
  <nav class="app-header navbar navbar-expand" :class="callingFrom == 'admin' ? portal.admin_header_color : portal.agent_header_color">

    <div class="container-fluid">
      <ul class="navbar-nav">

        <li class="nav-item">

          <a class="nav-link" data-lte-toggle="sidebar" href="javascript:;" role="button" @click="pushMenu">
            
            <i class="fas fa-bars"></i>
          </a>
        </li>

      </ul>

      <ul class="navbar-nav ms-auto">

        <li v-if="topMenus.length" class="nav-item dropdown">

          <a id="topMenu" href="javascript:;" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="nav-link dropdown-toggle rounded pb-25">

            <i class="far fa-plus-square"></i> &nbsp;{{ trans('new') }}
          </a>

          <ul aria-labelledby="topMenu" class="dropdown-menu border-0 shadow top-dropdown-menu">

            <li v-if="topMenuLoading">
              <ReuseLoader :size="25"></ReuseLoader>
            </li>

            <template v-else>

              <li v-for="(menu,index) in topMenus" :key="index" :class="topMenus.length > 1 ? 'pb-1' : ''">

                <a v-if="callingFrom === 'admin'" :href="this.basePath()+'/panel/'+menu.routeString" class="dropdown-item">

                  <i :class="menu.iconClass"></i> &nbsp;{{ trans(menu.name) }}
                </a>

                <router-link v-else :to="menu.redirectUrl.replace(this.basePath(), '')" class="dropdown-item">

                  <i :class="menu.iconClass"></i> &nbsp;{{ trans(menu.name) }}
                </router-link>
              </li>

              <li v-if="!topMenus.length" class="dropdown-item text-center">
                <i class="fas fa-exclamation-triangle"></i> &nbsp; {{ trans('no_options_found') }}
              </li>

            </template>
          </ul>
        </li>

        <li class="nav-item">
          <a v-if="callingFrom == 'admin'"
             class="nav-link"
             :href="basePath()+'/panel/dashboard'"
             v-tooltip="trans('switch_to_agent_panel')">
            <i class="fa-solid fa-user-tie m-auto"></i>
          </a>
        </li>

        <li v-if="!callingFrom && auth.user_data.role == 'admin'" class="nav-item">

          <a class="nav-link" :href="basePath()+'/admin/home'" v-tooltip="trans('switch_to_admin_panel')"><i class="fa-solid fa-user-gear m-auto"></i></a>
        </li>

        <a class="nav-link" href="javascript:;" v-if="!showSearchBar && callingFrom != 'admin'">
          <div >
            <i class="fas fa-search" @click="showSearchBar=true"></i>
          </div>
        </a>

        <global-search v-if="showSearchBar" @close-search-bar="handleCloseSearchBar" :userId="auth.user_data.id" :callingFrom="callingFrom" :headerBackground="callingFrom == 'admin' ? portal.admin_header_color : portal.agent_header_color"></global-search>

        <template v-if="auth.user_data.role == 'admin'">

          <application-updates :callingFrom="callingFrom" :headerBackground="callingFrom == 'admin' ? portal.admin_header_color : portal.agent_header_color"></application-updates>
        </template>

        <inapp-notification :userId="auth.user_data.id" :callingFrom="callingFrom" :headerBackground="callingFrom == 'admin' ? portal.admin_header_color : portal.agent_header_color"></inapp-notification>
        <template v-if="!callingFrom">

          <li id="nav-id" class="nav-item">{{navbarMounted()}}</li>
        </template>

        <language-dropdown :language="userLang"></language-dropdown>

        <li class="nav-item dropdown user-menu">
          <a href="javascript:;" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
        <span :key="dynamicKey" class="d-none d-md-inline me-1" v-tooltip="auth.user_data.full_name" dir="auto">
            {{ subString(auth.user_data.full_name) }}
            <img :src="auth.user_data.profile_pic" class="user-image rounded-circle elevation-2 d-none d-md-inline"
                 alt="User Image"/>
        </span>
            <faveo-image-element id="nav-image" :src="auth.user_data.profile_pic"
                                 class="user-image rounded-circle elevation-2 d-md-none" alt="User Image"/>
          </a>
          <ul class="dropdown-menu dropdown-menu-sm dropdown-menu-end rounded model-box rounded text-light dropdown-menu-arrow mt-2 rounded">
            <li>
              <a v-if="callingFrom === 'admin'" class="dropdown-item dp-data" :href="basePath()+'/panel/profile'">
                <i class="fa fa-user pe-2"></i>{{ trans('profile') }}
              </a>
              <router-link v-else class="dropdown-item dp-data " to="/profile"><i
                  class="fa fa-user pe-2"></i>{{ trans('profile') }}
              </router-link>
            </li>
            <li>
              <a href="javascript:;" class="dropdown-item dp-data mb-4 mt-1" @click="signOut">
                <i class="fas fa-sign-out-alt pe-2"></i>{{ trans('log_out') }}
              </a>
            </li>
          </ul>
        </li>
      </ul>

      <custom-loader v-if="loading"  :animation-duration="4000"/>
    </div>
 	</nav>
</template>

<script>

    import { getSubStringValue } from "../../../helpers/extraLogics";
    import { computed }  from 'vue';
    import { useStore } from 'vuex';
    import AgentLang from "./Mini/AgentLang.vue";
    import InAppNotification from "./Mini/InAppNotification.vue";
    import ApplicationUpdates from "./Mini/ApplicationUpdates.vue";
	import GlobalSearch from "./Mini/GlobalSearch.vue";
    import {errorHandler} from "../../../helpers/responseHandler";
	import ReuseLoader from "../../Client/Pages/ReusableComponents/Loader.vue";

	export default {

		name : 'admin-agent-top-navbar',

        setup() {

            const store = useStore();

            return {
                // getter
                getPushMenu: computed(() => store.getters.getPushMenu),
            };
        },

		props : {

			auth : { type : Object, default : ()=>{} },

			portal : { type : Object, default : ()=>{} },

			callingFrom : { type : String, default : '' }
		},

		data() {

			return {
				loading : false,
				showSearchBar: false,
				topMenuLoading : false,
				topMenus : []
			}
		},

		created() {

			this.togglePush();

			this.getTopMenu();
		},

		computed : {

      	userLang(){

	        	return this.auth.user_data.user_language ? this.auth.user_data.user_language : 'en'
	      },

      dynamicKey() {
        return `full-name-${this.auth.user_data.full_name}`;
      }
    },

	   	methods : {

		    changeNavColor() {

			    const appHeader = document.querySelector('.app-header');

			    if (appHeader) {

				    const headerBgColor = window.getComputedStyle(appHeader).backgroundColor;

				    const isBlack =
					    headerBgColor === 'black' ||
					    headerBgColor === 'rgb(0, 0, 0)' ||
					    headerBgColor === 'rgba(0, 0, 0, 1)' ||
					    headerBgColor.toLowerCase() === '#000000';

				    if (isBlack) {

					    const links = document.querySelectorAll('.app-header .nav-item .nav-link, .app-header .nav-link');

					    links.forEach(link => {
						    link.style.color = 'rgba(255, 255, 255, 0.55)';
					    });

					    let topMenu = document.getElementById('topMenu');

					    if (topMenu) {

						    topMenu.style.color = 'rgba(0, 0, 0, 0.8) !important';
					    }
				    }

			    } else {

					console.error('.app-header element not found!');
			    }
		    },

			getTopMenu() {

				this.topMenuLoading = true;

				axios.get('/api/agent/navigation?meta=true').then(res=>{

					this.topMenus = this.findObjectsWithShowOnTopNavbar(res.data.data);

					this.topMenuLoading = false;

					setTimeout(()=>{

						this.changeNavColor();

					},1000);

				}).catch(err=>{

					this.topMenuLoading = false;

					errorHandler(err,'layout');
				})
			},

		    findObjectsWithShowOnTopNavbar(data, parentIconClass = null) {

				let result = [];

			    function recurse(items, parentIconClass) {

				    items.forEach(item => {

					    if (item.showOnTopNavbar && item.iconClass === "far fa-circle" && parentIconClass) {

						    item.iconClass = parentIconClass;
					    }

					    if (item.showOnTopNavbar) {

						    if(item.routeString === 'user/list') {
							    item['name'] = 'create_contact';
							    item['routeString'] = 'user/create';
							    item['redirectUrl'] = '/user/create';
						    }

						    result.push(item);
					    }

					    if (item.children && item.children.length) {
						    recurse(item.children, item.iconClass);
					    }

					    if (item.navigations && item.navigations.length) {
						    recurse(item.navigations, item.iconClass);
					    }
				    });
			    }

			    recurse(data, parentIconClass);
			    return result;
		    },

	   		navbarMounted() {

	   			window.emitter.emit('navbar-mounted');
	   		},

	   		subString(value,length = 30){

				return getSubStringValue(value,length)
			},

		   	signOut(){

			   this.loading = true;

				axios.post('/auth/logout').then(res=>{

					this.loading = false;

					window.location.href = res.data.data ? res.data.data : this.basePath();

				}).catch(error=>{

					this.loading = false;
				})
			},

			pushMenu() {

				this.$store.dispatch('setPushMenu',!this.getPushMenu);

				this.togglePush()
			},

      togglePush() {
        // Get the element with the ID 'layout_body'
        let element = document.getElementById('layout_body');

        // Use Vue's nextTick to ensure the DOM is updated before making changes
        this.$nextTick(() => {

          // Check the current state of the push menu from the Vuex store
          if (this.getPushMenu) {

            // If the push menu is active, add the 'sidebar-collapse' class and remove the 'sidebar-open' class
            element.classList.add("sidebar-collapse");
            element.classList.remove("sidebar-open");
          } else {

            // If the push menu is not active, add the 'sidebar-open' class and remove the 'sidebar-collapse' class
            element.classList.add("sidebar-open");
            element.classList.remove("sidebar-collapse");
          }
        });
      },

		    handleCloseSearchBar(newValue) {
			    this.showSearchBar = newValue;
		    }
	   	},

		components : {

			'language-dropdown' : AgentLang,

			'inapp-notification' : InAppNotification,

			'application-updates' : ApplicationUpdates,

			'global-search' : GlobalSearch,

			ReuseLoader
		}
	};
</script>
<style scoped>
.model-box {
  margin-top: 8px !important;
  padding-top: 9px !important;
  width: 178px !important;
  height: 82px !important;
  background-color: #4f5962;

}

.dp-data {
  color: #c2c7d0;
}

.dp-data:hover {
  background-color: #717985;
  color: white;
}

.fa-user {
  margin-right: 1px;
}

.navbar-nav > .user-menu .user-image {
  height: 28px !important;
  width: 28px !important;
  margin-left: 4px;
  margin-top: -4px;
  margin-right: -10px;

}

.dropdown-menu-arrow::before {
  content: "" !important;
  position: absolute !important;
  top: -10px !important;
  left: 88%;
  transform: translate(-50%);
  border-width: 3px 7px 8px;
  border-style: solid;
  border-color: transparent transparent #3e4d5d;
}

.user-info:hover {
  background-color: #eaecf4;

}

.menu-box {
  margin-top: 8px;
  left: -4px;
}

.top-dropdown-menu {left: 0px; right: inherit;}
</style>