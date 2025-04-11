<template>

	<div  id="inbox-associates">

		<ticket-approval-progress v-if="getTicketActions.view_approval_progress" :actions="getTicketActions" :id="ticketId"></ticket-approval-progress>

		<ticket-time-track v-if="getTicketActions.time_track_enabled" :id="ticketId"></ticket-time-track>

    <associated-tickets :ticket-id="ticketId" :key="refreshKey"/>
		
		<div id="timeline-tab">{{timelineTabVisible()}}</div>	

		<div id="timeline-display-box-tasks">{{ timelineBoxVisibleTasks() }}</div>
		
		<div id="timeline-boxes">{{timelineBoxVisible()}}</div>

	</div>
</template>

<script>

	import {useStore} from 'vuex';

	import { scrollToElement } from "../../../../../../helpers/extraLogics";

	import AssociatedTickets from "./AssociatedTickets.vue";

	import {computed} from "vue";
	import InboxApproval from "../Actions/Mini/InboxApproval.vue";
	import InboxRecordedTime from "../Actions/Mini/InboxRecordedTime.vue";

	export default {

		name : 'inbox-associates',

		description : 'Inbox Assciates Component',

		setup() {

			const store = useStore();

			return {

				getTicketActions : computed(()=>store.getters.getTicketActions)
			}
		},

		props : {

			ticketId : { type : [String, Number], default : '' },

			ticketData: { type : Object, default : ()=>{} }
		},

    created() {
      // associated tickets will be hidden if no associated tickets found;
      // so listening for `updateTimelineActivity` to check for associated tickets.
      window.emitter.on('updateTimelineActivity',() => {
        this.refreshKey++;
      })
    },

    data() {
      return {
        refreshKey: Math.floor((Math.random()*10000)+1),
      }
    },

		methods : {

			scrollCurrent(id = 'inbox-associates', num = 140){

				return scrollToElement(id,num)
			},

			timelineTabVisible() {

    			if(this.getTicketActions){

					window.emitter.emit('ticket-tab-mounted',{...this.getTicketActions, 'disableLoader' : 'true'})
				}
    		},

    		timelineBoxVisibleTasks() {
				
				window.emitter.emit('ticket-timeline-mounted-tasks',this.ticketId);
			},

			timelineBoxVisible() {
    			window.emitter.emit('ticket-timeline-boxes-mounted',this.ticketData);
    		},
		},

		components :{

			'ticket-approval-progress' : InboxApproval,

			'ticket-time-track' : InboxRecordedTime,

			'associated-tickets' : AssociatedTickets
		}
	};
</script>