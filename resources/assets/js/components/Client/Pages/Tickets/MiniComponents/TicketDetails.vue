<template>

	<div class="row" :class="{align1: lang_locale == 'ar'}" style="min-height: 100px;">

		<div class="col-sm-6 custom_tic_detail">

			<div class="row">

				<div class="col-sm-6"><b>{{ lang('status') }}</b></div>

				<div class="col-sm-6">

					<span style="color:orange" v-tooltip="ticket.status"> {{ subString(ticket.status) }} </span>
				</div>
			</div>

			<div class="clearfix"></div>
		</div>

		<div class="col-sm-6 custom_tic_detail">

			<div class="row">

				<div class="col-sm-6"><b>{{ lang('department') }}</b></div>

				<div class="col-sm-6">

					<span v-tooltip="ticket.department">{{ subString(ticket.department) }}</span>
				</div>
			</div>

			<div class="clearfix"></div>
		</div>

		<div v-if="ticket.priority" class="col-sm-6 custom_tic_detail">

			<div class="row">

				<div class="col-sm-6"><b>{{ lang('priority') }}</b></div>

				<div class="col-sm-6">

					<span v-tooltip="ticket.priority">{{ subString(ticket.priority) }}</span>
				</div>
			</div>

			<div class="clearfix"></div>
		</div>

		<div class="col-sm-6 custom_tic_detail">

			<div class="row">

				<div class="col-sm-6"><b>{{ lang('created_date') }}</b></div>

				<div class="col-sm-6">

					<span v-tooltip="formattedTime(ticket.created_at)">{{ formattedTime(ticket.created_at) }}</span>
				</div>
			</div>

			<div class="clearfix"></div>
		</div>

		<div class="col-sm-6 custom_tic_detail">

			<div class="row">

				<div class="col-sm-6"><b>{{ lang('help_topic') }}</b></div>

				<div class="col-sm-6">

					<span v-tooltip="ticket.help_topic">{{ subString(ticket.help_topic) }}</span>
				</div>
			</div>

			<div class="clearfix"></div>
		</div>

		<div class="col-sm-6 custom_tic_detail">

			<div class="row">

				<div class="col-sm-6"><b>{{ lang('last_message') }}</b></div>

				<div class="col-sm-6">

					<span v-tooltip="ticket.threads[ticket.threads.length-1].user.first_name +' '+ ticket.threads[ticket.threads.length-1].user.last_name">
						{{ subString(ticket.threads[ticket.threads.length-1].user.first_name +' '+ ticket.threads[ticket.threads.length-1].user.last_name) }}
					</span>
				</div>
			</div>

			<div class="clearfix"></div>
		</div>

		<div class="col-sm-6 custom_tic_detail">

			<div class="row">

				<div class="col-sm-6"><b>{{ lang('last_response') }}</b></div>

				<div class="col-sm-6">

					<span v-tooltip="formattedTime(ticket.threads[ticket.threads.length-1].created_at)">
						{{ formattedTime(ticket.threads[ticket.threads.length-1].created_at) }}
					</span>
				</div>
			</div>

			<div class="clearfix"></div>
		</div>

		<div class="col-sm-6 custom_tic_detail">

			<div class="clearfix"></div>
		</div>

		<template v-if="loading">

			<client-panel-loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
		</template>
	</div>
</template>

<script>
	
	import { mapGetters } from 'vuex';

	import { getSubStringValue } from '../../../../../helpers/extraLogics'

	export default {

		name : 'ticket-details',

		description : 'Ticket deatils page',

		props : {

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},

			ticket : { type : Object, default : ()=>{}}
		},

		data(){

			return {

				loading : false,

				lang_locale : this.layout.language
			}
		},

		computed: {
			
			...mapGetters(['formattedTime','formattedDate'])
		},

		methods : {

			subString(value,length = 25){

				return getSubStringValue(value,length)
			},
		}
	};

</script>

<style scoped>
	
	.content {

		margin-top: 5px !important
	}

	.custom_tic_detail {
		padding: 15px;
		border-top: 1px solid #dddddd;
	}
</style>