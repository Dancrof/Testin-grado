<template>

	<nav id="navbar" class="site-navigation navbar navbar-expand-lg navbar-light">

		<client-panel-logo :layout="layout"></client-panel-logo>

		<button class="navbar-toggler custom-toggler" type="button"
			data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">

			<span class="fas fa-bars"></span>
		</button> <!-- collapse -->

		<div class="collapse navbar-collapse links" id="navbarSupportedContent">

			<ul class="navbar-nav navbar-menu site-navigate" :class="[(language === 'ar') ? 'me-auto float' : 'ms-auto']">

				<li class="nav-item" :class="[{'active': subIsActive('/')},{float: language == 'ar'}]">

					<router-link to="/" class="nav-link" id="client_header_home_link">{{ lang('home') }}

						<span class="sr-only">(current)</span>
						</router-link>
				</li>

				<li  class="nav-item"
					:class="[{'active': subIsActive('/create-ticket')},{float: language == 'ar'}]">

					<router-link to="/create-ticket" class="nav-link" id="client_create_ticket">{{ lang('submit_a_ticket') }}</router-link>
				</li>

				<li v-if="kb_status" class="nav-item dropdown" :class="[{'active': subIsActive('/knowledgebase')},{float: language == 'ar'}]">

					<router-link to="/knowledgebase" class="dropdown-toggle nav-link"  id="client_kb_link"
						role="button" data-bs-toggle="" aria-haspopup="true" aria-expanded="false">{{lang('knowledge_base')}}

					</router-link>

					<ul class="dropdown-menu" :class="{nav_dropdown : language === 'ar'}" role="menu"
						aria-labelledby="dropdownMenu">

						<li>

							<router-link  to="/category-list" :class="{align: language == 'ar'}" class="dropdown-item" id="client_kb_categories">
								{{lang('categories')}}

							</router-link>
						</li>

						<li>

							<router-link  to="/article-list" :class="{align: language == 'ar'}"  class="dropdown-item" id="client_kb_articles">
								{{ lang('articles') }}

							</router-link>
						</li>
					</ul>
				</li>

				<li v-if="kb_status && pages.length !== 0" class="nav-item dropdown" :class="[{'active': subIsActive('pages')},{float: language == 'ar'}]">

					<a class="dropdown-toggle nav-link" :class="{'active': subIsActive('pages')}"
						id="navbarDropdownPage" role="button"
						data-bs-toggle="" aria-haspopup="true" aria-expanded="false">{{lang('pages')}}
					</a>

					<ul class="dropdown-menu page-menu" :class="{nav_dropdown : language == 'ar'}" role="menu"
						aria-labelledby="dropdownMenu">

						<li v-for="page in pages">

							<router-link :to="{ name:'Pages', params:{slug:page.slug} }" :class="{align: language == 'ar'}"
								 class="dropdown-item" :id="'client_kb_page'+page.slug">{{subString(page.name)}}
							</router-link>
						</li>
					</ul>
				</li>

				<billing-menu v-if="isBillingEnabled" :layout="layout" :auth="auth" :language="language"></billing-menu>

				<li v-if="!Array.isArray(auth.user_data) && orgs.length > 0" class="nav-item dropdown" :class="[{'active': subIsActive('organizations')},{float: language == 'ar'}]">

					<a class="dropdown-toggle nav-link"  id="navbarDropdownOrg" :class="{'active': subIsActive('organizations')}"
						data-bs-toggle="" aria-haspopup="true" aria-expanded="false" role="button">{{lang('organizations')}}
					</a>

					<ul class="dropdown-menu page-menu" :class="{nav_dropdown : language == 'ar'}" role="menu"
						aria-labelledby="dropdownMenu">

						<li v-for="org in orgs">

							<router-link :to="{ name:'Organizations', params:{org_id:org.id} }" :id="'client_org'+org.id"
								:class="{align: language == 'ar'}" class="dropdown-item">{{subString(org.name)}}
							</router-link>
						</li>
					</ul>
				</li>

				<li v-if="!Array.isArray(auth.user_data)" class="nav-item" :class="[{float: language == 'ar'},{'active': subIsActive('/mytickets',true)}]">

					<router-link to="/mytickets" class="nav-link" id="client_my_tickets">{{ lang('my_tickets') }}</router-link>
				</li>

				<field-after-login v-if="!Array.isArray(auth.user_data)" :layout_data="layout" :auth="auth"
					:language="language">

				</field-after-login>

				<li v-if="Array.isArray(auth.user_data)" class="nav-item" :class="[{float: language == 'ar'},{'active': subIsActive('/auth/login')}]">

					<router-link to="/auth/login" class="nav-link" id="client_login">{{ lang('login') }}</router-link>

				</li>

				<li class="nav-item dropdown" :class="{float: language == 'ar'}">

					<a class="dropdown-toggle nav-link"  id="navbarDropdownLang" role="button"
						data-bs-toggle="" aria-haspopup="true" aria-expanded="false">

						<img :src="url+'/'+ appVersion +'/themes/default/common/images/flags/'+language+'.png'" alt="no">

					</a>

					<ul class="dropdown-menu" :class="language == 'ar' ? 'nav_lang_dropdown' : 'lang_dropdown-menu'"
						role="menu" aria-labelledby="dropdownMenu" id="lang_ul">

						<li v-for="language in langSorted" :class="{float: language == 'ar'}">

							<a class="lang dropdown-item" :id="'client_lang_'+language.locale" @click="changeLang(language.locale)">

								<img :src="url+'/'+ appVersion +'/themes/default/common/images/flags/'+language.locale+'.png'" alt="no">

								&nbsp; {{ language.name }} &nbsp;&rlm;({{ language.translation }})&rlm;
							</a>
						</li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
</template>

<script>

	import { getSubStringValue } from '../../../helpers/extraLogics';

    import LoginComponent from '../../../components/Client/Pages/Auth/MiniComponents/LoginComponent.vue';

    import BillingMenu from '../../../components/Client/Billing/BillingMenu.vue';

    import BillingMobileMenu from '../../../components/Client/Billing/BillingMobileMenu.vue';

    import FieldsAfterLogin from './FieldsAfterLogin.vue';

    import Logo from '../../../components/Client/ClientPanelLayoutComponents/Logo.vue';

	export default {

		name : 'client-panel-navigation',

		description : 'Client panel navigation component',

		props : {

			layout  : { type : [String, Object], default :''},

			auth : { type : [String, Object], default : ''},
		},

		data(){

			return {

				navigation : [],

				language : '',

				create_ticket : false,

				base : '',

				url : '',

				pages : [],

				orgs : [],

				languages : [],

				key : '',

				local : '',

				isBillingEnabled: false

			}
		},

		computed : {

			langSorted() {

				return _.orderBy(this.languages, 'name', 'asc');
			}
		},

		watch : {

		},

		beforeMount(){

			this.language = this.layout.language;

			this.create_ticket = parseInt(this.layout.allow_users_to_create_ticket.status);

      this.$store.dispatch('setCreateTicket', this.layout.allow_users_to_create_ticket.status);

      this.base = this.auth.system_url;

			this.url = this.layout.cdn ? 'https://hermescdn.co.in': this.base;

			this.kb_status = this.layout.kb_settings.status;

			this.pages = this.layout.pages;

			this.orgs = this.layout.organization ? this.layout.organization : [];

			this.isBillingEnabled = this.layout.billing_settings.active;

			axios.get('api/dependency/languages?meta=true').then(response => {

				this.languages=response.data.data.languages;
			}).catch(error=>{});

			this.local = this.language;

			this.key = this.$route.fullPath;

			this.navigateTo();
		},

		created(){

		},

		mounted(){

			var superfish = document.createElement('script');

			superfish.type = 'text/javascript';

			superfish.src = this.basePathVersion()+'/themes/default/client/js/min/client.min.js';

			document.getElementsByTagName('head')[0].appendChild(superfish);

			var header_color = this.layout.portal.client_header_color;

			var style = document.createElement('style');

			style.type = 'text/css';

			style.innerHTML = '.navbar-nav>li>a.active,.navbar-nav>li>a:hover,.navbar-nav>li>a:focus,.site-navigation li > a:hover{border-top:0px !important; color:'+header_color+'!important;}';

			var border_top = document.createElement('style');

			border_top.type = 'text/css';

			border_top.innerHTML = '.navbar-nav>li.nav-item.active,.navbar-nav>li.nav-item:hover,.navbar-nav>li.nav-item:focus{border-top:3px solid '+ header_color +'!important; color:'+header_color+'!important;}';

			document.getElementsByTagName('head')[0].appendChild(style);

			document.getElementsByTagName('head')[0].appendChild(border_top);

			var link = document.createElement('link');

			link.rel = 'icon';

			link.href = this.layout.icon != null ? this.layout.icon : this.basePathVersion()+'/themes/default/common/images/favicon.ico';

			document.getElementsByTagName('head')[0].appendChild(link);
		},

		methods : {

			subIsActive(input,include=false) {
		   	
		   	let page_path = this.$route.path.split('/');

         if(include){

           return this.$route.path.includes(input)

         }

		   	if(input === 'pages'){

		  		return input === page_path[page_path.length-2] 		
		   	
		   	} else if(input === 'organizations'){

		   		return input === page_path[page_path.length-3]

		   	} else {
					
		   		return input === this.$route.path 

		   	}
		  
		  },
			changeLang(locale) {

				this.$Progress.start();

				axios.post('api/user-language?locale='+locale).then(res=>{
					
					this.$Progress.finish();

					window.location.reload();
				})
			},

			subString(value){
				
				return getSubStringValue(value,15)
			},

			languageTo(){

				this.changeLang(this.local)
			},

			navigateTo(){

				this.$router.push(this.key).catch(()=>{});
			}
		},

		components :{

			'login' : LoginComponent,

			'billing-menu' : BillingMenu,

			'billing-mobile-nav' : BillingMobileMenu,

			'field-after-login': FieldsAfterLogin,

			'client-panel-logo' : Logo

		}
	};
</script>

<style scoped>
	.dropdown-item.active, .dropdown-item:active {
    background-color: transparent !important;
	}
	.dropdown-toggle::after {
    display: none !important;
  }
	#login{
		top: auto !important;
    margin-top: 55px;
	}
	#lang_ul{
		width: max-content;
		font-size: unset !important;
		overflow-y: auto;
		min-height: 120px;
    	max-height: 500px;
	}

	#lang_ul::-webkit-scrollbar-track{
	    background-color: #f1f1f1;
	    border-radius:10px;
	}

	#lang_ul::-webkit-scrollbar{
	    width: 6px;
	    background-color: #f1f1f1;
	}

	#lang_ul::-webkit-scrollbar-thumb{
	    background-color: #c1c1c1;
	    border-radius: 10px;
	}
	
	.navbar-expand-lg {
    -ms-flex-flow: wrap !important;
    flex-flow: wrap !important;
    align-items: flex-start;
  }
	.lang_dropdown-menu {
		right : -1px !important;
		left : auto !important;
	}
	.lang{
		cursor: pointer;
	}
	.page-menu{
		max-height: 160px;
		overflow-y: auto;
	}
	.navbar-nav li {
    padding: 0px !important;
	}
</style>