<template>

	<div class="col-sm-12">

		<div>

			<div class="row" v-if="!hasDataPopulated || loading">

				<reuse-loader :duration="4000"></reuse-loader>
			</div>

			<alert componentName="priority-create-edit"/>

			<faveo-box v-if="hasDataPopulated" :title="trans(page_title)">

				<div class="row" v-focus-first-input>

					<text-field :label="trans('priority')" :value="name"
						type="text"
						name="name"
						:onChange="onChange" :placehold="lang('enter_a_value')"
                      :keyupListener="triggerEvent"
						classname="col-sm-6"
						:required="true"
						>
					</text-field>

					<div class="col-sm-3 form-group" :class="{'has-error' : showErr || colorErr}">

						<label class="pb-1"> {{ trans('priority_color') }} <span class="text-danger">*</span> </label>

						<color-picker :color="priority_color" name="priority_color" :onColor="onChange" :showError="showErr" :colorError="colorErr" />

						<div v-if="showErr" class="error-block is-danger">{{trans('this_field_is_required')}}</div>

						<span v-if="!showErr && colorErr" class="is-danger">{{colorErr}}</span>
					</div>

                    <radio-button :options="lang(publicOptions)" :label="trans('visibility')" name="ispublic" :value="ispublic"
                                  :onChange="onChange" classname="form-group col-sm-3" >

                    </radio-button>
				</div>

				<div class="row">

					<text-field :label="trans('priority_desc')" :value="priority_desc"
						type="textarea"
						name="priority_desc"
						:onChange="onChange" :placehold="lang('enter_a_value')"
                      :keyupListener="triggerEvent"
						classname="col-sm-12"
						:required="true"
						>
					</text-field>
				</div>

				<div class="row">

					<div class="col-sm-12 mt-2">

						<label class="label_align" name="is_default">

							<input class="checkbox_align" type="checkbox" name="is_default" v-model="is_default" :keyupListener="triggerEvent"
								:disabled="priorityId && defaultPriority ? true : false">
								&nbsp;{{trans('make-default-priority')}}
						</label>
					</div>
				</div>

                <template #actions>

                    <div class="card-footer">

                        <button id="submit_btn" class="btn btn-primary" @click="onSubmit()">

                            <i :class="iconClass"></i> {{trans(btnName)}}
                        </button>
                    </div>
                </template>
			</faveo-box>
		</div>
	</div>
</template>

<script>

	import axios from 'axios'

	import {successHandler,errorHandler} from "../../../../helpers/responseHandler";
	
	import  { getIdFromUrl } from '../../../../helpers/extraLogics';
	
	import { validatePrioritySettings } from "../../../../helpers/validator/priorityValidation.js";
    import ColorPicker from "../../../MiniComponent/FormField/ColorPicker.vue";
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";

	export default {

		name : 'priority-create-edit',

		description  : 'Priority create edit page',

		data(){

			return {

				page_title : 'create_ticket_priority',

				iconClass : 'fas fa-save',

				btnName : 'save',

				hasDataPopulated : false,

				loading : false,

				// essentials
				priorityId : '',

				name : '',

				priority_desc : '',

				priority_color : '',

				ispublic : 1,

				publicOptions:[{name:'public',value:1},{name:'private',value:0}],

				is_default : false,

				showErr : false,

				colorErr : '',

				defaultPriority : ''
			}
		},

		beforeMount(){

			const path = window.location.pathname

			this.getValues(path);
		},

		watch : {

			priority_color(newValue, oldValue) {

				if(newValue == '#') {

					this.priority_color = '';
				}

				return this.priority_color
			},

			is_default(newValue, oldValue) {

				this.status = newValue ? 1 : this.status;
			}
		},

		methods : {

			getValues(path){

				const priorityId = getIdFromUrl(path)

				if(path.indexOf('edit') >= 0){

					this.page_title = 'edit_priority'

					this.iconClass = 'fas fa-sync'

					this.btnName = 'update'

					this.hasDataPopulated = false

					this.getInitialValues(priorityId)

				} else {

					this.loading = false;

					this.hasDataPopulated = true;
				}
			},

			getInitialValues(id){

				this.loading = true

				axios.get('/api/priority/'+id).then(res=>{

					this.loading = false;

					this.hasDataPopulated = true

					let priorityData = res.data.data.priority;

					this.priorityId = priorityData.id;

					this.defaultPriority = priorityData.is_default;

					this.updateStatesWithData(priorityData)

				}).catch(error=>{

					this.loading = false;

					errorHandler(error,'priority-create-edit')
				});
			},

			updateStatesWithData(data){

				const self = this;

				const stateData = this.$data;

				Object.keys(data).map(key => {

					if (stateData.hasOwnProperty(key)) {

						self[key] = data[key];
					}
				});
			},

			isValid(){

				const { errors, isValid } = validatePrioritySettings(this.$data);

				return isValid;
			},

			onChange(value, name) {

				this[name] = value;
			},

			onSubmit(){

				this.priority_color = this.priority_color == '#' ? '' : this.priority_color;

				this.showErr = !this.priority_color ? true : false;

				if(this.isValid()){

					this.loading = true

					let data = {};

					data['name'] = this.name;

					data['priority_desc'] = this.priority_desc;

					data['priority_color'] = this.priority_color;

					data['ispublic'] = this.ispublic ? 1 : 0;

					data['is_default'] = this.is_default ? 1 : 0;

					let apiUrl =  '/api/priority';

					if(this.page_title == 'edit_priority') {

						apiUrl = '/api/priority-edit/'+this.priorityId;

						data['_method'] = 'PATCH'
					}

					axios.post(apiUrl, data).then(res => {

						this.loading = false

						this.colorErr = '';

						successHandler(res,'priority-create-edit')

						if(!this.priorityId){

							setTimeout(()=>{

								this.$router.push({ name : 'Priority Index' })
							},3000);

						} else {

							this.getInitialValues(this.priorityId)
						}
					}).catch(err => {

						this.loading = false

						if(err.response.data.message && err.response.data.message['priority_color']){

							this.colorErr = err.response.data.message['priority_color'];
						}

						errorHandler(err,'priority-create-edit')
					});
				}
			},
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },
		},
		components  : {

			'text-field': TextField,

			'radio-button': RadioButton,

			'color-picker': ColorPicker,
		}
	};
</script>
<style scoped>

.checkbox_align{
  top: -4px!important;
}

.label_align{
  font-weight: normal !important;
}

</style>
