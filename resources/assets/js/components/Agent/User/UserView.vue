<template>
	
	<div class="col-sm-12">
	
		<div class="row">
			
			<div class="col-md-12">
				
				<alert componentName="user-view"/>
			</div>
		</div>

		<div v-if="!loading && userData" class="row">

			<template v-if="userData.active">
				
				<div class="col-md-4">
		
					<user-details :data="userData"></user-details>

          <iframe-injection v-if="integration_status" :integrationData="integration_data"></iframe-injection>
				</div>

				<div class="col-md-8">

					<user-tickets v-if="userId" :id="userId" :role="userData.role" :dept="userData.departments" :user="userData" :two_factor="userData.is_2fa_enabled" 
					:disabled_process="userData.processing_account_disabling" :permissions="userData.permissions">
						
					</user-tickets>

					<login-logs :userId="userId"></login-logs>

					<div v-if="location === 'user'" id="user-page-table">{{userPageVisible()}}</div>

					<div id="user-view-table">{{userBoxVisible()}}</div>

					<user-report v-if="userId" :id="userId" :name="userData.full_name"></user-report>
				</div>
			</template>

			<template v-else>
				
				<div class="col-md-12">
						
					<div class="row">

						<div class="col-md-12" style="margin-top:-15px;">
						
							<div id="page" class="hfeed site">
						
								<article class="hentry error404 text-center">
						
									<h1 class="error-title">
						
										<i class="fa fa-user-times text-info" style="color: grey"></i>
									</h1>
									
									<h2 class="entry-title text-muted">
										{{ userData.is_delete ? lang('user-account-deleted') : lang('user-account-deactivated')}}
									</h2>
									
									<div class="entry-content clearfix" v-if="!userData.is_delete">
											
										<p>
											<button type="button" class="btn btn-primary btn-sm" @click="showModal = true">{{lang('restore-account')}}</button>

											<button type="button" class="btn btn-primary btn-sm" @click="showDeleteModal = true">{{lang('delete_account')}}</button>
										</p>
									</div>
								</article>
							</div>
						</div>
					</div>
				</div>
			</template>
		</div>

		<div v-if="loading" class="row">
				
			<reuse-loader :animation-duration="4000" :size="60"/>
		</div>

		<transition  name="modal">
				
			<user-restore-modal v-if="showModal" :onClose="onClose" :showModal="showModal" 
				:userId="userId">
						
			</user-restore-modal>
		</transition>

		<transition  name="modal">
				
			<user-delete-modal v-if="showDeleteModal" :onClose="onClose" :showModal="showDeleteModal" 
				:userData="userData">
						
			</user-delete-modal>
		</transition>
	</div>
</template>

<script>
	
	import {errorHandler} from "../../../helpers/responseHandler";

	import {getIdFromUrl, lang} from "../../../helpers/extraLogics";

	import axios from 'axios'
	import UserDetails from "./View/UserDetails.vue";
	import UserTickets from "./View/UserTickets.vue";
	import UserReport from "./View/UserReport.vue";
	import UserRestoreModal from "./View/MiniComponents/UserRestoreModal.vue";
	import UserDeleteModal from "./View/MiniComponents/UserDeleteModal.vue";
	import LoginLogs from "../Profile/LoginLogs.vue";
  import IframeInjection from "../Inbox/View/Mini/Timeline/IframeInjection.vue";

	export default {
		
		name : 'user-view',

		description : 'User view page',

		props : {

			authInfo : { type : Object, default :  ()=>{}}
		},

		data() {
			return {

				userId : '',

				loading : true,

				userData : '',

				location : '',

				showModal : false,

				showDeleteModal : false,

        refreshVerifyStatus : false,

        integration_status: false,

        integrateAppBtn: 'show_app',

        integration_data: []
			}
		},

		created(){

			window.emitter.on('refreshUserData',this.refreshUserDetails);

			window.emitter.on('updateEditData',this.refreshUserDetails);

      window.emitter.on('refreshMailAndMobile', () => {

        this.refreshVerifyStatus = true;

      });
		},

		beforeMount(){

			const path = window.location.pathname;
			
			let splitPath = path.split('/');

			this.location = splitPath[splitPath.length-2];

			this.userId = getIdFromUrl(path);

			this.getInitialValues(this.userId);

      this.getIntegrationStatus();
		},

		methods :{

			refreshUserDetails(from = ''){

				if(from){

					setTimeout(()=>{

						this.loading = true;

						this.getInitialValues(this.userId);
					},2000);
				} else {

					this.getInitialValues(this.userId);
				}
			},

			getInitialValues(id){

				axios.get('/api/get-user/view/'+id).then(res=>{
					
					this.userData = res.data.data;

					if(this.userData.processing_account_disabling) {

						this.$store.dispatch('setAlert',{type:'warning', duration : 500000,
							message:lang('processing_account_disabling'), component_name : 'user-view'})
					}

					this.loading = false
				
				}).catch(err=>{

					this.loading = false

					errorHandler(err,'layout');

					this.redirect('/panel/dashboard');
				})
			},
			userPageVisible(){
				
				window.emitter.emit('user-page-mounted',{'disableLoader':'true'});
			},

			userBoxVisible(){
				
				window.emitter.emit('user-box-mounted',{user_id : this.userId,'from' : 'user', user:this.userData, 'disableLoader':'true'});
			},

			onClose(){
				
				this.showModal = false;

				this.showDeleteModal = false;
				
				this.$store.dispatch('unsetValidationError');
			},

      getIntegrationStatus() {
        axios.get("/api/integration-status?route_name=User Profile&user_id="+this.userId).then(res => {
          if(res.data.data.integrations.length > 0) {
            this.integration_status = true;
          }
          this.integration_data = res.data.data.integrations
        }).catch((err) => {
          errorHandler(err, 'layout')
        })
      },
		},

    watch: {

      refreshVerifyStatus (newValue, oldValue) {

        if (newValue === true) {

          this.getInitialValues(this.userId);
        }
        this.refreshVerifyStatus = false;
      }
    },

		components : {

			'user-details' : UserDetails,
			
			'user-tickets' : UserTickets,

			'user-report' : UserReport,

			'user-restore-modal': UserRestoreModal,

			'user-delete-modal': UserDeleteModal,

			'login-logs' : LoginLogs,

      'iframe-injection': IframeInjection
		}
	};
</script>

<style scoped>
	
	#dept_mgr{
		min-height: 120px;
	}
</style>