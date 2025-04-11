<template>

		<div class="nav-tabs-custom" :class="{pro_align : language === 'ar' }">
			
			<meta-component :dynamic_title="lang('client-profile-title')" :layout="layout"
				:dynamic_description="lang('client-profile-description')" ></meta-component>

			<alert componentName="edit_profile"/>

			<alert componentName="faveo-form" />

			<ul class="nav nav-tabs">
			
				<li v-for="(tab,i) in tabs" class="nav-item">
			
					<a :id="'client_profile_tab_'+i" :class="{ active: current === tab.title, float1 : language === 'ar' }" 
					class="nav-link cur_tab" data-bs-toggle="tab" @click="onTabChange(tab.title)" href="javascript:;">
			
						{{lang(tab.title)}}
					</a>
				</li>
			</ul>
			
			<div class="tab-content">
			
				<div class="active tab-pane">
			
					<div :class="{'row' : current != 'login-logs' , 'mt-3' : current == 'login-logs'}">
						
						<component :is="currentTabComponent" :layout="layout" :inputStyle="inputStyle" :panel="panel" :btnStyle="btnStyle" :auth="auth" :userId="auth.user_data.id" alertName="edit_profile" :showBtn="true">
							
						</component>

					</div>
				</div>
			</div>
		</div>
</template>

<script>

	import EditProfile from "./ProfileComponents/EditProfile.vue";
    import ChangePassword from "./ProfileComponents/ChangePassword.vue";
    import TwoStepVerify from "./ProfileComponents/TwoStepVerify.vue";
    import LoginLogs from "../../Agent/Profile/LoginLogs.vue";

    export default{

		name : 'client-profile',

		description : 'Client profile component',

		props : {

			layout : { type : Object, default : ()=>{}},
			
			auth : { type : Object, default : ()=>{}},
		},

		data() {

			return {

				current : 'edit_profile',

				tabs : [{title:'edit_profile'},{title:'change_password'},{title:'2-step_verification'},{title:'login-logs'}],

				language : this.layout.language,

				btnStyle : {

					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				inputStyle: {

					borderColor : this.layout.portal.client_input_field_color,
				},

				lineStyle : { borderColor : this.layout.portal.client_header_color },

				linkStyle : { color : this.layout.portal.client_header_color },

				panel: 'client'

			}
		},

		computed : {

			currentTabComponent(){
        
          return this.current === 'edit_profile' ? 'edit-profile' : this.current === 'change_password' ? 'change-password' : this.current === '2-step_verification' ? 'two-step' : 'login-logs'
        
        }
		},

		methods : {

     		onTabChange(value) {

				this.$store.dispatch('unsetAlert');

				this.current = value;
			},
     },

		components : {

			'edit-profile' : EditProfile,
			
			'change-password' : ChangePassword,

			'two-step' : TwoStepVerify,

			'login-logs' : LoginLogs,
		}
	};
</script>

<style scoped>
	
	.cur_tab {

		cursor: pointer;
	}
	.pro_align{
		direction: rtl;
	}

	.mt-3 { margin-top: 1.5rem; }
</style>