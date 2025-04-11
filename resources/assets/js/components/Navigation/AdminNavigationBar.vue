<template>
  	
  	<navigation-layout :auth="auth" :from="from" :key="counter">
	
		<nav class="mt-2" style="margin-bottom: 60px">
			
			<div v-if="loading" class="admin-navigation">

				<reuse-loader :size="40"></reuse-loader>
			</div> 

			<ul class="nav sidebar-menu nav-pills nav-sidebar flex-column nav-child-indent" data-lte-toggle="treeview"  role="menu"
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

  		name : 'admin-navigation-bar',

  		description : 'Admin Navigation Bar on admin panel',

  		props : {

			auth : { type : Object, default : ()=>{}},

			from : { type : String, default : '' }
		},

  		data(){

	 		return {

				navigationArray : [],

				loading: true,

				counter : 0
	  		}
  		},

		watch : {

			$route(to, from){

				this.counter += 1;
			}
		},

 		created() {

	 		window.emitter.on('updateSideNav', this.refreshSidebar);
  		},

  		beforeMount(){
			// this.loading = true;

			this.getDataFromServer();
  		},

  		methods:{

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

			axios.get("/api/admin/navigation").then(res => {

				this.loading = false;

		  		this.navigationArray = res.data.data

				this.navigationArray.forEach(obj=>{

					if(!obj.main_navigation){

						obj.navigations.forEach(data=>{
							data['open_new_tab'] = true;
						})
					}
				})

			}).catch(err => {

				this.loading = false;

		  		errorHandler(err);

			});
	 	}
  	},

  	components: {

		'navigation' : Navigation,

	 	'navigation-layout' : NavigationLayout,
  	},
};
</script>

<style>

	.admin-navigation{
	    margin-top : 200px !important;
	  }
</style>
