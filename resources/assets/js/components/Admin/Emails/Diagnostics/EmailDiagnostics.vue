<template>

	<div class="col-sm-12">

		<alert componentName="email-diagno"></alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{trans('send-mail-to-diagnos')}}</h3>
			</div>

			<div class="card-body">

				<div class="row">

					<dynamic-select :label="trans('from')" :multiple="false"
						name='from' classname="col-sm-6"
						apiEndpoint="api/emails-list?outgoing_emails=true"
						:value="from" :onChange="onChange" :strlength="60"
						:required="true" :clearable="from ? true : false">
					</dynamic-select>

					<text-field :label="trans('to')" :value="to" type="text" name="to" :onChange="onChange" :placehold="lang('enter_a_value')"
       				classname="col-sm-6" :keyupListener="triggerEvent" :required="true">
					</text-field>
				</div>

				<div class="row">

					<text-field :label="trans('subject')" :value="subject" type="text" name="subject" :onChange="onChange"  :placehold="lang('enter_a_value')"
       				classname="col-sm-12" :keyupListener="triggerEvent" :required="true">
					</text-field>

					<text-field :label="trans('message')" :value="message" type="textarea" name="message" :onChange="onChange"  :placehold="lang('enter_a_value')"
       				classname="col-sm-12" :keyupListener="triggerEvent" :required="true">
					</text-field>
				</div>
			</div>

			<div class="card-footer">

				<button type="button" class="btn btn-primary" @click="onSubmit">

					<i class="fas fa-paper-plane"> </i> {{trans('send')}}
				</button>
			</div>
		</div>

		<div class="row" v-if="loading">

			<custom-loader :duration="4000"></custom-loader>
		</div>
	</div>
</template>

<script>

	import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
	
	import { validateDiagnoSettings } from "../../../../helpers/validator/diagnoRules.js"

	import axios from 'axios'
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {

		name : 'email-diagno',

		data() {

			return {

				from : '',

				to : '',

				subject : '',

				message : '',

				loading : false
			}
		},

		methods : {

			onChange (value, name) {

				this[name] = value;
			},

			isValid() {

				const { errors, isValid } = validateDiagnoSettings(this.$data);

				return isValid
			},

			onSubmit () {

				if(this.isValid()){

					this.loading = true

					let data = {};

					data['from'] = this.from.id;

					data['to'] = this.to;

					data['subject'] = this.subject;

					data['message'] = this.message.replace(/\r?\n/g, '<br />');

					axios.post('/api/postdiagno', data).then(res => {

						this.loading = false

						successHandler(res,'email-diagno');

						this.resetFields()

					}).catch(err => {

						this.loading = false

						errorHandler(err,'email-diagno')
					});
				}
			},

			resetFields() {

				this.from = '';

				this.to = '';

				this.subject = '';

				this.message = '';
			},
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },
		},

		components : {

			"text-field": TextField,

			'dynamic-select': DynamicSelect,
		}
	};
</script>
