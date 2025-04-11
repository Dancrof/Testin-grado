<template>

  <transition v-if="currentStatus" name="modal">

    <div class="modal-mask" :class="{rtl : language === 'ar'}" tabindex="0" @keyup.enter="handleEnterPress" ref="modalMask">

      <div class="modal-wrapper" :class="classname">

        <div class="modal-content common-modal" :style="containerStyle">

          <div class="modal-header">

            <slot name="title"></slot>

            <button v-if="showCloseBtn || showIconCloseBtn" type="button" @click="onClose()" aria-label="Close" data-bs-dismiss="modal"  :class="['btn-close', { 'ms-auto': language !== 'ar', 'me-auto': language === 'ar' }]">

            </button>

          </div>

          <div class="modal-body" :class="modalBodyClass">
          
            <slot name="alert"></slot>
            
            <slot name="fields"></slot>
        
          </div>

          <div v-if="showControls" class="modal-footer" :class="[showCloseBtn ? 'justify-content-between' : '', footerClass]">

            <button v-if="showCloseBtn" type="button" id="clos" :class="{right: lang_locale == 'ar'}" class="btn btn-light"
              @click="onClose()">
              <i class="fas fa-times">&nbsp;</i>
              <span v-if="showbuttonName">{{ showbuttonName }}</span>
              <span v-else>{{ lang('close') }}</span>
            </button>
          
            <slot name="controls"></slot>

          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import {sessionItems} from "../../helpers/extraLogics";

export default {
  name: "modal",

  description: "Modal popup Component",

  props: {
    /**
     * state of modal popup
     * @type {Object}
     */
    showModal: { type: Boolean, default: false },

    /**
     * method which will call on click on close button
     * @type {Function}
     */
    onClose: { type: Function },

    /**
     * contains css styles fro the container
     * @type {Object}
     */
    containerStyle: { type: Object },

    /**
     *Class name helps to matain the size of the modal as per the reuirement
     * for eg if modal-lg is set if large modal size is required
     */
    classname: {
      type: String,
      default: "modal-md"
    },

    language : { type : String, default : ''},

    modalBodyClass : { type : String, default : '' },

    showbuttonName : { type : String, default : '' },

    showCloseBtn : { type : Boolean, default : true },

    showIconCloseBtn: { type: Boolean, default : true },
	  
	  footerClass: { type : String, default : '' },

    showControls : { type : Boolean, default : true },

	  handleEnter: { type : Function, default : () => {} }
  },
  data() {
    return {
      currentStatus: this.showModal,

      lang_locale: ""
    };
  },

	watch: {

		showModal(newVal) {

			this.currentStatus = newVal;

			if (newVal) {

				this.$nextTick(() => {

					this.$refs.modalMask.focus(); // Focus the modal mask when the modal opens
				});
			}
		},
	},

	mounted() {

		this.lang_locale = this.appLanguage;

		if (this.currentStatus) {

			this.$nextTick(() => {
				this.$refs.modalMask.focus();
			});
		}
	},

	methods: {

		handleEnterPress() {

			if (event.target === this.$refs.modalMask) {
				this.handleEnter(); // Call the prop function if needed
			}
		}
	}
};
</script>
<style>
.modal-mask {
  position: fixed;
  z-index: 1050; /* changed to make tinymce dialogs work*/
  top: 0;
  left: 0;
  right: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: table;
  font-weight: 400;
  font-size: 14px;
  /*transition: opacity 0.5s ease !important;*/
}

.modal-wrapper {
  display: table-cell;
  vertical-align: middle;
}

.modal-content {
  max-width: 840px !important;
  margin: 0px auto;
  background-color: #fff;
  border-radius: 0.25rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.5s ease !important;
  color: #444 !important;
}

.modal-title {
  font-weight: 400 !important;
}

.modal-default-button {
  float: right;
}

.modal-body-spacing {
  padding: 0px;
  margin-top: 1rem;
  margin-bottom: 1rem;
}

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter .modal-content,
.modal-leave-active .modal-content {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}

.modal-body{
  padding: 0.9rem;
}

.modal-header {
  display: flex;
  flex-shrink: 0;
  align-items: center;
  padding: 0.7rem;
  border-bottom: 1px solid #e9ecef;
  border-top-left-radius: calc(0.3rem - 1px);
  border-top-right-radius: calc(0.3rem - 1px);
}

.modal-header .btn-close {
  padding: 0.5rem 0.5rem;
  cursor: pointer;
  background-color: transparent;
  border: 0;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  font-size: x-small;
  font-weight: bolder;
}

.modal-footer{
  padding: 0.9rem;
  border-top: 1px solid #e9ecef;
  border-bottom-left-radius: calc(0.3rem - 1px);
  border-bottom-right-radius: calc(0.3rem - 1px);
}

.right {
  float: right !important;
}

.rtl {
  direction: rtl;
}

#modal_close{
  font-size: 1.5rem !important;
}

.modal-header h4 {
	margin-top: 0px !important;
	margin-bottom: 0px !important;
	font-size: 1.2rem;
}

@media only screen and (max-width: 600px) {
  .modal-content {
    width: auto !important;
    margin: 10px !important;
  }
}
</style>
