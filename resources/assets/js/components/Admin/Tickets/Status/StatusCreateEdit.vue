<template>

	<div class="container col-sm-12">

		<alert componentName="status-create-edit"></alert>

		<div v-if="!hasDataPopulated || loading">

			<custom-loader :loadingSpeed="4000"></custom-loader>
		</div>

		<div class="card card-light" v-if="hasDataPopulated">

			<div class="card-header">

				<h3 class="card-title">{{trans(page_title)}}</h3>
			</div>

			<div class="card-body">

				<div class="row mb-3" v-focus-first-input>

					<text-field :label="trans('name')" type="text" :value="name" name="name" class="col-sm-3" :required="true" :onChange="onChange" :placehold="lang('enter_a_value')">

					</text-field>

					<number-field :label="trans('display_order')" :value="order" name="order" classname="col-sm-3" :onChange="onChange" placeholder="n"
								  type="number" :required="true">

					</number-field>

					<dynamic-select name="icon_class" :label="trans('icon_class')" :value="icon_class" :onChange="onChange"
									classname="col-sm-3" :elements="iconList" :multiple="false" option-label="icon_class" :required="true" :clearable="false">

					</dynamic-select>

					<div class="col-sm-3 form-group" :class="{'has-error' : showErr}">

						<label v-tooltip="trans('icon_color')" class="pb-1"> {{ trans('icon_color') }} <span class="text-danger"> *</span></label>

						<color-picker :color="icon_color" name="icon_color" :onColor="onChange" :showError="showErr" />

						<div v-if="showErr" class="error-block is-danger">{{trans('this_field_is_required')}}</div>
					</div>
				</div>

				<div class="row mb-3">

					<radio-button :options="yesNoOptions" :label="trans('allow_client')" name="allow_client" :value="allow_client"
								  :onChange="onChange" classname="form-group col-sm-2" optionClass="col-sm-6" :hint="trans('if_yes_then_clients_can_choose_this_status')">

					</radio-button>

					<radio-button :options="yesNoOptions" :label="trans('halt_sla')" name="halt_sla" :value="halt_sla"
								  :onChange="onChange" classname="form-group col-sm-2" optionClass="col-sm-6">

					</radio-button>

					<radio-button :options="commentOptions" :label="trans('comment')" name="comment" :value="comment" :onChange="onChange"
								  classname="form-group col-sm-3" optionClass="col-sm-6" :hint="trans('if_required_comment_is_mandatory_while_changing_the_ticket_status')">

					</radio-button>

					<radio-button :options="yesNoOptions" :label="trans('visibility_to_client')" name="visibility_for_client" :value="visibility_for_client"
								  :onChange="onChange" classname="form-group col-sm-2" optionClass="col-sm-6" :hint="trans('if_yes_status_name_will_be_displayed')">

					</radio-button>

					<radio-button :options="overrideOptions" :label="trans('allowed_override_status_to')" name="override_status"
								  :value="override_status" :onChange="onChange" classname="form-group col-sm-3" optionClass="col-sm-6">

					</radio-button>
				</div>

				<div class="row mb-3">

					<dynamic-select :label="trans('purpose_of_status')" :multiple="false" name="purpose_of_status" :required="true"
									classname="col-sm-3" apiEndpoint="/api/dependency/ticket-status-type?purpose_of_status=1" :value="purpose_of_status"
									:onChange="onChange" :clearable="purpose_of_status ? true : false"
									:hint="trans('purpose_of_status_will_perform_the_action_to_be_applied_on_the_status_selection')"
					>
					</dynamic-select>

					<dynamic-select v-if="!visibility_for_client" :label="trans('status_to_display')" :multiple="false" name="secondary_status"   
						classname="col-sm-3" :apiEndpoint="visibiltyEndpoint" :value="secondary_status"
						:onChange="onChange" :clearable="secondary_status ? true : false" :required="true" 
						:hint="trans('this_status_will_be_displayed_to_client_if_visibility_of_client_chosen_no')">

					</dynamic-select>

					<dynamic-select v-if="!override_status" :label="trans('select_status')" :multiple="true" name="override_statuses" :required="true"
									classname="col-sm-4" apiEndpoint="/api/dependency/statuses" :value="override_statuses" :onChange="onChange">

					</dynamic-select>
				</div>
				<div class="row mb-3" v-if="alerts">
					<div for="notify" class="col-sm-12">
						<div class="card card-light">
							<div class="card-header">
								<h3 class="card-title">{{lang('notify')}}
								</h3>
							</div>
							<div class="card-body">
								<table class="table table-borderless table-sm">
						<tr v-for="person in alerts.associates" style="width=:100%">
							<td style="text-align:left;">
								{{trans(person.name)}}
							</td>
							<td v-for="channel in alerts.allowedChannels" style="width: 5%;text-align:left;">
								<i :class="[channel.icon, setAlerts[person.associate_id].includes(channel.id) ? 'active-channel' : 'inactive-channel']" aria-hidden="true" @click="toggleChannel(setAlerts[person.associate_id].includes(channel.id), person.associate_id, channel.id)" style="pointer-events: initial; cursor: pointer; color:"></i>
							</td>
						</tr>
					</table>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="card-footer">

				<button class="btn btn-primary" @click="onSubmit"><i :class="iconClass"> </i> {{trans(btnName)}}</button>
			</div>
		</div>
	</div>
</template>

<script>
	
	import axios from "axios";
	
	import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
	
	import { validateStatusSettings } from "../../../../helpers/validator/statusRules";
	
	import {getIdFromUrl} from '../../../../helpers/extraLogics';

	import TextField from "../../../MiniComponent/FormField/TextField.vue";

	import NumberField from "../../../MiniComponent/FormField/NumberField.vue";

	import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";

	import ColorPicker from "../../../MiniComponent/FormField/ColorPicker.vue";

	import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";

	export default {

		name : 'status-create-edit',

		data () {

			return {

				page_title : 'create_new_status',

				iconClass:'fas fa-save',

				btnName:'save',

				status_id : '',

				hasDataPopulated : false,

				name : '',

				order : '',

				icon_class : {
              "icon_class": "fas fa-edit"
            },

            iconList : [],

            icon_color : '',

            visibility_for_client : 1,

            allow_client : 1,

            yesNoOptions : [{name:'yes',value:1},{name:'no',value:0}],

            purpose_of_status : '',

            halt_sla : 1,

            commentOptions : [{name:'required',value:1},{name:'optional',value:0}],

            comment : 1,

            overrideOptions : [{name:'all_statuses',value:1},{name:'specific_statuses',value:0}],

            override_status : 1,

            is_default : false,

            showErr : false,

            secondary_status : '',

            override_statuses : [],

            loading : false,

            alerts: null,

	        	setAlerts: {}
			}
		},

		beforeMount() {

			const path = window.location.pathname;

			this.getValues(path);

			this.getIconList();

			this.getStatusAlerts(path);
		},

    computed : {

      visibiltyEndpoint() {

        let endPoint = "/api/dependency/statuses?client_visibility=1";

        return this.purpose_of_status ? endPoint+'&purpose_of_status_id='+this.purpose_of_status.id : endPoint;
      }
    },

		methods : {

			getIconList() {
          	
          	axios.get('/json/icon-list.json').then((response) => {
            	
            	this.iconList = response.data.data;

          	}).catch((error) => {
            	
            	this.iconList = [];
          	})
        	},

        	getValues(path){

				const statusId = getIdFromUrl(path);
			
				if (path.indexOf("edit") >= 0) {
			
					this.page_title = 'edit_status';
			
					this.iconClass = 'fas fa-sync-alt'
			
					this.btnName = 'update'
			
					this.hasDataPopulated = false;
			
					this.getInitialValues(statusId);

				} else {

					this.loading = false;

					this.hasDataPopulated = true
				}
			},

			getInitialValues(statusId) {
		
				this.loading = true;			
		
				axios.get('/api/status/'+statusId).then(res => {
					
					this.loading = false;

					this.hasDataPopulated = true;

					this.status_id  = statusId;

					let statusData = res.data.data.status;

					this.updateStatesWithData(statusData);

					this.override_status = statusData.override_statuses.length ? 0 : 1;

					this.icon_class = { "icon_class": statusData.icon };

					this.is_default = statusData.default ? true : false;
		
				}).catch(err => {			
					
					this.loading = false;

					errorHandler(err)
				});
			},
			getStatusAlerts(path)
			{
				this.loading = true;
			    let statusId = getIdFromUrl(path);
			    statusId = statusId === undefined ? '' : statusId; 
			    axios.get('/api/status-alerts/'+statusId).then(res => {
			    	this.loading = false;
			    	this.alerts = res.data.data.ticket_status_changed;
			    	this.updateSetAlerts();
		    	}).catch(err => {
					this.loading = false;
					errorHandler(err)
				});
			},

			updateSetAlerts()
        	{
        		let tmp = {}
        		this.alerts.associates.forEach(function(associate){
        			let value = [];
        			let key = associate.associate_id;
        			if(associate.channels.length > 0) {
        				value = associate.channels;
        			}
       				tmp[key] = value;
        		})
        		this.setAlerts = tmp;
        	},

        	toggleChannel(isSet, key, value)
        	{
        		let index = this.setAlerts[key].indexOf(value);
        		if (index > -1) {
    				this.setAlerts[key].splice(index, 1);
  				}
        		if(!isSet) {
        			this.setAlerts[key].push(value);        			
        		}
        	},

			updateStatesWithData(statusData) {
		
				const self = this;
		
				const stateData = this.$data;

				Object.keys(statusData).map(key => {
		
					if (stateData.hasOwnProperty(key)) {
		
						self[key] = statusData[key];
					}
				});

				this.secondary_status = statusData.secondary_status ? statusData.secondary_status : '';
			},

			formatAlertFormData()
   			{
   				let m = [];
   				for (const [key, value] of Object.entries(this.setAlerts)) {
  					let tmp = {}
  					tmp.associate = key;
  					tmp.channels =[];
  					value.forEach(function(item, index){
  						tmp['channels'][index] = {'channel_id':item};
  					})
  					m.push(tmp);
				}
				return m;
   			},
   			
			onChange(value,name) {

				this[name] = value;

				if(value === null){
			
					this[name] = '';
				}
			},

			isValid() {
		
				const { errors, isValid } = validateStatusSettings(this.$data);
		
				return isValid;
			},

			onSubmit() {
				
				this.icon_color = this.icon_color == '#' ? '' : this.icon_color;

				this.showErr = !this.icon_color ? true : false;				

				if(this.isValid() && this.icon_color){

					this.loading = true;

					let data = {};

					data['name'] = this.name;

					data['order'] = this.order;
					
					data['icon_color'] = this.icon_color;
					
					data['icon_class'] = this.icon_class.icon_class;
					
					data['visibility_for_client'] = this.visibility_for_client;
					
					if(!this.visibility_for_client) {

						data['secondary_status'] = this.secondary_status.id;
					}

					data['allow_client'] = this.allow_client;

					data['purpose_of_status'] = this.purpose_of_status.id;

					data['halt_sla'] = this.halt_sla;

					data['comment'] = this.comment;

					data['default'] = this.is_default ? 1 : 0;

					data['override_statuses'] = !this.override_status ? this.override_statuses.map(obj=>obj.id) : [];

					data['alerts'] = this.formatAlertFormData();

					if(this.status_id){
			
						data['status'] = this.status_id;

						data['_method'] = 'PATCH';
					}

					let apiUrl = this.status_id ? '/api/status-update/'+this.status_id : '/api/status';

					axios.post(apiUrl,data).then(res=>{

						this.loading = false;

						successHandler(res, 'status-create-edit');

						if(!this.status_id){

							setTimeout(()=>{

								this.$router.push({ name : 'Status Index'})
							},3000);

						} else {

							this.getInitialValues(this.status_id)
						}
					}).catch(err=>{

						this.loading = false;
						
						errorHandler(err, 'status-create-edit');
					})
				}
			}
		},

		components : {

			'text-field' : TextField,

			"number-field": NumberField,

			'dynamic-select': DynamicSelect,

			'color-picker': ColorPicker,

			'radio-button': RadioButton,
		}
	};
</script>
<style scoped>
	.active-channel {
	color: #797A7A;
	/*color: #4A4A4B;*/
	/*color: #4CA746*/
}

.inactive-channel {
	color: #C5C5C5
}
</style>