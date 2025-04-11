<template>

	<div class="col-sm-12">

		<alert componentName="health-alerts"></alert>

		<div class="row" v-if="updateLoad">

			<custom-loader :duration="4000"></custom-loader>
		</div>

		<div v-if="moduleLoad" class="row mt-5">

			<reuse-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
		</div>

		<template v-else>

			<div class="card card-light">

				<div class="card-header">

					<h3 class="card-title">{{ trans('alerts') }}</h3>

				</div>

				<div class="card-body">

					<div class="row">

						<div class="col-sm-12">

							<div class="row p-2">

								<table class="table border">

									<thead>

										<tr>

											<th>{{trans('title')}}</th>

											<th>{{trans('value')}}</th>

											<th>{{trans('action')}}</th>
										</tr>
									</thead>

									<tbody>

										<tr v-for="(alert,index) in alertData" :key="index">

                      <td>{{ trans(alert.check) }} <span class="health-tool" v-if="alert.type" :title="alert.type" v-tooltip="alert.type">
                      <i class="fas fa-question-circle tic-pop-i h-check"></i>
                       </span></td>

											<td class="d-flex">

												<input v-if="alert.field == 'number'" type="number" min="0" v-model="alert.value" max="999" class="form-control ml_3"

												   @keypress="checkValue"
												   @paste="onPaste" placeholder="1"
												   :disabled="!alert.display">&nbsp;

												<select v-if="alert.field == 'select'" name="alert-select" v-model="alert.value" class="form-control" :disabled="!alert.display">
													<template v-for="option in alert.option">
														<option :value="option">{{ option }}</option>
													</template>
												</select>
											</td>

											<td>

												<toggle v-model="alert.display" class="toggle-switch mt-2" />
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>

				<div class="card-footer" v-if="!updateLoad">

					<button class="btn btn-primary float-end" @click="updateAlerts(alertData)">

						<i class="fas fa-sync-alt"></i>&nbsp;{{trans('update')}}
					</button>
				</div>
			</div>
		</template>
	</div>
</template>

<script>

import {mapGetters} from "vuex";

import {errorHandler, successHandler} from "../../../../../resources/assets/js/helpers/responseHandler";

import Switch from "../../../../../resources/assets/js/components/MiniComponent/FormField/Switch.vue";

export default {

	name : 'health-alerts',

	data () {

		return {

			alertData : [],

			moduleLoad : false,

			updateLoad : false
		}
	},

	beforeMount() {

		this.getAlertData();
	},

	computed :{

		...mapGetters(['formattedTime'])
	},

	methods : {

		getAlertData() {

			this.moduleLoad = true;

			axios.get('/health/check/alerts').then(res=>{

				this.alertData = res.data.data;

				this.alertData.filter(obj => obj.field == 'number').forEach(obj => {
					let splitted = obj.value.split(' ');
					obj['value'] = splitted[0];
					obj['type'] = splitted[1]
				})

				this.moduleLoad = false;

			}).catch(err=>{

				this.moduleLoad = false;

			});
		},

		checkValue(evt) {

			evt = (evt) ? evt : window.event;

			let charCode = (evt.which) ? evt.which : evt.keyCode;

			if ((charCode > 31 && (charCode < 48 || charCode > 57))) {

				evt.preventDefault();;

			} else {

				return true;
			}
		},

		onPaste(evt) {

			evt = (evt) ? evt : window.event;

			evt.preventDefault();
		},

		updateAlerts(alert) {

			this.updateLoad = true;

			let data = {}

			data['alerts'] = alert.map((obj) => ({
				check_id : obj.id,
				value : obj.type ? (obj.value ? obj.value : 1) + ' ' + obj.type : obj.value,
				display : obj.display ? 1 : 0,
			}));

			axios.post('/api/health/alerts',data).then(res=>{

				successHandler(res,'health-alerts');

				this.updateLoad = false;

				this.getAlertData();

			}).catch(err=>{

				errorHandler(err,'health-alerts');

				this.updateLoad = false;
			});
		}
	},

	components : {

		"status-switch": Switch
	}
}
</script>

<style scoped>
	.ml_3 { margin-left: 3px; }
</style>

<style>
	.toggle-switch {
		--toggle-bg-on: #28a745;
		--toggle-border-on: #28a745;
		--toggle-bg-off: #d9534f;
		--toggle-border-off: #d9534f;
	}
	.toggle-off { opacity: 0.5; }
  .h-check{
    color:#3c8dbc
  }

  .health-tool{
    cursor: help;
  }
</style>