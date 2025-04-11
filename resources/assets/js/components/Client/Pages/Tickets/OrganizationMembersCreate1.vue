<template>
	
	<div>

		<meta-component :dynamic_title="title === 'edit_user' ? lang('edit-user-title') : lang('create-user-title')" 
			:dynamic_description="title === 'edit_user' ? lang('edit-user-description') : lang('create-user-description')"
                        :layout="layout" >
						
		</meta-component>

		<div v-if="loading || !hasDataPopulated">
				
			<loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
		</div>

		<div v-if="submitForm" class="row">

			<client-panel-loader :size="60" :color="layout.portal.client_header_color"></client-panel-loader>
		</div>

		<alert componentName="members"/>

		<div v-if="hasDataPopulated" class="row" :class="{align1: lang_locale == 'ar'}" >

			<div id="content" class="site-content col-sm-12">
								
				<header class="archive-header">
					
					<h1 class="archive-title">{{lang(title)}}</h1>
				</header>

				<div class="archive-list archive-news">

					<div class="row" v-focus-first-input>
						
						<text-field :label="lang('first_name')" :value="first_name" type="text" name="first_name" id="client_org_user_firstname"
							:onChange="onChange" classname="col-sm-6" :required="true" :inputStyle="inputStyle"></text-field>

						<text-field :label="lang('last_name')" :value="last_name" type="text" name="last_name" id="client_org_user_lastname"
							:onChange="onChange" classname="col-sm-6" :inputStyle="inputStyle"></text-field>
					</div>

					<div class="row">

						<text-field :label="lang('email')" :value="email" type="text" name="email" id="client_org_user_email"
							:onChange="onChange" classname="col-sm-6" :required="true" :inputStyle="inputStyle"></text-field>

						<text-field :label="lang('org_user_name')" :value="user_name" type="text" name="user_name" id="client_org_user_name"
							:onChange="onChange" classname="col-sm-6" :required="true" :inputStyle="inputStyle"></text-field>
					</div>

					<div class="row">

						<phoneWithCountryCode classname="col-sm-6" name="mobile" id="client_org_user_mobile" @validPhoneNumber="checkValidity"
							:onChange="onChange" :value="mobile" :countryCode="country_code" @countCode="getCountCode" :language="lang_locale" :inputStyle="inputStyle" :countryIso="iso" @countIso="getCountIso"
              fieldType="FIXED_LINE_OR_MOBILE">
							
						</phoneWithCountryCode>

						<number-field :label="lang('ext')" :value="ext" name="ext" classname="col-sm-2" id="client_org_user_ext"
							:onChange="onChange" type="number" :formStyle="inputStyle">
							
						</number-field>

						<number-field :label="lang('work_phone')" :value="phone_number" name="phone_number" classname="col-sm-4"
							:onChange="onChange" type="number" :formStyle="inputStyle" id="client_org_user_phone">
							
						</number-field>
					</div>

					<div class="row">

						<static-select :label="lang('organization')"  :elements="organizations" name="organization" 
							:value="organization" classname="col-sm-6" :onChange="onChange" :required="true" 
							:inputStyle="inputStyle" id="client_org_user_org">
									
						</static-select>


						<!-- <radio-button :options="banOptions" :label="lang('ban')" name="ban" :value="ban"
							:onChange="onChange" classname="col-sm-3">
							
						</radio-button> -->
					</div>

					<div class="row">

						<text-field :label="lang('address')" :value="internal_note" type="textarea" name="internal_note"
							:onChange="onChange" classname="col-sm-12" :inputStyle="inputStyle" id="client_org_user_address"></text-field>

						<div class="col-sm-12">
							
							<button @click="onSubmit()" class="btn btn-custom float-end" :class="{left: lang_locale == 'ar'}"
								:style="buttonStyle" :disabled="isDisabled" id="client_org_user_action">
								
								<i :class="iconClass"></i> {{ lang(btnName) }}
							</button>
						</div>
					</div>		
				</div>

				<footer class="archive-footer text-center">
				
				</footer>
			</div>
		</div>
	</div>
</template>

<script>
	
	import { successHandler, errorHandler } from '../../../../helpers/responseHandler';

	import  { getIdFromUrl } from '../../../../helpers/extraLogics';

	import { validateUserCreateSettings } from "../../../../helpers/validator/userCreateRules.js";

	import axios from 'axios'
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import phoneWithCountryCode from "../../../MiniComponent/FormField/PhoneWithCountryCode.vue";
    import NumberField from "../../../MiniComponent/FormField/NumberField.vue";
    import Loader from "../../ClientPanelLayoutComponents/ReusableComponents/Loader.vue";

	export default {

		name : 'create-user',

		description  : 'User create component',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},
		},

		data() {
			return {

				title : 'create_user',

				first_name : '',

				last_name : '',

				user_name : '',

				email : '',

				organizations : this.layout.organization,

				organization : '',

				active : 1,

				// banOptions : [{name:'yes',value:1},{name:'no',value:0}],

				// ban : 1,

				country_code: 91,
					
				mobile: '',

				ext : '',

				phone_number : '',

				internal_note : '',

				btnName : 'save',

				iconClass : 'fa fa-save',

				userId : '',

				isDisabled:false,

				apiUrl : '',
				
				base : this.auth.system_url,

				inputStyle: { borderColor : this.layout.portal.client_input_field_color},

				buttonStyle: { 

					borderColor : this.layout.portal.client_button_border_color,

					backgroundColor : this.layout.portal.client_button_color
				},

				lineStyle: { borderColor : this.layout.portal.client_header_color },

				loading : true,

				hasDataPopulated : false,

				submitForm : false,

				lang_locale : this.layout.language,

				meta_title:'',

				meta_des:'',

				iso : '',

        isPhoneValid: true
			}
		},

		beforeMount(){

			this.$Progress.start();

			const path = window.location.pathname
			
			this.getValues(path);
		},

		components: {

			'text-field': TextField,

			'static-select':StaticSelect,

			'radio-button':RadioButton,

			'phoneWithCountryCode': phoneWithCountryCode,

			"number-field": NumberField,

			'client-panel-loader' : Loader,
		},

		methods:{
			
			getValues(path){

				this.$Progress.start();

				this.$store.dispatch('unsetValidationError');

				this.userId = getIdFromUrl(path)

				if(path.indexOf('edit') >= 0){

					this.apiUrl='org/edit/user/'+this.userId;

					this.title = 'edit_user'

					this.iconClass = 'fas fa-sync'

					this.btnName = 'update'

					this.hasDataPopulated = false

					this.meta_title = 'user_edit-page-title';

					this.meta_des = 'user_edit-page-description';

					this.getInitialValues(this.userId)

				} else {

					this.apiUrl='client/user/create/';

					this.loading = false;

					this.hasDataPopulated = true;

					this.meta_title = 'user_create-page-title';
					
					this.meta_des = 'user_create-page-description';

					this.$Progress.finish();
				}
			},

			getInitialValues(id){
				
				this.$Progress.start();
				
				axios.get('client/organizations/edituser/'+id).then(res=>{
			 
					this.loading = false;

					this.hasDataPopulated = true

					this.organization = res.data.data.selectedorg;

					this.updateStatesWithData(res.data.data.user);

					this.$Progress.finish();
				}).catch(res=>{

					this.loading = false;

					this.hasDataPopulated = true;

					this.$Progress.fail();
				})
			},

			updateStatesWithData(data){

				const self = this;
				
				const stateData = this.$data;
				
				Object.keys(data).map(key => {
					
					if (stateData.hasOwnProperty(key)) {
					
						self[key] = data[key];
					}
				});

				this.mobile = this.mobile === 'Not available' ? '' : this.mobile;

				this.email = this.email === 'Not available' ? '' : this.email;

				this.country_code = this.country_code ? this.country_code : 91;
			},

			onChange(value,name){

				this[name] = value;
			},

			getCountCode(value){

				this.country_code = value;
			},

			getCountIso(value){
          	
          	this.iso = value;
        	},

      checkValidity(name, value) {
        this.isPhoneValid = value;
      },

			isValid() {

				const { errors, isValid } = validateUserCreateSettings(this.$data);
				
				if (!isValid) {
				
					return false;	
				}
					return true;
			},

			onSubmit(){

				if(this.isValid() && this.isPhoneValid){

					this.$Progress.start();

					this.isDisabled = true;

					this.submitForm = true;

					const data = {};

					data['first_name'] = this.first_name;
					
					data['last_name'] = this.last_name;
					
					data['user_name'] = this.user_name;
					
					data['email'] = this.email;

					data['active'] = this.active;

					data['org_id'] = this.organization.id ? this.organization.id : this.organization;

					data['code'] = this.country_code ? this.country_code : 91;

					data['mobile'] = this.mobile;

					data['ext'] = this.ext;

					data['phone_number'] = this.phone_number;

					data['iso'] = this.iso;

					data['internal_note'] = this.internal_note;

					// data['ban'] = this.ban;

					axios.post(this.apiUrl, data).then(res=> {

						this.$Progress.finish();
						
						this.isDisabled = false;
						
						this.submitForm = false;

						successHandler(res, 'members')

						this.$Progress.finish();

						setTimeout(()=>{

							this.$router.push('/organization/'+this.organization)
						},3000)
					}).catch(error=>{
					
						this.$Progress.fail();
												
						this.isDisabled = false;

						this.submitForm = false;

						errorHandler(error,'members');

						this.$Progress.fail();
					})
				}		
			},
		}
	};
</script>
<style scoped>

	.box {
    position: relative;
    border-radius: 3px;
    background: #ffffff;
    border-top: 3px solid #d2d6de;
    margin-bottom: 20px;
    width: 100%;
    box-shadow: 0 1px 1px rgba(0,0,0,0.1);
}

.box-header.with-border {
    border-bottom: 1px solid #f4f4f4;
}

.box-header {
    padding-left: 18px;
}
.box-header {
    color: #444;
    display: block;
    padding: 10px;
    position: relative;
}

.box-header .box-title {
    display: inline-block;
    font-size: 18px;
    margin: 0;
    line-height: 1;
}

.box-body {
    border-top-left-radius: 0;
    border-top-right-radius: 0;
    border-bottom-right-radius: 3px;
    border-bottom-left-radius: 3px;
    padding: 10px;
}
.user_align {
	direction: rtl;
}
</style>