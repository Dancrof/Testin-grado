<template>

	<div class="col-sm-12">

		<div class="row" v-if="!hasDataPopulated || loading">

			<custom-loader :duration="4000"></custom-loader>
		</div>

		<alert componentName="source-create-edit"/>

		<faveo-box v-if="hasDataPopulated" :title="trans(page_title)">

			<div class="row" v-focus-first-input>

				<text-field :label="trans('name')" :value="name"
					type="text"
					name="name"
					:onChange="onChange" :placehold="lang('enter_a_value')"
					classname="col-sm-4"
                    :keyupListener="triggerEvent"
					:required="true"
					:disabled="isDisabled"
					>
				</text-field>

				<text-field :label="trans('display_as')" :value="display_as"
					type="text"
					name="display_as"
					:onChange="onChange" :placehold="lang('enter_a_value')"
                    :keyupListener="triggerEvent"
					classname="col-sm-4"
					:required="true"
					>
				</text-field>

				<dynamic-select name="icon" :label="trans('icon_class')"
					:value="icon" :onChange="onChange"
            	classname="col-sm-4" :elements="iconList"
            	:multiple="false" option-label="icon_class" :required="true" :clearable="icon ? true : false"
            >
          </dynamic-select>
			</div>

			<div class="row">

				<text-field :label="trans('description')" :value="description"
					type="textarea"
					name="description"
					:onChange="onChange" :placehold="lang('enter_a_value')"
                    :keyupListener="triggerEvent"
					classname="col-sm-12"
					:required="false"
					>
				</text-field>
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
</template>

<script>

	import axios from 'axios'

	import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
	
	import  { getIdFromUrl } from '../../../../helpers/extraLogics';
	
	import { validateSourceSettings } from "../../../../helpers/validator/sourceValidation.js";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {

		name : 'source-create-edit',

		description  : 'Source Create edit page',

		data(){

			return {

				page_title : 'create_source',

				iconClass : 'fas fa-save',

				btnName : 'save',

				hasDataPopulated : false,

				loading : false,

				// essentials
				source_id : '',

				name : '',

				display_as : '',

			  	description : '',

			  	icon : '',

			  	iconList: [],

			  	isDisabled : false
			}
		},

		beforeMount(){

			const path = window.location.pathname

			this.getValues(path);

			this.getIconList();
		},

		methods : {

        getIconList() {

         	axios.get('/json/icon-list.json').then((response) => {

	            this.iconList = response.data.data;

	        	}) .catch((error) => {

	            this.iconList = [];
	         })
	      },

			getValues(path){

				const sourceId = getIdFromUrl(path)

				if(path.indexOf('edit') >= 0){

					this.page_title = 'edit_source'

					this.iconClass = 'fas fa-sync'

					this.btnName = 'update'

					this.hasDataPopulated = false

					this.getInitialValues(sourceId)

				} else {

					this.loading = false;

					this.hasDataPopulated = true;
				}
			},

			getInitialValues(id){

				this.loading = true

				axios.get('/api/source/'+id).then(res=>{

					this.loading = false;

					this.hasDataPopulated = true

					let sourceData = res.data.data.source;

					this.source_id = sourceData.id;

					this.display_as = sourceData.value;

					this.icon = sourceData.css_class ? { icon_class : sourceData.css_class } : '';

					this.isDisabled = sourceData.is_default ? true : false;

					this.updateStatesWithData(sourceData)

				}).catch(error=>{

					this.loading = false;

					errorHandler(error,'source-create-edit')
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

				const { errors, isValid } = validateSourceSettings(this.$data);

				return isValid;
			},

			onChange(value, name) {

				this[name] = value ? value : '';
			},

			onSubmit(){

				if(this.isValid()){

					this.loading = true

					let data = {};

					data['name'] = this.name;

					data['display_as'] = this.display_as;

					data['description'] = this.description;

					data['icon'] = this.icon.icon_class;

					let apiUrl =  '/api/source';

					if(this.page_title == 'edit_source') {

						apiUrl = '/api/source/update/'+this.source_id;

						data['_method'] = 'PATCH'
					}

					axios.post(apiUrl, data).then(res => {

						this.loading = false

						successHandler(res,'source-create-edit')

						if(!this.source_id){

							setTimeout(()=>{
								this.$router.push({ name : 'Source Index' });
							},3000);

						} else {

							this.getInitialValues(this.source_id)
						}
					}).catch(err => {

						this.loading = false

						errorHandler(err,'source-create-edit')
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

			'dynamic-select': DynamicSelect,
		}
	};
</script>
