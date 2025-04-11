<template>

		<div>
			
			<meta-component :dynamic_title="lang('home')" :dynamic_description="lang('home-page-description')" :layout="layout" >

			</meta-component>

			<div id="content" class="site-content col-md-12">

				<alert componentName="home"/>

				<widget-component :layout="layout" :auth="auth"></widget-component>

			</div>
		</div>
</template>
<script>

import WidgetBoxComponent from "../ClientPanelLayoutComponents/WidgetBoxComponent.vue";

export default {
	
	name : 'home-page',

	description : 'Client panel home page Component',

	props : {

		layout : { type : Object, default : ()=>{}},

		auth : { type : Object, default : ()=>{}}
	},

	components:{

		'widget-component': WidgetBoxComponent
	}
};
</script>