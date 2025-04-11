<template>

	<div id="agent-tickets-table">

		<div class="row">

			<div class="col-md-12">

				<alert componentName="UserTickets"/>
			</div>
		</div>

		<div class="card card-light card-outline">

			<div class="card-header border-0">

				<div v-if="role && !disabled_process" class="float-end user_view">

					<template v-if="showDiv">

						<div v-if="role === 'user'" id="users-action-div" class="inline-block">{{userActionDivMounted()}}</div>


          </template>

					<template v-if="getUserData && getUserData.user_data.id != id ">

						<button v-if="role !== 'user'" type="button" class="btn btn-xs btn-light" @click="changeRole('user')"
						id="user_role">

							<i class="fas fa-male">&nbsp;&nbsp;</i>{{lang('change_role_to_user')}}
						</button>

						<button v-if="role !== 'agent'" type="button" class="btn btn-xs btn-light" @click="changeRole('agent')"
							id="agent_role">

							<i class="fa-solid fa-user-tie">&nbsp;&nbsp;</i>{{lang('change_role_to_agent')}}
						</button>

						<button v-if="role !== 'admin' && userRole === 'admin'" type="button" class="btn btn-xs btn-light" @click="changeRole('admin')"
							id="admin_role">

							<i class="fa-solid fa-user-gear">&nbsp;&nbsp;</i>{{lang('change_role_to_admin')}}
						</button>

					</template>

					<router-link v-if="role == 'user'" :to="'/user/'+id+'/edit'" class="btn btn-xs btn-light">

						<i class="fas fa-edit">&nbsp;&nbsp;</i>{{lang('edit')}}
					</router-link>

					<router-link v-else :to="'/agent/'+id+'/edit'" class="btn btn-xs btn-light">

						<i class="fas fa-edit">&nbsp;&nbsp;</i>{{lang('edit')}}
					</router-link>

					<button type="button" class="btn btn-xs btn-light" @click="showPasswordModal = true" id="show_pass" v-if="getUserData && getUserData.user_data.id != id ">

						<i class="fas fa-lock">&nbsp;&nbsp;</i>{{lang('change_password')}}
					</button>

					<template v-if="getUserData && getUserData.user_data.id != id ">

						<button type="button" class="btn btn-xs btn-light"  @click="showDeactivateModal = true" id="deactive_pop">

							<i class="fas fa-trash">&nbsp;&nbsp;</i>{{lang('deactivate')}}
						</button>
					</template>

					<button v-if="two_factor" type="button" class="btn btn-xs btn-light" @click="showDisable2FA = true">

						<i class="fas fa-ban">&nbsp;&nbsp;</i>{{lang('disable_2fa')}}
					</button>
				</div>
			</div>

			<div class="card-body">

				<div v-if="hasDataPopulated">

					<template v-if="!loading">

						<ul class="nav nav-tabs" role="tablist">

							<li v-for="section in tabs" class="nav-item">

								<a class="nav-link" :class="{ active: category === section.id }" data-bs-toggle="pill" role="tab" href="javascript:;"
									@click="tickets(section)" id="tickets_tab">

									{{lang(section.title)}} <span class="badge text-bg-primary">{{section.count}}</span>
								</a>
							</li>
						</ul>

						<div class="tab-content">

							<div class="active tab-pane" role="tabpanel">

								<div class="mt-3">
									<button type="button" @click="mergeTicket()" class="btn btn-xs btn-light" id="merge_ticket">

										<i class="fas fa-code-branch"> </i> {{lang('merge')}}
									</button>

									<div class="btn-group" :key="statusDiv">

										<button v-tooltip="lang('change_status')" type="button" class="btn btn-xs btn-light dropdown-toggle"
											data-bs-toggle="dropdown" @click="getStatusList()" id="status">

											<i class="fas fa-exchange-alt"> </i> {{lang('change_status')}}
										</button>

										<div class="dropdown-menu status-list" v-if="ticketId.length > 0">

											<div  v-if="statusLoader" class="row">

													<reuse-loader :animation-duration="4000" color="#1d78ff" :size="30"/>

											</div>

											<template v-if="!statusLoader">

												<template v-if="statusList && statusList.length > 0">

													<a v-for="status in statusList" class="dropdown-item" @click="getStatus(status)" href="javascript:;"
														id="change_status">

														<i :class="status.icon" :style="{color:status.icon_color}"> </i> &nbsp;{{status.name}}
													</a>
												</template>

												<a v-if="statusList && statusList.length === 0" class="dropdown-item" href="javascript:;">
													{{lang('no-records')}}
												</a>
											</template>
										</div>
									</div>

									<button v-if="ticketId.length > 0" type="button" @click="showAssignModal = true"
										class="btn btn-xs btn-light" id="assign_ticket">

										<i class="far fa-hand-point-right"> </i> {{lang('assign')}}
									</button>

								</div>

								<div id="my_tic">

									<agent-tickets-table :category="category" :id="id" :tickets="ticketsData" :key="category"
										:apiUrl="apiUrl" :componentTitle="componentTitle" scroll_to="agent-tickets-table" :allTickets="allData">

									</agent-tickets-table>
								</div>
							</div>
						</div>
					</template>
				</div>

				<div v-if="!hasDataPopulated && loading" class="row">

					<reuse-loader :animation-duration="4000" :size="60"/>
				</div>

				<transition  name="modal">

					<change-status-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :statusIds="statusIds" :ticketIds="ticketId" :status="change_status" :componentTitle="componentTitle">

					</change-status-modal>
				</transition>

				<transition  name="modal">
					<merge-ticket-modal v-if="showMergeModal" :onClose="onClose" :showModal="showMergeModal" :parent_tickets="parent_tickets" :ticketIds="ticketId" :componentTitle="componentTitle">

					</merge-ticket-modal>
				</transition>

				<transition  name="modal">
					<assign-ticket-modal v-if="showAssignModal" :onClose="onClose" :showModal="showAssignModal"
						:ticketIds="ticketId" :componentTitle="componentTitle" :tickets="allEntries">

					</assign-ticket-modal>
				</transition>

				<transition  name="modal">

					<user-role-modal v-if="showRoleModal" :onClose="onClose" :showModal="showRoleModal"
						:role_to="role_to" :role="role" :userId="id" :dept="dept" :user="user">

					</user-role-modal>
				</transition>

				<transition  name="modal">

					<password-change-modal v-if="showPasswordModal" :onClose="onClose" :showModal="showPasswordModal"
						:userId="id">

					</password-change-modal>
				</transition>

				<transition  name="modal">

					<user-deactivate-modal v-if="showDeactivateModal" :onClose="onClose" :showModal="showDeactivateModal"
						:userId="id" :role="role" :user="user">

					</user-deactivate-modal>
				</transition>

				<transition name="modal">

					<remove-modal v-if="showDisable2FA" :onClose="onClose" :showModal="showDisable2FA" alertName="user-view" :id="id" from="user_view">

					</remove-modal>
				</transition>
        <transition name="modal">

          <merge-user-modal v-if="showMergeUSerModal" :onClose="onClose" :showModal="showMergeUSerModal"  :userId="id">

          </merge-user-modal>
        </transition>
			</div>
		</div>
	</div>
</template>

<script>

	import axios from 'axios'

	import {arrayUnique} from "../../../../helpers/extraLogics";

	import {useStore} from 'vuex'
	import {computed} from "vue";
	import TicketsTable from "../../TicketsComponents/TicketsTable.vue";
	import ChangeStatusModal from "../../TicketsComponents/ChangeStatusModal.vue";
	import MergeTicketModal from "../../TicketsComponents/MergeTicketModal.vue";
	import AssignTicketModal from "../../TicketsComponents/AssignTicketModal.vue";
	import UserRoleModal from "./MiniComponents/UserRoleModal.vue";
	import PasswordChangeModal from "./MiniComponents/PasswordChangeModal.vue";
	import UserDeactivateModal from "./MiniComponents/UserDeactivateModal.vue";
	import RemoveVerification from "../../Views/Profile/RemoveVerification.vue";
  import MergeUser from "./MiniComponents/MergeUserModal.vue";
  import {errorHandler} from "../../../../helpers/responseHandler";


  export default {

		name : 'agent-tickets',

		description : 'Agent panel tickets page',

		setup() {

			const store = useStore();

			return {

				getUserData : computed(()=>store.getters.getUserData)
			}
		},

		props : {

			data : { type : Object, default : ()=> {} },

			afterAction : { type : Function, default : ()=>{} },

			dept : { type : Array, default : ()=>[]},

			role : { type : String, default : ''},

			id : { type : [String,Number], default : ''},

			user : { type : Object, default : ()=>{}},

			two_factor : { type : [Boolean, Number], default : false},

			disabled_process : { type : [Boolean, Number], default : false},

			permissions : { type : Array, default :() => [] },

      reloadDetails : { type : Function }
		},

		data() {

			return {

        currentTabId : 1,

				category:'',

				status_type : '',

				tabs:[],

				loading:true,

				hasDataPopulated : false,

				ticketId:[],

				showModal : false,

				statusList : '',

				showMergeModal : false,

				showAssignModal : false,

				showRoleModal : false,

				showPasswordModal : false,

				showDeactivateModal : false,

				parent_tickets : [],

				change_status : '',

				role_to : '',

				componentTitle : 'UserTickets',

				apiUrl : '',

				showDisable2FA : false,

				ticketTabData : {},

				statusLoader  : false,

				statusDiv : 0,

				allEntries : [],

				showPermissionModal : false,

				showDiv : true,

        showMergeUSerModal : false,

			}
		},

		beforeMount(){

			this.category = 'open';

			this.getCount();


		},

		computed : {

			updatedPermissions() {

				return this.permissions;
			},

			userRole(){
				return sessionStorage.getItem('user_role');
			}
		},

		created () {

			window.emitter.on('refreshUserActions',this.updateActionsDiv);
		},

		methods :{

      reloadData(from) {

        this.afterAction(from);
      },

			updateActionsDiv() {

				this.showDiv = false;

				setTimeout(()=>{

					this.showDiv = true;

				},1000)
			},

			userActionDivMounted() {

				let data = {};

				data['user_id'] = this.id;

				data['permissions'] = this.updatedPermissions;

        		data['labels'] = this.labels;

				window.emitter.emit("user-permission-mounted", data);

			},

			getStatusList(){

				this.statusList = '';

				if(this.ticketId.length > 0){

					this.statusLoader = true;

					let params = {meta: true, supplements:arrayUnique(this.ticketId),limit : 'all'}

					axios.get('/api/dependency/statuses',{params}).then(res =>{

						this.statusLoader  = false

						this.statusList=res.data.data.statuses;

					}).catch(err=>{

						this.statusLoader  = false
					})
				} else {

					this.statusDiv +=1;

          this.$store.dispatch('setAlert', {
            type: 'danger',
            message: (this.lang('please_select_tickets')),
            component_name: 'UserTickets'
          })
				}
			},

			getStatus(status){

				if(this.ticketId.length > 0){

					this.showModal = true

					this.change_status = status

					this.statusIds = this.tic_statuses

				}else {

          this.$store.dispatch('setAlert', {
            type: 'danger',
            message: (this.lang('please_select_tickets')),
            component_name: 'UserTickets'
          })

					this.showModal = false
				}
			},

			mergeTicket(){

				if(this.ticketId.length > 1){

					this.showMergeModal = true

					axios.get('/api/agent/tickets/get-merge-tickets',{ params : {'ticket-ids' : this.ticketId} }).then(res=>{

						this.parent_tickets = res.data.data

						for (var i in this.parent_tickets) {

							this.parent_tickets[i].id = this.parent_tickets[i]['ticket_id'];

							this.parent_tickets[i].subject = this.parent_tickets[i]['name'];

							this.parent_tickets[i].name = this.parent_tickets[i]['title'];

							delete this.parent_tickets[i].ticket_id;

							delete this.parent_tickets[i].title;
						}
					})

					this.parent_tickets = [];
				}else {

					this.showMergeModal = false

          this.$store.dispatch('setAlert', {
            type: 'danger',
            message: (this.lang('please_select_more_tickets')),
            component_name: 'UserTickets'
          })
				}
			},

			tickets(category){
				this.category = category.id
				this.apiUrl = category.url
			},


			changeRole(role){

				this.role_to = role;

				this.showRoleModal = true;
			},

			onClose(){

				this.showModal = false;

				this.showMergeModal = false;

				this.showAssignModal = false;

				this.showRoleModal = false;

				this.showPasswordModal = false;

				this.showDeactivateModal = false;

				this.showDisable2FA = false;

				this.showPermissionModal = false;

        this.showMergeUSerModal = false;
				
				this.getCount();

				this.$store.dispatch('unsetValidationError');
			},

			ticketsData(data){

				this.ticketId = data
			},

			allData(data) {

				this.allEntries = data;
			},

			getCount(){

				let params;

				let endPoint = 'api/agent/ticket-count?';

        		let path = window.location.pathname.split('/');

				if(path[path.length-2] === 'user'){
					params = 'owner-ids[]='+this.id;
					endPoint += params;
				}

				else {
					params = 'assignee-ids[]='+this.id;
					endPoint += params;
				}

				axios.get(endPoint).then(res=>{

					this.hasDataPopulated = true;

					this.loading = false;

					this.tabs = [];

					for (var key in res.data.data) {

						if (res.data.data.hasOwnProperty(key)) {

							let tabsBody = { id : key, title : key, count : res.data.data[key]}

							switch(tabsBody.title) {
								case 'open':
									tabsBody['url'] = 'api/agent/ticket-list?category=inbox&'+params;
									break;
								case 'closed':
									tabsBody['url'] = 'api/agent/ticket-list?category=closed&'+params;
									break;
								case 'deleted':
									tabsBody['url'] = 'api/agent/ticket-list?category=deleted&'+params;
									break;
								case 'unapproved':
									tabsBody['url'] = 'api/agent/ticket-list?category=unapproved&'+params;
									break;
							}

							this.tabs.push(tabsBody)
						}
					}

					this.tickets(this.tabs[0])

				}).catch(error=>{

					this.hasDataPopulated = true;

					this.loading = false;
				})
			},

			updateStatus(status){

				this.showModal = true

				this.change_status = status;
			},

      mergeUSerModal() {
        this.showMergeUSerModal = true;
      },
		},

		components : {

			'agent-tickets-table' : TicketsTable,

			'change-status-modal': ChangeStatusModal,

			'merge-ticket-modal': MergeTicketModal,

			'assign-ticket-modal': AssignTicketModal,

			'user-role-modal': UserRoleModal,

			'password-change-modal': PasswordChangeModal,

			'user-deactivate-modal': UserDeactivateModal,

			'remove-modal' : RemoveVerification,

      'merge-user-modal' : MergeUser,
		}
	};
</script>

<style scoped>

	.user_view .btn { margin-bottom: 5px; }

	.inline-block { display: inline-block !important; }
</style>