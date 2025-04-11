<template>

	<div class="col-sm-12">

		<alert componentName="UserExport"/>

		<div class="card card-light ">

			<div class="card-header">

				<h3 class="card-title">{{lang('users')}}</h3>
			</div>

			<div class="card-body">

				<div v-if="!loading" class="row">

					<date-time-field :label="lang('select_date_range')"
						:value="date_range"
						type="date"
						name="date_range"
						:required="false"
						:onChange="onChange" range
						:currentYearDate="false"
						format="YYYY-MM-DD" classname="col-sm-6"
						:clearable="true" :editable="true" :disabled="false" :pickers="getPickers()">
					</date-time-field>

					<a class="btn btn-primary" @click="onSubmit()" id="range-submit" href="javascript:;">

						<i class="fas fa-save"></i> {{lang('submit')}}
					</a>
				</div>

				<div v-if="loading" class="row">

					<div class="col-md-12 col-sm-12 col-12">

						<reuse-loader :animation-duration="4000" :size="60"/>
					</div>
				</div>
		</div>
	</div>
	</div>
</template>

<script>

	import {errorHandler} from "../../../helpers/responseHandler";

	import axios from 'axios'

	import moment from 'moment'
	import DateTimePicker from "../../MiniComponent/FormField/DateTimePicker.vue";

	export default {

		name : 'user-export',

		description : 'User export component',

		data() {

			return{

				date_range :'',

				start : '',

				end : '',

				loading : false,
			}
		},

		methods : {

			getPickers(){

				const self = this;
				let date = new Date();

				let pickers = [

					{ text: 'Today', onClick() {
							return self.onChange([date,date],'date_range')
						}
					},

					{ text: 'Yesterday', onClick() {
							return self.onChange([new Date(Date.now() - 86400000),new Date(Date.now() - 86400000)],'date_range')
						}
					},

					{ text: 'Last 7 days', onClick() {
							return self.onChange([new Date(Date.now() - 86400000 * 7),date],'date_range')
						}
					},

					{ text: 'Last 30 days', onClick() {
							return self.onChange([new Date(Date.now() - 86400000 * 30),date],'date_range')
						}
					},

					{ text: 'Next 7 days', onClick() {
							return self.onChange([date,new Date(Date.now() + 86400000 * 7)],'date_range')
						}
					},

					{ text: 'Next 30 days', onClick() {
							return self.onChange([date,new Date(Date.now() + 86400000 * 30)],'date_range')
						}
					},

					{ text: 'This month', onClick() {
							return self.onChange([new Date(date.getFullYear(), date.getMonth(), 1),new Date(date.getFullYear(), date.getMonth() + 1, 0)],'date_range')
						}
					},

					{ text: 'Last month', onClick() {
							return self.onChange([new Date(date.getFullYear(), date.getMonth() -1 , 1),new Date(date.getFullYear(), date.getMonth()-1 + 1, 0)],'date_range')
						}
					}
				]

				return pickers;
			},

			onChange(value,name){

				this[name] = value;

				this.start = value[0] !== null ? moment(value[0]).format('YYYY-MM-DD') : '';

				this.end =  value[1] !== null ? moment(value[1]).format('YYYY-MM-D') : '';
			},

			onSubmit(){

				if(this.start) {

					this.loading = true;

					axios.get('/user-export-download?start_date='+this.start+'&end_date='+ this.end).then(res=>{

            this.$store.dispatch('setAlert',{type:'success',message:res.data.message, component_name : 'UserExport'})

						this.loading = false;

					}).catch(error=>{

						this.loading = false;

						errorHandler(error,'UserExport')
					})
				} else {

					this.$store.dispatch('setAlert',{type:'danger',message:'Please select the date range', component_name : 'UserExport'})

				}
			}
		},

		components : {

			'date-time-field': DateTimePicker
		}
	};
</script>

<style scoped>

	#range-submit{
		margin: 29px;
		cursor: pointer;
	}
</style>
