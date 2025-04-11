<template>
	
	<div class="col-sm-12">
		
		<alert componentName="cron"/>

		<custom-loader v-if="pageLoad" :loadingSpeed="4000"></custom-loader>

		<div class="card card-light">
			
			<div class="card-header">
				
				<h3 class="card-title">{{trans('cron_settings')}}</h3>
			</div>

			<div class="card-body">
				
				<div class="row" v-if="!hasDataPopulated || loading">

					<reuse-loader :animation-duration="4000" :size="60"/>
				</div>

				<template v-if="hasDataPopulated">
					
					<div>
						
						<p>{{trans('copy-cron-command-description')}}</p>

						<div class="card p-4 bg-light">
							
							<div class="row">
								
								<div class="col-sm-2">
									
									<span class="fs-3">*&nbsp;&nbsp;*&nbsp;&nbsp;*&nbsp;&nbsp;*&nbsp;&nbsp;*</span>
								</div>

								<div class="col-sm-4">
									
									<select v-if="php_path != 'other'" class="form-control" v-model="php_path">
										
										<option disabled value="">{{trans('specify-php-executable')}}</option>
										
										<template v-for="(path, index) in phpPaths">
											
											<option :value="path">{{path}}</option>	
										</template>
										
										<option value="other">{{trans('other')}}</option>
									</select>

									<div v-if="php_path == 'other'" class="input-group">

										<input type="text" class="form-control" v-model="custom_php_path" :placeholder="trans('specify-php-executable')">
										
										<div class="input-group-append">
										
										  <a href="javascript:;" class="input-group-text" @click="clearPhpPath"><i class="fas fa-times"></i></a>
										
										</div>
									 </div>
								</div>
								
								<div class="col-sm-5"><span class="text-md">{{cron_path}}</span></div>
								
								<div class="col-sm-1">
									
									<span v-if="!copying" v-tooltip="trans('verify-and-copy-command')" @click="copyCommand()" class="pointer">

										<i class="far fa-clipboard fa-2x"></i>
									</span>

									<span v-if="copying" class="pointer"><i class="fas fa-circle-notch fa-spin fa-2x"></i></span>
					 
								</div>
							</div>
						</div>

						<div class="row">

							<template v-for="job in job_list">
								
								<div class="col-md-6">

									<div class="info-box">

									  <span class="info-box-icon bg-info"><i :class="job.icon"></i></span>

									  <div class="info-box-content">

										 <div class="row">
											  
											  <div class="col-md-7">

													<div class="form-group mt-4">

									  					<label name="share">

															<input class="checkbox_align" type="checkbox" name="active" id="active_job" v-model="job.active">
																&nbsp;{{trans(job.job)}}
														</label>

														<tool-tip :message="trans(job.job_info)" size="small"></tool-tip>
													</div>
											  </div>

											  <div v-if="job.active" class="col-md-5 mt-13" id="fetching-command-block">

												  	<div class="row">

                              <form-field-template :label="'select'" :labelStyle="labelStyle" :name="'job_list.'+job.job+'.value'" :classname="job.value =='dailyAt' ? 'col-sm-6' : 'col-sm-12'">

                                <select class="form-control col-sm-12" v-model="job.value">

                                <option value="">{{trans('select')}}</option>

                                <template v-for="time in timeOptions">

                                  <option v-if="isVisible(time.id, job.command)" :value="time.id">{{time.name}}</option>

                                </template>
                                </select>
                              </form-field-template>

														<div v-if="job.value =='dailyAt'" class="col-sm-6" id="fetching-daily-at">

															<form-field-template :label="'time'" :labelStyle="labelStyle" :name="'job_list.'+job.job+'.time'" classname="col-sm-12">

																<input class="form-control" placeholder="H:m" :name="'job_list.'+job.job+'.time'" type="text" v-model="job.daily_time">
															</form-field-template>
														</div>
													</div>
											  </div>
										 </div>
									  </div>
									</div>
			  					</div>
							</template>
						</div>
					</div>
				</template>
			</div>

			<div class="card-footer" v-if="hasDataPopulated">
				
				<button type="button" class="btn btn-primary" @click="onSubmit" :disabled="pageLoad">
					
					<i class="fas fa-save"></i> {{trans('save')}}
				</button>
			</div>
		</div>
	</div>
</template>

<script>

	import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

    import axios from 'axios'

	import {lang} from '../../../../helpers/extraLogics';
	
	import copy from 'clipboard-copy';

    import ToolTip from "../../../MiniComponent/ToolTip.vue";

    import FormFieldTemplate from "../../../MiniComponent/FormField/FormFieldTemplate.vue";

	export default {

		name : 'cron-settings',

		data () {

			return {

				loading : false,

				hasDataPopulated : false,

				pageLoad : false,

				job_list : '',

				exec_enabled : false,

				cron_path : '',

				phpPaths : '',

				php_path : '',

				labelStyle : { display : 'none' },

				custom_php_path : '',

				copying : false,

				timeOptions : []
			}
		},

		beforeMount() {

			this.getCronData();

			this.getTimeOptions();
		},

		methods : {

      isVisible(time, command){
        let commands = ['ticket:archive', 'archive:delete'];
        let times = ['everyFiveMinutes', 'everyMinute', 'everyThirtyMinutes', 'everyTenMinutes']
        return !((commands.includes(command) && times.includes(time)));
      },

			getTimeOptions() {

				axios.get('/api/dependency/cron-time-commands').then(res=>{

					this.timeOptions = res.data.data.cron_time_commands;
				}).catch(err=>{

					this.timeOptions = []
				})
			},

			getCronData() {

				this.loading = true;

				axios.get('/api/admin/get-cron-setting').then(res=>{

					this.cron_path = res.data.data.cron_path;

					this.exec_enabled = res.data.data.exec_enabled;

					if(!this.exec_enabled) {

						this.$store.dispatch('setAlert',{type:'warning', duration : 500000,
							message:lang('please_enable_php_exec_for_cronjob_check'), component_name : 'cron'})
					}

					this.job_list = res.data.data.job_list;

					this.job_list.map(obj=>{

						obj['active'] = obj.active ? true : false;

						if(obj.value.includes('dailyAt')) {

							obj['daily_time'] = obj.value.split(',')[obj.value.split(',').length - 1 ];

							obj['value'] = 'dailyAt';
						}
					})

					this.phpPaths = res.data.data.php_bin_paths;

					this.hasDataPopulated = true;

					this.loading = false;

				}).catch(err=>{

					this.hasDataPopulated = true;

					this.loading = false;
				})
			},

			clearPhpPath() {

				this.php_path = '';

				this.custom_php_path = '';
			},

			copyCommand() {

				this.copying = true;

				let data = {};

				data['path'] = this.custom_php_path ? this.custom_php_path : this.php_path;

				axios.post('/verify-php-path', data).then(res=>{

					copy('* * * * * ' + (this.custom_php_path ? this.custom_php_path : this.php_path) +' '+this.cron_path);

					this.copying = false;

					successHandler(res,'cron');

				}).catch(err=>{

					this.copying = false;

					errorHandler(err,'cron');
				})
			},

			onSubmit() {

				const data = {};

				let jobObj = {};

				this.job_list.forEach((obj)=>{

					jobObj[obj.job] = { active : obj.active ? 1 : 0, value : obj.active ? obj.value : ''}

					if(obj.value.includes('dailyAt') && obj.daily_time && obj.active) {
						
						jobObj[obj.job]['time'] = obj.daily_time;

					}
				});

				data['job_list'] = jobObj;

				data['_method'] = 'PATCH';

				this.pageLoad = true;
		
				axios.post('/api/admin/update-cron-setting', data).then(res => {

					this.pageLoad = false;
					
					successHandler(res,'cron');
					
					this.getCronData()

					this.$store.dispatch('unsetValidationError');
					
				}).catch(err => {

					this.pageLoad = false;
				
					errorHandler(err,'cron');
				});
			
			}
		},

		components : {

    		'tool-tip': ToolTip,

    		'form-field-template': FormFieldTemplate,
		}
	};
</script>

<style scoped>
	.label_align1 {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: 500 !important; padding-top: 6px;
	}
	.checkbox_align {
		width: 13px; height: 14px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -5px; overflow: hidden;
	}
	.mt-13 { margin-top: 13px;}

  .bg-info{
    color: #ffffff !important;
  }
</style>