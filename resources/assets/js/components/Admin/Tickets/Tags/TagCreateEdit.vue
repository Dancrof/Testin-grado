<template>

	<div class="col-sm-12">

		<div class="row" v-if="!hasDataPopulated || loading">

			<custom-loader :duration="4000"></custom-loader>
		</div>

		<alert componentName="tag-create-edit"/>

		<faveo-box v-if="hasDataPopulated" :title="trans(page_title)">

			<div class="row" v-focus-first-input>

				<text-field :hint="trans('tag_hint')" :label="trans('name')" :value="name"
					type="text"
					name="name"
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

				<dynamic-select :label="trans('visibility')" :multiple="true"
					:elements="visibility_options" name="visible_to" :value="visible_to"
					classname="col-sm-6" :onChange="onChange" :required="true">
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

	import {successHandler, errorHandler} from "../../../../helpers/responseHandler";

	import  { getIdFromUrl } from '../../../../helpers/extraLogics';
	
	import { validateTagSettings } from "../../../../helpers/validator/tagValidation.js";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
  import emojiData from 'emoji-datasource';

	export default {

		name : 'tag-create-edit',

		description  : 'Tag Create edit page',

		data(){

			return {

				page_title : 'create_tag',

				iconClass : 'fas fa-save',

				btnName : 'save',

				hasDataPopulated : false,

				loading : false,

				// essentials
				tag_id : '',

				name : '',

			  	description : '',

			  	visibility_options:[{ id:"all_users",name:"All Users" },{ id:"logged_in_users",name:"Logged in Users" },{ id:"agents",name:"Agents" }],

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

				const tagId = getIdFromUrl(path)

				if(path.indexOf('edit') >= 0){

					this.page_title = 'edit_tag'

					this.iconClass = 'fas fa-sync'

					this.btnName = 'update'

					this.hasDataPopulated = false

					this.getInitialValues(tagId)

				} else {

					this.loading = false;

					this.hasDataPopulated = true;
				}
			},

			getInitialValues(id){

				this.loading = true

				axios.get('/api/tag/'+id).then(res=>{

					this.loading = false;

					this.hasDataPopulated = true

					let tagData = res.data.data.tag;

					this.tag_id = tagData.id;

					this.updateStatesWithData(tagData)

				}).catch(error=>{

					this.loading = false;

					errorHandler(error,'tag-create-edit')
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

				const { errors, isValid } = validateTagSettings(this.$data);

				return isValid;
			},

			onChange(value, name) {

				this[name] = value;
			},

			onSubmit(){

				if(this.isValid()){

					this.loading = true

					let data = {};

					data['name'] = this.name;

					data['description'] = this.description;

					data['visible_to'] = this.visible_to.map(a => a.id);

					let apiUrl =  '/api/tag';

					if(this.page_title == 'edit_tag') {

						apiUrl = '/api/tag/update/'+this.tag_id;

						data['_method'] = 'PATCH'
					}

					axios.post(apiUrl, data).then(res => {

						this.loading = false

						successHandler(res,'tag-create-edit')

						if(!this.tag_id){

							setTimeout(()=>{
								this.$router.push({ name : 'Tags Index'});
							},3000);

						} else {

							this.getInitialValues(this.tag_id)
						}
					}).catch(err => {

						this.loading = false

						errorHandler(err,'tag-create-edit')
					});
				}
			},
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // Enter key
          if (this.showDropdown && this.filteredEmojis.length > 0) {
            this.selectEmoji(this.filteredEmojis[this.selectedEmojiIndex]);
          } else {
            this.onSubmit();
          }
        } else if (key === 38) { // Up arrow
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
        const words = this.name.split(' ');
        words.pop();
        words.push(`:${emoji.short_names[0]}:`);
        this.name = words.join(' ');
        this.showDropdown = false;
      },
		},
		components  : {

			'text-field': TextField,

			'dynamic-select': DynamicSelect
		}
	};
</script>

<style scoped>

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
