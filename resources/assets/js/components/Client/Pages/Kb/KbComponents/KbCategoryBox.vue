<template>
		
	<div>
		
		<div v-if="pageChange" class="row">

			<client-panel-loader :size="60" :color="layout.portal.client_header_color"></client-panel-loader>
		</div>

		<div v-if="!hasDataPopulated || loading">

			<h3 style="text-align : center">{{lang('loading_data')}}</h3><br>
		</div>

		<div class="row">

			<div v-if="hasDataPopulated" :class="[classname,{float1: lang_locale == 'ar'}]"  
				v-for="(category,index) in categoryList" :key="index">
				
				<section class="box-categories">
					
					<h1 class="section-title h4 clearfix" :class="{align1: lang_locale == 'ar'}">

						<i class="line" :style="lineStyle"></i>

						<i class="far fa-folder-open fa-fw text-muted pe-1"></i>
						

						<small :class="{left: lang_locale == 'ar'}" class="pull-right float-end">
			
							<router-link :to="{ name:'Category', params:{slug:category.slug} }" :style="linkStyle">

								<i class="far fa-hdd fa-fw"></i> ({{category.articles.length}})
							</router-link>
						</small>

						<router-link :title="category.name" :to="{ name:'Category', params:{slug:category.slug} }" 
							:style="linkStyle" :id="'kb_category_box_category_link-'+index">
								{{ subString(category.name) }}
						</router-link>	
					</h1>
					
					<ul v-if="category.articles.length || category.children.length" id="list" class="fa-ul">
						
						<li v-for="category in category.children">
							
							<h3 id="0" :class="{align1: lang_locale == 'ar'}" class="h5" style="text-align:left">
								
								<i :class="{art:lang_locale=='ar'}" 
									class="fa-li fas fa-folder-open fa-fw text-muted pe-1">
										
								</i>

								<router-link id="child_cat_name"  
									:to="{ name:'Category', params:{slug:category.slug} }" 
									:title="category.name">
									{{subStringChild(category.name)}}
								</router-link>
							</h3>
						</li>

						<li v-for="article in category.articles">
							
							<h3 :class="{align1: lang_locale == 'ar'}" class="h5 cat_box_art_name">
								
								<i :class="{art: lang_locale == 'ar'}" class="fa-li fa fa-list-alt fa-fw text-muted"></i>

								<router-link :to="{ name:'Articles', params:{slug:article.slug} }" 
									:title="article.name" :id="'kb_category_box_article_link_'+category.id+'_'+article.id">
									{{subStringChild(article.name)}}
								</router-link>
							</h3>
						</li>
					</ul>

					<ul v-else class="fa-ul" id="list">
						
						<li>
							
							<p :class="{align1: lang_locale == 'ar'}" style="text-align:left">{{lang('no_articles')}}</p>
						</li>
					</ul>
					
					<p class="more-link text-center">
								
						<router-link :to="{ name:'Category', params:{slug:category.slug} }" class="btn btn-custom btn-sm" 
							:style="buttonStyle" :id="'kb_category_box_view_all_'+index">{{ lang('view_all') }}
						</router-link>
					</p>
				</section>
			</div>
		</div>

		<div :class="[(lang_locale === 'ar') ? 'page_left' : 'kb_page']" v-if="records > 10 && loading === false">

			<uib-pagination :records="records" v-model="pagination" class="pagination" :boundary-links="true"
				:per-page="perpage" @paginate="pageChanged()" :options="{chunk:3, chunksNavigation:'scroll'}">
								
			</uib-pagination>
		</div>

		<div v-if="records > 10 && loading === false"><br><br><br><br></div>
	</div>
</template>

<script>

	import axios from 'axios'

	import { getSubStringValue } from '../../../../../helpers/extraLogics';
	
	export default {
	
		name : "category-box",

		description : "This component shows the category list with articles",
	
		props:{
			
			layout : { type : Object, default : ()=>{}},

			classname : { type:String, default : '' },

			onLoaded : { type : Function, default : ()=>{} }
		},

		data() {
		
			return {

				categories:{},

				categoryList:[],

				buttonStyle: {

					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				lineStyle: {

					borderColor : this.layout.portal.client_header_color,

					width : '35%'
				},

				linkStyle : {

					color : this.layout.portal.client_header_color
				},

				perpage:0,

				pagination:1,

				records:0,

				paramsObj:{},

				loading:true,

				hasDataPopulated : false,

				lang_locale : this.layout.language,

				sub_str_length:0,

				pageChange : false,
			}
		},
		
		created() {
		
			this.kbApi();
		},

		methods : {

			subString(value){
			
				return getSubStringValue(value,20)
			},

			subStringChild(value){
				
				if(this.$route.path === '/category-list'){

					return getSubStringValue(value,60)
				} else {

					return getSubStringValue(value,40)
				}
			},

			kbApi(x) {

				var params = x;
				
				this.$Progress.start();

				axios.get('api/category-list-with-articles',{params}).then(response => {
			
					this.loading=false;

					this.pageChange = false;

					this.hasDataPopulated = true;
				
					this.categories = response.data.data.categories;
				
					this.categoryList = response.data.data.categories.data;

					this.onLoaded(this.categories.total)

					for(let i in this.categoryList) {

						if(!this.categoryList[i].children.length) {

							this.categoryList[i].articles = this.categoryList[i].articles.splice(0,6)
						
						} else if(!this.categoryList[i].articles.length) {

							this.categoryList[i].children = this.categoryList[i].children.splice(0,6);
						
						} else {

							this.categoryList[i].children = this.categoryList[i].children.splice(0,3);

							this.categoryList[i].articles = this.categoryList[i].articles.splice(0,3);
						}
					}
				
					this.records =  this.categories.total;
				
					this.perpage = this.categories.per_page;
					
					this.$Progress.finish();

				}).catch(error=>{
			
					this.loading=false;

					this.pageChange = false;

					this.hasDataPopulated = true;

					this.$Progress.fail();
				})
			},

			pageChanged() {
				
				this.pageChange = true;

				this.paramsObj['page']=this.pagination;
				
				this.kbApi(this.paramsObj);

				var elmnt = document.getElementById('categories');
	  		
	  		elmnt.scrollIntoView({ behavior : "smooth"});
			},
		}
	};
</script>

<style scoped>
	
	.kb_page{
		float: right;
	}
	#list {
		min-height: 164px;
	}

	#catbox {
		margin-bottom : 50px !important
	}
	#catb{
		height:250px;
	}
	.box_align{
		direction : rtl;
	}
	.page_left {
			float: left;
		}
	#kb_category_box_category_link {
		text-decoration: none !important;
	}

	.cat_box_art_name { font-weight: 600;text-align:left; }
</style>