<template>

	<div class="col-sm-12">

		<alert componentName="api-settings"></alert>

		<faveo-box :title="trans('api_settings')">

			<div class="row" v-if="!hasDataPopulated || loading">

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>

			<template v-if="hasDataPopulated">

				<div class="row">

					<radio-button :options="radioOptions" :label="trans('api')" name="api_enable" :value="api_enable" :onChange="onChange"
						classname="form-group col-sm-4">

					</radio-button>

					<radio-button :options="radioOptions" :label="trans('api_key_mandatory')" name="api_key_mandatory" :value="api_key_mandatory"
						:onChange="onChange" classname="form-group col-sm-4">

					</radio-button>

					<div class="col-sm-4 form-group">

						<label>{{trans('api_key')}}</label>&nbsp;<label v-if="api_key_mandatory" class="text-danger">*</label>

						<button class="btn btn-light float-end mb-1" id="random" @click="getRandomKey()">

							<i class="fas fa-key">&nbsp;&nbsp;</i>{{trans('generate_key')}}
						</button>

						<div :class="((showError && api_key_mandatory) || statusText)  ? 'has-error' : ''">

							<input type="text" class="form-control" name="api_key" v-model="api_key" @keyup.enter="triggerEvent" :placeholder="trans('enter_a_value')" >

							<a v-if="api_key" id="basic-addon" @click.prevent="onCopy()">

								<span v-tooltip="!copied ? trans('click-to-copy') : trans('clipboard-copy-message')"
									:class="copied ? 'fas fa-check text-success' : 'fa fa-clipboard'" id="eye">

								</span>
							</a>
						</div>

						<div v-if="statusText || (showError && api_key_mandatory)" class="error-block is-danger">{{ statusText || trans('this_field_is_required') }}</div>

					</div>
				</div>
			</template>

            <template #actions>

                <div class="card-footer">

                    <button class="btn btn-primary" @click="onSubmit()" :disabled="pageLoad">

                        <i class="fas fa-save"></i> {{trans('save')}}
                    </button>
                </div>
            </template>
		</faveo-box>

		<div class="row" v-if="pageLoad">

			<custom-loader :duration="4000"></custom-loader>
		</div>
	</div>
</template>

<script>

	import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

    import axios from 'axios'

	import copy from 'clipboard-copy';

    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";

	export default {

		name : 'api-settings',

		data () {

			return {

				api_enable : 1,

				api_key_mandatory : 1,

				api_key : '',

				radioOptions:[{name:'enable',value:1},{name:'disable',value:0}],

				loading : true,

				hasDataPopulated : false,

				pageLoad : false,

				copied: false,

				statusText : '',

				showError : false
			}
		},

		beforeMount(){

			this.getValues();
		},

		methods : {

			getRandomKey() {

				axios.get('/generate-api-key').then(res=>{

					this.api_key = res.data;

				}).catch(error=>{

					this.api_key = ''
				})
			},

			onCopy(){

				copy(this.api_key);

            this.copied = true;

            setTimeout(() => {

               this.copied = false;
            }, 5000)
			},

			getValues(id){

				axios.get('/api/admin/get-api-setting').then(res=>{

					this.loading = false;

					this.hasDataPopulated = true;

					let values = res.data.data;

					this.api_enable = values.api_enable;

					this.api_key_mandatory = values.api_key_mandatory;

					this.api_key = values.api_key;

				}).catch(error=>{

					errorHandler(error,'api-settings');

					this.loading = false;

					this.hasDataPopulated = true;
				});
			},

			onChange(value, name) {

				this[name] = value;
			},

			onSubmit() {

				this.showError = false;

				this.statusText = '';

				if (this.api_key_mandatory && !this.api_key) {

					this.showError = true;

					return;
				}

				this.pageLoad = true;

				const data = {};

				data['api_enable'] = this.api_enable;

				data['api_key_mandatory'] = this.api_key_mandatory;

				data['api_key'] = this.api_key;

				axios.post('/api/admin/update-api-setting', data).then(res => {

					this.statusText = '';

					this.pageLoad = false;

					successHandler(res,'api-settings');

					this.getValues()

				}).catch(err => {

					this.statusText = err.response.data.message['api_key'];

					this.pageLoad = false;

					errorHandler(err,'api-settings');
				});
			},
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },
		},

		components : {

			'radio-button': RadioButton
		}
	};
</script>

<style scoped>

	#eye{
		float: right;margin-left: -25px;margin-top: -25px;
		margin-right: 6px;
		position: relative;
		z-index: 2;
		color: black;
        cursor: pointer;
	}
	#random{
		font-size: 13px !important;
	}
	.status-text{
		top: -10px;
    position: relative;
	}
</style>
