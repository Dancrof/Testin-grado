<template>

    <form @submit.prevent class="search-form" role="search" v-click-outside="onClickOutside" :key="componentKey">

        <div class="form-border" :class="searchOpen ? 'form_border' : ''">

            <div class="form-inline">

                <div class="input-group" style="width: 100%;">

                    <input type="text" name="s" class="search-field form-control input-lg" v-model="search"
                           :class="[(language === 'ar') ? 'ms-3' : 'me-3']" id="client_kb_search" :style="inputStyle"
                           :title="lang('enter_search_term')" :placeholder="lang('have_a_question?_type_your_search_term_here')" @click="showAdv"/>

                    <span class="input-group-btn">

						<button type="submit" class="btn btn-custom btn-md btn_font_color" :style="btnStyle" id="client_kb_search_btn"
                                :class="{search_button : language === 'ar'}" @click="searchOnClick">{{lang('search')}}
						</button>
					</span>
                </div>
            </div>

            <div v-if="searchOpen" class="search-advance">

                <div class="row pt-2 pb-2 ps-3">

                    <div class="col-sm-4">

                        <input type="checkbox" class="form-check-input" id="title_and_article" v-model="description" :disabled="name">

                        <label for="title_and_article" class="cursor-pointer">&nbsp;&nbsp;{{lang('article')}}</label>
                    </div>

                    <div class="col-sm-4">

                        <input type="checkbox" class="form-check-input" id="title_only" v-model="name" :disabled="description">

                        <label for="title_only" class="cursor-pointer">&nbsp;&nbsp;{{lang('title_only')}}</label>
                    </div>

                    <div class="col-sm-4">

                        <input type="checkbox" class="form-check-input" id="case_sensitive" v-model="case_sensitive">

                        <label for="case_sensitive" class="cursor-pointer">&nbsp;&nbsp;{{lang('case_sensitive')}}</label>
                    </div>
                </div>

                <div class="row">

                    <dynamic-select :label="lang('category')"
                                    :multiple="false" name="category" id="client_kb_search_category_dropdown"
                                    classname="col-sm-6" apiEndpoint="/api/dependency/categories"
                                    :value="category" :onChange="onChange" :placeholder="lang('search_or_select')"  :required="false" strlength="30">
                    </dynamic-select>

                    <dynamic-select :label="lang('tags')"
                                    :multiple="false" name="tag" id="client_kb_search_tag_dropdown"
                                    classname="col-sm-6" apiEndpoint="/api/dependency/tags"
                                    :value="tag" :onChange="onChange" :placeholder="lang('search_or_select')"  :required="false" strlength="30">
                    </dynamic-select>
                </div>
            </div>

            <a v-if="searchOpen" href="javascript:;" class="search-advance-button text-center" @click="onClickOutside" id="client_kb_search_arrow_btn">

                <i class="fa fa-chevron-circle-up fa-2x" :style="iconStyle"></i>
            </a>

        </div>
    </form>
</template>

<script>

import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";

export default {

    name : 'client-panel-header-search',

    description : 'Client panel search component',

    props : {

        layout : { type : Object , default : ()=>{}},
    },

    data(){

        return {

            search : '',

            inputStyle:{

	            borderColor : this.layout.portal.client_input_field_color,
            },

            language : this.layout.language,

            btnStyle : {

                borderColor : this.layout.portal.client_button_border_color,
	            color : this.layout.portal.client_button_font_color + ' !important',
                backgroundColor : this.layout.portal.client_button_color,
            },

            iconStyle : {

                borderColor : this.layout.portal.client_button_border_color,

                color : this.layout.portal.client_button_color,
            },

            category : '',

            tag : '',

            case_sensitive : false,

            name : false,

            description : false,

            searchOpen : false,

            componentKey : 0,

            search_class : 'form_border',
        }
    },

    watch : {

        '$route.path'(newValue,oldValue){

            if(newValue != '/search'){

                this.search = '';

                this.name = false;

                this.description = false;

                this.case_sensitive = false;

                this.category = '';

                this.tag = '';
            }
        },

        name(newValue,oldValue){
            if(newValue) {
                setTimeout(()=> {
                    document.getElementById('title_and_article').checked = false;
                    document.getElementById('title_and_article').disabled = true;
                    this.description = false;
                },1)
            }
        },

        description(newValue,oldValue){
            if(newValue) {
                setTimeout(()=> {
                    document.getElementById('title_only').checked = false;
                    document.getElementById('title_only').disabled = true;
                    this.name = false;
                },1)
            }
        }
    },

    created () {

        window.emitter.on('doingSearch', this.onClickOutside);
        window.emitter.on("cropModalChanged",this.updateClass);
    },

    methods : {

        updateClass(value) {

            this.search_class = value;
        },

        onClickOutside (event) {

            this.searchOpen = false;
        },

        onChange(value,name){

            this[name]=value;
        },

        showAdv() {

            this.searchOpen = true;
        },

        searchOnClick(){

            this.componentKey += 1;

            if(this.search){

                let paramsObj = {};

                paramsObj['name'] = this.name ? 1 : 0;

                paramsObj['description'] = this.description ? 1 : 0;

                paramsObj['case_sensitive'] = this.case_sensitive ? 1 : 0;

                paramsObj['category'] = this.category ? this.category.name : '';

                paramsObj['tag'] = this.tag ? this.tag.name : '';

                paramsObj['s'] = this.search;

                this.$router.replace({ name: "SearchResult",path: '/search', params: { paramsData: paramsObj }, query: paramsObj});
            }
        }
    },

    components : {

        'dynamic-select' : DynamicSelect
    }
};
</script>
<style scoped>

.input-group>.form-control:not(:last-child) {
    border-top-right-radius: 5px !important;
    border-bottom-right-radius: 5px !important;
}
.form_border{

    z-index: 999 !important;
}

.form-check-input{
  margin-left: -1rem;
	cursor: pointer;
}

.input-group .btn_font_color{
  z-index: 1 !important;
}

.search-advance, .search-advance-button{ display: block !important; }
</style>
