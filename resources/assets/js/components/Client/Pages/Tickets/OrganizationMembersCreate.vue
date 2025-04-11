<template>

<div>
	
	<meta-component :dynamic_title="mode === 'edit' ? trans('edit-user-title') : trans('create-user-title')"
        :dynamic_description="mode === 'edit' ? trans('edit-user-description') : trans('create-user-description')"
        :layout="layout" >
	
	</meta-component>
	
	<div class="row">
		
		<div id="content" class="site-content col-md-12">
			
			<article class="hentry">
				
				<div id="form-border" class="comment-respond form-border" style="background : #fff">
					
					<section id="section-categories" class="section">
						
						<h2 class="section-title h4 clearfix mb-1">
							
							<i class="line" :style="lineStyle"></i>{{ mode === 'edit' ? trans('edit_user') : trans('create_user') }}
						</h2>
						
						<div class="row">
							
							<faveo-form-client-panel panel="client" category="requester" :inputStyle="inputStyle" :layout="layout"
	                            :scenario="mode === 'create' ? 'create_organization_user' : mode" :showOrgField="true"
                                :editApiEndpoint="mode === 'create' ? '' : '/client/organizations/edituser/'+userFormId" :editId="userFormId">
								
							</faveo-form-client-panel>
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
import {getIdFromUrl} from "../../../../helpers/extraLogics";

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
	 * - lineStyle: Style object for border color, derived from layout configuration.
	 * - inputStyle: Style object for input field appearance, derived from layout configuration.
	 */
	data() {
		return {
			lineStyle: {
				borderColor : this.layout.portal.client_header_color,
			},
			inputStyle: {
				borderColor: this.layout.portal.client_input_field_color,
			},
			userFormId: ''
		}
	},
	
	/**
	 * Lifecycle hook executed before the component is mounted.
	 * It checks if user registration is allowed and if user data is available.
	 * If either condition is not met, it redirects the user to the homepage.
	 */
	beforeMount(){
		
		if(Array.isArray(this.auth.user_data)){
			
			this.$router.push('/')
		}
		
		const path = window.location.pathname
		
		this.userFormId = getIdFromUrl(path)
	},
	
	computed: {
		
		/**
		 * Computed property to determine the mode of the component:
		 * - Returns 'edit' if the current path contains 'edit', otherwise returns 'create'.
		 */
		mode () {
			
			return this.currentPath().indexOf('edit') !== -1 ? 'edit' : 'create'
		},
		
		...mapGetters(['showLoader']),
	},
	
	components: {
		
		'faveo-form-client-panel': FaveoFormClientPanel
	},
};
</script>
