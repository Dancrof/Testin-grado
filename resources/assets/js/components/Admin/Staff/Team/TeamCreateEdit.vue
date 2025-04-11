<template>
	
	<div class="col-sm-12">
	
		<div class="row" v-if="!hasDataPopulated || loading">
	
			<custom-loader :duration="4000"></custom-loader>
		</div>

		<alert componentName="teams"/>

		<div class="card card-light" v-if="hasDataPopulated">

			<div class="card-header">
				
				<h3 class="card-title">{{trans(title)}}</h3>

				<div v-if="teamData && teamData.status" class="card-tools">
						
					<router-link class="btn-tool" :to="'/team/'+team_id" v-tooltip="trans('view')">
		
						<i class="fas fa-eye"> </i> 
					</router-link>
				</div>
			</div>
				
			<div class="card-body">
				
				<div class="row" v-focus-first-input>
				
					<text-field label="Name" :value="name" type="text" name="name" :onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-6"
						:required="true">
					
					</text-field>

					<dynamic-select :label="trans('team_lead')" :multiple="false" name="lead" :prePopulate="true" :hint="trans('team-lead-hint')"
						classname="col-sm-6" :apiEndpoint="lead_api" :value="lead" :onChange="onChange" :required="false" :strlength="45">
					
					</dynamic-select>
				</div>

				<div class="row">
					
					<dynamic-select :label="trans('departments')" :multiple="true" name="departments" classname="col-sm-6" 
						apiEndpoint="/api/dependency/departments" :value="departments" :onChange="onChange" :required="false" :strlength="45">
					
					</dynamic-select>

					<radio-button :options="radioOptions" :label="trans('status')" name="status" :value="status" :onChange="onChange" 
						classname="form-group col-sm-4" :hint="trans('team-status-hint')">
					
					</radio-button>
				</div>
				
				<div>

					<tiny-editor :value="admin_notes" :onChange="onChange" name="admin_notes" :label="trans('admin_notes')"
								 width="100%" :required="false" id="team-edit-editor" :lang="'en'" :hint="trans('team-notes-hint')">
						
					</tiny-editor>
				</div>
			</div>

			<div class="card-footer">

				<button type="button" @click="onSubmit" :disabled="loading" class="btn btn-primary">
						
					<span :class="iconClass"></span>&nbsp;{{trans(btnName)}}
				</button>
			</div>
		</div>
	</div>
</template>

<script>

	import axios from "axios";

    import {errorHandler,successHandler} from "../../../../helpers/responseHandler";

	import { validateTeamSettings } from "../../../../helpers/validator/teamCreateRules";

	import {getIdFromUrl} from '../../../../helpers/extraLogics';

	import TextField from "../../../MiniComponent/FormField/TextField.vue";

	import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";

	import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";

	export default {

		name: "team-create-edit",

		description: "Team create and edit page",

		data() {

			return  {

				name: "",

				lead : '', 

				status : 1,

				departments : [],

				admin_notes : "",

				loading: false,

				hasDataPopulated: true,

				radioOptions:[{name:'Active',value:1},{name:'Inactive',value:0}],

				title :'create_a_team', 

				iconClass:'fas fa-save',

				btnName:'save',

				team_id :'',

				teamData : {},

				lead_api : '/api/dependency/team-qualifiable-leads',
			}
		},

		beforeMount() {

			const path = window.location.pathname;
			
			this.getValues(path);
		},

		methods: {

			getValues(path){

				const teamId = getIdFromUrl(path);

				if(path.indexOf('edit') >= 0){

					this.title = 'edit_a_team';
					
					this.iconClass = 'fas fa-sync'
					
					this.btnName = 'update'
					
					this.hasDataPopulated = false;
					
					this.getInitialValues(teamId);

					this.lead_api = '/api/dependency/team-qualifiable-leads?supplements='+teamId;

				} else {
					
					this.loading = false;

					this.hasDataPopulated = true
				}
			},

			getInitialValues(teamId) {
				
				this.loading = true;			
				
				axios.get('/api/admin/edit-team/'+teamId).then(res => {
				
					this.loading = false;
					
					this.hasDataPopulated = true;

					this.team_id  = teamId;

					this.teamData = res.data.data.team;
				
					this.updateStatesWithData(this.teamData);

				}).catch(err => {

					this.loading = false;

					errorHandler(err)
					
				});
			},

			updateStatesWithData(data) {
				
				const self = this;
				
				const stateData = this.$data;
				
				Object.keys(data).map(key => {
					
					if (stateData.hasOwnProperty(key)) {
					
						self[key] = data[key];
					}
				});
			},

			isValid() {
				
				const { errors, isValid } = validateTeamSettings(this.$data);
				
				return isValid;
			},

			onSubmit() {
				
				if (this.isValid()) {

					this.loading = true;

					const data = {};

					if(this.team_id != ''){
						
						data['id'] = parseInt(this.team_id)
					}

					if(this.departments.length){
						
						data['department_ids'] = this.departments.map(obj=>obj.id);
					
					} else {
					
						data['department_ids'] = [];
					}

					data['name'] = this.name

					data['admin_notes'] = this.admin_notes;

					data['team_lead_id'] = this.lead ? this.lead.id : '';
						
					data['status'] = this.status;
					
					axios.post('/api/admin/create-update-team', data).then(res => {
						
						this.loading = false;
						
						successHandler(res,'teams');
						
						if(!this.team_id){

							setTimeout(()=>{

                let id = res.data.data.id
								return this.$router.push('/team/'+id);
							},3000)

						}else {
								
							this.getInitialValues(this.team_id);
						}
					}).catch(err => {
							
						this.loading = false;
							
						errorHandler(err,'teams');
					});
				} 
			},

			onChange(value, name) {
				
				this[name] = value;
			}
		},

		components: {
		
			TextField,
		
			DynamicSelect,

			RadioButton,
		}
	};	
</script>