<template>
	
	<div class="article-index-box">

		<div class="timeline mt-20">

			<div id="article_div">
									
				<div class="timeline-item" id="article_item">
				  
				  <span class="time"><i class="far fa-clock"></i> {{publishDate(article.publish_time)}}</span>

				  <h3 class="timeline-header">

						<a :href="basePath()+'/show/'+article.slug" v-tooltip="article.name">{{article.name}}</a>

					  <popover arrow placement="right">

						 &nbsp; <i class="fas fa-question-circle cursor text-primary"  v-tooltip="lang('click_to_see_details')">

						  </i>

						  <template #content>

							  <div class="p-3">

								  <template v-if="article.author">

									  <strong><i class="fas fa-user me-1 mb-2"> </i> {{lang('author')}} </strong> &nbsp;

									  <p class="text-muted" v-tooltip="article.author.full_name ? article.author.full_name : article.author.user_name"> {{article.author.full_name ? article.author.full_name : article.author.user_name}}</p>

									  <hr>
								  </template>

								  <template v-if="article.categories.length > 0">

									  <strong><i class="fas fa-newspaper me-1 mb-2"> </i> {{lang('categories')}} </strong> &nbsp;

									  <p class="text-muted" v-for="(category,index) in article.categories.slice(0,20)" v-tooltip="category.name">

										  <i class="far fa-circle "> </i> {{subString(category.name,25)}}
									  </p>

									  <hr>
								  </template>

								  <template v-if="article.tags.length > 0">

									  <strong><i class="fas fa-tags me-1 mb-2"> </i> {{lang('tags')}} </strong> &nbsp;

									  <p class="text-muted" v-for="(tag,index) in article.tags.slice(0,20)" v-tooltip="tag.name">

										  <i class="far fa-circle "> </i> {{tag.name}}
									  </p>

									  <hr>
								  </template>
							  </div>
						  </template>
					  </popover>
					</h3>

					<div v-if="article.summary" class="timeline-body" v-html="article.summary"></div>

					<div v-else class="timeline-body" v-html="convert(article.description)"></div>
				  
				 	<div class="timeline-footer bt-1">
					
						<router-link :to="'/article/'+article.id+'/edit'" class="btn btn-xs btn-light text-dark" v-tooltip="lang('edit')">

							<i class="fas fa-edit"></i> {{lang('edit')}}
						</router-link>
					
						<a v-if="status" target="_blank" :href="basePath()+'/show/'+article.slug" class="btn btn-xs btn-light text-dark"
							@click="viewArticle(article.id)" v-tooltip="lang('view')">

							<i class="fas fa-eye"></i> {{lang('view')}}
						</a>
					
						<a href="javascript:;" class="btn btn-xs btn-light text-dark" @click="deleteMethod(article.slug)"
							v-tooltip="lang('delete')">

							<i class="fas fa-trash"></i> {{lang('delete')}}
						</a>

						<span :style ="{float : isRtl  ? 'left' : 'right'}">

							<a href="javascript:;" @click="pendingComments(article.id,article.name)" v-tooltip="lang('pending_comments')">

								<i class="far fa-comment-dots"></i>

								<span class="badge text-bg-danger article-badge">{{article.pending_comments_count > 9 ? '9+' : article.pending_comments_count }}</span>
							</a>&nbsp;&nbsp;

							 <a href="javascript:;" :class="{ 'rtl-padding': isRtl, 'ltr-padding': (!isRtl && article.pending_comments_count > 9) }"  @click="allComments(article.id,article.name)" v-tooltip="lang('total_comments')">
							
								<i class="far fa-comments ms-1"></i> ({{article.all_comments_count}}) {{lang('comments')}}
							</a>
						</span>
					</div>
				</div>
			</div> 
		</div>

		<transition name="modal">

			 <delete-modal v-if="showModal" :onClose="onClose" :showModal="showModal"
	        alert="ArticlesIndex" :apiUrl="'/article/delete/'+slug" :updateKb="updateKb">

	     </delete-modal>
		</transition>
	</div>
</template>
<script>

	import {useStore} from 'vuex'

  import {boolean, getSubStringValue} from "../../../../../helpers/extraLogics";

	import moment from 'moment'

	import {computed} from "vue";

	import KbDeleteModal from "../../KbDeleteModal.vue";
	export default {

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				timeFormat : computed(()=>store.getters.timeFormat)
			}
		},

		props : {

			article : { type : Object, default : () => {} },

			status : { type : [String, Number, Boolean], default : 1 },

			updateKb : { type : Function, default : ()=> {}}
		},

		data () {

			return {

				slug : '',

				showModal : false,

        isRtl: false,
			}
		},

		created(){

			this.$store.dispatch('commentFilterData',{});

      // getting is_rtl from sessionStorage
      this.isRtl = boolean(sessionStorage.getItem('is_rtl'));
		},

		methods: {

			publishDate(value) {

				if(value) {
					let utcFormat = new Date(value).toISOString();

					return moment(utcFormat).format(this.timeFormat)
				}
			},

			subString(value,length = 10){

				return getSubStringValue(value,length)
			},
	
			viewArticle(article) {
			
				this.$store.dispatch('setArticleId', article);
			},

			deleteMethod(value) {

				this.slug = value;

				this.showModal = true;
			},

			onClose() {

				this.showModal = false;
			},

			// showing only 250 characters in article description
			convert(x) {
		
				if(x){
				
					if(x.length>250){
					
						return x.replace(/(<\/?(?:a|p|blockquote)[^>]*>)|<[^>]+>/ig, '').substring(0,250) + '....';
			 	
			 		} else {
					
						return x.replace(/(<\/?(?:a|p|blockquote)[^>]*>)|<[^>]+>/ig, '');
					}
				}
			},

			allComments(id,name){
		
				const data = {to:'all',id:id ,name:name}
		
				this.$store.dispatch('commentFilterData',data);

				this.$router.push({ path:'/article/comment', name: 'KB Article Comments',params: { from: data }});
			},
		
			pendingComments(id,name){
		
				const data = {to:'unapprove',id:id ,name:name}
		
				this.$store.dispatch('commentFilterData',data);

				this.$router.push({ path:'/article/comment',name: 'KB Article Comments',params: { from: data }});
			}
		},

		components : {

			'delete-modal' : KbDeleteModal
		}
	};
</script>

<style scoped>

	#article_item { 
	/*	box-shadow: none !important;
    	border-top: 1px solid #dee2e6;
    	border-bottom: 1px solid #dee2e6;
    	border-radius: 0; */
    	margin-left: 2px !important;  margin-right: 4px!important; 
	}

	.bt-1 { border-top: 1px solid #dee2e6!important; }

	#article_div { margin-bottom: 0 !important; margin-right: 0 !important; }

	.article-badge {
		font-size: 0.6rem;
		font-weight: 300;
		position: absolute;
		margin-left: -5px;
		padding: .25em .4em;
		margin-top: -4px;
	}

	.cursor { cursor: pointer; }

	.mt-20 { margin-bottom: 20px !important; }

  .rtl-padding {
    padding-right: 7px;
  }
  .ltr-padding {
    padding-left: 1px;
  }
</style>