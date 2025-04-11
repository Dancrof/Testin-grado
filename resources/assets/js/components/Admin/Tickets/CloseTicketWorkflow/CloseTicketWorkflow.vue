<template>

	<div class="col-sm-12">

		<alert componentName="close-ticket-workflow"></alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{trans('close_ticket_workflow')}}</h3>
				<div class="card-tools" v-if="helplink">
					<a class="btn btn-tool" :href="helplink" target="__blank" v-tooltip="trans('read_more')">
						<i class="fas fa-question-circle"> </i>
					</a>
				</div>
			</div>

			<div class="card-body">

				<div class="row" v-if="!hasDataPopulated || loading">

					<reuse-loader :animation-duration="4000" :size="60"/>
				</div>

				<template v-if="hasDataPopulated">

					<div class="row" v-focus-first-input>

						<number-field :label="trans('no_of_days')" :value="days" name="days" :onChange="onChange"  :keyupListener="triggerEvent"
							classname="col-sm-6" type="number" :required="true" placeholder="n" :hint="trans('close-msg1')"
						>

						</number-field>

<!--						<radio-button :options="radioOptions" :label="trans('send_email_to_user')" name="send_email"  :keyupListener="triggerEvent"-->
<!--							:value="send_email" :onChange="onChange" classname="form-group col-sm-6" :hint="trans('close-msg4')">-->

<!--						</radio-button>-->
					</div>

					<div class="row">

						<dynamic-select :label="trans('ticket_status')" :multiple="true" name="ticket_status" classname="col-sm-6"
							apiEndpoint="/api/dependency/statuses?config=true" :value="ticket_status" :onChange="onChange" :strlength="30"
							:required="true" :hint="trans('close_ticket_statu_msg')">

						</dynamic-select>
          </div>

					<div class="row">
						
						<dynamic-select :label="trans('target_status')" :multiple="false" name="status" classname="col-sm-6"
							apiEndpoint="/api/dependency/statuses?supplements[purpose_of_status][]=2" :value="status" :onChange="onChange"
							:strlength="30" :required="true" :clearable="status ? true : false" :hint="trans('close-msg3')">

						</dynamic-select>
					</div>
				</template>
			</div>

			<div class="card-footer">

				<button class="btn btn-primary" @click="onSubmit()">

					<i class="fas fa-save"></i> {{trans('save')}}
				</button>
			</div>
		</div>

		<div class="row" v-if="pageLoad">

			<custom-loader :duration="4000"></custom-loader>
		</div>
	</div>
</template>

<script>

	import { validateCloseWorkflowSettings } from "../../../../helpers/validator/closeWorkflowSettingRules.js"

    import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

    import axios from 'axios'
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
    import NumberField from "../../../MiniComponent/FormField/NumberField.vue";

	export default {

		name : 'close-ticket-workflow',

		data () {

			return {

				days : '',

				ticket_status : '',

				status : '',

				loading : true,

				hasDataPopulated : false,

				pageLoad : false,

				helplink : '',
			}
		},

		beforeMount(){

			this.getValues();
		},

		methods : {

			getValues(id){

				axios.get('/api/close-workflow').then(res=>{

					this.loading = false;

					this.hasDataPopulated = true;

					let values = res.data.data.workflowClose;

					this.days = values.days;

					this.send_email = values.send_email;

					this.status = values.status;

					this.ticket_status = values.ticket_status;

					this.helplink = values.helpLink;
				}).catch(error=>{

					this.loading = false;

					this.hasDataPopulated = true;
				});
			},

			isValid() {

				const { errors, isValid } = validateCloseWorkflowSettings(this.$data);

				return isValid;
			},

			onChange(value, name) {

				this[name] = value;

				if(value === null){

					this[name] = '';
				}
			},

			onSubmit() {

				if (this.isValid()) {

					this.pageLoad = true;

					const data = {};

					data['days'] = this.days;

					data['ticket_status'] = this.ticket_status.map(a => a.id);

					data['status'] = this.status.id;

					data['_method'] = 'PATCH';

					axios.post('/api/close-workflow-update', data).then(res => {

						this.pageLoad = false;

						successHandler(res,'close-ticket-workflow');

						this.getValues()

					}).catch(err => {

						this.pageLoad = false;

						errorHandler(err,'close-ticket-workflow');
					});
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

			'dynamic-select': DynamicSelect,
			
			'number-field': NumberField
		}
	};
</script>
