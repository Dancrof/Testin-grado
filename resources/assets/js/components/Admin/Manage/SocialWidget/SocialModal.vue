<template>
	<div>
		<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">


			<template #title>

				<h4 class="modal-title">{{lang(modalMode)}}</h4>

			</template>

            <template #alert>

                <alert componentName="widget-Modal"/>

            </template>

			<template #fields>

				<div class="row" v-focus-first-input>

 <text-field :label="lang('Link')"  :onChange="onChange" :required="true" :placehold="lang('enter_a_value')" :value="value" type="URL" name="value" :keyupListener="triggerEvent"
							classname="col-sm-12" >

						</text-field>

				</div>

        <div v-if="loading" slot="fields" >

          <custom-loader :duration="4000"></custom-loader>
        </div>

			</template>



        <!-- TODO add modal box content here -->

						
			<template #controls>


				<button  type="button" id="submit_btn" @click="onSubmit()" class="btn btn-primary" :disabled="isValueEmpty"><i class="fas fa-sync" aria-hidden="true"></i> {{lang('update')}}</button>
				
			</template>

		</modal>
	</div>
</template>

<script type="text/javascript">

    import { errorHandler, successHandler } from "../../../../helpers/responseHandler";
    import { validateSocialModalFormFields } from "../../../../helpers/validator/socialModalValidations.js";

	import axios from 'axios';
    import TextField from "../../../MiniComponent/FormField/TextField.vue";

	export default {

		name : 'Social-Modal',

		description : 'Social Modal component',

		props:{
			data : { type : Object, required : true },

 	/**
			 * status of the modal popup
			 * @type {Object}
			 */
      showModal:{type:Boolean,default:false},

			/**
			 * The function which will be called as soon as user click on the close button
			 * @type {Function}
			*/
			onClose:{type: Function},

      /**
       * Mode of the modal, edit/view
       */
			modalMode : { type: String , required : true },
		},


		data:()=>{
			return {
				/**
				 * width of the modal container
				 * @type {Object}
				 */
				containerStyle:{
					width:'500px',

				},

				// name:"",
				value:"",

				/**
				 * initial state of loader
				 * @type {Boolean}
				 */
				loading:false,

			}
		},

    beforeUnmount() {
      // Unset the validation error when the modal is closed
      this.$store.dispatch('unsetValidationError');
    },

    beforeMount(){
			// this.name=this.data.name
      // sets the value as empty string if the value is null
			this.value = this.data.value === null ? '' : this.data.value;
		},

		created(){
		// getting locale from localStorage
			this.lang_locale = localStorage.getItem('LANGUAGE');
			this.ticketId = this.getStoredTicketId;
		},

		methods:{
			 onChange(value, name){
            this[name] = value;
		},


		/**
		 * api calls happens here
		 * @return {Void}
		 */
			onSubmit() {

				 if(this.isValidInputs()) {
				this.loading = true;
				let params = this.getSubmitParams();
				axios.post('api/update-widget/' + this.data.id, params)

					.then(res => {
						this.loading = false;
						this.onClose();
						successHandler(res, 'dataTableModal');
						window.emitter.emit('refreshData')
					})
					.catch(err => {
						this.loading = false;
						errorHandler(err, 'widget-Modal');
					});
				 }
			},



		getSubmitParams(){
			 let params = {
				//  title: this.name,
				 value: this.value,

			}
			return params;

		},

		 /**
         * This method validates the user input for mandatory fields
         * @return {Boolean}
         */
         isValidInputs() {
          const {errors, isValid} = validateSocialModalFormFields(this.$data);
          return isValid;
         },
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },

	},

    watch: {
      // Monitors the validators when the value changes
      value(newVal, oldVal) {
          this.isValidInputs();
      }
    },

    computed: {
      // Checks if the value is empty
      isValueEmpty() {
        // Check if `value` is not null or undefined before calling `trim()`
        return this.value ? !this.value.trim() : true;
      }
    },

	components:{
		'text-field': TextField
	}


};


</script>
