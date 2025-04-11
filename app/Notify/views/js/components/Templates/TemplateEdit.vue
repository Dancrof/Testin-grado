<template>
<div class="col-sm-12">
	<alert componentName="template-edit"></alert>
	<custom-loader v-if="loading" />
	<div class="card card-light">
    	<div class="card-header" v-if="template">
        	<h3 class="card-title">{{trans(name)}}</h3>
    	</div>
    	<!-- /.box-header -->
    	<div class="card-body">
    		<div class="row" v-if="template">
                <div class="col-md-12">
                        <!-- first name -->
                    <p class="lead">{{ trans(template.template_name)}}</p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="card card-light" :class="{'collapsed-card': cardCollapsed }">
                        <div class="card-header">
                            <h3 class="card-title">{{trans('list-of-available-shot-codes')}}</h3>
                            <div class="card-tools">
                                <button class="btn btn-tool" data-lte-toggle="card-collapse" @click="collapseCard" data-bs-toggle="tooltip" v-tooltip="trans('collapse-list')">
                                  <i :class="cardCollapsed ? 'fas fa-plus' : 'fas fa-minus'"></i></button>
                            </div><!-- /.box-tools -->
                        </div><!-- /.box-header -->
                        <div class="card-body col-md-12">
                            <div class="alert alert-info alert-dismissable">
                                <i class="fas  fa-info-circle"></i>&nbsp;
                                <span>{{trans('template-short-code-tips')}}</span>
                                <button type="button" class="btn-close float-end" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        	<div>
                        		<ul class="list-inline" v-if="template">

			                        <template v-for="(description, value) in template.shortCodes">
				                        <li v-if="!hiddenKeys.includes(value)" class="list-inline-item" style="width: 23%"><span v-tooltip.right="trans(description)" data-placement="right">{{value}}</span></li>
			                        </template>
                        		</ul>
                    		</div>
                        </div><!-- /.box-body -->
                    </div>
                </div>
            </div>
            <div class="row">
            	<div class="col-md-12 form-group">
          			<text-field :autofocus="true" v-if="showsubject" :label="trans('subject')" :value="subject" type="text" name="subject" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6" :required="true" />
	          		<tiny-editor-with-validation :value="content" id="template-edit-editor" type="text" :onChange="onChange" name="content" :label="trans('content')"	:required="true" classname="col-sm-12 width55" :lang="'en'" :convertURLs="false"></tiny-editor-with-validation>

            	</div>
	    	</div>
    	<!-- ./box-body -->
		</div>
		<div class="card-footer">
            <button type="button" id="submitter"  @click="submit" class="btn btn-primary" :disabled="isDisabled">
                <i class="fas fa-save" aria-hidden="true"></i> {{trans('update')}}
            </button>
        </div>
	</div>
</div>
</template>
<script>
	import {errorHandler,successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
	import {getIdFromUrl} from "../../../../../../resources/assets/js/helpers/extraLogics";
	import axios from 'axios';
    import { validateNotifyTemplate } from "../../../../../../resources/assets/js/helpers/validator/notifyTemplateCreateRule";
	import TextField from "../../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";
	import ToolTip from "../../../../../../resources/assets/js/components/MiniComponent/ToolTip.vue";
	export default {
        name : 'template-edit',

        data()  {
        	return {
        		template : null,
        		id       : null,
        		showsubject : false,
        		isDisabled : false,
        		loading : false,
        		variable : false,
        		name: '',
        		content: '',
        		subject : '',
                cardCollapsed: false,
		        hiddenKeys:['{!! $ticket_title !!}']
        	}
        },

        beforeMount() {
        	this.id = getIdFromUrl(window.location.pathname);
        	this.getTemplateDetails();
        },

        methods: {
        	getTemplateDetails() {
        		this.toggleLoaders(true);
        		axios.get('/notify/api/get-template/'+this.id).then(res => {
					this.template = res.data.data;
					this.showsubject = this.template.variable == 1;
					this.name = this.template.name;
					this.subject = this.template.subject;
					this.content = this.template.content;
					this.variable = this.template.variable == 1;
					this.toggleLoaders(false);
					successHandler(res,'template-edit');
					
				}).catch(err => {
					this.toggleLoaders(false);				
					errorHandler(err,'template-edit');
				});
        	},
      	
		    onChange(value, name) {
      			this[name] = value;
   			},

   			submit() {
   				if(this.isValidInputs()) {
	   				this.toggleLoaders(true);
	   				let data = {
	   					'subject':this.subject,
	   					'variable':this.variable,
	   					'content':this.content
	   				}
	   				axios.patch('notify/api/update-template/'+this.id,data).
	   				then(res => {
	   					this.toggleLoaders(false);
						successHandler(res,'template-edit');
					}).catch(err => {
						this.toggleLoaders(false);				
						errorHandler(err,'template-edit');
					});
				}
   			},

   			toggleLoaders(value) {
   				this.loading = value;
   				this.isDisabled = value;
   			},

   			isValidInputs() {
                const {errors, isValid} = validateNotifyTemplate(this.$data);
                return isValid;
            },

          collapseCard() {
            this.cardCollapsed = !this.cardCollapsed;
          }
        },

        components: {
        	"text-field": TextField,
	    	"tool-tip": ToolTip
  		}
    }
</script>