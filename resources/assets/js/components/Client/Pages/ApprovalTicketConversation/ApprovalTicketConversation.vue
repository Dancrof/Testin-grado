<template>
	
	<div>

		<meta-component :dynamic_title="lang('approval_settings-page-title')" :dynamic_description="lang('approval_settings-page-description')" :layout="layout" >
				
		</meta-component>

    <alert componentName="approval-converstaion"/>
		
		<div v-if="pageChange" class="row">

			<client-panel-loader :size="60" :color="layout.portal.client_header_color"></client-panel-loader>
		</div>

		<div class="row" v-if="statusText === '' && hasDataPopulated">

			<div id="content" class="site-content col-sm-12">
								
				<article class="hentry">
										
					<header class="entry-header">
											
						<h3 class="entry-title" :title="title" :class="{align1: lang_locale == 'ar'}">
							
							<i class="fas fa-ticket"> </i>
							
							{{ title }} 

							<small> ( {{ ticket_number }} )</small>
						</h3>
					</header>

					<div v-if="hasDataPopulated && thread_count > 0" class="entry-content clearfix">

						<ticket-details v-if="ticketData" :ticket="ticketData" :layout="layout" :auth="auth"></ticket-details>

						<div id="comments" class="comments-area" :class="{align1: lang_locale == 'ar'}">

							<ol class="comment-list">

								<thread-list :userId="user.id" v-for="thread in threads" :key="thread.id" :comments="thread"
									:layout="layout" :auth="auth" :dept="department" :showRatings="false">
											
								</thread-list>
							</ol>
											
							<div :class="{left: lang_locale == 'ar'}" class="float-end" v-if="thread_count > 10  && loading === false">

								<uib-pagination :records="thread_count" v-model="pagination" @paginate="changePage"
									:class="{left: lang_locale == 'ar'}" class="float-end"  :boundary-links="true" :per-page="perpage"
												:options="{chunk:3, chunksNavigation:'scroll'}">
									
								</uib-pagination><br><br><br><br>
							</div>

							<div v-if="thread_count > 10"><br><br><br><br></div>
						</div>
					</div>
				</article>
			</div>
		</div>

		<div v-if="!loading && shallShowApprovalAction && !statusText" class="row" id="approval-action-form" :class="{align1: lang_locale == 'ar'}" v-focus-first-input>

			<text-field id="approval_conversation_comment" :label="lang('comment')" :value="comment" type="textarea" name="comment"
				:onChange="onChange" classname="col-sm-12" :required="true"></text-field>

			<div class="form-group col-md-12">
						
				<button  id="approval_conversation_approve" @click = "onSubmit('approve')" class="btn btn-primary" :disabled="isDisabled">
						
					<span class="fa fa-check"></span> {{lang('approve')}}
				</button>
						

				<button id="approval_conversation_deny" @click = "onSubmit('deny')" class="btn btn-light" :disabled="isDisabled">
						
					<span class="fa fa-times"></span> {{lang('deny')}}
				</button>
			</div>
		</div>

		<div v-if="loading" id="loader" class="row">
						
			<client-panel-loader :animation-duration="4000" :size="60" :color="layout.portal.client_header_color"/>
		</div>
	</div>
</template>

<script>

	import axios from 'axios'

	import {validateApprovalTicketSettings} from "../../../../helpers/validator/approvalTicketRules"

	import {errorHandler, successHandler} from '../../../../helpers/responseHandler'

    import ThreadsList from "../Tickets/MiniComponents/ThreadsList.vue";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import TicketDetails from "../Tickets/MiniComponents/TicketDetails.vue";

	export default {

		name : 'approval-ticket-conversation',

		description : 'Approval Ticket Conversation Component',

		props : { 

			layout : { type :  Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}}
		},

		data () {
			return {
				thread_count: 0,

				title: '',

				ticket_number: 0,

				threads: [],

				user: {},

				pagination: 1,

				perpage: 10,

				loading: true,

				hasDataPopulated : false,

				paramsObj: {},

				isDisabled: false,

				comment:'',

				/**
				 * locale of the user
				 * @type {String}
				 */
				lang_locale : this.layout.language,

				hash: '',

				statusText : '',

				shallShowApprovalAction: true,

				department : '',

				pageChange : false, 

				lineStyle : {
					 borderColor : this.layout.portal.client_header_color
				},

				ticketData : '',

      }
		},

		beforeMount() {

			this.paramsObj['page'] = this.pagination
			
			this.getInitialValues(this.paramsObj);
		},


		methods:{
			
			getHashFromUrl(url){

		    let urlArray = url.split("/");

		    return urlArray[urlArray.length - 1];

			},

			getInitialValues(params){
				
				this.$Progress.start();
				
				const path = window.location.pathname;
				
				this.hash = this.getHashFromUrl(path);

				axios.get('/api/ticket-conversation/'+this.hash,{params}).then(res => {

					this.ticketData = res.data.data.ticket;

					this.updateStatesWithData(res.data.data.ticket);

					this.loading = false

					this.pageChange = false;

					this.hasDataPopulated = true;

					this.$Progress.finish();

          successHandler(res, 'approval-converstaion')


				}).catch(err => {

					this.statusText = err.response.data ? err.response.data.message : ''

          this.$store.dispatch('updateStatusText', this.statusText);

          this.hasDataPopulated = true
				
					this.loading = false

					this.pageChange = false;
					
					this.$Progress.fail();

          this.$router.push({ path:'/not-found',name: 'NotFound'});

				})
			},

    	updateStatesWithData(data) {

        const self = this;
      	
      	const stateData = this.$data;
      	
      	Object.keys(data).map(key => {
	      
	        if (stateData.hasOwnProperty(key)) {
	      
	          self[key] = data[key];
	        }
	      });
    	},

    	isValid(){
			
				const {errors, isValid} = validateApprovalTicketSettings(this.$data)
				
				if(!isValid){
					
					return false
				}
				return true
			},
			
			onChange(value, name){
			
				this[name]= value;
			},

			changePage(){

				this.pageChange = true;

				window.scrollTo({top: 100,behavior: 'smooth'})
				
				this.pagination = this.pagination;
				
				this.paramsObj['page'] = this.pagination
				
				this.getInitialValues(this.paramsObj);
			},

			onSubmit(url){
				
				if(this.isValid()){
				
					this.loading = true
				
					this.isDisabled = true
					
					this.$Progress.start();

					axios.post('/api/approval-action/'+this.hash,{ action_type:url,comment:this.comment}).then(res=>{

            successHandler(res, 'approval-converstaion')
				
						this.loading = false;
				
						this.isDisabled = false;
				
						this.comment = '';
				
						this.shallShowApprovalAction = false;

						this.$Progress.finish();
				
					}).catch(err => {

            errorHandler(err , 'approval-converstaion')
				
						this.loading = false
				
						this.isDisabled = false
				
						this.shallShowApprovalAction = true;

						this.$Progress.fail();
					})
				}
			},
		},
		components:{

			'thread-list': ThreadsList,
			
			'text-field': TextField,

			'ticket-details': TicketDetails
		}
	};
</script>

<style scoped type="text/css">
	#comment{
		margin-left:0px !important;
		border: 1px solid #d2d6de45 !important;
	}
	#approval_conversation_comment{
		margin-top: 10px !important;
	}
</style>
