<template>
	
		<div id="content" class="site-content col-md-12" :class="{'edit_pass align1' : language === 'ar'}">

			<div class="row" v-focus-first-input>
				<text-field :label="lang('old_password')" :value="old_password" type="password" name="old_password" 
					:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-4" :required="true" :inputStyle="inputStyle" id="client_change_pass_old">
									
				</text-field>
				
				<text-field :label="lang('new_password')" :value="new_password" type="password" name="new_password" 
					:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-4" :required="true" :inputStyle="inputStyle" id="client_change_pass_new">
									
				</text-field>

				<text-field :label="lang('confirm_password')" :value="confirm_password" type="password" id="client_change_pass_confirm"
					name="confirm_password" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-4" :required="true" :inputStyle="inputStyle">
									
				</text-field>
			</div>

			<div class="row" v-if="loading === true">

        <client-panel-loader :color="layout.portal.client_header_color" :size="60"></client-panel-loader>
      </div>

			<div>
				
				<hr/>
				
				<button @click="onUpdate()" class="btn btn-custom float-end" :class="{left : language === 'ar'}"
					:style="buttonStyle" id="client_change_pass_action">
					
					<i class="fas fa-sync"> </i> {{ lang('update') }}
				</button>
			</div>
		</div>
</template>

<script>
	
	import { errorHandler, successHandler } from '../../../../helpers/responseHandler'

	import { validatePasswordSettings } from "../../../../helpers/validator/passwordSettings.js"

    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import Loader from "../../ClientPanelLayoutComponents/ReusableComponents/Loader.vue";

	export default{

		name : 'change-password',

		description : 'Channge password component',

		props : {

			layout : { type : Object, default : ()=>{}},
			
			auth : { type : Object, default : ()=>{}},
		},

		data() {

			return {

				old_password : '',

				new_password : '',

				confirm_password : '',

				loading : false,

				isDisabled : false,

				buttonStyle : {

					borderColor : this.layout.portal.client_button_border_color,
					color : this.layout.portal.client_button_font_color + ' !important',
					backgroundColor : this.layout.portal.client_button_color
				},

				inputStyle : { borderColor : this.layout.portal.client_input_field_color },

				language : this.layout.language
			}
		},

		methods : {

			onChange(value, name) {
	      
	      this[name] = value;
	    },

	    isValid(){
				
				const {errors, isValid} = validatePasswordSettings(this.$data);
				
				if(!isValid){
				
					return false
				}
				return true
			},

			onUpdate(){

      	if(this.isValid()){

      		if(this.old_password !== this.new_password){

      			if(this.new_password === this.confirm_password){

							this.isDisabled=true;
							
							this.loading=true;

		      		this.$Progress.start();
							
							const data={};

							data['old_password']=this.old_password;
							
							data['new_password']=this.new_password;
							
							data['confirm_password']=this.confirm_password;

							axios.post('api/password/change',data).then(res=> {
								
								this.$Progress.finish();
								
								this.loading=false;

								this.isDisabled=false;
								
								successHandler(res,'edit_profile');

                setTimeout(()=>{
                  this.$store.dispatch('deleteUser')

                  this.$store.dispatch('updateUser')
                },2000)

							}).catch(error=>{

								this.$Progress.fail();

								this.loading=false;

								this.isDisabled=false;

								errorHandler(error,'edit_profile')
							})
		      	}else {

		      		this.$store.dispatch('setValidationError', {'confirm_password' : 'Password does not match'})
		      	}
      		}else {

		      	this.$store.dispatch('setValidationError', {'new_password' : 'new password is same as old. Please choose a different password'})
		      }
      	} 
      }
		},

		components : {

			"text-field": TextField,

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

	.edit_pass {
		direction : rtl;
	}
</style>