/*global tinymce, module, require, define, global, self */

;(function (f) {
    'use strict';

    // CommonJS
    if (typeof exports === 'object' && typeof module !== 'undefined') {
        module.exports = f(require('jquery'));

        // RequireJS
    } else if (typeof define === 'function'  && define.amd) {
        define(['jquery'], f);

        // <script>
    } else {
        var g;
        if (typeof window !== 'undefined') {
            g = window;
        } else if (typeof global !== 'undefined') {
            g = global;
        } else if (typeof self !== 'undefined') {
            g = self;
        } else {
            g = this;
        }

        f(g.jQuery);
    }

})(function ($) {
    'use strict';

    var AutoComplete = function (ed, options) {
        this.editor = ed;

        this.options = $.extend({}, {
            source: [],
            delay: 500,
            queryBy: 'name',
            // items: 10
        }, options);

        this.options.insertFrom = this.options.insertFrom || this.options.queryBy;

        this.matcher = this.options.matcher || this.matcher;
        this.sorter = this.options.sorter || this.sorter;
        this.renderDropdown = this.options.renderDropdown || this.renderDropdown;
        this.render = this.options.render || this.render;
        this.insert = this.options.insert || this.insert;
        this.highlighter = this.options.highlighter || this.highlighter;

        this.query = '';
        this.hasFocus = true;

        this.renderInput();

        this.bindEvents();
    };

    AutoComplete.prototype = {

        constructor: AutoComplete,

        renderInput: function () {
            var rawHtml =  '<span class="autocomplete" id="autocomplete">' +
                '<span id="autocomplete-delimiter">' + this.options.delimiter + '</span>' +
                '<span id="autocomplete-searchtext"><span class="dummy">\uFEFF</span></span>' +
                '</span>';

            this.editor.execCommand('mceInsertContent', false, rawHtml);
            this.editor.focus();
            this.editor.selection.select(this.editor.selection.dom.select('span#autocomplete-searchtext span')[0]);
            this.editor.selection.collapse(0);

        },

        bindEvents: function () {
            this.editor.on('keyup', this.editorKeyUpProxy = $.proxy(this.rteKeyUp, this));
            this.editor.on('keydown', this.editorKeyDownProxy = $.proxy(this.rteKeyDown, this), true);
            this.editor.on('click', this.editorClickProxy = $.proxy(this.rteClicked, this));

            $('body').on('click', this.bodyClickProxy = $.proxy(this.rteLostFocus, this));

            $(this.editor.getWin()).on('scroll', this.rteScroll = $.proxy(function () { this.cleanUp(true); }, this));
        },

        unbindEvents: function () {
            this.editor.off('keyup', this.editorKeyUpProxy);
            this.editor.off('keydown', this.editorKeyDownProxy);
            this.editor.off('click', this.editorClickProxy);

            $('body').off('click', this.bodyClickProxy);

            $(this.editor.getWin()).off('scroll', this.rteScroll);
        },

        rteKeyUp: function (e) {
            switch (e.which || e.keyCode) {
                //DOWN ARROW
                case 40:
                //UP ARROW
                case 38:
                //SHIFT
                case 16:
                //CTRL
                case 17:
                //ALT
                case 18:
                    break;

                //BACKSPACE
                case 8:
                    if (this.query === '') {
                        this.cleanUp(true);
                    } else {
                        this.lookup();
                    }
                    break;

                //TAB
                case 9:
                //ENTER
                case 13:
                    var item = (this.$dropdown !== undefined) ? this.$dropdown.find('li.active') : [];
                    if (item.length) {
                        this.select(item.data());
                        this.cleanUp(false);
                    } else {
                        this.cleanUp(true);
                    }
                    break;

                //ESC
                case 27:
                    this.cleanUp(true);
                    break;

                default:
                    this.lookup();
            }
        },

        rteKeyDown: function (e) {
            switch (e.which || e.keyCode) {
                //TAB
                case 9:
                //ENTER
                case 13:
                //ESC
                case 27:
                    e.preventDefault();
                    break;

                //UP ARROW
                case 38:
                    e.preventDefault();
                    if (this.$dropdown !== undefined) {
                        this.highlightPreviousResult();
                    }
                    break;
                //DOWN ARROW
                case 40:
                    e.preventDefault();
                    if (this.$dropdown !== undefined) {
                        this.highlightNextResult();
                    }
                    break;
            }

            e.stopPropagation();
        },

        rteClicked: function (e) {
            var $target = $(e.target);

            if (this.hasFocus && $target.parent().attr('id') !== 'autocomplete-searchtext') {
                this.cleanUp(true);
            }
        },

        rteLostFocus: function () {
            if (this.hasFocus) {
                this.cleanUp(true);
            }
        },

        lookup: function () {
            const delimiterIndex = this.editor.selection.getRng(true).startOffset;
            const text = this.editor.selection.getRng(true).startContainer.data || '';
            const delimiter = this.options.delimiter;
            const queryStart = text.lastIndexOf(delimiter, delimiterIndex - 1) + 1;
            this.query = text.substring(queryStart, delimiterIndex).trim();

            if (this.$dropdown === undefined) {
                this.show();
            }

            clearTimeout(this.searchTimeout);
            this.searchTimeout = setTimeout($.proxy(function () {
                // Added delimiter parameter as last argument for backwards compatibility.
                var items = $.isFunction(this.options.source) ? this.options.source(this.query, $.proxy(this.process, this), this.options.delimiter) : this.options.source;
                if (items) {
                    this.process(items);
                }
            }, this), this.options.delay);
        },

        matcher: function (item) {
            return ~item[this.options.queryBy].toLowerCase().indexOf(this.query.toLowerCase());
        },

        process: function (data) {
            if (!this.hasFocus) {
                return;
            }

            var _this = this,
                result = [],
                items = $.grep(data, function (item) {
                    return _this.matcher(item);
                });

            items = _this.sorter(items);

            items = items.slice(0, this.options.items);

            $.each(items, function (i, item) {
                var $element = $(_this.render(item, i));

                $element.html($element.html().replace($element.text(), _this.highlighter($element.text())));

                $.each(items[i], function (key, val) {
                    $element.attr('data-' + key, val);
                });

                result.push($element[0].outerHTML);
            });

            if (result.length) {
                this.$dropdown.html(result.join('')).show();
            } else {
                this.$dropdown.hide();
            }
        },


        sorter: function (items) {
            var beginswith = [],
                caseSensitive = [],
                caseInsensitive = [],
                item;

            while ((item = items.shift()) !== undefined) {
                if (!item[this.options.queryBy].toLowerCase().indexOf(this.query.toLowerCase())) {
                    beginswith.push(item);
                } else if (~item[this.options.queryBy].indexOf(this.query)) {
                    caseSensitive.push(item);
                } else {
                    caseInsensitive.push(item);
                }
            }

            return beginswith.concat(caseSensitive, caseInsensitive);
        },

        highlighter: function (text) {
            return text.replace(new RegExp('(' + this.query.replace(/([.?*+^$[\]\\(){}|-])/g, '\\$1') + ')', 'ig'), function ($1, match) {
                return '<strong>' + match + '</strong>';
            });
        },

        show: function () {
            var offset = this.editor.inline ? this.offsetInline() : this.offset();

            this.$dropdown = $(this.renderDropdown())
                .css({ 'top': offset.top, 'left': offset.left });

            $('body').append(this.$dropdown);

            this.$dropdown.on('click', $.proxy(this.autoCompleteClick, this));
        },

        renderDropdown: function () {
            return '<ul class="rte-autocomplete dropdown-menu"><li class="loading"></li></ul>';
        },

        render: function (item, index) {
            return '<li style="position: relative;">' +
                '<a href="javascript:;" style="display: block; padding: 3px 20px; clear: both; font-weight: normal; line-height: 20px; color: #333; white-space: nowrap; text-decoration: none;">' +
                '<span>' + item[this.options.queryBy] + '</span>' +
                '</a>' +
                '<style>' +
                'li:hover a {background-color: #0081c2; }' +
                '</style>' +
                '</li>';
        },


        autoCompleteClick: function (e) {
            var item = $(e.target).closest('li').data();
            if (!$.isEmptyObject(item)) {
                this.select(item);
                this.cleanUp(false);
            }
            e.stopPropagation();
            e.preventDefault();
        },

        highlightPreviousResult: function () {
            var $items = this.$dropdown.find('li');
            var currentIndex = $items.index($items.filter('.active'));
            var index = (currentIndex === 0) ? $items.length - 1 : currentIndex - 1;

            $items.removeClass('active').eq(index).addClass('active');

            // Scroll into view
            var $activeItem = $items.eq(index);
            var dropdownTop = this.$dropdown.scrollTop();
            var dropdownBottom = dropdownTop + this.$dropdown.height();
            var itemTop = $activeItem.position().top + dropdownTop;
            var itemBottom = itemTop + $activeItem.outerHeight();

            if (itemTop < dropdownTop) {
                this.$dropdown.scrollTop(itemTop);
            } else if (itemBottom > dropdownBottom) {
                this.$dropdown.scrollTop(itemBottom - this.$dropdown.height());
            }
        },

        highlightNextResult: function () {
            var $items = this.$dropdown.find('li');
            var currentIndex = $items.index($items.filter('.active'));
            var index = (currentIndex === $items.length - 1) ? 0 : currentIndex + 1;

            $items.removeClass('active').eq(index).addClass('active');

            // Scroll into view
            var $activeItem = $items.eq(index);
            var dropdownTop = this.$dropdown.scrollTop();
            var dropdownBottom = dropdownTop + this.$dropdown.height();
            var itemTop = $activeItem.position().top + dropdownTop;
            var itemBottom = itemTop + $activeItem.outerHeight();

            if (itemTop < dropdownTop) {
                this.$dropdown.scrollTop(itemTop);
            } else if (itemBottom > dropdownBottom) {
                this.$dropdown.scrollTop(itemBottom - this.$dropdown.height());
            }
        },

        select: function (item) {
            this.editor.focus();
            var selection = this.editor.dom.select('span.autocomplete')[0];
            this.editor.dom.remove(selection);
            this.editor.execCommand('mceInsertContent', false, this.insert(item));
        },

        insert: function (item) {

            return '<strong>' + '<a title="mention_link" href='+item.route_path+'>' + item[this.options.insertFrom] + '' + '</a></strong>&nbsp;';
        },

        cleanUp: function (rollback) {
            this.unbindEvents();
            this.hasFocus = false;

            if (this.$dropdown !== undefined) {
                this.$dropdown.remove();
                delete this.$dropdown;
            }

            if (rollback) {
                var text = this.query,
                    $selection = $(this.editor.dom.select('span.autocomplete'));

                if (!$selection.length) {
                    return;
                }

                var replacement = $('<p>' + this.options.delimiter + text + '</p>')[0].firstChild,
                    focus = $(this.editor.selection.getNode()).offset().top === ($selection.offset().top + (($selection.outerHeight() - $selection.height()) / 2));

                this.editor.dom.replace(replacement, $selection[0]);

                if (focus) {
                    this.editor.selection.select(replacement);
                    this.editor.selection.collapse();
                }
            }
        },

        offset: function () {
            var rtePosition = $(this.editor.getContainer()).offset(),
                contentAreaPosition = $(this.editor.getContentAreaContainer()).position(),
                nodePosition = $(this.editor.dom.select('span.autocomplete')).position();

            return {
                top: rtePosition.top + contentAreaPosition.top + nodePosition.top + $(this.editor.selection.getNode()).innerHeight() - $(this.editor.getDoc()).scrollTop() + 5,
                left: rtePosition.left + contentAreaPosition.left + nodePosition.left
            };
        },

        offsetInline: function () {
            var nodePosition = $(this.editor.dom.select('span.autocomplete')).offset();

            return {
                top: nodePosition.top + $(this.editor.selection.getNode()).innerHeight() + 5,
                left: nodePosition.left
            };
        }

    };

    /*
    Note: We have included the plugin in the same JavaScript file as the TinyMCE
    instance for display purposes only. Tiny recommends not maintaining the plugin
    with the TinyMCE instance and using the `external_plugins` option.
    */
    tinymce.PluginManager.add('mention', (editor, url) => {
        var autoComplete,autoCompleteData = editor.getParam('mentions');

        // If the delimiter is undefined set default value to ['@'].
        // If the delimiter is a string value convert it to an array. (backwards compatibility)
        autoCompleteData.delimiter = (autoCompleteData.delimiter !== undefined) ? !$.isArray(autoCompleteData.delimiter) ? [autoCompleteData.delimiter] : autoCompleteData.delimiter : ['@'];

        function prevCharIsSpace() {
            var start = editor.selection.getRng(true).startOffset,
                text = editor.selection.getRng(true).startContainer.data || '',
                charachter = text.substr(start > 0 ? start - 1 : 0, 1);

            return (!!$.trim(charachter).length) ? false : true;
        }

        editor.on('keypress', function (e) {
            var delimiterIndex = $.inArray(String.fromCharCode(e.which || e.keyCode), autoCompleteData.delimiter);
            if (delimiterIndex > -1 && prevCharIsSpace()) {
                if (autoComplete === undefined || (autoComplete.hasFocus !== undefined && !autoComplete.hasFocus)) {
                    e.preventDefault();
                    // Clone options object and set the used delimiter.
                    autoComplete = new AutoComplete(editor, $.extend({}, autoCompleteData, { delimiter: autoCompleteData.delimiter[delimiterIndex] }));
                }
            }
        });
    });
});

