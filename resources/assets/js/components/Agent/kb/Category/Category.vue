<template>

	<div class="col-sm-12">

		<div class="row" v-if="hasDataPopulated === false || loading === true">

			<custom-loader :duration="loadingSpeed"></custom-loader>

		</div>

		<alert componentName="category-create"/>

		<div class="card card-light " v-if="hasDataPopulated === true">

			<div class="card-header">
				
				<h3 class="card-title">{{lang(title)}}</h3>

				<div class="card-tools">
	
					<a v-if="buttonVisible" id="view_category" class="btn-tool" :disabled="!status" v-tooltip="lang('view')"
						:href="status ? basePath()+'/category-list/'+link :'javascript:;'" :target="status ? '_blank' : ''">
								
						<i class="fa fa-eye" ></i> 
					</a>
							
					<a v-if="buttonVisible" id="delete_category" class="btn-tool" @click="showModal = true" href="javascript:;"
						v-tooltip="lang('delete')">
							
						<i class="fas fa-trash">  </i>	
					</a>
				</div>
			</div>
					
			<div class="card-body">
		
				<div class="row" v-focus-first-input>
			
					<text-field :label="trans('name')" :value="name" type="text" name="name" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6"
						:required="true">
						
					</text-field>

					<perma-link :label="trans('perma_link')" :value="slug" :updateSlug="refreshSlug"
						name="slug" :onChange="onChange" from="category"
						classname="col-sm-6" :required="true" :link="link" :disabled="buttonVisible">
					</perma-link>
				</div> 

				<div class="row">
					
					<tree-select :label="trans('parent')" 
						:multiple="false" name="parent_category"
						classname="col-sm-6" :apiEndpoint="endPoint" 
						:value="parent_category" :onChange="onChange" :placeHolder="trans('search_or_select')" :required="false" strlength="45">
							
					</tree-select>

					<number-field :label="lang('display_order')" :value="display_order" name="display_order" 
						classname="col-sm-3" :onChange="onChange" :placeholder="('n')" type="number" :required="true">
	            
	            	</number-field>

					<radio-button :options="radioOptions" :label="lang('status')" name="status" :value="status"
						:onChange="onChange" classname="form-group col-sm-3" >
						
					</radio-button>
				</div>

				<div class="row">
					
					<text-field :label="lang('description')" :value="description" type="textarea" name="description"
						rows="8" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-12" :required="true">
									
					</text-field>
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

			<category-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :apiUrl="'/category/delete/'+category_id"
				alert="category-create" redirectUrl="/category">

			</category-modal>
		</transition>
	</div>

</template>

<script>

	import axios from "axios";
	
	import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

	import { validateCategoryCreateSettings } from "../../../../helpers/validator/categoryCreateRules";

	import {getIdFromUrl} from "../../../../helpers/extraLogics";
	import TextField from "../../../MiniComponent/FormField/TextField.vue";
	import NumberField from "../../../MiniComponent/FormField/NumberField.vue";
	import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
	import KbDeleteModal from "../KbDeleteModal.vue";
	import PermaLink from "../../../MiniComponent/FormField/PermaLink.vue";
	import TreeSelect from "../../../MiniComponent/FormField/TreeSelect.vue";

	export default {

		name : 'article-template',

		description : 'Article Template component',

		data(){
			return {

				name : '',

				status : 1,

				description : '',

				display_order : '',

				radioOptions:[{name:'active',value:1},{name:'inactive',value:0}],

				//ck editor
				classname : 'form-group',

				show_err : false,
				
				title :'create_new_category', 

				iconClass:'fas fa-save',

				btnName:'save',

				loading: false,//loader status
				
				loadingSpeed: 4000,
				
				hasDataPopulated: true,

				category_id :'',

				buttonVisible : false,

				showModal : false,

				slug:'',

				link: "",

				parent_category : null,

				endPoint : ''

			}
		},
		
		beforeMount() {

			const path = window.location.pathname;
			
			this.getValues(path);
		},

		methods : {

			getValues(path){

				const categoryId = getIdFromUrl(path);
			
				if (path.indexOf("edit") >= 0) {
					
					this.title = 'edit_category';
							
					this.iconClass = 'fas fa-sync-alt'
					
					this.btnName = 'update'

					this.hasDataPopulated = false;
					
					this.buttonVisible = true;

					this.endPoint = '/api/dependency/categories?category_id='+categoryId;

					this.getInitialValues(categoryId);
				 
				 } else {

					this.endPoint = '/api/dependency/categories';

					this.loading = false;

					this.hasDataPopulated = true
				}
			},

			getInitialValues(id) {

				this.loading = true;			
				
				axios.get('/api/edit/category/'+id).then(res => {

					this.category_id  = id

					this.hasDataPopulated = true;
					
					this.loading = false;

					this.updateStatesWithData(res.data.message.category);
				
				}).catch(err => {
					
					errorHandler(err)
					
					this.hasDataPopulated = true;
					
					this.loading = false;
				
				});
			
			},
			
			updateStatesWithData(categoryData) {
				
				this.link = categoryData.slug

				const self = this;
				
				const stateData = this.$data;
				
				Object.keys(categoryData).map(key => {

					if (stateData.hasOwnProperty(key)) {
					
						self[key] = categoryData[key];
					
					}
				
				});
			
			},
			
			isValid() {

				const { errors, isValid } = validateCategoryCreateSettings(this.$data);
			
				if (!isValid) {
			
					return false;
			
				}
			
					return true;
			
			},

			onChange(value, name) {
				
				this[name] = value;

				/*
				* Updating category link based on name(Text field) and slug(Text field)
				* By default category link is Category Name... also given option to update the link in Slug field
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
			},

			onSubmit() {
			
				if (this.isValid()) {
			
					this.loadingSpeed = 8000;
			
					this.loading = true;
			
					const data = {};
			
					if(this.category_id != ''){

						data['id'] = this.category_id;
					
					}

					data['name'] = this.name;

					data['status'] = this.status;

					data['description'] = this.description;

					data['display_order'] = this.display_order;

					data['slug'] = this.link;

					data['parent'] = this.parent_category ? this.parent_category.id : '';

					axios.post('/api/category/create', data).then(res => {

						this.loading = false;
						
						successHandler(res,'category-create');
						
						if(this.category_id === ''){
						
						 	setTimeout(()=>{

								return this.$router.push({name:'KB Category Index'})
							},3000)
						
						}else {
							this.getInitialValues(this.category_id)
						}
					
					}).catch(err => {

						this.loading = false;
					
						errorHandler(err,'category-create');
					});
				}
			},

			refreshSlug(value) {

				this.link = value;
			},

			onClose(){
			
				this.$store.dispatch('unsetValidationError');
			
				this.showModal = false
			},
		},

		components:{
			
			"text-field": TextField,
			
			'number-field': NumberField,
			
			'radio-button': RadioButton,
			
			'category-modal': KbDeleteModal,

			"perma-link": PermaLink,

			"tree-select": TreeSelect,
		}
	};
</script>