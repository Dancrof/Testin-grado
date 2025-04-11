<template>
    <transition name="fm-modal">
        <div class="fm-modal" ref="fmModal" v-on:click="hideModal">
            <div class="modal-dialog" role="document" v-bind:class="modalSize" v-on:click.stop>
                <component v-bind:is="modalName" />
            </div>
        </div>
    </transition>
</template>

<script>
import NewFile from './views/NewFileModal.vue';
import NewFolder from './views/NewFolderModal.vue';
import Upload from './views/UploadModal.vue';
import Delete from './views/DeleteModal.vue';
import Clipboard from './views/ClipboardModal.vue';
import Status from './views/StatusModal.vue';
import Rename from './views/RenameModal.vue';
import Properties from './views/PropertiesModal.vue';
import Preview from './views/PreviewModal.vue';
import TextEdit from './views/TextEditModal.vue';
import AudioPlayer from './views/AudioPlayerModal.vue';
import VideoPlayer from './views/VideoPlayerModal.vue';
import Zip from './views/ZipModal.vue';
import Unzip from './views/UnzipModal.vue';
import About from './views/AboutModal.vue';

export default {
    name: 'ModalBlock',
    components: {
		NewFile,
		NewFolder,
		Upload,
		Delete,
		Clipboard,
		Status,
		Rename,
		Properties,
		Preview,
		TextEdit,
		AudioPlayer,
		VideoPlayer,
		Zip,
		Unzip,
		About,
    },
	mounted() {
		// set height
		this.$store.commit('fm/modal/setModalBlockHeight', this.$refs.fmModal.offsetHeight);
	},
	computed: {
		/**
		 * Selected modal name
		 * @returns {null|*}
		 */
		modalName() {
			return this.$store.state.fm.modal.modalName;
		},

		/**
		 * Modal size style
		 * @returns {{'modal-lg': boolean, 'modal-sm': boolean}}
		 */
		modalSize() {
			return {
				'modal-xl': this.modalName === 'Preview' || this.modalName === 'TextEdit',
				'modal-lg': this.modalName === 'VideoPlayer',
				'modal-sm': this.modalName === 'Upload' || this.modalName === 'Delete' || false,
			};
		},
	},
	methods: {
		/**
		 * Hide modal window
		 */
		hideModal() {
			this.$store.commit('fm/modal/clearModal');
		},
	},
};
</script>

<style lang="scss">

.fm-modal {
	position: absolute;
	z-index: 9998;
	top: 0;
	bottom: 0;
	left: 0;
	right: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, .35);
	display: block;
	transition: opacity .4s ease;
	overflow: auto;

	.modal-xl {
		max-width: 96%;
	}
}

.fm-modal-enter-active, .fm-modal-leave-active {
	transition: opacity .5s;
}
.fm-modal-enter, .fm-modal-leave-to {
	opacity: 0;
}
@media (min-width: 768px){
	.modal-sm {
		width: 500px;
	}
}

</style>
