<template>
	
	<div class="col-sm-12">
		
		<div class="row" v-if="hasDataPopulated === false || loading === true">
		
			<custom-loader :duration="loadingSpeed"></custom-loader>
		</div>
		
		<alert componentName="article-create"/>

		<div class="card card-light " v-if="hasDataPopulated === true">
			
			<div class="card-header">

				<h3 class="card-title">{{trans(title)}}</h3>

				<div class="card-tools">
			
					<a v-if="buttonVisible" id="view_article" class="btn btn-tool" type="button"
						:href="basePath()+'/show/'+link" target="_blank"
						v-tooltip="trans('view')">
								
						<i class="fas fa-eye"> </i>
					</a>

					<button v-if="buttonVisible" id="delete_article" class="btn btn-tool" type="button" 
						@click="modalMethod('delete')" v-tooltip="trans('delete')">
								
						<i class="fas fa-trash"> </i>
					</button>
							
					<template v-if="!buttonVisible">

						<a href="javascript:;" class="btn-tool dropdown-toggle" data-bs-toggle="dropdown" v-tooltip="trans('add_fields')">
				
							<i class="glyphicon glyphicon-plus"> </i>
						</a>

						<div class="dropdown-menu dropdown-menu-right" role="menu">
							
							<a class="dropdown-item text-dark" @click="modalMethod('new_category')" href="javascript:;"
								id="add_category">
							
								{{trans('add_category')}}
							</a>

							<a class="dropdown-item text-dark" @click="modalMethod('new_tag')" href="javascript:;">

								{{trans('add_tag')}}
							</a>
						</div>
					</template>
				</div>
			</div>

			<div class="card-body">
				
				<div class="row" v-focus-first-input>
			
					<text-field :label="lang('name')" :value="name" type="text"
						:name="showModal ? 'article_name' :'name'" :onChange="onChange" :placehold="lang('enter_a_value')"
						classname="col-sm-6" :required="true">
					</text-field>
						
					<perma-link :label="trans('perma_link')" :value="slug" :updateSlug="refreshSlug"
						name="slug" :onChange="onChange" 
						classname="col-sm-6" :required="true" :link="link" :disabled="buttonVisible">
					</perma-link>
				</div>
					
				<div class="row">
					
					<!-- <dynamic-select :label="trans('category')" 
						:multiple="true" name="category" 
						classname="col-sm-4" apiEndpoint="/api/dependency/categories" 
						:value="category" :onChange="onChange" :required="true" strlength="25">
					</dynamic-select> -->

					<tree-select :label="trans('category')" 
						:multiple="true" name="category" 
						classname="col-sm-4" apiEndpoint="/api/dependency/categories" 
						:value="category" :onChange="onChange" :placeHolder="lang('search_or_select')" :required="true" strlength="25"
						valueFormat="array">
							
					</tree-select>

					<dynamic-select :label="trans('author')" 
						:multiple="false" name="author" 
						classname="col-sm-4" apiEndpoint="/api/dependency/agents?meta=true" 
						:value="author" :onChange="onChange" :required="true" :clearable="author ? true : false" strlength="25">
					</dynamic-select>

					<dynamic-select :label="trans('tags')" 
						:multiple="true" name="tag_id" 
						classname="col-sm-4" apiEndpoint="/api/dependency/tags" 
						:value="tag_id" :onChange="onChange" :required="false" strlength="25" :hint="trans('relevant_tags_search')">
					</dynamic-select>
				</div>

				<div class="row">
					
					<text-field :label="trans('summary')" :value="summary" type="textarea" name="summary" :onChange="onChange" :placehold="lang('enter_a_value')"
						classname="col-sm-9" :required="true">
					</text-field>

					<div class="col-sm-3" v-if="showComments">
						
						<label for="status">{{trans('allow_comments')}}</label><br>
						
						<status-switch name="is_comment_enabled" :value="is_comment_enabled" :onChange="onChange" classname="float-start" :bold="true">
						
						</status-switch>   
					</div>
				</div>

				<div class="ml_7 ps-2">

					<add-media :description="description" from="article" :classname="classname" :show_error="show_err" id="article_editor"  page_name="kb"
						name="description" chunkApi="/chunk/upload/public" filesApi="/media/files/public" :onInput="onChange">

						<template #template>

							<button id="article__template__button" class="btn btn-light" @click="() => showTemplateModal = true">
								<i class="fas fa-align-left" aria-hidden="true"></i> {{trans('select_template')}}</button>
						</template>

					</add-media>
				</div>

				<div class="row">
					
					<static-select :label="trans('visibility')"  
						:elements="visibility_options" name="visible_to" :value="visible_to" 
						classname="col-sm-3" :onChange="onChange" :required="true">
					</static-select>

					<dynamic-select v-if="visible_to === 'organization_members'" :label="trans('organization')" 
						:multiple="false" name="organization_id" 
						classname="col-sm-3" apiEndpoint="/api/dependency/organizations" 
						:value="organization_id" :onChange="onChange" :required="true" strlength="20">
					</dynamic-select>

					<date-time-field :label="trans('publish_immediately')" 
						:value="publish_time" type="datetime" name="publish_time" 
						:onChange="onChange" :time-picker-options="timeOptions" 
						:required="true" format="MMMM DD YYYY HH:mm" classname="col-sm-3"
						:clearable="false" :disabled="false">
					</date-time-field>

					<radio-button :options="radioOptions" :label="trans('status')" 
						name="type" :value="type"
						:onChange="onChange" classname="form-group col-sm-3" >
					</radio-button>
				</div>

				<div class="row">

					<div :class="buttonVisible ? 'col-sm-6' : 'col-sm-12'">

						<div class="card card-light">
					
							<div class="card-header">
							
								<h3 class="card-title">{{trans('seo')}}</h3>
							</div>
							
							<div class="card-body">
						
								<div>
							
									<text-field :label="trans('seo_title')" :value="seo_title" 
										type="text" name="seo_title" :onChange="onChange" :placehold="lang('enter_a_value')"
										classname="col-sm-12" :required="false">
									</text-field>

									<div class="progress sm col-md-12 p-0" id="prog"><div :class="seoClass" :style="seoStyle"></div></div>
								</div>
								
								<div>
									
									<text-field :label="trans('description')" :value="meta_description" 
										type="textarea" name="meta_description" :onChange="onChange" :placehold="lang('enter_a_value')"
										classname="col-sm-12" :required="false">
									</text-field>

									<div class="progress sm col-md-12 p-0" id="prog"><div :class="seoDesClass" :style="seoDesStyle"></div></div>
								</div>
							</div>
						</div>
					</div>

					<div class="col-sm-6" v-if="buttonVisible && showRevisions">

						<article-revisions :articleId="article_id"></article-revisions>
					</div>
				</div>
			</div>

		<div class="card-footer">
			
			<button type="button" v-on:click="onSubmit()" :disabled="loading" class="btn btn-primary">
				
				<span :class="iconClass"></span>&nbsp;{{trans(btnName)}}
			</button>
		</div>
		
		<transition  name="modal">
			
			<article-modal :category="category" v-if="showModal" 
				:newCategory="newCategory" :onClose="onClose" :newTag="newTag"
				:showModal="showModal" :title="modal_title" :id="link">
			</article-modal>
		</transition>

		<transition name="modal">
			<template-modal v-if="showTemplateModal" :onClose="onTemplateModalClose" :showModal="showTemplateModal" :modal-title="trans('select_template')"></template-modal>
		</transition>

      <transition name="modal">

        <delete-modal v-if="showConfirmationModal" :onClose="onClose" :showModal="showConfirmationModal" from="template" :modalMessage="message" :buttonText="buttonName" :header="header"></delete-modal>
      </transition>
	</div>
</div>
</template>

<script>

	import axios from "axios";
	
	import { errorHandler, successHandler } from "../../../../../helpers/responseHandler";

	import { validateArticleSettings } from "../../../../../helpers/validator/articleCreateRules";

	import {getIdFromUrl} from "../../../../../helpers/extraLogics";

	import moment from 'moment'

	import TextField from "../../../../MiniComponent/FormField/TextField.vue";
	import PermaLink from "../../../../MiniComponent/FormField/PermaLink.vue";
	import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";
	import TreeSelect from "../../../../MiniComponent/FormField/TreeSelect.vue";
	import AddMedia from "../../../../MiniComponent/FormField/AddMedia.vue";
	import RadioButton from "../../../../MiniComponent/FormField/RadioButton.vue";
	import StaticSelect from "../../../../MiniComponent/FormField/StaticSelect.vue";
	import DateTimePicker from "../../../../MiniComponent/FormField/DateTimePicker.vue";
	import ArticleModal from "./ArticleModal.vue";
	import TemplateModal from "./TemplateModal.vue";
	import Switch from "../../../../MiniComponent/FormField/Switch.vue";
	import ArticleRevisions from "./ArticleRevisions.vue";
  import deleteModal from "../../../../MiniComponent/DataTableComponents/DeleteModal.vue";
	
	export default {
	
		name: "article-page",
	
		description: "article create and edit page",

		props : {

			auth : { type : Object, default : ()=> {}}
		},
	
		data: () => ({
	
			showModal: false,//modal status
	
			name: "",//typed article name
	
			link: "", //article link
	
			category: [], //selected category
	
			author: '', //selected author
	
			template: '', //selected author
	
			loading: false,//loader status
	
			loadingSpeed: 4000,
	
			hasDataPopulated: false,
	
			slug:'',//article slug
	
			radioOptions:[{name:'published',value:1},{name:'draft',value:0}],//article status
	
			type : 1,//article status
	
			visibility_options:[{ id:"all_users",name:"All Users" },{ id:"logged_in_users",name:"Logged in Users" },{ id:"agents",name:"Agents" },{ id : 'organization_members', name : 'Organization Members'}],
	
			visible_to: "",
	
			buttonVisible : false,//buttons config for create and edit page
	
			publish_time: new Date(),
	
			timeOptions : { start: '00:00', step: '00:30', end: '23:30' },//date picker time options
	
			seo_title :'',
	
			meta_description :'',
	

			description : '',
	

			seoDesStyle : { width : "0%"},//progress bar width
	
			seoDesClass : '',//progress bar class
	
			seoStyle : { width : "0%"},//progress bar width
	
			seoClass : '',//progress bar class
	
			classname : 'form-group',//ckeditor class
	
			progStart : 'progress-bar progress-bar-primary progress-bar-striped',//progress bar class
	
			progWarn : 'progress-bar progress-bar-warning progress-bar-striped',//progress bar class
	
			progSuc : 'progress-bar progress-bar-success progress-bar-striped',//progress bar class
	
			progDan : 'progress-bar progress-bar-danger progress-bar-striped',//progress bar class
	
			show_err : false,//ckeditor error class
	
			title :'create_new_article', iconClass:'fas fa-save',btnName:'save',//page title and btn classes for create and edit page
			article_id :'',
	
			modal_title :'',

			tag_id : [],

			showTemplateModal: false,

			is_comment_enabled : true,

			showComments : false,

			summary : '',

			organization_id : '',

			showRevisions : true,

      showConfirmationModal:false,

      message:'article-alert-message',

      beforeConfirmation:'',

      buttonName : 'Confirm',

      header:'Overwrite'
		}),

		beforeMount() {
			
			const path = window.location.pathname;

			this.getValues(path);

			this.getCommentStatus();

			const location = path.split('/');      	 
	
			if(location[location.length-1] !== 'edit') {

				this.author = {

					id : this.auth.user_data.id, 

					name: this.auth.user_data.first_name + ' ' + this.auth.user_data.last_name, 
			
					email : this.auth.user_data.email, 
					
					profile_pic : this.auth.user_data.profile_pic 
				};
			}
		},

		created() {
			window.emitter.on('applyTemplate', this.applyTemplate);
      window.emitter.on('updateConfirmation',this.updatingConfirmation);
      window.emitter.on('updateDescription',(data)=>{
        this.description = data;
      });
		},
		
		methods: {

			getValues(path){

				const articleId = getIdFromUrl(path);
			
				if (path.indexOf("edit") >= 0) {
			
					this.title = 'edit_article';
			
					this.iconClass = 'fas fa-sync'
			
					this.btnName = 'update'
			
					this.buttonVisible = true
			
					this.hasDataPopulated = false;

					this.article_id = articleId;
			
					this.getInitialValues(articleId);
				} else {

					this.loading = false;

					this.hasDataPopulated = true;

				}
			},
			
			getCommentStatus() {

				axios.get('/kb/settings/getvalue').then(res=>{
				
					this.showComments = res.data.data.kbsettings.is_comment_enabled;

				}).catch(res=>{
					
					this.showComments = false;
				});
			},

			getInitialValues(articleId) {
		
				this.loading = true;			
		
				axios.get('/api/edit/article/'+articleId).then(res => {
					
					this.loading = false;

					this.hasDataPopulated = true;

					this.article_id  = articleId
		
					this.updateStatesWithData(res.data.message);

					this.tag_id = res.data.message.article.tags;
		
				}).catch(err => {			
					
					this.loading = false;

					errorHandler(err,'article-create');

					setTimeout(() => {
						this.$router.push('/article/list');
					}, 4000);
				});
			},
		
			updateStatesWithData(articleData) {
				
				var articleDetails = articleData.article
		
				this.link = articleDetails.slug
		
				this.seoTitleProgress(articleDetails.seo_title)
		
				this.metaProgress(articleDetails.meta_description);
		
				const self = this;
		
				const stateData = this.$data;

				Object.keys(articleData.article).map(key => {
		
					if (stateData.hasOwnProperty(key)) {
		
						self[key] = articleData.article[key];
					}
				});

				this.publish_time = new Date(this.publish_time).toString()

				this.seo_title = articleDetails.seo_title === '' ? articleDetails.name : articleDetails.seo_title

				this.meta_description = articleDetails.meta_description === '' ? articleDetails.description : articleDetails.meta_description;

				this.summary = this.summary ? this.summary.replace(/<br>/g,'\n') : '';

				this.organization_id = articleDetails.organization;
			},
		
			isValid() {
		
				const { errors, isValid } = validateArticleSettings(this.$data);
		
				if (!isValid) {
		
					return false;
				}
					return true;
			},
			
			modalMethod(name){
			
				this.showModal = true
			
				this.modal_title = name
			
				this.$store.dispatch('unsetValidationError');
			},	
			
			onSubmit() {
			
				this.classname = this.description === '' ? 'form-group has-error'  : 'form-group'
			
				this.show_err = this.description === '' ? true  : false
			
				if (this.isValid() && this.description !== '') {

					this.loadingSpeed = 8000;
			
					this.loading = true;
			
					var fd = new FormData();
			
					if(this.article_id != ''){
			
						fd.append('articleid', this.article_id);
					}
			
					fd.append('name', this.name);
			
					fd.append('slug', this.link);
			
					fd.append('description', this.description);
			
					fd.append('category_id',this.category.map(a => a.id));

					if(this.visible_to === 'organization_members') {

						fd.append('organization_id',this.organization_id ? this.organization_id.id : '');

					} else {

						fd.append('organization_id','');
					}

					if(this.showComments){

						fd.append('is_comment_enabled',this.is_comment_enabled ? 1 : 0);
					}

					if(this.tag_id.length > 0){
						
						fd.append('tag_id',this.tag_id.map(a => a.id));								
					}
			
					fd.append('author', this.author.id);
			
					if(this.template != '' && this.template != null ){
			
						fd.append('template', this.template.id);
					} else {
						
						fd.append('template', '');
					}				
			
					fd.append('publish_time', new Date(this.publish_time).toUTCString());
			
					fd.append('visible_to', this.visible_to);
			
					fd.append('type', this.type);
			
					fd.append('seo_title', this.seo_title);
			
					fd.append('meta_description', this.meta_description);

					fd.append('summary', this.summary.replace(/\r?\n/g, '<br>'));
			
					const config = { headers: { 'Content-Type': 'multipart/form-data' } };
			
					axios.post('/article', fd,config).then(res => {
			
						this.loading = false;

						this.showRevisions = false;
			
						successHandler(res,'article-create');
			
						if(this.article_id === ''){
							
							setTimeout(()=>{

								return this.$router.push({name:'KB Article'})
							},3000)
						} else {
			
							this.getInitialValues(this.article_id);

							setTimeout(()=>{

								this.showRevisions = true;

							},1500);
						}
					}).catch(err => {
			
						this.loading = false;
			
						errorHandler(err,'article-create');
					});
				}
			},
			
			newCategory(value){
			
				this.category.push(value);
			},

			newTag(value){
				
				this.tag_id.push(value)
			},
			
			refreshSlug(value) {

				this.link = value;
			},

			onChange(value, name) {
				
				this[name] = value;
				
				/*
				* Updating article link based on name(Text field) and slug(Text field)
				* By default article link is Article Name... also given option to update the link in Slug field
				* Description : link should not contain any spaces or special characters for that i am using Regex pattern
				*/
				if(!this.buttonVisible){

					if(name === 'name' || name==="slug"){
			
						var regex = value.replace(/[^\w\s]/gi, '').toLowerCase();
				
						var regex1 = regex.replace(/_+/g,'')
				
						this.link= regex1.replace(/\s+/g,"-");
				
						this.slug = value
					}
				}

				if(name === 'publish_time') {

					this.publish_time = moment(value).format('YYYY-MM-DD HH:mm:ss')
				}
			
				if(name === 'seo_title'){ this.seoTitleProgress(value) }
			
				if(name === 'meta_description'){ this.metaProgress(value) }

				if(name === 'author' ){ this[name] = value === null ? '' : value }

				if(name === 'visible_to') {

					if(value != 'organization_members') {

						this.organization_id = "";
					}
				}

			},

			templateData(data){

				this.description = data;
			},
			
			seoTitleProgress(value){
			
				this.seoStyle.width = value.length/0.6+'%'
				
				// SEO title length
				var len = value.length;
				
				/**
				 * progDan(danger (red)), progSuc(success (green)), progWarn(warning (yellow)) => Progress bar classes
				 *
				 * Based on SEO title length this will show Progrees bar
				 * If SEO title length is more than 60 progress bar in red color
				 * If SEO title length is more than 25 and less than or equal to 50 progress bar in green color
				 * If SEO title length is more than 50 and less than or equal to 60 progress bar in yellow color
				 */
				this.seoClass = len > 60 ? this.progDan : 
												len > 25 && len <= 50 ? this.progSuc : 
												len > 50 && len <= 60 ? this.progWarn :  this.progStart;
			},
			
			metaProgress(value){
			
				this.seoDesStyle.width = value.length/1.6+'%'
				
				// SEO description length
				var len = value.length;
				
				/**
				 * progDan(danger (red)), progSuc(success (green)), progWarn(warning (yellow)) => Progress bar classes
				 *
				 * Based on SEO description length this will show Progrees bar
				 * If SEO description length is more than 160 progress bar in red color
				 * If SEO description length is more than 80 and less than or equal to 120 progress bar in green color
				 * If SEO description length is more than 120 and less than or equal to 160 progress bar in yellow color
				 */
				this.seoDesClass = len > 160 ? this.progDan : 
														len > 80 && len <= 120 ? this.progSuc : 
														len > 120 && len <= 160 ? this.progWarn :  this.progStart;
			},
			
			onClose(){
			
				this.$store.dispatch('unsetValidationError');
			
				this.showModal = false

				this.showConfirmationModal = false

			},

			/**
			 * Apply template description to the ckeditor content
			 * data.operation = {
			 * 'append': 'Append the data.data to the ckeditor content',
			 * 'overwrite': 'Overwrite the content of ckeditor with the data.data
			 * }
			 */
			applyTemplate(data) {
				if(data.operation === 'append') {
					this.description += data.data;
				} else if(data.operation === 'overwrite') {
				this.showConfirmationModal = true;
        this.beforeConfirmation=data.data;
				}
				this.onTemplateModalClose();
			},

      updatingConfirmation(){
        this.description = this.beforeConfirmation
      },

			onTemplateModalClose() {
				this.showTemplateModal = false;
			}
		},
		components: {
      'delete-modal': deleteModal,
			
			"text-field": TextField,
			
			"perma-link": PermaLink,
			
			"dynamic-select": DynamicSelect,

			"tree-select": TreeSelect,
			
			"add-media": AddMedia,
			
			'radio-button': RadioButton,
			
			'static-select': StaticSelect,
			
			'date-time-field': DateTimePicker,
			
			'article-modal': ArticleModal,

			'template-modal': TemplateModal,

			'status-switch': Switch,

			'article-revisions': ArticleRevisions,
		}
	};	
</script>

<style scoped>
  #article__template__button {
    margin-top: -13px;
  }

  .fs-25 { font-size: 25px !important; }
</style>

<style>

	.ml_7{ margin-left: -7px; }

	.ml_7 .tox-tinymce { width: 100% !important; }
</style>