<template>
	
	<div class="col-sm-12">
		
		<div class="row" v-if="hasDataPopulated === false || loading === true">
		
			<custom-loader :duration="loadingSpeed"></custom-loader>
		</div>
		
		<alert componentName="canned-create-edit"/>

		<div class="card card-light " v-if="hasDataPopulated === true">
			
			<div class="card-header">

				<h3 class="card-title">{{lang(page_title)}}</h3>
			</div>

			<div class="card-body">

        <div class="row">

          <div class="col-md-12">

            <div class="card card-light">

              <div class="card-header">

                <h3 class="card-title">{{trans('list-of-available-shot-codes')}}</h3>
              </div>

              <div class="card-body col-md-12">

                <div class="row" v-if="shortCodesLoader">

                  <reuse-loader :animation-duration="4000" :size="60"/>
                </div>

                <div v-else>

                  <div class="alert alert-info alert-dismissable">

                    <i class="fas  fa-info-circle"></i>&nbsp;

                    <span>{{trans('template-short-code-tips')}}</span>

                    <button type="button" class="btn-close float-end" data-bs-dismiss="alert" aria-label="Close"></button>
                  </div>

                  <ul class="list-inline" v-if="shortcodes.length">

                    <li v-for="item in shortcodes" class="list-inline-item" style="width: 23%">

                      <span v-tooltip.right="{ content : trans(item.desc_lang_key), html : true}" data-placement="right">{{item.shortcode}}</span>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>

				<div class="row" v-focus-first-input>
			
					<text-field :label="lang('title')" :value="title" type="text" name="title" :onChange="onChange" :placehold="lang('enter_a_value')"
						classname="col-sm-6" :required="true">
				
					</text-field>
				</div>
					
				<div class="row addMedia ms-0">
					
					<add-media :attachments="attachments" :inlineFile="inline" :description="message" :classname="classname" 
						name="message" :show_error="show_err" :onAttach="getAttachments" :onInline="getInlineImages"  :type="type"
						:onInput="onChange" page_name="canned" chunkApi="/chunk/upload/public" filesApi="/media/files/public" id="canned-response-tinymce">
						
					</add-media>

				</div>

				<div class="row">
					
					<div class="col-sm-12">

						<label class="label_align" name="share">

							<input class="checkbox_align" type="checkbox" name="share" id="share" v-model="share">
								&nbsp;{{lang('share-response-with-department')}}
						</label>
					</div>

					<dynamic-select v-if="share" :label="lang('departments')" :multiple="true" name="departments" :required="true"
						 classname="col-sm-6" apiEndpoint="/api/dependency/departments" :value="departments" 
						:onChange="onChange">

					</dynamic-select>

				</div>
			</div>

			<div class="card-footer">
				
				<button type="button" v-on:click="onSubmit()" :disabled="loading" class="btn btn-primary">
			
					<span :class="iconClass"></span>&nbsp;{{lang(btnName)}}
				</button>
			</div>
		</div>
	</div>
</template>

<script>

	import axios from "axios";
	
	import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

	import { validateCannedSettings } from "../../../../helpers/validator/cannedCreateRules";

	import {getIdFromUrl} from "../../../../helpers/extraLogics";
	import TextField from "../../../MiniComponent/FormField/TextField.vue";
	import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
	import AddMedia from "../../../MiniComponent/FormField/AddMedia.vue";

	export default {
	
		name: "canned-page",
	
		description: "Canned create and edit page",
	
		data: () => ({
	
			title: "",
	
			loading: false,

			loadingSpeed: 4000,
	
			hasDataPopulated: false,
	
			message : '',
	
			classname : 'form-group ps-0',

			show_err : false,
	
			page_title :'create_canned_response', 

			iconClass:'fas fa-save',

			btnName:'save',

			canned_id :'',

			share : false,

			departments : [],

			attachments : [],

			inline : [],

      shortCodesLoader : false,

      shortcodes : [],

      type:'reply'

    }),

		beforeMount() {
			
			const path = window.location.pathname;

			this.getValues(path);

      this.getShortCodes();
		},
		
		methods: {

      getShortCodes() {

        this.shortCodesLoader = true

        axios.get('/api/getTicketSetting/pdfShortCodes?forCannedResponse=1').then(res=>{

          this.shortCodesLoader = false;

          this.shortcodes = res.data.data;

        }).catch(error=>{

          this.shortCodesLoader = false;

          errorHandler(error,'canned-create-edit');
        });
      },

      getAttachments(files){

				this.attachments = files;
			},

			getInlineImages(files){

				this.inline = files;
			},

			getValues(path){

				const cannedId = getIdFromUrl(path);
			
				if (path.indexOf("edit") >= 0) {
			
					this.page_title = 'edit_canned_response';
			
					this.iconClass = 'fas fa-sync-alt'
			
					this.btnName = 'update'
			
					this.hasDataPopulated = false;
			
					this.getInitialValues(cannedId);
				} else {

					this.loading = false;

					this.hasDataPopulated = true
				}
			},
		
			getInitialValues(cannedId) {
		
				this.loading = true;			
		
				axios.get('/api/canned/edit/'+cannedId).then(res => {
					
					this.loading = false;

					this.hasDataPopulated = true;

					this.canned_id  = cannedId
		
					this.updateStatesWithData(res.data.data);
		
				}).catch(err => {			
					
					this.loading = false;

          this.hasDataPopulated = false;

          errorHandler(err,'canned-create-edit')

          setTimeout(()=>{

            return this.$router.push({name:'Canned Response Index'})
          }, 2000)
				});
			},
		
			updateStatesWithData(cannedData) {
		
				const self = this;
		
				const stateData = this.$data;

				Object.keys(cannedData).map(key => {
		
					if (stateData.hasOwnProperty(key)) {
		
						self[key] = cannedData[key];
					}
				});
			},
		
			isValid() {
		
				const { errors, isValid } = validateCannedSettings(this.$data);
		
				if (!isValid) {
		
					return false;
				}
					return true;
			},

			onSubmit() {
			
				this.classname = this.message === '' ? 'form-group has-error ps-0'  : 'form-group ps-0'
			
				this.show_err = this.message === '' ? true  : false

				if (this.isValid() && this.message !== '') {
					
					this.loadingSpeed = 8000;
			
					this.loading = true;
					
					const data = {};
			
					if(this.canned_id != ''){
			
						data['canned_id'] = this.canned_id;
					}
			
					data['title'] = this.title;
			
					data['message'] = this.message;

					data['attachment'] = this.attachments;

					data['inline'] = this.inline;

					var depts = [];

					for(var i in this.departments){
						depts.push(this.departments[i].id)						
					}

					data['d_id[]'] = depts;

					data['share'] = this.share;
			
					axios.post('/api/agent/canned-response', data).then(res => {
			
						this.loading = false;

						successHandler(res,'canned-create-edit');
			
						if(this.canned_id === ''){

							setTimeout(()=>{

								return this.$router.push({name:'Canned Response Index'})
							},3000)
						} else {

							this.getInitialValues(this.canned_id)
						}
					}).catch(err => {
			
						this.loading = false;
			
						errorHandler(err,'canned-create-edit');
					});
				}
			},
			
			onChange(value, name) {
			
				this[name] = value;		
			}
		},
		components: {
			
			"text-field": TextField,
			
			"dynamic-select": DynamicSelect,
			
			"add-media": AddMedia
		}
	};	
</script>
<style scoped>
	.label_align1 {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: 500 !important; padding-top: 6px;
	}
	.checkbox_align {
		width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden; cursor: pointer;
	}
  .addMedia{
    margin-right: 3px!important;
  }
</style>