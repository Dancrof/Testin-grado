<template>
	
	<div class="col-sm-12">
		
		<alert componentName="error-debug"></alert>

		<div class="card card-light">
			
			<div class="card-header">
				
				<h3 class="card-title">{{trans('debug-options')}}</h3>
			</div>

			<div class="card-body">
				
				<div class="row" v-if="!hasDataPopulated || loading">

					<reuse-loader :animation-duration="4000" :size="60"/>
				</div>

				<template v-if="hasDataPopulated">

					<div class="row">
								
						<radio-button :options="modeOptions" :label="trans('debugging')" name="debug" :value="debug" :onChange="onChange" 
							classname="form-group col-sm-6">
								
						</radio-button>

						<radio-button :options="crashOptions" :label="trans('bugsnag-debugging')" name="bugsnag_reporting" :value="bugsnag_reporting" 
							:onChange="onChange" classname="form-group col-sm-6">
								
						</radio-button>
					</div>
				</template>
			</div>

			<div class="card-footer">

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

    import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

    import axios from 'axios'

    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";

	export default {

		name : 'error-debug',

		data () {

			return {

				crashOptions:[{name:'yes',value:1},{name:'no',value:0}],

				modeOptions:[{name:'enable',value:1},{name:'disable',value:0}],

				debug : '',

				bugsnag_reporting : '',

				loading : true,

				hasDataPopulated : false,

				pageLoad : false,
				
				valueChanged : false
			}
		},

		beforeMount(){

			this.getValues();
		},

		methods : {

			getValues(id){
				
				axios.get('/api/error-and-debugging-options').then(res=>{

					this.loading = false;

					this.hasDataPopulated = true;
					
					this.valueChanged = false;

					let values = res.data.data.options;

					this.debug = values.debug ? 1 : 0;

					this.bugsnag_reporting = values.bugsnag_reporting ? 1 : 0;

				}).catch(error=>{
					
					this.loading = false;

					this.hasDataPopulated = true;
				});
			},


			onChange(value, name) {

				this[name] = value;

				if(name == 'debug') {
					
					this.valueChanged = true;
				}
			},

			onSubmit() {
				
				this.$store.dispatch('unsetAlert');
				
				this.pageLoad = true;
		
				const data = {};

				data['debug'] = this.debug ? 1 : 0;

				data['bugsnag'] = this.bugsnag_reporting ? 1 : 0;

				axios.post('/api/error-and-debugging-options', data).then(res => {

					this.pageLoad = false;
					
					successHandler(res,'error-debug');
					
					this.getValues();
					
					if(this.valueChanged) {
						this.redirect('/admin/error-and-debugging-options')
					}
					
				}).catch(err => {

					this.pageLoad = false;
				
					errorHandler(err,'error-debug');
				});
			}
		},

		components : {

			'radio-button': RadioButton
		}
	};
</script>