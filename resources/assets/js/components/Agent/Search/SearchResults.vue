<template>
        <div class="col-sm-12 mb-2">

            <alert componentName="search-result"/>

                <div class="input-group input-group-lg">

                    <input v-model.trim="searchedText" type="search" ref="searchInput" class="form-control form-control-lg"
                           :placeholder="trans('search')" @keyup.enter="searchData()" autofocus>

                        <button type="submit" class="btn btn-lg btn-light" @click="searchData()" >

                            <i class="fa fa-search"></i>
                        </button>
                </div>
        </div>

       <div class="col-sm-12">

           <div class="row" v-if="loading">

               <custom-loader :duration="4000"></custom-loader>

           </div>

         <div class="card card-light">

            <div class="card-body">

                    <ul class="nav nav-tabs" id="search-result-tabs" role="tablist">

                        <li v-for="section in tabs" class="nav-item text-md">

                            <a class="nav-link" :class="{ active: $route.query.type === section.id }" data-bs-toggle="pill" role="tab" href="javascript:;"
                               @click="loadData(section.id)">

                                {{section.title}} <span class="badge text-bg-warning"> {{section.count}} </span>
                            </a>
                        </li>

                        <div id="filter-list" class="search-filter">

                            <div class="btn-group float-end">

                                 <span type="button" class="dropdown-toggle pe-4" data-bs-toggle="dropdown" aria-expanded="true"
                                     id="dropdown-menu" @click="callFilterData()">

			                         <i class="fas fa-cog filter-icon pt-2"> </i>
                                 </span>

                            <div class="dropdown-menu dropdown-menu-xl dropdown-menu-right dropdown-position">

                                <div v-if="showLoader" class="mb-1 mt-1">

                                    <reuse-loader  :animation-duration="6000" :size="30"/>
                                </div>

                                 <div v-if="!showLoader" class="card search-by">

                                    <div class="card-header" @click="preventToCloseBox">

                                        <div> <b>{{trans('search_by')}}</b> <a class="select-btn float-end"
                                                  @click="toggleSelectAll ">{{ selectAllText }}</a>
                                        </div>
                                    </div>

                                    <div class="card-body pt-2 pb-2 pe-1">

                                        <div class="scrollable-ul" id="activity_scroll">

                                            <div v-for="item in searchBy" :key="item"  @click="preventToCloseBox">

                                                {{item.label}}
                                                <status-switch :name="item.id" :onChange="onChange" :value="item.is_selected"
                                                               classname="toggle_button float-end" >

                                                </status-switch> <hr>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-footer p-2">

                                        <div class="btn btn-primary float-end pt-1 pb-1" @click="saveFilters()">

                                            <i class="fas fa-save"></i>&nbsp;{{trans('save')}}
                                        </div>

                                        <div class="btn btn-light pt-1 pb-1">

                                            <i class="fas fa-times"></i>&nbsp;{{trans('cancel')}}
                                        </div>
                                    </div>
                                 </div>
                            </div>
	                      </div>
                        </div>
                    </ul>

                <div class="tab-content">

                    <div class="active tab-pane mt-4 scrollable-area">

                        <template v-if="tab === 'tickets'">

                            <template v-if="tickets && tickets.length">

                                <template v-for="item in tickets" :key="item">

                                        <div class="mailbox-messages mailinbox">

                                            <div class="row ticket-box">

                                                <div class="col-md-12 col-sm-12 col-12">

                                                    <table id="tickets-expanded">
                                                        <tbody>
                                                        <tr class="unanswered">

                                                            <td id="ticket_user" style="width: 1%;">

                                                                <div class="user-image">

                                                                    <faveo-image-element id="size-30" :source-url="item.user.profile_pic" :img-width="35" :img-height="35"
                                                                                         alternative-text="User Image"/>

                                                                </div>

                                                            </td>

                                                            <td class="name td-ticket-details">

                                                                <router-link :to="item.view_url" v-tooltip="item.first_thread && item.first_thread.title ? item.first_thread.title : '---'" id="first_thread_title">

                                                                <span class="text-gray"> [#{{item.ticket_number}}]</span> &nbsp

                                                                    <span class="text-primary" v-if="item.first_thread && item.first_thread.title">{{ item.first_thread.title.length > 30 ?
                                                                        item.first_thread.title.substring(0,30) + '...' : item.first_thread && item.first_thread.title ?item.first_thread.title:'---' }}</span>

                                                                    <span class="text-primary">
                                                                                 ({{item.thread_count}})
                                                                    </span>

                                                                </router-link>

                                                            </td>

                                                            <td class="td-ticket-status hideForList">

                                                                <span class="badge text-white font-weight-lighter" :style="{background:item.priority.priority_color +'!important'}">{{item.priority.name}}</span>

                                                            </td>

                                                            <td>

                                                                <i :class="item.statuses.icon"  id="ticket-source-icon" :style="{color: item.statuses.icon_color}" v-tooltip="lang('ticket_is')+item.statuses.name"></i>

                                                                <i :class="item.sources.css_class" class="ps-3"  id="ticket-source-icon" v-tooltip="lang('ticket_is_generated_via')+item.sources.name"></i>

                                                            </td>


                                                            <td class="source-icon hideForList text-muted text-sm">
                                                                <i class="far fa-clock me-1"></i>{{formattedDate(item.created_at)}}
                                                            </td>
                                                        </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                </template>

                                <template v-if="next_cursor">

                                    <infinite-loading @infinite="getDataFromServer">
                                        <template #spinner><span></span></template>
                                        <template #complete><span></span></template>
                                    </infinite-loading>

                                </template>
                            </template>

                            <template v-if="!loading && ticketCount === 0">

                                <div class="text-center">{{ trans('no-records')}}</div>
                            </template>
                        </template>

                        <template v-if="tab === 'contacts'">

                            <template v-if="contacts && contacts.length">

                                <template v-for="item in contacts" class="content-space">

                                        <div class="mailbox-messages mailinbox">

                                            <div class="row ticket-box">

                                                <div class="col-md-12 col-sm-12 col-12">

                                                    <table id="tickets-expanded">

                                                        <tbody>

                                                            <tr class="unanswered">

                                                                <td id="ticket_user" style="width: 1%;">

                                                                    <div class=" user-image">

                                                                        <faveo-image-element id="size-30" :source-url="item.profile_pic" :img-width="35" :img-height="35"
                                                                                         alternative-text="User Image"/>

                                                                     </div>

                                                                </td>

                                                                <td class="name td-ticket-emails">

                                                                    <router-link :to="item.view_url" id="contact_name">

                                                                    <span class="text-gray" >[{{ item.email ? item.email : item.user_name ? item.user_name.slice(0,12) + '...' : item.user_name }}]</span> &nbsp

                                                                    </router-link>

                                                                </td>

                                                                <td class= "td-username">

                                                                    <router-link :to="item.view_url" id="contact_name">

                                                                        <span class="text-primary" v-tooltip="item.full_name">{{ item.full_name }}</span>

                                                                    </router-link>

                                                                </td>


                                                                <td >

                                                                    <i :class="{'success':item.email_verified === true,'danger':item.email_verified === false}"
                                                                      class="fas fa-envelope" id="ticket-source-icon"
                                                                      v-tooltip="item.email_verified === true ? lang('user email is verified') : lang('user has not verified email')"
                                                                    >

                                                                    </i>

                                                                    <i :class="{'success':item.mobile_verified === true,'danger':item.mobile_verified === false}"
                                                                      class="fas fa-mobile-alt ps-3" id="ticket-source-icon"
                                                                      v-tooltip="item.mobile_verified === true ? lang('user mobile is verified') : lang('user has not verified mobile')"
                                                                      >

					                                                </i>

                                                                </td>


                                                                <td class="source-icon hideForList text-muted text-sm">

                                                                    <i class="far fa-clock me-1"></i>{{formattedDate(item.created_at)}}

                                                                </td>

                                                            </tr>
                                                        </tbody>

                                                    </table>

                                                </div>

                                            </div>

                                        </div>

                                </template>

                                <template v-if="next_cursor">

                                    <infinite-loading @infinite="getDataFromServer">
                                        <template #spinner><span></span></template>
                                        <template #complete><span></span></template>
                                    </infinite-loading>
                                </template>


                            </template>

                            <template v-if="!loading && contactCount === 0">

                                <div class="text-center">{{ trans('no-records') }}</div>

                            </template>
                        </template>

                        <template v-if="tab === 'articles'">

                            <template v-if="articles && articles.length">

                                <template v-for="item in articles" :key="item"  class="content-space">

                                        <div class="mailbox-messages mailinbox">

                                            <div class="row ticket-box">

                                                <div class="col-md-12 col-sm-12 col-12">

                                                    <table id="tickets-expanded">
                                                        <tbody>
                                                            <tr class="unanswered">

                                                                <td id="ticket_user" style="width: 1%;">
                                                                    <a href="javascript:;">
                                                                        <span class="fa-stack fa-2x">

                                                                        <i class="fas fa-newspaper fa-stack-1x"></i>
                                                                    </span>
                                                                    </a>
                                                                </td>

                                                                <td class="name td-ticket-details articles">

                                                                    <a :href="basePath()+item.view_url" target="_blank">

                                                                        <span class="text-primary" v-tooltip="item.name">{{ item.name }}</span>

                                                                    </a>


                                                                </td>

                                                                <td class="source-icon hideForList text-muted text-sm">

                                                                    <i class="far fa-clock me-1"></i>{{formattedDate(item.publish_time)}}
                                                                </td>
                                                            </tr>

                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                </template>

                                <template v-if="next_cursor">

                                    <infinite-loading @infinite="getDataFromServer">
                                        <template #spinner><span></span></template>
                                        <template #complete><span></span></template>
                                    </infinite-loading>

                                </template>
                            </template>

                            <template v-if="!loading && articleCount === 0">

                                <div class="text-center">{{ trans('no-records') }}</div>
                            </template>
                        </template>
                    </div>
                </div>
            </div>
        </div>
      </div>
</template>

<script>

    import axios from "axios";

    import {mapGetters} from 'vuex';

    import Switch from "../../MiniComponent/FormField/Switch.vue";

    import {errorHandler, successHandler} from "../../../helpers/responseHandler";

    import {getSubStringValue} from "../../../helpers/extraLogics";

    export default {

        name : 'search-result',

        components:{
            'status-switch': Switch
        },

        data() {

            return {

                searchResults : '',

                tabs : [],

                tab : this.$route && this.$route.query && this.$route.query.type,

                loading : true,

                next_cursor : '',

                selectAllText: '',

                tickets : [],

                contacts : [],

                articles : [],

                filterParams : [],

                searchedText : '',

                showLoader: false,

                searchBy: [],

                apiUrl : '',

              ticketCount:'',

              contactCount:'',

              articleCount:''

            }
        },

        beforeMount() {
            //To get the Data from the viewAll from globalSearch Component through route.

            if(this.$route && this.$route.query && this.$route.query.type){

              this.getCountsAndData();
            }
        },

        mounted(){


            this.updateSelectAllText();

            this.$nextTick(() => {

                if(this.$refs.searchInput){

                    setTimeout(()=>{

                        this.$refs.searchInput.focus();
                    },100);
                }
            });

        },



        computed:{

          ...mapGetters(['formattedDate'])
        },

        methods : {
            preventToCloseBox(event) {

                event.stopPropagation();
            },

            subString(value,length = 30){

                return getSubStringValue(value,length)
            },

            callFilterData(){

                this.getFilterParams();

                this.updateSelectAllText();
            },

            onChange(value, name) {

                this[name] = value

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
                if (this.selectAllText === 'Select All') {

                    this.selectAllText = 'Deselect All';

                    this.searchBy.forEach(item => {

                        item.is_selected = true;

                        if (!this.filterParams.includes(item.id)) {

                            this.filterParams.push(item.id);
                        }
                    });
                } else {
                    this.selectAllText = 'Select All';

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

                    this.selectAllText = 'Select All';
                } else if (this.filterParams.length === this.searchBy.length) {

                    this.selectAllText = 'Deselect All';
                } else {

                    this.selectAllText = 'Deselect All';
                }
            },

            getFilterParams(){

                this.showLoader = true;

                axios.get('/agent/search-preferences').then(res=>{

                    this.searchBy = res.data.data;

                    this.showLoader = false;

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

                    this.showLoader = false;

                    errorHandler(err)
                })

            },

            saveFilters(){

              if(this.searchedText === '' && this.$route.query.endpoint === '' ){

                this.tabs = [

                  { id : 'tickets', title: 'Tickets', count :  0  },

                  { id : 'contacts', title: 'Contacts', count : 0 },

                  { id : 'articles', title: 'Articles', count :  0 }
                ]
                     this.ticketCount = 0,

                    this.contactCount = 0,

                    this.articleCount = 0

              }

                const requestData = {

                    'filter-ids': [...this.filterParams]
                };

                this.loading = true;

                axios.post('/agent/search-preferences', requestData).then(res => {

                    this.loading = false;

                    if(this.searchedText.length === 0 && this.$route && this.$route.query && this.$route.query.type){

                        this[this.tab] = [];

                        this.getCountsAndData()
                    }else{

                        this.searchData();
                    }

                    successHandler(res,'search-result');

                }).catch(err => {

                    this.loading = false;

                    errorHandler(err,'search-result');
                });
            },

          async getCountsAndData() {
            try {
              await this.getCounts();
              await this.getDataFromServer();
            } catch (error) {
              this.handleError(error);
            }
          },

          async getCounts() {
            try {
              this.loading = true;

              if (this.searchedText) {
                let encodedValue = encodeURIComponent(this.searchedText);
                this.apiUrl = `/search-all?search-query=${encodedValue}`;
              } else {
                this.$route.query.endpoint = this.$route.query.endpoint.replace(`category[]=${this.$route.query.type}`, '');
                this.apiUrl = this.$route.query.endpoint;
              }

              const response = await axios.get(this.apiUrl);
              this.searchResults = response.data.data;

               this.ticketCount = this.searchResults.tickets ? this.searchResults.tickets.total : 0;
              this.contactCount = this.searchResults.contacts ? this.searchResults.contacts.total : 0;
              this.articleCount = this.searchResults.articles ? this.searchResults.articles.total : 0;

              this.tabs = [
                { id: 'tickets', title: 'Tickets', count: this.searchResults.tickets ? this.searchResults.tickets.total : 0 },
                { id: 'contacts', title: 'Contacts', count: this.searchResults.contacts ? this.searchResults.contacts.total : 0 },
                { id: 'articles', title: 'Articles', count: this.searchResults.articles ? this.searchResults.articles.total : 0 }
              ];

              this.loading = false;
            } catch (err) {
              this.loading = false;
              errorHandler(err);
            }
          },

          searchData(){

                //executes while the searched from search bar.
                if(this.searchedText.length > 0){

                    this.$route.query.endpoint = '';

                    this[this.tab] = [];

                    this.next_cursor = '';

                  this.getCountsAndData();

                    // Removes the additional data passed from the basePath Url
                   // const currentUrl = new URL(window.location.href);
                    // Get the base URL without query parameters
                  // const baseUrl = currentUrl.origin + currentUrl.pathname;
                   // Update the URL without query parameters
                  // history.replaceState(null, '', baseUrl);
                }
            },

            loadData(type) {

                // calls data and count API when the tabs where clicked.

                if (type === this.tab ) {

                    return;
                }

                this.tab = type;

                this.next_cursor = '';

                this.tickets =  [];

                this.contacts = [];

                this.articles = [];

                if(this.searchedText === '' && this.$route.query.endpoint === '' ){

                    this.tabs = [

                        { id : 'tickets', title: 'Tickets', count :  0  },

                        { id : 'contacts', title: 'Contacts', count : 0 },

                        { id : 'articles', title: 'Articles', count :  0 }
                    ]

                      this.ticketCount = 0,

                      this.contactCount = 0,

                      this.articleCount = 0
                }

                if(this.searchedText || this.$route.query.endpoint){

                  this.getCountsAndData();
                }
            },

          async getDataFromServer($state) {
            try {
              this.loading = true;

              let params = {
                cursor: this.next_cursor
              };

              if (this.searchedText) {
                let encodedValue = encodeURIComponent(this.searchedText);
                this.apiUrl = `/search-all?search-query=${encodedValue}&category[]=${this.tab}`;
              } else {
                this.$route.query.endpoint = this.$route.query.endpoint.replace(`category[]=${this.$route.query.type}`, '');
                this.apiUrl = this.$route.query.endpoint;
                params['category[]'] = this.tab;
              }

              const response = await axios.get(this.apiUrl, { params });
              const newData = response.data.data[this.tab].data.data;

              this[this.tab].push(...newData);

              $state && $state.loaded();

              if (newData.length < 10) {
                $state && $state.complete();
              }

              this.next_cursor = response.data.data[this.tab].data.next_cursor;

              this.loading = false;

            } catch (error) {
              this[this.tab] = [];
              this.loading = false;
            }
          }

        }
    }
</script>

<style scoped>

.td-ticket-details{
    width: 40%;
}

.td-ticket-emails{
    width: 30%;
}

.td-username{
    width: 30%;
}

.td-ticket-status {
    padding-right: 0;
    width: 8%;
}

#tickets-expanded .td-ticket-status {
    text-align: left !important;
    padding-right: 0;
    width: 8%;
}

#tickets-expanded td{
    font-size: 15px;
}

#tickets-expanded .source-icon{
    width: 10%;
    font-size: 13px !important;
}

.font-weight-lighter {
    font-weight: 500!important;
}

.articles{
    width: 80%;
}

.scrollable-ul { max-height: 250px; overflow-y: auto;overflow-x: auto;}

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

.select-btn{
    cursor: pointer;
}

.dropdown-position {
    max-width: 250px;
    min-width: 250px;
    max-height: 300px;
    min-height: 300px;
    padding-top: 0;
    transform: translate3d(-10px, 39px, 0px) !important;
    border-radius: 15px;
}

.filter-icon{
    font-size:21px;
}

.search-filter{
    float: right!important;
    position: absolute;
    right: 0px;
}

#search-result-tabs .nav-link{
  color: #3c8dbc;
}

</style>