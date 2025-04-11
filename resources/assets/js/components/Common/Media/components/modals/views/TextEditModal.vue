<template>
    <div class="modal-content fm-modal-text-edit">
        <div class="modal-header">
            <h5 class="modal-title w-75 text-truncate">
                {{ lang1.modal.editor.title }}
                <small class="text-muted ps-3">{{ selectedItem.basename }}</small>
            </h5>
            <button type="button" class="btn-close" aria-label="Close" v-on:click="hideModal"></button>
        </div>
        <div class="modal-body">
            <codemirror
                ref="fmCodeEditor"
                v-bind:value="code"
                v-bind:options="cmOptions"
                v-bind:height="editorHeight"
                v-on:change="onChange"
            />
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-info" v-on:click="updateFile">
                {{ lang1.btn.submit }}
            </button>
            <button type="button" class="btn btn-light" v-on:click="hideModal">
                {{ lang1.btn.cancel }}
            </button>
        </div>
    </div>
</template>

<script>
import Codemirror from 'codemirror-editor-vue3';
import 'codemirror/mode/shell/shell';
import 'codemirror/mode/css/css';
import 'codemirror/mode/sass/sass';
import 'codemirror/mode/htmlmixed/htmlmixed';
import 'codemirror/mode/javascript/javascript';
import 'codemirror/mode/vue/vue';
import 'codemirror/mode/markdown/markdown';
import 'codemirror/mode/xml/xml';
import 'codemirror/mode/clike/clike';
import 'codemirror/mode/php/php';
import 'codemirror/mode/sql/sql';
import 'codemirror/mode/lua/lua';
import 'codemirror/mode/perl/perl';
import 'codemirror/mode/python/python';
import 'codemirror/mode/swift/swift';
import 'codemirror/mode/ruby/ruby';
import 'codemirror/mode/go/go';
import 'codemirror/mode/yaml/yaml';
import 'codemirror/mode/properties/properties';
import modal from '../mixins/modal';
import translate from '../../../mixins/translate';

export default {
    name: 'TextEditModal',
    mixins: [modal, translate],
    components: { Codemirror },
    data() {
        return {
            code: '',
            editedCode: '',
        };
    },
	mounted() {
		// get file for edit
		this.$store.dispatch('fm/getFile', {
			disk: this.selectedDisk,
			path: this.selectedItem.path,
		}).then((response) => {
			// add code
			if (this.selectedItem.extension === 'json') {
				this.code = JSON.stringify(response.data, null, 4);
			} else {
				this.code = response.data;
			}

			// set size
			this.$refs.fmCodeEditor.codemirror.setSize(null, this.editorHeight);
		});
	},
	computed: {
		/**
		 * Selected disk
		 * @returns {*}
		 */
		selectedDisk() {
			return this.$store.getters['fm/selectedDisk'];
		},

		/**
		 * Selected file
		 * @returns {*}
		 */
		selectedItem() {
			return this.$store.getters['fm/selectedItems'][0];
		},

		/**
		 * CodeMirror options
		 * @returns {{tabSize: number, mode: *, theme: string, lineNumbers: boolean, line: boolean}}
		 */
		cmOptions() {
			return {
				mode: this.$store.state.fm.settings.textExtensions[this.selectedItem.extension],
				theme: 'blackboard',
				lineNumbers: true,
				line: true,
			};
		},

		/**
		 * Calculate the height of the code editor
		 * @returns {number}
		 */
		editorHeight() {
			if (this.$store.state.fm.modal.modalBlockHeight) {
				return this.$store.state.fm.modal.modalBlockHeight - 200;
			}

			return 300;
		},
	},
	methods: {
		// Update file
		updateFile() {
			const formData = new FormData();
			// add disk name
			formData.append('disk', this.selectedDisk);
			// add path
			formData.append('path', this.selectedItem.dirname);
			// add updated file
			formData.append('file', new Blob([this.code]), this.selectedItem.basename);

			this.$store.dispatch('fm/updateFile', formData).then((response) => {
				// if file updated successfully
				if (response.data.result.status === 'success') {
					// close modal window
					this.hideModal();
				}
			});
		},
	},
};
</script>

<style lang="scss">
@import 'codemirror/theme/blackboard.css';

.fm-modal-text-edit {
    .modal-body {
        padding: 0;
    }
}
</style>
