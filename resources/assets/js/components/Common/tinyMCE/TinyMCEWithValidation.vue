<template>
    <form-field-template :label="label" :labelStyle="labelStyle" :name="name" :classname="classname" :hint="hint" :required="required" :isInlineForm="isInlineForm" :tipRule="tipRule"
    :labelLength="labelLength">

    <file-manager-container v-if="mediaOption && panel != 'client'"
                            v-on:filesChosen="getAttachmentInfo"
    />

    <ValidationProvider :name="name" :rules="rules" v-model="editorValue">
      <template v-slot="{ field, errorMessage, meta, classes }">

        <transition name="fade">
          <div v-if="showMsg" class="full-screen-msg-block">
            <span class="full-screen-msg">Press <strong>Esc</strong> to exit Full Screen mode</span>
          </div>
        </transition>

        <div class="tinyMce-editor-valid" :key="id">
          <editor :id="id" :init="options" v-model="editorValue" @onChange="onChange(editorValue, name)" :name="name" :class="errorMessage ? 'field-danger' : ''" />

          <!-- This template section defines a suggestion card that appears when `showSuggestionCard` is true.The card displays a suggestion with options to insert or dismiss it.-->
          <div v-if="showSuggestionCard" class="suggestion-card card-light card" :style="{ top: suggestionCardPosition.top, left: suggestionCardPosition.left }">
            <!-- Card header displaying the suggestion error -->
            <div class="card-header suggestion-box-header">
              <div class="card-title">
                <h6 class="pt-2"><i class="fas fa-wand-magic-sparkles"></i>&nbsp; <span class="error-text">{{ suggestionError }}</span></h6>
              </div>
            </div>
            <!-- Card body displaying the suggestion text -->
            <div class="card-body suggestion-box p-2">
              <div class="suggest-text" @click="insertSuggestion(suggestionIndex)" v-html="suggestionText"></div>
            </div>
            <!-- Card footer with buttons to insert or dismiss the suggestion -->
            <div class="card-footer suggestion-box-footer p-1">
              <!-- Button to insert the suggestion -->
              <div class="float-end">
                <button class="btn btn-tool" v-tooltip="trans('insert')" @click="insertSuggestion(suggestionIndex)">
                  <i class="fas fa-arrow-right-to-bracket fa-rotate-270 text-muted"></i>
                </button>
                <!-- Button to dismiss the suggestion -->
                <button class="btn btn-tool" v-tooltip="trans('dismiss')" @click="ignoreSuggestion(suggestionIndex)">
                  <i class="fas fa-trash text-muted"></i>
                </button>
              </div>
            </div>
          </div>
        </div>

        <span v-if="errorMessage" class="error-block is-danger">{{errorMessage}}</span>

      </template>
    </ValidationProvider>

    <template v-if="loading">
      <custom-loader duration="4000" />
    </template>

    <template v-for="(attachment,index) in attachmentsArr">

      <div id='hidden-attach' contenteditable='false' v-if="attachment.disposition !== 'inline'">

        {{attachment.name}}({{attachment.size ? attachment.size : attachment.file_size}} bytes)

        <i class='fa fa-times close-icon' aria-hidden='true' @click='removeAttachment(index)'></i>
      </div>
    </template>

  </form-field-template>
</template>

<script>

import Editor from '@tinymce/tinymce-vue';
import { plugins, editorProps } from "./tinyMceDefaults";
import FormFieldTemplate from "../../MiniComponent/FormField/FormFieldTemplate.vue";
import FileManagerContainer from "../../Agent/Filemanager/FileManagerContainer.vue";
import  {mapGetters,mapActions,mapMutations,mapState} from "vuex";
import 'tinymce/themes/silver';
import {customImageUploadHandler, getSystemLanguage} from "../../../helpers/extraLogics";
import {iconsList} from "./tinyMCEIcons";
import {eleaGrammarCheck, eleaBetterReply, eleaTranslate } from "../../../../../../app/Plugins/EleaAssistant/views/js/eleaAssistConfig";
import tinymce from "tinymce";

export default {

  name: "tiny-editor-with-validation",

  description: 'TinyMCE Editor With Validations',

  props: {

    ...editorProps,

    label: { type: String, default: '' },

    name: { type: String, required: false },

    value: { type: String, required: false },

    isInlineForm: { type: Boolean, default: false },

    required: { type: Boolean, default: false },

    rules: { type: String, default: '' },

    hint: { type: String, default: '' },

    /**
     * for show labels of the fields
     * @type {Object}
     */
    labelStyle:{type:Object},

    /**
     * classname of the form field. It can be used to give this component any bootstrap class or a custom class
     * whose css will be defined in parent class
     * @type {String}
     */
    classname: { type: String, default: "" },

    /**
     * The function which will be called as soon as value of the field changes
     * It should have two arguments `value` and `name`
     *     `value` will be the updated value of the field
     *     `name` will be thw name of the state in the parent class
     *
     * An example function :
     *         onChange(value, name){
     *             this[name]= selectedValue
     *         }
     *
     * @type {Function}
     */
    onChange: { type: Function, Required: true },

    mediaOption: { type: [Boolean, Number], default: false },

    attachments : { type : Array, default : ()=> []},

    getAttach : { type : Function },

    panel : { type : String, default : '' },

      /**
       * For restricting Editor to resolve URLs to relative or absolute URL
       * @see https://www.tiny.cloud/docs-3x/reference/Configuration3x/Configuration3x@convert_urls/
       */
       convertURLs : {type : Boolean, default : true},

	    labelLength : { type : [Number, String], default : 500 },

      //FOR TOOLTIP POSITION
      tipRule : { type : [Number, Boolean], default : false },

       id: { type: String, default: 'tiny_editor' },

       from : { type: String, default: 'ticket' }
  },

  created () {
    this.getCsrfToken();
  },

  data() {
    return {
      loading: false,
      attachmentsArr : this.attachments,
      editorValue : this.value,
      options: {},
      showMsg: false,
      url: `${this.basePath()}/api/tiny-image-uploader?_token=${document.querySelector('meta[name="csrf-token"]').getAttribute('content')}&auth=false&api_key=${this.getApiKey}`,
      fetchedContents: [],
      currentIndex: 0,
      languages: [],
      showSuggestionCard: false,
      suggestionText: '',
      suggestionIndex: null,
      grammarContent: [],
      grammarContentIndex : 0,
      suggestionError: '',
      suggestionCardPosition: { top: '0px', left: '0px' },
      isTranslated: false,

    }
  },

  beforeMount() {
    this.attachmentsArr=this.getAttachmentsData !=null ? this.getAttachmentsData :this.attachments;

    const self = this;

    this.options = {

      max_height: self.height,
      min_height: self.height,
      menubar: (self.showMenubar) ? 'file edit view insert format tools table help' : false,
      menu: {
        view: {
          title: 'View',
          items: 'code | visualchars visualblocks | preview'
        },
      },
      // this is to ensure that the text doesn't overlap at all in email clients
      formats: {
        fontsize: { inline: 'span', styles: { 'font-size': '%value', 'line-height': 'normal' } },
      },
      toolbar_sticky: self.toolbarSticky,
      autosave_ask_before_unload: self.autoSaveAskBeforeUnload,
      autosave_interval: self.autoSaveInterval,
      autosave_prefix: 'tinymce-autosave-{path}{query}-{id}-',
      autosave_restore_when_empty: self.autoSaveRestoreWhenEmpty,
      autosave_retention: self.autoSaveRetention,
      image_advtab: self.imageAdvancedTab,
      template_cdate_format: '[Date Created (CDATE): %m/%d/%Y : %H:%M:%S]',
      template_mdate_format: '[Date Modified (MDATE): %m/%d/%Y : %H:%M:%S]',
      image_caption: self.imageCaption,
      quickbars_selection_toolbar: 'bold italic | quicklink h2 h3 blockquote quickimage quicktable',
      extended_valid_elements: 'div[onclick|style|class=toc|contenteditable]',
      noneditable_noneditable_class: 'mceNonEditable',
      toolbar_mode: self.toolbarMode,
      contextmenu: false,

      // Custom styles for the editor content
      content_style:  `
            /* Loader styles */
            .loader {
               width: 20px;
               aspect-ratio: 4;
               background: radial-gradient(circle closest-side,#3c8dbc 90%,#0000) 0/calc(100%/3) 100% space;
               clip-path: inset(0 100% 0 0);
               animation: l1 1s steps(4) infinite;
               display: inline-block;
               padding-left: 5px;
            }

            /* Keyframes for loader animation */
            @keyframes l1 {to{clip-path: inset(0 -34% 0 0)}}

             /* Loader text styles */
            .loader-text {
                text-align: left;
                font-size: 10px;
                color: #000;
                padding: 2px;
                display: inline-block;
                font-family: roboto;
                background-color: #d6d5d5 !important;
            }

            /* Suggestion card styles */
            .suggestion-card {
            border: 1px solid #eee;
            border-radius: 6px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin: 10px;
            padding: 10px;
            max-height: 200px;
            overflow-y: auto;
            }

            /* Suggestion title styles */
            .suggestion-title {
              font-weight: bold;
              margin-bottom: 5px;
            }

            /* Suggestion content styles */
            .suggestion-content {
              max-height: 150px;
              overflow-y: auto;
            }

            /* Grammerly UI styles */
            .elea-suggest {
              position: relative;
              cursor: pointer;
              text-decoration: underline;
              text-decoration-thickness: 3px;
              text-underline-offset: 3px;
              text-decoration-color: red;
            }

            .elea-suggest::after {
              content: '';
              position: absolute;
              left: 0;
              bottom: -3px;
              width: 100%; /* Set the width to 100% initially */
              height: 3px; /* Match the thickness of the underline */
              background-color: red; /* Match the underline color */
              animation: underlineAnimation 0.7s ease-in-out; /* Apply the animation */
              box-shadow: 0 1px 2px rgba(255, 0, 0, 0.5);
            }

            @keyframes underlineAnimation {
               from {
                width: 0;
               }
               to {
                width: 100%;
               }
            }

            /* Suggestion error styles */
            .elea-suggest:hover{
                background-color: #f9cbcb;
            }
              ${self.contentStyle}
            `,
      draggable_modal: self.draggableModal,
      elementpath: self.elementPath,
      height: self.height,
      resize: self.resize,
      branding: self.branding,
      browser_spellcheck: self.browserSpellcheck,
      custom_undo_redo_levels: self.customUndoRedoLevels,
      paste_data_images: self.pasteDataImages,
      statusbar: self.statusbar,
      auto_focus:self.autoFocus,
      automatic_uploads: self.automaticUploads,
      relative_urls: self.relativeUrls,
      remove_script_host: self.removeScriptHost,
      document_base_url: self.basePath(),

      /**
       * Custom handler for image uploads.
       * @param {BlobInfo} blobInfo - Information about the uploaded blob.
       * @param {Function} progress - Function to track the upload progress.
       * @returns {Promise} - A promise that resolves when the upload is complete.
       */
      images_upload_handler: (blobInfo, progress) => customImageUploadHandler(blobInfo, progress, self.url),
      convert_urls : self.convertURLs,
      plugins: (self.page !== 'kb') ? plugins.filter(element => element !== 'media') : plugins,
      text_patterns: self.textpattern_patterns,

      // Highlight the editor on focus.
      highlight_on_focus: self.highlight_on_focus,

      // Language setting for the editor.
      language: getSystemLanguage(self.appLanguage),

      //Theme setting for the editor.
      theme: 'silver',

      setup: function(editor) {

        if(self.page === 'kb' ){
          editor.ui.registry.addButton("customtoc", {
            text: "ToC",
            onAction: () => editor.execCommand("customtoc"),
          });

          editor.addCommand("customtoc", function () {
            const toc = generateTableOfContents(editor);
            editor.insertContent(toc);
          });
        }

        if(!self.areAllSettingsInactive){

          // Register custom icons for the TinyMCE editor
          for (const [name, svg] of Object.entries(iconsList)) {
            editor.ui.registry.addIcon(name, svg);
          }

          // Load available languages for the editor
          self.loadLanguage();

          // Add a custom menu button for AI features
          editor.ui.registry.addMenuButton('aiIcon', {
            icon: 'ai_icon',
            tooltip: 'Elea AI',
            onSetup: function(api){
              const isAuthenticated = self.isUserLoggedIn ? true : false;
              api.setEnabled(isAuthenticated);
            },
            // Fetches the menu items for the AI features.
            fetch: function (callback) {

              const editor = tinymce.get(self.id);
              const contentLength = editor.getContent().length;

              const isBetterReplyActive = self.hasIsSettingActiveGetter && self.isSettingActive('better_ticket_reply_key');

              const isTranslateActive = self.hasIsSettingActiveGetter && self.isSettingActive('translate_ticket_content_key');

              // Define the menu items for the AI features
              const items = [
                {
                  type: 'menuitem',
                  text: self.lang('expand_text'),
                  icon: 'expand',
                  // Sets up the menu item to be enabled or disabled based on the content length and the setting status.
                  onSetup: function (api) {
                    api.setEnabled((contentLength > 0 && isBetterReplyActive) ? true : false);
                  },
                  // Generates a response to expand the text.
                  onAction: function () {
                    self.generateResponse({ solution: 'expand' });
                  },
                },
                {
                  type: 'menuitem',
                  text: self.lang('rephrase_text'),
                  icon: 'rephrase',

                  // Sets up the menu item to be enabled or disabled based on the content length and the setting status.
                  onSetup: function (api) {
                    api.setEnabled((contentLength > 0 && isBetterReplyActive) ? true : false);
                  },

                  // Generates a response to rephrase the text.
                  onAction: function () {
                    self.generateResponse({ solution: 'rephrase' });
                  },
                },
                ...(self.from !== 'article' ? [{
                  type: 'menuitem',
                  text: self.lang('generate_mail'),
                  icon: 'mail_generate',
                  onSetup: function (api) {
                    api.setEnabled((contentLength > 0 && isBetterReplyActive) ? true : false);
                  },
                  // Generates a response to generate an email.
                  onAction: function () {
                    self.generateResponse({ solution: 'email_generate' });
                  },
                }] : []),
                ...(self.from === 'article' ? [{
                  type: 'menuitem',
                  text: self.lang('generate_article'),
                  icon: 'article_generate',
                  onSetup: function (api) {
                    api.setEnabled((contentLength > 0 && isBetterReplyActive) ? true : false);
                  },

                  // Generates a response to generate an article.
                  onAction: function () {
                    self.generateResponse({ solution: 'article_generate' });
                  },
                }] : []),
                {
                  type: "menuitem",
                  text:self.lang('grammar_check'),
                  icon: 'spell-check',
                  onSetup: function (api) {
                    api.setEnabled((contentLength > 0 && self.hasIsSettingActiveGetter && self.isSettingActive('grammar_spell_check')) ? true : false);
                  },

                  // Generates a response to check the grammar.
                  onAction: function (){
                    self.loadGrammarCorrection();
                  }
                },
                {
                  type: 'nestedmenuitem',
                  text: self.lang('enhance_tone'),
                  icon: 'enhance',
                  onSetup: function (api) {
                    api.setEnabled((contentLength > 0 && isBetterReplyActive) ? true : false);
                  },
                  getSubmenuItems: function () {
                    return [
                      {
                        type: 'menuitem',
                        text: self.lang('professional'),
                        icon: 'formal',
                        onSetup: function (api) {
                          api.setEnabled(true);
                        },

                        // Generates a response with a professional tone.
                        onAction: function () {
                          self.generateResponse({ tone: 'professional' });
                        },
                      },
                      {
                        type: 'menuitem',
                        text: self.lang('casual'),
                        icon: 'casual',

                        // Generates a response with a casual tone.
                        onAction: function () {
                          self.generateResponse({ tone: 'casual' });
                        },
                      },
                      {
                        type: 'menuitem',
                        text: self.lang('friendly'),
                        icon: 'friendly',

                        // Generates a response with a friendly tone.
                        onAction: function () {
                          self.generateResponse({ tone: 'friendly' });
                        },
                      },
                    ];
                  },
                },
                {
                  type: 'nestedmenuitem',
                  text: self.lang('translate'),
                  icon: 'translate',

                  // Sets up the menu item to be enabled or disabled based on the content length and the setting status.
                  onSetup: function (api) {
                    api.setEnabled((contentLength > 0 && isTranslateActive) ? true : false);
                  },

                  // Gets the submenu items for the "Translate" menu item.
                  getSubmenuItems: function () {
                    return self.languages.map(language => ({
                      type: 'menuitem',
                      text: language.name,

                      // Generates a response to translate the text.
                      onAction: function () {
                        self.generateResponse({ translate: language.language });
                      },
                    }));
                  },
                },
              ];
              callback(items);
            }
          });
        }

        editor.on('Keyup', function () {
          self.onChange(editor.getContent(),self.name)
        });

        editor.on('Change', function () {
          self.onChange(editor.getContent(),self.name)
        });

        // Handle escape key to exit full screen tinymce
        editor.on('keydown', function (e) {
          if (e.key === 'Escape' && editor.plugins.fullscreen.isFullscreen()) {
            // If the editor is maximized, minimize it
            editor.execCommand('mceFullScreen');
          }
        });

        //Show popup for exiting full screen
        editor.on('FullscreenStateChanged', (e) => {
          if (e.state) {
            // Maximized
            self.showMsg = true;
            setTimeout(()=>{
              self.showMsg = false;
            }, 3000)
          } else {
            // Minimized
            self.showMsg = false;
          }
        });


        editor.on('focus', function () {

          // Get the editor instance
          const editor = tinymce.get(self.id);

          // Get the selected content element and the suggestion element
          const selectedContentElement = editor.getBody().querySelector('.selected-elea-content');
          const eleaSuggest = editor.getBody().querySelector('.elea-suggest');

          // Close the toolbar if the selected content element is present
          if(selectedContentElement && !self.showLoader) self.closeToolbar();

          // Remove the suggestion if the suggestion element is present
          if(eleaSuggest && !self.showLoader) self.removeSuggestion();

          editor.selection.select(editor.getBody(), true);
          editor.selection.collapse(false);
        });

        editor.on('click', function () {
          // Get the editor instance
          const editor = tinymce.get(self.id);

          // Get the selected content element and the suggestion element
          const selectedContentElement = editor.getBody().querySelector('.selected-elea-content');
          const eleaSuggest = editor.getBody().querySelector('.elea-suggest');

          // Close the toolbar if the selected content element is present
          if(eleaSuggest && !self.showLoader) self.removeSuggestion();

          // Close the toolbar if the selected content element is present
          if(selectedContentElement && !self.showLoader) self.closeToolbar();
        });

        /**
         * Event handler for the 'keydown' event.
         * Prevents typing in the editor when `showLoader` is `true`.
         */
        editor.on('keydown', function (e) {

          if (self.showLoader) e.preventDefault();
        });

        /**
         * Event handler for the 'BeforeExecCommand' event.
         * Prevents executing commands in the editor when `showLoader` is `true`.
         */
        editor.on('BeforeExecCommand', function (e) {
          if (self.showLoader) {
            e.preventDefault();
            return false;
          }
        });
      },

      toolbar: 'undo redo aiIcon bold italic underline strikethrough | customtoc | fontfamily fontsize blocks | align | outdent indent |  numlist bullist | forecolor backcolor removeformat | pagebreak | charmap emoticons | fullscreen  preview save print | insertfile image media link codesample | ltr rtl'
    }
  },

  watch: {
    value: {
      immediate: true,
      handler (value, oldValue) {
        this.editorValue = value;
      }
    },

    editorValue(value) {
      if (value.includes('elea-loader') || value.includes('selected-elea-content') || value.includes('elea-suggest') || value.includes('loader')) {
        // Create a temporary DOM element to manipulate the HTML content
        const tempElement = document.createElement('div');
        tempElement.innerHTML = value;

        // Remove elements with the class 'elea-loader' or 'loader'
        tempElement.querySelectorAll('.elea-loader, .loader').forEach(el => el.remove());

        // Remove elements with the class 'selected-elea-content' but keep their inner content
        tempElement.querySelectorAll('.selected-elea-content').forEach(el => {
          const parent = el.parentNode;
          while (el.firstChild) {
            parent.insertBefore(el.firstChild, el);
          }
          parent.removeChild(el);
        });

        // Remove elements with the class 'elea-suggest' but keep their inner content
        tempElement.querySelectorAll('.elea-suggest').forEach(element => {
          const parent = element.parentNode;
          while (element.firstChild) {
            parent.insertBefore(element.firstChild, element);
          }
          parent.removeChild(element);
        });

        // Remove 'style' and 'data-mce-style' attributes from all elements
        tempElement.querySelectorAll('[style], [data-mce-style]').forEach(element => {
          element.removeAttribute('style');
          element.removeAttribute('data-mce-style');
        });

        // Update the value with the cleaned content
        value = tempElement.innerHTML;
      }

      this.$emit('input', value);
      this.onChange(value, this.name);
    },
  },


  computed: {
    ...mapGetters(['getAttachmentsData','getApiKey','isSettingActive', 'areAllSettingsInactive']),

    // Check if all the AI settings are inactive
    areAllSettingsInactive() {
      return this.$store.getters.hasOwnProperty('areAllSettingsInactive') ? this.areAllSettingsInactive : true;
    },

    // Check if the `isSettingActive` getter is available
    hasIsSettingActiveGetter() {
      return this.$store.getters.hasOwnProperty('isSettingActive');
    }

  },


  methods: {

    getCsrfToken() {

      if(this.getApiKey) {

        this.url = this.basePath() + '/api/tiny-image-uploader?_token=' + document.querySelector('meta[name="csrf-token"]').getAttribute('content')+'&api_key='+this.getApiKey;

      } else {

        this.url = this.basePath() + '/api/tiny-image-uploader?_token=' + document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      }
    },

    removeAttachment(x){

      this.attachmentsArr.splice(x,1);

      this.getAttach(this.attachmentsArr);
    },

    async getAttachmentInfo(filesInfo) {
      let files = JSON.stringify(filesInfo.files);
      this.loading = true
      try {
        let response = await axios.get('file-manager/files-info', {
          params: {names: files, disk: filesInfo.disk}
        })
        let data = response.data.data;
        data.forEach((file) => {this.attachmentsArr.push(file)});
        this.getAttach(this.attachmentsArr);

      } catch (e) {
        await this.$store.dispatch('setAlert', {
          type: 'danger',
          message: this.lang('file-manager-modal-error-message'),
          component_name: 'faveo-form'
        })
      } finally {
        this.loading = false;
      }
    },

    /**
     * Generates a response based on the provided solution, tone, and translation options.
     * @param {Object} options - The options for generating the response.
     * @param {string} options.solution - The type of solution to generate (e.g., 'expand', 'rephrase').
     * @param {string[]} options.tone - The tone to apply to the generated response.
     * @param {string} options.translate - The language to translate the content into.
     */
    generateResponse({solution, tone, translate}) {

      // Show the loader while generating the response
      this.showLoader = true;
      const solutionFor = this.from === 'article' ? 'article' : 'ticket';
      const solutionTemplate = solution || '';
      const lang = translate || '';
      tone = tone || [];

      const editor = tinymce.get(this.id);
      if (editor) {

        const checkContent = editor.getContent({ format: 'text' }).trim();
        const isImageOnly = checkContent === '' && editor.getContent().includes('<img');

        if (isImageOnly) {
          // Show a alert notification on only image
          editor.notificationManager.open({
            text: this.lang('alert-image-content'),
            type: 'warning',
            timeout: 3000
          });
          return;
        }

        // Disable the editor
        editor.mode.set('readonly');

        // Get the selected text or the entire content if no text is selected
        const selectedText = editor.selection.getContent();
        const text = selectedText || editor.getContent();

        // Create a container for the selected content
        const content = editor.selection.getContent() || editor.getContent();
        const selectedContent = document.createElement(selectedText ? 'span' : 'div');
        selectedContent.className = 'selected-elea-content';
        selectedContent.style.display = 'inline-block';
        selectedContent.innerHTML = content;

        // Create a loader element
        const loader = document.createElement('span');
        loader.className = 'elea-loader';
        loader.style.display = 'inline-block';
        loader.innerHTML = `<span id="loader-text" style="display: inline-block;">&nbsp;<b class="text-muted">${this.lang('generating')}</b></span><div class="loader" id="loader" style="display: inline-block"></div>`;

        // Insert the selected content and loader into the editor
        const range = selectedText ? editor.selection.getRng() : document.createRange();
        if (!selectedText) range.selectNodeContents(editor.getBody());
        range.deleteContents();

        const fragment = document.createDocumentFragment();
        fragment.appendChild(selectedContent);
        fragment.appendChild(loader);
        range.insertNode(fragment);

        // Remove any existing suggestions
        if (editor.getBody().querySelector('.elea-suggest')) {
          this.removeSuggestion();
        }

        /**
         * Removes the loader element from the editor.
         * Removes the selected content element from the editor.
         */
        const removeLoader = () => {
          const loaderElement = editor.getBody().querySelector('.elea-loader');
          if (loaderElement) loaderElement.remove();

          const selectedContentElement = editor.getBody().querySelector('.selected-elea-content');
          if (selectedContentElement) selectedContentElement.removeAttribute('style');

          // Re-enable the editor
          editor.mode.set('design');
        };

        // Highlight the selected content
        const selectedContentElement = editor.getBody().querySelector('.selected-elea-content');
        if (selectedContentElement) {
          const walker = document.createTreeWalker(selectedContentElement, NodeFilter.SHOW_TEXT, null, false);
          let node;
          while (node = walker.nextNode()) {
            const span = document.createElement('span');
            span.style.backgroundColor = '#d6d5d5';
            span.style.padding = '2px';
            node.parentNode.replaceChild(span, node);
            span.appendChild(node);
          }
        }

        // Handle the response from the API
        const handleResponse = (newContents) => {
          this.fetchedContents = Array.isArray(newContents) ? newContents.map(content => content.replace(/^```html\n|```$/g, '')) : [].concat(newContents.replace(/^```html\n|```$/g, ''));
          this.isTranslated = !!translate; // Set isTranslated based on whether translate is provided
          this.insertContextToolbar();
          removeLoader();
          this.showLoader = false;
        };

        // Handle errors that occur during the API request
        const handleError = (error) => {
          this.fetchedContents = ["Sorry, I am unable to process your request at the moment. Please try again later."];
          this.insertContextToolbar();
          removeLoader();
          this.showLoader = false;
          console.error('Error fetching new content:', error);
        };

        // Make the API request to generate the response
        if (translate) {
          eleaTranslate(text, lang).then(handleResponse).catch(handleError);
        } else {
          eleaBetterReply(text, solutionFor, solutionTemplate, tone).then(handleResponse).catch(handleError);
        }
      }
    },

    insertContextToolbar() {

      // Get the TinyMCE editor instance by ID
      const editor = tinymce.get(this.id);
      if (!editor) return;

      const self = this;
      let activeIndex = 0;

      // Function to set the active suggestion index and update the UI
      function setActiveIndex(index) {
        activeIndex = index;
        document.querySelectorAll('.suggestion').forEach((el, i) => {
          el.classList.toggle('active-suggestion', i === index);
        });
      }

      // Function to create the HTML for the suggestion panel
      function createSuggestionHTML(fetchedContents) {
        return `
      <div style="display: flex; flex-direction: row; gap: 10px; height: 100%;">
        <div id="suggestion-0" class="suggestion" style="flex: 1; display: flex; flex-direction: column; min-height: 100%; max-height: 100%;" onclick="setActiveIndex(0)">
          ${fetchedContents[1] ? `<h3>${self.lang('suggestion-1')}</h3>` : ''}
          <iframe srcdoc="${fetchedContents[0].replace(/"/g, '&quot;')}" style="width: 100%; height: 100%; border: none;"></iframe>
        </div>
        ${fetchedContents[1] ? `
          <div id="suggestion-1" class="suggestion" style="flex: 1; display: flex; flex-direction: column; min-height: 100%; max-height: 100%" onclick="setActiveIndex(1)">
            <h3>${self.lang('suggestion-2')}</h3>
            <iframe srcdoc="${fetchedContents[1].replace(/"/g, '&quot;')}" style="width: 100%; height: 100%; border: none;"></iframe>
          </div>` : ''}
      </div>`;
      }

      // Function to open a custom dialog with the suggestions
      function openCustomDialog(editor, fetchedContents,  isTranslated = false) {

        // Make setActiveIndex globally accessible
        window.setActiveIndex = setActiveIndex;

        editor.windowManager.open({
          title: isTranslated ? self.lang('translate_content') : self.lang('ai_suggestion'),
          size: 'large',
          body: {
            type: 'panel',
            items: [
              {
                type: 'htmlpanel',
                html: createSuggestionHTML(fetchedContents),
              },
            ],
            classes: 'custom-body-class',
          },
          buttons: [
            {
              type: 'custom',
              name: 'copy',
              icon: 'suggest_copy',
              text:  self.lang('copy'),
              align: 'end',
            },
            {
              type: 'custom',
              text: self.lang('insert'),
              name: 'insert',
              icon: 'suggest_insert',
              align: 'end',
            },
          ],

          // Handle button actions
          onAction: (api, details) => {
            if (details.name === 'insert') {
              self.insertContent(activeIndex);
            } else if (details.name === 'copy') {
              self.copyContent(activeIndex);
            }
            api.close();
          },
          // Handle dialog cancel action
          onCancel() {
            self.closeToolbar();
          },
        });

        // Set the first suggestion as active by default
        document.getElementById('suggestion-0').classList.add('active-suggestion');

	      const iframes = Array.from(document.querySelectorAll('iframe')).filter(iframe => iframe.id !== 'focus_editor_ifr');

	      iframes.forEach((iframe, index) => {

		      iframe.contentWindow.addEventListener('mousedown', () => {

			      setActiveIndex(index);
		      });
	      });
      }

      // Open the custom dialog with the fetched contents
      openCustomDialog(editor, this.fetchedContents, this.isTranslated);
    },

    insertContent(index) {

      // Get the TinyMCE editor instance by ID
      const editor = tinymce.get(this.id);
      if (editor) {
        // Get the content to insert from the fetched contents array
        const contentToInsert = this.fetchedContents[index];

        // Get the text inside the .selected-elea-content element
        const selectedContentElement = editor.getBody().querySelector('.selected-elea-content');
        if (selectedContentElement) {
          // Replace the HTML inside the .selected-elea-content element with contentToInsert
          selectedContentElement.innerHTML = contentToInsert;

          // Remove the 'div' or 'span' elements with the 'selected-elea-content'
          const body = editor.getBody();
          const elements = body.querySelectorAll('.selected-elea-content');
          elements.forEach(element => {
            const parent = element.parentNode;
            // Move all child nodes of the element to its parent
            while (element.firstChild) {
              parent.insertBefore(element.firstChild, element);
            }
            // Remove the empty element
            parent.removeChild(element);
          });

          // Remove the 'style' and 'data-mce-style' attributes from all elements
          const styledElements = body.querySelectorAll('[style], [data-mce-style]');
          styledElements.forEach(element => {
            element.removeAttribute('style');
            element.removeAttribute('data-mce-style');
          });

          // Set the cleaned content back to the editor
          editor.setContent(body.innerHTML);

          // Show a success notification
          editor.notificationManager.open({
            text: 'Content Inserted Successfully',
            type: 'success',
            timeout: 3000
          });
        }
        // Close the toolbar
        this.closeToolbar();
      }
    },

    copyContent(index) {
      // Get the TinyMCE editor instance by ID
      const editor = tinymce.get(this.id);
      if (!editor) return;

      // Get the content to copy from the fetched contents array
      const contentToCopy = this.fetchedContents[index];

      // Create a temporary element to hold the HTML content
      const tempElement = document.createElement('div');
      tempElement.innerHTML = contentToCopy;
      document.body.appendChild(tempElement);

      // Select the content
      const range = document.createRange();
      range.selectNodeContents(tempElement);
      const selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);

      // Copy the content to the clipboard
      document.execCommand('copy');
      // Show a success notification
      editor.notificationManager.open({
        text: this.lang('content-copied-clipboard'),
        type: 'success',
        timeout: 3000
      });

      // Clean up
      selection.removeAllRanges();
      document.body.removeChild(tempElement);
      // Close the toolbar and clear the fetched contents
      this.closeToolbar();
      this.fetchedContents = [];
    },

    closeToolbar() {
      const editor = tinymce.get(this.id);
      if (!editor) return;

      this.fetchedContents = [];

      // Get the body of the editor
      const body = editor.getBody();

      // Remove elements with 'selected-elea-content' class and move their children to the parent
      body.querySelectorAll('.selected-elea-content').forEach(element => {
        const parent = element.parentNode;
        while (element.firstChild) {
          parent.insertBefore(element.firstChild, element);
        }
        parent.removeChild(element);
      });

      // Remove 'style' and 'data-mce-style' attributes
      body.querySelectorAll('[style], [data-mce-style]').forEach(element => {
        element.removeAttribute('style');
        element.removeAttribute('data-mce-style');
      });

      // Set the cleaned content back to the editor
      editor.setContent(body.innerHTML);
      editor.selection.setCursorLocation(null, body.innerHTML.length);

      this.currentIndex = 0;
    },

    async loadLanguage() {
      // Fetch the list of languages from the Vuex store
      const response = await this.$store.getters.isLanguageList;

      // Filter out the languages that are not 'auto' and update the languages array
      this.languages = response.filter(language => language.language !== 'auto');
    },

    loadGrammarCorrection() {

      this.showLoader = true;

      // Get the TinyMCE editor instance by ID
      const editor = tinymce.get(this.id);

      // Remove any existing suggestions
      if (editor.getBody().querySelector('.elea-suggest')) {
        this.removeSuggestion();
      }
      const content = editor.getContent();

      const checkContent = editor.getContent({ format: 'text' }).trim();
      const isImageOnly = checkContent === '' && editor.getContent().includes('<img');

      if (isImageOnly) {
        // Show a alert notification on only image
        editor.notificationManager.open({
          text: this.lang('alert-image-content'),
          type: 'warning',
          timeout: 3000
        });
        return;
      }

      // Disable the editor
      editor.mode.set('readonly');

      // Create and insert the loader
      const loader = document.createElement('span');
      loader.className = 'elea-loader';
      loader.style.display = 'inline-block';
      loader.innerHTML = `<span id="loader-text" style="display: inline-block;">&nbsp;<b class="text-muted">${this.lang('checking')}</b></span><div class="loader" id="loader" style="display: inline-block"></div>`;

      // Create and insert the selected content element
      const selectedContent = document.createElement('div');
      selectedContent.className = 'selected-elea-content';
      selectedContent.style.display = 'inline-block';
      selectedContent.innerHTML = content;

      // Replace the editor content with the selected content and loader
      const range = document.createRange();
      range.selectNodeContents(editor.getBody());
      range.deleteContents();
      const fragment = document.createDocumentFragment();
      fragment.appendChild(selectedContent);
      fragment.appendChild(loader);
      range.insertNode(fragment);

      // Function to remove loader and selected content elements
      const removeElements = () => {
        // Log the inner HTML of the editor's body to verify the insertion
        editor.getBody().querySelectorAll('.elea-loader').forEach(el => el.remove());

        // Remove elements with the class 'selected-elea-content' but keep their inner content
        editor.getBody().querySelectorAll('.selected-elea-content').forEach(el => {
          const parent = el.parentNode;
          while (el.firstChild) {
            parent.insertBefore(el.firstChild, el);
          }
          parent.removeChild(el);
        });

        this.showLoader = false;
        // Re-enable the editor
        editor.mode.set('design');
      };

      // Check if grammar spell check is active and perform grammar check
      if (content && !content.includes('elea-suggest') && this.hasIsSettingActiveGetter && this.isSettingActive('grammar_spell_check')) {
        eleaGrammarCheck(content).then(suggestions => {
          if (suggestions.data.suggestions.length === 0) {

            removeElements();
            editor.notificationManager.open({
              text: this.lang('no_grammar_found'),
              type: 'info',
              timeout: 3000
            });
          } else {

            removeElements();
            // Display grammar suggestions
            this.displayGrammarSuggestionBox(suggestions.data);
          }
        }).catch(error => {
          removeElements();
          editor.notificationManager.open({
            text: this.lang(error.response.data.message || 'error-occured-checking-grammer'),
            type: 'warn',
            timeout: 3000
          });
        })
      } else {
        removeElements();
      }
    },

    displayGrammarSuggestionBox(correctedText) {
      const editor = tinymce.get(this.id);
      if (!editor) return;

      let content = editor.getContent();
      let isValid = true;
      let fromLargeData = false;

      let grammarResponse = correctedText;

      if (correctedText.original.length < 150) {

        let originalContent = editor.getContent({ format: 'text' });

        // Define the content to insert
        content = `<span class="elea-suggest" data-suggestion="${correctedText.proofread}" data-error="grammar error" data-index="1">${originalContent}</span>`;

        editor.setContent(content);

      }else{
        let largerData = grammarResponse.suggestions;

        fromLargeData = true;

        largerData.forEach(({original, suggestion, error}, index) => {
          const escapedOriginal = original.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // Escape special regex characters
          const regex = new RegExp(`(${escapedOriginal})(?![^<]*>)`, 'gi'); // Match the original text case-insensitively, excluding tags

          // Check if the original text is already enclosed in a span with the elea-suggest class
          const alreadyEnclosedRegex = new RegExp(`<span class="elea-suggest"[^>]*>.*${escapedOriginal}.*<\/span>`, 'gi');
          if (!content.match(alreadyEnclosedRegex)) {
            // Check if the replacement will cause nested elea-suggest spans
            if (content.match(regex)) {
              content = content.replace(regex, (match) => {
                // Check if the match is already inside an elea-suggest span
                const parentSpan = match.match(/<span class="elea-suggest"[^>]*>.*<\/span>/);
                if (parentSpan) {
                  return match; // Return the match as is to avoid nesting
                }
                return `<span class="elea-suggest" data-suggestion="${suggestion}" data-error="${error}" data-index="${index}">${match}</span>`;
              });
            } else {
              isValid = false;
            }
          }
        });
      }

      if (isValid) {
        if(fromLargeData){
          editor.setContent(content);
        }

        // Add event listeners for showing/hiding suggestions
        editor.getBody().querySelectorAll('.elea-suggest').forEach(element => {
          element.addEventListener('mouseenter', (event) => this.showSuggestion(event));
          element.addEventListener('mouseleave', () => this.hideSuggestionCardWithDelay());
        });
      } else {

        let errorMessage = 'Error occurred while checking grammar';

        editor.notificationManager.open({
          text: errorMessage,
          type: 'warn',
          timeout: 3000
        });
      }
    },

    /**
     * Displays a suggestion card near the target element when a suggestion is hovered over.
     *
     * @param {Event} event - The event object containing details about the hovered element.
     */
    showSuggestion(event) {
      // Extract suggestion details from the event target's dataset
      const { suggestion, index, error } = event.target.dataset;
      this.suggestionText = suggestion;
      this.suggestionIndex = index;
      this.suggestionError = error;

      // Get the bounding rectangle of the target element
      const rect = event.target.getBoundingClientRect();
      // Get the content window of the TinyMCE editor
      const editorWindow = tinymce.get(this.id).contentWindow;

      // Define the dimensions of the suggestion card
      const suggestCardHeight = 140;
      const suggestCardWidth = 300;
      // Get the dimensions of the editor window
      const editorHeight = editorWindow.innerHeight;
      const editorWidth = editorWindow.innerWidth;

      // Calculate the midpoint coordinates of the target element
      let midpointX = rect.left;
      let midpointY = rect.top + rect.height;

      // Adjust the vertical position of the suggestion card if it overflows the editor height
      if (midpointY + suggestCardHeight > editorHeight) {
        midpointY -= 35;
      } else {
        midpointY += 94;
      }

      // Adjust the horizontal position of the suggestion card if it overflows the editor width
      if (midpointX + suggestCardWidth > editorWidth) {
        midpointX -= (midpointX + suggestCardWidth - editorWidth);
      }

      // Set the position of the suggestion card
      this.suggestionCardPosition = {
        top: `${midpointY}px !important`,
        left: `${midpointX}px !important`
      };

      // Show the suggestion card
      this.showSuggestionCard = true;

      // Add event listeners to keep the suggestion card visible or hide it with a delay
      this.$nextTick(() => {
        const suggestionCard = document.querySelector('.suggestion-card');
        if (suggestionCard) {
          suggestionCard.addEventListener('mouseenter', this.keepSuggestionCardVisible);
          suggestionCard.addEventListener('mouseleave', this.hideSuggestionCardWithDelay);
        }
      });
    },

    // Delays hiding the suggestion card by a specified timeout.
    hideSuggestionCardWithDelay() {
      this.hideSuggestionCardTimeout = setTimeout(this.hideSuggestionCard, 200); // Adjust the delay as needed
    },

    // effectively hiding the suggestion card from the view.
    hideSuggestionCard() {
      this.showSuggestionCard = false;
    },

    // Prevents the suggestion card from hiding when the mouse enters the card.
    keepSuggestionCardVisible() {
      clearTimeout(this.hideSuggestionCardTimeout);
    },

    // Insert the suggestion into the editor content at the specified index.
    insertSuggestion(index) {
      const editor = tinymce.get(this.id);
      if (!editor) return;

      const suggestElement = editor.getBody().querySelector(`.elea-suggest[data-index="${index}"]`);
      if (suggestElement) {
        suggestElement.outerHTML = suggestElement.getAttribute('data-suggestion');
      }
      this.hideSuggestionCard();
    },

    // Ignore the suggestion at the specified index and remove the suggestion element.
    ignoreSuggestion(index) {
      const editor = tinymce.get(this.id);
      if (!editor) return;

      const suggestElement = editor.getBody().querySelector(`.elea-suggest[data-index="${index}"]`);
      if (suggestElement) {
        suggestElement.outerHTML = suggestElement.textContent;
      }
      this.hideSuggestionCard();
    },

    // Remove all suggestion elements from the editor content.
    removeSuggestion() {
      const editor = tinymce.get(this.id);
      if (!editor) return;

      editor.getBody().querySelectorAll('.elea-suggest').forEach(element => {
        const parent = element.parentNode;
        while (element.firstChild) {
          parent.insertBefore(element.firstChild, element);
        }
        parent.removeChild(element);
      });
    }
  },

  components: {
    'editor': Editor,
    'form-field-template': FormFieldTemplate,

    "file-manager-container" : FileManagerContainer
  },
}

function generateTableOfContents(editor) {
	const headings = editor.getBody().querySelectorAll("h1, h2, h3, h4, h5, h6");
	if (!headings.length) return "";
	let toc = "<div class='mce-toc' contenteditable='false'><h2 contenteditable='true'>Table of Contents</h2><ul>";
	headings.forEach((heading, index) => {
		const id = `toc_${index}`;
		heading.setAttribute("id", id);
		const headingText = heading.innerText.trim();
		if (headingText) {
			toc += `<li><a href="#${id}" class="toc_link">${headingText}</a></li>`;
		}
	});
	toc += "</ul></div>";

	return toc;
}
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

.tox .tox-editor-header{
  z-index: 1!important;
}

.tox .tox-dialog__body-nav-item:nth-child(4) {
  display: none !important;
}

.tox .tox-dialog--width-lg{
  max-width: 1000px!important;
}

.tox .tox-dialog--width-lg {
  max-width: 1000px !important;
}

.tox.tox-fullscreen{
  height: 100vh!important; /* on maximizing */
  z-index: 10000!important;
}

.full-screen-msg{
  padding: 10px;
  background-color: rgba(0,0,0,0.7);
  border-radius: 25px;
}

.full-screen-msg-block{
  position:fixed;
  z-index: 10000000;
  top: 20%;
  left: 50%;
  transform: translateX(-50%);
  color: white;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
}

body.tox-fullscreen .card {
  position: static !important; /* when tinymce is in full screen, it doesn't cause overlapping issue */
  z-index: auto !important;
}

.tox-tinymce{
  border-radius: 0.25rem !important;
}

.tox .tox-menu.tox-collection.tox-collection--list{
  max-height: 300px !important;
}

.content-dropdown {
  margin-top: 20px;
}
.content-navigation {
  display: flex;
  justify-content: space-between;
}
.content-actions {
  margin-top: 10px;
}

#context-toolbar{
  position : absolute;
  z-index : 1300;
  margin: 0;
  background-color: #fff;
  border: 1px solid #eee;
  border-radius: 6px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.suggestion-card {
  position: absolute;
  background-color: #fff;
  border: 1px solid #eee;
  border-radius: 6px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  z-index: 1000;
}

.suggestion-box{
  max-width: 300px;
  width: max-content;
  max-height: 140px;
  min-width: 300px;
  min-height: 50px;
  overflow-x: auto;
  overflow-y: auto;
  padding: 10px;
}

.suggestion-box::-webkit-scrollbar-track{
  background-color: #f1f1f1;
  border-radius: 10px;
}

.suggestion-box::-webkit-scrollbar{
  width: 6px;
  background-color: #f1f1f1;
}

.suggestion-box::-webkit-scrollbar-thumb{
  background-color: #c1c1c1;
  border-radius: 10px;
}

.selected-elea-content {
  background-color: Highlight;
  color: HighlightText;
}

.suggestion-box-header{
  border-bottom: none;
  padding: 0 8px;
}

.suggestion-box-footer{
  border-top: none;
}

.custom-body-class .tox-form__group {
  height: 100% !important;
}

.custom-body-class .suggestion {
  border: 1px solid transparent;
  cursor: pointer;
}

.custom-body-class .active-suggestion {
  border: 3px solid #007BFF; /* Change the color and width as needed */
  padding: 5px;
  border-radius: 10px;
}

@keyframes l3 {
  20% { background-position: 0% 0%, 50% 50%, 100% 50%; }
  40% { background-position: 0% 100%, 50% 0%, 100% 50%; }
  60% { background-position: 0% 50%, 50% 100%, 100% 0%; }
  80% { background-position: 0% 50%, 50% 50%, 100% 100%; }
}

.suggest-text{
  cursor: pointer;
  font-weight: bold;
  color: #3c8dbc;
}

.error-text{
  font-weight: 700;
}

.tox .tox-spinner>div {
  animation: tam-bouncing-dots 1.5s ease-in-out 0s infinite both;
  background-color: #3c8dbc !important;
  border-radius: 100%;
  height: 8px;
  width: 8px;
}

.elea-suggest {
  position: relative;
  cursor: pointer;
  text-decoration: underline;
  text-decoration-color: red;
  text-decoration-thickness: 3px;
  text-underline-offset: 3px;
}

.elea-suggest::after {
  content: '';
  position: absolute;
  left: 0;
  bottom: -3px;
  width: 100%;
  height: 3px;
  background-color: red;
  animation: underlineAnimation 0.7s ease-in-out;
  box-shadow: 0 1px 2px rgba(255, 0, 0, 0.5);
}

@keyframes underlineAnimation {
  from {
    width: 0;
  }
  to {
    width: 100%;
  }
}

.tinyMce-editor-valid{
  position: relative;
}

.elea-suggest:hover {
  background-color: #f9cbcb;
}
</style>