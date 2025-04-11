<template>
	
	<div class="col-sm-12">
		
		<alert componentName="OAuthSettings" />
		
		<div class="row" v-if="loading">
			
			<custom-loader :duration="4000"></custom-loader>
		
		</div>
		
		<div v-else>
			
			<div class="card card-light">
				
				<div class="card-header">
					
					<h3 class="card-title">  {{ provider }} {{ trans('settings') }}&nbsp;&nbsp;</h3>
					
					<a v-if="details.refer_uri && !details.isWhiteLabeled" :href="details.refer_uri" target="__blank">
						
						<tool-tip slot="headerTooltip" :message="trans('click-here-to-see-more-details')" size="medium"></tool-tip>
					</a>
				</div>
				
				<div class="card-body">
					
					<div class="row" v-focus-first-input>
						
						<text-field id="client-id" :label="trans('client-id')" :value="client_id" type="text" name="client_id" :onChange="onChange" :placehold="lang('enter_a_value')"
						            classname="col-sm-6" :required="true">
						
						</text-field>
						
						<text-field id="client-secret" :label="trans('client-secret')" :value="client_secret" type="text" name="client_secret" :onChange="onChange" :placehold="lang('enter_a_value')"
						            classname="col-sm-6" :required="true">
						
						</text-field>
					
					</div>
					
					<div class="row">
						
						<text-field id="redirect-url" :label="trans('redirect-url')" :value="redirect_url" type="text" name="redirect_url" :onChange="onChange" :placehold="lang('enter_a_value')"
						            classname="col-sm-5" :required="true" :disabled="true">
						
						</text-field>
						
						<div class="col-sm-1 ps-0">
							
							<a class="btn btn-light uri-copy" @click.prevent="onCopy()"
							   v-tooltip="!copied ? trans('click-to-copy') : trans('clipboard-copy-message')">
								
								<span :class="copied ? 'fas fa-check text-success' : 'fa fa-clipboard'" id="eye">
										
								</span>
							</a>
						</div>
						
						<radio-button :options="radioOptions" :label="lang('activate_login_via') + ' ' + lang(provider)" name="status" :value="status"
						              :onChange="onChange" classname="form-group col-sm-6" ></radio-button>
					</div>
				</div>
				
				<div class="card-footer">
					
					<button id="submit_btn" class="btn btn-primary" @click="onSubmit()">
						<i class="fas fa-save"></i> {{trans('save')}}
					</button>
				</div>
			</div>
		</div>
	
	</div>
</template>

<script>

import {successHandler,errorHandler} from "../../../../helpers/responseHandler";

import axios from 'axios';

import { validateOAuthSetting } from  '../../../../helpers/validator/settingsOAuth.js';

import {getIdFromUrl} from '../../../../helpers/extraLogics';

import copy from 'clipboard-copy';
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
import ToolTip from "../../../MiniComponent/ToolTip.vue";

export default {
	
	name : 'oauth-settings',
	
	data(){
		
		return{
			
			loading: false,
			
			provider: '',
			
			client_id: '',
			
			client_secret: '',
			
			redirect_url: '',
			
			status : 1,
			
			details : '',
			
			radioOptions:[{name:'yes',value:1},{name:'no',value:0}],
			
			copied: false,
		}
	},
	
	beforeMount(){
		
		const path = window.location.pathname;
		
		this.provider_id = getIdFromUrl(path)
		
		this.getInitialValues();
		
	},
	
	methods:{
		
		onCopy(){
			
			copy(this.redirect_url);
			
			this.copied = true;
			
			setTimeout(() => {
				
				this.copied = false;
			}, 5000)
		},
		
		getInitialValues(){
			
			this.loading = true;
			
			axios.get('/get/oauth-integration/'+this.provider_id).then(res=>{
				
				this.details = res.data;
				
				this.provider = this.details.provider;
				
				this.status = this.details.is_active;
				
				this.client_id = this.details.client_id ? this.details.client_id : '';
				
				this.client_secret = this.details.client_secret ? this.details.client_secret : '';
				
				this.redirect_url = this.details.redirect_uri;
				
				this.loading = false;
				
			}).catch(error=>{
				
				errorHandler(error,'OAuthSettings')
			});
		},
		
		onChange(value, name) {
			
			this[name] = value;
			
			if(value === null){
				
				this[name] = '';
			}
		},
		
		isValid() {
			
			const { errors, isValid } = validateOAuthSetting(this.$data);
			
			return isValid;
		},
		
		onSubmit(){
			
			if(this.isValid()){
				
				this.loading = true;
				
				let data = {};
				
				data['client_id'] = this.client_id;
				
				data['client_secret'] = this.client_secret;
				
				data['id'] = this.provider_id;
				
				data['is_active'] = this.status;
				
				axios.post('/api/oauth-integration/update', data).then(res => {
					
					this.loading = false;
					
					successHandler(res,'OAuthSettings')
					
				}).catch(err => {
					
					this.loading = false
					
					errorHandler(err, 'OAuthSettings')
				});
			}
		}
	},
	
	components : {

		"text-field": TextField,
		
		"radio-button": RadioButton,
		
		'tool-tip': ToolTip,
	}
}
</script>

<style scoped>

.uri-copy { margin-top: 29px; cursor: pointer}
</style>