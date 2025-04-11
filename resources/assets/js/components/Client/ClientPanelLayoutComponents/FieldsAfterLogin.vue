 <template>

	<li class="nav-item dropdown" :class="[{float: language == 'ar'},{'active': subIsActive('profile')}]">
		
		<a class="dropdown-toggle nav-link"  id="navbarDropdownProfile" role="button" data-bs-toggle=""
			aria-haspopup="true" 
			aria-expanded="false" href="javascript:;" :class="{'active': subIsActive('profile')}">{{ lang('my_profile') }}

		</a>
		
		<ul class="dropdown-menu" :class="{nav_dropdown : language == 'ar'}" role="menu" 
			aria-labelledby="dropdownMenu">
		
			<li>
				
				<div class="banner-wrapper user-data text-center clearfix" id="profile_dropdown">

					<faveo-image-element id="user_avatar" :source-url="image" :classes="['avatar']" alternative-text="User Image" :img-width="70" :img-height="70"/>

					<div><strong>{{lang('hello')}}</strong></div>
					
					<p class="banner-title ellipsize_first_name h4" :title="first_name">{{first_name}}</p>
					
					<div class="banner-content" id="dropdown_content">
						
						<button class="btn btn-custom btn-sm text-white profile_btn" :style="buttonStyle" @click="logout()" id="client_logout">
							{{ lang('log_out') }}

						</button>

						<router-link v-if="role=='user'" to="/client-profile" :style="buttonStyle" id="client_profile"
							class="btn btn-custom btn-sm text-white profile_btn">{{ lang('profile') }}
						</router-link>

						<a v-else class="btn btn-custom btn-sm text-white profile_btn" :href="basePath() + '/panel/dashboard'" 
							:style="buttonStyle" id="client_dashboard"> 
							{{ lang('dashboard') }}
						</a>
					</div>
				</div>
			</li>
		</ul>
	</li>
</template>

<script>

import axios from 'axios';

import FaveoImageElement from '../../../components/Common/FaveoImageElement.vue';

export default {

	props : { 

		layout_data : { type : Object, default : ()=>{}}, 

		auth : { type : Object, default : ()=>{}},

		language : { type : String, default : ''}
	},
	
	data () {
		return {

			buttonStyle : {
				
				backgroundColor: this.layout_data.portal.client_button_color,
				color : this.layout_data.portal.client_button_font_color + ' !important',
		    borderColor: this.layout_data.portal.client_button_border_color,
			},

			image : this.auth.user_data.profile_pic,
			
			role : this.auth.user_data.role,
			
			first_name : this.auth.user_data.first_name			
		}
	},

	created(){

		window.emitter.on('updateUserData',this.updateData)
	},

	methods: {

		subIsActive(input) {
		  
		  if(input === 'profile'){
		  	
		  	return this.$route.path === '/client-profile'; 		
		  }
		},

		updateData(data){

			this.image = data.profile_pic
			
			this.role = data.role
			
			this.first_name = data.first_name
		},

		logout(){

			this.$Progress.start();

			axios.post('/auth/logout').then(res=>{

				localStorage.setItem('redirectPath','');

				this.$Progress.finish();

				this.redirect('/');

			}).catch(error=>{

				this.$Progress.fail();

				this.redirect('/');
			})
		}
	},

	components: {
		'faveo-image-element': FaveoImageElement
	}
};
</script>
<style scoped>
	
	#dropdown_content{
		padding-top: 1rem;
		margin: 0 !important;
	}
	#user_avatar{
		border-radius: 35px;
		width: 70px;
    height: 70px;
	}
	#profile_dropdown {
     border: 1px solid transparent !important; 
  }
  #profile_dropdown:hover{
  	background: transparent !important;
  }
  .profile_btn{
  	padding: 3px !important;
    font-size: 10px !important;
  }
  .text-white:hover{
  	color: white !important;
  }
	.ellipsize_first_name {
		overflow: hidden;
		text-overflow: ellipsis;
	}
</style>