<template>

	<div class="col-sm-12">

		<tickets-index v-if="!loading" :selectedColor="headerColor" :ticketPage="ticketPage" :key="counter"
			:permissions="tablePermissions">

		</tickets-index>

	</div>
</template>

<script>

	import TicketsIndex from "./View/TicketsIndex.vue";
	import axios from "axios";

	export default {

		name : 'inbox-layout',

		description : 'Inbox layout Component',

    props : {

      from : { type : String, default : '' }
    },

		data() {

      return {

        ticketPage : '',

        counter : 0,

	      loading : true,

	      tablePermissions : ''
      }
		},

    created() {

      window.emitter.on('refreshTicketPage', this.reloadPage);
    },

    beforeMount() {

      if(!this.from) {

        let decodedVal = JSON.parse('{"' + decodeURIComponent(location.search.substring(1)).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"').replace(/%2F/g, '\/') + '"}');

        this.ticketPage = decodedVal['show[]']

      } else {

        this.ticketPage = 'filter';
      }

	  this.getTablePermissions();
    },

    methods : {

	    getTablePermissions() {

		    axios.get('/ticket-datatable/permissions').then(res => {

			    this.tablePermissions = res.data.data;

				this.loading = false;

		    }).catch(error => {

			    this.loading = false;
		    })
	    },

      reloadPage() {
        this.counter += 1;
      }
    },

		components : {

			'tickets-index' : TicketsIndex,
		}
	};
</script>
<style>

.tooltip .tooltip-inner {
  background: black;
  color: white;
  padding: 5px 10px 4px;
}

.tooltip .tooltip-arrow {
  width: 0;
  height: 0;
  border-style: solid;
  position: absolute;
  margin: 5px;
  border-color: black;
}

.tooltip[x-placement^="top"] {
  margin-bottom: 5px;
}

.tooltip[x-placement^="top"] .tooltip-arrow {
  border-width: 5px 5px 0 5px;
  border-left-color: transparent !important;
  border-right-color: transparent !important;
  border-bottom-color: transparent !important;
  bottom: -5px;
  left: calc(50% - 5px);
  margin-top: 0;
  margin-bottom: 0;
}

.tooltip[x-placement^="bottom"] {
  margin-top: 5px;
}

.tooltip[x-placement^="bottom"] .tooltip-arrow {
  border-width: 0 5px 5px 5px;
  border-left-color: transparent !important;
  border-right-color: transparent !important;
  border-top-color: transparent !important;
  top: -5px;
  left: calc(50% - 5px);
  margin-top: 0;
  margin-bottom: 0;
}

.tooltip[x-placement^="right"] {
  margin-left: 5px;
}

.tooltip[x-placement^="right"] .tooltip-arrow {
  border-width: 5px 5px 5px 0;
  border-left-color: transparent !important;
  border-top-color: transparent !important;
  border-bottom-color: transparent !important;
  left: -5px;
  top: calc(50% - 5px);
  margin-left: 0;
  margin-right: 0;
}

.tooltip[x-placement^="left"] {
  margin-right: 5px;
}

.tooltip[x-placement^="left"] .tooltip-arrow {
  border-width: 5px 0 5px 5px;
  border-top-color: transparent !important;
  border-right-color: transparent !important;
  border-bottom-color: transparent !important;
  right: -5px;
  top: calc(50% - 5px);
  margin-left: 0;
  margin-right: 0;
}

.tooltip[aria-hidden='true'] {
  visibility: hidden;
  opacity: 0;
  transition: opacity .15s, visibility .15s;
}

.tooltip[aria-hidden='false'] {
  visibility: visible;
  opacity: 1;
  transition: opacity .15s;
}

.caret { border-top: 4px solid !important; }
</style>
