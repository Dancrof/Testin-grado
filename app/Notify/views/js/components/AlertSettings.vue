<template>
<div class="col-sm-12">
	<alert componentName="alert-settings"></alert>
	<custom-loader v-if="loading"/>
	<div class="card card-light" v-if="alerts">
    	<div class="card-header">
        	<h3 class="card-title">{{trans('alerts')}}</h3>
    	</div>
    	<!-- /.box-header -->
    	<div class="card-body">
            <div class="row">
            	<div class="col-md-12 form-group">
            		<table class="table table-sm" style="text-align:center;">
						<tbody>
							<tr v-for="(alert, name) in alerts" class="align-middle">
								<td style="vertical-align:middle; width: 5%">
									<status-switch  :name="name" :value="checkAlertIsSet(alert.associates)"
							            classname="btn-tool" :onChange="onChange">
          							</status-switch>
								</td>
								<td style="vertical-align:middle; width: 10%;">
									<table class="table table-borderless table-sm">
										<tr v-for="channel in alert.allowedChannels">
											<td style="vertical-align:middle;">
												<i :class="[channel.icon, checkAlertIsSet(alert.associates, channel.id) ? 'active' : 'inactive']" style="pointer-events: initial; cursor: pointer; color:" @click="toggleChannelForAlert(checkAlertIsSet(alert.associates, channel.id), alert.associates, channel.id)"></i>
											</td>
										</tr>
									</table>
								</td>
								<td style="vertical-align:middle; text-align:left;">
									{{trans(alert.name)}}&nbsp;<span v-tooltip="trans(alert.description)" class="alert-tooltip"><i class="fas fa-info-circle"></i></span>
								</td>
								<td>
									<table class="table table-borderless table-sm">
										<tr v-for="person in alert.associates" style="width=:100%">
											<td style="text-align:right;">
												<span v-tooltip="trans(person.description)">{{trans(person.name)}}</span>
												<!-- Admins -->
											</td>
											<td v-for="channel in alert.allowedChannels" style="width: 5%;text-align:left;">
												<i :class="[channel.icon, setAlerts[person.associate_id].includes(channel.id) ? 'active' : 'inactive']" aria-hidden="true" @click="toggleChannel(setAlerts[person.associate_id].includes(channel.id), person.associate_id, channel.id)" style="pointer-events: initial; cursor: pointer; color:"></i>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
            	</div>
	    	</div>
    	<!-- ./box-body -->
		</div>
		<div slot="actions" class="card-footer">
            <button type="button" id="submitter"  @click="submit" class="btn btn-primary" :disabled="isDisabled">
                <i class="fas fa-save" aria-hidden="true"></i> {{trans('submit')}}
            </button>
        </div>
	</div>
</div>
</template>
<script>
	import {errorHandler,successHandler} from "../../../../../resources/assets/js/helpers/responseHandler";
	import {getIdFromUrl} from "../../../../../resources/assets/js/helpers/extraLogics";
	import axios from 'axios'
	import Checkbox from "../../../../../resources/assets/js/components/MiniComponent/FormField/Checkbox.vue";
	import ToolTip from "../../../../../resources/assets/js/components/MiniComponent/ToolTip.vue";
	import Switch from "../../../../../resources/assets/js/components/MiniComponent/FormField/Switch.vue";

	export default {
        name : 'alert-settings',

        data()  {
        	return {
        		isDisabled : false,
        		loading : false,
        		alerts: null,
        		setAlerts: null
        	}
        },

        beforeMount() {
        	this.id = getIdFromUrl(window.location.pathname);
        	this.getAlerts();
        },

        methods: {
        	checkAlertIsSet(associates, channelId=0)
        	{
        		for(let i=0; i < associates.length; i++) {
        			let channels = this.setAlerts[associates[i].associate_id].join();
        			if(channels.includes(channelId)) {
        				return true;
        			} else if(channels != '' && !channelId) {
        				return true;
        			}
        		}

        		return false;
        	},
        	
        	onChange(value,name)
        	{
        		if(!value) {
        			this.toggleAllChannelsForAlert(name, true);
        		} else {
        			this.enableAllChannelsForAlert(name);
        		}
        	},

        	enableAllChannelsForAlert(name)
        	{
        		for(var i = 0; i < this.alerts[name].associates.length; i++) {
        			if(this.setAlerts[this.alerts[name].associates[i].associate_id].length > 0) {
        				return false;
        			}
        		}

        		this.toggleAllChannelsForAlert(name, false);
        	},

        	toggleAllChannelsForAlert(name, toEnable)
        	{
        		this.alerts[name].allowedChannels.forEach((channel)=>{
        			this.toggleChannelForAlert(toEnable, this.alerts[name].associates, channel.id);
        		})
        	},

			toggleChannelForAlert(isSet, associates, channel_id)
        	{
        		associates.forEach((associate)=>{
        			this.toggleChannel(isSet, associate.associate_id, channel_id);
        		})
        	},

        	toggleChannel(isSet, key, value)
        	{
        		let index = this.setAlerts[key].indexOf(value);
        		if (index > -1) {
    				this.setAlerts[key].splice(index, 1);
  				}
        		if(!isSet) {
        			this.setAlerts[key].push(value);        			
        		}
        	},

        	toggleLoaders(value) {
   				this.loading = value;
   				this.isDisabled = value;
   			},

        	updateSetAlerts()
        	{
        		let tmp = {}
        		for(const[key, alert] of Object.entries(this.alerts)){
        			alert.associates.forEach(function(associate){
        				let value = [];
        				let key = associate.associate_id;
        				if(associate.channels.length > 0) {
        					value = associate.channels;
        				}
       					tmp[key] = value;
        			})
        		}
        		this.setAlerts = tmp;
        	},

        	getAlerts() {
        		this.toggleLoaders(true);
        		axios.get('/notify/api/base-alerts').then(res => {
        			this.alerts = res.data.data
        			this.updateSetAlerts();
					this.toggleLoaders(false);
					successHandler(res,'alert-settings');
					
				}).catch(err => {
					this.toggleLoaders(false);
					errorHandler(err,'alert-settings');
				});
        	},

        	formatAlertFormData()
   			{
   				let m = [];
   				for (const [key, value] of Object.entries(this.setAlerts)) {
  					let tmp = {}
  					tmp.associate = key;
  					tmp.channels =[];
  					value.forEach(function(item, index){
  						tmp['channels'][index] = {'channel_id':item};
  					})
  					m.push(tmp);
				}
				return m;
   			},

   			submit() {
   				this.toggleLoaders(true);
   				let data = {
   					alerts : this.formatAlertFormData()
   				}
   				axios.patch('notify/api/base-alerts',data).
   				then(res => {
   					this.toggleLoaders(false);
					successHandler(res,'alert-settings');
				}).catch(err => {
					this.toggleLoaders(false);				
					errorHandler(err,'alert-settings');
				});
   			}
        },

        components: {
    		checkbox: Checkbox,
	    	"tool-tip": ToolTip,
		    "status-switch": Switch,
  		}
    }
</script>
<style scoped>
.active {
	color: #797A7A;
	/*color: #4A4A4B;*/
	/*color: #4CA746*/
}

.inactive {
	color: #C5C5C5
}

.alert-tooltip{
  cursor: help !important;
}
</style>