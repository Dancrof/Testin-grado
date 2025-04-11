<template>
	<div class="col-sm-12">

		<div class="row" v-if="hasDataPopulated === false || loading === true">

			<custom-loader :duration="loadingSpeed"></custom-loader>

		</div>

		<alert componentName="package"/>

		<div class="card card-light" v-if="hasDataPopulated === true">

			<div class="card-header">
				
				<h3 class="card-title">{{lang(title)}}</h3>
			</div>
					
			<div class="card-body">
		
				<div class="row" v-focus-first-input>
			
					<text-field :label="lang('name')" :value="name" type="text"
						name="name" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-4"
						:required="true">
						
					</text-field>

					<number-field :label="lang('display_order')" :value="display_order" 
						name="display_order" classname="col-sm-4"
            :onChange="onChange" placeholder="n" type="number" :required="true">
            
          </number-field>

          <dynamic-select :label="lang('departments')" :multiple="true" name="departments" :prePopulate="true"
            classname="col-sm-4" apiEndpoint="/api/dependency/departments" :value="departments" :onChange="onChange">
          
          </dynamic-select>

				</div>

				<div class="row">
					
					<text-field :label="lang('description')" :value="description" 
						type="textarea" name="description"
						:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-12" :required="true">
							
					</text-field>

				</div>

				<div class="row">
					
					<static-select :label="lang('billing_cycle')"  
						:elements="cycle_options" name="validity" :value="validity" 
						classname="col-sm-4" :onChange="onChange" :required="true">
					</static-select>

					<radio-button :options="radioOptions" :label="lang('credit_type')" name="credit_type" :value="credit_type"
					:onChange="onChange" classname="form-group col-sm-4" >

					</radio-button>

					<div class="col-sm-2">

						<label for="package" class="col-sm-12 control-label">{{lang('status')}}</label>
						
						<div class="col-sm-2">

							<status-switch name="status" :value="status" :onChange="onChange"
								classname="pull-left" :bold="true">
							</status-switch>
						</div>
					</div>

          <div class="col-sm-2">

            <label for="package" class="col-sm-12 control-label">{{lang('private')}}</label>

            <div class="col-sm-2">

              <status-switch name="is_private" :value="is_private" :onChange="onChange"
                             classname="pull-left" :bold="true">
              </status-switch>
            </div>
          </div>
				</div>

                <div v-if="credit_type != 'all'" class="row">

                    <static-select :value="selected_option" name="selected_option" :elements="createOption" :label="lang('monthly_credit_reset_duration')"
                                   :onChange="onChange" classname="col-sm-6" :hide-empty-select="true" :hint="lang('package_schedule')" :required="true"/>

                    <number-field v-if="selected_option !== 'end_of_each_month'" :value="month_definition" name="month_definition"
                                   :label="lang('number_of_days')" type="number"
                                   :onChange="onChange" placeholder="n" classname="col-sm-6" :required="true"/>

                </div>
				
				<div class="row">

					<number-field :label="lang('incident_credit')" :value="allowed_tickets"
						name="allowed_tickets" classname="col-sm-6"
            :onChange="onChange" placeholder="n" type="number" :required="true">

          </number-field>

					<number-field :label="lang('price')" :value="price"
						name="price" classname="col-sm-6"
            :onChange="onChange" placeholder="n" type="number" :required="true">

          </number-field>
				</div>

				<div class="row">

					<text-field :label="lang('terms_conditions_page_link')" :value="kb_link"
						type="text" name="kb_link"
						:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6">

					</text-field>

					<file-upload :label="lang('image')" :value="package_pic" name="package_pic"
					:onChange="onChange" classname="col-sm-6" accept="image/*">
					</file-upload>
				</div>

			</div>

			<div class="card-footer">

				<button type="button" id="submit_btn" v-on:click="onSubmit()" :disabled="loading" class="btn btn-primary">

					<span :class="iconClass"></span>&nbsp;{{lang(btnName)}}

				</button>
			</div>

		</div>

	</div>
</template>

<script>

	import axios from "axios";
	
	import {errorHandler,successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
	
	import {validatePackageCreateSettings} from "../../helpers/validator/packageCreateRules";
	
	import {getIdFromUrl} from "../../../../../../resources/assets/js/helpers/extraLogics";
	
	import { useStore } from 'vuex'
	import {computed} from "vue";
	import TextField from "../../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";
	import NumberField from "../../../../../../resources/assets/js/components/MiniComponent/FormField/NumberField.vue";
	import RadioButton from "../../../../../../resources/assets/js/components/MiniComponent/FormField/RadioButton.vue";
	import StaticSelect
		from "../../../../../../resources/assets/js/components/MiniComponent/FormField/StaticSelect.vue";
	import DynamicSelect
		from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DynamicSelect.vue";
	import Switch from "../../../../../../resources/assets/js/components/MiniComponent/FormField/Switch.vue";
	import DayHourMinuteField
		from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DayHourMinuteField.vue";
	import fileUpload from "../../../../../../resources/assets/js/components/MiniComponent/FormField/fileUpload.vue";

	export default {

		name : 'pacakges',

		description : 'Pacakges data table component',

		setup() {

			const store = useStore()

			return {

				getUserData : computed(()=>store.getters.getUserData)
			}
		},

		data(){

			return {

				base : '',

				name : '',

				credit_type : 'all',

				description : '',

				display_order : '',

				status : 0,

				radioOptions : [{name:'ticket_credit_overall',value:'all'},{name:'ticket_credit_monthly',value:'monthly'}],

        is_private : 0,


				cycle_options : [
					{ id:"one_time",name:"One time" },
					{ id:"monthly",name:"Monthly" },
					{ id:"quarterly",name:"Quarterly" },
					{ id:"semi_annually",name:"Semi annually" },
					{ id:"annually",name:"Annually" }
                ],

				validity : 'one_time',

				title :'create_new_package',

				iconClass:'fas fa-save',

				btnName:'save',

				loading: false,//loader status

				loadingSpeed: 4000,

				hasDataPopulated: true,

				package_id :'',

				formStyle:{ width:'15%' },

        price : '',

        allowed_tickets : '',

        package_pic : '',

        kb_link : '',

        departments : [],

        month_definition: 31,

        createOption : [
              {id:'end_of_each_month', name:'At the end of each month'},
              {id:'after_specific_number_of_days', name:'After x days of credit purchase'}
        ],

        selected_option : 'end_of_each_month',

		}
		},

		watch : {

			getUserData(newValue,oldValue){

				this.base = newValue.system_url

	   		return newValue
		   }
		},

		beforeMount(){

			const path = window.location.pathname;

			this.getValues(path);

            if(this.validity == 'monthly') {

                this.radioOptions = [{name:'ticket_credit_overall',value:'all'}];

                this.credit_type = 'all';
            }
		},

		created(){

			if(this.getUserData.system_url){
				this.base = this.getUserData.system_url
			}
		},

		methods : {

			getValues(path){

				const packageId = getIdFromUrl(path);

				if (path.indexOf("edit") >= 0) {

					this.title = 'edit-package';

					this.iconClass = 'fas fa-sync'

					this.btnName = 'update'

					this.hasDataPopulated = false;

					this.getInitialValues(packageId);

				 } else {

					this.loading = false;

					this.hasDataPopulated = true
				}
			},

			getInitialValues(id) {

				this.loading = true;

				axios.get('/api/bill/package/edit/'+id).then(res => {

					this.package_id  = id

					this.hasDataPopulated = true;

					this.loading = false;

					this.updateStatesWithData(res.data.data);

				}).catch(err => {

					errorHandler(err)

					this.hasDataPopulated = true;

					this.loading = false;

				});

			},

			updateStatesWithData(packageData) {

				const self = this;

				const stateData = this.$data;

				Object.keys(packageData).map(key => {

					if (stateData.hasOwnProperty(key)) {

						self[key] = packageData[key];

					}

				});

                this.credit_type = packageData.allowed_tickets_period;

                if(this.validity == 'monthly') {

                    this.radioOptions = [{name:'ticket_credit_overall',value:'all'}];

                    this.credit_type = 'all';
                }

                if (this.month_definition.includes('-days')) {
                    this.selected_option = 'after_specific_number_of_days';
                    this.month_definition = this.month_definition.replace('-days', '');
                } else {
                    this.selected_option = 'end_of_each_month';
                    this.month_definition = 0;
                }

			},

			isValid() {

				const { errors, isValid } = validatePackageCreateSettings(this.$data);

				if (!isValid) {

					return false;

				}

                return true;

			},

			onSubmit() {

				this.kb_link = this.kb_link === null ? '' : this.kb_link;

				if (this.isValid()) {

					this.loadingSpeed = 8000;

					this.loading = true;

					var fd = new FormData();

					if(this.package_id != ''){

						fd.append('id',parseInt(this.package_id));

					}

					fd.append('name', this.name)

					fd.append('status', this.status === true || this.status === 1 ? 1 : 0)

          fd.append('is_private', this.is_private === true || this.is_private === 1 ? 1 : 0)

					fd.append('description', this.description)

					fd.append('display_order', this.display_order)

					fd.append('price', parseInt(this.price))

					fd.append('validity', this.validity)

					if(this.departments.length > 0){

						fd.append('departments', this.departments.map(a => a.id))
					}

					fd.append('period', this.credit_type);

					fd.append('allowed_tickets', this.allowed_tickets);
					//Faveo ke purvajon Bhagwaan iskliye tumhe kabhi maaf nhi krega

          if (this.package_pic && this.package_pic.id) {

            fd.append('package_pic_id', this.package_pic.id);
          }else if(this.package_pic === null){

            fd.append('package_pic', '')
          } else{

            this.package_pic.length===1?fd.append('package_pic', this.package_pic.shift()):fd.append('package_pic', this.package_pic)
          }

					fd.append('kb_link', this.kb_link)

                    if(this.credit_type !=='all'){

                        fd.append('month_definition', this.selected_option == 'after_specific_number_of_days' ? this.month_definition+'-days' : 'months_end' );
                    }

					const config = { headers: { 'Content-Type': 'multipart/form-data' } }

					axios.post('/bill/package/store-update', fd,config).then(res => {

						this.loading = false;

						successHandler(res,'package');

						if(this.package_id === ''){

							setTimeout(()=>{
								this.$router.push({ name : 'Packages Index' });
							},3000);

						}else {
							this.getInitialValues(this.package_id)
						}

					}).catch(err => {

						this.loading = false;

						errorHandler(err,'package');
					});
				}
			},

			onChange(value,name){

				this[name] = value;

                if(name == 'validity') {

                    if(value == 'monthly') {

                        this.radioOptions = [{name:'ticket_credit_overall',value:'all'}];

                        this.credit_type = 'all';

                        this.selected_option = 'end_of_each_month'

                    } else {

                        this.radioOptions = [{name:'ticket_credit_overall',value:'all'},{name:'ticket_credit_monthly',value:'monthly'}];

                        this.credit_type = this.credit_type;
                    }
                }
			}
		},

		components : {
			
		'text-field': TextField,
		
		'number-field': NumberField,
		
		'radio-button': RadioButton,

		'static-select': StaticSelect,

		'dynamic-select': DynamicSelect,

		'status-switch': Switch,

		'time-field': DayHourMinuteField,

		'file-upload': fileUpload,
		}
	};
</script>