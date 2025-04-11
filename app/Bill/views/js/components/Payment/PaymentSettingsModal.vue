<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" 
		:containerStyle="containerStyle">
		
		<template #title>
			
			<h4 class="modal-title">{{lang(title)}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading">

				<div class="row" v-focus-first-input>

					<text-field :label="lang('name')" :value="name"
								type="text" name="name" :disabled="true"
								:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-5">

					</text-field>

					<text-field :label="lang('gateway_name')" :value="gateway_name"
								type="text" name="gateway_name" :disabled="true"
								:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-5">

					</text-field>

					<div class="col-sm-2">

						<label for="package" class="col-sm-12 control-label">{{lang('status')}}</label>

						<div class="col-sm-2">

							<status-switch name="status" :value="status" :onChange="onChange"
										   classname="pull-left" :bold="true">
							</status-switch>
						</div>
					</div>
				</div>

				<div class="row">

					<text-field v-for="(field,index) in extraTextFields" :key="field.index" :label="lang(field.name)" :value="field.value" type="text" :name="field.name"
								:onChange="onChange" :placehold="lang('enter_a_value')" classname="col-sm-5" :required="true"></text-field>

					<div v-for="(field,index) in extraSwitchFields" :key="field.index" class="col-sm-2">

						<label class="col-sm-12 control-label">{{lang(field.name)}}</label>

						<div class="col-sm-2">

							<status-switch :name="field.name" :value="field.value" :onChange="onChange"
										   classname="pull-left" :bold="true">
							</status-switch>
						</div>
					</div>
				</div>

				<div class="row">

					<div class="form-group col-md-12" id="align">

						<label class="label_align">

							<input class="checkbox_align" type="checkbox"
								   name="default" v-model="is_default" :disabled="checkDisabled">
							{{lang('make-default-payment-gateway')}}
						</label>
					</div>
				</div>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" color="#1d78ff" :size="size"/>
			</div>
		</template>
						
		<template #controls>
			
			<button type="button" id="submit_btn" @click="onSubmit()" class="btn btn-primary" :disabled="isDisabled">
					
				<i class="fas fa-sync" aria-hidden="true"></i> {{lang('update')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import {errorHandler,successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";

	import {validatePaymentGatewaySettings} from "../../helpers/validator/validatePaymentGatewayRules";
	
	import axios from 'axios'
	import TextField from "../../../../../../resources/assets/js/components/MiniComponent/FormField/TextField.vue";
	import DynamicSelect
		from "../../../../../../resources/assets/js/components/MiniComponent/FormField/DynamicSelect.vue";
	import Switch from "../../../../../../resources/assets/js/components/MiniComponent/FormField/Switch.vue";

	export default {
		
		name : 'settings-modal',

		description : 'Settings Modal component',

		props:{
	
			showModal:{type:Boolean,default:false},

			onClose:{type: Function},

			title : { type : String , default :''},

			data : { type : Object }
		},

		data:()=>({

			isDisabled:true,

			containerStyle:{ width:'800px' },

			loading:true,

			size: 60,

			status : 0,

			name : '',

			gateway_name : '',

			is_default: false,

			checkDisabled : false,

			extraTextFields : [],

			extraSwitchFields : [],

			extraFields : {}
		}),

		beforeMount() {

			this.getValues();
		},

		methods:{

			getValues(){
				let url = this.data.gateway_name ? '/bill/gateway/'+this.data.name+'/'+this.data.gateway_name : '/bill/gateway/'+this.data.name
				axios.get(url).then(res=>{

					this.loading = false;

					this.isDisabled = false;

					let result = res.data.data;

					this.name = result.name;

					this.gateway_name = result.gateway_name;
					
					this.status = result.status;

					this.is_default = result.is_default;

					this.checkDisabled = result.is_default  === 0 ? false : true

					this.extraFields = result.extra;

					for(var i in result.extra){
						if(result.extra[i].name !== 'testMode'){
							result.extra[i].value = result.extra[i].value==null ? '' : result.extra[i].value;
							this.extraTextFields.push(result.extra[i])
						} else {
							this.extraSwitchFields.push(result.extra[i])
						}
					}
					
				}).catch(error=>{

					this.loading = false;

					this.isDisabled = false;
				})
			},

		isValid(){
			
			const {errors, isValid} = validatePaymentGatewaySettings(this.$data)
			
			if(!isValid){
			
				return false
			}
			return true
		},

		onChange(value, name){
			
			this[name]= value;	

			for(var i in this.extraTextFields){
				if(this.extraTextFields[i].name === name ){
					this.extraTextFields[i].value = value
				} 
			}

			for(var i in this.extraSwitchFields){
				if(this.extraSwitchFields[i].name === name ){
					this.extraSwitchFields[i].value = value
				} 
			}
		},

		onSubmit(){

			if(this.isValid()){

				let extra = {};

				for ( var i in this.extraFields){
						extra[this.extraFields[i].name] = this.extraFields[i].value
				}
				
				this.loading = true
			
				this.isDisabled = true
				
				let data = {};

				data['name'] = this.name;

				if(this.gateway_name) {
					data['gateway_name'] = this.gateway_name;
				}			
				data['is_default'] = this.is_default === false || this.is_default === 0 ? 0 : 1 ;

				data['status'] = this.status == false ? 0 : 1 ;
				if(Object.keys(extra).length > 0){
					data['extra'] = extra;
				}
				axios.post('/bill/update/gateway',data).then(res=>{
			
					this.loading = false
			
					this.isDisabled = false
			
					successHandler(res,'dataTableModal');
			
					window.emitter.emit('refreshData');
					
					this.onClose();
				
				}).catch(err => {
				
					this.loading = false
				
					this.isDisabled = false
				
					errorHandler(err,'dataTableModal')
				})
			}
		},
	},

	components:{

		'text-field': TextField,

		"dynamic-select": DynamicSelect,

		'status-switch': Switch,
	}
};
</script>

<style type="text/css" scoped>
	.label_align {
		display: block; padding-left: 15px; text-indent: -15px; font-weight: normal !important; padding-top: 6px;
	}
	.checkbox_align {
		width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden;
	}
</style>