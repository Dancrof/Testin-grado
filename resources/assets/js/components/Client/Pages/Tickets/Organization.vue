<template>

	<div>
			
		<meta-component :dynamic_title="lang('organizations-title')" :layout="layout"
			:dynamic_description="lang('organizations-description')" >
				
		</meta-component>

		<div v-if="loading">
								
			<loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
						
			<br>
		</div>

		<alert componentName="organization"/>

		<div class="row" v-if="!loading" :class="{align1: lang_locale == 'ar'}">
					
			<div class="col-md-4">
				
				<div class="widget-area">
					
					<section id="section-org" class="section">
						
						<h2 class="section-title h4 clearfix"><i class="line" :style="lineStyle"></i>{{lang('about')}}</h2>
						
						<div class="banner-wrapper text-center" id="org_about_wrap">

							<span class="fa-stack fa-3x">

								<i>
									
									<faveo-image-element id="org_img" :source-url="orgLogo" :classes="['img-circle pack_image']" 
										alternative-text="Org Image"/>
								</i>
							</span><br> 

							<h4 class="banner-title h3 banner_h3" :title="organization.name">{{subString(organization.name,20)}}
							</h4> 

							<div class="banner-content">

								<ul class="fa-ul with-line-border">
									
									<li v-if="organization.phone" :title="organization.phone">

										<i title="Phone" class="fa-li fa fa-phone text-muted" id="org_icon"></i>
										 {{subString(organization.phone,25)}}
									</li>
									
									<li v-if="organization.domain" :title="organization.domain">
										
										<i title="Domain" class="fa-li fa fa-globe text-muted" id="org_icon"></i> 
										{{subString(organization.domain,25)}}
									</li>
									
									<li v-if="organization.address" id="word_break">
										<i title="Address" class="fa-li fa fa-map-marker text-muted" id="org_icon"></i>{{organization.address}}
									</li>
									
									<li v-if="organization.internal_notes" id="word_break">

										<i title="Internal Notes" class="fa-li fas fa-sticky-note text-muted" id="org_icon"></i> {{organization.internal_notes}}
									</li>
								</ul>
							</div> 
						</div>
					</section>
				</div>

				<div class="widget-area">
					
					<section id="section-managers" class="section">
						
						<h2 class="section-title h4 clearfix"><i class="line" :style="lineStyle"></i>{{lang('managers')}}</h2>
						
						<div v-for="manager in managers" class="banner-wrapper text-center" id="org_managers_wrap">

							<span class="fa-stack fa-3x">

								<i>
									<faveo-image-element id="user_avatar" :source-url="manager.profile_pic" :classes="['img-circle', 'pack_image']"/>
								</i>
							</span><br> 

							<h4 class="banner-title h3 banner_h3" :title="manager.first_name + ' ' + manager.last_name">	
								{{subString(manager.first_name + ' ' +manager.last_name,25)}}
							</h4> 

							<div class="banner-content">

								<ul class="fa-ul with-line-border">
									
									<li :title="manager.mobile">

										<i title="Phone" class="fa-li fa fa-phone text-muted" id="org_icon"></i>
										 {{subString(manager.mobile !== 'Not available' ? manager.mobile : '--',25)}}
									</li>
									
									<li :title="manager.email">
										
										<i title="Email" class="fa-li fas fa-envelope text-muted" id="org_icon"></i> 
										{{subString(manager.email !== 'Not available' ? manager.email : '--',25)}}
									</li>
								</ul>
							</div> 
						</div>
					</section>
				</div>
			</div>
				
			<div class="col-md-8">
				
				<div class="widget-area" id="org_members">
					
					<section id="section-users" class="section">
						
						<h2 class="section-title h4 clearfix"><i class="line" :style="lineStyle"></i>{{lang('users')}}

							<router-link to="/create/user" :class="{left: lang_locale =='ar'}" 
								class="btn btn-custom btn-sm float-end org-user" :style="buttonStyle" id="client_org_user_create_link">
										
								<i class="glyphicon glyphicon-plus"></i> {{lang('create_user')}}
							</router-link>
						</h2>
						
						<div class="textwidget">
							
							<user-data v-if="org_id" :org_id="org_id" :layout="layout" :inputStyle="inputStyle" :auth="auth">
								
							</user-data>
						</div>
					</section>
				</div>

				<div class="widget-area">
					
					<section id="section-tickets" class="section">
						
						<h2 class="section-title h4 clearfix"><i class="line" :style="lineStyle"></i>{{lang('tickets')}}</h2>
						
						<div class="textwidget">
							
							<tickets-table v-if="org_id" :layout="layout" :inputStyle="inputStyle" :auth="auth" from="org" :orgId="org_id">
									
							</tickets-table>
						</div>
					</section>
				</div>
			</div> 
		</div>
	</div>
</template>
<script>
	
	import axios from 'axios'

	import { getSubStringValue } from '../../../../helpers/extraLogics';

	import { mapGetters } from 'vuex';
    import MyTicketsIndex from "./MyTicketsIndex.vue";
    import OrgMembers from "./MiniComponents/OrgMembers.vue";
    import FaveoImageElement from "../../../Common/FaveoImageElement.vue";

	export default {
	
		name : 'organization-view',

		description : 'Organization details page',

		props  : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}}
		},

		data() {
		
			return {
		
				base : this.auth.system_url,
		
				loading : true,
				
				organization : '',
				
				managers : '',
				
				user_id:'',
				
				org_id:'',
				
				lang_locale : this.layout.language,
				
				apiUrl : '',

				buttonStyle : {

					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color,
				},

				inputStyle: {
					borderColor : this.layout.portal.client_input_field_color,
				},

				lineStyle : {

					borderColor : this.layout.portal.client_header_color,
				},

				orgLogo : ''
			}
		},
		 components: {
				
			'tickets-table': MyTicketsIndex,
				
			'user-data': OrgMembers,

			'faveo-image-element': FaveoImageElement
		},

		computed : {

			...mapGetters(['formattedTime'])
		},

		beforeMount(){

			const path = location.pathname.split('/');

			this.org_id = path[path.length-1];

			this.user_id = path[path.length-2];

			this.apiUrl = '/api/mytickets/'+this.org_id;

			this.getData();
		},

		methods:{

			getData(){

				this.$Progress.start();

				axios.get('/organizations/data/'+this.org_id).then(res=>{

					this.$Progress.finish();

					this.loading = false;

					this.organization=res.data.data.organization;

					this.orgLogo = this.organization.logo ? this.organization.logo : this.basePathVersion()+'/themes/default/common/images/org.png';
					
					this.managers = res.data.data.organization.managers;
				
				}).catch(error=>{

					this.$Progress.fail();

					this.loading = false;

					this.$router.push({name:'Client Layout'})

				});
			},

			subString(value,length = 10){
				
				if(value){
					
					return getSubStringValue(value,length)
				} else {
					return '--'
				}
			}
		},
	};
</script>
<style scoped>
#client_org_user_create_link{
	margin-top: -10px;
}

.img-circle {
  border-radius: 50%;
}

.banner_h3{
  margin-top: 20px;
  word-break: break-word;
}
.pack_image{
  width: 100px !important;
  height: 100px !important;
  border: 2px solid #d4d1d1;
}
.banner-wrapper:hover {
  border-color: #fff !important;
}
#org_managers_wrap,#org_about_wrap{
	border: 0px solid #f39b93 !important;
  border-top-width: 0px !important;
  background-color: #f2f2f2 !important;
  margin-bottom: 30px;
}
#org_icon{
	color: black !important;
}
ol.with-line-border>li, ul.with-line-border>li {
    border-bottom: 1px solid #dddddd !important;
}
#word_break{
	word-break: break-all;
}

.org-user{
	padding: 0.25rem 0.5rem !important;
	font-size: .875rem !important;
	line-height: 1.5;
	border-radius: 0.2rem;
}
</style>