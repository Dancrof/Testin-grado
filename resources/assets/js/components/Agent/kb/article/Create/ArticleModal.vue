<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="modalStyle">

		<template #title>
				
			<h4 class="modal-title">{{lang(title)}}</h4>
		</template>

		<template #alert>

			<alert/>
		</template>

		<template #fields>

			<template v-if="title === 'new_category'">
					
				<div class="row" v-focus-first-input>

					<text-field :label="lang('name')" :value="name" 
						type="text" name="name"
						:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6" :required="true">
					</text-field>

					<perma-link :label="trans('perma_link')" :value="slug" :updateSlug="refreshSlug"
						name="slug" :onChange="onChange" from="category"
						classname="col-sm-6" :required="true" :link="link" :disabled="buttonVisible">
					</perma-link>
				</div>

				<div class="row">

					<tree-select :label="trans('parent')" 
						:multiple="false" name="parent_category" 
						classname="col-sm-6" apiEndpoint="/api/dependency/categories" 
						:value="parent_category" :onChange="onChange" :placeHolder="trans('search_or_select')" :required="false" strlength="45">
							
					</tree-select>

					<number-field :label="lang('display_order')" :value="display_order" 
						name="display_order" classname="col-sm-3"
						:onChange="onChange" :placeholder="('n')" type="number" :required="true">
					</number-field>

					<radio-button :options="radioOptions" :label="lang('status')" 
						name="status" :value="status"
						:onChange="onChange" classname="form-group col-sm-3" >
					</radio-button>
				</div>

				<div class="row">
					
					<text-field :label="lang('description')" :value="description" 
						type="textarea" name="description"
						:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-12" :required="true">
					</text-field>
				</div>
			</template>

			<div v-if="title === 'new_tag'" class="row" v-focus-first-input>
					
				<text-field :label="lang('name')" :value="name" type="text" name="name" :onChange="onChange" :placehold="lang('enter_a_value')"
					classname="col-sm-12" :required="true">
					
				</text-field>
			</div>

			<div v-if="title === 'delete'">
					
				<span>{{lang('are_you_sure_you_want_to_delete')}}</span>
			</div>

			<div class="row" v-if="loading === true">

				<custom-loader :duration="4000"></custom-loader>
			</div>
		</template>
							
		<template #controls>
			
			<button type="button" id="submit_btn"  @click = "onSubmit()" :class="btnClass" :disabled="isDisabled">
				
				<i :class="iconClass"></i> {{lang(btnName)}}
			</button>
		</template>
	</modal>	
</template>

<script>

	import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

	import {validateCategoryCreate} from "../../../../../helpers/validator/categoryCreateValidation";

	import { validateKbTagSettings } from "../../../../../helpers/validator/kbTagRules";

	import { findObjectByKey} from "../../../../../helpers/extraLogics";

	import axios from 'axios'
	import TextField from "../../../../MiniComponent/FormField/TextField.vue";
	import NumberField from "../../../../MiniComponent/FormField/NumberField.vue";
	import RadioButton from "../../../../MiniComponent/FormField/RadioButton.vue";
	import TreeSelect from "../../../../MiniComponent/FormField/TreeSelect.vue";
	import PermaLink from "../../../../MiniComponent/FormField/PermaLink.vue";

	export default {

		name:'article-modal',

		description:'Article modal Component',

		props:{

			showModal:{type:Boolean,default:false},

			onClose:{type: Function},

			newCategory:{type: Function},

			newTag : { type : Function },

			title: { type : String },

			id : { type : [String, Number], default : ''}
		},

		data:()=>({

			btnName:'save',

			iconClass:'fas fa-save',

			btnClass:'btn btn-primary',
			
			isDisabled:false,

			description:'',

			loading:false,

			size: 60,

			color: '#1d78ff',

			apiUrl:'',

			lang_locale:'',

			radioOptions:[{name:'active',value:1}],

			status : 1 ,

			name : '' ,

			display_order : '' ,

			modalStyle : { width : '850px'},

			parent_category : null,

			slug:'',

			link: "",

			buttonVisible : false,

		}),

		beforeMount(){
			
			this.iconClass = this.title === 'delete' ? 'fas fa-trash' : 'fas fa-save'
			
			this.btnClass = this.title === 'delete' ? 'btn btn-secondary' : 'btn btn-primary'
			
			this.btnName = this.title === 'delete' ? 'delete' : 'save'
			
			this.modalStyle.width = this.title === 'delete' ? '500px' : '850px'

		},

		methods:{
		
		isValid(){
		
			const {errors, isValid} = validateCategoryCreate(this.$data)
		
			if(!isValid){
		
				return false
			}
			return true
		},

		isTagValid(){
			
			const {errors, isValid} = validateKbTagSettings(this.$data)
			
			if(!isValid){
			
				return false
			}
			return true
		},
		
		onChange(value, name,){
		
			this[name]= value;	

			if(!this.buttonVisible){

				if(name === 'name' || name==="slug"){
		
					var regex = value.replace(/[^\w\s]/gi, '').toLowerCase();
			
					var regex1 = regex.replace(/_+/g,'')
			
					this.link= regex1.replace(/\s+/g,"-");
			
					this.slug = value
				}
			}
		},

		initialState(){

			this.loading = false;
			
			this.isDisabled = false
			
			this.name = ''
			
			this.description = ''
			
			this.display_order = ''
		},

		onSubmit(){
			
			switch (this.title) {

			  	case 'delete':
			    	this.deleteMethod();
			    	break;

			  	case 'new_tag':
			   	this.createNewTag();
			   	break;

			   case 'new_category':
			   	this.createNewCategory();
			   	break;
			}
		},

		deleteMethod(){
			
			this.loading = true
			
			this.isDisabled = true
			
			axios.delete('/article/delete/'+this.id).then(res=>{					
				
				this.afterSuccess(res);
				
				setTimeout(()=>{

					return this.$router.push({name:'KB Article'})
				},3000)
			
			}).catch(err => {
						
				this.afterFailure(err)
			})
		},

		createNewTag(){
			
			if(this.isTagValid()){
				
				this.loading = true
			
				this.isDisabled = true
				
				const data = {};
				
				data['name'] = this.name;

				data['kb'] = 1;
				
				axios.post('/api/tag', data).then(res => {
					
					this.getNewTag(this.name)
					
					this.afterSuccess(res);
				}).catch(err => {
						
						this.afterFailure(err)
				});
			}
		},

		refreshSlug(value) {

			this.link = value;
		},
			
		createNewCategory(){
			
			if(this.isValid()){
					
				this.loading = true
			
				this.isDisabled = true
				
				axios.post('/api/category/create',{
			
					name : this.name,
					
					description : this.description,
					
					status : this.status,
					
					display_order : this.display_order,

					parent : this.parent_category ? this.parent_category.id : '',

					slug : this.link
				
				}).then(res=>{
						
						this.getNewCategory(this.name)
						
						this.afterSuccess(res)
				
				}).catch(error=>{
					
					this.afterFailure(error)
				})
			}
		},

		afterSuccess(res){
			
			this.loading = false;
						
			this.isDisabled = true;
			
			successHandler(res,'article-create');
				
			this.initialState()
			
			this.onClose();
		},
		
		afterFailure(error){
			
			this.loading = false;
					
			this.isDisabled = false
					
			errorHandler(error);
		},

		getNewTag(name){
			
			axios.get('/api/dependency/tags?search-query='+name).then(res=>{
				
				let tag = findObjectByKey(res.data.data.tags, 'name',name);
				
				this.newTag(tag);
			})
		},

		getNewCategory(name){

			axios.get('/api/dependency/categories?search-query='+name).then(res=>{

				let category = findObjectByKey(res.data.data.kb_category, 'name',name);
			
				this.newCategory(category);
			})
		}
	},

	components:{

		'text-field': TextField,
		
		'number-field': NumberField,
		
		'radio-button': RadioButton,

		"tree-select": TreeSelect,

		"perma-link": PermaLink,
	}
};
</script>