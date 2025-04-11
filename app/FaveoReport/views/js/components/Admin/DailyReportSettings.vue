<template>

	<div class="col-sm-12">

		<alert componentName="daily-report-settings"></alert>

		<div class="row">

			<div class="col-sm-4">

				<div class="card">

					<div class="card-header p_18">

						<h3 class="card-title">{{trans('select_widgets')}}</h3>
					</div>
				</div>

				<draggable
					tag="div"
					:group="{ name: 'ticket_components', pull: 'clone', put: false }"
					class="draggable-list"
					:list="ticket_components"
					:animation="200"
					itemKey="id"
					:clone="onClone">

					<template #item="{element, index}">

						<draggable-widgets
							:ticket="element"
							:key="element.id">

						</draggable-widgets>
					</template>
				</draggable>
			</div>

			<div class="col-sm-8">

				<div class="card">

					<div class="card-header">

						<h3 class="card-title mt-1">{{trans('preview_of_daily_report')}}</h3>

						<div class="card-tools">

							<button type="button" class="btn btn-primary btn-sm" @click="onSend()">

								<i class="fas fa-save"></i> {{trans('save')}}
							</button>

              <button v-if="loading" type="button" class="btn btn-tool rotating" data-card-widget="refresh">

                <i class="fas fa-sync-alt"></i>
              </button>
						</div>
					</div>

					<div class="card-body">

						<modal v-if="showNameModal" :showModal="true" :onClose="onClose" :showCloseBtn="true">

			                <template #title>

			                   	<h4 class="modal-title">{{trans('edit_report_name')}}</h4>
			               	</template>

			                <template #fields>

		                      	<div class="row" v-focus-first-input>

									<text-field :label="trans('report_name')" type="text" :value="report_name" name="report_name"
										class="col-sm-12" :labelStyle="labelStyle"
										:onChange="onChange" :placehold="lang('enter_a_value')">

									</text-field>
								</div>
		                  	</template>

		                  	<template #controls>

		                    	<button type="button" @click= "onSave(report_name)" class="btn btn-primary">

		                      		<i class="fas fa-check"></i> &nbsp;{{trans('proceed')}}
		                    	</button>
		                  	</template>
			            </modal>

            <table class="report_table_main">
              <tbody>
              <tr class="report_color_row">
                <td class="report_color_row_td">
                  <table>
                    <tbody>
                    <tr>
                      <td class="report_calendar">
                        <span>{{ month }}</span>
                      </td>

                      <td class="report_cal_name">
                        <h2 class="report_daily_head text-capitalize">
                          {{ report_full_name ? report_full_name : trans('daily_reports') }}
                        </h2>
                      </td>

                      <td class="report_cal_edit">
                        <button class="btn btn-sm btn-light" v-tooltip="trans('edit_report_name')" @click="showNameModal = true">
                          <i class="fas fa-edit"></i>
                        </button>
                      </td>
                    </tr>

                    <tr>
                      <td class="report_calendar_date">
                        <span>{{ date }}</span>
                      </td>
                      <td><h3 class="report_calendar_day">{{ day }}</h3></td>
                    </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
              </tbody>
            </table>

            <!-- Move div outside tbody -->
            <div class="report_table_pad">
              <table class="report_table">
                <tbody>
                <tr>
                  <td class="report_owner">
                    <h5 class="report_owner_wish">
                      {{ trans('greetings') }},
                      <b>XXXXXXXXXXX YYYYYYYYY</b>
                    </h5>
                  </td>
                </tr>
                </tbody>
              </table>

              <draggable
                  tag="div"
                  group="ticket_components"
                  class="draggable-list"
                  :list="dragged_elements"
                  :animation="200"
                  itemKey="id"
              >
                <template #item="{ element, index }">
                  <dragged-widgets :ticket="element" :key="element.id" :removeItem="removeItem" />
                </template>
              </draggable>
            </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>

	import Draggable from "vuedraggable";

	import DraggableWidgets from "./DraggableWidgets.vue";

	import DraggedWidgets from "./DraggedWidgets.vue";

	import {errorHandler,successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";

	import {validateDailyReportSettings} from "../../helpers/validator/dailyReportRules";

	import axios from 'axios';

	import TextField from "../../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";

	export default {

		name : 'daily-report-settings',

		data() {

			return {

				ticket_components : [],

				dragged_elements : [],

				loading : false,

				existData : '',

				report_name : '',

				labelStyle : { display : 'none' },

				date : '',

				day : '',

				month : '',

				showNameModal : false,

        		report_full_name : ''
			};
		},

		mounted() {

			const months = ["January","February","March","April","May","June","July","August","September","October","November","December"];

			const days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];

			const d = new Date();

			this.month = months[d.getMonth()];

			this.day = days[d.getDay()];

			this.date = d.getDate();

			this.loadData();
		},

		methods: {

      onClose () {

        this.showNameModal = false;

        this.report_name = this.report_full_name;

        if(!this.report_name) {

          this.report_name = 'Daily Report';
        }
      },

		 	onSave(value) {

         this.report_full_name = value;

        if(!this.report_name) {

          this.report_name = 'Daily Report';
        }

		 		if(this.isValid()) {

		 			this.showNameModal = false;
		 		}
		 	},

		 	onChange(value, name) {

				this[name] = value;
			},

		 	removeItem(value) {

				// get index of object
				let removeIndex = this.dragged_elements.map(item=> item.id).indexOf(value.id);

				// remove object
				this.dragged_elements.splice(removeIndex, 1);
		 	},

		 	onClone(data) {

		 		if(!this.dragged_elements.map(a=>a.id).includes(data.id)){

			 		return data;
		 		}
		 	},

			loadData() {

				this.loading = true;

				Promise.all([this.loadTicketComponents(),this.loadExistData()]).then((values)=>{

					[this.ticket_components,this.existData] = values;

					this.dragged_elements = this.existData.components;

					this.report_name = this.existData.name ? this.existData.name : 'Daily Report';

          this.report_full_name = this.report_name;

					this.loading = false;

				}).catch(err=>{

					this.loading = false;

					errorHandler(err,'daily-report-settings')
				})
			},

			loadTicketComponents() {

				return axios.get('/get/admin/daily-report/ticket-components-widgets').then(res=> res.data.data.components);
			},

			loadExistData() {

				return axios.get('/get/admin/daily-report').then(res=> res.data.data);
			},

			isValid(){

		        const { errors, isValid } = validateDailyReportSettings(this.$data);

		        return isValid;
		    },

			onSend() {

				if(this.isValid()) {

					let formattedElems = [];

					for(let i in this.dragged_elements) {

						formattedElems.push({ component_id : this.dragged_elements[i].id, order : parseInt(i)+1})
					}

					this.loading = true;

					let obj = {};

					obj['report_id'] = this.existData.id;

					obj['name'] = this.report_name ? this.report_name : 'Daily Report';

					obj['component_ids'] = formattedElems;

					axios.post('/api/admin/daily-report/createOrUpdateReport',obj).then(res=>{

						this.loading = false;

						successHandler(res,'daily-report-settings');

						this.loadData();

					}).catch(err=>{

						this.loading = false;

						errorHandler(err,'daily-report-settings')

					})
				}
			}
		},

		components: {

			Draggable,

			DraggableWidgets,

			DraggedWidgets,

			'text-field' : TextField
		},
	}
</script>

<style scoped>

	.draggable-list { min-height: 300px;}

	.report_table { min-width:100%;background-color:#fff;border:1px solid #d4d7dc;margin-top:20px; }

	.report_owner { padding: 25px; }

	.report_owner_wish { text-align: center;font-weight: 400;margin-top: 5px; }

	.report_table_pad { padding: 10px;background: #f4f6f9; }

	.report_table_main { min-width:100%;background-color:#fff;border:1px solid #d4d7dc;margin-bottom: 20px; }

	.report_color_row { background-color: #3d9eed; }

	.report_color_row_td {padding:20px;}

	.report_calendar { text-align:center;text-transform:uppercase;border:1px solid #fff;background-color:#fff;width:10%; }

	.report_calendar span { font-weight:600;color:#3d9eed;font-size:12px;line-height:20px; }

	.report_daily_head { color:#fff;margin:0;font-size:22px;line-height:30px; margin-left: 15px; }

	.report_calendar_date { border:1px solid #fff;width:66px;text-align:center; }

	.report_calendar_date span { font-size:20px;color:#fff;font-weight:500!important; }

	.report_calendar_day { color:#fff;font-weight:400!important;margin:0;font-size:18px;line-height:30px;margin-left: 15px; }

	.p_18 { padding: 18px; }

	.report_cal_name { width: 60%; }

	.report_cal_edit { width: 1%; }

  @keyframes rotate {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  /* Apply the rotation animation when the button has a class of "rotating" */
  .btn-tool.rotating i {
    animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
  }
</style>