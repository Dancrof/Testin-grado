<template>

    <li class="nav-item dropdown">

        <a class="nav-link font-1">

          <div class="navbar-search-block navbar-search-open global-search-box">

              <div class="input-group input-group-sm global-search-input-group position-absolute">

                <input v-model.trim="searchedText" ref="searchInput" class="form-control" type="search" autofocus :placeholder="trans('search')" @keyup.enter="searchContent()" />

                  <a class="btn btn-light search_button" type="button" @click="searchContent()">

                    <i class="fas fa-search"></i>
                  </a>

                  <a class="btn btn-light search_button" type="button" @click="closeSearchBar">

                    <i class="fas fa-times"></i>
                  </a>


                <div v-if="showLoader" class="loader-overlay">

                  <div class="loader-content">

                    <reuse-loader :animation-duration="6000" :size="20" />
                  </div>
                </div>
              </div>
          </div>

        </a>

        <div class="dropdown-menu dropdown-menu-xl dropdown-menu-right search-data" :class="{'show': isDropdownOpen}">

            <div class="filter_by" v-if="!showSearchby">

                <div class="card-header">

                    <div class="row search-by-btn">

                        <div v-for="item in mainFilter" :key="item" class="ps-1">

                            <div :class="[isSelected(item.id) ? 'btn btn-block btn-primary select-filter' : 'btn btn-block btn-outline-primary select-filter']" @click="selectedFilter(item.id)">
                                {{lang(item.title)}}
                            </div>
                        </div>

                        <div class="ms-auto pe-2">

                            <i class="fas fa-cog search_icon" @click="callFilterData()" v-tooltip="trans('search_filter')"></i>
                        </div>
                    </div>
                </div>

                <div class="scrollable-ul" id="activity_scroll" @scroll="handleScroll">

                    <template v-if="showRecentSearch">

                        <template v-if="recentSearches.length > 0">

							<span class="dropdown-item dropdown-header text-start bg-light">

								<span>{{ trans('recently_searched') }}</span>

								<a href="javascript:;" class="text-primary float-end bg-light" @click="clearSearchHistory()">
									{{trans('clear_all') }}
								</a>
							</span>

                            <div class="dropdown-divider"></div>

                            <template v-for="search in recentSearches.slice(-5).reverse()">

                                <a href="javascript:;" class="dropdown-item" @click="searchText(search)">
                                    <i class="fas fa-search me-2"></i> {{ search }}
                                </a>
                            </template>

                            <div class="dropdown-divider"></div>
                        </template>
                    </template>

                    <template v-if="searchedText && showData && !showLoader">

                        <div v-if="noDataMessage" class="pt-3 pb-2 text-center">{{ noDataMessage }}</div>

                        <template v-if="category === 'all' || 'tickets'">

                            <template v-if="searchResult && searchResult.tickets && searchResult.tickets.count > 0">

							<span class="dropdown-item dropdown-header text-start bg-light">

								<span>{{ lang('tickets') }}</span>

								<a href="javascript:;" class="float-end text-primary" @click="gotoViewAll('tickets')">

									{{trans('view_all') }} ({{searchResult.tickets.total}})
								</a>
							</span>

                                <div class="dropdown-divider"></div>

                                <template v-for="item in searchResult.tickets.data.data.slice(0,category === 'all' ? 3 : 10)" :key="item">

                                    <div  href="javascript:;" class="dropdown-item bg-light">

                                        <i class="fas fa-ticket me-2"></i>

                                        <router-link :to="item.view_url" v-tooltip=" item.first_thread.title" id="first_thread_title" @click="closeSearchBar()">

                                        <span class="text-muted fs-8">[#{{item.ticket_number}}]</span>&nbsp

                                                  <span class="text-primary">
											        {{ item.first_thread.title.length > 10 ? item.first_thread.title.substring(0,10) + '...' : item.first_thread.title}}
										          </span>
                                            <span class="text-primary">
                                                ({{item.thread_count}})
                                            </span>

                                        </router-link>

                                        <span class="float-end text-muted fs-8">

											<i class="far fa-clock me-1"></i>{{formattedDate(item.created_at)}}
                                    </span>
                                    </div>
                                </template>

                                <div class="dropdown-divider"></div>
                            </template>

                        </template>

                        <template v-if="category === 'all' || 'contacts'" >

                            <template v-if="searchResult && searchResult.contacts && searchResult.contacts.count > 0" >

							<span class="dropdown-item dropdown-header text-start bg-light">

								<span>{{ lang('contacts') }}</span>

								<a href="javascript:;" class="float-end text-primary" @click="gotoViewAll('contacts')">

									{{trans('view_all') }} ({{searchResult.contacts.total}})
								</a>
							</span>

                                <div class="dropdown-divider"></div>

                                <template v-for="item in searchResult.contacts.data.data.slice(0,category === 'all' ? 3 : 10)" class="content-space">

                                    <div href="javascript:;" class="dropdown-item bg-light">

                                        <i class="fas fa-user-alt me-2"></i>

                                        <router-link :to="item.view_url" id="first_thread_title" @click="closeSearchBar()">

                                        <span class="text-muted fs-8" v-tooltip="item.email? item.email: item.user_name">[{{ item.email ? item.email.length > 15 ? item.email.slice(0,12) + '...' :
                                            item.email : item.user_name ? item.user_name.slice(0,12) + '...' : item.user_name }}]</span> &nbsp

                                            <span class="text-primary" v-tooltip="item.full_name">
												{{ item.full_name.length > 10 ? item.full_name.substring(0,10) + '...' : item.full_name}}
											</span>
                                        </router-link>

                                        <span class="float-end text-muted fs-8">
												<i class="far fa-clock me-1"></i>{{formattedDate(item.created_at)}}
											</span>
                                    </div>
                                </template>
                                <div class="dropdown-divider"></div>
                            </template>

                        </template>

                        <template v-if="category === 'all' || 'articles'">

                            <template v-if="searchResult && searchResult.articles && searchResult.articles.count > 0">

							<span class="dropdown-item dropdown-header text-start">

								<span>{{ lang('articles') }}</span>

								<a href="javascript:;" class="float-end text-primary bg-light" @click="gotoViewAll('articles')">
									{{trans('view_all') }} ({{searchResult.articles.total}})
								</a>
							</span>

                                <div class="dropdown-divider"></div>

                                <template v-for="item in searchResult.articles.data.data.slice(0,category === 'all' ? 3 : 10)" :key="item"  class="content-space">

                                    <div href="javascript:;" class="dropdown-item bg-light">

                                        <i class="fas fa-newspaper me-2"></i>

                                        <a :href="basePath()+item.view_url" target="_blank" @click="closeSearchBar()">

                                            <span class="text-primary fs-8" v-tooltip="item.name">{{ item.name.length > 30 ? item.name.substring(0,30) + '...' : item.name}}</span>

                                        </a>

                                        <span class="float-end text-muted fs-8"><i class="far fa-clock me-1"></i>{{formattedDate(item.publish_time)}}</span>
                                    </div>
                                </template>

                                <div class="dropdown-divider"></div>
                            </template>

                        </template>
                    </template>
                </div>
            </div>


            <div class="search_by" v-if="showSearchby">

                <div v-if="!showLoader" class="card heading-card">

                    <div class="card-header ">

                        <h6> <b>{{trans('search_by')}}</b> <a class="select-btn float-end" @click="toggleSelectAll">{{ lang(selectAllText) }}</a></h6>
                    </div>

                    <div class="card-body filter-data">

                        <div class="scrollable-ul" id="activity_scroll">

                            <div v-for="item in searchBy" :key="item">

                                {{lang(item.key)}}
                                <status-switch :name="item.id" :onChange="onChange" classname="toggle_button float-end" :value="item.is_selected">

                                </status-switch><hr>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer">

                        <div class="btn btn-primary float-end" @click="saveFilters()">

                            <i class="fas fa-save"></i>&nbsp;{{trans('save')}}
                        </div>

                        <div class="btn btn-light float-start" @click="cancelFilters()">

                            <i class="fas fa-times"></i>&nbsp;{{trans('cancel')}}
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </li>

</template>

<script type="text/javascript">
import Switch from "../../../MiniComponent/FormField/Switch.vue";

import axios from "axios";

import {mapGetters} from 'vuex';

import {getSubStringValue} from "../../../../helpers/extraLogics";

import {errorHandler, successHandler} from "../../../../helpers/responseHandler";

export default {
    name: "GlobalSearch",

    components:{
        'status-switch': Switch
    },

    props: {

        userId: {type: [String, Number], default: ''},

        callingFrom: {type: String, default: ''},

        headerBackground: {type: String, default: ''}
    },

    data() {
        return {
            backgroundColors: {
                "navbar-light": "#f8f9fa",
                "navbar-dark navbar-blue": "#3c8dbc",
                "navbar-dark navbar-black": "#343a40",
                "navbar-dark navbar-green": "#28a745",
                "navbar-dark navbar-purple": "#6f42c1",
                "navbar-dark navbar-red": "#dc3545",
                "navbar-light navbar-yellow": "#ffc107",
                "navbar-light navbar-orange": "#fd7e14",
            },
            indicatorBackground: "#FFF",

            mainFilter: [
                {
                    id: 'all',
                    title: 'all'
                },
                {
                    id: 'tickets',
                    title: 'tickets'
                },
                {
                    id: 'contacts',
                    title: 'contacts'
                },
                {
                    id: 'articles',
                    title: 'articles'
                }
            ],

            searchBy:[],

            isDropdownOpen: true,

            showSearchby: false,

            searchedText: '',

            recentSearches: [],

            timeoutId: null,

            searchResult: '',

            showLoader: false,

            apiUrl:'',

            search:'',

            selected:'all',

            category:'all',

            showRecentSearch:true,

            showData:false,

            noData:'all',

            filterParams : [],

            recentlyViewed:[],

            selectAllText: '',

            page:1,

            ticketNextPageUrl:'',

            loadUrl:'',

            nextPage:'',

            loadData : false,

            next_pageUrl:'',

            reloadData:''
        }
    },

    beforeMount() {
        this.indicatorBackground = this.backgroundColors[this.headerBackground];

        this.getSearchedText();

        setTimeout(()=>{

            this.$refs.searchInput.focus();
        },1)
    },

    watch: {
        searchedText(value) {
            if (value.length === 0) {
                this.showRecentSearch = true;

                this.showData = false
            }
        },
    },
    computed:{

        ...mapGetters(['formattedDate']),

        noDataMessage() {
            //No data message display.
            if (this.noData === 'all' &&

                (!this.searchResult ||
                    (this.searchResult.tickets && this.searchResult.tickets.count <= 0) &&
                    (this.searchResult.contacts && this.searchResult.contacts.count <= 0) &&
                    (this.searchResult.articles && this.searchResult.articles.count <= 0))) {

                return this.lang('no_data_found');
            }
            if (this.searchResult && this.noData !== 'all') {
                if (this.searchResult.tickets && this.searchResult.tickets.count <= 0 && this.noData === 'tickets') {
                    return this.lang('no_tickets_found');
                } else if (this.searchResult.contacts && this.searchResult.contacts.count <= 0 && this.noData === 'contacts') {
                    return this.lang('no_contacts_found');
                } else if (this.searchResult.articles && this.searchResult.articles.count <= 0 && this.noData === 'articles') {
                    return this.lang('no_articles_found');
                }
            }
            return null;
        }

    },
    methods: {

        outsideClick(event) {
            const dropdownElement = this.$el;
            const { clientX, clientY } = event;

            // Get the bounding rectangle of the dropdown element
            const dropdownRect = dropdownElement.getBoundingClientRect();

            // Calculate the boundaries of the dropdown element relative to the viewport
            const dropdownLeft = dropdownRect.left + window.pageXOffset;
            const dropdownRight = dropdownRect.right + window.pageXOffset;
            const dropdownTop = dropdownRect.top - window.pageYOffset;
            const dropdownBottom = dropdownRect.bottom + window.pageYOffset;

            // Define the minimum width and minimum height of the dropdown
            const minWidth = 400; // Adjust this value as needed
            const minHeight = 400; // Adjust this value as needed

            // Check if the click occurred outside the dropdown boundaries, considering the minimum width and height
            const isClickedOutside = (
                clientX < dropdownLeft - minWidth ||
                clientX > dropdownRight ||
                clientY < dropdownTop ||
                clientY > dropdownBottom
            );

            const isClickedInsideDropdown = !dropdownElement.contains(event.target);

            // Close the dropdown if the click is outside, the dropdown is open, and the click didn't originate from within the dropdown
            if (isClickedOutside &&  isClickedInsideDropdown && this.isDropdownOpen) {
                this.closeSearchBar();
            }
        },

        gotoViewAll(type) {
            //passing data to the SearchResult Component throught route and open.

            this.closeSearchBar();

            const uniqueKey = Date.now().toString();

            this.$router.push({ path : '/search-results', query: { type : type, endpoint : this.apiUrl, key: uniqueKey }})
        },

        closeSearchBar() {
            this.$emit('close-search-bar', false);
        },

        subString(value,length = 30){

            return getSubStringValue(value,length)
        },

        searchText(value){

            this.searchedText = value;

            this.$refs.searchInput.focus();
        },

        getSearchedText() {
            return axios
                .get('/agent/recent-searches/get')
                .then((res) => {
                    this.recentSearches = res.data?.data?.recentSearches || [];
                })
                .catch((err) => {
                });
        },


        callFilterData(){

            event.stopPropagation();

            this.getFilterParams();

            this.updateSelectAllText();

            this.showSearchby = true;

        },

        onChange(value, name) {

            this[name] = value;

            const selectedFilter = this.searchBy.find(item => item.id === name);

            if (selectedFilter) {
                if (value) {
                    // Add the ID to the filterParams array if the value is true and it's not already present
                    if (!this.filterParams.includes(selectedFilter.id)) {

                        this.filterParams.push(selectedFilter.id);
                    }
                } else {
                    // Remove the ID from the filterParams array if the value is false and it's present
                    const index = this.filterParams.indexOf(selectedFilter.id);
                    if (index > -1) {

                        this.filterParams.splice(index, 1);
                    }
                }
            }

            this.updateSelectAllText();
        },

        toggleSelectAll() {
            if (this.selectAllText === 'select_all') {
                this.selectAllText = 'deselect_all';
                this.searchBy.forEach(item => {
                    item.is_selected = true;
                    if (!this.filterParams.includes(item.id)) {
                        this.filterParams.push(item.id);
                    }
                });
            } else {
                this.selectAllText = 'select_all';
                this.searchBy.forEach(item => {
                    item.is_selected = false;
                    const index = this.filterParams.indexOf(item.id);
                    if (index > -1) {
                        this.filterParams.splice(index, 1);
                    }
                });
            }
        },

        updateSelectAllText() {

            //updates the Text of the Select All or Deselect All by the selected filters.
            if (this.filterParams.length === 0) {

                this.selectAllText = 'select_all';
            } else if (this.filterParams.length === this.searchBy.length) {

                this.selectAllText = 'deselect_all';
            } else {

                this.selectAllText = 'deselect_all';
            }
        },

        selectedFilter(id) {

            //passing  selected category to the api.
            if (this.selected !== id) {

                this.selected = id;

                this.category = id;

                if (this.searchedText.length > 0 && this.category) {

                    this.searchContent();
                }

                this.noData = id;
            }
        },
        isSelected(id) {

            return this.selected === id
        },

        clearSearchHistory() {

            axios.get('/agent/recent-searches/clear').then(res=>{

                this.recentSearches = [];
            }).catch(err=>{

            })
        },

        getFilterParams(){

            this.showLoader = true

            axios.get('/agent/search-preferences').then(res=>{

                this.searchBy = res.data.data;

                this.showLoader = false

                // Clear the existing filterParams array
                this.filterParams = [];

                // Iterate over the searchBy array
                for (const item of this.searchBy) {
                    if (item.is_selected) {
                        // Add the selected ID to the filterParams array
                        this.filterParams.push(item.id);
                    }
                }

                this.updateSelectAllText();

            }).catch(err=>{

                this.showLoader = false

                errorHandler(err)
            })

        },

        searchContent() {
            if (!this.searchedText || this.searchedText.trim() === '') {
                return; // Return early if searchedText is null or empty
            }
            
            if (this.showSearchby) {
                this.showSearchby = false;
            }

            // Get API display's the search result.
            if (this.category && this.category !== 'all' && this.searchedText && this.searchedText.length > 0) {
                let encodedValue = encodeURIComponent(this.searchedText);
                this.apiUrl = '/search-all?search-query=' + encodedValue + '&category[]=' + this.category;
            } else if (this.searchedText && this.searchedText.length > 0) {
                let encodedValue = encodeURIComponent(this.searchedText);
                this.apiUrl = '/search-all?search-query=' + encodedValue;
            }

            if (this.searchedText && this.searchedText.length > 0) {
                this.showRecentSearch = false;
                this.showData = true;
                this.showLoader = true;

                axios.get(this.apiUrl)
                    .then(res => {
                        this.getSearchedText();
                        this.showLoader = false;
                        this.searchResult = res.data.data;
                        this.nextPage = this.category;

                        if (res.data.data[this.nextPage].data.next_page_url && this.category !== 'all') {
                            // If next_page_url exists in the API response, increment page and call the API again to load the next page
                            this.loadUrl = res.data.data[this.nextPage].data.next_page_url;
                        }
                    })
                    .catch(err => {
                        this.showLoader = false;
                    });
            }
        },

        saveFilters(){

            event.stopPropagation();

            const requestData = {

                'filter-ids': [...this.filterParams]
            };

            axios.post('/agent/search-preferences', requestData).then(res => {

                this.searchContent();

                successHandler(res)

            }).catch(err => {

                errorHandler(err)
            });

            this.showSearchby = false;
        },

        cancelFilters(){

            event.stopPropagation();

            this.showSearchby = false;
        }

    },

    beforeDestroy() {

        document.removeEventListener('click', this.outsideClick);
    },

    mounted() {

        document.addEventListener('click', this.outsideClick);

        this.updateSelectAllText();
    },

}
</script>

<style type="text/css">

.global-search-box {
    width: 400px !important;
}

.global-search-input-group {
    border-radius: 0.25rem;
    border: 2px solid #3c8dbc;
}

.space_button{
    margin-right:5px;
}

.navbar-search-block {
    position: absolute;
    padding: 0rem;
    left: auto;
    top: 0;
    right: 0;
    bottom: 0;
    z-index: 10;
    display: none;
    justify-content: center;
    flex-direction: column;
    width: 400px;
}

.navbar-search-block.navbar-search-open {
    display: flex;
}

.navbar-search-block .input-group {
    width: 100%;
}

.search_icon{
    font-size: 21px;
    margin-top: 5px;
    cursor: pointer;
}

.filter-data{
    padding-top: 1rem;
    padding-left:20px;
    padding-right:2px;
    padding-bottom:2px;
}

.scrollable-ul { max-height: 280px; overflow-y: auto;overflow-x: auto;}

.scrollable-ul::-webkit-scrollbar-track
{
    background-color: #f1f1f1;
    border-radius:10px;
}

.scrollable-ul::-webkit-scrollbar
{
    width: 6px;
    height:10px;
    background-color: #f1f1f1;
}

.scrollable-ul::-webkit-scrollbar-thumb
{
    background-color: #c1c1c1;
    border-radius: 10px;
}

.toggle_button{
    margin-right: 10px;
}

.toggle-container:focus {
    box-shadow:none;
    outline: none;

}
.status-switch .toggle-control {
    height: 14px;
    width: 28px;
}

.search_button{
    margin-right:0 !important;
    border-left:0 !important;
    padding-top:8px !important;
}

.toggle{
    width: 40px;
    height: 15px;
}

.toggle-handle{
    width: 15px;
    height: 15px;
}

.search-data{
    width:400px;
    max-width: 400px !important;
    margin-top: 10px;
    max-height: 400px;
    transform: translate3d(-370px, 0px, 0px) !important;
}

.select-btn{
    cursor: pointer;
}

.loader-overlay {
  position: absolute;
  top: 0;
  right: 0;
  height: 100%;
  z-index: 99;
  display: flex;
  align-items: center;
  padding-right: 85px;
}

.loader-content {
  position: relative;
}

.loader-content .reuse-loader {
  position: relative;
  margin: auto;
}

.btn-outline-primary {
  color: #3c8dbc;
  background-color: #fff;
  border-color: #3c8dbc;
}

.btn-outline-primary:hover {
  color: #fff;
  background-color: #3c8dbc;
  border-color: #3c8dbc;
}

.search-by-btn>*{
   width: auto;
  padding-left: 0;
  padding-right: 0;
}

</style>