<template>
  
    <div>
    
        <meta-component :dynamic_title="lang('registration-page-title')" :dynamic_description="lang('registration-page-description')" :layout="layout">
      
        </meta-component>

        <div class="row">

            <div v-show="userInfo" id="content" class="site-content col-md-12">

                <article class="hentry">

                    <div id="form-border">
              
                        <section id="section-categories" class="section">

	                        <h2 class="section-title h4 clearfix mb-3">

		                        <i class="line" :style="lineStyle"></i>{{lang('register')}}
	                        </h2>

						    <div class="row">
			
			                    <faveo-form-client-panel panel="client" category="requester" :inputStyle="inputStyle" :redirectPath="redirectPath" :layout="layout"></faveo-form-client-panel>
						    </div>
	                    </section>
                    </div>
                </article>
            </div>
        </div>
    </div>
</template>

<script>

	import { mapGetters } from 'vuex';
	
	import FaveoFormClientPanel from "../../FaveoFormClientPanel.vue";

	export default {
		
		/**
		 * Props passed to the component:
		 * - layout: Object defining the layout configuration. Default is an empty object.
		 * - auth: Object containing authentication data. Default is an empty object.
		 */
	    props : {
	        layout : { type : Object, default : ()=>{}},
	        auth : { type : Object, default : ()=>{}}
	    },
		
		/**
		 * Data properties for the component:
		 * - user_data: Holds user data.
		 * - system: Holds system data.
		 * - loading: Indicates whether data is being loaded.
		 * - color: Holds loader color information.
		 * - size: Specifies the size of an loader element.
		 * - layout_data: Holds layout configuration data.
		 * - allow_register: Indicates whether registration is allowed.
		 * - allow_create_ticket: Indicates whether ticket creation is allowed.
		 * - redirectPath: Holds the path to redirect to.
		 * - status: Holds kb status information.
		 * - lineStyle: Style object for border color, derived from layout configuration.
		 * - buttonStyle: Style object for button appearance, derived from layout configuration.
		 * - inputStyle: Style object for input field appearance, derived from layout configuration.
		 */
		data() {
		    return {
				user_data: "",
		        system: null,
		        loading: false,
		        color: "",
		        size: 50,
		        layout_data: "",
		        allow_register: "",
		        allow_create_ticket: "",
		        redirectPath: {route: '/auth/login', text: 'go_to_login'},
				status: "",
		        lineStyle: {
		            borderColor : this.layout.portal.client_header_color,
		        },
		        buttonStyle : {
		            borderColor : this.layout.portal.client_button_border_color,
			        color : this.layout.portal.client_button_font_color + ' !important',
		            backgroundColor : this.layout.portal.client_button_color,
		        },
			    inputStyle: {
					borderColor: this.layout.portal.client_input_field_color,
			    }
		    }
		},
		
		/**
		 * Lifecycle hook executed before the component is mounted.
		 * It checks if user registration is allowed and if user data is available.
		 * If either condition is not met, it redirects the user to the homepage.
		 */
	    beforeMount(){
	
	        if(!this.layout.user_registration.status || !Array.isArray(this.auth.user_data)){
	      
	            this.$router.push('/')
	        }
	    },

		computed: {
			
			...mapGetters(['showLoader']),
		
		    /**
		     * @return {Object} return user details from vuex store
		     */
		    userInfo() {
		    
		        if (this.$store.getters.getUserData) {
		    
		            this.userDetails(this.$store.getters.getUserData);
		        
					return this.$store.getters.getUserData;
		        }
		    }
		},
		
        methods: {
		    /**
		     * getting user details from vuex store
		     * @param  {Object} user data from vuex
		     * @return {Void}
		     */
		    userDetails(user) {
		    
				this.user_data = user.user_data;
		  
				if (this.user_data.length != 0) {
		            this.$router.push({ name: "Home" });
		        }
		    },

		    /**
		     * getting layout details from vuex store
		     * @param  {Object} layout - layout details from vuex store
		     * @return {Void}
		     */
		    layoutDetails() {
			    this.layout_data = this.layout;
			    this.color = this.layout_data.portal.client_header_color;
			    this.allow_register = this.layout_data.user_registration.status;
			    this.allow_create_ticket = this.layout_data.allow_users_to_create_ticket.status;
			    this.status = this.layout_data.kb_settings.status;
			    this.system = this.layout_data.system.status;
		    }
        },

        components: {
			'faveo-form-client-panel': FaveoFormClientPanel
        },
	};
</script>
