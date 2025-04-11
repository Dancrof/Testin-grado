<template>

  <div class="inbox-thread-body">

    <i class="timeline-icon" :class="thread.thread_type_icon_class" v-tooltip="thread.thread_type_text"></i>

    <div class="timeline-item" v-if="isEditingInternalNote">

      <div class="card-header internal-Note">

        <h3 class="card-title">{{trans('edit_internal_note')}}</h3>

      </div>

      <div class="m-3 descrp">

        <add-media v-if="showAddMedia" :attachments="attachments" :inlineFile="inline" :description="description" :id="'focus_editor'+thread.id"
                   classname="col-sm-12" name="description" :onAttach="getAttachments" :onInline="getInlineImages" :onInput="onChange"
                   page_name="description">

        </add-media>

      </div>

      <div class="card-footer">

        <button id="submit_btn" class="btn btn-primary" @click="onSubmit()">

          <i class="fas fa-sync-alt"></i> {{lang('update')}}

        </button>

      </div>

    </div>

    <div class="timeline-item" v-else>

			<span class="time thread_right">

				<span v-tooltip="lang('reply_rating')" class="thread_rating">

					<rating-component v-for="rating in ratings" :key="rating.id" :rating="rating" :labelStyle="labelStyle">

					</rating-component>
				</span>

				<span v-if="ratings.length > 0" class="mt_4">&nbsp;&#124;&nbsp;&nbsp;</span>

				<div class="div" v-if="!ticketMerged && showThreadActions">

          <!-- Check if the 'isSettingActive' getter exists and if either 'summarize_ticket_key' or 'translate_ticket_content_key' settings are active -->
          <div v-if="!isEmptyContent && (hasIsSettingActiveGetter && (isSettingActive('summarize_ticket_key') || isSettingActive('translate_ticket_content_key')) && from === 'inbox')" class="inline-block ai-ticket-thread-summary">
            <div class="dropdown">
              <!-- Dropdown toggle button with an SVG icon -->
              <a type="button" class="pointer margin_5px dropdown-bs-toggle" data-bs-toggle="dropdown" id="elea-dropdown" aria-haspopup="true" aria-expanded="false">
                  <svg-icon-handler StyleCss="p-0" height="20" width="20" color="#66686a" icon-from="elea_c_icon" />
              </a>
              <ul class="dropdown-menu summary-menu elea-dropdown-menu" aria-labelledby="elea-dropdown">
                <li v-if="isSettingActive('summarize_ticket_key')">
                  <a class="dropdown-item summary-dropdown" @click="loadThreadSummarizeModal(langKey = '')">
                  <i class="fas fa-clipboard-list"></i>&nbsp;{{ lang('summarize_thread') }}
                </a></li>
                <li v-if="isSettingActive('translate_ticket_content_key')" class="dropdown-submenu summary-submenu" @click.stop="toggleLanguageDropdown">
                  <a class="dropdown-item summary-dropdown dropdown-toggle">
                   <i class="fas fa-language"></i>&nbsp;{{ lang('translate') }}
                  </a>
                  <!-- Language selection submenu -->
                  <ul ref="languageList" class="dropdown-menu summary-menu lang-dropdown"  :style="{ display: showLangDropdown ? 'block' : 'none' }" @mouseleave="showLangDropdown = false">
                    <!-- List of available languages for translation -->
                    <li v-for="(language, index) in languages" :key="language.language" :class="{ 'lang-highlight': index === 0 }">
                            <a class="dropdown-item summary-dropdown" @click="loadThreadSummarizeModal(language.language)">{{ language.name }}</a>
                    </li>
                  </ul>
                </li>
              </ul>
            </div>
          </div>

					<a v-if="thread.is_internal !== 1 && !max" class="pointer margin_5px" v-tooltip="lang('reply_to_this_thread')"
             @click="replyThread(thread.body,thread.user.name,thread.created_at)">
						<i class="fas fa-reply"></i>
					</a>

         <a v-if="thread.is_internal === 1" class="pointer margin_5px" v-tooltip="lang('edit_internal_note')"
            @click="editInternalNoteThread(thread)">
          <i class="fa-solid fa-pen-to-square"></i>
         </a>

        <a class="pointer margin_5px"
           v-tooltip="thread.thread_type === 'note' ? lang('delete_note') : lang('delete_reply')"
           @click="deleteThread"
           v-if="index !== total - 1 && !thread.allows_modification">
           <i class="fa-solid fa-trash"></i>
        </a>


        <transition name="modal">

          <delete-modal v-if="showModal" :modalMessage="modalMessage" :onClose="onClose" alertComponentName="timeline"  :showModal="showModal" :deleteUrl="deleteUrl" ></delete-modal>

        </transition>

          <transition name="modal">
            <!-- Component for displaying the ticket thread summary modal -->
            <elea-ticket-thread-summary v-if="showSummary" :data="threadData" :showModal="showSummary" :translate="translateTo"  :onClose="onClose" :ticketId="ticketId"></elea-ticket-thread-summary>
          </transition>

          <span v-if="showRedaction && pluginStatus"  class="dropdown">

            <a data-bs-toggle="dropdown" id="redact-toggle"  aria-expanded="true" class="pointer margin_5px" v-tooltip="lang('redact_to_this_thread')">
              <i class="fas fa-ellipsis-v"></i>
            </a>

					<div class="dropdown-menu dropdown-menu-right" role="menu" aria-labelledby="redact-toggle">

						<a class="dropdown-item" href="javascript:;" @click="makeEditable()">{{lang('redact')}}</a>

          </div>
          </span>

        </div>

        <template v-if="thread.allows_modification && showThreadActions">

	         <a v-tooltip="trans('edit')" class="pointer margin_5px" @click.prevent="editThreadClicked(thread)">

		       <i class="fas fa-edit"></i>

           </a>

	         <a  v-tooltip="trans('delete')" class="pointer margin_5px"  @click.prevent="deleteThreadClicked(thread)">

		        <i class="fas fa-trash"></i>

           </a>
        </template>

			</span>

      <h3 class="timeline-header bg-light">

        <faveo-image-element id="thread_img" :source-url="thread.user.profile_pic"
                             :classes="['img-circle', 'img-bordered-sm', 'img-rounder']" alternative-text="User Image" :img-width="25"
                             :img-height="25"/>&nbsp;

        <div class="hover-card">

          <router-link :to="'/user/' + this.thread.user.id" id="thread_head_name" class="ml-1">
            {{ subString(thread.user.name) }}
          </router-link>

          <div class="hover-card-content">

            <div class="d-flex align-items-center mb-2">

              <img :src="thread.user.profile_pic"
                   style="height: 40px; width: 40px; border-radius: 24px; border: 2px solid #3788d8;"
                   alt="Profile Picture"/>

              <div class="ms-2">
                <div>{{ subString(thread.user.name) }}</div>
              </div>
            </div>

            <div class="email-wrapper">

              <i class="fas fa-envelope"></i>

              <span class="email">{{ subString(thread.user.email) }}</span>
            </div>
          </div>
        </div>

        <span class="thread_time"> - &nbsp;<i class="far fa-clock"></i> {{ formattedTime(thread.created_at) }}</span>

        <p v-if="isEditing && showThreadActions" class="thread_time" id="redactioninfo">{{ lang('highlight_redact_text') }}

          <strong>{{ lang('mark_for_redaction_option') }}</strong>
        </p>
      </h3>

      <div class="timeline-body thread_desc w-100" :class="bgClass(thread.thread_type_text)" :id="'thread_desc_'+thread.id" :contentEditable="isEditing.toString()"
           @mouseup="handleSelection">

        <activity-parser :data="updatedBody(thread.body)"></activity-parser>
      </div>

      <div v-if="showDropdown && isEditing && showThreadActions" class="rounded dropadded"
           :style="positionFix">
        <a class="dropdown-item cursor-pointer px-2 py-1" href="javascript:;"
           @click="markForRedaction('permanent','thread_desc_'+thread.id)">
          {{ lang('mark_for_permanent_redaction') }}
        </a>
        <a class="dropdown-item cursor-pointer px-2 py-1" href="javascript:;"
           @click="markForRedaction('temporary','thread_desc_'+thread.id)">
          {{ lang('mark_for_temporary_redaction') }}
        </a>
      </div>


      <div v-if="thread.attach.length" class="timeline-footer" :contentEditable="isEditing.toString()"
           @mouseup="handleSelection">

        <ul class="mailbox-attachments align-items-stretch clearfix mb-0 clearfixapply">

          <template v-for="(attachment, index) in thread.attach">

            <template
                v-if="attachment.poster === 'ATTACHMENT' && attachment.temporary_redaction === 0 && attachment.permanent_redaction === 0">

              <attachment :attachment="attachment"></attachment>
            </template>

            <template v-else-if="attachment.temporary_redaction === 1 || attachment.permanent_redaction === 1">

              <div v-if="isHTMLContent(attachment.thumbnail_url)">

                <div v-html="attachment.thumbnail_url"></div>
              </div>

              <div v-else class="d-flex">

                <attachment :attachment="attachment"></attachment>
              </div>
            </template>
          </template>
        </ul>
      </div>

      <div v-if="showPopupUndo && showThreadActions" :style="positionFix" id="popup_undo" class="rounded dropadded">

        <a class="dropdown-item redact-dropdown-item" href="javascript:;" @click="viewRedaction" id="viewButton">{{ lang('view') }}</a>

        <a class="dropdown-item redact-dropdown-item" href="javascript:;" @click="undoRedaction" id="undoButton">{{ lang('undo') }}</a>
      </div>

      <div v-if="isEditing && showThreadActions" class="timeline-footer" id="editableContent_footer">

        <button type="button" id="editableContent_cancelBtn" class="btn btn-light border btn-sm "
                @click="cancelEditing">
          <i class="fas fa-times me-1"></i>{{ lang('cancel') }}
        </button>

      </div>
    </div>
  </div>
</template>

<script>

import {mapGetters, useStore} from 'vuex';
import {computed} from "vue";
import RatingComponent from "../../../../../../MiniComponent/RatingComponent.vue";
import AttachmentBlock from "../../../../../../MiniComponent/AttachmentBlock.vue";
import ActivityParser from "../../../../../../Common/ActivityParser.vue";
import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";
import AddMedia from "../../../../../../MiniComponent/FormField/AddMedia.vue";
import DeleteModal from "../../../../../../MiniComponent/DataTableComponents/DeleteModal.vue";
import {getSubStringValue, lang} from "../../../../../../../helpers/extraLogics";
import SvgIconHandler
  from "../../../../../../../../../../app/Plugins/EleaAssistant/views/js/components/miniComponent/SvgIconHandler.vue";
import EleaTicketThreadSummary
  from "../../../../../../../../../../app/Plugins/EleaAssistant/views/js/components/EleaTicketThreadSummary.vue";

export default {

  name: 'thread-body',

  description: 'Thread Body Component',

  setup() {

    const store = useStore();

    return {

      formattedTime: computed(() => store.getters.formattedTime),

      getRatingTypes: computed(() => store.getters.getRatingTypes)
    }
  },

  props: {

    thread: {
      type: Object, default: () => {
      }
    },

    index: {type: [String, Number], default: ''},

    total: {type:  Number, default: ''},

    max: {type: Boolean, default: false},

    ticketMerged: {type: Boolean, default: false},

    pluginStatus: {type: Boolean, default: false},

    ticketId: {type: [String, Number], default: ''},

    from: {type: String, default: ''},

    showRedaction: {type: Boolean, default: false},

	  showThreadActions: { type: Boolean, default: true }
  },

  data() {

    return {

      ratings: [],

      labelStyle: {display: 'none'},

      isEditing: false,

      showDropdown: false,

      selectedText: '',

      newselectedText: '',

      showPopupUndo: false,

      nonRedactedResponse: [],

      isRedactionTypeSelected: false,

      redactionSelections: [],

      topPosition: 0,

      leftPosition: 0,

      isViewingRedaction: false,

      previousRedactedContent: '',

      combinedText:'',

      description:'',

      isEditingInternalNote : false,

      attachments:[],

      inline : [],

      showAddMedia:true,

      showModal : false,

      deleteUrl : '',

      threads:[],

      modalMessage:this.trans('are_you_sure_want_delete_this_thread'),

      showLangDropdown: false,

      languages : [],

      showSummary: false,

      translateTo: '',

      threadData: '',
    }
  },
  mounted() {
    if (this.isEditing) {
      document.addEventListener('selectionchange', this.handleSelection);
      this.showDropdown = false;  // Reset dropdown visibility on edit
    }

    // Loads the languages.
    this.loadLanguage();
  },

  beforeDestroy() {
    // Clean up event listener when component is destroyed
    document.removeEventListener('selectionchange', this.handleSelection);
  },

  created() {

    window.emitter.on('threadUpdated', () => {

      window.emitter.emit('updateTimelineThreads')
      window.emitter.emit('refreshData')

    });

    window.emitter.on('showRedactionOptions', () => {
      this.makeEditable();
    });
  },

  methods: {
    lang,

	  subString(value,length = 25){
		  // to set the length different for the email and name Data
		  return getSubStringValue(value,length)
	  },

    getAttachments(files){

      this.attachments = files;
    },

    getInlineImages(files){

      this.inline = files;
    },

    onInput(value, name) {
      this[name] = value || '';
    },

    onChange(value, name) {
      this[name] = value;

      if(value === null){

        this[name] = '';
      }
    },

    // Check if the content contains any HTML tags
    isHTMLContent(content) {
      const htmlRegex = /<[a-z][\s\S]*>/i;
      return htmlRegex.test(content);
    },


    handleSelection() {

      const selection = window.getSelection();
      if (!this.isEditing || selection.isCollapsed) {
        this.showDropdown = false;  // Hide dropdown if not editing or no text selected
        return;
      }
      if (selection && selection.rangeCount > 0) {
        const range = selection.getRangeAt(0);
        const rect = range.getBoundingClientRect();
        const midpointX = rect.left / 2
        this.leftPosition = midpointX/2
        const selectedText = range.toString();
        let selectedNode = range.commonAncestorContainer;
        const parentNode = range.commonAncestorContainer.parentNode;
        if (parentNode.outerHTML.includes('<permanent>')) {
          this.showDropdown = false;
          return;
        }

        // Traverse up the DOM tree from the selected node until reaching the body
        while (selectedNode && selectedNode !== document.body) {
          if (selectedNode.tagName === 'REDACTED' || selectedNode.tagName === 'BLOCKQUOTE' || selectedNode.tagName === 'REDACTEDIMG' || selectedNode.tagName === 'REDACTEDATTACHMENT') {
            if (selectedNode.tagName === 'BLOCKQUOTE') {
              this.showDropdown = false;
              return;
            }
            this.showDropdown = true;
            break;
          }
          selectedNode = selectedNode.parentNode;
        }
        // Check if the selected node is redacted
        let isRedacted = selectedNode && (selectedNode.tagName === 'REDACTED' || selectedNode.tagName === 'REDACTEDIMG' || selectedNode.tagName === 'REDACTEDATTACHMENT');
        if (!isRedacted && selectedText.trim().length > 0) {
          this.showDropdown = true;
        } else {
          this.showDropdown = false; // Hide if text is redacted or empty
        }
        const cloneRange = range.cloneRange();
        const clonedContents = cloneRange.cloneContents();
        const tempDiv = document.createElement('div');
        tempDiv.appendChild(clonedContents);
        this.combinedText = tempDiv.innerHTML;
        // Find any images within the selected range
        const images = tempDiv.querySelectorAll('img');
        let selectedImage = '';
        if (images.length > 0) {
          // If images are found, wrap each image in a paragraph and store the HTML
          images.forEach(image => {
            const paragraph = document.createElement('p');
            paragraph.appendChild(image.cloneNode(true));
            selectedImage = paragraph.outerHTML;
          });
        }
        // Determine the selected HTML based on whether it is redacted or not
        const selectedHtml = isRedacted ? selectedNode.outerHTML : selectedText;
        if (this.isEditing) {
          // this.showDropdown = !selection.isCollapsed;
          this.selectedText = selectedText || selectedHtml || selectedImage;
          let selectedTextWithoutPTag = this.selectedText.replace(/^<p>|<\/p>$/g, '');
          selectedTextWithoutPTag !== this.combinedText ? this.showDropdown = false : this.showDropdown = !selection.isCollapsed;
          this.newselectedText = selectedHtml;
          this.showPopupUndo = isRedacted;
          // Extract the ID of the redacted attachment if present
          const idRegex = /<redactedattachment id="(\d+)">/;
          const match = this.newselectedText.match(idRegex);
          this.redactedImgId = match ? match[1] : null;
          this.showDropdown = !selection.isCollapsed && !isRedacted && selectedTextWithoutPTag.length > 0;
        }
        // If the selection is redacted and in editing mode, show the undo popup and hide the dropdown
        if (isRedacted && this.isEditing) {
          this.showPopupUndo = true;
          this.showDropdown = false;
        }
        if (selectedText.includes('█')) {
          this.showDropdown = false;
        }
      }
    },

    markForRedaction(redactionType, id) {
      // Flag indicating a redaction type is selected
      this.isRedactionTypeSelected = true;
      const selection = window.getSelection();
      if (!selection.isCollapsed) {
        const selectedText = this.selectedText.toString().trim();
        // Extract image ID if the selected text contains an image
        const imgSrc = this.selectedText.match(/<img[^>]*\sid="(\d+)"[^>]*>/);
        const imgId = imgSrc ? imgSrc[1] : null;

        // Store the redaction data here
        this.redactionSelections.push({text: selectedText, type: redactionType, attachmentId: imgId});

        // Function to create a redaction span
        const createRedactionSpan = (borderColor) => {
          const span = document.createElement('span');
          span.style.backgroundColor = 'rgba(255, 0, 0, 0.1)';
          span.style.border = `2px solid ${borderColor}`;
          span.style.display = 'inline-block';
          span.className = 'redacted-span';
          return span;
        };
        // Check if a range is selected and if it includes an image
        if (selection.rangeCount > 0 && selectedText.includes('<img')) {
          const range = selection.getRangeAt(0);
          const lastRedactionType = this.redactionSelections[this.redactionSelections.length - 1]?.type;
          const borderColor = lastRedactionType === 'temporary' ? '#495057' : 'black';
          range.surroundContents(createRedactionSpan(borderColor));
          this.thread.body = document.getElementById(id).innerHTML;
        } else {
          // If no range or no image, replace the selected text with a redacted span in the thread body
          const lastRedactionType = this.redactionSelections[this.redactionSelections.length - 1]?.type;
          const borderColor = lastRedactionType === 'temporary' ? '#495057' : 'black';
          const range = selection.getRangeAt(0);
          range.surroundContents(createRedactionSpan(borderColor));
          this.thread.body = document.getElementById(id).innerHTML;
        }
        if (this.isViewingRedaction) {
          this.thread.body = this.previousRedactedContent;
          this.isViewingRedaction = false;
          this.previousRedactedContent = '';
        }
        this.submitRedaction(id)
        // Remove all ranges from the selection and hide the dropdown
        selection.removeAllRanges();
        this.showDropdown = false;
      }
    },

    // Cancel editing mode and will remove all the marked css
    cancelEditing() {
      this.isEditing = false;
      this.redactionSelections.forEach(selectedText => {
        this.thread.body = this.thread.body.replace(new RegExp(`<span[^>]*>${selectedText.text}<\/span>`, 'g'), selectedText.text);
      });
      this.redactionSelections = [];
      window.getSelection().removeAllRanges();
      window.emitter.emit('updateTimelineThreads');
      this.showDropdown = false;
    },

    async submitRedaction(id) {

      try {
        let redactedContent = this.thread.body;
        // Iterate over redaction selections to replace text with appropriate tags and extract attachment information
        const attachmentInfo = {};
        this.redactionSelections.forEach(selectedText => {
          if (selectedText && selectedText.text && selectedText.type) {
            // Determine opening and closing tags based on redaction type
            const openingTag = selectedText.type === 'permanent' ? '<permanentRedacted>' : '<redacted>';
            const closingTag = selectedText.type === 'permanent' ? '</permanentRedacted>' : '</redacted>';
            // const redactedText = `${openingTag}${selectedText.text}${closingTag}`;
            const redactedSpans = document.querySelectorAll('#' + id + ' span.redacted-span');
            redactedSpans.forEach(span => {
              // Replace text with redacted tags in the content
              if (selectedText.text.includes('<img src')) {
                // This replaces the selected image with the redacted image
                let selectedTextWithoutPTag = this.selectedText.replace(/^<p>|<\/p>$/g, '');
                redactedContent = redactedContent.replace(span.outerHTML, `${openingTag}${selectedTextWithoutPTag}${closingTag}`);
                // redactedContent = redactedContent.split(selectedTextWithoutPTag).join(redactedText);
              } else {
                redactedContent = redactedContent.replace(span.outerHTML, `${openingTag}${selectedText.text}${closingTag}`);
              }
            });


            // Extract attachment information
            if (selectedText.attachmentId) {
              attachmentInfo[selectedText.attachmentId] = selectedText.type;
            }
          }
        });
        // Send redacted content and attachment information to the server
        const response = await axios.post('secret/api/thread/redact', {
          threadId: this.thread.id,
          text: redactedContent,
          attachments: attachmentInfo
        });
        successHandler(response, 'timeline');
        window.emitter.emit('updateTimelineThreads');
      } catch (error) {
        errorHandler(error, 'timeline');
      }
    },

    // Function to view redacted content
    viewRedaction() {
      this.isViewingRedaction = true;
      // Store the previous redacted content before viewing new redaction
      this.previousRedactedContent = this.thread.body;
      // Replace redacted image tags with appropriate formatting
      const modifiedSelectedText = this.newselectedText.replace(/<redactedImg/gi, '<redactedimg').replace(/<\/redactedimg>/g, '</redactedimg>');
      const viewRedactedText = this.newselectedText.replace(/<redactedimg/gi, '<redacted').replace(/<\/redactedimg>/g, '</redacted>');

      // Send request to view redacted content
      axios.post('secret/api/thread/viewRedaction', {
        threadId: this.thread.id,
        text: viewRedactedText,
        attachment: this.redactedImgId
      }).then(response => {
        // Update attachment information with non-redacted data
        this.nonRedactedResponse = response.data.data[0];
        this.thread.attach.forEach(attachment => {
          if (attachment.id === this.nonRedactedResponse.id) {
            attachment.thumbnail_url = this.nonRedactedResponse.thumbnail_url;
            attachment.view_url = this.nonRedactedResponse.view_url;
            attachment.name = this.nonRedactedResponse.filename;
            attachment.download_url = this.nonRedactedResponse.download_url;
          }
        });
        // Replace redacted content with non-redacted content in the thread body
        this.thread.body = this.thread.body.replaceAll(modifiedSelectedText, response.data.data);
        successHandler(response, 'timeline');
        this.showPopupUndo = false;
      }).catch(error => {
        errorHandler(error, 'timeline');
      });
    },

    undoRedaction() {
      // Replace redacted content with unredacted content
      const undoRedactedText = this.newselectedText
          .replace(/<redactedimg/gi, '<redactedImg')
          .replace(/<\/redactedimg>/g, '</redactedImg>')
          .replace(/redactedImg|redacted/g, 'unredacted');

      // Send request to undo redaction
      axios.post('secret/api/thread/rollbackRedaction', {
        threadId: this.thread.id,
        text: undoRedactedText,
        attachments: this.redactedImgId
      }).then(response => {
        successHandler(response, 'timeline');
        window.emitter.emit('updateTimelineThreads');
        window.emitter.emit('refreshData');
        // Reset editing and hide undo popup
        this.isEditing = false;
        this.showPopupUndo = false;
      }).catch(error => {
        errorHandler(error, 'timeline');
      });
    },

    makeEditable() {

      this.isEditing = !this.isEditing;
    },

    updatedBody(value) {
      return `<div>` + value.replace(/\r?\n/g, '').trim() + `</div>`;
    },

    replyThread(data, name, date) {

      const quote = 'On ' + this.formattedTime(date) + ' ' + '<b>' + name + '</b> ' + 'wrote :';

      var content;

      content = "<p id='extra_p'>&nbsp;</p><blockquote>" + quote + "<figure  id='mine'>" + data + "</figure></blockquote>";

      this.thread['content'] = content;

      window.emitter.emit('threadReply', this.thread);
    },

    ratingTypes(types) {

      this.ratings = types;

      var ratingArr = [];

      if (this.thread.ratings.length != 0) {

        for (var i in this.ratings) {

          for (var j in this.thread.ratings) {

            if (this.ratings[i].id == this.thread.ratings[j].rating_id) {

              if (this.ratings[i].rating_area == 'Comment Area') {

                this.ratings[i]['rating_value'] = this.thread.ratings[j].rating_value;

                this.ratings[i]['ticket_id'] = this.thread.ticket_id;

                ratingArr.push(this.ratings[i])

              }
            }
          }
        }
      }

      this.ratings = ratingArr;
    },

    // In case of Task Comments we are allowing to delete and edit
    deleteThreadClicked(thread) {
      const {id} = thread
      window.emitter.emit('threadDelete', {id});
    },

    editThreadClicked(thread) {
      // Again it assumes `originalText` is passed from backend
      const {id, originalText, attach} = thread;
      window.emitter.emit('threadEdit', {id, originalText, attach});
    },

    onSubmit() {
      const obj = {
        content: this.description,
        attachment: this.attachments
      };
      axios.post('api/thread/internal/note/' + this.thread.id, obj)
          .then(response => {
            successHandler(response, 'timeline');
            // this.showAddMedia = false;
            window.emitter.emit('updateTimelineThreads')
          })
          .catch(error => {
            errorHandler(error, 'timeline')
          });
    },

    editInternalNoteThread(){

      axios.get('api/thread/internal/note/' + this.thread.id)
          .then((res) => {
            this.description = res.data.data.body;
            this.attachments = res.data.data.attach;
            this.isEditingInternalNote = true;

          })
          .catch((error) => {
            errorHandler(error,'timeline')
          });
    },

    deleteThread() {

      this.deleteUrl = 'api/thread/delete/' + this.thread.id

      this.showModal = true

      this.$emit('threadDeleted', this.thread.id);
    },

    onClose(){

      this.showModal = false;

      // Checks if the `showSummary` property is true and sets it to false if it is.
      if(this.showSummary){
        this.showSummary = false;
      }

      this.$store.dispatch('unsetValidationError');
    },

    bgClass(requester) {
      if (!requester) {
        return 'bg-note';
      }

      if (requester.includes(this.lang('posted_by_client'))) {

        return 'bg-client';

      } else if (requester.includes(this.lang('posted_as_internal_note'))) {

        return 'bg-note';

      } else if(requester.includes(this.lang('posted_by_system'))) {

        return 'bg-system';

      } else {

        return 'bg-default';
      }
    },

    // Loads the thread summary modal with the updated thread body and sets the language for translation.
    // {string} langKey - The language to translate the thread content to.
    loadThreadSummarizeModal(langKey){
      this.threadData = this.updatedBody(this.thread.body);
      this.translateTo = langKey;
       this.showSummary = true;
    },

    toggleLanguageDropdown() {

      // Toggles the visibility of the language dropdown menu.
      this.showLangDropdown = !this.showLangDropdown;

      if (this.showLangDropdown) {
        this.scrollToTop();
      }
    },

    scrollToTop() {
      this.$nextTick(() => {
        const dropdown = this.$refs.languageList;
        if (dropdown) {
          dropdown.scrollTop = 0;
        }
      });
    },

    async loadLanguage() {
      // Loads the list of available languages for translation, excluding the 'auto' option.
      let response = [];

      const store = useStore(); // Get the store instance using the useStore hook

      if (store && store.getters) {
        response = await store.getters.isLanguageList;
      }
      if (response) {
        this.languages = response.filter(language => language.language !== 'auto');
      }
    }
  },

  computed: {
    positionFix() {
      return {
        top: this.topPosition + 'px',
        left: this.leftPosition + 'px',
        position: 'absolute'
      };
    },

    // Import the 'isSettingActive' getter from the Vuex store
    ...mapGetters(['isSettingActive']),

    hasIsSettingActiveGetter() {
      // if the 'isSettingActive' getter exists, false otherwise.
      return this.$store.getters.hasOwnProperty('isSettingActive');
    },

    isEmptyContent() {
      const content = this.thread.body.replace(/<[^>]*>/g, '').trim();
      return content.length === 0;
    }
  },

  components: {
    'elea-ticket-thread-summary' : EleaTicketThreadSummary,

    'svg-icon-handler' : SvgIconHandler,

    'delete-modal': DeleteModal,

    AddMedia,

    'rating-component': RatingComponent,

    'attachment': AttachmentBlock,

    'activity-parser': ActivityParser,
  }
};
</script>

<style scoped>

.ellips {
  color: #999;
}

#redactioninfo {
  padding-top: 10px;
  font-style: italic;
}

.dropdown-item:hover {
  background-color: transparent !important; /* Set the background color to transparent */
  color: inherit !important; /* Use the default text color */
  text-decoration: none !important; /* Remove underline if any */
  cursor: pointer;
}

.dropadded {
  position: absolute;
  background: #f8f9fa;
  border: 1px solid #d7d7d7;
}

#thread_img {
  margin-top: -3px;
}

.hover-card {
  position: relative;
  display: inline-block;
}

.hover-card-content {
  position: absolute;
  left: 100px;
  top: -29px;
  display: none;
  background-color: #f9f9f9;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
  padding: 10px;
  white-space: nowrap;
}

.hover-card:hover .hover-card-content {
  display: block;
}

.email-wrapper {
  display: flex;
  align-items: center;
}

.email {
  margin-left: 5px;
}

.pointer {
  cursor: pointer;
  color: #999 !important;
}

.thread_rating {
  margin-top: -13px;
}

.thread_right {
  display: flex;
  margin-top: 5px;
}

.mt_4 {
  margin-top: -4px;
}

.rating_dropdown {
  background: transparent !important;
  border: none !important;
  box-shadow: unset !important;
  margin-top: -5px;
  font-size: 14px !important;
}

.rating_body {
  width: max-content;
  left: unset !important;
  right: -1px !important;
}

.thread_time {
  font-size: 12px;
  color: #999999;
}

.margin_5px {
  margin-right: 5px;
  margin-left: 5px;
}

#thread_head_name {
  color: #3c8dbc !important;
}
</style>

<style>
.redacted-text {
  background-color: #eca5a5 !important;
  border: 1px solid red !important;
}

blockquote p {
  font-size: 14px !important;
}

.timeline-body table:not([cellpadding]) th, .timeline-body table:not([cellpadding]) td{
  padding: 0.4rem;
}

.timeline-body table:not([border]) td, .timeline-body table:not([border]) th {
  border: 1px solid black;
}

.timeline-body table:not([border]){
  border: 1px solid black;
  border-collapse: collapse !important;
}

.thread_desc table {
  border-collapse: separate;
}

.timeline>div>.timeline-item>.timeline-body ol,
.timeline>div>.timeline-item>.timeline-body ul,
.timeline>div>.timeline-item>.timeline-body>dl {
  margin-bottom: 1rem;
}

.timeline > div > .timeline-item > .timeline-body div:not(.alert) {
	margin-bottom: 1rem;
}

.timeline > div > .timeline-item > .timeline-body .alert div {
	margin-bottom: 0; /* Reset margin for divs inside .alert */
}

.timeline>div>.timeline-item>.timeline-body img,
.timeline>div>.timeline-item>.timeline-body p{
  max-width: 100%;
}

blockquote{
  border-left: 1px solid #3c8dbc !important;
}

.align-left {
  float: left !important;
}
.internal-Note{
  background-color: rgba(0, 0, 0, .03)!important;
}
.descrp{
  padding-top: 10px!important;
}

.lang-dropdown::-webkit-scrollbar-track{
  background-color: #f1f1f1;
  border-radius: 10px;
}

.lang-dropdown::-webkit-scrollbar{
  width: 6px;
  background-color: #f1f1f1;
}

.lang-dropdown::-webkit-scrollbar-thumb{
  background-color: #c1c1c1;
  border-radius: 10px;
}

.elea-dropdown-menu{
  top: -30px !important;
  right: 20px !important;
}

.summary-dropdown {
  padding: 4px 12px;
  cursor: pointer;
}

.dropdown-item.summary-dropdown:hover {
  background: #d6d5d5 !important;
}

.summary-submenu {
  position: relative;
}

.summary-submenu .summary-menu {
  top: -30px;
  right: 100%;
  left: auto;
  margin-top: -1px;
}

.lang-dropdown{
  max-height: 200px;
  overflow-y: auto;
  padding-top: 0;
}

.redact-dropdown-item{
  padding: .25rem 1rem !important;
}

</style>