<template>

	<div class="col-sm-12">

		<alert componentName="inapp-settings"></alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{trans('notification_settings')}}</h3>

			</div>

			<div class="card-body">

				<div class="row" v-focus-first-input>
					<number-field :label="trans('noti_msg1')" :value="days_to_delete" name="days_to_delete"
						:onChange="onChange" classname="col-sm-6" :keyupListener="triggerEvent" type="number" :required="true" placeholder="n"
						:hint="trans('noti_msg2')">

					</number-field>
				</div>
				<div class="row">
					<checkbox id="delete-read" name="only_read" :value="only_read" :label="trans('delete_noti')"
					:onChange="onChange" classname="col-md-12" :hint="trans('delete_only_read_tooltip')">
					</checkbox>
				</div>
			</div>

			<div class="card-footer">

				<button class="btn btn-secondary" @click="onSubmit()">

					<i class="fas fa-trash"></i> {{trans('delete')}}
				</button>
			</div>
		</div>

		<div class="row" v-if="pageLoad">

			<custom-loader :duration="4000"></custom-loader>
		</div>

	</div>
</template>

<script>

import {validateNoticeSettings} from "../../../../../resources/assets/js/helpers/validator/noticeSettingRules";

import {errorHandler,successHandler} from "../../../../../resources/assets/js/helpers/responseHandler";

import axios from 'axios'
import NumberField from "../../../../../resources/assets/js/components/MiniComponent/FormField/NumberField.vue";
import Checkbox from "../../../../../resources/assets/js/components/MiniComponent/FormField/Checkbox.vue";

export default {

	name : 'inapp-settings',

	data () {

		return {

			pageLoad : false,

			loading : false,

			days_to_delete : '',

			showModal : false,

			only_read : false
		}
	},

	methods : {

		isValid() {

			const { errors, isValid } = validateNoticeSettings(this.$data);

			return isValid;
		},

		onChange(value, name) {
			this[name] = value;
		},

		onSubmit() {

			if (this.isValid()) {

				this.pageLoad = true;

				const data = {};

				data['days_to_delete'] = this.days_to_delete;

				data['only_read'] = this.only_read;

				axios.delete('/api/clear-notifications', {data}).then(res => {

					this.pageLoad = false;

					successHandler(res,'inapp-settings');

					this.days_to_delete = '';

					this.only_read = false;

				}).catch(err => {

					this.pageLoad = false;

					errorHandler(err,'inapp-settings');
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

		'number-field' : NumberField,

		'checkbox' : Checkbox
	}
};
</script>
