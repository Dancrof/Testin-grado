<template>

	<div class="col-sm-12">
		
		<alert componentName="login-log-settings"></alert> 

		<div class="card card-light">
			
			<div class="card-header">
				
				<h3 class="card-title">{{trans('login-log-setting')}}</h3>
			</div>

			<div class="card-body">

				<div class="row">
					
					<div class="col-sm-3">

						<label>{{trans('days_to_delete_login_logs')}} <span class="text-danger"> *</span></label>
					</div> 

					<static-select :label="trans('days_to_delete_login_logs')" strlength="60"  :elements="daysOptions" :hideEmptySelect="true"
						name="day" :value="day" classname="col-sm-4" :onChange="onChange" :required="true" :labelStyle="labelStyle">
					
					</static-select>
				</div>
			</div>

			<div class="card-footer">

				<button class="btn btn-primary" @click="onSubmit()" :disabled="isDaysEmpty">
					
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

	import {errorHandler,successHandler} from "../../../../helpers/responseHandler";

	import axios from 'axios'

    import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";

	export default {

		name : 'login-log-settings',

		props : {

			days : { type : [String, Number], default : '' }
		},

		data () {

			return {

				pageLoad : false,

				day : this.days,
				
				daysOptions:[{name:'1 Day',id:1},{name:'7 Days',id:7},{name:'1 Month (30 Days)',id:30},{name:'2 Months (60 Days)',id:60},{name:'6 Months (180 Days)',id:180},{name:'1 Year (365 Days)',id:365}],

				labelStyle : { display : 'none' }
			}
		},

		methods : {

			onChange(value, name) {

				this[name] = value;

				if(value === null){

					this[name] = '';
				}
			},

			onSubmit() {
			
				this.pageLoad = true;
				
				let userId =  sessionStorage.getItem('user_id');
				
				const data = {};

				data['days'] = this.day;

				axios.post('/api/delete-login-logs/days/'+userId, data).then(res => {

					this.pageLoad = false;
					
					successHandler(res,'login-log-settings');
					
				}).catch(err => {

					this.pageLoad = false;
				
					errorHandler(err,'login-log-settings');
				});
			}
		},

    computed: {
      isDaysEmpty() {

        return this.day.length === 0;
      }
    },

		components : {

            'static-select': StaticSelect,
		}
	};
</script>