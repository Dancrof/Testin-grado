<template>
		
		<div id="content" class="site-content col-md-12">
				
			<div class="row">
			
				<div class="col-sm-3" :class="{float1 : language === 'ar'}">

					<image-crop :value="profile_pic" name="profile_pic" :onChange="onChange"
					            :classname="{float1 : language === 'ar'}" :language="language" :btn-style="btnStyle">

					</image-crop>
				</div>
				
				<div class="col-md-9" :class="{'edit_pro align1' : language === 'ar'}">

					<faveo-form-client-panel panel="client" category="requester" :editApiEndpoint="'/user/edit/api/'+auth.user_data.id"
						:disableEmail="true" :layout="layout" :inputStyle="inputStyle" :btnStyle="btnStyle" scenario="edit" :editId="auth.user_data.id">

					</faveo-form-client-panel>
				</div>
			</div>

			<div class="row" v-if="loading === true">

            <client-panel-loader :color="layout.portal.client_header_color" :size="60"></client-panel-loader>
        </div>
		</div>
</template>

<script>

	import { errorHandler, successHandler } from '../../../../helpers/responseHandler'

	import { validateProfileSettings } from "../../../../helpers/validator/profileSettings.js"

	import axios from 'axios'

    import FaveoFormClientPanel from "../../FaveoFormClientPanel.vue";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import NumberField from "../../../MiniComponent/FormField/NumberField.vue";
    import PhoneWithCountryCode from "../../../MiniComponent/FormField/PhoneWithCountryCode.vue";
    import ImageCrop from "../ReusableComponents/ImageCrop.vue";
    import Loader from "../../ClientPanelLayoutComponents/ReusableComponents/Loader.vue";

	export default{

		name : 'edit-profile',

		description : 'Profile edit component',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},
		},

		data() {

			return {

				loading : true,

				first_name : '',

				last_name : '',

				email : '',

				country_code: 91,
     		
     		mobile: '',

     		phone_number : '',

     		ext : '',

     		profile_pic : '',

     		profile_pic_name : '',

     		btnStyle : {

     			borderColor : this.layout.portal.client_button_border_color,
		        color : this.layout.portal.client_button_font_color + ' !important',
     			backgroundColor : this.layout.portal.client_button_color
     		},

     		inputStyle : { borderColor : this.layout.portal.client_input_field_color },

     		selectedImage : '',

     		language : this.layout.language,

     		iso : ''
			}
		},

		watch : {

		},

		beforeMount(){

			this.$Progress.start();

			this.updateStatesWithData(this.auth.user_data)

		},

		created() {

			window.emitter.on('clientFormSubmitted',this.updateUserData);
		},

		methods : {

			updateStatesWithData(data){

				const self = this;
				
				const stateData = this.$data;
				
				Object.keys(data).map(key => {
					
					if (stateData.hasOwnProperty(key)) {
					
						self[key] = data[key];
					
					}

				});

				this.mobile = this.mobile === 'Not available' ? '' : this.mobile;

				this.country_code = this.country_code === '' ? 91 : this.country_code;

				this.loading = false

				this.$Progress.finish();
			},

			onChange(value, name) {

	      if(name === 'profile_pic'){

	      		this.profile_pic = value.image;

	      		this.selectedImage = value;

				  this.onUpdate();

	      } else {

	      	this[name] = value;
	      }
	    },

	    getCountCode(value){

        this.country_code = value;
      },

      getCountIso(value){
          	
          	this.iso = value;
        	},

      isValid(){
				
				const {errors, isValid} = validateProfileSettings(this.$data);
				
				if(!isValid){
				
					return false
				}
				return true
			},

      onUpdate(){

      	if(this.isValid()){

					this.isDisabled=true;
					
					this.loading=true;

      		this.$Progress.start();
				
					var fd = new FormData();

					if(this.selectedImage){

						fd.append('profile_pic', this.selectedImage.file,this.selectedImage.name);
					}
					
					// fd.append('_method', "PATCH");
					
					axios.post('api/profile-image/edit', fd).then(res=> {
						
						this.$Progress.finish();
						
						successHandler(res,'edit_profile');

						this.updateUserData()
							
					}).catch(error=>{

						this.$Progress.fail();

						this.loading=false;

						this.isDisabled=false;

						errorHandler(error,'edit_profile')
					})
      	}
      },

      updateUserData(){

      	this.$Progress.start();

      	axios.get('/api/get-auth-info').then(res=>{

      		this.loading=false;

					this.isDisabled=false;

					this.updateStatesWithData(res.data.data.user_data);

					window.emitter.emit('updateUserData',res.data.data.user_data)
					
					window.emitter.emit('updateProfileData',res.data.data)
      		
      		this.$Progress.finish();

      	}).catch(error=>{

      		this.loading=false;

					this.isDisabled=false;

					this.$Progress.fail();
      	})
      }
		},

		components : {

			'faveo-form-client-panel': FaveoFormClientPanel,

			"text-field": TextField,

			"radio-button": RadioButton,

			"number-field": NumberField,

			'phoneWithCountryCode': PhoneWithCountryCode,

			'image-crop': ImageCrop,

			'client-panel-loader' : Loader,
		}
	};
</script>

<style scoped>
	
	#profile_tab {

		cursor: pointer;
	}

	#content {

		margin-top: 15px !important;
	}
	.edit_pro{
		float: left !important;
		direction: rtl;
	}
</style>