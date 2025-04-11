<template>

		<div class="article-comment-box">

		<div class="timeline">

			<div id="comment_div">
									
				<div class="timeline-item" id="comment_item">
				  
				  <span class="time mt-6px"><i class="far fa-clock"></i> {{formattedTime(comment.created_at)}}</span>

				  <h3 class="timeline-header">

				  		<faveo-image-element id="proimg" :source-url="comment.profile_pic" :classes="['img-circle img-bordered-sm img-rounder img-30']" alternative-text="User Image"/>

						<a href="javascript:;" v-tooltip="comment.name">&nbsp;{{comment.name}}&nbsp;</a>

						  <popover click arrow placement="right">

							  <i class="fas fa-question-circle cursor text-primary"  v-tooltip="lang('click_to_see_details')">

							  </i>

							  <template #content>

								  <div class="p-3">

									  <p>

										  <i class="fas fa-user"> </i>&nbsp;

										  <span href="javascript:;" v-tooltip="comment.name">{{subString(comment.name,25)}}</span>
									  </p>

									  <p>

										  <i class="fas fa-envelope"> </i>&nbsp;

										  <span href="javascript:;" v-tooltip="comment.email">{{subString(comment.email,25)}}</span>
									  </p>

									  <p v-if="comment.website != ''">

										  <i class="fas fa-globe"> </i>&nbsp;

										  <a :href="comment.website" target="_blank" v-tooltip="comment.website">

											  {{subString(comment.website,25)}}
										  </a>
									  </p>
								  </div>
							  </template>
						  </popover>
					</h3>

					<div class="timeline-body" :class="{ 'bg-comment' : !comment.status}">
						
						<h6>
							
							<i class="fas fa-newspaper"> </i>&nbsp;
							
							<a :href="basePath()+'/show/'+comment.article[0].slug" target="_blank">

								{{comment.article[0].name}} 
							</a>
						</h6>

						<p v-html="comment.comment"></p>
					</div>
				  
				 	<div class="timeline-footer bt-1">
						
						<a :disabled="isDisabled" @click="updateStatus(comment.id)"  class="btn btn-light btn-xs text-dark"
							v-tooltip="comment.status ? lang('unapprove') : lang('approve')" href="javascript:;">

							<i class="fas fa-check"></i> {{ comment.status ? lang('unapprove') : lang('approve')}} 
						</a>

						<a @click="viewArticle(comment.article[0].id)" target="_blank" class="btn btn-xs btn-light text-dark"
							:href="basePath()+'/show/'+comment.article[0].slug" v-tooltip="lang('view')">

							<i class="fas fa-eye"></i> {{lang('view')}} 
						</a>
						
						<a href="javascript:;" class="btn btn-xs btn-light text-dark" @click="deleteMethod(comment.id)"
							v-tooltip="lang('delete')">

							<i class="fas fa-trash"></i> {{lang('delete')}}
						</a>
					</div>
				</div>
			</div> 
		</div>

		<div class="row" v-if="loading">
				
			<custom-loader></custom-loader>
		</div>

		<transition name="modal">

			 <delete-modal v-if="showModal" :onClose="onClose" :showModal="showModal"
	        alert="CommentsIndex" :apiUrl="'/comment/delete/'+commentId">

	     </delete-modal>
		</transition>
	</div>
</template>
<script>

	import {useStore} from 'vuex'

	import { getSubStringValue } from "../../../../../helpers/extraLogics";

	import { errorHandler, successHandler } from "../../../../../helpers/responseHandler";

	import {computed} from "vue";
	import KbDeleteModal from "../../KbDeleteModal.vue";
	
	export default {

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},

		props : {

			comment : { type : Object, default : ()=>{} },

			updateList : { type : Function, default : ()=> {} }
		},
		
		data() {
			
			return {
			
				isDisabled : false,

				showModal : false,

				commentId : '',

				loading : false,
			}
		},

		methods: {
			
			subString(value,length = 10){

				return getSubStringValue(value,length)
			},

			// for view comment
			viewArticle(article) {

				this.$store.dispatch('setArticleId', article);
			},

			updateStatus(id) {

				let endPoint = this.comment.status ? '/unapprove/'+id : '/published/'+id;

				this.loading = true;

				this.isDisabled = true;

				axios.get(endPoint).then(res=>{
	
					this.isDisabled = false;

					this.loading = false;

					this.updateList();
					
					successHandler(res,'CommentsIndex');

				}).catch(err=>{

					this.isDisabled = false;

					this.loading = false;

					errorHandler(res,'CommentsIndex');
				});
			},

			deleteMethod(value) {

				this.commentId = value;

				this.showModal = true;
			},

			onClose() {

				this.showModal = false;
			},
		},

		components :{

			'delete-modal' : KbDeleteModal
		}
	};
</script>

<style scoped>
	
	.vue-popover{ top:auto !important; left:auto !important;width: 250px !important; }

	#comment_item { 
		box-shadow: none !important;
    	border-top: 1px solid #dee2e6;
    	border-bottom: 1px solid #dee2e6;
    	border-radius: 0; 
    	margin-left: 2px !important;  margin-right: 4px!important; 
    }

	#comment_div { margin-bottom: 0 !important; margin-right: 0 !important; }

	.cursor { cursor: pointer; }

	.img-30 { width: 30px; height: 30px; }

	.bt-1 { border-top: 1px solid #dee2e6!important; }

	.bg-comment { background: #fef7f1 !important; }

	.btn-sm { font-size: 12px !important; }
</style>