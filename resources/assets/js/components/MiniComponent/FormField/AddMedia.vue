<template>

	<div class="col-12" :class="classname">
		
		<div class="form-group" id="reply_content_class">
		
			<div class="col-md-12 pe-0">
				
				<label :style="[show_error ? {'color': '#dc3545 '} : {'color': 'black'}]" for="Reply Content">
					{{ lang(labelName) }}
				</label>

				<span class="text-danger"> *</span>

        <file-manager-container :type="type"
            :page="page_name"
            v-on:filesChosen="getAttachmentInfo"
            v-on:fileChosenInlinePdf="addInlinePdf"
        >
          <template #templateBtn>
						<slot name="template"></slot>
					</template>
        </file-manager-container>

        <template v-if="loading">
          <custom-loader></custom-loader>
        </template>

				<tiny-editor :from="from" :value="description" type="text" :onChange="onChange" :name="name" :label="lang('description')"
					classname="" :required="false" :labelStyle="labelStyle" :lang="'en'" :page="page_name" :id="id">

				</tiny-editor>

				<span v-if="show_error" class="text-danger">{{lang('this_field_is_required')}}</span>

				<div v-if="page_name != 'kb'" id="file_details">

					<template v-for="(attachment,index) in attchments" :key="index">

						<div class="file-detail-box" v-if="attachment.disposition !== 'inline'" contenteditable='false'>

							<div class="file-details">

								{{attachment.name}} ({{bytesToKB(attachment.size ? attachment.size : attachment.file_size)}})

								<div class="float-end">

									<span @click='removeAttachment(index)' class="me-1 text-muted">

										<i class="fas fa-times pointer" v-tooltip="trans('remove')"></i>
									</span>
								</div>
							</div>
						</div>
					</template>
				</div>
			</div>
		</div>
	</div>
</template>

<script>

  import axios from 'axios';
  import {errorHandler} from '../../../helpers/responseHandler';

  const alertComponents = {
    kb: 'article-create', page: 'page-create',
    reply: 'inboxActions', internal_note: 'inboxActions',
    canned: 'canned-create-edit',
	problem_bulk_action: 'problem-associated-ticket-alert',
    task_comment: 'task-comment-threads'
  }

	export default {

		name : 'add-media',

		description : 'Media files uploader component',

		props : {

			description : { type : String, default : ''},

			classname : { type : String, default : 'p-0'},

			show_error : { type : Boolean, default : false},

			noDropdown : { type : Boolean, default : false},

			page_name : { type : String, default : ''},

			attachments : { type : Array, default : ()=>[]},

			inlineFile : { type : Array, default : ()=>[]},

			onAttach : { type : Function, default : ()=> { return true}},

			onInline : { type : Function, default : ()=> { return true}},

			onInput : { type : Function, default : ()=> { return true}},

			chunkApi : { type : String, default : '/chunk/upload'},

			filesApi : { type : String, default : '/media/files'},

			name : { type : String, default : 'description'},

			id : { type : String, default : '' },

      type : { type : String, default : '' },

      from : { type : String, default : '' },

      labelName: { type: String, default: 'description' }
		},

		data(){

			return {

				attchments : this.attachments,

				inline : this.inlineFile,

				labelStyle : { display : 'none' },

        loading: false
			}
		},

		watch : {

			attachments(newValue,oldValue){

				this.attchments = newValue;
			}
		},

		methods : {

      bytesToKB(sizeString) {
        if (!sizeString) return '0 KB';

        const size = parseFloat(sizeString);
        if (isNaN(size)) return 'Invalid size';

        return (size * 1024).toFixed(0) + ' KB'; // Convert MB to KB
      },

      async addInlinePdf(filesInfo) {
        let files = JSON.stringify(filesInfo.files)

        let anchorTags = '';

        this.loading = true;

        try {
          let params = { names: files, disk: filesInfo.disk };

          if (this.page_name === 'kb') {
            params.auth = false;
          }

          let response = await axios.get('file-manager/inline-files-info', {params});

          let data = response.data.data;

          data.forEach((file) => {
            anchorTags += `<a target='_blank' href=${file.link}>${file.name}</a><br>`
          });

          if (anchorTags) {
            this.getPDF(anchorTags)
          }

        } catch (e) {
          errorHandler(e, alertComponents[this.page_name]);
        } finally {
          this.loading = false;
        }

      },

      async getAttachmentInfo(filesInfo) {
        let files = JSON.stringify(filesInfo.files);
        this.loading = true;
        try {

          let params = { names: files, disk: filesInfo.disk };
          if (this.page_name === 'Kb') {
            params.auth = false;
          }
          let response = await axios.get('file-manager/files-info', {params})

          let data = response.data.data;

          data.forEach((file) => {
            this.attachments.push(file);
          })

        } catch (e) {
          await this.$store.dispatch('setAlert', {
            type: 'danger',
            message: this.lang('file-manager-modal-error-message'),
            component_name: 'inboxActions'
          })
        } finally {
          this.loading = false;
        }
      },

			onChange(value,name){

				this.onInput(value,name);
			},

			getPDF(value){

				this.onInput(this.description + '<br>' +value,this.name);
			},

			getAttachment(x){

				this.attchments.push(x);

				this.onAttach(this.attchments);
			},

			removeAttachment(x){

				this.attchments.splice(x,1);

				this.onAttach(this.attchments);
			},

			getInline(x){

				this.inline.push(x);

				this.onInline(this.inline);
			},
		}
	};
</script>

<style scoped>
	#hidden-attach{
		background-color: #f5f5f5;
		border: 1px solid #dcdcdc;
		font-weight: bold;
		margin-top:9px;
		overflow-y: hidden;
		padding: 4px 4px 4px 8px;
	}

	.close-icon{
		float:right;cursor: pointer;
	}
</style>
