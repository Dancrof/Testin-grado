<template>

	<navigation-layout :auth="auth" :from="from" :key="counter">

    <nav class="mt-2" style="margin-bottom: 60px">
			
			<div v-if="loading" class="agent-navigation">

				<reuse-loader :size="40"></reuse-loader>
			</div> 

			<ul class="nav sidebar-menu flex-column nav-pills nav-sidebar nav-child-indent" data-lte-toggle="treeview" role="menu"
				data-accordion="false">

				<!-- for loop from here itself -->
						
				<template v-for="(navigationCategory, index) in navigationArray">

					<li class="nav-header">{{navigationCategory.name.toUpperCase()}}</li>

					<template v-for="(navigation, index) in navigationCategory.navigations">
				              
				      <navigation v-if="navigation.name" :navigation="navigation" :key="navigation.name" :from="from">

				      </navigation>
				   </template>
				</template>
			</ul>
		</nav>
	</navigation-layout>
</template>

<script>

import axios from 'axios';

import { errorHandler } from "../../helpers/responseHandler";

import NavigationLayout from './NavigationLayout.vue';

import Navigation from "./Navigation.vue";

export default {
	
	name : 'agent-navigation-bar',

	description : 'Agent Navigation Bar on agent panel',

	props : {

		auth : { type : Object, default : ()=>{}},

		from : { type : String, default : '' }
	},

	data(){

		return {
			
			navigationArray : [],
			
			loading: true,

			counter : 0,

      refreshNav: false,
		 }
	},

	watch : {

		$route(to, from){
        
        this.counter += 1;
	   }
	},

	beforeMount(){

			window.emitter.on('refreshTicket', this.refreshSidebar);

			// if any piece of code requires sidebar to be updated,
			// they can simply fire this event
			window.emitter.on('updateAgentSidebar', this.refreshSidebar);

      // refreshes the component data when order in ticket navigation changes
      window.emitter.on('updateNavActive', ()=>{
        this.refreshNav = true;
      });

			// this.loading = true;

			this.getDataFromServer();
	},

	methods: {

		/**
		 * Gets data from server and populate in the component state
		 * NOTE: Making it a diffent method to improve readablity
		 * @return {Promise}
		 */
		refreshSidebar(){
			
			this.getDataFromServer();
		},

		/**
		 * Gets data from server and populate in the component state
		 * @return {Promise}
		 */
		getDataFromServer(){

			axios.get("/api/agent/navigation").then(res => {

				this.loading = false;

				this.navigationArray = res.data.data

        if(this.refreshNav){
          // sets active class not being added to the navigation according to active route while order changes
          setTimeout(()=>{
            this.counter += 1;
            this.refreshNav = false;
          }, 400);
        }

			}).catch(err => {

				this.loading = false;

				errorHandler(err);
			});
		}
	},

	components: {
	
		'navigation' : Navigation,
	
		'navigation-layout' : NavigationLayout
	}
};
</script>

<style>
	
	.agent-navigation{
	    margin-top : 200px !important;
	  }
</style>