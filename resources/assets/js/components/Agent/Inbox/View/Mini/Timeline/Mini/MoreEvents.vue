<template>
	
	<div class="btn-group" id="more-evt">

		<button type="button" class="btn btn-xs btn-light rounded-1" data-bs-toggle="dropdown" v-tooltip="lang('more-actions')">

			<i class="fas fa-ellipsis-v"> </i>
		</button>

		<div class="dropdown-menu dropdown-menu-right">

			<a class="dropdown-item" href="javascript:;" @click="showRequesterModal = true">

				<i class="far fa-user"> </i> {{ lang('change_requester') }} 
			</a>
			
			<a class="dropdown-item" href="javascript:;" @click="showMergeModal = true">

				<i class="fas fa-cog"> </i> {{ lang('merge-ticket') }}
			</a>
			
			<a class="dropdown-item" href="javascript:;" @click="showForkModal = true">

				<i class="fas fa-code-branch"> </i> {{ lang('ticket-fork') }}
			</a>
		
			<a href="javascript:;" class="dropdown-item" @click="requestFeedback">

				<i class="far fa-star"></i>{{ lang('request-feedback') }}
			</a>
			
			<a v-if="actions.time_track_enabled" class="dropdown-item" href="javascript:;" @click="showTimeModal = true">

				<i class="far fa-clock"> </i> {{ lang('record_time') }}
			</a>

			<a  v-if="actionsList.change_duedate"  class="dropdown-item" href="javascript:;" @click="showDueModal = true">
				
				<i  class="far fa-calendar"> </i> {{lang('change_due_date')}}
			</a>

			<a  v-if="actionsList.surrender" class="dropdown-item" href="javascript:;" @click="showSurrenderModal = true">
				
				<i  class="fas fa-arrows-alt"> </i> {{lang('surrender')}}
			</a>

			<a  v-if="actionsList.transfer" class="dropdown-item" href="javascript:;" @click="showDeptModal = true">
				
				<i  class="far fa-hand-point-right"> </i> {{lang('change_department')}}
			</a>

		    <a href="javascript:;" class="dropdown-item" @click="showGenerateModal = true">
				    	
		    	<i class="far fa-file-pdf"> </i> {{ lang('generate_pdf') }}
		    </a>

			<a  v-if="actionsList.allowed_enforce_approval_workflow" class="dropdown-item" href="javascript:;" @click="showApprovalModal = true">
				
				<i  class="fas fa-pause"> </i> {{lang('apply_approval_workflow')}}
			</a>

			<a class="dropdown-item" href="javascript:;" @click="showForwardModal = true">

				<i  class="fas fa-forward"> </i> {{lang('forward_ticket')}}
			</a>
      <!-- iframe card -->
      <a class="dropdown-item" v-if="integration_status" v-tooltip="btnName" :class="{'bg-primary': integrateAppBtn === 'show_app'}" href="javascript:;" @click="integrationMethod">

        <i :class="btnIcon"></i> &nbsp; {{subString(btnName, 10)}}
      </a>
		</div>

		<transition name="modal">

			<due-date-modal v-if="showDueModal" :onClose="onClose" :showModal="showDueModal" 
				:ticketId="ticket.id" componentTitle="timeline" :reloadDetails="reloadData">

			</due-date-modal>
		</transition>

		<transition name="modal">

			<generate-pdf-modal v-if="showGenerateModal" :onClose="onClose" :showModal="showGenerateModal" :ticket="ticket">

			</generate-pdf-modal>
		</transition>

		<transition name="modal">

			<surrender-modal v-if="showSurrenderModal" :onClose="onClose" :showModal="showSurrenderModal" 
				:ticketId="ticket.id" componentTitle="timeline" :reloadDetails="reloadData">

			</surrender-modal>
		</transition>

		<transition name="modal">

			<change-dept-modal v-if="showDeptModal" :onClose="onClose" :showModal="showDeptModal" 
				:ticketId="ticket.id" componentTitle="timeline" :reloadDetails="reloadData">

			</change-dept-modal>
		</transition>

		<transition name="modal">

			<approval-modal v-if="showApprovalModal" :onClose="onClose" :showModal="showApprovalModal" 
				:ticketId="ticket.id" componentTitle="timeline" :reloadDetails="reloadData">

			</approval-modal>
		</transition>

		<transition name="modal">

			<forward-modal v-if="showForwardModal" :onClose="onClose" :showModal="showForwardModal" 
				:ticketId="ticket.id" componentTitle="timeline" :reloadDetails="reloadData">

			</forward-modal>
		</transition>

		<transition name="modal">

			<change-requester-modal v-if="showRequesterModal" :onClose="onClose" :showModal="showRequesterModal" 
				:ticketId="ticket.id" componentTitle="timeline" :reloadDetails="reloadData">

			</change-requester-modal>
		</transition>

		<transition name="modal">
		
			<timeline-merge-modal v-if="showMergeModal" :onClose="onClose" :showModal="showMergeModal" 
				:ticket="ticket" componentTitle="timeline" :reloadTickets="reloadData">

			</timeline-merge-modal>
		</transition>

		<transition name="modal">
		
			<ticket-fork-modal v-if="showForkModal" :onClose="onClose" :showModal="showForkModal" 
				:ticketId="ticket.id" componentTitle="timeline" :reloadDetails="reloadData" :selectedFormData="ticket.form">

			</ticket-fork-modal>
		</transition>

		<transition name="modal">
		
			<record-time-modal v-if="showTimeModal" :onClose="onClose" :showModal="showTimeModal" 
				:ticketId="ticket.id" componentTitle="timeline" :updateData="updateTimeTrack">

			</record-time-modal>
		</transition>

		<div  v-if="loading" class="row">
						
						<custom-loader :size="60"/>
					</div>
	</div>
</template>

<script>

	import { successHandler, errorHandler } from "../../../../../../../helpers/responseHandler";

	import axios from 'axios';
	import ChangeRequesterModal from "./ChangeRequesterModal.vue";
	import TicketFork from "./TicketFork.vue";
	import RecordTimeModal from "./RecordTimeModal.vue";
	import TimelineMergeModal from "./TimelineMergeModal.vue";
	import SurrenderModal from "./SurrenderModal.vue";
	import DepartmentModal from "./DepartmentModal.vue";
	import ApprovalWorkflowModal from "./ApprovalWorkflowModal.vue";
	import ForwardModal from "./ForwardModal.vue";
	import DueDateModal from "./DueDateModal.vue";
	import PdfModal from "./PdfModal.vue";
  import {getSubStringValue} from "../../../../../../../helpers/extraLogics";
	
	export default {
		
		props : {

			actions : { type : Object, default : ()=> {} },

			ticket : { type : Object, default : ()=> {} },

			user : { type : Object, default : ()=> {} },

			updateDetails : { type : Function }
		},
		
		data() {
			
			return {

				showRequesterModal : false,

				showMergeModal : false,
				
				showForkModal : false,
				
				showTimeModal : false,

				showDueModal : false,

				showApprovalModal : false,

				showForwardModal : false,

				showSurrenderModal : false,

				showDeptModal : false,

				showGenerateModal : false,

				loading : false,

				actionsList : this.actions,

        integration_status : false,

        btnName : '',

        btnIcon: '',

        integrateAppBtn : 'hide_app',

        integration_data : []
			}
		},
    created () {
      //on clicking refresh, it will refresh the iframe card also
      window.emitter.on('iframeReload', this.getIntegrationStatus);
    },

    mounted() {

      this.getIntegrationStatus();
    },

		methods: {

      subString(value, count = 30){
        return getSubStringValue(value,count);
      },

			reloadData(from) {

				this.updateDetails(from);
			},

			updateTimeTrack() {

				window.emitter.emit('refreshTimeTrack')
			},

			onClose() {

				this.showRequesterModal = false;

				this.showMergeModal = false;
				
				this.showForkModal = false;
				
				this.showTimeModal = false;

				this.showDueModal = false;

				this.showSurrenderModal = false;

				this.showDeptModal = false;

				this.showApprovalModal = false;

				this.showForwardModal = false;

				this.showGenerateModal = false;
			},

			requestFeedback()
			{	
				this.loading = true;

				axios.post('/api/request/rating/'+this.ticket.id).then(res=>{

					this.loading = false;

					successHandler(res,'timeline');
				}).catch(err=>{
					
					this.loading = false;

					errorHandler(err,'timeline')
				})
			},

      //get iframe data on mounting and on pressing refresh button
      getIntegrationStatus() {
        axios.get("/api/integration-status?route_name=Ticket Details&ticket_id="+this.ticket.id).then(res => {
          if(res.data.data.integrations.length > 0) {
            this.integration_status = true;
          }
          this.btnName = res.data.data.integrations[0]?.button_name;
          this.btnIcon = res.data.data.integrations[0]?.button_icon;
          this.integration_data = res.data.data.integrations
          window.emitter.emit('showIframeCard', { integration_btn: this.integrateAppBtn, integration_data: this.integration_data, reload: true });
        }).catch(err => {
          this.loading = false;
        })
      },

      integrationMethod() {
        this.integrateAppBtn = this.integrateAppBtn === 'hide_app' ?  'show_app' : 'hide_app';
        //to show/hide the iframe card
        window.emitter.emit('showIframeCard', { integration_btn: this.integrateAppBtn, integration_data: this.integration_data, reload: false });
      },
		},

		components : {

         'change-requester-modal' : ChangeRequesterModal,

         'ticket-fork-modal' : TicketFork,

         'record-time-modal' : RecordTimeModal,

         'timeline-merge-modal': TimelineMergeModal,

         'surrender-modal' : SurrenderModal,

         'change-dept-modal' : DepartmentModal,

         'approval-modal' : ApprovalWorkflowModal,

         'forward-modal' : ForwardModal,

         'due-date-modal' : DueDateModal,

         'generate-pdf-modal' : PdfModal,
		}
	};
</script>

<style scoped>
	#more-evt .btn-xs { font-size: 0.75rem !important; }
</style>
