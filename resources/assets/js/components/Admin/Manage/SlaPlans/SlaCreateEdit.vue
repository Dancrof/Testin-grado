<template>
  <div class="col-sm-12">
    <alert componentName="sla"></alert>
    <div class="">
    <div class="row" v-if="showLoader">
      <reuse-loader :animation-duration="4000" :size="60" />
    </div>
    <template v-if="!showLoader">

        <div class="card card-light">

          <div class="card-header">
            <h3 for="select targets" id="title" class="card-title">{{lang(title)}}</h3>
            <div class="card-tools switch-pos">
              <status-switch name="status" :value="status" :onChange="onChange" :bold="true" classname="btn-tool"> </status-switch>
            </div>
          </div>
          <ValidationObserver ref="faveoAutomatorForm" v-slot="{ values, errors, validate }">
              <div class="card-body">
                <div class="row" v-focus-first-input>
                  <text-field :label="lang('name')" :value="name" type="text" name="name" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6" :required="true" rules="required"> </text-field>
                </div>
                <div>
                  <div class="card card-light">
                    <div class="card-header">
                      <h3 for="select targets" class="card-title">{{lang('sla_targets')}}</h3>
                    </div>
                    <div class="card-body">
                      <template v-if="targetArr.length > 0">
                        <table class="table" id="target_table">
                          <tbody>
                            <tr>
                              <th style="width: 10%;">{{lang('priority')}}</th>
                              <th>{{lang('respond_Within')}}&nbsp;<label style="color: rgb(220, 53, 69);">*</label></th>
                              <th>{{lang('resolve_within')}}&nbsp;<label style="color: rgb(220, 53, 69);">*</label></th>
                              <th style="width: 25%;">{{lang('operational_hours')}}</th>
                              <th>{{lang('notify')}}</th>
                            </tr>
                            <tr v-for="(target,index) in targetArr">
                              <td>{{target.name}}</td>
                              <td>
                                <div class="d-flex">
                                  <number-field
                                    :label="lang('respond_Within')"
                                    :value="target.respond_count"
                                    :name="'respond_count-'+index"
                                    :onChange="onChange"
                                    classname="w_70"
                                    type="number"
                                    :labelStyle="labelStyle"
                                    :required="true"
                                    rules="required|min_value:1"
                                    from="sla"
                                    placeholder="n"
                                  >
                                  </number-field>
                                  &nbsp;&nbsp;
                                  <static-select
                                    :label="lang('option')"
                                    :elements="selectOptions"
                                    :name="'respond_option-'+index"
                                    :onChange="onChange"
                                    :value="target.respond_option"
                                    :labelStyle="labelStyle"
                                    :hideEmptySelect="true"
                                    classname="w_95"
                                  >
                                  </static-select>
                                </div>
                              </td>
                              <td>
                                <div class="d-flex">
                                  <number-field
                                    :label="lang('resolve_within')"
                                    :value="target.resolve_count"
                                    :name="'resolve_count-'+index"
                                    :onChange="onChange"
                                    classname="w_70"
                                    :labelStyle="labelStyle"
                                    type="number"
                                    :required="true"
                                    placeholder="n"
                                    rules="required|min_value:1"
                                    from="sla"
                                  >
                                  </number-field>
                                  &nbsp;&nbsp;
                                  <static-select
                                    :label="lang('option')"
                                    :elements="selectOptions"
                                    :name="'resolve_option-'+index"
                                    :onChange="onChange"
                                    :value="target.resolve_option"
                                    :labelStyle="labelStyle"
                                    :hideEmptySelect="true"
                                    classname="w_95"
                                  >
                                  </static-select>
                                </div>
                              </td>
                              <td>
                                <dynamic-select
                                  :label="lang('operational_hours')"
                                  :multiple="false"
                                  :name="'business_hour-'+index"
                                  :labelStyle="labelStyle"
                                  apiEndpoint="/api/dependency/business-hours"
                                  :value="target.business_hour"
                                  :onChange="onChange"
                                  :strlength="17"
                                  :required="false"
                                  :clearable="target.business_hour ? true : false"
                                >
                                </dynamic-select>
                              </td>
                              <td v-for="channel in channels">
                                <i :class="[channel.icon, target.channels.includes(channel.id) ? 'active-channel' : 'inactive-channel']" aria-hidden="true" @click="toggleChannel(target.channels.includes(channel.id), index, channel.id)" style="pointer-events: initial; cursor: pointer; color:"></i>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </template>
                    </div>
                  </div>
                </div>
                <div>

                  <!-- Insha'allah, boys played well -->
                  <div id="sla-rules-container">
                    <rule-list v-if="!default_sla" :categories="formCategories"/>
                  </div>
                    <div>
                      <alert componentName="reminder" />
                    </div>
                      <sla-reminders :getUpdateArray="approchesArray" :approach="approach"></sla-reminders>
                      <sla-escalations :getUpdateArray="violatedArray" :violated="violated"></sla-escalations>

                </div>
                <div class="row">
                  <text-field :label="lang('admin_notes')" :value="internal_notes" type="textarea" name="internal_notes" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-12" :rows="10"> </text-field>
                </div>
              </div>
              <div v-if="!showLoader" class="card-footer">
                <button class="btn btn-primary" type="button" @click="validateForm()"><i :class="iconClass"></i> {{lang(btnName)}}</button>
              </div>
          </ValidationObserver>
        </div>
    </template>
    </div>

	  <transition name="modal">
		  <modal v-if="showDeleteModal" :showModal="true" :onClose="() => showDeleteModal = false" :containerStyle="{width:'400px'}">

			  <template #title>

				  <h4 class="modal-title">{{lang('delete')}}</h4>
			  </template>

			  <template #fields>

				  <reuse-loader v-if="loading"></reuse-loader>

				  <span v-if="!loading">{{lang('are_you_sure_you_want_to_delete')}}</span>
			  </template>

			  <template #controls>
				  <button id="approval-action-confirm" type="button" @click = "doDelete()" class="btn btn-secondary">
					  <i class="fas fa-trash-alt" aria-hidden="true"></i>&nbsp;{{lang('confirm')}}
				  </button>
			  </template>
		  </modal>
	  </transition>
  </div>
</template>


<script>

	import { boolean, getIdFromUrl } from "../../../../helpers/extraLogics.js";

	import {errorHandler,successHandler} from "../../../../helpers/responseHandler";

	import { validateSlaSettings } from "../../../../helpers/validator/slaRules.js"

	import { FaveoAutomator, getEnforcerDataByPropertyForSubmit, getEnforcerInstanceList, isLocalElement } from '../../../../helpers/AutomatorUtils';

	import { scrollToErrorBlock } from '../../../../helpers/formUtils';

	import axios from 'axios';

	import {useStore} from "vuex";
    import {computed} from "vue";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import Switch from "../../../MiniComponent/FormField/Switch.vue";
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
    import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
    import NumberField from "../../../MiniComponent/FormField/NumberField.vue";
    import RuleList from "../../Automator/RuleList.vue";
    import SlaEscalations from "./SlaEscalations.vue";
    import SlaReminders from "./SlaReminders.vue";

	export default {

		name : 'sla-create-edit',

		description  : 'SLA Create and Edit page',

        setup() {

            const store = useStore();

            return {

                showLoader : computed(()=> store.getters.showLoader )
            }
        },

		data(){

			return {

				title : 'create_new_sla_plan',

				iconClass : 'fas fa-save',

				btnName : 'save',

				sla_id :'',

				name : '',

				status : true,

				internal_notes : '',

				selectOptions: [{id: 'minute', name: 'Min(s)'}, {id: 'hour', name: 'Hour(s)'},{id: 'day', name: 'Day(s)'}],
				
				labelStyle : { display : 'none' },

				submitData: {},

				count: 0,

				ruleList: [
					{
						id: null,
						
						field: "",
						
						relation: "equal",
						
						category: "ticket",
						
						value: "",
						
						rules: []
					}
				],

				obj: {

					id: null,

					matcher: "any",

				},

				/**
				 * variable to store the customields
				 */
				ticketCustomFields: [],

				/**
				 *state for storing the edit data
				 */
				editData: {},

				editRuleValues: [],

				/**
				 *editform is used to check if the edit api has been called or not
				 */
				editformcall: false,

				/**
				 * Reminders
				 */
				approach : [],

				violated : [],

				approach_response : [],

				approach_resolution : [],

				violated_response : [],

				violated_resolution : [],

				priorities : [],

				channels : {},

				target_status : true,

				targetArr : [],

				default_sla : false,

				slaFormFields: { rules: [] },

				submitEndpoint: '',

				formCategories : [],

				showDeleteModal :false,
				deleteType : '',
				deleteIndex : '',
				deleteId : '',
				loading : false
			}
		},

		beforeMount() {

			const path = window.location.pathname;
			
			this.getValues(path);
		},

		created() {			
			window.emitter.on('deleteItem', this.deleteItem);
		},


		watch: {
		
			editformcall(newvalue) {
				
				this.editformcall = newvalue;
			}
		},

		methods : {

			getFormData () {
				this.$store.dispatch('startLoader', 'getFormData');
				axios.get('api/form/automator', { params: { category: 'sla' }})
				.then((response) => {
					this.formCategories = response.data.data.form_categories
					this.submitEndpoint = response.data.data.submit_endpoint
				})
				.catch((error) => {
					errorHandler(error, 'sla')
				})
				.finally(() => {
					this.$store.dispatch('stopLoader', 'getFormData');
				})
			},

			getPriorities() {

				this.$store.dispatch('startLoader', 'getPriorities');

				axios.get('/api/dependency/priorities', { params: {limit: 'all' }}).then(res=>{

					this.priorities = res.data.data.priorities;

					for(var i in this.priorities){

						this.targetArr.push(
							{ 
								id : null,
								ticket_sla_id : null,
								p_id : this.priorities[i].id,
								name : this.priorities[i].name, 
								business_hour : '', 
								respond_count : 4, respond_option : 'hour',
								resolve_count : 10, resolve_option : 'hour',
								channels: []
							}
						)
					}

				}).catch(err=>{

					this.targetArr = [];
					
					errorHandler(err, "sla");
				})
				.finally(() => {
					this.$store.dispatch('stopLoader', 'getPriorities');
				})
			},

			getAllowedChannels()
			{
				this.$store.dispatch('startLoader', 'getAllowedChannels');
				axios.get('/api/sla-alert-channels').then(res =>{
					this.channels = res.data.data;
				}).catch(err=>{
					this.channels = {};
					errorHandler(err, "sla");
				})
				.finally(() => {
					this.$store.dispatch('stopLoader', 'getAllowedChannels');
				})
			},

			getValues(path) {

				this.sla_id = getIdFromUrl(path);

				if(path.indexOf('edit') >= 0){

					this.title = 'edit_sla_plan';

					this.iconClass = 'fas fa-sync';

					this.btnName = 'update';

					this.editform(this.sla_id);
				
				} else {

					this.$store.dispatch('createNewAutomatorInstance');

					this.getPriorities();
				}

				this.getFormData();
				this.getAllowedChannels();
			},

			approchesArray(response,resolution){

				this.approach_response = response;

				this.approach_resolution = resolution;

				this.approach = [...this.approach_response, ...this.approach_resolution];
			},

			violatedArray(response,resolution){

				this.violated_response = response;

				this.violated_resolution = resolution;

				this.violated = [...this.violated_response, ...this.violated_resolution];
			},

			finalArray(array){

				var final = [];

				for(var i in array){

					var option = array[i].option;

					var delta = array[i].reminder_delta;

					var agents = array[i].reminder_receivers.agents;

					var agent_types = array[i].reminder_receivers.agent_types;

                    if(agents.length || agent_types.length) {

                        final.push({

                            id : array[i].id,

                            reminder_delta : 'diff::'+delta + '~' + option,

                            type : array[i].type === 'responded' ? 'response' : array[i].type === 'resolved' ? 'resolution' : array[i].type,

                            reminder_receivers : {

                                agent_types : agent_types.map(a => a.id),

                                agents : agents.map(a => a.id)
                            }
                        })
                    }
				}

				return final
			},

			onChange(value,name){

				this[name] = value;

				let nameArray = name.split('-')

				let index = nameArray[nameArray.length - 1]

				if(name.includes('business_hour-')){
					
					this.targetArr[index].business_hour = value ? value : '';
				}

				if(name.includes('respond_count-')){
					
					this.targetArr[index].respond_count = value
				}

				if(name.includes('respond_option-')){
					
					this.targetArr[index].respond_option = value
				}

				if(name.includes('resolve_count-')){
					
					this.targetArr[index].resolve_count = value
				}

				if(name.includes('resolve_option-')){

					this.targetArr[index].resolve_option = value
				}
			},

			toggleChannel(isSet, index, value)
			{
				let pos = this.targetArr[index].channels.indexOf(value);
        		if (pos > -1) {
    				this.targetArr[index].channels.splice(pos, 1);
  				}
        		if(!isSet) {
        			this.targetArr[index].channels.push(value);        			
        		}
			},

			async validateForm() {
				const { errors, valid } = await this.$refs.faveoAutomatorForm.validate();

				const firstInvalidField = Object.entries(errors).find((item) => item[1].length > 0);

				if (!valid) {
					scrollToErrorBlock(firstInvalidField[0]);
					console.debug(firstInvalidField[0] + ' is not valid!');
					return;
				}

				this.submitForm();
			},

			getTarget(meta){

				var arr = [];

				for(var i in meta){

					var obj = {};

					obj['id'] = meta[i].id;

					obj['p_id'] = meta[i].priority_id;

					obj['ticket_sla_id'] = meta[i].ticket_sla_id;

					obj['name'] = meta[i].priority.name;

					obj['business_hour'] = meta[i].business_hour;
					
					var resolve = meta[i].resolve_within.split('~');

					var res_count = resolve[resolve.length -2].split('::');

					obj['resolve_option'] = resolve[resolve.length -1];

					obj['resolve_count'] = res_count[res_count.length -1];

					var respond = meta[i].respond_within.split('~');

					var resp_count = respond[respond.length -2].split('::');

					obj['respond_option'] = respond[respond.length -1];

					obj['respond_count'] = resp_count[resp_count.length -1];

					obj['channels'] = meta[i].channels

					arr.push(obj)
				}

				return arr;
			},

			slaMeta(){

				let metaArr = [];

				for(var i in this.targetArr) {

					var obj = {};

					obj['id'] = this.targetArr[i].id;
					
					obj['priority_id'] = this.targetArr[i].p_id;

					obj['ticket_sla_id'] = this.targetArr[i].ticket_sla_id;

					obj['business_hour_id'] = this.targetArr[i].business_hour.id;

					obj['respond_within'] = 'diff::'+this.targetArr[i].respond_count + '~' + this.targetArr[i].respond_option;
					
					obj['resolve_within'] = 'diff::'+this.targetArr[i].resolve_count + '~' + this.targetArr[i].resolve_option;

					obj['channels'] = this.targetArr[i].channels.map(function(value, index){
						return {'channel_id':value}
					})

					metaArr.push(obj)
				}

				return metaArr;
			},

			/**
			 * Submit method of the form
			 */
			submitForm() {

				// this.$store.dispatch('startLoader', 'submitForm');

				this.count++;
				
				if (this.count == 1) {

					this.obj['name'] = this.name;

					this.obj['status'] = this.status;
					
					this.obj['internal_notes'] = this.internal_notes;

					this.obj['matcher'] = this.$store.getters.getAutomatorData.matcher;

					this.obj['reminders'] = {
						'approaching' : this.finalArray(this.approach), 
						'violated' : this.finalArray(this.violated)
					}

					this.submitData = Object.assign({}, this.obj);

					const automatorData = this.$store.getters.getAutomatorData;
				
					this.submitData["rules"] = getEnforcerDataByPropertyForSubmit(automatorData.rules, 'rules');

					this.submitData["sla_meta"] = this.slaMeta();
								
					axios.post(this.submitEndpoint, {type: 'sla', data: this.submitData}).then(res => {
						
						successHandler(res, "sla");
					
						if(!this.sla_id){

							setTimeout(()=>{

								this.$router.push({ name : 'SLA Index' });
							},3000);

						} else {

							this.editform(this.sla_id)
						}
					}).catch(error => {
						
						if(error?.response?.status === 412 && error?.response?.data?.message) {
							
							let formattedErr = {};
							
							let params = {type: 'sla', data: this.submitData};
							
							Object.keys(error.response.data.message).forEach(key => {
								
								let splitKey = key.split('.');
								
								let newKey = params.data[splitKey[1]][splitKey[2]].field + params.data[splitKey[1]][splitKey[2]]._id;
								
								formattedErr[newKey] = error.response.data.message[key];
							});
							
							error.response.data.message = formattedErr;
							
							errorHandler(error, 'sla');
							
							return
						}
						
						errorHandler(error, "sla");

					}).finally(res => {

						this.count = 0;

						// this.$store.dispatch('stopLoader', 'submitForm');
					});
				}
			},

			editform(id) {

				this.$store.dispatch('startLoader', 'editform');
			
				this.ruleList = [];

				this.editformcall = true;
				
				axios.get("/api/get-enforcer/sla/"+ id).then(res => {
					
					try {
						this.editData = res.data.data;
					
						this.name = this.editData.name;

						this.status = boolean(this.editData.status);

						this.default_sla = boolean(this.editData.is_default);
						
						this.internal_notes = this.editData.internal_notes;
						
						this.obj.id = this.editData.id;
						
						this.targetArr = this.getTarget(this.editData.sla_meta);

						this.editRuleValues = _.cloneDeep(this.editData.rules);

						const faveoAutomator = new FaveoAutomator(this.editData.id, getEnforcerInstanceList(res.data.data.rules, 'rule'), [], [], res.data.data.matcher);

						this.$store.dispatch('createNewAutomatorInstance', faveoAutomator);
						
						this.ruleList = this.editData.rules;

						this.approach = this.editData.reminders.approaching;

						this.violated = this.editData.reminders.violated;

						this.$store.dispatch('stopLoader', 'editform');
					} catch (error) {
						console.log(error)
					}

				}).catch(err => {
					errorHandler(err, 'sla')
				})
			},

			isValid() {

				const { errors, isValid } = validateSlaSettings(this.$data);
				
				if (!isValid) {
				
					return false;
				
				}
					return true;
			},

			deleteItem ({type, index, id}) {

				this.showDeleteModal = true;

				this.deleteType = type;
				this.deleteIndex = index;
				this.deleteId = id;
			},

			doDelete() {

				if (isLocalElement(this.deleteId)) { this.deleteItemFromStore(this.deleteType, this.deleteIndex); return };

				this.loading = true;
				axios.delete(`api/delete-enforcer/${this.deleteType}/${this.deleteId}`)
					.then((response) => {
						this.deleteItemFromStore(this.deleteType, this.deleteIndex);
						this.showDeleteModal = false;
						this.loading = false;
						successHandler(response, 'sla')
					})
					.catch((error) => {
						this.showDeleteModal = false;
						this.loading = false;
						errorHandler(error, 'sla')
					})
			},

			deleteItemFromStore (type, index) {
				this.showDeleteModal = false;
				this.loading = false;
				this.$store.dispatch('deleteElementFromAutomator', { key: type, index: index })
				window.emitter.emit('deletedItem');
			},

		},

		components : {

			"text-field": TextField,

			'status-switch': Switch,

			'dynamic-select': DynamicSelect,

			'static-select': StaticSelect,
			
			'number-field': NumberField,

			'rule-list': RuleList,

			'sla-escalations' : SlaEscalations,

			'sla-reminders' : SlaReminders
		}
	};
</script>

<style scoped>
	
	.switch-pos{position: relative; top: 6px;}

	.label_align1 {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: 500 !important; padding-top: 6px;
	}

	.checkbox_align {
		width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden;
	}

	.w_70{
		width: 70px !important;
	}

	.w_95{
		width: 95px !important;
	}

	.p_name{
		text-align: left;
		word-break: break-all;
	}

	#target_table{
		font-size: inherit !important;
	}

</style>

<style>

#sla-rules-container .faveo-trash {
  padding-top: 8px !important;
}

	.active-channel {
	color: #797A7A;
	/*color: #4A4A4B;*/
	/*color: #4CA746*/
}

.inactive-channel {
	color: #C5C5C5
}
</style>