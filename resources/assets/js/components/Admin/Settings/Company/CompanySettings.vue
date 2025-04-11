<template>
	<div class="col-sm-12">
		<div>
			
			<alert componentName="company-settings"/>
		</div>

		<div v-if="loading">
			
			<custom-loader :loadingSpeed="4000"></custom-loader>
		</div>
		
		<div class="card card-light" v-if="hasDataPopulated">
			
			<div class="card-header">
				
				<h3 class="card-title">{{lang('company_settings')}}</h3>
			</div>

			<div class="card-body">
				
				<div class="row" v-focus-first-input>
					
					<text-field :label="lang('name')" type="text" :value="company_name" name="company_name"
						class="col-sm-4" :required="true" :onChange="onChange" :placehold="lang('enter_a_value')">
					</text-field>

          <phoneWithCountryCode id="phone" classname="col-sm-4" name="phone" :onChange="onChange" :value="phone"
                                :countryCode="phone_country_code"  :countryIso="phone_iso"  @countCode="onPhoneFieldUpdate($event, 'phone_country_code')"   @countIso="onPhoneFieldUpdate($event, 'phone_iso')"
                                :label="lang('phone')" :apiUrl="'/api/dependency/country-codes?time='+Date.now()" @validPhoneNumber="checkValidity" fieldType="FIXED_LINE_OR_MOBILE">
          </phoneWithCountryCode>

					<text-field :label="lang('website')" type="text" name="website" :value="website"
						classname="col-sm-4" :onChange="onChange" :placehold="lang('enter_a_value')">
					</text-field>
				
				</div>

				<div class="row">

					<text-field :label="lang('address')" type="textarea" name="address" :value="address" :rows="5"
						classname="col-sm-12" :onChange="onChange" :placehold="lang('enter_a_value')">
					</text-field>
				</div>

				<div class="row">
					
					<div for="Logo and Favicon" class="col-sm-12">
						
						<div class="card card-light">
					
							<div class="card-header">
					
								<h3 class="card-title">{{lang('agent_panel_color_configuartion')}}</h3>
							</div>

							<div class="card-body">
								
								<div class="row">
									
									<static-select :label="lang('admin_header_color')" :elements="header_colors"
											name="admin_header_color" :value="admin_header_color" 
											classname="col-sm-3" :onChange="onChange" :required="true">
									</static-select>

									<static-select :label="lang('admin_sidebar_color')" :elements="sidebar_colors"
											name="admin_sidebar_color" :value="admin_sidebar_color" 
											classname="col-sm-3" :onChange="onChange" :required="true">
									</static-select>

									<static-select :label="lang('agent_header_color')" :elements="header_colors"
											name="agent_header_color" :value="agent_header_color" 
											classname="col-sm-3" :onChange="onChange" :required="true">
									</static-select>

									<static-select :label="lang('agent_sidebar_color')" :elements="sidebar_colors"
											name="agent_sidebar_color" :value="agent_sidebar_color" 
											classname="col-sm-3" :onChange="onChange" :required="true">
									</static-select>
								</div>
							</div>
						</div>
						
						<div class="card card-light">
					
							<div class="card-header">
					
								<h3 class="card-title">{{lang('client_panel_configuartion')}}

									<tool-tip :message="lang('color_configuartion_tooltip')" size="medium"></tool-tip>
								</h3>
							</div>

							<div class="card-body">

								<div class="row">
									
									<div class="col-sm-2">
										<label for="Address"> {{ lang('client_header_color') }} </label>

										<label class="label_align">
											<input class="checkbox_align" type="checkbox" name="defaultheader" v-model="header_default">&nbsp;{{lang('use_default')}}
										</label>

										<color-picker  v-if="!header_default" :color="client_header_color" name="client_header_color" :onColor="onChange" />
									</div>

									<div class="col-sm-2">
										<label for="Address"> {{ lang('client_button_color') }} </label>
										
										<label class="label_align">
											<input class="checkbox_align" type="checkbox" name="defaultbutton" v-model="button_default">&nbsp;{{lang('use_default')}}
										</label>

										<color-picker  v-if="!button_default" :color="client_button_color" name="client_button_color" :onColor="onChange"/>
									</div>

									<div class="col-sm-2">
										<label for="Address"> {{ lang('client_button_border_color') }} </label>
										
										<label class="label_align">
											<input class="checkbox_align" type="checkbox" name="defaultborder" v-model="border_default">&nbsp;{{lang('use_default')}}
										</label>

										<color-picker  v-if="!border_default" :color="client_button_border_color" name="client_button_border_color" :onColor="onChange"/>
									</div>
									
									<div class="col-sm-2">
										<label for="Address"> {{ lang('button_font_color') }} </label>
										
										<label class="label_align">
											<input class="checkbox_align" type="checkbox" name="defaultfontcolor" v-model="font_color_default">&nbsp;{{lang('use_default')}}
										</label>
										
										<color-picker  v-if="!font_color_default" :color="client_button_font_color" name="client_button_font_color" :onColor="onChange"/>
									</div>

									<div class="col-sm-2">
										<label for="Address"> {{ lang('client_input_field_color') }} </label>
										
										<label class="label_align">
											<input class="checkbox_align" type="checkbox" name="defaultinput" v-model="input_default">&nbsp;{{lang('use_default')}}
										</label>

										<color-picker v-if="!input_default" :color="client_input_field_color" name="client_input_field_color" :onColor="onChange"/>
									</div>

									<div class="col-sm-2">
						
										<label for="status">{{lang('show_breadcrumbs')}}</label><br>
										
										<status-switch name="is_enabled_breadcrumb" :value="is_enabled_breadcrumb" :onChange="onChange" classname="float-start"
											:bold="true">
										
										</status-switch>   
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					
					<div for="Logo and Favicon" class="col-sm-12">
					
						<div class="card card-light">
					
							<div class="card-header">
					
								<h3 class="card-title">{{lang('logo_and_favicon')}}

									<tool-tip :message="lang('logo_icon_config')" size="medium"></tool-tip>
								</h3>
							</div>

							<div class="card-body">

								<div class="row">

									<label class="label_align col-md-4 text-center">
										<input class="checkbox_align" type="checkbox" name="defaulticon" v-model="defaulticon">&nbsp;{{lang('use_default')}}
									</label>

									<label class="label_align col-md-4 text-center">
										<input class="checkbox_align" type="checkbox" name="defaultlogo" v-model="defaultlogo">&nbsp;{{lang('use_default')}}
									</label>

									<label class="label_align col-md-4 text-center">
										<input class="checkbox_align" type="checkbox" name="uselogo" v-model="uselogo">&nbsp;{{lang('use_logo')}}
									</label>
								</div>

								<div class="row">
									
									<image-upload :label="lang('favicon')" :labelStyle="logoStyle" :value="icon" 
										name="icon" :onChange="onChange" btnName="change_icon"
										classname="col-sm-4 text-center" :is_default="defaulticon">
									</image-upload>

									<image-upload :label="lang('admin_logo')" :labelStyle="logoStyle" 
										:value="logo_admin_agent"
										name="logo_admin_agent" :onChange="onChange"
										classname="col-sm-4 text-center" :is_default="defaultlogo">
									</image-upload>

									<image-upload :label="lang('client_logo')" :labelStyle="logoStyle" :value="logo"
										name="logo" :onChange="onChange"
										classname="col-sm-4 text-center">
									</image-upload>

								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="card-footer">
				<button id="submit_btn" type="button" v-on:click="onSubmit()" :disabled="loading" class="btn btn-primary">
					<span class="fas fa-save"></span>&nbsp;{{lang('save')}}
				</button>
			</div>
		</div>
	</div>
</template>

<script>
	
	import axios from 'axios'

    import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

	import { companySettingsValidation } from '../../../../helpers/validator/companySettingRules.js'

	import {boolean} from '../../../../helpers/extraLogics'
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import NumberField from "../../../MiniComponent/FormField/NumberField.vue";
    import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
    import CheckBoxComponent from "../../../MiniComponent/FormField/CheckBoxComponent.vue";
    import ToolTip from "../../../MiniComponent/ToolTip.vue";
    import ColorPicker from "../../../MiniComponent/FormField/ColorPicker.vue";
    import ImageUpload from "../../../MiniComponent/FormField/ImageUpload.vue";
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import Switch from "../../../MiniComponent/FormField/Switch.vue";
  import phoneWithCountryCode from "../../../MiniComponent/FormField/PhoneWithCountryCode.vue";

	export default {

		name : 'company-settings',

		description : 'Company Settings page',

		props : {

		},

		data:()=>({

			loading : true,

			hasDataPopulated : false,

			company_name : "",

			uselogo : false,

			website : '',

			phone : '',

			address : '',

			admin_header_color : '', 

			agent_header_color : '', 

			admin_sidebar_color : '',

			agent_sidebar_color : '',

			header_colors : [
				{ id:'navbar-light', name:'White'},
				{ id:'navbar-dark navbar-blue', name:'Blue'},
				{ id:'navbar-dark navbar-black', name:'Black'},
				{ id:'navbar-dark navbar-green', name:'Green'},
				{ id:'navbar-dark navbar-purple', name:'Purple'},
				{ id:'navbar-dark navbar-red', name:'Red'},
				{ id:'navbar-light navbar-yellow', name:'Yellow'},
				{ id:'navbar-light navbar-orange', name:'Orange'},
			],

			sidebar_colors : [
				{ id:'sidebar-dark-light', name:'White'},
				{ id:'sidebar-dark-blue', name:'Blue'},
				{ id:'sidebar-dark-black', name:'Black'},
				{ id:'sidebar-dark-green', name:'Green'},
				{ id:'sidebar-dark-purple', name:'Purple'},
				{ id:'sidebar-dark-red', name:'Red'},
				{ id:'sidebar-dark-yellow', name:'Yellow'},
				{ id:'sidebar-dark-orange', name:'Orange'},
			],

			client_header_color: '',

			client_button_color : '',

			client_button_border_color : '',
			
			client_button_font_color : '',

			client_input_field_color : '',

			icon : '',

      logo_admin_agent : '',

			logo : '',

      selectedIcon : '',

      selectedLogoAdminAgent : '',

      selectedLogo : '',

			logoStyle : { visibility : 'hidden' },

			radioOptions:[{name:'yes',value:1},{name:'no',value:0}],

			defaulticon : 0,

			defaultlogo : 0,

			header_default : true,

			input_default : true,

			button_default : true,

			border_default : true,
			
			font_color_default : true,

			is_enabled_breadcrumb : false,

      phone_country_code: null,

      phone_iso :'',

      isPhoneValid: true,
		}),

		watch : {

			defaultlogo(newValue,oldValue){
				
				this.defaultlogo = boolean(newValue)

				return newValue
			},

			defaulticon(newValue,oldValue){
				
				this.defaulticon = boolean(newValue)

				return newValue
			}
		},

		beforeMount(){

			this.getInitialValues()
		},

		created(){

			this.defaulticon = boolean(this.defaulticon)

			this.defaultlogo = boolean(this.defaulticon)
		},

		methods :{

			getInitialValues(){

				this.loading = true

				axios.get('/getCompanyDetails').then(res=>{

					this.loading = false

					this.hasDataPopulated = true

					this.updatesStateWithData(res.data.message)

          this.phone_country_code = res.data.message.phone_country_code ? res.data.message.phone_country_code: null

          this.phone_iso = res.data.message.phone_iso ? res.data.message.phone_iso: null

        }).catch(error=>{

					this.loading = false;

					this.hasDataPopulated = true;
				})
			},

			updatesStateWithData(company){

				const self = this

				const stateData = this.$data

				Object.keys(company).map(key=>{

					if(stateData.hasOwnProperty(key)){

						self[key] = company[key];
					}
				})

				this.logo = company.clientlogo ? company.clientlogo : '';

        this.logo_admin_agent = company.logo;

				if(this.admin_header_color.includes('skin')){
					
					this.admin_header_color = this.admin_header_color.replace("skin", "navbar-dark navbar");

					this.admin_sidebar_color = this.admin_header_color.replace("navbar-dark navbar", "sidebar-dark");
				}

				if(this.agent_header_color.includes('skin')){
					
					this.agent_header_color = this.agent_header_color.replace("skin", "navbar-dark navbar");

					this.agent_sidebar_color = this.agent_header_color.replace("navbar-dark navbar", "sidebar-dark");
				}
				
				this.border_default = this.colorMethod('client_button_border_color',this.client_button_border_color,'#00c0ef')
				
				this.font_color_default = this.colorMethod('client_button_font_color',this.client_button_font_color,'#ffffff')

				this.button_default = this.colorMethod('client_button_color',this.client_button_color,'#009aba')

				this.header_default = this.colorMethod('client_header_color',this.client_header_color,'#009aba')

				this.input_default = this.colorMethod('client_input_field_color',this.client_input_field_color,'#d2d6de')
			},

			colorMethod(key,value,def){

				this[key] = value;

				return value === def ? true : false
			},

      checkValidity(name, value) {
        this.isPhoneValid = value;
      },

			isValid(){

				const { errors , isValid } = companySettingsValidation(this.$data)

				if(!isValid){

					return false
				}
				return true
			},

			validUrl(){

				if(this.website){

					let regex = /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/;

					if(this.website.match(regex)) {  return true } 

					else {
			    	
			    	this.$store.dispatch('setValidationError',{website: "Invalid URL"})	
			    }
			    
				} else {

					return true
				}
			},

			onChange(value,name){

        switch (name) {
          case 'icon':
            this.icon = value.image;
            let icon = value;
            this.selectedIcon = icon.file, icon.name;
            break;
          case 'logo_admin_agent':
            this.logo_admin_agent = value.image;
            let logo_admin_agent = value;
            this.selectedLogoAdminAgent = logo_admin_agent.file, logo_admin_agent.name;
            break;
          case 'logo':
            this.logo = value.image;
            let logo = value;
            this.selectedLogo = logo.file, logo.name;
            break;
          default:
            this[name] = value;
        }
			},

			onSubmit(){
				
				if(this.isValid() && this.validUrl() && this.isPhoneValid){
					
					this.loading = true 

					var fd = new FormData();
					
					fd.append('company_name', this.company_name)

					fd.append('address', this.address)

					fd.append('phone', this.phone)

					fd.append('website', this.website)

					fd.append('admin_header_color', this.admin_header_color)

					fd.append('agent_header_color', this.agent_header_color)

					fd.append('admin_sidebar_color', this.admin_sidebar_color)
					
					fd.append('agent_sidebar_color', this.agent_sidebar_color)

					fd.append('is_enabled_breadcrumb',this.is_enabled_breadcrumb ? 1 : 0)

					if(!this.defaulticon){

						fd.append('icon', this.selectedIcon ? this.selectedIcon : this.icon)
					}

					if(!this.defaultlogo){

						fd.append('logo_admin_agent', this.selectedLogoAdminAgent ? this.selectedLogoAdminAgent : this.logo_admin_agent)
					}

					fd.append('logo', this.logo === '' ? null : this.selectedLogo ? this.selectedLogo : this.logo)

					fd.append('uselogo', this.uselogo === true ? 1 : 0)

					fd.append('client_header_color',this.header_default ? '#009aba' : this.client_header_color)
					
					fd.append('client_button_color', this.button_default ? '#009aba' : this.client_button_color)

					fd.append('client_button_border_color', this.border_default ? '#00c0ef' : this.client_button_border_color)
					
					fd.append('client_button_font_color', this.font_color_default ? '#ffffff' : this.client_button_font_color)

					fd.append('client_input_field_color', this.input_default ? '#d2d6de' : this.client_input_field_color)

          fd.append('phone_country_code',this.phone_country_code)

          fd.append('phone_iso',this.phone_iso)

          const config = { headers: { 'Content-Type': 'multipart/form-data' } }

					axios.post('/postcompany', fd,config).then(res => {

						this.loading = false
						
						this.hasDataPopulated = true

						successHandler(res,'company-settings')

						window.emitter.emit('companySettingsUpdated')

					}).catch(err => {
						
						this.loading = false
						
						this.hasDataPopulated = true

						errorHandler(err,'company-settings')
					});
				}
			},
      onPhoneFieldUpdate(value, name) {
        this[name] = value;
      }

    },

		components :{

			'text-field' : TextField,

			"number-field": NumberField,

			'static-select': StaticSelect,

			'check-box': CheckBoxComponent,

			"tool-tip": ToolTip,

			'color-picker': ColorPicker,

			'image-upload': ImageUpload,

			'radio-button': RadioButton,

			'status-switch': Switch,

      'phoneWithCountryCode' : phoneWithCountryCode,
		}
	};
</script>

<style type="text/css" scoped>

	.label_align {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: normal!important; padding-top: 6px;
	}
	.checkbox_align {
		width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden;
	}
</style>