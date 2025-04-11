<template>

	<transition name="page" mode="out-in">

		<div id="categories">
			
			<meta-component :dynamic_title="lang('category-list-title')" :dynamic_description="lang('category-list-description')" :layout="layout">
				
			</meta-component>

			<div v-if="!showNoRecords" id="content cnt" class="site-content col-md-12">

				<category-box :layout="layout" classname="col-md-6 col-sm-12 col-xs-12" :onLoaded="getLength"/>
			</div>

			<div v-else>

				<h3 style="text-align:center">{{lang('no-data-to-show')}}</h3>
			</div>
		</div>
	</transition>
</template>
<script>

	import KbCategoryBox from "./KbComponents/KbCategoryBox.vue";

    export default {

		props : {

			layout : { type : Object, default : ()=>{}}
		},
		
		data() {
			
			return {
			
				showNoRecords : false,
				
				lang_locale : this.layout.language,
				
				kb_status : this.layout.kb_settings.status,
			}
		},

		beforeMount(){

			if(!this.kb_status){

				this.$router.push({name:'Home'})
			}
		},
		
		methods:{

			getLength(value) {

				this.showNoRecords = value ? false : true;
			}
		},

		components:{
			
			'category-box': KbCategoryBox,
		},
	};
</script>
<style scoped>
	#cnt {
		margin-top:-25px;
	}
</style>