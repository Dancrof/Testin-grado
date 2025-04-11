<template>

	<div class="col-sm-12">

		<alert componentName="healthcheck-entry"></alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{lang('logs')}}</h3>
			</div>

			<div class="card-body">

				<div class="row">

					<template v-for="type in log_types" :key="type.name">

						<div class="col-md-2 col-sm-6">

							<div class="settingiconblue">

								<div class="settingdivblue" :class="type.name == selectedLogType ? 'selected_type' : ''">

									<a href="javascript:;" @click="showContent(type.name)">

									  	<span class="fa-stack fa-2x">

											<i :class="type.icon" class="fa-stack-1x"></i>
								  		</span>
									</a>
								</div>

								<div class="text-center text-sm" :class="type.name == selectedLogType ? 'fw_600' : ''">{{ trans(type.name) }}</div>
							</div>
						</div>
					</template>
				</div>

				<div class="row mt-3">

					<div class="col-sm-12">

						<div class="card card-light">

							<div class="card-header">

								<h3 class="card-title">

                  {{trans(selectedLogType)}} {{ trans('logs') }}
                  <span class="logs-tooltip">
                    <i class="fas fa-question-circle text-primary" v-tooltip="!loading ? logTooltip : ''"></i>
                  </span>
                 </h3>
							</div>

							<div class="card-body">

								<reuse-loader v-if="loading"></reuse-loader>

								<div v-else class="row">

									<div class="col-lg-9 col-sm-12">

										<div class="row">

											<template v-if="!loading && !logCategories.length">
												<div class="col-sm-12 text-center">
													<h3 class="log-h3">{{trans('no_logs_found')}}</h3>
												</div>
											</template>
											<template v-for="(category, index) in logCategories" :key="index">

												<div class="col-md-4 col-sm-6 col-12">

													<template v-if="selectedLogType == 'exception'">

														<a href="javascript:;" @click="showLogs(category)">

															<div class="info-box bg-gradient-light">

																<div class="info-box-content">

																	<span v-tooltip="category.name" class="info-box-text">{{ getSubString(category.name,25) }}</span>

																	<span class="info-box-number">

																		<span class="text-blue text-xl">{{ category.count }}</span>

																	</span>
																</div>
															</div>
														</a>
													</template>

													<div v-else class="info-box bg-gradient-light">

														<div class="info-box-content">

															<span v-tooltip="category.name" class="info-box-text">{{ getSubString(category.name,25) }}</span>

															<span class="info-box-number">

																<template v-if="selectedLogType == 'cron'">

																	<a href="javascript:;" @click="showLogs(category,'completed')">

																		<span class="text-blue text-xl">{{ category.completed }}</span>

																		<small>&nbsp;{{ trans('completed') }}</small>
																	</a>
																</template>

																<template v-if="selectedLogType == 'mail'">

																	<a href="javascript:;" @click="showLogs(category,'sent')">

																		<span class="text-blue text-xl">{{ category.sent }}</span>

																		<small>&nbsp;{{ trans('sent') }}</small>
																	</a>
																</template>
															</span>
														</div>

														<span class="info-box-icon custom-box-icon">

															<template v-if="selectedLogType == 'cron'">

																<a v-if="category.running" class="text-uppercase fw_600" href="javascript:;" @click="showLogs(category,'running')">

																	<span class="text-lg"> {{ category.running }} </span>
																	<small>&nbsp;{{ trans('running') }}</small>
																</a>
															</template>

															<template v-if="selectedLogType == 'mail'">

																<a v-if="category.accepted" class="text-uppercase fw_600" href="javascript:;" @click="showLogs(category,'accepted')">

																	<span class="text-lg"> {{ category.accepted }} </span>
																	<small>&nbsp;{{ trans('accepted') }}</small>
																</a>

																<a v-if="category.queued" class="text-uppercase fw_600" href="javascript:;" @click="showLogs(category,'queued')">

																	<span class="text-lg"> {{ category.queued }} </span>
																	<small>&nbsp;{{ trans('queued') }}</small>
																</a>

																<a v-if="category.blocked" class="text-uppercase fw_600" href="javascript:;" @click="showLogs(category,'blocked')">

																	<span class="text-lg"> {{ category.blocked }} </span>
																	<small>&nbsp;{{ trans('blocked') }}</small>
																</a>

                                <a v-if="category.rejected" class="text-uppercase fw_600" href="javascript:;" @click="showLogs(category,'rejected')">

																	<span class="text-lg"> {{ category.rejected }} </span>
																	<small>&nbsp;{{ trans('rejected') }}</small>
																</a>

																<a v-if="category['attachment-removed']" class="text-uppercase fw_600" href="javascript:;" @click="showLogs(category,'attachment-removed')">

																	<span class="text-lg"> {{ category['attachment-removed'] }} </span>
																	<small>&nbsp;{{ trans('attachment-removed') }}</small>
																</a>
															</template>

															<a class="text-uppercase text-danger fw_600" href="javascript:;" @click="showLogs(category,'failed')">

																<span class="text-lg"> {{ category.failed }} </span>
																<small>&nbsp;{{ trans('failed') }}</small>
															</a>
														</span>
													</div>
												</div>
											</template>
										</div>
									</div>

									<div class="col-lg-3 col-sm-5">

										<div class="card card-light">

											<div class="card-body">

												<date-picker :label="trans('date')" :value="date" type="date" name="date"
															 :onChange="onChange" :required="false" format="MM-DD-YYYY" classname="col-sm-12"
															 :clearable="false" :disabled="false" :inline="true"
															 :label-style="{ display : 'none' }" :checkManual="true">

												</date-picker>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="row mt-3" id="healthcheck-table-logs">

					<reuse-loader v-if="fetching"></reuse-loader>

					<table-view v-if="showTable && !fetching" :logType="selectedLogType" :category="selectedCategory"
						:status="status" :created_at="date">

					</table-view>

				</div>
			</div>
		</div>
	</div>
</template>

<script>

	import {errorHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
	import DateTimePicker
		from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DateTimePicker.vue";
	import moment from "moment";
	import TableView from "./TableView.vue";

	export default {

		name : 'healthcheck-entry',

		data () {

			return {

				log_types : [
					{ name : 'cron', icon : 'fas fa-hourglass' },
					{ name : 'exception', icon : 'fas fa-exclamation-triangle' },
					{ name : 'mail', icon : 'fas fa-envelope' }
				],

				selectedLogType : '',

				logTypeApi : '',

				loading : false,

				logCategories : [],

				date: new Date(),

				selectedCategory : '',

				fetching : false,

				status : '',

				showTable : false,

                logTooltip : ''
			}
		},

		beforeMount() {

			this.showContent('cron')
		},
        
        created() {
            
            window.emitter.on('retryLogActionPerformed',this.updateMailLog);
        },

		methods : {

			showLogs(value,type = '') {

				this.status = type;

				let x = document.getElementById("healthcheck-table-logs");

				setTimeout(() => {

					if(x){

						x.scrollIntoView({behavior: "smooth", block: "center", inline:"center"});
					}
				}, 2);

				this.fetching = true;

				this.selectedCategory = '';

				setTimeout(()=>{

					this.showTable = true;

					this.selectedCategory = value;

					this.fetching = false;

				},1000);
			},

			onChange(value,name) {

				if(moment(this.date).format('YYYY-MM-DD') != moment(value).format('YYYY-MM-DD')) {

					this.showTable = false;

					this[name] = value;

					this.loading = true;

					setTimeout(()=>{

						this.getLogCategories();

					},1000);
				}
			},
            
            updateMailLog(name = 'mail') {
                this.selectedCategory = '';
                
                this.selectedLogType = name;
                
                this.logTypeApi = '/api/automation/' + name;
                
                this.loading = true;
                
                setTimeout(()=>{
                    
                    this.getLogCategories();
                    
                },1000);
            },
            
			showContent(name) {

				this.showTable = false;

				this.selectedCategory = '';

				this.selectedLogType = name;

				this.logTypeApi = '/api/automation/' + name;

				this.loading = true;

				setTimeout(()=>{

					this.getLogCategories();

				},1000);
			},

			getLogCategories() {

				this.loading = true;

				axios.get(this.logTypeApi+'?created_at='+moment(this.date).format('YYYY-MM-DD')).then(res=>{

					this.logCategories = res.data.message;

                    this.logTooltip = res.data.data.tool_tip_lang

					this.loading = false;

				}).catch(err=>{

					errorHandler(err,'healthcheck-entry');

					this.loading = false;

					this.logCategories = [];
				})
			}
		},

		components : {

			'date-picker' : DateTimePicker,

			'table-view' : TableView
		}
	}
</script>

<style scoped>

	.custom-box-icon {
		align-items: end !important;
		font-size: unset !important;
		margin-bottom: 10px !important;
		display: grid !important;
		text-align: initial !important;
		justify-content: initial !important;
		width : 90px !important;
	}

	.selected_type { border-color: #3c8dbc !important; }

	.fw_600 { font-weight: 600  !important; }

	.log-h3{ padding-top: 8rem}

  .logs-tooltip{
    cursor: help;
  }
</style>