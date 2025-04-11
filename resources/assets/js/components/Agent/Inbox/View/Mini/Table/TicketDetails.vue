<template>

	<tr :class="{'unanswered': ticket.isanswered == 0, 'active_ticket' : getStoredTicketId == ticket.id && timelineId}">

		<td class="priority-border" :style="{background: ticket.priority.priority_color+' !important'}"
			v-tooltip="lang('priority_is')+ticket.priority.name">

		</td>

		<td id="ticket_user">

			<div class="user-image">

				<faveo-image-element :id="'user_img_'+ticket.id" :source-url="ticket.from.profile_pic" alternative-text="User"
									 :img-width="40" :img-height="40"/>

				<input :id="ticket.id" type="checkbox" name="check-row" class="checkbox" v-model="checked">

				<label :for="ticket.id" class="cursor-pointer"></label>
			</div>
		</td>

		<td class="name td-ticket-details">

			<div class="ticket_subject">

				<h3 class="ticket-description-tip overdue_ticket break-word" @click="onRowClick(ticket.id,$event)" @click.ctrl="redirectToTab(ticket.id)">

					<ticket-popover :details="ticket" :tableHeader="color" :onTicketClick="ticketClicked" ref="ticketPopover">

					</ticket-popover>
				</h3>

				<div class="info-data">

					<div class="information ellipsis">

            <template v-if="canViewProfile(ticket)">

              <span>{{lang('from')}}:&nbsp;</span>

              <user-info :from="ticket.from" :tableHeader="color"></user-info>&nbsp;

            </template>

            <template v-else>

              <span>{{lang('from')}}:&nbsp;</span>

              <a  style="color:#3c8dbc" v-tooltip="trans('access_denied_now')">{{subString(ticket.from.full_name)}}</a>&nbsp;

            </template>

						<template v-if="canViewAssignedProfile(ticket) && ticket.assigned">

							<span>{{lang('assigned_to')}}:&nbsp;</span>

			        <user-info  :from="ticket.assigned" :tableHeader="color">

							</user-info>&nbsp;

						</template>

            <template v-else-if="ticket.assigned">

              <span>{{lang('assigned_to')}}:&nbsp;</span>

              <a  style="color:#3c8dbc" v-tooltip="trans('access_denied_now')">{{subString(ticket.assigned.full_name)}}</a>&nbsp;

            </template>

						<template v-if="!Array.isArray(ticket.assigned_team)">

							<span>{{lang('assigned_team')}}:&nbsp;</span>

							<a style="color:#3c8dbc">{{ticket.assigned_team.name}}</a>&nbsp;
						</template>

						<template v-if="!ticket.assigned && Array.isArray(ticket.assigned_team)">

							<span>{{lang('assigned_to')}}:&nbsp;</span>

							<span style="color: red">{{lang('unassigned')}}</span>&nbsp;
						</template>

						<span class="departm"> {{ lang('department') }}:&nbsp;</span>

						<span style="color:#3c8dbc">{{ticket.department?.name}}</span>&nbsp;

            <div class="ticket-list-custom-box pb-1">
              <!-- custom details -->
              <span class="org-extra-field d-block" v-for="field in ticket.extra_fields">

             <span v-if="(field.label === lang('organisation')) && Array.isArray(field.value)"> <!-- Check if the label is ' Organizations' && the value in an array -->
                <span v-if="field.value && field.value.length > 0">
                {{ field.label }}:
              <template v-for="(org, index) in field.value">
              <!-- display's the org name and the pop details-->
              <org-info :from="org" ></org-info>
              <span v-if="index < field.value.length - 1">, </span>
            </template>
              </span>
           </span>
                  <span v-else>

                    <span v-if="field.value">{{ field.label }}:&nbsp;</span>

							      <span v-if="field.value" class="extra-field" v-html="field.value"/>
              </span>
            </span>
            </div>
					</div>
				</div>
			</div>
		</td>

		<td class="td-ticket-status hideForList">

			<span class="badge text-bg-danger text-xs" v-show="ticket.is_overdue">{{ lang('overdue') }}</span>

			<span class="badge text-bg-warning text-xs" v-show="ticket.due_today">{{ lang('due_today') }}</span>
		</td>

		<td class="source source-icon hideForList">

			<div class="status-source source-detailed-phone" v-tooltip="lang('ticket_is_generated_via')+ lang(ticket.source.name)">

				<i :class="ticket.source.css_class" id="ticket-source-icon"></i>
			</div>
		</td>

		<td class="source-icon hideForList">

			<div class="status-source source-detailed-phone" v-tooltip="lang('ticket_is')+ticket.status.name">

				<i :class="ticket.status.icon" id="ticket-source-icon" :style="{color:ticket.status.icon_color}"></i>
			</div>
		</td>

		<td  class="assign hideForList">

			<ul style="padding: 0px; margin: 0px; list-style: none; font-size: medium;">

				<li>{{ lang('created') }}:

					<span class="emphasize">{{countUpForCreated}}</span>
				</li>

				<li>{{ lang('updated') }}:

					<span class="emphasize">{{countUpForUpdated}}</span>
				</li>

				<li v-if="ticket.is_overdue">{{ lang('overdue') }}:

					<span class="emphasize">{{countUpForOverdue}}</span>
				</li>

				<li v-if="!ticket.is_overdue">{{ lang('due_in') }}

					<span class="emphasize">{{countdownForDuedate ? countdownForDuedate : '---'}}</span>
				</li>
			</ul>
		</td>
	</tr>
</template>

<script>

import {useStore} from 'vuex';
import {computed} from "vue";
import UserInfo from "./UserInfo.vue";
import TicketPopover from "./TicketPopover.vue";
import OrgInfo from "./OrgInfo.vue";
import {getSubStringValue} from "../../../../../../helpers/extraLogics";

	export default {

		name : 'ticket-details',

		description : 'Ticket details component',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),
				timeDiffForPast : computed(()=>store.getters.timeDiffForPast),
				timeDiffForFuture : computed(()=>store.getters.timeDiffForFuture),
				getStoredTicketId : computed(()=>store.getters.getStoredTicketId),
			}
		},

		props : {

			color : { type : String, default :''},

			ticket : { type : Object, default : ()=>{}},

			appendSelect : { type : Function},

			onSelect : { type : Function },

			timelineId : { type : [String, Number], default : '' }

		},

		data() {

			return {

				countdownForDuedate:'',

				countUpForCreated:'',

				countUpForUpdated:'',

				countUpForOverdue:'',

				checked: false,
			}
		},

		watch : {

			checked:function(val){

				this.appendSelect(this.ticket.id, val);
			},
		},

		beforeMount(){

			window.emitter.on('selectTicket', this.selectAllTicket);

			window.emitter.on("unCheckTicket", this.unCheck);
		},

		mounted() {
			this.timerActions()
		},

		methods : {
      subString(value,length = 15){

        return getSubStringValue(value,length)
      },
      canViewProfile(ticket) {
        return ticket.profileAccessPermission;
      },

      canViewAssignedProfile(ticket) {
        return ticket.assignedprofileAccessPermission;
      },

			onRowClick(id,e) {

				this.$refs.ticketPopover.onClick(id,e)
			},

			redirectToTab(id) {
				this.$refs.ticketPopover.redirectMethod(id,'_blank')
			},

			timerActions() {
				if(this.ticket.is_overdue) {
					this.updateCountUp('duedate');
				}
				else {
					this.updateCountDownForDueDate();
				}
				this.updateCountUp('created_at');
				this.updateCountUp('updated_at');
			},

			ticketClicked(id) {

				this.onSelect(id);
			},

			selectAllTicket(x){

				this.checked=x;
			},

			unCheck(){

				this.checked = false;
			},

			updateCountDownForDueDate(){

				this.countdownForDuedate = this.timeDiffForFuture(this.ticket.duedate);

				if(this.countdownForDuedate === 0){

					this.ticket.is_overdue = true

					this.ticket.due_today = false

					this.updateCountUp('duedate');
				}
				else{

					const timer = setTimeout(() => { this.updateCountDownForDueDate(this.ticket.duedate); }, 1000);
				}
			},

			updateCountUp(dateType){

				switch(dateType){

					case 'duedate':

						this.countUpForOverdue = this.timeDiffForPast(this.ticket[dateType]);
						break;

					case 'created_at':

						this.countUpForCreated = this.timeDiffForPast(this.ticket[dateType]);
						break;

					case 'updated_at':

						this.countUpForUpdated = this.timeDiffForPast(this.ticket[dateType]);
						break;

					default:

						return;
				}
				var self = this;

				setTimeout(

					function(){

						self.updateCountUp(dateType);
				}, 10000);
			},
		},

		components :{
       'org-info': OrgInfo,

			'user-info' : UserInfo,

			'ticket-popover' : TicketPopover
		}
	};
</script>

<style scoped>

	.inbox-subject{
		font-weight: 600;
	}

	.unanswered td{

		background: #f4f4f4 !important;
	}

	.active_ticket td { box-shadow: 8px 1px 5px 5px #bbbbbb;position: relative; }

	#ticket_user{
		width : 7%;
	}

	.fs-unset { font-size: unset !important; cursor: text; }

  .extra-field{
    color:#3c8dbc;
  }

  .cursor-pointer{
    cursor: pointer;
  }

</style>