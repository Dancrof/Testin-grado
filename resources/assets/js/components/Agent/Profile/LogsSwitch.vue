<template>

	<div class="card card-light ">
				
		<div class="card-header">
			
			<h3 class="card-title">{{trans('allow-login-logs')}}</h3>
		</div>
		
		<div class="card-body" v-if="!loading">
			
			<div class="row">
				
				<div class="col-md-9">

					<span> <i class="fas fa-bell"></i> &nbsp;{{trans('get_alert_unrecognized_logins')}}</span>
				</div>
				
				<div class="col-md-3">

					<button v-if="!isEnabled && !updating" type="button" class="btn" :class="[panel === 'client' ? 'btn-custom' : 'btn-primary', 'float-end']" :style="btnStyle" @click="toggleSwitch(1)">

						<i class="fas fa-toggle-on"></i> {{trans('turn_on')}}

					</button>

					<button v-if="isEnabled && !updating" type="button" class="btn btn-secondary float-end" @click="toggleSwitch(0)">

						<i class="fas fa-toggle-off"></i> {{trans('turn_off')}}

					</button>

					<button v-if="updating" type="button" class="btn" :class="[panel === 'client' ? 'btn-custom' : 'btn-primary', 'float-end disabled']" :style="btnStyle">
						
						{{trans('updating')}}
					</button>
				</div>
			</div>	
		</div>
	</div>
</template>
<script>

	import axios from 'axios';

	import { errorHandler, successHandler } from '../../../helpers/responseHandler'

	export default {

		name: 'login-logs-toggle',

		props: { 

			userId: { type : [String, Number], default : ''},

			alertName : { type : String, default : 'edit_agent_profile'},

			btnStyle : { type : Object, default : ()=>{}},

			panel : { type : String, default : 'agent' }
		},

		data() {
			
			return {
				
				isEnabled : false,
				
				updating : false,

				loading : false
			}
		},

		beforeMount() {

			this.getStatus()
		},

		methods: {

			getStatus() {

				this.loading = true;

				axios.get( '/api/login/info/'+this.userId).then(res =>{
					
					this.loading = false;

					this.isEnabled = res.data.data.allow_unrecognized_login;
					
				}).catch(err=>{
					
					this.loading = false;

					this.isEnabled=false;
				});
			},
			
			toggleSwitch(toggle) {
				
				this.updating=true
				
				axios.post('/api/allow-login-logs/'+this.userId+'/'+toggle).then(res =>{
						  
					this.isEnabled = toggle
					
					this.updating=false
					
					successHandler(res, this.alertName);
				
				}).catch(err=>{
					
					this.updating=false
					
					errorHandler(err,this.alertName);
				});
			}
		}
	};
</script>