<template>

  <div class="col-sm-12">

    <div class="row" v-if="!hasDataPopulated || loading">

      <custom-loader :duration="4000"></custom-loader>

    </div>

    <alert componentName="CreateEditSchedule"/>

    <div class="card card-light" v-if="hasDataPopulated">

      <div class="card-header">

        <div class="card-title">{{trans(title)}}</div>

      </div>

      <div class="card-body">

        <div class="row" v-focus-first-input>

          <static-select :label="trans('schedule_by')"
                         :elements="schedule_List" :hide-empty-select="true" name="schedule" :value="schedule"
                         classname="col-sm-6" :onChange="onChange" >
          </static-select>

          <tree-select v-if="schedule==='weekly'" name="day" :label="trans('weekly')" :elements="day_List" :multiple="true"
                       classname="col-sm-6" :required="true" :onChange="onChange" :value="day" valueFormat="array" strlength="50">

          </tree-select>

          <tree-select v-if="schedule==='monthly'" name="day" :label="trans('monthly')" :elements="Monthly" :multiple="true"
                       classname="col-sm-6" :required="true" :onChange="onChange" :value="day" valueFormat="array">

          </tree-select>

          <date-time-field  :label="trans('execute_at')" :value="moment(delivery_time,'HH:mm')" :required="true" name="delivery_time"
                            type="time" :onChange="onChangeDeliveryTime" :time-picker-options="timeOptions"
                            format="HH:mm" place="select_time_to_generate_report" :checkManual="true"
                            classname="col-sm-6">
          </date-time-field>


          <dynamic-select
                          :label="trans('notify_assign')" :multiple="true" :required="true"
                          name="notify_persons" classname="col-sm-6" apiEndpoint="/api/dependency/agents?meta=true"
                          :value="notify_persons" :onChange="onChange" strlength="25" :auth="auth">
          </dynamic-select>

        </div>

        <text-field :label="trans('subject')" :value="subject" type="text" name="subject"
                    :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-12" :required="true"></text-field>


        <tiny-editor :value="description" type="text" :onChange="onChange" name="description" :label="lang('description')"
                     classname="col-sm-12" :required="true" :lang="'en'" id="schedule_editor">

        </tiny-editor>


        <div class="row">

          <div v-if="!hideExt" class="col-sm-6">
            <radio-button
                :label="trans('export_as:')"
                :onChange="onChange"
                :options="exportOptions"
                :required="true"
                :value="ext"
                name="ext"/>
          </div>

          <div class="col-sm-6" :class="hideExt ? 'ps-3' : ''">
            <label for="status"> {{trans('status')}} </label>
            <status-switch name="status" :value=status :onChange="onChange" :bold="true">
            </status-switch>
          </div>

        </div>

      </div>

      <div class="card-footer">

        <button type="button"  @click="onSubmit()" class="btn btn-primary">

          <i :class="iconClass"></i> {{trans(btnName)}}
        </button>

      </div>

    </div>

  </div>

</template>

<script>
import StaticSelect from "../../../../../../resources/assets/js/components/MiniComponent/FormField/StaticSelect.vue";
import TextField from "../../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";
import RadioButton from "../../../../../../resources/assets/js/components/MiniComponent/FormField/RadioButton.vue";
import DateTimePicker
	from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DateTimePicker.vue";
import {successHandler, errorHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";

import moment from "moment"
import DynamicSelect from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DynamicSelect.vue";
import {getIdFromUrl} from "../../../../../../resources/assets/js/helpers/extraLogics";
import {validateSchedule} from "../../../../../../resources/assets/js/helpers/validator/reportSchedule";
import StatusSwitch from "../../../../../../resources/assets/js/components/MiniComponent/FormField/Switch.vue";
import TreeSelect from "../../../../../../resources/assets/js/components/MiniComponent/FormField/TreeSelect.vue";


export default {
	name: "CreateEditSchedule",

	components:{
    TreeSelect,

    'dynamic-select':DynamicSelect,
		'date-time-field':DateTimePicker,
		'static-select':StaticSelect,
		'text-field':TextField,
		'radio-button':RadioButton,
    'status-switch':StatusSwitch
	},

  props : {

    auth : { type : Object, default : ()=> {}}
  },

	data(){

		return {

			moment:moment,

      hasDataPopulated: false,

			loading: false,

			schedule_List: [
				{id: 'daily', name: 'Daily'},
				{id: 'weekly', name: 'Weekly'},
				{id: 'monthly', name: 'Monthly'}
			],

			schedule: 'daily',

			timeOptions:{
				start: '00:00:00',
				step: '00:30:00',
				end: '23:30:00'
			},

			delivery_time:'',

			day_List: [
				{id: 'Monday', name: 'Monday'},
				{id: 'Tuesday', name: 'Tuesday'},
				{id: 'Wednesday', name: 'Wednesday'},
				{id: 'Thursday', name: 'Thursday'},
				{id: 'Friday', name: 'Friday'},
				{id: 'Saturday', name: 'Saturday'},
				{id: 'Sunday', name: 'Sunday'},
			],

			day: [],

			Monthly:[
				...Array.from({ length: 31 }, (val, index) => ({
          id: (index + 1).toString(),
          name: (index + 1).toString(),
				})),
			] ,

			subject:'',

			description:'',

      notify_persons:[],

			exportOptions:[{name: 'CSV', value: 'csv'}, {name: 'Excel', value: 'xlsx'}],

			ext:'csv',

			labelStyle: {display: 'none'},

			url: '',

			btnName: 'save',

			title: 'create_schedule',

			iconClass : 'fas fa-save',

      scheduledData:[],

      scheduleId:'',

      reportId:'',

      notifyPerson: false,

      edit : false,

      clearable: true,

      status:true,

      hideExt: false,

		}

	},

  beforeMount() {
    // Get the current URL and split it into parts
    const currentURL = window.location.href;
    const parts = currentURL.split('/');

   // Set notify_persons object based on auth.user_data
    this.notify_persons = [{
      id: this.auth.user_data.id,
      name: this.auth.user_data.first_name + ' ' + this.auth.user_data.last_name,
      email: this.auth.user_data.email,
      profile_pic: this.auth.user_data.profile_pic,
    }];

    // Initialize scheduleId
    this.scheduleId = getIdFromUrl(this.currentPath());

    // Initialize variables
    let pathType;
    let isEdit = false;

    // Check if "edit" is present in the URL parts
    if (parts.includes("edit")) {

      this.edit = true;

      // Determine the pathType and reportId from URL parts
      pathType = parts[parts.length - 4];

      this.reportId = parts[parts.length - 3];

      // Set the URL for the API based on reportId
      this.url = 'api/schedule-report/'+this.reportId;

      this.btnName = 'update';

      this.title = 'edit_schedule';

      this.iconClass =  'fas fa-sync';

      this.hasDataPopulated = false;

      this.getInitialValues();

    }else{
      // Set the URL based on scheduleId
      this.url = 'api/schedule-report/'+this.scheduleId;

      this.hasDataPopulated = true;

      this.loading = false;

      pathType = parts[parts.length - 2];

    }

    this.reportType = pathType;

    // Split the reportType and format it
    var words = this.reportType.split('-');
    this.subject = words.map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');

    // Set the description
    this.description = `Here is your ${this.schedule.replace(/^\w/, (c) => c.toUpperCase())} ${this.subject}`;

    // Set the scheduledData property
    this.scheduledData = this.$route.query.params;

    this.hideExt = !!this.$route.query.type;
  },


  methods:{

    onChange(value, name) {
      // Update the data property with the new value
      this[name] = value;

      // Update the description based on schedule
      if (name === 'schedule' && (value === 'weekly' || value === 'monthly')) {
        this.day = [];
      }
    },

		onChangeDeliveryTime(value) {

      // Convert the input value (time) to a moment object
			const newDeliveryTime = moment(value, 'HH:mm');
			this.delivery_time = newDeliveryTime;
		},

    isValid() {

      // Validate the schedule data using the validateSchedule function and get errors and isValid flag
      const { errors, isValid } = validateSchedule(this.$data);

      return isValid;
    },

		getInitialValues(){

			this.loading = true;

			axios.get('get/individual_schedule_report/'+this.scheduleId).then(res =>{

				this.loading = false;

        this.hasDataPopulated = true

				let data = res.data.data;

        // assigning values to forms while editing to data
        this.subject = data.subject;
        this.description = data.description;
        this.schedule = data.type;
        this.execution_time = data.execution_time;
        this.hideExt = data.extension === 'pdf';
        this.ext = data.extension;
        this.day = data.periods;
        this.status = data.status;
        this.notify_persons = data.notify_persons;
        // For date and time fields, you may need to format the data
        this.delivery_time = moment(data.execution_time, 'YYYY-MM-DDTHH:mm:ss.SSSSSS[Z]');


			}).catch(err=>{
        errorHandler(err,'CreateEditSchedule')
				this.loading = false;
			})

		},

    onSubmit() {
      // Check if data is valid
      if (this.isValid()) {
        this.loading = true;

        // Format delivery_time
        const deliveryTime = new Date(this.delivery_time);
        const options = { hour: '2-digit', minute: '2-digit', hour12: false };
        const formattedTime = deliveryTime.toLocaleTimeString('en-US', options);

        // Create a FormData object to send the data
        const formData = new FormData();

        // Define common fields
        const commonFields = {
          type: this.schedule,
          execution_time: formattedTime,
          subject: this.subject,
          description: this.description,
          extension: this.hideExt ? 'pdf' :this.ext,
          status: this.status ? 1 : 0,
        };

        // Append common fields to the FormData object
        for (const key in commonFields) {
          formData.append(key, commonFields[key]);
        }

        // Append payload if available
        if (this.scheduledData) {
          formData.append('payload', this.scheduledData);
        }

        // Append daily schedule if applicable
        if (this.schedule === 'daily') {
          formData.append('periods[0]', this.schedule);
        }

        // Check if there are notify persons and append them conditionally
        let notifyPerson = false;
        if (this.notify_persons && Object.keys(this.notify_persons).length > 0) {
          for (const i in this.notify_persons) {
            if (this.notify_persons[i].id && typeof this.notify_persons[i].id === 'number') {
              notifyPerson = true;
              formData.append(`notify_persons[${i}]`, this.notify_persons[i].id);
            }
          }
        }

        // Append a default notify person if none were added
        if (!notifyPerson) {
          formData.append('notify_persons[0]', this.notify_persons.id);
        }

        // Append weekly or monthly schedule
        if (this.schedule !== 'daily' && this.day !== '') {
          for (const i in this.day) {
            if (this.day[i].id && (typeof this.day[i].id === 'string' || typeof this.day[i].id === 'number')) {
              formData.append(`periods[${i}]`, this.day[i].id);
            }
          }
        }

        // Append scheduleId if in edit mode
        if (this.edit) {
          formData.append('id', this.scheduleId);
        }

        // Make a POST request with axios
        axios.post(this.url, formData)
            .then((res) => {
              // Handle success
              successHandler(res, 'CreateEditSchedule');
              this.loading = false;
              setTimeout(() => {
                this.$router.push({ name: 'AllScheduleList' });
              }, 3000);
            })
            .catch((err) => {
              // Handle errors
              errorHandler(err, 'CreateEditSchedule');
              this.loading = false;
            });
      }
    }

  },
}
</script>

<style scoped>

.labels{
	margin-left: 5px;
}

</style>