<template>

	<div class="col-sm-12">

		<alert componentName="TicketSettings"></alert>

		<faveo-box :title="trans('ticket-setting')">

			<div class="row" v-if="!hasDataPopulated || loading">

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>

			<template v-if="hasDataPopulated">

				<faveo-box :title="trans('general_settings')">

					<div class="row">

						<dynamic-select :label="trans('default_status')" :multiple="false" name="status" classname="col-sm-4"
							apiEndpoint="/api/dependency/statuses?supplements[purpose_of_status][]=1" :value="status" :onChange="onChange"
							:strlength="30" :required="false" :clearable="false">

						</dynamic-select>

						<number-field :label="trans('agent_collision_avoidance_duration_minutes')" :value="collision_avoid"  name="collision_avoid" :keyupListener="triggerEvent"
								:onChange="onChange" type="number" :required="false" placeholder="n" classname="col-sm-4"
							>

						</number-field>

						<static-select :label="trans('lock_ticket_frequency')" :elements="lockOptions" name="lock_ticket_frequency"
							:onChange="onChange" :value="lock_ticket_frequency" :hideEmptySelect="true" classname="col-sm-4" >

						</static-select>
	            </div>

	            <div class="row">

          			<text-field :label="trans('ticket_number_prefix')" :value="ticket_number_prefix" type="text" name="ticket_number_prefix"  :keyupListener="triggerEvent"
          				:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-4" :required="true" :hint="trans('ticket_number_prefix_description')">

						</text-field>

						<static-select :label="trans('show_ticket_per_page')" :elements="pageOptions" name="record_per_page"
							:onChange="onChange" :value="record_per_page" :hideEmptySelect="true" classname="col-sm-4"
							:hint="trans('ticket-perpage-tooltip')">

						</static-select>

						<number-field :label="trans('waiting_time_hours')" :value="waiting_time"  name="waiting_time" :onChange="onChange"
							type="number" :keyupListener="triggerEvent" :required="false" placeholder="n" classname="col-sm-4" :hint="trans('waiting_time_for_client_reply')"
							>

						</number-field>
        			</div>
					<div class="row">
						<radio-button name="append_reply_by_fetching_email" classname="form-group col-sm-4" :options="inboxOptions"
									  :label="trans('append_reply_by_fetching_email')" :value="append_reply_by_fetching_email" :onChange="onChange" :hint="trans('append_reply_by_fetching_email_hint')">

						</radio-button>
						<radio-button name="auto_assign_ticket_to_agent_on_first_reply" classname="form-group col-sm-4" :options="inboxOptions"
									  :label="trans('auto_assign_ticket_to_agent_on_first_reply')" :value="auto_assign_ticket_to_agent_on_first_reply" :onChange="onChange" :hint="trans('auto_assign_ticket_to_agent_on_first_reply_hint')">

						</radio-button>

						<radio-button name="show_org_ticket_form" classname="form-group col-sm-4" :options="inboxOptions"
									  :label="trans('show_org_ticket_form')" :value="show_org_ticket_form" :onChange="onChange">

						</radio-button>
					</div>

				</faveo-box>

        <faveo-box v-if="pluginStatus" :title="trans('automatic_redaction')">

          <div class="alter-row">

          <label class="redact mb-3" for="status">{{trans('automatic_redaction')}}</label><span class="px-1" v-tooltip="trans('automatic_redaction_info')"> <i class="fas fa-question-circle ms-1" style="font-size: small; color: rgb(51, 122, 183); cursor: help;"></i></span><br>

            <status-switch name="automatic_redaction"  :onChange="onSwitchChange" :value="automatic_redaction"  classname="form-group col-sm-4 ms-1"  :bold="true"
                           :label="trans('status')"  :hint="trans('text')">

            </status-switch>

          </div>

          <div class="row mb-3" v-if="showCheckbox || automatic_redaction===1">

            <Checkbox  name="credit_card_number" :value="credit_card_number"  :label="trans('credit_card_numbers')"
                       :onChange="onChange" :hint="trans('credit_card_numbers_info')">
            </Checkbox>

          </div>

        </faveo-box>

				<faveo-box :title="trans('inbox_settings')">

					<div class="row">

						<radio-button name="count_internal" classname="form-group col-sm-4 mmb-3" :options="inboxOptions"
            			:label="trans('include_internal_note_in_thread_count')" :value="count_internal" :onChange="onChange">

            		</radio-button>

            		<radio-button name="show_status_date" classname="form-group col-sm-4 mb-3" :options="inboxOptions"
            			:label="trans('show_status_update_date')" :value="show_status_date" :onChange="onChange">

            		</radio-button>

            		<radio-button name="show_org_details" classname="form-group col-sm-4 mb-3" :options="inboxOptions"
            			:label="trans('show_org_details')" :value="show_org_details" :onChange="onChange">

            		</radio-button>
					</div>

					<div class="row">

						<radio-button name="show_user_location" classname="form-group col-sm-4 mb-3" :options="inboxOptions"
            			:label="trans('ticket_settings_inbox_settings_display_location')" :value="show_user_location"
            			:onChange="onChange">

            			</radio-button>
					</div>

					<div class="row">
					
						<div class="col-sm-4">
							
							<label>{{trans('add_custom_fields')}}</label>
							
							<div class="search-container mb-2">
								
								<input type="text" placeholder="Search..." class="form-control" v-model="searchTerm" @input="onSearch">
								
								<i class="fas fa-search text-muted"></i>
							</div>
							
							<div v-if="customOptions.length" id="fields-container" @scroll="handleCardScroll">
								
								<check-box :options="customOptions" name="custom_field_name" :value="custom_field_name"
								           :label="trans('add_custom_fields')" :label-style="{ display: 'none' }" :onChange="onChange" :keyupListener="triggerEvent" classname="col-sm-12 ps-0" class_name="col-sm-12"
								           spanClass="check_grid">
								
								</check-box>
								
								<div class="row" v-if="fieldsLoader">
									
									<reuse-loader :animation-duration="4000" :size="30"/>
								</div>
							</div>
						</div>
					</div>
				</faveo-box>

				<div class="card-footer" slot="actions">

					<button class="btn btn-primary" type="button" @click="onSubmit">

						<i class="fas fa-save"> </i> {{trans('save')}}
					</button>
				</div>
			</template>
		</faveo-box>

		<div class="row" v-if="pageLoad">

			<custom-loader :duration="4000"></custom-loader>
		</div>
	</div>
</template>

<script>

	  import { errorHandler, successHandler } from "../../../../helpers/responseHandler";
    import { validateTicketSettings } from "../../../../helpers/validator/ticketSettingRules.js"
	  import axios from 'axios';
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
    import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
    import NumberField from "../../../MiniComponent/FormField/NumberField.vue";
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import CheckBoxComponent from "../../../MiniComponent/FormField/CheckBoxComponent.vue";
    import StatusSwitch from "../../../MiniComponent/FormField/Switch.vue";
    import ToggleButton from "../../../Common/ToggleButton.vue";
    import Checkbox from "../../../MiniComponent/FormField/Checkbox.vue";
    import FaveoBox from "../../../MiniComponent/FaveoBox.vue";
		import _ from 'lodash-core';

	export default {

		name : 'ticket-settings',

		data() {

			return {
        showCheckbox: false,

				loading : true,

				hasDataPopulated : false,

				pageLoad : false,

				settingsData : '',

				customData : [],

				status : '',

				collision_avoid : '',

				lock_ticket_frequency : '',

				lockOptions: [{id: 0, name: 'No'}, {id: 1, name: 'Only once'}, { id : 2, name : 'Frequently'}],

				ticket_number_prefix : '',

				record_per_page : '',

				pageOptions : [{id: 10, name: '10 tickets per page'}, {id: 25, name: '25 tickets per page'},{id: 50, name: '50 tickets per page'},
					{id: 100, name: '100 tickets per page'}],

				waiting_time : '',

				count_internal : '',

				show_status_date : '',

				show_org_details : '',

				show_user_location : '',

				inboxOptions: [{name:'Yes', value: 1}, {name:'No', value: 0 }],

				custom_field_name : [],

        automatic_redaction:'',

        credit_card_number:'',

				customOptions : [],

                append_reply_by_fetching_email : '',

                auto_assign_ticket_to_agent_on_first_reply : '',

				show_org_ticket_form: '',
				
				fieldsLoader: false,
				page: 1,
				hasMoreData: true,
				searchTerm: '',
        pluginStatus:false,
			}
		},

		beforeMount() {

			this.getValues();

			this.getCustomFields();

      this.getPLuginStatus()

		},
		
		methods : {

      async getPLuginStatus(){
        try {
          const res = await axios.get('api/agent/checkplugin');
          this.pluginStatus = res.data.data.plugin_status;
        } catch (error) {
          errorHandler(error, 'TicketSettings');
        }
      },

			onSwitchChange(value) {
				this.automatic_redaction = value;
				this.showCheckbox = this.automatic_redaction ? true : false;
				if (!this.showCheckbox) {
					this.credit_card_number = false;
				}
			},

			onSearch() {
				this.page = 1;
				this.search();
			},

			search: _.debounce(function () {
				this.getCustomFields('search')
			}, 350),
			
			handleCardScroll () {
				const fieldsContainer = document.getElementById('fields-container');
				const scrollHeight = fieldsContainer.scrollHeight;
				const scrollTop = fieldsContainer.scrollTop;
				const clientHeight = fieldsContainer.clientHeight;
				if (scrollTop + clientHeight >= scrollHeight - 100 && !this.fieldsLoader && this.hasMoreData) {
					this.getCustomFields();
				}
        this.handleScroll();
			},
			
			async getCustomFields (type = "") {
				
				try {
				
					if(type === 'search') {
						
						this.customOptions = [];
					}
					this.fieldsLoader = true;
				
					const response = await axios.get(`/custom-field-flattened?category=ticket&page=${this.page}&search-query=${this.searchTerm}&module=settings`);
					
					if (response.data.data.data.length > 0) {
						
						response.data.data.data.forEach((item)=>{
							
							item['value'] = '';
						});
						
						this.customOptions = [...this.customOptions, ...response.data.data.data];
				
						this.page++;
						
						this.hasMoreData = true;
				
					} else {
						// No more data, set the flag to false
						this.hasMoreData = false;
					}
					
				} catch (error) {
				
					console.error('Error fetching data:', error);
				
				} finally {
					
					this.fieldsLoader = false;
				}
			},
			
			//Making List of Custom fields present in ticket form
			setSelectedField(data){

			 	data.forEach((item)=>{

			 		item['value'] = '';

			 		this.customOptions.push(item);
			 	});
			},

			getValues() {

				axios.get('/api/getTicketSetting').then(res=>{

					this.settingsData = res.data.data.ticket;

					this.updateStatesWithData(this.settingsData)

					this.hasDataPopulated = true;

					this.loading = false;

				}).catch(err=>{

					this.hasDataPopulated = true;

					this.loading = false;
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
			},

			onChange(value, name) {

				this[name] = value;

				if(value === null){

					this[name] = '';
				}
			},

			isValid () {

				const { errors, isValid } = validateTicketSettings(this.$data);

				return isValid;
			},

			onSubmit() {

				if(this.isValid()) {

					this.pageLoad = true;

					let data = {};

					data['ticket_number_prefix'] = this.ticket_number_prefix;

					data['status'] = this.status.id;

					data['collision_avoid'] = this.collision_avoid;

					data['record_per_page'] = this.record_per_page;

					data['lock_ticket_frequency'] = this.lock_ticket_frequency;

					data['waiting_time'] = this.waiting_time;

					data['count_internal'] = this.count_internal;

					data['show_status_date'] = this.show_status_date;

					data['show_user_location'] = this.show_user_location;

					data['show_org_details'] = this.show_org_details;

					data['append_reply_by_fetching_email'] = this.append_reply_by_fetching_email;

					data['auto_assign_ticket_to_agent_on_first_reply'] = this.auto_assign_ticket_to_agent_on_first_reply;

					data['automatic_redaction'] = this.automatic_redaction;

					data['credit_card_number'] = this.credit_card_number;

					data['show_org_ticket_form'] = this.show_org_ticket_form;

					data['_method'] = 'PATCH';

					if(this.custom_field_name.length) {

						//Extracting only id's from customOptions
						let checkOptions = this.customOptions.map(obj => obj.id);

						let finalValues = [];

						this.custom_field_name.map(obj => {

							//Checking whether selectedValue is present in customOptions or not
							if(checkOptions.includes(parseInt(obj))) {

								//If present .. pushing it into new array
								finalValues.push(parseInt(obj))
							}
						});
						//Sending new array values to backend
						if(finalValues.length) {

							data['custom_field_value'] = finalValues;
						}
					}

					axios.post('/api/postticket',data).then(res=> {

						this.pageLoad = false;

						successHandler(res,'TicketSettings');

						this.getValues();

					}).catch(err=>{

						this.pageLoad = false;

						errorHandler(err,'TicketSettings')
					})
				}
			},
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },
		},

		components : {
      FaveoBox,
      Checkbox,
      ToggleButton,
      StatusSwitch,

			"text-field": TextField,

			'dynamic-select': DynamicSelect,

			'static-select': StaticSelect,
			
			'number-field': NumberField,

			'radio-button': RadioButton,

			'check-box': CheckBoxComponent,
		}
	};
</script>

<style scoped>

	.redac{
		margin-left: 2px;
	}

	.redact{
		margin-left: 8px;
	}

	#fields-container {
		max-height: 200px;
		overflow-y: auto;
		overflow-x: hidden;
	}
	
	#fields-container::-webkit-scrollbar-track
	{
		background-color: #f1f1f1;
		border-radius:10px;
	}
	#fields-container::-webkit-scrollbar
	{
		width: 6px;
		background-color: #f1f1f1;
	}
	#fields-container::-webkit-scrollbar-thumb
	{
		background-color: #c1c1c1;
		border-radius: 10px;
	}
	
	.search-container {
		position: relative;
	}
	
	.search-container input {
		padding-right: 30px; /* Space for the search icon */
	}
	
	.search-container i {
		position: absolute;
		top: 50%;
		right: 10px;
		transform: translateY(-50%);
		cursor: pointer;
	}

  .alter-row{
    display: flex;
    -ms-flex-wrap: wrap;
    flex-wrap: wrap;
    margin-right: -7.5px;
    margin-left: -7.5px;
  }
</style>
