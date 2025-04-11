<template>

	<div class="col-sm-12">

		<alert componentName="dataTableModal"/>

		<div class="card card-light ">

			<div class="card-header">

				<h3 id="emails-index" class="card-title">{{trans('list_of_emails')}}</h3>

				<div class="card-tools">

					<router-link class="btn btn-tool" to="/email/create" v-tooltip="{ content: lang('create_email'), placement: 'left' }">

						<i class="glyphicon glyphicon-plus"> </i> 
					</router-link>
				</div>
			</div>

			<div class="card-body" id="emails_index">

				<data-table
						url="/api/emails-list" :dataColumns="columns"
						:option="options" scroll_to ="emails-index"
				/>
			</div>
		</div>
	</div>
</template>

<script type="text/javascript">

    import { computed }  from 'vue';
    import { useStore } from 'vuex';

	import DataTableActions from "../../MiniComponent/DataTableComponents/DataTableActions.vue";
    import {RouterLink} from "vue-router";

	import EmailStatus from "./EmailStatus.vue";

	export default {

		name : 'emails-index',

		description : 'Emails lists table component',

        setup() {

            const store = useStore();

            return {
                // getter
                formattedTime: computed(() => store.getters.formattedTime)
            };
        },

		data(){

			return {

				columns: [ 'email_address', 'priority', 'department', 'help_topic', 'incoming_status', 'outgoing_status', 'created_at', 'updated_at', 'actions'],

				options: {}
			}	
		},

		beforeMount() {

			const self = this;

			this.options = {

				sortIcon: {

					base : 'glyphicon',

					down: 'glyphicon-chevron-up',

					up: 'glyphicon-chevron-down'
				},

				columnsClasses : {

					email_address: 'email-address',

					priority: 'email-priority',

					department: 'email-dept',

					created_at: 'email-create',

					updated_at: 'email-update',

					help_topic : 'email-topic',

					actions: 'email-actions',
				},

				headings : {

					'incoming_status' : ()=>{

						let span = self.h('i', { 'class' : 'text-primary fas fa-arrow-circle-down'});

						return self.h('span', {}, [this.lang("incoming-status")+'  ',span]);

					},

					'outgoing_status' : ()=>{

						let span = self.h('i', { 'class' : 'text-primary fas fa-arrow-circle-up'});

						return self.h('span', {}, [this.lang("outgoing-status")+'  ',span]);

					},

          email_address: this.trans('email_address'),
          priority: this.trans('priority'),
          department: this.trans('department'),
          created_at: this.trans('created_at'),
          updated_at: this.trans('updated_at'),
          help_topic : this.trans('help_topic'),
          actions: this.trans('actions'),

				},

				texts: { filter: '', limit: '', filterPlaceholder:"Search by email address" },

				templates: {

					priority(h,row) {

						return row.priority ? row.priority.name : '--'
					},

					department(h,row) {

						return row.department ? row.department.name : '--' 
					},

					help_topic(h,row) {

						return row.help_topic ? row.help_topic.name : '--' 
					},

					updated_at : function(h,row){

                        return self.formattedTime(row.updated_at)
                     },

                     created_at : function(h,row){

                        return self.formattedTime(row.created_at)
                     },

                     email_address: function(createElement, row) {

                        if(row.is_default) {

                            let span = self.h('span', { 'class' : 'badge text-bg-warning'}, 'Default');

                            return self.h(RouterLink, {
                                to : '/email/'+row.id+'/edit',
                            }, [row.email_address+'  ',span]);

                        } else {

                            return self.h(RouterLink, {
                                to : '/email/'+row.id+'/edit',
                            }, [row.email_address]);
                        }
                    },

					incoming_status(f,row) {

						return self.h(EmailStatus,{
							data : row, status : 'incoming'
						})
					},

					outgoing_status(f,row) {

						return self.h(EmailStatus,{
							data : row, status : 'outgoing'
						})
					},

					actions : function(createElement,row) {

                        return self.h(DataTableActions,{
                            data : row
                        })
                    }
				},

				sortable:  [ 'email_address', 'priority', 'department', 'help_topic', 'created_at', 'updated_at' ],

				filterable:  ['email_address'],

				pagination: { chunk:5,nav: 'fixed',edge:true },

				requestAdapter(data) {

					return {

						'sort-field' : data.orderBy ? data.orderBy : 'id',

						'sort-order' : data.ascending ? 'desc' : 'asc',

						'search-query' : data.query.trim(),

						page : data.page,

						limit : data.limit,
					}
				},

				responseAdapter({data}) {

					self.updateMailConfigMsg(data.data.total);

					return {

						data: data.data.emails.map(data => {

							data.edit_url = '/email/' + data.id + '/edit';
							
							data.delete_url = self.basePath() + '/api/email-delete/' + data.id;
							
							return data;
						}),
						count: data.data.total
					}
				},

				orderBy: { column: 'id', ascending: true },
			}
		},

        methods : {

			updateMailConfigMsg(value) {
				window.emitter.emit('checkMailConfig',value);
			}
		}
	};
</script>

<style type="text/css">
	.email-address,.email-priority,.email-dept,.email-create,.email-update,.email-actions, .email-topic
	{ max-width: 250px; word-break: break-all;}

	#emails_index .VueTables .table-responsive {
		overflow-x: auto;
	}

	#emails_index .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>
