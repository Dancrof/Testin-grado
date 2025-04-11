<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="divStyle">

		<template #title>
	
			<h4 class="modal-title">{{lang('change_due_date')}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading" class="row">

				<date-time-field
					:label="lang('select_date')"
					value=""
					type="datetime"
					key="due_date"
					id="due_date"
					name="due_date"
					:onChange="onChange"
					:required="true"
					format="YYYY-MM-DD HH:mm:ss"
					classname="col-sm-12 due_picker"
					:clearable="true"
					:disabled="false"
					:editable="true"
					:currentYearDate="false"
					:notBefore="new Date()"
				>
				</date-time-field>
			</div>

			<div class="row" v-if="loading">

				<reuse-loader :duration="4000" :size="60"></reuse-loader>

			</div>
		</template>

		<template #controls>
			<button type="button"  @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">

				<i class="fas fa-sync-alt"></i> {{lang('update')}}
			</button>
		</template>
	</modal>
</template>

<script>

	import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";

	import axios from 'axios'

	import moment from 'moment'
	import DateTimePicker from "../../../../../../MiniComponent/FormField/DateTimePicker.vue";

	export default {

		name:'due-date-modal',

		description:'Due Date modal Component',

		props:{

			showModal : { type : Boolean, default : false },

			onClose : { type : Function },

			ticketId : { type : [String, Number], default : '' },

			reloadDetails : { type : Function }
		},

		data(){
			
			return {

				isDisabled:false,

				loading:false,

				due_date : '',

				divStyle : { width : '500px' }
			} 
		},

		beforeMount() {

			this.isDisabled = this.due_date ? false : true;
		},

		methods:{

			onChange(value,name) {

				this[name] = value;

				this.isDisabled = value ? false : true;
			},

			onSubmit(){
				
				this.loading = true;

				this.isDisabled = true;

				const data = {};

				data['ticket-id'] = this.ticketId;

				data['duedate'] =  moment(this.due_date).format('YYYY-MM-DD HH:mm:ss');

				axios.post('/api/ticket/change-duedate',data).then(res=>{

					this.reloadDetails('duedate');

					successHandler(res,'timeline');

					this.loading = false;

					this.isDisabled = false;

					this.onClose();

				}).catch(err=>{

					errorHandler(err,'timeline');

					this.loading = false;

					this.isDisabled = false;

					this.onClose();
				})
			},
		},

		components:{

			'date-time-field': DateTimePicker,
		},
	};
</script>

<style>
	
	.due_picker .mx-datepicker-popup {
		bottom: 100% !important;
		top: auto !important;
	}
</style>