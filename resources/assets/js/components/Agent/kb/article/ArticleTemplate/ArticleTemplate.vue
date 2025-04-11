<template>

	<div class="col-sm-12">

		<div class="row" v-if="!hasDataPopulated || loading">

			<custom-loader :duration="loadingSpeed"></custom-loader>

		</div>

		<alert componentName="template-create"/>

		<div class="card card-light " v-if="hasDataPopulated">

			<div class="card-header">
				
				<h3 class="card-title">{{lang(title)}}</h3>

				<div class="card-tools">
							
					<a v-if="buttonVisible" class="btn-tool" @click="showModal = true" href="javascript:;" v-tooltip="lang('delete')">
							
								<i class="fas fa-trash"> </i> 	
					</a>
				</div>
			</div>
					
			<div class="card-body">
		
				<div class="row" v-focus-first-input>
			
					<text-field :label="lang('name')" :value="name" type="text" name="name" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6"
						:required="true">
						
					</text-field>
			
					<radio-button :options="radioOptions" :label="lang('status')" name="status" :value="status" :onChange="onChange"
						classname="form-group col-sm-6" >
						
					</radio-button>
				</div> 
			
				<div class="row">

					<tiny-editor :value="description" type="text" from="article" :onChange="onChange" name="description" id="template_editor" :label="lang('description')"
						classname="col-sm-12" :required="true" :lang="'en'">
						
					</tiny-editor>
			
				</div>
			</div>

			<div class="card-footer">
				
				<button type="button" id="submit_btn" v-on:click="onSubmit()" :disabled="loading" 
					class="btn btn-primary">
						
					<i :class="iconClass"></i>&nbsp;{{lang(btnName)}}		
				</button>
			</div>
		</div>

		<transition  name="modal">

			<template-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :apiUrl="'/article/deletetemplate/'+template_id"
				alert="template-create" redirectUrl="/article/alltemplate/list">

			</template-modal>
		</transition>
	</div>
</template>

<script>

	import axios from "axios";
	
	import { errorHandler, successHandler } from "../../../../../helpers/responseHandler";

	import { validateArticleTemplateSettings } from "../../../../../helpers/validator/articleTemplateCreateRules";

	import {getIdFromUrl } from "../../../../../helpers/extraLogics";
	import TextField from "../../../../MiniComponent/FormField/TextField.vue";
	import RadioButton from "../../../../MiniComponent/FormField/RadioButton.vue";
	import KbDeleteModal from "../../KbDeleteModal.vue";

	export default {

		name : 'article-template',

		description : 'Article Template component',

		data(){
			return {

				name : '',

				status : 1,

				description : '',

				radioOptions:[{name:'active',value:1},{name:'inactive',value:0}],

				//ck editor
				classname : 'form-group',

				show_err : false,
				
				title :'create_new_article_template', 

				iconClass:'fas fa-save',

				btnName:'save',

				loading: false,//loader status
				
				loadingSpeed: 4000,
				
				hasDataPopulated: true,

				template_id :'',

				buttonVisible : false,

				showModal : false
			}
		},
		
		beforeMount() {

			const path = window.location.pathname;
			
			this.getValues(path);
		},

		methods : {

			getValues(path){

				const templateId = getIdFromUrl(path);
			
				if (path.indexOf("edit") >= 0) {
					
					this.title = 'edit_article_template';
							
					this.iconClass = 'fas fa-sync'
					
					this.btnName = 'update'

					this.hasDataPopulated = false;

					this.buttonVisible = true;
					
					this.getInitialValues(templateId);
				 
				} else {

					this.loading = false;

					this.hasDataPopulated = true
				}
			},

			getInitialValues(id) {

				this.loading = true;			
				
				axios.get('/api/articletemplate/edit/'+id).then(res => {

					this.template_id  = id
					
					this.hasDataPopulated = true;
					
					this.loading = false;

					this.updateStatesWithData(res.data.message.template);
				
				}).catch(err => {
					
					errorHandler(err)
					
					this.hasDataPopulated = true;
					
					this.loading = false;
				
				});
			
			},
			
			updateStatesWithData(templateData) {
				
				const self = this;
				
				const stateData = this.$data;
				
				Object.keys(templateData).map(key => {

					if (stateData.hasOwnProperty(key)) {
					
						self[key] = templateData[key];
					
					}
				
				});
			
			},
			
			isValid() {

				const { errors, isValid } = validateArticleTemplateSettings(this.$data);
			
				if (!isValid) {
			
					return false;
			
				}
			
					return true;
			
			},

			onChange(value, name) {
				this[name] = value;
	
			},
			
			onSubmit() {
			
				if (this.isValid()) {
			
					this.loadingSpeed = 8000;
			
					this.loading = true;
			
					const data = {};
			
					if(this.template_id != ''){

						data['id'] = this.template_id;
					
					}

					data['name'] = this.name;

					data['status'] = this.status;

					data['description'] = this.description;

					axios.post('/article/post/template', data).then(res => {

						this.loading = false;
						
						successHandler(res,'template-create');
						
						if(this.template_id === ''){
							
							setTimeout(()=>{

								return this.$router.push({name:'KB Article Template List'})
							},3000)
						
						} else {

							this.getInitialValues(this.template_id)
						}
					
					}).catch(err => {
					
						this.loading = false;
					
						errorHandler(err,'template-create');
					
					});
				
				}
			
			},

			onClose(){
			
				this.$store.dispatch('unsetValidationError');
			
				this.showModal = false
			},

		},

		components:{
			
			"text-field": TextField,
			
			'radio-button': RadioButton,
			
			'template-modal': KbDeleteModal
		}
	
	};
</script>