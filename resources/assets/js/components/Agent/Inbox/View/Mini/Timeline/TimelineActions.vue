<template>

	<span class="timeline-actions-span">

  		<template v-if="!actions.block_ticket_actions && actions.view_tickets_without_actions">

        <!-- Conditionally renders the AI ticket summary modal if the `summarize_ticket_key` setting is active.-->
        <!-- The HTML content for the AI ticket summary modal.-->
        <div v-if="hasIsSettingActiveGetter && (isSettingActive('summarize_ticket_key') || isSettingActive('article_generate')) " id="ai-ticket-summary-modal" class="inline-block"> {{loadSummarizeModal()}} </div>

   			<!-- labels -->
        	<ticket-label v-if="!data.ticketMerged" :ticketObj="data" :reloadDetails="reloadData"></ticket-label>

			<!-- tags -->
			<ticket-tag v-if="!data.ticketMerged" :ticketObj="data" :reloadDetails="reloadData"></ticket-tag>

     		<div v-if="!data.ticketMerged" id="timeline-action-div" class="inline-block">{{timelineActionDivMounted()}}</div>

   			<div v-if="!data.ticketMerged" id="timeline-action-bar" class="inline-block">{{timelineActionBarMounted()}}</div>

  		</template>

  		<slot name="left-actions"></slot>

  		<more-events v-if="!actions.block_ticket_actions && actions.view_tickets_without_actions && !data.ticketMerged" :actions="actionsList" :ticket="data" :updateDetails="reloadData">

		</more-events>
 	</span>
</template>

<script>

	import TicketLabel from "./Mini/TicketLabel.vue";
	import TicketTags from "./Mini/TicketTags.vue";
	import MoreEvents from "./Mini/MoreEvents.vue";
  import { mapGetters } from 'vuex';

	export default {

    name: 'timeline-action',

    description: 'Timeline Actions Component',

  props : {

    actions : { type : [Object, String], default : '' },

    id : { type : [String, Number], default : '' },

    data : { type : Object, default : ()=> {} },

    afterAction : { type : Function, default : ()=>{} },
  },

  data() {

    return {

      actionsList : this.actions,
    }
  },

  methods : {

    reloadData(from) {

      this.afterAction(from);
    },

    timelineActionBarMounted(){

      this.data['alertName'] = 'timeline';
      // if i could pass data to it
		window.emitter.emit('timeline-action-bar-mounted', this.data);
    },

    timelineActionDivMounted(){

		this.data['alertName'] = 'timeline';
		this.data['showTaskCount'] = true;

		this.data['ticket_id'] = this.id;

		// Following two lines are added to generalize task module
		this.data['entity_id'] = this.id;
		this.data['entity_type'] = 'ticket'
		// if i could pass data to it

            window.emitter.emit('timeline-action-div-mounted', this.data);
         },

    loadSummarizeModal(){

      // Emits the 'elea-ticket-summary-loaded' event with the ticket data and a summary identifier.
      window.emitter.emit('elea-ticket-summary-loaded', {'ticketData' : this.data, 'summary_for': 'ticket'});
    }
  },

    computed: {
      // Maps Vuex getters to computed properties.
      // isSettingActive - Getter to check if a specific setting is active.
      ...mapGetters(['isSettingActive']),


      // The event `elea-ticket-summary-loaded` is emitted with the ticket data and a summary identifier.
      hasIsSettingActiveGetter() {
        return this.$store.getters.hasOwnProperty('isSettingActive');
      }
    },

		components : {
			
			'ticket-label' : TicketLabel,
          
         'ticket-tag' : TicketTags,

         'more-events' : MoreEvents,
		}
	};
</script>


<style>

.smaller { font-size: smaller !important; }

.ticket_actions .btn { margin-bottom: 5px; font-size: 13px !important;}

.ticket_actions .btn-group .btn { margin-bottom: 5px; font-size: 13px !important; }

/*#timeline-action-bar .btn { margin-bottom: 5px; }*/

.inline-block{ display: inline-block; }

.ticket_actions { padding-top: 6px;padding-bottom: 2px; }

.br-25 { border-radius: 0.25rem; }
</style>
