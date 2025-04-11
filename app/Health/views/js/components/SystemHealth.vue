<template>

	<div class="col-sm-12">

		<alert component-name="system-health"></alert>

		<template v-if="loading">

			<reuse-loader></reuse-loader>
		</template>

		<div class="row" v-else>

			<template v-for="data in this.healthData">

				<div class="col-md-4 col-sm-6 col-12">

					<div class="info-box">

						<span :class="'info-box-icon bg-'+data.bg_class"><i :class="data.icon"></i></span>

						<div class="info-box-content">

              <span class="info-box-number">{{ data.data.length }}</span>

							<span class="info-box-text">{{ trans(data.name) }}</span>
						</div>
					</div>

					<template v-if="data.data.length">

            <div :class="['card', 'card-' + data.bg_class + '-outline-left', {'collapsed-card': data['collapsed']}]">

							<div class="card-header border-0">

								<h3 class="card-title">

									<i :class="data.icon"></i>&nbsp;&nbsp;{{ trans(data.name) }}
								</h3>

								<div class="card-tools">

									<button type="button" class="btn btn-tool" data-lte-toggle="card-collapse" @click="data['collapsed'] = !data['collapsed']">
                    <i :class="data['collapsed'] ? 'fas fa-plus' : 'fas fa-minus'"></i>

									</button>
								</div>
							</div>

							<div class="card-body p-2" :class="data['collapsed'] ? 'd-none' : 'd-block'">

								<div class="card mb-2" v-for="item in data.data">

									<div class="card-body p-2">

										<h6>

                                            <b>{{ item.check }}</b>&nbsp;

                                            <a :href="item.tool_tip_action" target="_blank">

                                                <i class="fas fa-question-circle labelColor" v-tooltip="item.tool_tip_lang"></i>
                                            </a>
                                        </h6>

										<p :class="item.check == 'db_storage' ? 'health_trace' : ''" v-html="item.value"></p>

										<ul v-if="item.process">

											<li v-for="(value,key) in item.process">

												<p>{{ key }} <span v-html="value"></span></p>
											</li>
										</ul>

										<p v-if="item.info">
                                            {{ trans('click_to_check') }}

                                            <router-link to="/health-check/php-info"> {{ trans('php_info') }}</router-link>
                                        </p>

										<button v-if="item.columns && item.columns.length" class="btn btn-primary" type="button" @click="openView(item)">

											<i class="fas fa-eye"></i>&nbsp;{{ trans('view_status') }}
										</button>

                    <div v-if="item.action">
                      <button v-if="item.action" class="btn btn-primary" type="button" @click="markResolve(item.action, item.refresh ? item.refresh : '')">

                          <i class="fas fa-check"></i>&nbsp;{{ trans(item.label) }}
                      </button>
                    </div>
									</div>
								</div>
							</div>
						</div>
					</template>
				</div>
			</template>
		</div>

		<transition name="modal">
			<health-table-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :data="viewItem"></health-table-modal>
		</transition>
	</div>
</template>

<script>

import {errorHandler, successHandler} from "../../../../../resources/assets/js/helpers/responseHandler";
import HealthTableModal from "./HealthTableModal.vue";

	export default {

		name : 'system-health',

		data() {

			return {

				loading : false,

				healthData : [],

				viewItem : '',

				showModal : false,

				success : {
					name : 'successful-checks',
					icon : 'fas fa-check',
					bg_class : 'success',
					data : []
				},

				warning : {
					name : 'warnings',
					icon : 'fas fa-warning',
					bg_class : 'warning',
					data : []
				},

				danger : {
					name : 'needing-attention',
					icon : 'fas fa-times',
					bg_class : 'danger',
					data : []
				}
			}
		},

		beforeMount() {

			this.getData()
		},

		methods : {

			openView(value) {

				this.viewItem = value;

				this.showModal = true;
			},


			onClose(value) {

				this.viewItem = '';

				this.showModal = false;
			},

			getData() {

				this.loading = true;

				axios.get('/health/getServerChecks').then(res=>{

					this.success.data = res.data.data.Ok;

					this.warning.data = res.data.data.Warning;

					this.danger.data = res.data.data.Danger;

					this.healthData = [this.success,this.warning,this.danger];

					this.loading = false;

					this.getBillHealth();
					
				}).catch(err=>{

					this.healthData = [this.success,this.warning,this.danger];

					this.loading = false;
				})
			},

			getBillHealth() {

				axios.get('/health/getServerChecks/billing').then(res=>{

					this.success.data.push(...res.data.data.Ok);
					this.warning.data.push(...res.data.data.Warning);
					this.danger.data.push(...res.data.data.Danger);

					this.healthData = [this.success,this.warning,this.danger];

				}).catch(err=>{

					this.healthData = [this.success,this.warning,this.danger];

				})
			},

			markResolve(action, refresh) {

         if(refresh){
            setTimeout(()=>{
              window.location.reload();
            }, 1000)
         }

				this.loading = true;

				let url = action.replace(this.basePath(),'');

				axios.get(url).then(res=>{

					successHandler(res,'system-health');

					this.loading = false;

					this.getData();

				}).catch(err=>{

					errorHandler(err,'system-health');

					this.loading = false;
				})
			},
		},

		components : {

			'health-table-modal' : HealthTableModal
		}
	}
</script>

<style scoped>

	.card-success-outline-left { border-left: 3px solid #28a745 !important; background: #28a7451a; }

	.card-danger-outline-left { border-left: 3px solid #dc3545 !important; background: #dc354521; }

	.card-warning-outline-left { border-left: 3px solid #ffc107 !important; background: #ffc10726; }

	.health_trace {
		padding: 1rem;
		color: #fff;
		background-color: #000;
		height: 50vh;
		overflow: auto!important;
		line-height: 1.5!important;
	}
  .labelColor{
    color:#3c8dbc
  }
</style>