<template>

  <data-table :url="apiUrl" :dataColumns="columns"  :option="options" :tickets="tickets"
    scroll_to="client-tickets-table" :inputStyle="inputStyle" :color="layout.portal.client_header_color"
    :alert-component-name="alertComponentName">
        
  </data-table>
	
</template>

<script>

  import { mapGetters } from 'vuex'

	export default {
		
    name : 'client-tickets-table',

		description : 'Client panel tickets page',

		props : {
    
      tickets : { type : Function, default : ()=>[]},

      layout : { type : Object, default : ()=>{}},

      inputStyle : { type : Object, default : ()=>{}},

      apiUrl : { type : String, default : ''},

      loggedInId : { type : [String, Number], default : ''},

      /**
			 * Alert component name to dispatch alert box
			 */
			alertComponentName: { type: String, default: '' },
  },

		data() {

			return {

      selectedTickets : this.tickets,

      columns: ['id', 'ticket_number', 'title', 'user', 'last_replier', 'statuses', 'updated_at'],
      
      options : {},
			}
		},

    beforeMount(){

      const self = this;

      this.options = {

        sortIcon: {
          
          base : 'glyphicon',
          
          up: 'glyphicon-chevron-down',
          
          down: 'glyphicon-chevron-up'
        },

        headings: {

          id : this.trans('id'),

          title: self.lang('subject'),

          ticket_number : self.lang('ticket_id'),

          user: self.lang('requester'),

          last_replier : self.lang('last_replier'),

          updated_at: self.lang('last_activity'),

          statuses : self.lang('status')
        },

        columnsClasses : {

          id : 'ticket-id',

          title: 'ticket-title',

          ticket_number : 'ticket-number',

          user: 'ticket-user',

          last_replier: 'ticket-reply',

          updated_at: 'ticket-updated',

          statuses: 'ticket-status',
        },
        
        texts : { 

          filter : '', 

          limit : ''
        },
        
        templates: {

          title: function(createElement, row) {

            var cc_tag = '';

            if(self.loggedInId != row.user_id){

              if(row.collaborator.length > 0){

                let result = row.collaborator.map(a => a.user_id);

                let present = result.includes(self.loggedInId);

                cc_tag = present ? self.h('span',{ class : 'badge badge-info'},'CC') : '';
              }
            }

            return self.h('a', {
                href : 'javascript:;',
                style : `color:${self.layout.portal.client_header_color}`,
                onClick(event) {
                    self.$router.push('/check-ticket/' + row.encrypted_id)
                }
            }, (row.first_thread ? row.first_thread.title : '') + ' ('+row.strictly_thread_count+') ',[cc_tag] )
          },
          
          updated_at(h,row){

            return self.formattedTime(row.updated_at)
          },

          statuses(h,row){

            return row.statuses ? row.statuses.name : '--';
          },
          
          user: function(createElement, row) {
              
             return self.h('p', {}, row.user.full_name);
          },

          last_replier: function(createElement, row) {

             return self.h('p', {}, (row.last_thread ? row.last_thread.user.full_name : ''));
          },

          ticket_number: function(createElement, row) {

             return self.h('a', {

                 href : 'javascript:;',

                 onClick(event) {
                     self.$router.push( '/check-ticket/' + row.encrypted_id)
                 },

                 style : `color:${self.layout.portal.client_header_color}`

             }, '#'+row.ticket_number);
          }
        },
        
        sortable:  ['ticket_number','updated_at'],
        
        filterable:  ['ticket_number','updated_at'],
        
        pagination:{chunk:5,nav: 'fixed',edge:true},
        
        requestAdapter(data) {

          return {
        
            'sort-field': data.orderBy ? data.orderBy : 'updated_at',
        
            'sort-order': data.ascending ? 'desc' : 'asc',
        
            'search-query':data.query.trim(),
        
            'page':data.page,
        
            'limit':data.limit,
          }
        },
        
        responseAdapter({data}) {
          
          return { data : data.data.data, count: data.data.total }
        },

	      orderBy: { column: 'updated_at', ascending: true }
      }
    },

		computed:{
      ...mapGetters(['formattedTime','formattedDate'])
		}
	};
</script>

<style type="text/css">

	.ticket-title,.ticket-user,.ticket-reply, .ticket-status{ max-width: 250px; word-break: break-all;}

	#my_tic .VueTables .table-responsive {
		overflow-x: auto;
	}

	#my_tic .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
	}
</style>