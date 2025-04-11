<template>
  <div id="file-manager-container">

    <button v-on:click="showModalDialog()" type="button" class="btn btn-light" id="add-media-button-with-margin">
      <i class="far fa-caret-square-right"></i>&nbsp;{{ page == 'widget' ? lang('gallery') : lang('add-media')}}
    </button>

    <slot name="templateBtn"></slot>
    <span v-if="shouldShowResponseMessage" class="response-message">{{ responseMessage }}</span>
    <span v-if="shouldShowNewResponseMessage" class="response-message">{{ newresponseMessage }}</span>

    <modal v-if="displayModal"  :showModal="displayModal" :onClose="onClose" :containerStyle="containerStyle"
           modalBodyClass="fm_modal_body">

      <template #title>
        <h4>{{ lang('file-manager-modal-title') }} <tool-tip v-if="toolTipMessage" :message="toolTipMessage" size="large"></tool-tip></h4>
      </template>

		<template #fields>

			<div v-if="!loading" style="height: 100%">
				<alert componentName="fileManagerModal" />
				<file-manager :settings="settings"></file-manager>
			</div>

			<div class="row" v-if="loading">
				<reuse-loader :duration="4000" :size="60"></reuse-loader>
			</div>
		</template>

		<template #controls>

			<button slot="controls" type="button"  @click="onSubmit" class="btn btn-primary" :disabled="buttonDisabled">
				<i class="fas fa-paperclip"> </i>  {{lang('file-manager-insert-media')}}
			</button>
		</template>
    </modal>
  </div>
</template>

<script>

import axios from 'axios';
import ToolTip from "../../MiniComponent/ToolTip.vue";

export default {
  name: "FileManagerContainer",

  components: {

    "tool-tip": ToolTip,
  },

  props: {
    page: {type: String, default: 'others'}, // takes 2 values 'kb' or 'others'
    type: {type: String, default: ''},
    showModal: {type: Boolean, default: false},
    mediaOption: { type: [Boolean, Number], default: false },

  },

  data() {
    return {
      responseMessage: '',
      newresponseMessage:'',
      toolTipMessage: null,
      selectedFiles: [],
      selectedDisk: null,
      displayModal : this.showModal,
      loading: false,
      containerStyle: {
        "width": "80vw",
      },
    }
  },

  computed: {
	  settings() {

		  return {
			  baseUrl : this.basePath() + '/file-manager/',
			  page: this.page,
			  maxFileUploadCount: null,
			  maxSingleFileSize: null,
			  maxPostSize: null,
        maxTicketPostSize: null
		  }
	  },
    fileSelected() {
      return this.$store.state.fm.left.selected.files;
    },
    folderSelected() {
      return this.$store.state.fm.left.selectedDirectory;
    },
    diskSelected() {
      return this.$store.state.fm.left.selectedDisk;
    },
    buttonDisabled() {
      return !this.selectedFiles.length;
    },
    filesInClipboard() {
      return this.$store.state.fm.clipboard.files
    },
    shouldShowResponseMessage() {
      return this.type !== 'reply' && this.mediaOption && this.$route.fullPath !== '/agent/ticket/recur';
    },
    shouldShowNewResponseMessage() {
      return this.type === 'reply' || this.mediaOption === false || this.$route.fullPath === '/agent/ticket/recur';
    }
  },

  watch: {
    fileSelected() {
      this.selectedFiles = this.fileSelected;
    },
    folderSelected() {
      if (this.folderSelected.length) {
        this.selectedFiles = [];
      }
    },
    diskSelected() {
      this.selectedFiles = [];
      this.selectedDisk = this.diskSelected;
    },
    filesInClipboard() {
      if (this.filesInClipboard.length) {
        this.selectedFiles = [];
      }
    }
  },

  beforeMount() {
    this.getFileUploadRules();
  },

  methods: {
    bytesToHuman(bytes) {
      const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];

      if (bytes === 0) return '0 Bytes';

      const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10);

      if (i === 0) return `${bytes} ${sizes[i]}`;

      return `${(bytes / (1024 ** i)).toFixed(1)} ${sizes[i]}`;
    },
    formatBytes(bytes, decimals) {

      if (bytes == 0)
        return '0 Bytes';

      var k = 1024,

          dm = decimals || 2,

          sizes = ['Bytes', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb', 'Eb', 'Zb', 'Yb'],

          i = Math.floor(Math.log(bytes) / Math.log(k));

      return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    },

    showModalDialog() {
    this.displayModal = !this.displayModal;
    window.emitter.emit('fileModal', this.displayModal)
		this.$store.dispatch('unsetAlert');
		this.$store.dispatch('unsetValidationError');
    },

    onSubmit() {
      let inlineFilesAreNotPdf = false;

      this.selectedFiles.forEach((file) => {
        if (file.split('.').pop() !== 'pdf') inlineFilesAreNotPdf = true
      });

      if (this.selectedFiles.length) {
        let disk = this.$store.state.fm.left.selectedDisk;
        if (['page','kb'].includes(this.page)) {
          this.$emit('fileChosenInlinePdf', {files: this.selectedFiles, disk: disk});
        } else {
          this.$emit('filesChosen', {files: this.selectedFiles, disk: disk});
        }
        this.onClose();
      } else {
        this.$store.dispatch('setAlert', {
          type: "danger",
          message: this.lang('file-manager-select-atleast-one-file'),
          component_name: 'fileManagerModal'
        })
      }
    },

    onClose() {
      this.displayModal = false;
       window.emitter.emit('fileModal', this.displayModal)
    },

    async getFileUploadRules() {
      try {
        let response = await axios.get('file-manager/upload-info');
        let data =response.data.data;
        this.responseMessage = this.trans('max_upload_size') + this.formatBytes(response.data.data.maxPostSize);
        this.newresponseMessage = this.trans('max_upload_size') + this.formatBytes(response.data.data.maxTicketPostSize);
        this.settings.maxSingleFileSize = data.maxSingleFileSize;
        this.settings.maxFileUploadCount = data.maxFileUploadCount;
        this.settings.maxPostSize = data.maxPostSize;
        this.settings.maxTicketPostSize = data.maxTicketPostSize;
        this.settings.maxTicketPostSize = data.maxPostSize;
        this.toolTipMessage = this.trans('max_upload_size') + this.bytesToHuman(data.maxPostSize) +',' + this.trans('single_file_size') + this.bytesToHuman(data.maxSingleFileSize) + this.trans('max_number_of_files') + data.maxFileUploadCount;
      } catch(e) {
        this.settings.maxSingleFileSize = null;
        this.settings.maxFileUploadCount = null;
        this.settings.maxPostSize = null;
        this.toolTipMessage = null;
      }
    },

    onChange(value,name) {
      this[name] = value;
    }
  }
}
</script>

<style>
#add-media-button-with-margin {
  margin-bottom: 0.8rem;
}

.fm_modal_body {
  max-height: 500px;
  overflow-y: auto;
  height: 500px;
  padding: 0 1rem !important;
}
.response-message{
  font-style: italic;
  font-size: 12px;
  display: flex;
  margin: -10px 0px 10px 0px;
}
</style>
