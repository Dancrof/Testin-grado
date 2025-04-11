<template>

	<div class="col-sm-12">

		<alert componentName="CommentsIndex"/>

		<div class="card card-light ">
			
			<div class="card-header">
				
				<h3 class="card-title">{{lang('list_of_comments')}}</h3>
			</div>

			<div class="card-body" id="kb-comments">
				
				<div class="row"  v-if="!loading">

					<div class="col-md-4">
						
						<template v-if="records > 0">
							
							<data-per-page :ticketper="perpage" v-on:message="handlePageCount"/>
						
							<kb-sorting :sorting-menu="sortingMenu" v-on:sort="sorting"/>
						</template>
					</div>

					<div class="col-md-3 offset-md-5">

						<div class="d-flex">

							<span class="mt-6px">{{ lang('search') }}:&nbsp;</span>

							<input type="text"  class="form-control search-field" v-model="search"
								:placeholder="lang('search_here')"  @keyup.enter="updateSearchFilter">
						</div>
					</div>
				</div>

				<div v-if="!loading" class="mt-2">

					<div class="callout callout-info bg-light border-tbe mb-2 rounded" :style="callOutStyle">
						
						<span v-if="from && from.name" id="call">
							<p class="mb-0">{{calloutText}} <b>{{from.name}}</b>.&nbsp;&nbsp;&nbsp;</p>
							<a id="all" href="javascript:;" @click="seeAll">{{lang('click_to_see_all')}}</a>
						</span>
					</div>
					
					<ul class="nav nav-tabs" role="tablist">
					
						<li v-for="section in tabs" class="nav-item">
							
							<a class="nav-link" :class="{ active: filter === section.id }" data-bs-toggle="pill" role="tab" href="javascript:;"
								@click="comments(section.id)" id="comment_tab">

								{{lang(section.title)}} <span class="badge text-bg-warning"> {{section.count}} </span>
							</a>
						</li>
					</ul>

					<div class="tab-content">
					
						<div class="active tab-pane mt-4">
							
							<template v-if="records > 0">

								<comments-box v-for="comment in comments_List"  :key="comment.id" :comment="comment"
									:updateList="updateData">
									
								</comments-box>
						
								<div class="comment-page" id="comments-pagination" v-if="records >  10">
							
									<uib-pagination :records="records" v-model="pagination" class="pagination" :boundary-links="true"
										:per-page="perpage" @paginate="pageChanged()" :options="{chunk:3, chunksNavigation:'scroll'}">
									
									</uib-pagination>
								</div>
							</template>

							<div v-if="show && records == 0">
					
								<p class="p-3" style="text-align:center">{{lang('no-data-to-show')}}</p>
							</div>

							<div class="row" v-if="pageLoader">
				
								<custom-loader></custom-loader>
							</div>
						</div>			
					</div>
				</div>

				<div class="row" v-if="loading">
				
					<reuse-loader></reuse-loader>
				</div>
			</div>
		</div>
	</div>  
</template>
<script>

	import axios from 'axios'

	import {useStore} from 'vuex';

	import {computed} from "vue";
	import commentBox from "./ReusableComponents/commentBox.vue";
	import kbSorting from "../common/kbSorting.vue";
	import dataPerPage from "../common/dataPerPage.vue";
  import {boolean} from "../../../../helpers/extraLogics";
	
	export default {

		setup() {

			const store = useStore();

			return {

				getCommentFilterData : computed(()=>store.getters.getCommentFilterData)
			}
		},
		
		data() {
			
			return {
				
				comments_List:[],
				
				paramsObj:{},
				
				length:0,

				from : this.getCommentFilterData,
				
				// pagination
				perpage:10,
				
				pagination: 1,
				
				records:0,
				
				// loader
				loading:true,
				
				// search
				search:'',

				show:false,
				
				tab:'',
				
				calloutText:'',
				
				callOutStyle:{display:'none'},
				
				filter:2,
				
				tabs:[{id:2,title:'all',count:0},{id:1,title:'approved',count:0},{id:0,title:'unapproved',count:0}],
				
				commentFilterData:{},
				
				pageLoader : false,

        isRtl: false,

        sortingMenu:[
            {
               name: 'created_time',
               order: 'asc',
               value: 'created_at',
              class: "fas fa-sort-amount-down",
              order_name: "ascending"
            }
        ]
			}
		},



		created() {
      // getting is_rtl from sessionStorage
      this.isRtl = boolean(sessionStorage.getItem('is_rtl'));

			window.emitter.on('updateCommentsList',this.updateData);

			if(this.from){
				
				if(this.from.id !== undefined){
					
					this.commentFilterData = this.from
					
					if(this.commentFilterData.to === 'all'){
						
						this.filter = 2
						
						this.callOutStyle.display = 'block';
					
					} else if(this.commentFilterData.to === 'unapprove') {
						
						this.filter = 0
						
						this.callOutStyle.display = 'block';
					
					} else {
					
						this.filter = 1
					}
				}
			}
		},

		beforeMount(){

			if(this.from){

				if(this.from.id){
	
					this.calloutText = 'Comments of ';
	
					const data ={ condition: this.from.to, article_id: this.from.id, filter_by:this.filter }
					
					this.commonApi(data);
				
				} else {
					
					this.commonApi()
				}
			
			}else {
				
				this.commonApi();
			}
		},

		methods: {
			
			updateData() {

				this.pagination = 1;

				this.search = '';

				this.loading = true;

				this.paramsObj = {};

				this.commonApi(this.paramsObj)				
			},

			commonApi(obj) {
				
				var params = obj;
				
				axios.get('/get-comment',{params}).then(res=>{
					
					this.loading = false;

					this.pageLoader = false;
					
					this.comments_List=res.data.message.data;
					
					if( res.data.message.total == 0){
						
						this.show=true;
					}
					
					this.records = res.data.message.total;
					
					this.perpage = res.data.message.per_page;
					
					this.tabs[0].count = res.data.data.all;
					
					this.tabs[1].count = res.data.data.approved;
					
					this.tabs[2].count= res.data.data.pending;
					
					this.length =  res.data.message.total;
				
				}).catch(res=>{

					this.pageLoader = false;

					this.loading = false;
				});
			},

			//per page change function
			handlePageCount(payload){
				
				this.pageLoader = true;

				this.pagination = 1;
			
				this.paramsObj['pagination']=payload;
			
				setTimeout(()=>{
			
					if(this.from){
			
						if(this.from.id !== undefined){
			
							this.commonFunction('pagination',payload)
			
						} else {
			
							this.commonApi(this.paramsObj);
						}
					} else {

						this.commonApi(this.paramsObj);
					}
				},100)
			},

			//sorting
			sorting(payload){
				
				this.pageLoader = true;

				this.show=false;
			
				this.paramsObj['sort-by']=payload.value;
        this.paramsObj['order']=payload.order;
			
				if(this.from){
			
					if(this.from.id !== undefined){
			
						this.commonFunction('sort-by',payload.value, 'order', payload.order)
			
					} else {
			
						this.commonApi(this.paramsObj);
					}
				} else {
					
					this.commonApi(this.paramsObj);
				}
			},

			// for showing approved onapproved and all comments
			comments(x) {
				
				this.pageLoader = true;

				this.tab =x;
			
				this.paramsObj['filter_by']=x;
			
				this.pagination = 1;
			
				this.paramsObj['page']=1;
			
				if(this.from){
			
					if(this.from.id !== undefined){
			
						this.commonFunction('filter-by',x)
			
					} else {
			
						this.commonApi(this.paramsObj);
					}
				} else {
					
					this.commonApi(this.paramsObj);
				}	
			},

			// for pagination
			pageChanged() {
				
				this.pageLoader = true;

				var elmnt = document.getElementById('kb-comments');
				
				elmnt.scrollIntoView({ behavior : "smooth"});

				this.paramsObj['page']=this.pagination;
				
				let filter = '';
				
				if(this.from){
				
					if(this.from.id !== undefined){
				
						this.commonFunction('page',this.pagination)
				
					} else {
				
						this.commonApi(this.paramsObj);
					}
				} else {
				 
				  	this.commonApi(this.paramsObj);
				}
			},

			commonFunction(param,value){
			
				if(param === 'filter-by'){
			
					this.filter = value
				}
			
				const data = { condition: this.from.to, article_id: this.from.id, filter_by:this.filter}
				
				if(param === 'filter-by'){
					
					data['page']= 1
				
				} else {
				
					data[param]= value
				}
				
				this.commonApi(data);
			},

			seeAll(){
				
				this.pageLoader = true;
				
				this.$store.dispatch('commentFilterData',{});

				this.paramsObj = {};
				
				this.paramsObj['filter_by']=this.filter;
				
				this.pagination = 1;
				
				this.paramsObj['page']=1;
				
				this.commonApi(this.paramsObj);
				
				this.callOutStyle.display = 'none';
			},

      updateSearchFilter() {
        // Set the page loader to true to indicate loading state
        this.pageLoader = true;

        // Update the paramsObj with the current search option
        this.paramsObj['search-option'] = this.search;

        // Check if the 'from' object is defined
        if (this.from) {
          // If 'from.id' is defined, call the commonFunction with the search option
          if (this.from.id !== undefined) {
            this.commonFunction('search-option', this.search);
          } else {
            // Otherwise, call the commonApi with the updated paramsObj
            this.commonApi(this.paramsObj);
          }
        } else {
          // If 'from' is not defined, call the commonApi with the updated paramsObj
          this.commonApi(this.paramsObj);
        }
      }
    },

		components : {

			'comments-box': commentBox,

			'kb-sorting': kbSorting,

			'data-per-page': dataPerPage
		}
	};
</script>
<style scoped>

#call{
	display:inline-flex;
}
#all{
	color:#007bff !important;
}
</style>

<style>

	.comment-page .VuePagination__pagination { margin-right: 0px !important; }
</style>