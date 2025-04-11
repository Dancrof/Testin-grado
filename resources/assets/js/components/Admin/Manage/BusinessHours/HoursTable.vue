<template>
	<!-- hours select table -->
	<div id="hours_table">
		<table id="example2" class="table">
			<thead class="inputField"> 
				<tr>				
					<td style="width:20%">
						<label class="label_align">
							<input class="checkbox_align" id="day_select" type="checkbox" name="day" @change="daySelect(day.status,index)" :checked="day.status != 'Closed'"> {{lang('day'+index)}}
						</label>
					</td>
										
					<td id="open24">
						<label class="label_align1">
							<input class="checkbox_align" id="open24_hour" type="checkbox" name="open_hour" @change="open24(day.status,index)" :checked="day.status == 'Open_fixed'" :disabled="day.status == 'Closed'"> {{lang('open24Hours')}}
						</label>
					</td> 
																				
					<td id="timeSelect" >
						<div class="row">
							
										
								<date-time-field :id="'open_time' +index" :label="lang('date')" :value="moment(day.open_time,'H:m')"   :labelStyle="labelStyle" :name="'open_time'+index" type="time" :onChange="onChangeStartTime"  :required="day.required" :time-picker-options="openTimeOptions" format="HH:mm"  classname="col-sm-6" :clearable="false" :disabled="day.status == 'Open_fixed' || day.status == 'Closed' "  place="From..." :checkManual="true"></date-time-field>
										
								<date-time-field :id="'close_time' +index" :label="lang('date')" :value="moment(day.close_time,'H:m')"   :labelStyle="labelStyle" :name="'close_time'+index" type="time" :onChange="onChangeEndTime"  :required="day.required" :time-picker-options="closeTimeOptions" format="HH:mm"  classname="col-sm-6" :clearable="false" :disabled="day.status == 'Open_fixed' || day.status == 'Closed' "  place="To..." :checkManual="true"></date-time-field>
						
						</div>
					</td>  
				</tr>

			</thead> 
		</table> 
	</div> 	 
</template>

<script>

import moment from "moment"
import DateTimePicker from "../../../MiniComponent/FormField/DateTimePicker.vue";

	export default {
		
		name: 'hours-table',
		
		description: 'hours table component',

		components:{

			'date-time-field': DateTimePicker,
		},

		props:{

			/**
			 * contains particular day details
			 * @type {Object}
			 */
			day:{type:Object,default:()=>{}},

			/**
			 * index of the particular day in days array
			 * @type {Object}
			 */
			index:{type:Number,default:0},

			/**
			 * this function getting called when change time in datetime picker
			 * @type {Object}
			 */
			onHoursChange:{type:Function},

			/**
			 * this function getting called when change day checkbox
			 * @type {Object}
			 */
			onClosed:{type:Function},

			/**
			 * this function getting called when change open24 hours checkbox
			 * @type {Object}
			 */
			onOpenfixed:{type:Function}
		},

		data: () => ({

			/**
			 * checkbox disabled status
			 * @type {Boolean}
			 */
			isDisabled:false,

			/**
			 * timepicker options
			 * @type {Object}
			 */
			openTimeOptions:{
						start: '00:00',
						step: '00:30',
						end: '23:30'
			},

			closeTimeOptions:{
						start: '00:00',
						step: '00:30',
						end: '23:30'
			},
			/**
			 * label display attribute value
			 * @type {Object}
			 */
			labelStyle:{
				display:'none'
			},

			/**
			 * moment declaration
			 */
			moment:moment

		}),

		watch:{
			//function for updating new value of the day
			day(newValue,oldValue){
				this.day = newvalue
			}
		},

		beforeMount(){

      let formatted = moment(this.day.open_time, "HH:mm").format();

			this.closeTimeOptions.start = this.day.open_time !== null ? moment(formatted).add(30, 'minutes').format("HH:mm") : '00:00';
		},

		methods:{
			/**
			 * this function getting called when we change time in from timepicker
			 * @return {Void} 
			 */
			onChangeStartTime(value,index){
        this.closeTimeOptions.start = moment(value).add(30, 'minutes').format("HH:mm");
        this.day.close_time = moment(value).add(30, 'minutes').format("HH:mm");
        let x = index.split("");
				let newindexValue = x[x.length - 1];
				this.onHoursChange('open_time',value,newindexValue);
			},

			/**
			 * this function getting called when we change time in to timepicker
			 * @return {Void} 
			 */
			onChangeEndTime(value,index){
				let x = index.split("");
				let newindexValue = x[x.length - 1];
				this.onHoursChange('close_time',value,newindexValue);
			},

			/**
			 * this function getting called when we change day checkbox
			 * it will disable the open24hours checkbox
			 * @return {Void} 
			 */
			daySelect(status,index){
				let changedStatus= (status === 'Closed') ? 'Open_custom' : 'Closed';
				this.onClosed(changedStatus,index);
				this.onHoursChange('close_time','00:00',index);
				this.onHoursChange('open_time','00:00',index);
			},

			/**
			 * this function getting called when we change open24 hours checkbox
			 * it will disable the timepicker
			 * @return {Void} 
			 */
			open24(status,index){
				let changedStatus= (status === 'Open_custom') ? 'Open_fixed' : 'Open_custom';
				this.onClosed(changedStatus,index);
				this.onHoursChange('close_time','00:00',index);
				this.onHoursChange('open_time','00:00',index);
			},

		}
	};
</script>

<style type="text/css">
	.label_align {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: 700 !important; padding-top: 6px;
	}
	.label_align1 {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: 500 !important; padding-top: 6px;
    }
  .checkbox_align {
	 	width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px;
	 	overflow: hidden;
    cursor: pointer;
	}
	#add_btn{ color:green;font-size:20px; }

	#remove_btn{ color:red;font-size:20px; }
	
	#to { position: relative;top:-3px; }

	#open24{ width:20%; background:none; }

 	#timeSelect{ text-align:center; background:none;padding-bottom: 22px; }
</style>