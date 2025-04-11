<template>
	
	<div class="col-sm-12">

    	<alert></alert>
	
		<div class="card card-light">

			<div class="card-header">
			
				<h3 class="card-title">{{trans('time-track-settings')}}</h3>
			</div>

			<div class="card-body">
				
				<div class="row" v-if="!hasDataPopulated || loading">

					<reuse-loader :animation-duration="4000" :size="60"/>
				</div>

				<template v-if="hasDataPopulated">
					
					<div class="row">
						<radio-button :options="radioOptions" :label="trans('timetype_visible')"
									  name="show_worktime_type_field"
									  :value="show_worktime_type_field"
									  :onChange="onChange" classname="form-group col-sm-4">

						</radio-button>

						<radio-button :options="radioOptions" :label="trans('make_timetype_required')"
									  name="require_worktime_type_field"
									  :value="require_worktime_type_field"
									  :onChange="onChange" classname="form-group col-sm-4" :disabled="typeDisable">

						</radio-button>
						<radio-button :options="radioOptions" :label="trans('worktime_field_required')"
									  name="require_thread_worktime"
									  :value="require_thread_worktime"
									  :onChange="onChange" classname="form-group col-sm-4" :hint="trans('require_thread_worktime_tooltip')">

						</radio-button>
					</div>
				</template>
				
			</div>

			<div class="card-footer">
				<checkbox v-if="hasDataPopulated" name="additional" :value="additional" :label="lang('timetrack_application_level')" :onChange="onChange" classname="col-sm-12"/>
				<button class="btn btn-primary" @click="onSubmit()">
					
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
	
	import axios from 'axios'

	import {errorHandler,successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
	import Switch from "../../../../../../resources/assets/js/components/MiniComponent/FormField/Switch.vue";
	import RadioButton from "../../../../../../resources/assets/js/components/MiniComponent/FormField/RadioButton.vue";
	import Checkbox from "../../../../../../resources/assets/js/components/MiniComponent/FormField/Checkbox.vue";
	
	export default {
	
		name:'timetrack-settings',

		beforeMount(){

			this.getInitialValues()
		},

		data:()=> ({

			additional:0,

			hasDataPopulated : false,

			loading : true,

			pageLoad : false,

			radioOptions:[{name:'yes',value:1},{name:'no',value:0}],

			require_thread_worktime : '',

			require_worktime_type_field : '',

			show_worktime_type_field : '',

			typeDisable : false
		}),

		methods:{
			
			getInitialValues(){
				
				axios.get('/time-track/get-settings').then(res=>{

					this.loading = false;

					this.hasDataPopulated = true;

					this.additional = res.data.data.additional ? 1 : 0;

					this.require_thread_worktime = res.data.data.require_thread_worktime ? 1 : 0;
					
					this.show_worktime_type_field = res.data.data.show_worktime_type_field ? 1 : 0;

					this.typeDisable = this.show_worktime_type_field ? false : true;
					
					this.require_worktime_type_field = res.data.data.require_worktime_type_field ? 1 : 0;
				
				}).catch(error=>{
					
					this.loading = false;

					this.hasDataPopulated = true;
				});
			},
		
			onChange(value,name){
				
				this[name]=value;

				if(name === 'show_worktime_type_field') {

					this.require_worktime_type_field = value ? this.require_worktime_type_field : 0;

					this.typeDisable = value ? false : true;
				}		
			},

			onSubmit() {

				this.pageLoad = true;
			
				const data = {};

				data['additional'] = this.additional ? 1 : 0;

				data['require_thread_worktime'] = this.require_thread_worktime;

				data['show_worktime_type_field'] = this.show_worktime_type_field ? 1 : 0;
				
				data['require_worktime_type_field'] = this.show_worktime_type_field ? this.require_worktime_type_field : 0;

				axios.post('/time-track', data).then(res => {

					this.pageLoad = false;
					
					successHandler(res);
					
					this.getInitialValues()
					
				}).catch(err => {

					this.pageLoad = false;
				
					errorHandler(err);
				});
			}
	
		},

		components:{
		
			'status-switch': Switch,

			'radio-button': RadioButton,

            checkbox: Checkbox,
		},
	};
</script>
