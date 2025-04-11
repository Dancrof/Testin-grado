<template>
	
	<div id="logo" :class="{float: layout.language == 'ar'}" class="navbar-brand brand site-logo text-center d-inline-block">

			<router-link  v-if="layout.company.use_logo == '1'" to="/" rel="home" id="client_logo_img">

				<img :src="layout.company.logo" alt="User Image" style="max-width: 300px; max-height: 127px;">
			</router-link>
			
			<router-link to="/" id="client_logo_title" v-else :style="[link_color !== 'null' ? {'color': link_color} : {'color': '#b00'}]">
				{{layout.system.name !== '' ? layout.system.name : 'SUPPORT CENTER'}}
			</router-link>
		</div>
</template>

<script>
	
	export default {

		name : 'client-panel-logo',

		description : 'Client panel logo component',

		props : {

			layout : { type : [Object, String], default : ()=>{}},
		},

		data() {

			return {

				link_color : ''
			}
		},

		beforeMount(){

			this.link_color = this.layout.portal.client_header_color
		}
	};
</script>

<style scoped>
	
	#client_logo_title {
		font-size: 32px !important;
		font-weight : 600 !important;
		text-decoration: none !important;
	}

	#logo{
		margin-bottom: 10px !important;
	}
</style>