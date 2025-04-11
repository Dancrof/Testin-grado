<template>
	<div v-if="!showModal" class="modal-content fm-modal-upload mt-3" :key="counter">
		<div class="modal-header">
			<h5 class="modal-title">{{ lang1.modal.upload.title }}</h5>
			<button type="button" aria-label="Close" data-bs-dismiss="modal" v-on:click="hideModal"
              :class="['btn-close mb-3', { 'ms-auto': language !== 'ar', 'me-auto': language === 'ar' }]">
			</button>
		</div>
		<div class="modal-body">
			<div class="fm-btn-wrapper d-grid" v-show="!progressBar">
				<button type="button" class="btn btn-secondary btn-block">
					{{ lang1.btn.uploadSelect }}
				</button>
				<input type="file" multiple name="myfile" v-on:change="selectFiles($event)">
			</div>
			<div class="fm-upload-list" v-if="countFiles">
				<div class="d-flex justify-content-between"
					 v-for="(item, index) in newFiles"
					 v-bind:key="index">
					<div class="w-75 text-truncate fs-7">
						<i class="far" v-bind:class="mimeToIcon(item.type)"/>
						{{ item.name }} ({{ bytesToHuman(item.size) }})
					</div>
					<div class="text-end">
						<!-- {{ bytesToHuman(item.size) }} -->
						<i class="fas fa-times-circle" style="cursor: pointer;" @click="removeFileAtIndex(index)"></i>
					</div>
				</div>
				<hr>
				<div class="d-flex justify-content-between">
					<div>
						<strong>{{ lang1.modal.upload.selected }}</strong>
						{{ newFiles.length }}
					</div>
					<div class="text-end">
						<strong>{{ lang1.modal.upload.size }}</strong>
						{{ allFilesSize }}
					</div>
				</div>
				<hr>
				<div class="d-flex justify-content-between">
					<div>
						<strong>{{ lang1.modal.upload.ifExist }}</strong>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input pointer-cursor"
							   id="uploadRadio1"
							   type="radio"
							   name="uploadOptions"
							   value="0"
							   checked
							   v-model="overwrite">
						<label class="form-check-label" for="uploadRadio1">
							{{ lang1.modal.upload.skip }}
						</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input pointer-cursor"
							   id="uploadRadio2"
							   type="radio"
							   name="uploadOptions"
							   value="1"
							   checked
							   v-model="overwrite">
						<label class="form-check-label" for="uploadRadio2">
							{{ lang1.modal.upload.overwrite }}
						</label>
					</div>
				</div>
				<hr>
			</div>
			<div v-else><p>{{ lang1.modal.upload.noSelected }}</p></div>
			<div class="fm-upload-info">
				<!-- Progress Bar -->
				<div class="progress" v-show="countFiles">
					<div class="progress-bar progress-bar-striped bg-info" role="progressbar"
						 v-bind:aria-valuenow="progressBar"
						 aria-valuemin="0"
						 aria-valuemax="100"
						 v-bind:style="{width: progressBar + '%' }">
						{{ progressBar }}%
					</div>
				</div>
			</div>
		</div>
		<div class="modal-footer">
			<button class="btn" type="button"
					v-bind:class="[countFiles ? 'btn-info' : 'btn-light']"
					v-bind:disabled="!countFiles"
					v-on:click.once="uploadFiles">{{ lang1.btn.submit }}
			</button>
			<button class="btn btn-secondary" type="button" v-if="countFiles"
					v-bind:disabled="!countFiles"
					v-on:click="clearAllFiles">{{ lang1.btn.clearSelect }}
			</button>
			<button class="btn btn-light" type="button" v-on:click="hideModal()">{{ lang1.btn.cancel }}</button>
		</div>
	</div>

  <template v-if="showModal">
    <transition name="fm-clear">
      <div className="modal-content fm-modal-clear">
        <div className="modal-header">
          <h5 className="modal-title">{{lang1.clearall.clear_all_selection}}</h5>
          <button type="button" className="btn-close mb-3 ms-auto" aria-label="Close" @click="closeModal">
          </button>
        </div>
        <div className="modal-body">
          <p>{{lang1.clearall.delete_all}}</p>
        </div>
        <div className="modal-footer">
          <button className="btn btn-secondary" type="button" @click="deleteItems">{{lang1.btn.confirm}}
          </button>
          <button className="btn btn-light" type="button" @click="closeModal">{{ lang1.btn.cancel }}</button>
        </div>
      </div>
    </transition>
  </template>
</template>

<script>
import modal from '../mixins/modal';
import translate from '../../../mixins/translate';
import helper from '../../../mixins/helper';
import EventBus from "../../../emitter";

export default {
	name: 'Upload',
	mixins: [modal, translate, helper],
	data() {
		return {
			// selected files
			newFiles: [],

			// overwrite if exists
			overwrite: 0,

			counter : 0,

      showModal: false,

      language: '',
		};
	},

  mounted(){
    // Application Language
    this.language = sessionStorage.getItem('app_language');
  },

	computed: {

		maxFileUploadCount(){
			return this.$store.state.fm.settings.maxFileUploadCount
		},

		maxSingleFileSize(){
			return this.$store.state.fm.settings.maxSingleFileSize
		},

		maxPostSize(){
			return this.$store.state.fm.settings.maxPostSize
		},

		/**
		 * Progress bar value - %
		 * @returns {number}
		 */
		progressBar() {
			return this.$store.state.fm.messages.actionProgress;
		},

		/**
		 * Count of files selected for upload
		 * @returns {number}
		 */
		countFiles() {
			return this.newFiles.length;
		},

		/**
		 * Calculate the size of all files in human readable format
		 * @returns {*|string}
		 */
		allFilesSize() {
			return this.bytesToHuman(this.allFileSizeNumber);
		},

		/**
		 * Calculate the size of all files
		 * @returns {*|integer}
		 */
		allFileSizeNumber() {
			let size = 0;

			for (let i = 0; i < this.newFiles.length; i += 1) {
				size += this.newFiles[i].size;
			}
			return size;
		}

	},
	methods: {

		clearAllFiles() {
      this.showModal = true;
		},

    deleteItems(){
      this.newFiles = [];
      this.counter += 1;
      this.showModal = false;
    },

    closeModal(){
      this.showModal = false;
    },

		emitRefreshEvent() {
			EventBus.emit(`refresh-file-list-fm`);
		},

		removeFileAtIndex(index) {
			this.newFiles.splice(index, 1);
		},

		/**
		 * Select file or files
		 * @param event
		 */
		selectFiles(event) {
			// files selected?
			if (event.target.files.length === 0) {
				// no file selected
				this.newFiles = [];
			} else {
				// we have file or files
				let files = Array.from(event.target.files);

				files.forEach((file) => {
					this.newFiles.push(file);
				})
			}
		},

		/**
		 * Upload new files
		 */
		uploadFiles() {
			// if files exists
			if (this.countFiles) {

				if (this.countFiles > this.maxFileUploadCount) {
					this.hideModal();
					this.$store.dispatch('setAlert', {
						type: "danger",
						message: `Maximum ${this.maxFileUploadCount} files allowed`,
						component_name: 'fileManagerModal'
					})
				}

				else if (this.allFileSizeNumber > this.maxPostSize) {
					this.hideModal();
					this.$store.dispatch('setAlert', {
						type: "danger",
						message: this.trans('upload_failed') + this.bytesToHuman(this.maxPostSize),
						component_name: 'fileManagerModal'
					})
				}
				// upload files
				else {
					this.$store.dispatch('fm/upload', {
						files: this.newFiles,
						overwrite: this.overwrite,
					}).then((response) => {
						// if upload is successful
						if (response.data.result.status === 'success') {
							// close modal window
							this.emitRefreshEvent()
							this.hideModal();
						}
					}).catch(err=>{
						this.hideModal();
					});
				}
			}
		},
	},
};
</script>

<style lang="scss">
.fm-modal-upload {

	.fm-btn-wrapper {
		position: relative;
		overflow: hidden;
		padding-bottom: 6px;
		margin-bottom: 0.6rem;
	}

	.fm-btn-wrapper input[type=file] {
		font-size: 100px;
		position: absolute;
		left: 0;
		top: 0;
		opacity: 0;
		cursor: pointer;
	}

	.fm-upload-list .far {
		padding-right: 0.5rem;
	}

	.fm-upload-list .form-check-inline {
		margin-right: 0;
	}

	.fm-upload-info > .progress {
		margin-bottom: 1rem;
	}
}

.fm-modal-clear-enter-active, .fm-modal-clear-leave-active {
  transition: all .3s ease;
}
.ffm-modal-clear-enter, .fm-modal-clear-leave-to {
  transform: translateX(20px);
  opacity: 0;
}

@media (min-width: 768px){
  .modal-sm {
    width: 500px;
  }
}

.fm-modal-clear {
  position: absolute;
  z-index: 99999;
  top: 100px;
  bottom: 0;
  left: 0;
  right: 0;
  width: 500px;
  height: 210px;
  background-color: #fff;
  display: block;
  transition: opacity .4s ease;
  overflow: auto;
}

.pointer-cursor{
  cursor: pointer;
}


</style>
