<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="divStyle">

		<template #title>
	
			<h4 class="modal-title">{{lang('time-track')}}</h4>
		</template>

		<template #fields>

			<div  v-if="!loading && deleteTrack" class="row">

				<div class="col-sm-12">

					<span>{{lang('are_you_sure_you_want_to_delete')}}</span>
				</div>
			</div>

			<div v-if="!loading && !deleteTrack">
				<div class="row" v-focus-first-input>
					<time-field :label="lang('worktime')" :value="worktime"  :formStyle="formStyle" type="number" name="worktime"
								:onChange="onChange" classname="col-sm-6" :required="true">
					</time-field>
					<dynamic-select v-if="getTicketActions.show_worktime_type && worktime" :label="trans('worktime_type')" name="worktime_type" :value="worktime_type"
									:onChange="onChange" :strlength="30" :multiple="false" classname="col-sm-6"
									apiEndpoint="api/worktime-type-list" :required="getTicketActions.show_worktime_type && getTicketActions.require_worktime_type_field && worktime"></dynamic-select>
				</div>
				<div class="row">
					<text-field :label="lang('description')" :value="description" type="textarea" name="description"
								:onChange="onChange" :required="true" classname="col-md-12">

					</text-field>
				</div>
			</div>

			<div class="row" v-if="loading">

				<reuse-loader :duration="4000" :size="60"></reuse-loader>

			</div>
		</template>

		<template #controls>
			
			<button type="button"  @click="onSubmit" :class="btnClass" :disabled="isDisabled">
			
				<i :class="iconClass"></i> {{lang(btnName)}}
			</button>
		</template>
	</modal>
</template>

<script>

	import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";

	import axios from 'axios'

	import {validateTimeTrackSettings} from "../../../../../../../helpers/validator/timeTrackSettingsRules";
	import {useStore} from "vuex";
	import {computed} from "vue";
	import TextField from "../../../../../../MiniComponent/FormField/TextField.vue";
	import TimeField from "../../../../../../MiniComponent/FormField/TimeField.vue";
	import DynamicSelect from "../../../../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {

		name:'change-requester-modal',

		description: 'Change requester modal component',

		setup() {

			const store = useStore();

			return {

				getTicketActions : computed(()=>store.getters.getTicketActions)
			}
		},

		props:{

			showModal : { type : Boolean, default : false },

			onClose : { type : Function },

			ticketId : { type : [String, Number], default : '' },

			reloadDetails : { type : Function },

			deleteTrack : { type : Boolean, default : false},

			editTrack : { type : Boolean, default : false},

			trackData : { type : Object, default : ()=> {} },

			updateData : { type : Function }
		},

		data(){
			
			return {

				isDisabled:false,

				loading:false,

				description : '',

				worktime : 0,

				divStyle : { width : '700px' },

				formStyle:{ width:'30%' },

				btnName : 'save',

				iconClass : 'fas fa-save',

				btnClass : 'btn btn-primary',

				apiUrl : 'ticket/'+this.ticketId+'/time-track',

				actions:'',

                worktime_type : ''
			} 
		},

		beforeMount() {

			this.getInitialValues();
			this.actions = this.getTicketActions;
		},

		methods:{

			getInitialValues() {

				if(this.editTrack) {

					this.btnName = 'update'

					this.iconClass = 'fas fa-sync-alt'

					this.description = this.trackData.description;

					this.worktime = this.trackData.work_time;

					this.apiUrl = 'ticket/'+this.trackData.ticket_id+'/time-track/'+this.trackData.id;

					if(this.trackData.worktime_type) {
                        this.worktime_type = {id : this.trackData.worktime_type.id, name : this.trackData.worktime_type.name};
					}
				}

				if(this.deleteTrack) {

					this.btnName = 'delete'

					this.iconClass = 'fas fa-trash'

					this.btnClass = 'btn btn-secondary'
				}
			},

			onChange(value,name) {

				this[name] = value;
			},

			isValid(){
				
				const {errors, isValid} = validateTimeTrackSettings(this.$data)
				
				if(!isValid){
				
					return false
				}
				
				return true
			},

			onSubmit(){

				if(this.deleteTrack){
					
					this.deleteTime()
				} else{
                    this.worktime_type = this.worktime_type || '';
					if(this.isValid()){

						this.loading = true;

						this.isDisabled = true;

						const data = {};

						data['description'] = this.description;
						
						data['work_time'] = this.worktime;
						
						data['entrypoint'] = 'popup';

						if(this.worktime_type) {
                            data['worktime_type'] = this.worktime_type.id;
                        }

                            axios.post(this.apiUrl,data).then(res=>{

							successHandler(res,'timeline');

							this.updateData('track');

							this.loading = false;

							this.isDisabled = false;

							this.onClose();

						}).catch(err=>{

							errorHandler(err,'timeline');

							this.loading = false;

							this.isDisabled = false;

							this.onClose();
						})
					}
				}
			},

			deleteTime() {

				this.loading = true
				
				this.isDisabled = true
				
				axios.delete('ticket/time-track/'+this.trackData.id).then(res=>{
					
					this.loading = false;
				
					this.isDisabled = true

					successHandler(res,'timeline');
					
					this.updateData('track');

					this.onClose();
				
				}).catch(err => {
				
					errorHandler(err,'timeline')
					
					this.loading = false;
				
					this.isDisabled = true;

					this.onClose();
				})
			}
		},

		components:{

			'text-field': TextField,

			'time-field': TimeField,

			'dynamic-select' : DynamicSelect
		},
	};
</script>