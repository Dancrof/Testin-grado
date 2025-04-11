<template>

    <div v-if="!widgetLoad && widgetData" class="widget-UI">

        <div class="dpmsg-Screen">

            <div class="dpmsg-ScreenContent">

                <div class="scrollarea">

                    <div class="scrollarea-content">

                        <div class="dpmsg-ScreenHeader" :style="{ 'background-color' : widgetData.color_code }">

                            
                            <span class="dpmsg-ScreenHeaderTitle-pad">
                                
                                <a v-if="showBack" class="text-white back-link" href="javascript:;" @click="backToHome()">

                                    <i class="fas fa-arrow-circle-left back-icon"></i>
                                </a>Get In Touch
                            </span>
                        </div>

                        <div class="block-container">
                            
                            <div v-if="!showTicket" class="dpmsg-Block">
                                
                                <div class="dpmsg-BlockWrapper">
    
                                    <div class="fixed-kb">
                                        
                                        <div class="dpmsg-BlockHeader" :style="{ 'border-bottom' : '2px solid '+ widgetData.color_code }">KnowledgeBase</div>
                                        
                                        <div class="dpmsg-QuickSearchControl">
                                            
                                            <div class="dpmsg-QuickSearchControl--wrapper">
                                                
                                                <input class="dpmsg-QuickSearchControl--input" id="quickSearchInput" v-model="search_text" type="text"
                                                       @input="handleSearch">
                                                
                                                <label class="dpmsg-QuickSearchControl--label" for="quickSearchInput">
                                                    
                                                    <i class="fas fa-search" :style="{ 'color' : widgetData.color_code }"></i>
                                                    
                                                    <span aria-hidden="true">Search</span>
                                                </label>
                                                
                                                <i class="dpmsg-Icon dpmsg-IconSearchClear"></i>
                                            </div>
                                            
                                            <div v-if="loadKb" class="text-center p-3">
                                                
                                                <loader :color="widgetData.color_code" :size="30"></loader>
                                            </div>
                                            
                                            <div v-if="search_text && !loadKb && !articleList.length" class="dpmsg-QuickSearchControl--hint">
                                                
                                                <span>No results for {{ search_text }}</span>
                                            </div>
                                        </div>
                                    </div>
    
                                    <div v-if="!loadKb && articleList.length" class="dpmsg-QuickSearchResults">
    
                                        <template v-for="article in showAll ? articleList.slice().reverse() : articleList.slice(0,3).reverse()">
    
                                            <div class="dpmsg-QuickSearchEntry">
    
                                                <h4 class="dpmsg-QuickSearchEntryHeaderLink">
    
                                                    <a :title="article.name.length > 130 ? article.name : ''" rel="noreferrer noopener" target="_blank" :href="chatUrl+'/show/'+article.slug" :style="{ 'color' : widgetData.color_code }">
    
                                                        {{article.name.length > 130 ? article.name.substring(0,130) + '...' : article.name }}
                                                    </a>
                                                </h4>
    
                                                <div class="dpmsg-QuickSearchExcerpt">
                                                    {{ getSubStr(strippedText(article.description)) }}
                                                </div>
    
                                                <div class="dpmsg-QuickSearchEntry--divider"></div>
                                            </div>
                                        </template>
    
                                        <a v-if="!showAll && articleList.length > 3" class="dpmsg-QuickSearchFooter" href="javascript:;" @click="showAllArticles()" :style="{ 'color' : widgetData.color_code }">See more results</a>
                                    </div>
                                </div>
                            </div>
    
                            <div v-if="!showAll" class="dpmsg-Block">

                            <div class="dpmsg-BlockWrapper">

                                <div class="dpmsg-BlockHeader" :style="{ 'border-bottom' : '2px solid '+ widgetData.color_code }">Submit a Ticket</div>

                                <div v-if="!showTicket" class="dpmsg-BlockText">Submit an enquiry via our contact form</div>

                                <a v-if="!showTicket" class="dpmsg-Button Button-FullWidth Button--primary" @click="updateTicket()"
                                   title="Submit an enquiry via our contact form" href="javascript:;" :style="{ 'background' : widgetData.color_code }">Submit a New ticket</a>

                                <template v-if="showTicket">

                                    <faveo-form-client-panel panel="client" category="ticket" :layout="layoutDetails" :isInlineForm="false" formId="chat-widget" :apiKey="apiKey"
                                        :form_category="form_category">

                                    </faveo-form-client-panel>
                                </template>
                            </div>
                        </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="dpmsg-ScreenFooter">
                
                <template v-if="whiteLabel"> <span class="dpmsg-ScreenFooterText">{{ trans('all_rights_reserved') }}</span> </template>

                <template v-else>

                    <span class="dpmsg-ScreenFooterText">{{trans('powered_by')}}&nbsp;</span>
                    
                    <a href="https://www.faveohelpdesk.com" target="_blank" rel="noreferrer noopener">Faveo</a>
                </template>
            </div>
        </div>
    </div>
</template>

<script>

import axios from 'axios';

import FaveoFormClientPanel from "../Client/FaveoFormClientPanel.vue";

import Loader from "../Client/Pages/ReusableComponents/Loader.vue";
export default {

    name : 'widget-ui',
    
    props : {
        
        whiteLabel : { type : Boolean , default : false},
    },

    components: {

        'faveo-form-client-panel' : FaveoFormClientPanel,

        'loader' : Loader
    },

    data () {

        return {

            originalHtml: '<p>This is <strong>HTML</strong> content with an <img src="image.jpg" alt="An image"></p>',

            search_text : '',

            showAll: false,

            showBack: false,

            showTicket: false,

            widgetLoad: true,

            widgetData: '',

            articleList: [],

            loadKb: true,

            chatUrl: '',

            chatId: '',

            timeoutId: null,

            layoutDetails : {},
            
            widgetSource : '',
            
            apiKey: '',
	        
	        form_category: ''
        }
    },

    beforeMount() {

        // Get the value of the 'params' parameter from the iframe URL
        let urlParams = new URLSearchParams(window.location.search);

        this.chatUrl = urlParams.get('chat_url');

        this.chatId = urlParams.get('chat_id');

        let chatData = urlParams.get('chat_data');

        this.widgetData = chatData ? JSON.parse(chatData) : '';
	    
        this.apiKey = this.widgetData.api_key ? this.widgetData.api_key : '';
		
        this.form_category = this.widgetData.form_category ? this.widgetData.form_category : '';
        
        this.$store.dispatch('setApiKey', this.apiKey)
        
        this.widgetLoad= false;

        this.layoutDetails = {

            portal : {

                client_button_border_color: this.widgetData.color_code,

                client_button_color: this.widgetData.color_code,

                client_input_field_color: this.widgetData.color_code
            }
        }

        this.getKbData();
        
        this.getSource();
    },

    methods : {
        
        getSubStr(str) {
            
            if(str) {
          
                return str.length > 110 ? str.substring(0,110) + '...' : str
            }
        },

        getSource() {
        
            axios.get('/api/dependency/sources?api_key='+this.apiKey).then(res=>{
                
                this.widgetSource = res.data.data.sources.find(obj => obj.name === "Widget");
                
                if(this.widgetSource) {

                    this.$store.dispatch('setSource', this.widgetSource.id)
                }
                
            }).catch(err=>{
               
                this.widgetSource = "";
            });
        },
        
        handleSearch() {
            // Clear any previous timeout
            clearTimeout(this.timeoutId);

            // Set a new timeout to call the API after 5 seconds
            this.timeoutId = setTimeout(() => {

                if(this.search_text){
                    this.getKbData('/api/search',{'s' : this.search_text}, true);
                } else {
                    this.getKbData();
                }
            }, 1);
        },

        strippedText(value) {

            const strippedText = value.replace(/<\/?[^>]+(>|$)/g, '');

            return strippedText;
        },

        getKbData(endPoint = '/api/article-list-with-category', obj = {}, search = false ) {

            this.loadKb = true;

            let params = obj;

            axios.get(this.chatUrl+endPoint,{params}).then(res=>{

                this.loadKb=false;

                this.articleList = search ? res.data.data.articles.data.filter(obj=>obj.type) : res.data.data.articles.filter(obj=>obj.type);

            }).catch(err=>{

                this.loadKb=false;
            });
        },

        showAllArticles() {

            this.showTicket = false;

            this.showAll = this.showBack = true;

            this.getKbData()
        },

        backToHome() {

            this.showAll = this.showBack = this.showTicket = false;
        },

        updateTicket() {

            this.showAll = false;

            this.showTicket = this.showBack = true;
        }
    }
}
</script>

<style>

.widget-UI { height: 100%; overflow: hidden; }

.dpmsg-ColorSwatchGrid, .dpmsg-ColorSwatchItem, .dpmsg-Level, .dpmsg-LevelItem, .dpmsg-LevelBottom, .dpmsg-LevelTop, .dpmsg-LevelLeft, .dpmsg-LevelRight, .dpmsg-TriggerBtn-wrapper, .dpmsg-TriggerBtn, .dpmsg-AnimationDiv, .dpmsg-Control, .dpmsg-ScreenWrap, .dpmsg-Screen, .dpmsg-ScreenContent, .dpmsg-ScreenHeader, .dpmsg-ScreenHeaderLogo, .dpmsg-ScreenHeaderTitle, .dpmsg-ScreenHeaderTitle-pad, .dpmsg-ScreenHeaderText, .dpmsg-ScreenFooter, .dpmsg-ScreenLine, .dpmsg-ScreenFooterText, .dpmsg-VertLine, .dpmsg-ScreenFooterLogo, .dpmsg-ScreenIconRow, .dpmsg-ScreenControls, .dpmsg-StartChatScreen-FormMessage, .dpmsg-Block, .dpmsg-BlockWrapper, .dpmsg-BlockInnerHeader, .dpmsg-BlockInnerContent, .dpmsg-BlockInnerIcon, .dpmsg-BlockText, .dpmsg-ChatMessagesDropZone, .dpmsg-AvatarHeadsList, .dpmsg-AvatarHeadsIcon, .dpmsg-MessagePrompt, .dpmsg-PromptHeader, .dpmsg-PromptContentAgree, .dpmsg-PromptBtn, .dpmsg-PromptContentEvaluation, .dpmsg-PromptText, .dpmsg-PromptLeftAligned, .dpmsg-MessageBubble, .dpmsg-MessageBubbleRow, .dpmsg-AvatarCol, .dpmsg-BubbleCol, .dpmsg-BubbleAttachment, .dpmsg-BubbleItem, .dpmsg-BubbleNotification, .dpmsg-AvatarText, .dpmsg-AvatarTextTyping, .dpmsg-AvatarHeadText, .dpmsg-WrapGreetings, .dpmsg-GreetingsBubbleTime, .dpmsg-GreetingsBubble, .dpmsg-GreetingsBubbleRow, .dpmsg-GreetingsAvatarCol, .dpmsg-GreetingsBubbleCol, .dpmsg-GreetingsBubbleItem, .dpmsg-WrapGreetingsArea, .dpmsg-GreetingsArea, .dpmsg-GreetingsActions, .dpmsg-AutoStart, .dpmsg-AutoStartHeader, .dpmsg-AutoStart-close, .dpmsg-AutoStart-widget, .dpmsg-WrapInput, .dpmsg-InputError, .dpmsg-Input, .dpmsg-GroupInputs, .dpmsg-LabelInputText, .dpmsg-InputCheckbox, .dpmsg-InputCheckboxText, .dpmsg-InputCheckboxMarker, .dpmsg-WrapTextarea, .dpmsg-MainTextarea, .dpmsg-TextareaActions, .dpmsg-ChatMessagesWrapper, .dpmsg-QuickSearchControl, .dpmsg-QuickSearchResults, .dpmsg-Icon, .dpmsg-IconArrow, .dpmsg-IconRocket, .dpmsg-IconBadge, .dpmsg-IconBadgeWrap, .dpmsg-IconMail, .dpmsg-IconEmail, .dpmsg-IconMute, .dpmsg-IconHeadset, .dpmsg-IconEllipsis, .dpmsg-IconPlus, .dpmsg-IconPlusRound, .dpmsg-IconClose, .dpmsg-IconCloseFatty, .dpmsg-IconEdit, .dpmsg-IconLock, .dpmsg-IconRefresh, .dpmsg-IconSearchClear, .dpmsg-IconTag, .dpmsg-IconOpen, .dpmsg-IconUnlink, .dpmsg-IconLink, .dpmsg-IconSettings, .dpmsg-IconNotes, .dpmsg-IconSmile, .dpmsg-IconSadSmile, .dpmsg-IconAttach, .dpmsg-IconArrowCircle, .dpmsg-IconSend, .dpmsg-IconPaperclip, .dpmsg-Button, .dpmsg-Content {
    -webkit-animation: none 0s ease 0s 1 normal none running;
    animation: none 0s ease 0s 1 normal none running;
    background: transparent none repeat 0 0 / auto auto padding-box border-box scroll;
    border: none;
    border-collapse: collapse;
    border-image: none;
    border-radius: 0;
    border-spacing: 0;
    bottom: auto;
    box-shadow: none;
    box-sizing: border-box;
    caption-side: top;
    clear: none;
    clip: auto;
    color: #5f768a;
    -webkit-columns: auto;
    columns: auto;
    -webkit-column-count: auto;
    column-count: auto;
    -webkit-column-fill: balance;
    column-fill: balance;
    -webkit-column-gap: normal;
    column-gap: normal;
    -webkit-column-rule: medium none currentColor;
    column-rule: medium none currentColor;
    column-span: 1;
    -webkit-column-width: auto;
    column-width: auto;
    content: none;
    cursor: auto;
    display: inline;
    display: initial;
    float: none;
    font-family: Rubik, "Helvetica", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
    font-size: 16px;
    font-style: normal;
    -webkit-font-feature-settings: normal;
    font-feature-settings: normal;
    font-variant: normal;
    font-weight: normal;
    font-stretch: normal;
    line-height: 1.2;
    height: auto;
    -webkit-hyphens: none;
    -ms-hyphens: none;
    hyphens: none;
    left: auto;
    list-style: none;
    margin: 0;
    max-height: none;
    max-width: none;
    min-height: 0;
    min-width: 0;
    opacity: 1;
    outline: none;
    overflow: visible;
    overflow-x: visible;
    overflow-y: visible;
    padding: 0;
    position: static;
    right: auto;
    table-layout: auto;
    text-align: left;
    text-align-last: auto;
    text-decoration: none;
    text-indent: 0;
    text-shadow: none;
    text-transform: none;
    top: auto;
    -webkit-transform: none;
    transform: none;
    -webkit-transform-origin: 50% 50% 0;
    transform-origin: 50% 50% 0;
    -webkit-transform-style: flat;
    transform-style: flat;
    transition: none;
    vertical-align: baseline;
    visibility: visible;
    white-space: normal;
    width: auto;
    word-spacing: normal;
    z-index: auto;
}

.dpmsg-Screen {
    background-color: #eee;
    display: flex;
    flex-direction: column;
    height: 100%;
    overflow: hidden;
    padding-top: 0;
    border-radius: 10px;
}

.dpmsg-ScreenContent {
    align-self: flex-start;
    height: 100%;
    overflow: hidden;
    position: relative;
    width: 100%;
}

.dpmsg-ScreenContent > .scrollarea {
    height: 100%;
    overflow-x: hidden;
    overflow-y: auto;

}

.scrollarea::-webkit-scrollbar-track
{
    background-color: #f1f1f1;
    border-radius:10px;
}

.scrollarea::-webkit-scrollbar
{
    width: 6px;
    background-color: #f1f1f1;
}

.scrollarea::-webkit-scrollbar-thumb
{
    background-color: #c1c1c1;
    border-radius: 10px;
}

.dpmsg-ScreenHeader {
    flex-direction: row;
    padding: 0 25px 65px 30px;
    background-color: #3d88f3;
    display: flex;
    flex-wrap: wrap;
    margin-bottom: -50px;
    padding: 0 25px 15px 30px;
    width: 100%;
    position: fixed;
    z-index: 999;
}

.dpmsg-ScreenHeaderTitle, .dpmsg-ScreenHeaderTitle-pad {
    color: #fff;
}

.dpmsg-ScreenHeaderLogo, .dpmsg-ScreenHeaderTitle, .dpmsg-ScreenHeaderTitle-pad {
    flex: 0 0 auto;
}

.dpmsg-ScreenHeaderTitle,.dpmsg-ScreenHeaderTitle-pad {
    letter-spacing: 0;
    padding: 0;
}
.dpmsg-ScreenHeaderTitle {
    flex: 0 0 100%;
    font-size: 24px;
    max-width: 270px;
}

.dpmsg-ScreenHeaderTitle-pad {
    flex: 0 0 100%;
    font-size: 24px;
    max-width: 270px;
    padding: 18px 0 8px;
}

.fixed-kb {
    top: 70px;
    position: -webkit-sticky;
    position: sticky;
    z-index: 100;
    background: white;
}
.dpmsg-Block {
    background-color: #fff;
    border: 1px solid #e0e0e0;
    border-radius: 4px;
    box-shadow: 0 4px 8px 1px rgba(51, 51, 62, 0.1);
    display: block;
    margin: 0 10px 10px 10px;
    padding: 17px 20px 20px;
    position: relative;
}

.dpmsg-BlockWrapper {
    display: block;
    position: relative;
}

.dpmsg-BlockHeader, .dpmsg-BlockInnerHeader {
    color: #4c4f50;
    display: flex;
    font-size: 18px;
    letter-spacing: 0.4px;
    margin-bottom: 15px;
    padding-bottom: 13px;
    position: relative;
}

.dpmsg-BlockText {
    color: #4c4f50;
    display: block;
    font-size: 16px;
    margin-bottom: 16px;
}

.dpmsg-Button.Button-FullWidth {
    display: block;
    width: 100%;
}

.dpmsg-Button.Button--primary {
    background: #3d88f3;;
    color: #fefefe;
}
.dpmsg-Button {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 4px;
    color: #333;
    cursor: pointer;
    display: inline-block;
    font-size: 16px;
    line-height: 100%;
    padding: 10px 1rem;
    text-align: center;
    transition: 0.2s ease all;
}

.dpmsg-QuickSearchControl {
    font-family: Rubik, sans-serif;
    position: relative;
    width: calc(100% - 20px);
}

.dpmsg-QuickSearchControl .dpmsg-QuickSearchControl--wrapper {
    position: relative;
}

.dpmsg-QuickSearchControl .dpmsg-QuickSearchControl--input {
    background: #fff;
    border: 1.5px solid #d3d6d7;
    border-radius: 4px;
    color: #4c4f50;
    font-family: Rubik, sans-serif;
    font-size: 16px;
    outline: none;
    padding: 13px 46px;
    width: 100%;
}

.dpmsg-QuickSearchControl .dpmsg-QuickSearchControl--label {
    background-color: #fff;
    border: none;
    color: #3d88f3;
    font-size: 16px;
    height: 16px;
    left: 17px;
    padding: 0;
    position: absolute;
    top: 15px;
    width: 16px;
}

.dpmsg-QuickSearchControl .dpmsg-QuickSearchControl--label i {
    height: 16px;
    width: 16px;
}

.dpmsg-QuickSearchControl .dpmsg-QuickSearchControl--label span {
    display: none;
}

.dpmsg-QuickSearchControl .dpmsg-QuickSearchControl--hint {
    color: #4c4f50;
    font-family: Rubik, sans-serif;
    font-size: 14px;
    font-style: italic;
    font-weight: normal;
    margin-top: 15px;
    word-break: break-all;
}

.dpmsg-QuickSearchControl .dpmsg-IconSearchClear {
    display: none;
    position: absolute;
    right: 15px;
    top: 15px;
}
.dpmsg-IconSearchClear {
    background-image: unset;
    content: "";
    cursor: pointer;
    height: 16px;
    width: 16px;
}
[class^="dpmsg-Icon"] {
    background-repeat: no-repeat;
    background-size: contain;
    display: inline-block;
}
.dpmsg-Icon {
    display: inline-block;
    flex-shrink: 0;
    height: 17px;
    vertical-align: top;
    width: 17px;
}

.dpmsg-QuickSearchControl .dpmsg-QuickSearchControl--wrapper:hover .dpmsg-IconSearchClear, .dpmsg-QuickSearchControl .dpmsg-QuickSearchControl--wrapper.focused .dpmsg-IconSearchClear {
    display: block !important;
}

.dpmsg-QuickSearchResults {
    font-family: Rubik, sans-serif;
    margin-top: 7px;
}

.dpmsg-QuickSearchResults .dpmsg-QuickSearchEntry {
    margin-top: 15px;
}

.dpmsg-QuickSearchResults .dpmsg-QuickSearchEntry .dpmsg-QuickSearchEntryHeaderLink {
    font-size: 14px;
    font-weight: 400;
    line-height: 150%;
    margin: 0 0 3px 0;
    max-width: calc(100% - 20px);
}

.dpmsg-QuickSearchResults .dpmsg-QuickSearchEntry .dpmsg-QuickSearchEntryHeaderLink a {
    text-decoration: none;
    word-wrap: break-word;
}

.dpmsg-QuickSearchResults .dpmsg-QuickSearchEntry .dpmsg-QuickSearchExcerpt {
    color: #4c4f50;
    font-size: 12px;
    height: 34px;
    line-height: 150%;
    overflow: hidden;
    padding-right: 12px;
    position: relative;
    text-align: justify;
}

.dpmsg-QuickSearchResults .dpmsg-QuickSearchEntry .dpmsg-QuickSearchExcerpt::after {
    background: white;
    content: "";
    height: 10px;
    margin-top: 5px;
    position: absolute;
    right: 0;
    width: 10px;
}

.dpmsg-QuickSearchResults .dpmsg-QuickSearchEntry .dpmsg-QuickSearchEntry--divider {
    background-color: #d3d6d7;
    height: 1px;
    margin-top: 20px;
}

.dpmsg-QuickSearchResults .dpmsg-QuickSearchFooter {
    color: #4c4f50;
    display: block;
    font-size: 14px;
    font-weight: 400;
    margin: 20px 0 0 0;
    text-align: center;
    text-decoration: none;
}

a {
    color: #3d88f3;
}

.dpmsg-Control {
    background-color: #3d88f3;
    border-radius: 4px 4px 0 0;
    color: #fff;
    left: 0;
    position: relative;
    top: 0;
    z-index: 9999;
    height: 40px;
    min-height: 40px;
}


.dpmsg-ScreenControls, .dpmsg-ScreenControls a {
    color: #fff;
}
.dpmsg-ScreenControls {
    flex: 0 0 100%;
}
.dpmsg-Level {
    align-items: center;
    display: flex;
    justify-content: space-between;
}

.dpmsg-ScreenControls .dpmsg-BackBtn.dpmsg-LevelLeft, .dpmsg-ScreenControls a .dpmsg-BackBtn.dpmsg-LevelLeft {
    left: 10px;
    position: relative;
    top: 8px;
}

.dpmsg-ScreenControls, .dpmsg-ScreenControls a {
    color: #fff;
    color: var(--white);
}
.dpmsg-ScreenControls a, .dpmsg-ScreenControls a * {
    cursor: pointer;
    font-size: 24px;
}
.dpmsg-LevelLeft {
    align-items: center;
    display: flex;
    flex-basis: auto;
    flex-grow: 0;
    flex-shrink: 0;
    justify-content: flex-start;
}

.back-icon { font-size: 1.5rem; }

.back-link {
    position: relative;
    top: 2px;
    right: 2%;
    cursor: pointer;
}

.dpmsg-ScreenFooter {
    align-items: center;
    align-self: normal;
    background-color: #eee;
    margin-left: 10px;
    margin-top: auto;
    min-height: 33px;
    padding: 10px 25px 10px;
    /*z-index: 9999;*/
    text-align: center;
}

.dpmsg-ScreenFooterText {
    color: #a9b0b0;
    font-size: 12px;
}

.block-container { position: relative; top: 80px; }

.card-title {
    float: left;
    font-size: 1rem;
    font-weight: 400;
    margin: 0;
}
</style>