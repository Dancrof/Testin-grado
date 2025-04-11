<template>

	<div class="container col-sm-12">

		<div class="row" v-if="!hasDataPopulated || loading">

			<custom-loader :duration="4000"></custom-loader>
		</div>

		<alert componentName="label-create-edit"/>

		<faveo-box v-if="hasDataPopulated" :title="trans(page_title)">

			<div class="row" v-focus-first-input>

				<text-field :hint="trans('label_hint')" :label="trans('title')" :value="title"
					type="text"
					name="title"
					:onChange="onChange" :placehold="lang('enter_a_value')"
                    :keyupListener="triggerEvent"
					classname="col-sm-6"
					:required="true"
          @input="onInput"
					>
				</text-field>

        <ul v-if="showDropdown" class="emoji-dropdown">
          <li v-for="(emoji, index) in filteredEmojis" :key="index" :class="{ active: index === selectedEmojiIndex }" @click="selectEmoji(emoji)">
            {{ emoji.native }} {{ emoji.short_names[0] }}
          </li>
        </ul>

				<number-field :label="trans('order')"
					:value="order"
					name="order"
					:onChange="onChange"
					classname="col-sm-6"
                      :keyupListener="triggerEvent"
					type="number"
					:required="true"
					placeholder="n"
					>
				</number-field>
			</div>

			<div class="row">

				<dynamic-select :label="trans('visibility')" :multiple="true"
					:elements="visibility_options" name="visible_to" :value="visible_to"
					classname="col-sm-4" :onChange="onChange" :required="true">
				</dynamic-select>

				<div class="col-sm-4 form-group" :class="{'has-error' : showErr || colorErr}">

					<label class="pb-1"> {{ trans('icon_color') }} <span class="text-danger"> *</span></label>

					<color-picker :color="color" name="color" :showError="showErr" :colorError="colorErr" :onColor="onChange"/>

					<div v-if="showErr" class="error-block is-danger">{{trans('this_field_is_required')}}</div>

					<span v-if="!showErr && colorErr" class="is-danger">{{colorErr}}</span>
				</div>

				<div class="col-sm-4" v-if="page_title == 'edit_label'">

					<label for="status"> {{ trans('status') }} </label>

					<status-switch name="status" :value="status" :onChange="onChange" :bold="true">

					</status-switch>
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
</template>

<script>

	import axios from 'axios'

	import {successHandler,errorHandler} from "../../../../helpers/responseHandler";
	
	import  { getIdFromUrl } from '../../../../helpers/extraLogics';
	
	import { validateLabelSettings } from "../../../../helpers/validator/labelValidation.js";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import NumberField from "../../../MiniComponent/FormField/NumberField.vue";
    import ColorPicker from "../../../MiniComponent/FormField/ColorPicker.vue";
    import Switch from "../../../MiniComponent/FormField/Switch.vue";
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
  import emojiData from 'emoji-datasource';

	export default {

		name : 'label-create-edit',

		description  : 'Label create edit page',

		data(){

			return {

				page_title : 'create_label',

				iconClass : 'fas fa-save',

				btnName : 'save',

				hasDataPopulated : false,

				loading : false,

				// essentials
				label_id : '',

				title : '',

				order : '',

				color : '',

				colorErr : '',

				status : 1,

				showErr : false,

				visibility_options:[{ id:"agents",name:this.trans('agents') },{ id : 'team_lead', name : this.trans('team_lead')}, { id : 'dept_mngr', name : this.trans('department_manager')}],

				visible_to: "",

        showDropdown: false,

        filteredEmojis: [],

        allEmojis: emojiData.map(emoji => ({
          unified: emoji.unified,
          short_names: emoji.short_names,
          native: String.fromCodePoint(...emoji.unified.split('-').map(u => '0x' + u))
        })),

        selectedEmojiIndex: 0
			}
		},

		beforeMount(){

			const path = window.location.pathname

			this.getValues(path);
		},

		methods : {

			getValues(path){

				const labelId = getIdFromUrl(path)

				if(path.indexOf('edit') >= 0){

					this.page_title = 'edit_label'

					this.iconClass = 'fas fa-sync'

					this.btnName = 'update'

					this.hasDataPopulated = false

					this.getInitialValues(labelId)

				} else {

					this.loading = false;

					this.hasDataPopulated = true;
				}
			},

			getInitialValues(id){

				this.loading = true

				axios.get('/api/label/'+id).then(res=>{

					this.loading = false;

					this.hasDataPopulated = true

					let labelData = res.data.data.label;

					this.label_id = labelData.id;

					this.updateStatesWithData(labelData);

					this.status = parseInt(this.status)

				}).catch(error=>{

					this.loading = false;

					errorHandler(error,'label-create-edit')
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

				let arr = this.visible_to.split(',');

				this.visible_to = this.visibility_options.filter(obj => arr.includes(obj.id)).map(obj => obj);
			},

			isValid(){

				const { errors, isValid } = validateLabelSettings(this.$data);

				return isValid;
			},

			onChange(value, name) {

				this[name] = value;
			},

			onSubmit(){

				this.color = this.color == '#' ? '' : this.color;

				this.showErr = !this.color ? true : false;

				if(this.isValid() && this.color){

					this.loading = true

					let data = {};

					data['title'] = this.title;

					data['order'] = parseInt(this.order);

					data['color'] = this.color;

					data['status'] = this.status ? 1 : 0;

					data['visible_to'] = this.visible_to.map(a => a.id);

					let apiUrl =  '/api/label';

					if(this.page_title == 'edit_label') {

						apiUrl = '/api/label-update/'+this.label_id;

						data['_method'] = 'PATCH'
					}

					axios.post(apiUrl, data).then(res => {

						this.$store.dispatch('unsetValidationError');

						this.colorErr = '';

						this.loading = false

						successHandler(res,'label-create-edit')

						if(!this.label_id){

							setTimeout(()=>{
								this.$router.push({ name : 'Labels Index' })
							},3000);

						} else {

							this.getInitialValues(this.label_id)
						}
					}).catch(err => {

						if(err.response.data.message && err.response.data.message['color']){

							this.colorErr = err.response.data.message['color'];
						}

						this.loading = false

						errorHandler(err,'label-create-edit')
					});
				}
			},
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          if (this.showDropdown && this.filteredEmojis.length > 0) {
            this.selectEmoji(this.filteredEmojis[this.selectedEmojiIndex]);
          } else {
            this.onSubmit();
          }
        }else if (key === 38) { // Up arrow
          if (this.showDropdown) {
            this.selectedEmojiIndex = (this.selectedEmojiIndex - 1 + this.filteredEmojis.length) % this.filteredEmojis.length;
          }
        } else if (key === 40) { // Down arrow
          if (this.showDropdown) {
            this.selectedEmojiIndex = (this.selectedEmojiIndex + 1) % this.filteredEmojis.length;
          }
        }
      },

      onInput(event) {
        const value = event.target.value;
        const lastWord = value.split(' ').pop();
        if (lastWord.startsWith(':')) {
          const searchTerm = lastWord.slice(1);
          this.filteredEmojis = this.allEmojis.filter(emoji =>
              emoji.short_names.some(name => name.startsWith(searchTerm))
          ).slice(0, 5);
          this.showDropdown = this.filteredEmojis.length > 0;
          this.selectedEmojiIndex = 0;
        } else {
          this.showDropdown = false;
        }
      },

      selectEmoji(emoji) {
        const words = this.title.split(' ');
        words.pop();
        words.push(`:${emoji.short_names[0]}:`);
        this.title = words.join(' ');
        this.showDropdown = false;
      },
		},
		components  : {

			"text-field": TextField,

			'number-field': NumberField,

			'color-picker': ColorPicker,

			'status-switch': Switch,

			'dynamic-select': DynamicSelect
		}
	};
</script>

<style>

.emoji-dropdown {
  list-style: none;
  padding: 0;
  margin: 0;
  border: 1px solid #ccc;
  max-height: 260px;
  min-width: 150px;
  overflow-y: auto;
  position: absolute;
  top: 125px;
  left: 30px;
  padding: 5px;
  border-radius: 5px;
  background: white;
  z-index: 1000;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Increased shadow */
}

.emoji-dropdown li {
  padding: 5px 10px;
  cursor: pointer;
}

.emoji-dropdown li:hover,
.emoji-dropdown li.active { /* Active class */
  background: #f0f0f0;
}
</style>
