<template>

	<div class="col-sm-12">

		<div class="row" v-if="!hasDataPopulated || loading">

			<custom-loader :duration="4000"></custom-loader>
		</div>

		<alert componentName="location-create-edit"/>

		<faveo-box v-if="hasDataPopulated" :title="trans(page_title)">

			<div class="row" v-focus-first-input>

				<text-field :label="trans('title')" :value="title"
					type="text"
					name="title"
					:onChange="onChange"
                    :placehold="lang('enter_a_value')"
                    :keyupListener="triggerEvent"
					classname="col-sm-6"
					:required="true"
					>
				</text-field>

        <phoneWithCountryCode id="phone" classname="col-sm-4" name="phone" :onChange="onChange" :value="phone"
                              :countryCode="phone_country_code"  :countryIso="phone_iso" @countCode="onPhoneFieldUpdate($event, 'phone_country_code')"
                              @countIso="onPhoneFieldUpdate($event, 'phone_iso')" :keyupListener="triggerEvent"
                              labelName="phone" :apiUrl="'/api/dependency/country-codes?time='+Date.now()" @validPhoneNumber="checkValidity"
                              fieldType="FIXED_LINE_OR_MOBILE">
        </phoneWithCountryCode>

			</div>

			<div class="row">

				<dynamic-select :label="trans('country')" :multiple="false" name="country_id" classname="col-sm-6" :clearable="country_id ? true : false"
					apiEndpoint="/api/dependency/country-codes?limit=all" :value="country_id" :onChange="onChange" :required="false" strlength="40">
				</dynamic-select>

				<dynamic-select :label="trans('state')" :multiple="false" name="state_id" classname="col-sm-6" :required="false" strlength="40"
					:apiEndpoint="stateEndpoint" :value="state_id" :onChange="onChange"
					:clearable="state_id ? true : false" :disabled="country_id ? false : true">
				</dynamic-select>
			</div>

			<div class="row">

				<text-field :label="trans('city')" :value="city" type="text" name="city" :onChange="onChange" :placehold="lang('enter_a_value')"    :keyupListener="triggerEvent" classname="col-sm-6" :required="false">

				</text-field>

				<text-field :label="trans('pincode')" :value="pincode" type="text" name="pincode" :onChange="onChange" :placehold="lang('enter_a_value')"   :keyupListener="triggerEvent" classname="col-sm-6" :required="false">

				</text-field>
			</div>

			<div class="row">

				<text-field :label="trans('address')" :value="address"
					type="textarea"
					name="address"
					:onChange="onChange"
                    :placehold="lang('enter_a_value')"
                    :keyupListener="triggerEvent"
					classname="col-sm-12"
					>
				</text-field>
			</div>

			<template #actions>
				<div class="card-footer">

					<button id="submit_btn" class="btn btn-primary" @click="onSubmit()">

						<i :class="iconClass"></i> {{trans(btnName)}}
					</button>
				</div>
			</template>
		</faveo-box>
	</div>
</template>

<script>

	import axios from 'axios'

	import {successHandler,errorHandler} from "../../../../../resources/assets/js/helpers/responseHandler";
	
	import  { getIdFromUrl } from "../../../../../resources/assets/js/helpers/extraLogics";

	import {validateLocationSettings} from "../helpers/validator/locationValidation";
	import TextField from "../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";
	import NumberField from "../../../../../resources/assets/js/components/MiniComponent/FormField/NumberField.vue";
	import DynamicSelect from "../../../../../resources/assets/js/components/MiniComponent/FormField/DynamicSelect.vue";
  import phoneWithCountryCode
    from "../../../../../resources/assets/js/components/MiniComponent/FormField/PhoneWithCountryCode.vue";

	export default {

		name : 'location-create-edit',

		description  : 'Location create edit page',

		data(){

			return {

				page_title : 'create_location',

				iconClass : 'fas fa-save',

				btnName : 'save',

				hasDataPopulated : false,

				loading : false,

				// essentials
				location_id : '',

				title : '',

				phone : '',

				address : '',

				state_id : '',

				country_id : '',

				city : '',

				pincode : '',

        phone_country_code: null,

        phone_iso :'',

        isPhoneValid: true,
			}
		},

		computed : {

			stateEndpoint() {

				return this.country_id ? '/api/dependency/states?supplements=' +  this.country_id.id : '/api/dependency/states?supplements='
			}
		},

		beforeMount(){

			const path = window.location.pathname

			this.getValues(path);
		},

		methods : {

			getValues(path){

				const locationId = getIdFromUrl(path)

				if(path.indexOf('edit') >= 0){

					this.page_title = 'edit_location'

					this.iconClass = 'fas fa-sync'

					this.btnName = 'update'

					this.hasDataPopulated = false

					this.getInitialValues(locationId)

				} else {

					this.loading = false;

					this.hasDataPopulated = true;
				}
			},

			getInitialValues(id){

				this.loading = true

				axios.get('/api/location/'+id).then(res=>{

					this.loading = false;

					this.hasDataPopulated = true

					let locationData = res.data.data.location;

					this.location_id = locationData.id;

					this.title = locationData.title;

					this.phone = locationData.phone;

					this.address = locationData.address;

					this.city = locationData.city;

					this.country_id = locationData.country;

					this.state_id = locationData.state;

					this.pincode = locationData.pin_code;

          this.phone_country_code = locationData.phone_country_code ? locationData.phone_country_code: null

          this.phone_iso = locationData.phone_iso ? locationData.phone_iso: null


        }).catch(error=>{

					this.loading = false;

					errorHandler(error,'location-create-edit')
				});
			},

			isValid(){

				const { errors, isValid } = validateLocationSettings(this.$data);

				return isValid;
			},

			onChange(value, name) {

				this[name] = value;

				if(name == 'country_id') {

					this.state_id = '';
				}
			},

      checkValidity(name, value) {
        this.isPhoneValid = value;
      },

			onSubmit(){

				if(this.isValid() && this.isPhoneValid){

					this.loading = true

					let data = {};

					data['title'] = this.title;

					if(this.phone) { data['phone'] = this.phone; }

					if(this.address) { data['address'] = this.address; }

					if(this.country_id) { data['country_id'] =  this.country_id.id }

					if(this.state_id && this.country_id) { data['state_id'] =  this.state_id.id }

					if(this.city) { data['city'] =  this.city }

					if(this.pincode) { data['pincode'] =  this.pincode }

          if(this.phone_country_code !== null){

            data['phone'] = this.phone;

            data['phone_country_code'] = this.phone_country_code;

            data['phone_iso'] = this.phone_iso;

          }

					let apiUrl =  '/api/location';

					if(this.page_title == 'edit_location') {

						apiUrl = '/api/location-update/'+this.location_id;

					}

					axios.post(apiUrl, data).then(res => {

						this.loading = false

						successHandler(res,'location-create-edit')

						if(!this.location_id){

							setTimeout(()=>{
								this.$router.push({ name : 'Location Index'})
							},3000);

						} else {

							this.getInitialValues(this.location_id)
						}
					}).catch(err => {

						this.loading = false

						errorHandler(err,'location-create-edit')
					});
				}
			},
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },

      onPhoneFieldUpdate(value, name) {
        this[name] = value;
      }

		},
		components  : {

			"text-field": TextField,

			'number-field': NumberField,

			'dynamic-select': DynamicSelect,

      'phoneWithCountryCode' : phoneWithCountryCode,
		}
	};
</script>
