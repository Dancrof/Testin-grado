<template>

	<div class="col-sm-12">

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{ trans('payment_approval_alert') }}</h3>
			</div>

			<div class="card-body">

				<div class="row">

					<radio-button :options="statusOptions" :label="trans('status')" name="payment_approval_alert"
					              :value="payment_approval_alert" :onChange="onChange"
					              classname="form-group col-sm-6">

					</radio-button>

					<check-box :options="checkboxOptions" name="payment_approval_alert_mode" :value="payment_approval_alert_mode"
					           :label="trans('mode')" :onChange="onChange" class_name="col-sm-6"
					           classname="col-sm-6">

					</check-box>
				</div>

				<div class="row">

					<check-box :options="personOptions" name="payment_approval_alert_persons" :value="payment_approval_alert_persons"
					           :label="trans('persons')" :onChange="onChange" class_name="col-sm-12 pb-2"
					           classname="col-sm-12" :labelStyle="{ display : 'none' }">

					</check-box>
				</div>
			</div>
		</div>
	</div>
</template>

<script>

export default {

	name : 'approval-payment-alert',

	props : {

		data: {type: String|Object, required: true}
	},

	data () {

		return {

			alertData : JSON.parse(this.data),

			statusOptions:[{name:'enable',value:1},{name:'disable',value:0}],

			checkboxOptions:[{name:'email',value:'email'}],

			personOptions : [
				{name:'admin',value:'admin'},
				{name:'agent',value:'agent'},
			],

			payment_approval_alert : 0,

			payment_approval_alert_mode : [],

			payment_approval_alert_persons : [],
		}
	},

	beforeMount() {

		this.updateValues();
	},

	methods : {

		updateValues() {

			this.payment_approval_alert = parseInt(this.alertData['payment_approval_alert']);

			if(this.alertData['payment_approval_alert_mode']){

				this.payment_approval_alert_mode = this.alertData['payment_approval_alert_mode'].split(',');
			}

			if(this.alertData['payment_approval_alert_persons']) {

				this.payment_approval_alert_persons = this.alertData['payment_approval_alert_persons'].split(',');
			}
		},

		onChange(value, name) {

			this[name] = value;

			window.emitter.emit('alertDataUpdate',value,name);
		}
	},

	components : {

		'radio-button':require('components/MiniComponent/FormField/RadioButton'),

		'check-box': require('components/MiniComponent/FormField/CheckBoxComponent'),
	}
};
</script>