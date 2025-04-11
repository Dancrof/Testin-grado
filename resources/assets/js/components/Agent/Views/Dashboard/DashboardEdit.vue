<template>

  <div>

    <custom-loader :duration="4000" v-if="loading" />

    <div v-if="moduleLoad" class="row">

      <reuse-loader :animation-duration="4000" :size="60"/>
    </div>

    <template v-else>

      <div class="row mb-3 text-end">

        <div class="col-sm-12">

          <button type="button" class="btn btn-primary btn-md" @click="updateDashboardWidgets">

            <i class="fas fa-sync-alt"></i> {{ trans('update') }}
          </button>

          <button type="button" class="btn btn-secondary btn-md" @click="closeEditDash">

            <i class="fas fa-times"></i> {{ trans('cancel') }}
          </button>
        </div>
      </div>

      <div class="row">

        <div class="col-sm-9">

          <div class="card card-light">

            <div class="card-header">

              <h3 class="card-title">{{ trans('added_widgets') }}</h3>
            </div>

            <div class="card-body">

              <div class="row">

                <div :class="{'col-sm-12': item.key === 'ticket-widget', 'col-sm-6': item.key !== 'ticket-widget'}" v-for="item in dashboardWidgetData.filter(obj => obj.display && obj.key !== 'dashboard-charts')" :key="item.id">

                  <div class="card card-light shadow">

                    <div class="card-header">

                      <h3 class="card-title">{{ trans(item.label) }}</h3>

                      <div class="card-tools">

                        <span v-tooltip="trans('cache')" class="badge text-bg-primary">{{item.cache}}</span>

                          <button type="button" class="btn btn-tool" @click="onEdit(item)" v-tooltip="trans('edit')">

                              <i class="fas fa-pencil-alt"></i>
                          </button>

                        <button type="button" class="btn btn-tool" @click="onRemove(item)" v-tooltip="trans('remove')">

                          <i class="fas fa-times"></i>
                        </button>
                      </div>
                    </div>

                    <div class="card-body mh-255">

                      <template v-if="item.key === 'ticket-widget'">

                        <div class="row">

                          <div class="col-sm-4" v-for="item in widgetsData" :key="item.id">
                            <div class="info-box pe-0">

                                  <span v-if="item.icon_class" class="info-box-icon" :class="item.is_default ? 'bg-light box-icon-color' : ''" :style="{background: item.icon_color}">

                                      <i :class="item.icon_class"></i>
                                  </span>

                              <div class="info-box-content" v-tooltip="item.key + ': ' + item.value">

                                <span class="info-box-text">{{subString(item.key, 50)}}</span>

                                <span class="info-box-number">{{item.value}}</span>
                              </div>

                              <button v-if="item.is_deletable && item.widget_type !== 'Service Desk'" type="button" v-tooltip="trans('delete')" @click="onChartRemove(item.id, 'widget')"  class="btn btn-tool">
                                <i class="fas fa-trash-alt trash-color mb-5"></i>
                              </button>

                            </div>
                          </div>
                        </div>
                      </template>

                      <template v-if="item.key === 'immediate-action'">

                        <ul class="products-list product-list-in-card ps-2 pe-2">

							<li class="item" v-for="(ticket, index) in dashConfig.immediateTickets" :key="index">

								<span class="fw-500">
									<a :href="ticket.link">{{ trans(ticket.label) }}</a>
							  	</span> &nbsp;

								<span v-if="ticket.overdue" class="badge text-bg-danger">{{ trans('overdue') }}</span>

								<div class="float-end">
									<div class="float-end">
										<div class="text-danger">{{ trans('due_at') }}: <span>{{ trans(ticket.dueTime) }}</span></div>
									</div>
								</div>
							</li>
                        </ul>
                      </template>

                      <template v-if="item.key === 'todo'">

                        <span>→</span>&nbsp;<i>{{ trans('todo_msg') }}</i>
                      </template>

                      <template v-if="item.key === 'recent-activities'">

                        <ul class="products-list product-list-in-card">

							<li class="item" v-for="(activity, index) in dashConfig.recentActivities" :key="index">

								<div class="product-img">
									<faveo-image-element :source-url="activity.imageUrl" :classes="['img-circle img-30']" :id="'recent_img' + (index + 1)"/>
								</div>

								<div class="fw-400">
									<div class="row">
										<div class="col-sm-2">{{ trans(activity.agentType) }}</div>
										<div class="col-sm-7">
											<a href="javascript:;"><span>{{ trans(activity.message) }}</span></a>
										</div>
										<div class="col-md-3">
											<span class="float-end">{{ activity.date }}</span>
										</div>
									</div>
								</div>
							</li>
                        </ul>
                      </template>

                      <template v-if="item.key === 'agent-summary'">

                        <ul class="products-list product-list-in-card">

							<li class="item" v-for="(agent, index) in dashConfig.agentSummary" :key="index">
								<div class="row">
									<div class="col-md-2">
										<div class="product-img">
											<faveo-image-element :source-url="agent.imageUrl" :classes="['img-circle']" :id="'agent_sum_img' + (index + 1)"/>
										</div>
									</div>
									<div class="col-sm-4 mt-2">
										<span><a href="javascript:;">{{ trans(agent.name) }}</a></span>
									</div>
									<div class="float-end col-md-6">
										<div>
											<div style="padding: 0.3rem;">{{ trans('reopened_tickets') }}:
												<span class="float-end"><a href="javascript:;" class="badge text-bg-blue">{{ agent.reopenedTickets }}</a></span>
											</div>
											<div style="padding: 0.3rem;">{{ trans('overdue-tickets') }}:
												<span class="float-end"><a href="javascript:;" class="badge text-bg-blue">{{ agent.overdueTickets }}</a></span>
											</div>
										</div>
									</div>
								</div>
							</li>
                        </ul>
                      </template>

                      <template v-if="item.key === 'department-summary'">

						  <div class="card card-widget widget-user-2 shadow-0" v-for="(department, index) in dashConfig.departmentSummaries" :key="index">
							  <div class="widget-user-header p-0">
								  <h3 class="widget-user-username widget-name">{{ trans(department.name) }}</h3>
							  </div>
							  <div class="card-footer p-0">
								  <ul class="nav flex-column bg-white">
									  <li class="nav-item">
										  <a class="nav-link">{{ trans(department.summaryMessage) }}
											  <span class="float-end">
												  <a href="javascript:;" class="badge text-bg-blue">{{ department.badgeValue }}</a>
											  </span>
										  </a>
									  </li>
								  </ul>
							  </div>
						  </div>
                      </template>

                      <template v-if="item.key === 'agent-performance'">

						  <div class="col-md-12" v-for="(performance, index) in dashConfig.agentPerformances" :key="index">
							  <div class="progress-group">
								  <span class="progress-text">{{ trans(performance.message) }}</span>
								  <span class="progress-number"><b>&nbsp;{{ performance.percent }}%</b></span>
								  <div class="progress sm">
									  <div class="progress-bar progress-bar-red" :style="{ width: performance.percent + '%' }"></div>
								  </div>
							  </div>
						  </div>
                      </template>

                      <template v-if="item.key === 'system-summary'">

						  <div v-for="(summary, index) in dashConfig.systemAnalysisSummaries" :key="index">
							  <div class="system-analysis-list">
								  <ul class="nav flex-column">
									  <li>{{ trans(summary.message) }}
										  <span class="float-end badge text-bg-blue">{{ summary.value }}</span>
									  </li>
								  </ul>
							  </div>
						  </div>
                      </template>
                    </div>
                  </div>
                </div>

                  <template v-if="dashboardCharts && dashboardCharts.length">

                      <div class="col-sm-6" v-for="item in dashboardCharts">

                          <div class="card card-light shadow">

                              <div class="card-header">

                                  <h3 class="card-title">{{ trans(item.name) }}</h3>

                                  <div class="card-tools">

                                      <span v-tooltip="trans('cache')" class="badge text-bg-primary">{{item.cache}}</span>

                                      <button type="button" class="btn btn-tool" @click="onEdit(item,'chart')" v-tooltip="trans('edit')">

                                          <i class="fas fa-pencil-alt"></i>
                                      </button>

                                      <button type="button" class="btn btn-tool" @click="onChartRemove(item.id, 'charts')" v-tooltip="trans('remove')">

                                          <i class="fas fa-times"></i>
                                      </button>
                                  </div>
                              </div>

                              <div class="card-body h-255">

                                  <Bar v-if="item.chart_type === 'bar_chart'" :id="item.id+'my-chart-id'" :options="dashConfig.barChartOptions" :data="dashConfig.barChartData"/>

                                  <Doughnut v-if="item.chart_type === 'donut_chart'" :id="item.id+'my-chart-id'" :data="dashConfig.donutChartData" :options="dashConfig.donutChartOptions" />
                              </div>
                          </div>
                      </div>
                  </template>
              </div>
            </div>
          </div>
        </div>
        <div class="col-sm-3">

          <div class="card card-light">

            <div class="card-header">

              <h3 class="card-title">{{ trans('add_widgets') }}</h3>
            </div>

            <div class="card-body">

              <div class="row" v-if="dashboardWidgetData.length">

                <div class="col-sm-12" v-for="widget in dashboardWidgetData.filter(obj => (obj.key === 'dashboard-charts' || !obj.display) ? true : false)" :key="widget.id">

                  <a href="javascript:;" @mouseenter="onMouseEnter(widget)" @mouseleave="onMouseLeave(widget)"
                    @click="onAdd(widget)" @dragstart.prevent>

                    <div class="info-box bg-light">

                      <div class="info-box-content">

                      <span class="info-box-text text-center text-muted">

                        <template v-if="!widget.showOnlyIcon">{{ trans(widget.label) }}</template>

                        <template v-else> <i class="fas fa-plus fa-2x"></i></template>
                      </span>
                      </div>
                    </div>
                  </a>
                </div>
              </div>

              <modal v-if="showModal" :showModal="true" :onClose="onClose" :containerStyle="{ width: selectedWidget.key === 'dashboard-charts' ? '800px' : '500px' }">

                <template #title>

                  <h4 class="modal-title">{{trans(modalTitle)}} {{ trans('dashboard-charts') }}</h4>
                </template>

                <template #fields>

					<template v-if="selectedWidget.key === 'dashboard-charts'">

						<div class="row">

							<div class="col-sm-4">

								<div class="form-group">

									<label>Chart Type</label>

									<select v-model="chart_type" class="form-control">

										<option value="bar_chart">Bar Chart</option>

										<option value="donut_chart">Donut Chart</option>
									</select>
								</div>
							</div>

							<div class="col-sm-4">

								<div class="form-group">

									<label>{{trans('dashboard_cache')}}</label><tool-tip :message="trans('widget-cache')" size="medium"></tool-tip>

									<input type="number" min="0" v-model="cache" max="999" class="form-control"
									   @input="onInput"
									   @keypress="checkValue"
									   @paste="onPaste">
								</div>
							</div>

							<dynamic-select name="module" classname="col-sm-4" apiEndpoint="/service-desk/api/modules/list?dashboard=1" :label="trans('module')"
											:value="module" :multiple="false" :onChange="onChange" :required="true">

							</dynamic-select>
						</div>

						<div class="row">

							<template v-if="module">

								<template v-if="optionsLoading">

									<reuse-loader :animation-duration="4000" :size="30"/>
								</template>

								<template v-else>

                  <dynamic-select
                      name="tickets_view" classname="col-sm-4"
                      :elements="viewOptionStatus" :multiple="false"
                      :label="module.name + ' ' + trans('view')"
                      :value="tickets_view" :onChange="onChange"
                      :required=true
                  />



									<static-select :label="trans('categorized_by')" :elements="categoryOptions"
									   :hideEmptySelect="true"
									   name="category"
									   :onChange="onChange"
									   :value="category"
									   classname="col-sm-3"
									   bind-value-key="column_name"
									   :required="true" >
									</static-select>

                  <text-field v-if="!optionsLoading" :label="trans('widget_label')" :value="name" type="text" name="name"
                              :onChange="onChange" classname="col-sm-5" :required="true"/>
								</template>
							</template>


						</div>
					</template>

                  	<div v-else class="row widget-interval" v-focus-first-input>

						<label>{{trans('dashboard_cache')}}</label><tool-tip :message="trans('widget-cache')" size="medium"></tool-tip>

                      <div class="input-group">

                        <input type="number" min="0" v-model="cache" max="999" class="form-control"
                               @input="onInput"
                               @keypress="checkValue"
                               @paste="onPaste">

                            <div type="button" class="btn btn-light disabled cursor-default">

                              {{trans('minutes')}}
                            </div>
                      </div>
                  	</div>
                </template>

                <template #controls>

                  <button v-if="selectedWidget.key === 'dashboard-charts'" type="button" @click="onSaveChart" class="btn btn-primary">

                    <i class="fas fa-check"></i> &nbsp;{{trans(modalTitle)}}
                  </button>

					<button v-else type="button" @click="onSave" class="btn btn-primary">

                    <i class="fas fa-check"></i> &nbsp;{{trans(modalTitle)}}
                  </button>
                </template>
              </modal>
            </div>
          </div>
        </div>
      </div>
    </template>

	  <transition name="modal">

		  <BasicDeleteModal v-if="showDeleteModal" :onClose="onChartModalClose" :from="from" :showModal="showDeleteModal" :deleteUrl="deleteUrl"
		  	:updateList="getAddedCharts" alert="dashboard-page">

		  </BasicDeleteModal>
	  </transition>
  </div>
</template>

<script>

  import axios from "axios";

  import {errorHandler, successHandler} from "../../../../helpers/responseHandler";

  import TextField from "../../../MiniComponent/FormField/TextField.vue";

  import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";

  import NumberField from "../../../MiniComponent/FormField/NumberField.vue";

  import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";

  import {widgetChartValidation} from "../../../../helpers/validator/widgetChartValidation";

  import { Bar, Doughnut } from 'vue-chartjs'
  import { Chart as ChartJS, Title, ArcElement, Tooltip, Legend, BarElement, CategoryScale, LinearScale, Colors } from 'chart.js'

  ChartJS.register(Title, ArcElement, Tooltip, Legend, BarElement, CategoryScale, LinearScale, Colors)

  import * as dashboardConfig from "./dashboardEditConfig.js";

  import BasicDeleteModal from "../../../Common/BasicDeleteModal.vue";

  import ToolTip from "../../../MiniComponent/ToolTip.vue";

  import {getSubStringValue} from "../../../../helpers/extraLogics";

  export default {

    name : 'dashboard-edit',

  	components: {
		TextField,
		DynamicSelect,
		NumberField,
		StaticSelect,
		Bar,
		Doughnut,
		BasicDeleteModal,
    ToolTip,
	},

    props : {

      closeEditDash : { type : Function }
    },

	  computed: {
		  dashConfig() {
			  return { ...dashboardConfig };
		  }
	  },

    data () {

      return {

        dashboardWidget : '',

        dashboardWidgetData : [],

        moduleLoad : false,

        showModal : false,

        selectedWidget : '',

        cache : 0,

        loading : false,

        modalTitle : '',

		  chart_type: 'bar_chart',

		  module: '',

		  name: '',

		  category: '',

		  tickets_view: '',

		  viewOptions :[],

		  categoryOptions :[],

		  optionsLoading: false,

		  dashboardCharts: [],

		  showDeleteModal: false,

		  deleteUrl: "",

		  editChartId: "",

      viewOptionStatus: [],

        widgetsData: [],

        deleteWidgetKey: false,

        showWidgetDeleteModal: false,

        from: '',

        refreshWidgets : false

      }
    },

    beforeMount() {

      this.getEditableWidgets();

	  this.getAddedCharts();
    },

    created() {

      window.emitter.on('reloadTopWidgets',()=>this.refreshWidgets = true);
    },

    beforeUnmount() {
      this.closeEditDash(true);
    },

    watch: {

      refreshWidgets(newValue, oldValue){

        if(newValue === true){
          this.getDashboardWidgets();
        }
        this.refreshWidgets = false;
      }
    },

    methods : {

		onChartRemove(value, from) {

      let widgetId = null

      this.showDeleteModal = true;

      this.from = from;

      if(from === 'widget') {
        widgetId = value.startsWith('filter_') ? value.replace('filter_', '') : value;
      }

      this.deleteUrl = from === 'charts' ? "/service-desk/api/delete/dashboard-widgets/"+value : '/api/agent/ticket-filter/'+widgetId;
		},

		onChartModalClose() {

			this.showDeleteModal = false;

			this.deleteUrl = "";

			this.resetChartData();
		},

		isValid() {

			const { errors, isValid } = widgetChartValidation(this.$data);

			return isValid;
		},

		onSaveChart() {

			if(this.isValid()) {

				this.loading = true;

				let data = {};

				const { assigned, only_assigned, only_unassigned, status_id } = this.viewOptions.find(obj => obj.status_options === this.tickets_view);

				data['module_id'] = this.module.id;
				data['status_id'] = status_id;
				data['categorized_by'] = this.category;
				data['assigned'] = assigned;
				data['chart_type'] = this.chart_type;
				data['only_assigned'] = only_assigned;
				data['only_unassigned'] = only_unassigned;
				data['cache'] = this.cache ? parseInt(this.cache) : 0;
				data['name'] = this.name;
        data['dashboard_module'] = this.dashboardWidgetData.find((obj => obj.key === 'dashboard-charts'))

				if(this.editChartId) { data['id'] = this.editChartId; }

				axios.post('/service-desk/api/store/chart',data).then(res=>{

					this.loading = false;

					this.showModal = false;

					this.getAddedCharts();

					this.resetChartData();

					successHandler(res,'dashboard-page');

				}).catch(err=>{

					errorHandler(err,'dashboard-page');

					this.loading = false;
				});
			}
		},

		resetChartData() {
			this.chart_type = 'bar_chart';
			this.module = '';
			this.name = '';
			this.category = '';
			this.tickets_view = '';
			this.editChartId = "";
		},

		getAddedCharts() {

			axios.get('/service-desk/api/get/dashboard-charts').then(res=>{

				this.dashboardCharts = res.data.data;

			}).catch(err=>{

				this.dashboardCharts = [];
			})
		},

		onChange(value, name) {

			this[name] = value || '';

			if(name === 'module') {

				if(value) {

					this.getCategoryAndOptions(value.id, '');

					this.tickets_view = "";

					this.category = "";

				} else {

					this.viewOptions = [];

					this.categoryOptions = [];

					this.name = "";
				}
			}

			if(name === 'category' || name === 'tickets_view') {

          this.name = this.viewOptions.find(obj => obj.status_options === this.tickets_view).status_options + ' by ' + this.categoryOptions.find(obj => obj.column_name === this.category).name;

			}
		},

		getCategoryAndOptions(data, action ) {

			this.optionsLoading = true;

      let id = action === 'edit' ? data.module_id : data;

			axios.get('/service-desk/api/widget-options/list/'+id).then(res=>{

				const { options, categorizedBy } = res.data.data;

				this.viewOptions = options;
				this.categoryOptions = categorizedBy;

        this.viewOptionStatus = this.viewOptions.map(option => option.status_options);

          if(action === 'edit'){

            let matchingOption = this.viewOptions.find(obj =>
                (obj.status_id === data.status_id) &&
                (obj.assigned === data.assigned) &&
                (obj.only_assigned === data.only_assigned) &&
                (obj.only_unassigned === data.only_unassigned)
            );

            this.tickets_view = matchingOption.status_options;
            this.category = data.categorized_by;

          }else{
            this.tickets_view = options[0].status_options;
            this.category = categorizedBy[0].column_name;
          }
        const selectedViewOption = this.viewOptions.find(obj => obj.status_options === this.tickets_view);
        const selectedCategoryOption = this.categoryOptions.find(obj => obj.column_name === this.category);

				this.name = this.name || `${selectedViewOption.status_options} by ${selectedCategoryOption.name}`;

				this.optionsLoading = false;

				this.$store.dispatch('unsetValidationError');

			}).catch(err=>{

				this.viewOptions = [];

				this.categoryOptions = [];

				this.optionsLoading = false;
			})
		},

      updateDashboardWidgets(from) {

        this.loading = true;

        let data = {};

        data['module_id'] = this.dashboardWidget.id;

        data['sub_module'] = this.dashboardWidgetData.filter(item => item.key !== 'dashboard-charts').map((obj) => ({
          id:obj.id,
          display: obj.display ? 1 : 0,
          cache: obj.display ? parseInt(obj.cache) : 0,
        }));

        axios.post('/update/sub-module',data).then(res=>{

          this.loading = false;

		  this.closeEditDash(true);

          successHandler(res,'dashboard-page');

        }).catch(err=>{

          errorHandler(err,'dashboard-page');

          this.loading = false;
        });
      },

      onInput() {

        if (this.cache.toString().length <= 3) {

          return true;

        } else {

          this.cache = this.cache.toString().substring(0, this.cache.toString().length - 1);
        }
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

      onSave() {

        this.showModal = false;

        this.selectedWidget.display = true;

        this.selectedWidget['cache'] = this.cache;
      },

      onRemove(item) {

        item.display = false;

        item.cache = 0;
      },

      onAdd(item) {

        this.cache = 0;

        this.selectedWidget = item;

        if (item.key === 'ticket-widget') {
            this.getDashboardWidgets();
        }

        if(item.key === 'dashboard-charts') {

            this.showModal = true;

            this.modalTitle = 'add';

        } else {

            this.onSave();
        }
      },

      onEdit(item, type = "") {

        this.cache = item.cache;

		this.selectedWidget = item;

		if(type === 'chart') {

			this.editChartId = item.id;

			this.chart_type = item.chart_type;

			this.module= item.module;

			this.name= item.name;

			this.getCategoryAndOptions(item,  'edit');

			this.selectedWidget['key'] = "dashboard-charts";

      this.selectedWidget.label = "dashboard-charts";
		}

        this.showModal = true;

        this.modalTitle = 'update';
      },

      onClose() {

        this.selectedWidget = '';

        this.resetChartData();

        this.showModal = false;
      },

      onMouseEnter(item) {

        item.showOnlyIcon = true;
      },

      onMouseLeave(item) {

        item.showOnlyIcon = false;
      },

      getEditableWidgets() {

        this.editDash = true;

        this.moduleLoad = true;

        axios.get('/api/modules').then(res=>{

          this.dashboardWidget = res.data.data.helpdesk.find(obj => obj['key'] == 'Dashboard');

          axios.get(this.dashboardWidget.key_url).then(res=>{

            this.dashboardWidgetData = res.data.message.map((sub) => ({
              ...sub,
              display: sub.display ? sub.display : false,
              cache: sub.cache ? sub.cache : 0,
              showOnlyIcon : false
            }));

            this.dashboardWidgetData.forEach(item => {
              if (item.key === 'ticket-widget' && item.display) {
                this.getDashboardWidgets();
              }
            });

            this.moduleLoad = false;

          }).catch(err=>{

            this.moduleLoad = false;

            this.editDash = false;
          });
        }).catch(err=>{

          this.moduleLoad = false;

          this.editDash = false;
        });
      },

      getDashboardWidgets() {

        axios.get('api/agent/dashboard-report/top-widget')
            .then(res => {
              this.widgetsData = res.data.data;
            })
            .catch(err => {
              errorHandler(err, 'dashboard-page');
            })
            .finally(() => {
              this.moduleLoad = false;
            })
      },

      subString(value,length){

        return getSubStringValue(value,length)
      }
    }
  }
</script>

<style scoped>

  .img-30 { width: 30px !important; height: 30px !important; }

 .mh-255 { min-height: 255px !important; }

 .shadow-0 { box-shadow: none !important; }

  .widget-name {
    margin-left: 0 !important;
    padding-bottom: 5px;
    font-size: 20px !important;
    border-bottom: 1px solid #dfdfdf;
  }

  .system-analysis-list {
    border-bottom: 1px solid #f4f4f4;
    padding: 10px;
  }

  .h-255 {
	  height: 255px;
  }

  .box-icon-color { color: #1f2d3db3 !important; }

  .info-box {
    min-height: 75px;
  }

  .info-box-without-icon {
    display: block;
    min-height: 75px;
    background: #FFFFFF;
    width: 100%;
    border-radius: 2px;
    margin-bottom: 15px;
  }

  .info-box-icon {
    color: #FFFFFF;
  }

  .info-box-content-without-icon {
    padding: 1rem;
  }

  #dark-text { color: #343a40 !important; }


  .info-box .btn-tool {
    display: none;
  }

  .info-box:hover .btn-tool {
    display: block;
  }

  .delete-icon{
    margin-top: -60px;
    margin-right: -10px;
  }

  .trash-color{
    color: #a3a2a2;
  }

  .trash-color:hover{
    color: black !important;
  }

  .info-box-content{
    overflow: hidden !important;
  }

  .cursor-default{
    cursor: default !important;
  }

  .widget-interval>label {
    flex-shrink: 0;
    width: auto;
    padding-right: 0;
  }

  .widget-interval>span {
    flex-shrink: 0;
    width: auto;
    padding-left: 0;
  }

</style>