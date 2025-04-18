<template>

	<div id="category_data">
			
		<div v-if="loading || !hasDataPopulated" class="row" style="margin-top:30px;margin-bottom:30px">
			
			<client-panel-loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
		</div>
			
		<div v-if="pageChange" class="row">

			<client-panel-loader :color="layout.portal.client_header_color" :size="60"></client-panel-loader>
		</div>

		<alert componentName="categoryDetails"/>

		<div v-if="hasDataPopulated && !not_found" class="row">
					
			<meta-component :dynamic_title="categoryName" :dynamic_description="lang('categories_lists-page-description')"
				:layout="layout">
						
			</meta-component>

			<div id="content" :class="{float1: lang_locale == 'ar'}" class="site-content col-md-9">

				<header class="archive-header" :class="{align1: lang_locale == 'ar'}">
						
					<h1 class="archive-title">{{categoryName}}</h1>
				</header>

				<div v-if="childrenList.length" class="row col-md-12">

					<template v-for="child in childrenList">
						
						<div class="col-md-6 col-sm-12 col-xs-12">

							<section class="box-categories">

								<ul id="list" class="fa-ul">

									<li>

										<span :class="{align1: lang_locale == 'ar'}" 
											class="box_child">

											<i :class="{art:lang_locale=='ar'}" 
												class="fa-li fas fa-folder-open fa-fw text-muted pe-1">
													
											</i> 

											<router-link  
												:to="{ name:'Category', params:{slug:child.slug} }" 
												:title="child.name">
												{{subString(child.name)}}
											</router-link>
										</span>
									</li>
								</ul>
							</section>
						</div>
					</template>
				</div>
				
				<div v-if="articleList" class="archive-list archive-article" >
				
					<article :class="{article : lang_locale == 'ar'}" class="hentry" v-for="article in articleList">
				
						<header class="entry-header" :class="{align1: lang_locale == 'ar'}">
				
							<i :class="{float1: lang_locale == 'ar'}" class="fa fa-list-alt fa-2x fa-fw float-start text-muted">
								
							</i>
				
							<h2 class="entry-title h4">
				
								<router-link :class="{art_name: lang_locale == 'ar'}" :style="linkStyle"  id="kb_categorydata_article_link"
									:to="{ name:'Articles', params:{slug:article.slug} }">{{article.name}}
								</router-link>
							</h2>
						</header>
								
						<blockquote :class="{art_design: lang_locale =='ar'}" class="blockquote archive-description" id="block">
								
							<p v-html="stripTags(article.summary)" id="p_tag"></p>
							
							<a>

								<router-link  :to="{ name:'Articles', params:{slug:article.slug} }" :style="linkStyle" id="kb_category_redmore_link">
									{{ lang('read_more') }}
								</router-link>
							</a>
						</blockquote>   
								
						<footer :class="{'art_name align1': lang_locale == 'ar'}" class="entry-footer">
								
							<div class="entry-meta text-muted">

								<span class="date"><i class="far fa-clock fa-fw pe-1"></i>&nbsp;

									<span :class="{date_align : lang_locale === 'ar'}"> {{formattedTime(article.publish_time)}}</span>
								</span>
							</div>
						</footer>
					</article>
				</div>
						
				<div v-else class="archive-list archive-article" >
						
					<p style="text-align:left">{{lang('no_articles')}}</p>
				</div>

				<div :class="{left: lang_locale == 'ar'}" v-if="records > 10" class="float-end">
				
					<uib-pagination :records="records" v-model="pagination" class="pagination" :boundary-links="true" :per-page="perpage" :options="{chunk:3, chunksNavigation:'scroll'}" @paginate="pageChanged()">
								
					</uib-pagination>
				</div>
			</div>

			<div id="sidebar" :class="{left: lang_locale == 'ar'}" class="site-sidebar col-md-3">

				<category-sidebar :layout="layout" :categoryList="sidebarList" :categorylength="sidebarCount" 
					classname="col-md-12 col-sm-12 col-xs-12"/>
			</div>
		</div>
	</div>
</template>
<script>
	
	import axios from 'axios'
	
	import { findObjectByKey, getSubStringValue } from '../../../../helpers/extraLogics'
	
	import { mapGetters } from 'vuex'

    import KbCategorySidebar from "./KbComponents/KbCategorySidebar.vue";
	
	export default {
		
		name : 'kb-category-details',

		description : 'Knowledgebase category details component',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}}
		},
		
		data() {
			
			return {
				
				CategoryId:0,
			
				categoryName : '',

				articleList:[],

				childrenList : [],

				sidebarCount :0,
				
				sidebarList : [],
				
				loading : true,
			
				perpage:0,
				
				pagination:1,
				
				records:0,
				
				lang_locale : this.layout.language,
				
				kb_status : this.layout.kb_settings.status,

				not_found : false,

				hasDataPopulated : false,

				pageChange : false,

				linkStyle : {

					 color : this.layout.portal.client_header_color
				}
			}
		},
		
		beforeMount() {
		
			if(this.kb_status){
				
				this.categoryDetails();

			} else {

				this.$router.push({name:'Home'})
			}
		},
		
		computed:{
		
			...mapGetters(['formattedTime','formattedDate'])
		},

		methods:{
		
			subString(value){
			
				return getSubStringValue(value,30)
			},

		categoryDetails(){

			this.$Progress.start();
			
			axios.get('api/category-list-with-article-count').then(response=> {
		
				this.sidebarList = response.data.data.categories;
			
				this.sidebarCount = this.sidebarList.length;

				const path=location.pathname.split('/');
			
				let categorySlug = path[path.length-1];
			
				this.category = findObjectByKey(response.data.data.categories, 'slug', categorySlug);
				
				if(this.category){

					this.CategoryId = this.category.id;

					const data = 'page=' + this.pagination;

					this.categoryApi(data);
				} else {

					this.not_found = true;

					this.$Progress.fail();
				
					this.loading=false;

					this.pageChange = false;

					this.hasDataPopulated = true;
					
					this.$store.dispatch('setAlert', {
 						type: 'danger', 
 						message: 'Category not found.', component_name : 'categoryDetails'
 					});
				}

				this.$Progress.finish();

			}).catch(res=>{
				
				this.$Progress.fail();
				
				this.loading=false;

				this.hasDataPopulated = true;
			})
		},

		categoryApi(x){

			this.$Progress.start();
			
				axios.get('api/category-list/'+this.CategoryId+'?'+x).then(response => {
			
					this.$Progress.finish();
			
					this.loading = false;

					this.pageChange = false;

					this.hasDataPopulated = true;
			
					this.categoryName = response.data.data.category;
			
					this.articleList = response.data.data.article.data;

					this.childrenList = response.data.data.children;
			
					this.records = response.data.data.article.total;
			
					this.perpage = response.data.data.article.per_page;

					window.emitter.emit('categoryDetailsLoaded',response.data.data.breadcrumbs);
					
				}).catch(error=>{
				
					this.$Progress.fail();
				
					this.loading=false;

					this.pageChange = false;

					this.hasDataPopulated = true;
				})
		},

		stripTags (text) {

			if(text){

				if(text.length>25){

					return text.replace(/(<\/?(?:a|img)[^>]*>)|<[^>]+>/ig, '$1').substring(0,250) + '....';

				} else {

					return text;
				}
			}
		},

		pageChanged() {

			this.pageChange = true;

			this.pagination = this.pagination;

			const data = 'page=' + this.pagination;

			this.categoryApi(data);

			var elmnt = document.getElementById('category_data');
	  		
	  	elmnt.scrollIntoView({ behavior : "smooth"});
		}
	},

	components:{
		
		'category-sidebar': KbCategorySidebar
	},
};
</script>
<style scoped>
.date {
	margin-right:0px;
}
#head {
	margin-top:-22px;
}
.head_align{
	direction: rtl;
}
blockquote {
	font-size: 14px !important;
}

.article_align{
	padding-left: 0 !important;
  direction: rtl;
}
#block{
	margin-bottom: 10px !important;
	margin-top: 10px !important;
}
#block_link{
	text-decoration: underline;
}
#p_tag{
	word-wrap: break-word;
}
.date_align{
	margin-right: 0em !important
}

.box_child {
	text-align: left;
    font-size: 16px;
    font-weight: 600;
}
</style>