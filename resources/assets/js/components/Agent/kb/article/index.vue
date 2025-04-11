<template>

<div class="col-sm-12">

	<alert componentName="ArticlesIndex"/>

	<div class="card card-light ">
		
		<div class="card-header">
			
			<h3 class="card-title">{{lang('list_of_articles')}}</h3>

			<div class="card-tools">
       		
       		<a class="btn btn-tool " href="javascript:;" @click="toggleFilterView" v-tooltip="lang('filter')">
						
					<span class="glyphicon glyphicon-filter"></span>
				</a>

       		<router-link to="/article/create" class="btn-tool" v-tooltip="lang('create_article')">

       			<i class='glyphicon glyphicon-plus'> </i>
       		</router-link>
    		</div>
		</div>

		<div class="card-body" id="kb-articles">
			
			<kb-filter id="kb-filter-box" v-if="isShowFilter" :metaData="filterOptions" :appliedFilters="appliedFilters"
				@selectedFilters="selectedFilters">
		  
			</kb-filter>

			<div class="row"  v-if="!loading">

				<div class="col-md-4">
					
					<template v-if="records > 0">
						
						<data-per-page :ticketper="perpage" v-on:message="handlePageCount"/>
					
						<kb-sorting :sortingMenu="sortingMenu"
							v-on:sort="sorting"/>
					</template>
				</div>

				<div class="col-md-3 offset-md-5">

					<div class="d-flex">

						<span class="mt-6px">{{ lang('search') }}:&nbsp;</span>
						
						<input type="text"  class="form-control search-field" v-model="search"
							:placeholder="lang('search_here')" @keyup.enter="handleSearch">
					</div>
				</div>
			</div>

			<div v-if="!loading" class="mt-2">

				<template v-if="records > 0">

					<articles-box v-for="article in articleList"  :key="article.id" :article="article" :status="status" :updateKb="updateKbList">

					</articles-box>

					<div class="row" id="kb-pagination" v-if="records >  10">

						<uib-pagination :records="records" v-model="pagination" class="pagination" :boundary-links="true" :per-page="perpage" @paginate="pageChanged()"  :options="{chunk:3, chunksNavigation:'scroll'}">

						</uib-pagination>
					</div>
				</template>

				<div v-if="show && records == 0">

					<p style="text-align:center">{{lang('no-data-to-show')}}</p>
				</div>
			</div>

			<div class="row" v-if="loading">
			
				<reuse-loader></reuse-loader>
			</div>

			<div class="row" v-if="pageLoader">
			
				<custom-loader></custom-loader>
			</div>
		</div>
	</div>
</div>  
</template>
<script>

	import axios from 'axios'

  import {boolean, getApiParamsFromArray} from "../../../../helpers/extraLogics";

	import indexBox from "./ReusableComponents/indexBox.vue";
	import kbSorting from "../common/kbSorting.vue";
	import dataPerPage from "../common/dataPerPage.vue";
	import DataTableFilter from "../../../Extra/DataTableFilter.vue";
	import{ errorHandler } from "../../../../helpers/responseHandler";

	export default {
		
		data() {
			
			return {
				
				articleList:'',
				
				paramsObj:{},
				
				length:0,
				
				// for pagination
				perpage:10,
				
				pagination:1,
				
				records:0,
				
				// for loader
				loading:true,

				pageLoader : false,
				
				// for search
				search:'',
				
				status : 1,
				
				show:false,

				filterOptions: [
					{
						section : [
							{ 
								name: 'categories',
							 	url: '/api/dependency/categories',
							 	label: 'categories',
						  	},
						  	{ 
								name: 'tags',
							 	url: '/api/dependency/tags',
							 	label: 'tags',
						  	},
						  	{ 
								name: 'visible_to',
								type: 'static-select',
						 		label: 'visible_to',
						 		elements:[
						 			{id:'all_users',name:'All Users'},
						 			{id:'logged_in_users',name:'LoggedIn Users'},
						 			{id:'agents',name:'Agents'},
						 			{id:'organization_members', name : 'Organization Members'}
						 		]
					  		},
						],
					},

					{
						section : [
							{ 
								name: 'type',
							 	type: 'static-select',
							 	label: 'type',
							 	elements:[{name:'Published',id:1},{name:'Draft',id:0}]
						  	},
						  	{ 
								name: 'author_ids',
							 	url: '/api/dependency/agents',
							 	label: 'author',
						  	},
						  	{ 
								name: 'organization_ids',
						 		url: '/api/dependency/organizations',
						 		label: 'organizations',
					  		},
						],
					},

					{
						section : [
							{ 
								name: 'created_at',
								type: 'date',
								label: ['created_at', 'created_within_last'],
								timeOptions:{  start: '00:00', step: '00:30',  end: '23:30' },
								range : true
								},
								{ 
								name: 'published_at',
								type: 'date',
								label: ['published_at', 'published_within_last'],
								timeOptions:{  start: '00:00', step: '00:30',  end: '23:30' },
								range : true
								},
						],
					}
				],

				isShowFilter : false,

				appliedFilters : {},

				filterParams : {},

        isRtl: false,

        sortingMenu: [
          {
            name: 'article_publish_time',
            value: 'publish_time',
            order: 'asc',
            class: "fas fa-sort-amount-down",
            order_name: "ascending"
          },
          {
            name: 'article_name',
            value: 'name',
            order: 'asc',
            class: "fas fa-sort-amount-down",
            order_name: "ascending"
          }
        ]
			}
		},

		beforeMount() {
			
			this.commonApi();
			
			this.getKbStatus();

			this.filterData();
		},

		created() {

			window.emitter.on('updateFilter',this.updateFilter);

      // getting is_rtl from sessionStorage
      this.isRtl = boolean(sessionStorage.getItem('is_rtl'));
		},

		methods: {

			updateFilter(data) {

				this.filterOptions.map(function (obj) { 
				  
				  obj.section.map(function(row){

				  		if(data.name == row.name) {
				  			
				  			 row.value = data.value;
				  		}
				  })
				});
			},

			updateFilterMeta(data) {

				this.filterOptions.map(function (obj) { 
				  
				  obj.section.map(function(row){

				  		// if(data.name == row.name) {
				  			
				  			 row.value = data[row.name] ? data[row.name] : '';
				  		// }
				  })
				});
			},
			
			filterData(){

				this.filterOptions.map(function (obj) { 
				  
				 	 obj.section.map(function(row){

						row.elements = row.type === 'static-select' ? row.elements : [];
					  	row.isMultiple = row.type === 'static-select' ? false : true;;
					  	row.isPrepopulate = false;
					  	row.value = '';
					  	row.className = 'col-sm-4';
				  	})
				});
			},

			selectedFilters(value){ 

				if(value === 'closeEvent') {
				
					return this.isShowFilter = false;
				}
				if(value === 'resetEvent') {
					
					return this.resetFilter();
				}
				
				return this.applyFilter(value) 
			},

			resetFilter(){

				this.pageLoader = true;

				this.commonApi();
			
		  		this.filterOptions = this.filterOptions.map(function (obj) { 
				  
				  obj.section.map(function(row){

					row.elements = row.type === 'static-select' ? row.elements : [];
				  row.isMultiple = row.type === 'static-select' ? false : true;
				  row.isPrepopulate = false;
				  row.value = '';
				  row.className = 'col-sm-4';
				  })

				  return obj;
				});
			},

			applyFilter(value){

				this.updateFilterMeta(value);

				this.pageLoader = true;

				this.appliedFilters = value;
      	
        		let params = getApiParamsFromArray(this.filterOptions,value);

        		if(params[params.length-1] === '&') {
         
          		params = params.slice(0, -1);
        		}

        		//CONVERT STRING INTO OBJECT
        		params = params.split("&").reduce(function(obj, str, index) {
				
					let strParts = str.split("=");
					
					if (strParts[0] && strParts[1]) {
					   
					   obj[strParts[0].replace(/\s+/g, '')] = strParts[1].trim();
					}
					
					return obj;
					
				}, {});

        		this.filterParams = params;

        		this.commonApi(params,'filter');
        
        		this.isShowFilter = false;
      	},

			toggleFilterView() {
		  
		  		this.isShowFilter = !this.isShowFilter;
			},

			updateKbList() {

				this.loading = true;

				this.paramsObj['page']=this.pagination;
				
				this.commonApi(this.paramsObj);
			},

			getKbStatus() {

				axios.get('kb/settings/getvalue').then(({data})=>{
				
				this.status = data.data.kbsettings.status;

				}).catch(res=>{
					
					this.status = 0;
				})
			},

			commonApi(obj,from = '') {
				
				var params = from === 'filter' ? {...this.paramsObj, ...obj} : {...this.filterParams, ...obj};

				axios.get('/get-articles',{params}).then(res=>{
					
					this.loading = false;

					this.pageLoader = false;
					
					this.articleList=res.data.message.data;
					
					if(res.data.message.total == 0){
						
						this.show =true;
					}
					
					this.records = res.data.message.total;
					
					this.perpage = res.data.message.per_page;
					
					this.length = res.data.message.total;

				}).catch(err=>{
               
               this.loading = false;

					this.pageLoader = false;

               errorHandler(err,'ArticlesIndex')
            })
			},

			//per page change function
			handlePageCount(payload){
				
				this.pageLoader = true;

				this.pagination = 1;
				
				this.paramsObj['pagination']=payload;
				
				setTimeout(()=>{
	         
	            this.commonApi(this.paramsObj);
				},100)
			},

			//sorting
        	
        	sorting(payload){
	      	
				this.pageLoader = true;

	        	this.paramsObj['sort-by']=payload.value;

            this.paramsObj['order']=payload.order;
	      
	        	this.commonApi(this.paramsObj);
	    	},
	      
	      // for page changing
			pageChanged() {
				
				this.pageLoader = true;

				var elmnt = document.getElementById('kb-articles');
				
				elmnt.scrollIntoView({ behavior : "smooth"});

				this.paramsObj['page']=this.pagination;
				
				this.commonApi(this.paramsObj);
			},

      handleSearch() {
        // Set the page loader to true to indicate loading state
        this.pageLoader = true;

        // Update the paramsObj with the current search query
        this.paramsObj['search-query'] = this.search;

        // Call the commonApi method with the updated paramsObj
        this.commonApi(this.paramsObj);
      },
		},

		components : {

			'articles-box': indexBox,

			'kb-sorting': kbSorting,

			'data-per-page': dataPerPage,

			'kb-filter': DataTableFilter
		}
	};
</script>