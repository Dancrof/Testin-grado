<template>

  <data-table :url="apiUrl" :dataColumns="columns" @loaderState="handelLoader"  :option="options" :tickets="tickets"
    :scroll_to="scroll_to" :disableLoader="disableLoader" :componentTitle="componentTitle">

  </data-table>

</template>

<script>

    import { computed }  from 'vue';
    import { useStore } from 'vuex';
    import { RouterLink } from 'vue-router'

	export default {

    name : 'agent-tickets-table',

		description : 'Agent panel tickets page',

        setup() {

            const store = useStore();

            return {
                // getter
                formattedTime: computed(() => store.getters.formattedTime)
            };
        },

		props : {

          id : { type: [Number,String], default : ''},

          category : { type:String , default : 'inbox'},

          tickets : { type : Function, default : ()=>[]},

          allTickets : { type : Function, default : ()=>[]},

          apiUrl : { type : String, default : ''},

          componentTitle : { type : String, default :''},

          scroll_to : { type : String, default :''},

          isCalledFromAdmin : { type : Boolean, default : false},

          disableLoader : {type: Boolean, default: false}
        },

		data() {

			return {

              selectedTickets : this.tickets,

              options : {},

              tableData : [],
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

          id: this.trans('id'),

          title: this.trans('subject'),

          ticket_number : this.trans('ticket_id'),

          user: this.trans('requester'),

          assign_to : this.trans('assign_to'),

          updated_at: this.trans('last_activity')
        },

        columnsClasses : {

            id : 'ticket-id',

          title: 'ticket-title',

          ticket_number : 'ticket-number',

          user: 'ticket-user',

          assign_to: 'ticket-assign',

          updated_at: 'ticket-updated',
        },

        texts : {

          filter : '',

          limit : ''
        },

        templates: {

          title: function(createElement, row) {

            if(self.isCalledFromAdmin) {

              return self.h('a', {
                  target : '_blank',
                  href: self.basePath()+'/panel/thread/' + row.id
              },(row.title ? row.title : " ")+ '('+row.thread_count+')');

            } else {

              return self.h(RouterLink, {
                  to: '/thread/' + row.id
              },(row.title ? row.title : " ")+ '('+row.thread_count+')');
            }
          },

          updated_at(h,row){

            return self.formattedTime(row.updated_at)
          },

          user: function(createElement, row) {

             if(self.isCalledFromAdmin) {

              return self.h('a', { target : '_blank', href: self.basePath()+'/panel/user/' + row.from.id }, row.from.full_name ? row.from.full_name : row.from.user_name);

             } else {

                return self.h(RouterLink, { to: '/user/' + row.from.id }, row.from.full_name ? row.from.full_name : row.from.user_name);
             }
          },

          assign_to: function(createElement, row) {

             return self.h('p', row.assigned ? row.assigned.full_name : !Array.isArray(row.assigned_team) ? row.assigned_team.name : '---');
          },

          ticket_number: function(createElement, row) {

            if(self.isCalledFromAdmin) {

              return self.h('a', { target : '_blank', href: self.basePath()+'/panel/thread/' + row.id }, [self.h('span', { innerHTML: '#' + row.ticket_number })]);

             } else {

              return self.h(RouterLink, { to: '/thread/' + row.id }, [self.h('span', { innerHTML: '#' + row.ticket_number })]);
            }
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

          self.tableData = data.data;

          self.allTickets(data.data.tickets);

          return {

            data: data.data.tickets.map(data => {

              return data;

            }),

            count: data.data.total
          }
        },
	      orderBy: { column: 'updated_at', ascending: true },
      }

    },

		computed:{

          columns(){

            return this.tableData.length === 0 ? ['ticket_number', 'title', 'user', 'assign_to', 'updated_at'] :
            ['id', 'ticket_number', 'title', 'user', 'assign_to', 'updated_at']
          },

		},

    methods:{
      handelLoader(value){
        this.$emit('loaderValue',value);
      }
    }
	};
</script>

<style type="text/css">

	.ticket-title,.ticket-user,.ticket-assign,.ticket-reply{ max-width: 250px; word-break: break-all;}

	#my_tic .VueTables .table-responsive {
		overflow-x: auto;
	}

  .ticket-user a {
    color: #3c8dbc !important;
    text-decoration: none !important;
    background-color: transparent !important;
  }

	#my_tic .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
	}
</style>
