<template>
	<ol class="breadcrumb breadcrumb-custom" :class="{crumb_align : language === 'ar'}">
		
		<template v-if="layout.is_enabled_breadcrumb">

			<li class="text" :class="{text_align : language === 'ar'}"> {{lang('you_are_here')}} :&rlm;</li>

			<li  v-for="crumb in label.meta.breadcrumb">

				<router-link v-if="crumb.to" :to="crumb.to" class="color">{{ lang(crumb.text) }}</router-link>
	      
	      <a v-else class="text1">{{ lang(crumb.text) }}</a>

			</li>

			<template v-if="label.meta.view">

				<li  v-for="crumb in catCrumb">

					<router-link :to="'/category-list/'+crumb.slug" class="color">{{ crumb.name }}</router-link>
		      
				</li>
			</template>

			<li v-if="label.meta.page && categories.length > 0">

	      <router-link :to="'/category-list/'+categories[categories.length-1].slug" class="text-capitalize">
		      {{ lang(categories[categories.length-1].name)  }}
		    </router-link>
	    </li>

	    <li v-if="label.meta.page && categories.length > 0 && label.params.slug">
				<a class="text1 text-capitalize">{{name}}</a>
			</li>

			<li v-if="!label.meta.page && !label.meta.view && label.params.slug">
				<a class="text1 text-capitalize">{{label.params.slug}}</a>
			</li>
		</template>
	</ol>
</template>

<script>
	
	export default {

		name : 'client-panel-breadcrumbs',

		description : 'Client panel breadcrumbs component',

		props : {

			layout : { type : Object, default : ()=> {}},
		},

		data(){

			return {

				categories : [],

				name : '',

				articleData : '',

				language : this.layout.language,

				categoryCrumb : ''
			}
		},

		created() {

			window.emitter.on('articleDetailsLoaded',this.updateCrumb);

			window.emitter.on('categoryDetailsLoaded',this.categoryCrumbData);

		},

		computed : {

			label(){

				if(this.$route.meta.page && this.articleData){
	      		
	      		this.name = this.articleData.name;

	      		this.categories = this.articleData.categories;
	    		}

				return this.$route
			},

			catCrumb() {

				return this.categoryCrumb;
			}
		},

		methods : {

			categoryCrumbData(category) {
				
				this.categoryCrumb = category;
			},

			updateCrumb(article) {

				this.articleData = article
		   }
		}
	};
</script>

<style scoped>
	
	.breadcrumb{
		background-color: transparent !important;
		padding: 0 !important;
		margin-top: 10px !important;
    word-break: break-all;
	}
	.color {
		color : #fff !important;
	}

	.text1{
    font-weight: 400 !important;
    color: #ffc !important;
  }

  .crumb_align{
  	text-align: right;
  	direction: rtl;
  }

  .text_align {
  	float: right;
  	padding-right: 0em;
    padding-left: 1em;
  }
</style>