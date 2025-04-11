<template>

	<li v-if="!navigation.hasChildren" class="nav-item">
	
		<template v-if="navigation.routeString != 'panel/dashboard' && navigation.routeString != 'admin/home' &&
		navigation.routeString != 'client/home' && navigation.routeString != 'auth/logout' && navigation.routeString != 'horizon' &&
		 navigation.routeString != '__clockwork/app' && navigation.routeString != 'service-desk/agent-software/settings' && navigation.routeString != 'pulse'">
			
			<a v-if="navigation.open_new_tab" :class="['nav-link',{'active active-navigation-element' : active}]"
			             :href="basePath()+'/admin'+getLink(navigation)" @click="onNavigationClick(navigation)">
				
				<i :class="'nav-icon '+navigation.iconClass"></i>
				
				<p v-tooltip="tooltipContent"> {{(navigation.hasCount) ? subStr(navigation.name,16) :  subStr(navigation.name,20)}}
					
					<span v-if="boolean(navigation.hasCount)" class="nav-badge badge text-bg-success float-end"  id="nav_count">

                        {{navigation.count}}
				    </span>
				</p>
			</a>
			
			<router-link v-else :class="['nav-link',{'active-navigation-element active' : active}]"
			             :to="getLink(navigation)" @click.native="onNavigationClick(navigation)">

        <!-- If the navigation route string is 'elea/settings', it renders the custom SVG icon -->
          <svg-icon-handler v-if="navigation.routeString === 'elea/settings'" hover-color="#C2C7D0" color="#C2C7D0"
                            StyleCss="me-1" height="20" width="20" icon-from="elea_icon" />

        <!-- Otherwise, it renders a standard icon with the specified class -->
				  <i v-else :class="'nav-icon '+navigation.iconClass"></i>

				<p v-tooltip="tooltipContent"> {{(navigation.hasCount) ? subStr(navigation.name,16) :  subStr(navigation.name,22)}}

					<span v-if="boolean(navigation.hasCount)" class="nav-badge badge text-bg-success float-end" id="nav_count">

                        {{navigation.count}}
				    </span>
				</p>
			</router-link>
		</template>

    <a v-else-if="navigation.routeString == 'service-desk/agent-software/settings'" href="javascript:;" :class="['nav-link',{'active active-navigation-element' : active}]" @click="isValidLicense()">

      <i :class="'nav-icon '+navigation.iconClass"></i>

      <p v-tooltip="tooltipContent"> {{(navigation.hasCount) ? subStr(navigation.name,16) :  subStr(navigation.name,22)}}

        <span v-if="boolean(navigation.hasCount)" class="nav-badge badge text-bg-success float-end" id="nav_count">

          {{navigation.count}}
        </span>
      </p>
    </a>
		
		<a v-else :class="['nav-link',{'active active-navigation-element' : active}]"
			:href="getLink(navigation)" @click="onNavigationClick(navigation)">

			<i :class="'nav-icon '+navigation.iconClass"></i>

			<p v-tooltip="tooltipContent"> {{(navigation.hasCount) ? subStr(navigation.name,16) :  subStr(navigation.name,22)}}

				<span v-if="boolean(navigation.hasCount)" class="badge rounded-pill badge-bg-success float-end" id="nav_count">

                    {{navigation.count}}
				</span>
			</p>
		</a>
	</li>

	<li v-else :class="['nav-item has-treeview',{'menu-open' : menuOpened}]">

		<a href="javascript:;" :class="['nav-link',{'active' : active}]" id="nav_child" v-on:click.stop="onNavigationClick(navigation)">

			<i :class="'nav-icon '+navigation.iconClass"></i>

			<p v-tooltip="tooltipContent">{{navigation.name.length > 22 ? subStr(navigation.name,22) : navigation.name}}

				<i class="nav-arrow fas fa-angle-left"></i>
			</p>
		</a>

		<ul class="nav nav-treeview" :class="[{'displayMenu' : menuOpened, 'hideMenu' : !menuOpened}]">

			<navigation v-for="(nav, index) in navigation.children" :navigation="nav" :key="index"
				:toggleParent="toggleActive" :from="from">

			</navigation>
		</ul>
	</li>

  <transition name="modal">
    <!-- Agent License Modal component with showModal prop and onClose event -->
    <agent-license-modal :showModal="showLicenseModal" :onClose="()=>{this.showLicenseModal = false}"/>
  </transition>
</template>

<script>

import axios from "axios";

import { boolean, getSubStringValue } from "../../helpers/extraLogics";
import AgentLicenseModal
  from "../../../../../app/Plugins/ServiceDesk/views/js/components/Admin/AgentSoftware/AgentLicenseModal.vue";
import {errorHandler} from "../../helpers/responseHandler";
import SvgIconHandler
  from "../../../../../app/Plugins/EleaAssistant/views/js/components/miniComponent/SvgIconHandler.vue";

export default {

	name : 'navigation',

  components: {
    'agent-license-modal' : AgentLicenseModal,
    'svg-icon-handler' : SvgIconHandler,
  },

	props:{

		navigation : { type : Object, default :()=>{}},

		toggleParent : {type : Function, default : ()=>{} },

		from : { type : String, default : '' }
	},

	data(){

		return {

			menuOpened : false,

			active : false,

      showLicenseModal: false
		}
	},

	mounted(){

    	this.markNavigationActiveIfRequired()
  	},

	methods : {

		/**
     	* Marks active and menuOpened as true.
     	* NOTE: this method is passed to children so that chilren can call this method and mark parent as active
     	* @return {undefined}
     	*/
    	toggleActive(){

      	this.active = true;

      	this.menuOpened = true;

      	this.toggleParent();
    	},

		isActive(navigation){

			if(this.getCurrentRouteUrl() == navigation.redirectUrl ){

				return true
			}
		},

		/**
		 * Redirects if has no child elements
		 * @param  {String} redirectUrl
		 * @return {String}
		 */
		onNavigationClick(navigation){

      if(navigation.redirectUrl && navigation.redirectUrl.includes('tickets?show')){

        window.emitter.emit('refreshTicketPage');
      }

			this.active = navigation.redirectUrl ? false : this.active;

			this.markNavigationActiveIfRequired();

			// for logout
			if(navigation.routeString == 'auth/logout'){

				axios.post('/auth/logout').then(res=>{

					 window.location.replace(res.data.data);

				}).catch(error=>{})
			}

		 // if hasChildren is false, then redirect
      	if(boolean(navigation.hasChildren)){

        		this.menuOpened = !this.menuOpened;
      	}
		},

		 /**
	     * Gets redirect link for the anchor tag
	     * @return {String}
	     */
	    getLink(navigation){

	      if(!boolean(navigation.hasChildren)){

			if(navigation.routeString == 'panel/dashboard' || navigation.routeString == 'admin/home' || navigation.routeString == 'client/home' || navigation.routeString == 'auth/logout' || navigation.routeString == 'horizon' || navigation.routeString == '__clockwork/app' || navigation.routeString == 'pulse') {

				return navigation.redirectUrl;

			} else {

				return navigation.redirectUrl ? navigation.redirectUrl.replace(this.basePath(), '') : '';

			}
	      }
	      return 'javascript:void(0);';
	    },

		/**
		 * Gets current url
		 * @return {String}
		 */
		getCurrentRouteUrl(){
			return window.location.href;
		},


		subStr(name,count) {
			return getSubStringValue(name,parseInt(count));
		},

		/**
	     * Checks if navigation is active, if yes mark that as active
	     * @return {undefined}
	   */
    	markNavigationActiveIfRequired(){
      	
      	if(this.getCurrentRouteUrl().replace('/panel','') == this.navigation.redirectUrl || this.getCurrentRouteUrl().replace('/admin','') == this.navigation.redirectUrl){

        		this.active = true;

        		this.toggleParent();
      	}
    	},

    async isValidLicense() {

      try {
        // Make an API call to check the license status
        const response = await axios.get('service-desk/license-status');

        // If the response status is 200, navigate to the agent software page and hide the license modal
        if (response.status === 200) {
          this.$router.push('/service-desk/agent-software');
          this.showLicenseModal = false;
        }
      } catch (error) {
        // If there is an error in the API call, show the license modal
        this.showLicenseModal = true;
      }
    }
	},

	watch : {

    	active(newVal){

      	if(newVal){
        	// waiting for the DOM to render completely so that active-navigation-element can be present
        		setTimeout(()=>{

          		let activeElements = document.getElementsByClassName('exact-active');

          		if(activeElements !== undefined && activeElements.length){

            		activeElements[activeElements.length - 1].scrollIntoView({behavior: "smooth", block: 'end'});

          		} else {

          			let exactElements = document.getElementsByClassName('active-navigation-element');

				       if(exactElements !== undefined){

				         exactElements[exactElements.length - 1].scrollIntoView({behavior: "smooth"});
				       }
          		}
        		},10)
      	}

      	return newVal;
    	}
  	},

  computed: {
    tooltipContent() {
      if ((this.navigation.hasCount && this.navigation.name && this.navigation.name.length > 16) || (!this.navigation.hasCount && this.navigation.name && this.navigation.name.length > 22)) {
        return this.navigation.name;
      }
      return '';
    }
  }
};
</script>

<style scoped>

	.displayMenu { display : block !important; }

	.hideMenu { display : none !important; }
</style>
