<template>

	<div ref="ticketTimelineDrag" class="col-sm-12" v-if="ticketNum">

    <alert componentName="timeline"></alert>

		<div v-if="hasDataPopulated && !ticketData" class="alert alert-danger">

        	{{trans('no-ticket-found')}}
    	</div>

		<div v-if="hasDataPopulated" class="card card-light" :style="styleData">

			<div class="card-header" v-if="ticketData">

        <h3 class="card-title"><i class="fas fa-ticket"> </i> #{{ticketData.ticket_number}}&rlm;&nbsp;</h3>

        <div v-if="actionsPopulated" class="card-tools timelinebtns">

          <timeline-actions :id="ticketNum"  :data="ticketData" :afterAction="updateTimeline" :actions="getTicketActions" ref="timelineActions"
                            :key="dataCounter">

            <template #left-actions>

              <button v-if="getTicketActions.view_tickets_without_actions && !ticketMerged" type="button" class="btn btn-light btn-xs" :class="{'bg-primary border-b': replyCompBtn == 'hide_reply'}" @click="replyMethod">

                <i class="fas fa-reply"></i> {{trans('reply')}}
              </button>

              <button v-if="getTicketActions.view_tickets_without_actions && !ticketMerged" type="button" class="btn btn-light btn-xs" :class="{'bg-primary border-b': internalCompBtn == 'hide_note'}" @click="noteMethod">

                <i class="fas fa-edit"></i> {{trans('add_note')}}
              </button>

              <button v-if="getTicketActions.view_tickets_without_actions && ticketData.user && !expand && !ticketMerged" type="button" class="btn btn-xs btn-light"  :class="{'bg-primary border-b': userCompBtn == 'hide_requester'}" @click="userMethod" id="user_btn">
                <i class="fas fa-user"></i> {{trans('requester')}}
              </button>

              <button v-if="fromComp != 'index'" class="btn btn-light btn-xs" @click="reloadTimeline" v-tooltip="trans('refresh')">

                <i class="fas fa-sync-alt"></i>
              </button>

              <button type="button" class="btn btn-xs btn-light" v-tooltip="expand ? trans('show_sidebar') : trans('hide_sidebar')"
                      @click="expandView">

                      <i :class="{'fas fa-expand' : !expand, 'fas fa-compress' : expand}"> </i>
              </button>
            </template>

          </timeline-actions>

					<slot name="headerMenu"></slot>
				</div>
			</div>

      <div class="card-body" v-if="ticketData">

        <div class="row mb-2">

          <div class="col-sm-9">

            <h5 class="me-1">{{ticketData.title}}&nbsp;

              <span>

								<template v-if="ticketData.is_overdue || ticketData.due_today">

									<span v-if="ticketData.is_overdue" v-tooltip="trans('this_ticket_is_marked_as_overdue')" class="badge text-bg-danger fs-8 me-1 tags-padding">{{trans('overdue')}}

									</span>

									<span v-if="ticketData.due_today" class="badge text-bg-warning me-1 tags-padding"  v-tooltip="trans('this_ticket_is_marked_as_duetoday')">
										{{ trans('due_today') }}
									</span>
								</template>

								<template v-if="!viewAll && ticketData.labels.length > 2">

									<template v-for="(label,index) in ticketData.labels.slice(0,2)">

										<a v-if="label.name.includes('Elea Review')" target="_blank" :href="label.href"
                       v-tooltip="{content: renderDynamicTooltip(label.name), html: true}" class="badge me-1"
                       :style="{'borderColor' : label.color, 'color': label.color, 'border': 'solid 1px'}" :class="{'tags-padding': !label.name.includes('Elea Review')}">
                      <span>
                        <svg-icon-handler :hover-color="loadColor(label.name)" :color="loadColor(label.name)" height="15" width="15" icon-from="elea_c_icon"/>&nbsp;{{subString(removeTitle(label.name))}}
                      </span>
										</a>

                    	<a v-else target="_blank" :href="labelPath(label.href)" v-tooltip="{content: renderDynamicTooltip(label.name), html: true}" class="badge me-1" :style="{'backgroundColor' : label.color, 'color': '#FFF'}" :class="{'tags-padding': !label.name.includes('Elea Review')}">
											<span class="p-2" v-html="processLabel(label.name)"></span>
										</a>
									</template>
								</template>

								<template v-if="!viewAll && ticketData.tags.length > 2">

									<template v-for="(tag,index) in ticketData.tags.slice(0,2)">

										<a target="_blank" :href="labelPath(tag.href)" v-tooltip="{content: loadLabel(trans(tag.name)), html: true}" class="badge me-1 tags-padding" id="ticket_tags">

											<i class="fas fa-tag"></i> {{processLabel(tag.name)}}
										</a>
									</template>
								</template>

								<template v-if="viewAll || (ticketData.labels.length <= 2 && ticketData.tags.length <= 2)">

									<template v-for="(label,index) in ticketData.labels">

										  <router-link target="_blank" v-if="label.name.includes('Elea Review')" :to="label.href.replace(basePath(),'')" v-tooltip="{content: renderDynamicTooltip(label.name), html: true}" class="badge me-1" :class="{'tags-padding': !label.name.includes('Elea Review')}"
                                 :style="{'borderColor' : label.color, 'color': label.color, 'border': 'solid 1px'}">
                        <span>
                          <svg-icon-handler :hover-color="loadColor(label.name)" :color="loadColor(label.name)" height="15" width="15" icon-from="elea_c_icon"/>&nbsp;{{subString(removeTitle(label.name))}}
                        </span>

										  </router-link>

                    	<router-link v-else target="_blank" :to="label.href.replace(basePath(),'')" v-tooltip="{content: renderDynamicTooltip(label.name), html: true}" class="badge me-1" :class="{'tags-padding': !label.name.includes('Elea Review')}"
                                   :style="{'backgroundColor' : label.color, 'color': '#FFF'}">

											      <span class="p-2" v-html="processLabel(label.name)"></span>
										  </router-link>
									</template>

									<template v-for="(tag,index) in ticketData.tags">

										<router-link target="_blank" :to="tag.href.replace(basePath(),'')" v-tooltip="{content: loadLabel(trans(tag.name)), html: true}" class="badge me-1 tags-padding" id="ticket_tags">

											<i class="fas fa-tag"></i> {{processLabel(tag.name)}}
										</router-link>
									</template>
								</template>

								<a v-if="ticketData.labels.length > 2 || ticketData.tags.length > 2" href="javascript:;" class="fs-8 me-1"
                   @click="toggleAll">

									<i class="fas fa-ellipsis-h"> </i> {{getMsg(ticketData)}}
								</a>
							</span>
            </h5>
          </div>

          <div class="col-sm-3">

            <rating-component v-if="system_ratings.name && !refresh && !ticketMerged" url="rating/"
                              :rating="system_ratings" ticket_id="" classname="mb-2 lh-1" :readOnlyStar="true"
            />
          </div>
        </div>

        <div class="row">

          <div :class="{'col-sm-12' : expand, 'col-sm-8' : !expand}">

						<div id="actions-card">

							<ticket-reply v-if="replyCompBtn == 'hide_reply'" :id="ticketNum" :user="replyUser" :ccArray="ticketData.collaborators" :ticket="ticketData"
								:updateThreads="updateTimeline" :key="updateMCE">

							</ticket-reply>

              <ticket-note v-if="internalCompBtn == 'hide_note'" :id="ticketNum" :updateThreads="updateTimeline"></ticket-note>
            </div>

						<div class="card card-light card-tabs" :class="{'maximized-card' : maximized}">

							<div class="card-header p-0 pt-2">

								<ul class="nav nav-tabs" role="tablist">

									<li class="nav-item">

										<a class="nav-link" :class="{ active: activityCompBtn == 'hide_activity', 'pb-11' : currentActivity === 'ticket-activity' }" data-bs-toggle="pill" role="tab" href="javascript:;">

											<span class="p-1" @click="activityMethod('ticket_conversation')">
						                        <i class="far fa-comments"> </i> {{trans('ticket_conversation')}}
											</span>

                                            <span class="p-1" v-if="this.currentActivity === 'ticket-conversation'">

	                                            <button type="button" class="btn btn-light btn-xs dropdown-toggle" data-bs-toggle="dropdown"></button>

	                                            <div class="dropdown-menu dropdown-menu-class dropdown-menu-right">

						                          <a class="dropdown-item item-hover" :class="{'bg-gray-light': this.conversation_sort_order === 'ASC'}" @click="conversationSort('ASC')" href="javascript:;">
						                            <i class="fas fa-sort-amount-down"></i>
						                             {{ trans('created_date') + ' ' + trans('ascending') }}
						                            <i v-if="this.conversation_sort_order === 'ASC'" class="fas fa-check"></i>
						                          </a>

						                          <a class="dropdown-item item-hover" :class="{'bg-gray-light': this.conversation_sort_order === 'DESC'}" @click="conversationSort('DESC')" href="javascript:;">
						                            <i class="fas fa-sort-amount-up"></i>
						                               {{ trans('created_date') + ' ' + trans('descending') }}
						                            <i v-if="this.conversation_sort_order === 'DESC'" class="fas fa-check"></i>
						                          </a>
						                        </div>
						                      </span>
										</a>
									</li>

									<li class="nav-item">

										<a class="nav-link pb-11" :class="{ active: activityCompBtn == 'show_activity' }" data-bs-toggle="pill" role="tab" href="javascript:;"
											@click="activityMethod('ticket_activity')">

											<i class="fas fa-history"> </i> {{trans('ticket_activity')}}
										</a>
									</li>

									<li class="nav-item ms-auto mt-04">


                      <button v-if="showLoader" type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

                        <i class="fas fa-sync-alt"></i>
                      </button>

                    <a v-if="ticketData.is_overdue" class="btn-tool text-small" href="javascript:;"
                       v-tooltip="{ content : !getTicketActions.block_ticket_actions ? formattedTimeAndHours({duedate: ticketData.duedate, departmentDueTrack: ticketData['department-due-track']}) : '--',html: true}" >


                      <em>{{ trans('overdue') }} - <b>{{countUpForOverdue}}</b></em>
                    </a>

                    <a v-if="!ticketData.is_overdue" class="btn-tool text-small" href="javascript:;"
                       v-tooltip="{ content : !getTicketActions.block_ticket_actions ? formattedTimeAndHours({duein: ticketData.duedate, departmentDueTrack: ticketData['department-due-track']}) : '--',html: true}" >


                      <em>{{ trans('due_in') }} - <b>{{countdownForDuedate ? countdownForDuedate : '--'}}</b></em>
                    </a>

                    <button type="button" class="btn btn-tool" data-lte-toggle="card-maximize"  @click="maxView"
                            v-tooltip="maximized ? trans('minimize') : trans('maximize')" >
                      <i class="fas fa-expand"></i>
                    </button>
                  </li>
                </ul>
              </div>

              <div class="card-body" :class="{'maximized-logs ' : maximized}">

                <component  v-bind:is="activityComponent" :trigger="triggerApiCall" @sortOrder="sortOrder" :ticketMerged="ticketMerged" :ticketId="ticketNum" :key="activityCounter" @loaderState="handelLoader" :maximized="maximized" :showThreadActions="showThreadActions"></component>

              </div>
            </div>

            <inbox-associates v-if="hasDataPopulated" :ticketId="ticketNum" :ticketData="ticketData" ref="inboxAssociates">

            </inbox-associates>
          </div>

          <div class="col-sm-4" v-if="!expand">

            <timeline-integration v-if="ticketData.user && integrateAppBtn === 'hide_app' && integration_data" :integrationData="integration_data"></timeline-integration>

            <timeline-user v-if="ticketData.user && userCompBtn == 'hide_requester'" :user="ticketData.user" :latestTickets="ticketData.latestTickets" :org="ticketData.organizations">

            </timeline-user>

            <timeline-data :id="ticketNum" :ticket="ticketData" :key="dataCounter" :actions="getTicketActions" :afterAction="updateTimeline">

            </timeline-data>
          </div>
        </div>
      </div>
    </div>

    <div v-if="loading" class="bullet-load">

		<BulletListLoader viewBox="0 0 300 200"></BulletListLoader>
    </div>
  </div>
</template>

<script>
import { BulletListLoader } from 'vue-content-loader'
import axios from 'axios'
import {getSubStringValue, scrollToElement, getIdFromUrl, renderLabelWithEmoji, parseUrlParams} from "../../../../helpers/extraLogics";
import {useStore} from 'vuex';
import {computed} from "vue";
import TimelineActions from "./Mini/Timeline/TimelineActions.vue";
import TimelineDetails from "./Mini/Timeline/TimelineDetails.vue";
import TimelineRequester from "./Mini/Timeline/TimelineRequester.vue";
import RatingComponent from "../../../MiniComponent/RatingComponent.vue";
import InboxThreads from "./Mini/Logs/InboxThreads.vue";
import InboxTicketActivity from "./Mini/Logs/InboxTicketActivity.vue";
import InboxAssociates from "./Mini/Associates/InboxAssociates.vue";
import InboxReply from "./Mini/Actions/Mini/InboxReply.vue";
import InboxNotes from "./Mini/Actions/Mini/InboxNotes.vue";
import SvgIconHandler
  from "../../../../../../../app/Plugins/EleaAssistant/views/js/components/miniComponent/SvgIconHandler.vue";
import IframeInjection from "./Mini/Timeline/IframeInjection.vue";
export default {
  name : 'ticket-timeline',
  description : 'Ticket Timeline',
	setup() {

		const store = useStore();

		return {

			formattedTime : computed(()=>store.getters.formattedTime),

			getDefaultRatings : computed(()=>store.getters.getDefaultRatings),

			getTicketActions : computed(()=>store.getters.getTicketActions),

			timeDiffForPast : computed(()=>store.getters.timeDiffForPast),

			timeDiffForFuture : computed(()=>store.getters.timeDiffForFuture)
		}
	},
  props : {
    ticketId : { type : [String, Number], default : '' },
    from : { type : String, default : '' },
    fromComp : { type : String, default : '' },
    updateTable : { type : Function, default :()=>{} },
	  currentTicketCategory: { type : String, default : '' }
  },
  data() {
    return {
      ticketNum : this.ticketId,
      ticketData : '',
      loading : true,
      hasDataPopulated : false,
      actionsPopulated : false,
      system_ratings:[],
      ticket_ratings:[],
      refresh : false,
      currentActivity : 'ticket-conversation',
      activityCompBtn : 'hide_activity',
      associateCompBtn : 'show_associates',
      styleObj : {},
      replyCompBtn : 'reply',
      internalCompBtn : 'add_note',
      dataCounter : 0,
      activityCounter : 0,
      replyUser : '',
      updateMCE : 0,
      viewAll : false,
      countdownForDuedate:'',
      countUpForOverdue:'',
      expand : false,
      maximized : false,
      userCompBtn : 'show_requester',
      showLoader: false,
      ticketMerged: false,
      integrateAppBtn: 'show_app',
      triggerApiCall: false,
      conversation_sort_order : '',
      integration_data: [],
	    showThreadActions: true
    }
  },
  beforeMount() {

    if (this.from === 'timeline') {
      this.ticketNum = getIdFromUrl(window.location.pathname);

    }
    this.getTicketData()
  },
  mounted() {
    this.timerActions();
  },
  computed:{
    activityComponent(){
      return this.currentActivity
    },
    styleData() {
      let obj = {};
      if(this.ticketData.priority != null) {
        obj['border-top'] = '3px solid '+this.ticketData.priority.priority_color;
      }
      return obj;
    }
  },
  created(){
    window.emitter.on('workflowUpdated',this.updateTimeline);
    window.emitter.on('actionDone',this.updateTimeline);
    window.emitter.on('showHidedData',this.hideMethod);
    window.emitter.on('threadReply', this.replyOnThread);
	  window.emitter.on('closeReplyBox',this.replyMethod);
	  window.emitter.on('closeNoteBox',this.noteMethod);
    window.emitter.on('showIframeCard', this.iframeMethod); //emitter for toggling and showing iframe card
  },
  methods : {
    conversationSort(val) {
      this.triggerApiCall = val;
    },

    sortOrder(order) {
      this.conversation_sort_order = order;
    },

	  labelPath(value) {

		  if(!value.includes('/panel/')) {
			  return value.replace(this.basePath(), this.basePath()+'/panel')
		  }

		  return value;
	  },

    formattedTimeAndHours(data){
      let str = this.formattedTime(data.duedate)
      if(data.departmentDueTrack !==null && data.departmentDueTrack) {
        data.departmentDueTrack.forEach((track) => {
          str = str + ' <br>' + ` ${track.department} : ${track.workingHours}`
        })
      }
      else {
        str = str + ' <br>'
      }
        return str



    },
    getMsg(data){
      let count = data.labels.length + data.tags.length;
      return !this.viewAll ? 'View all '+ count  : 'View less'
    },
    expandView() {
      this.expand = !this.expand;
    },
    maxView() {
      this.maximized = !this.maximized;
      console.log(this.maximized)
    },
    userMethod() {
      this.userCompBtn = this.userCompBtn == 'hide_requester' ?  'show_requester' : 'hide_requester';
    },
    timerActions() {
      if(this.ticketData.is_overdue) {
        this.updateCountUp('duedate');
      } else {
        this.updateCountDownForDueDate();
      }
    },
    updateCountDownForDueDate(){
      this.countdownForDuedate = this.timeDiffForFuture(this.ticketData.duedate);
      if(this.countdownForDuedate === 0){
        this.ticketData.is_overdue = true
        this.ticketData.due_today = false
        this.updateCountUp('duedate');
      }
      else{
        const timer = setTimeout(() => { this.updateCountDownForDueDate(this.ticketData.duedate); }, 1000);
      }
    },
    updateCountUp(dateType){
      switch(dateType){
        case 'duedate':
          this.countUpForOverdue = this.timeDiffForPast(this.ticketData[dateType]);
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
    toggleAll() {
      this.viewAll = !this.viewAll;
    },
    reloadTimeline() {
      this.hasDataPopulated = false;
      this.loading = true;
      this.getTicketData();
      window.emitter.emit('iframeReload'); //call the api and refresh the IFRAME data on clicking refresh button
    },
    replyOnThread(value){
	    document.body.classList.add('overflow-hidden');
      this.updateMCE += 1;
      this.replyCompBtn = 'hide_reply';
      this.internalCompBtn = 'add_note';
      this.scrollToTarget('actions-card');
      this.replyUser = value.user;
      setTimeout(()=>{
        window.emitter.emit('updateContent', value)
      },1000)
    },
    updateTimeline(from) {
      window.emitter.emit('updateAgentSidebar');
      this.updateTable(from);
      if(from == 'external'){
        this.actionsPopulated = false;
        window.emitter.emit('closeTimelineActions');
        this.getTicketData();
        return
      }
      window.emitter.emit('closeTimelineActions');
      this.associateCompBtn = 'show_associates';
      let activityUpdateActions = ['forward'];
      if(activityUpdateActions.includes(from)) {
        window.emitter.emit('updateTimelineActivity')
      }
      let activityAndThreadUpdateActions = ['status','note','reply'];
      if(activityAndThreadUpdateActions.includes(from)) {
        this.activityCounter += 1;
        this.getTicketData();
      }
      let activityAndTicketUpdateActions = ['edit','assign','surrender','department','label','tag','approval','requester','timeline_merge','delete', 'fork'];
      if(activityAndTicketUpdateActions.includes(from)) {
        window.emitter.emit('updateTimelineActivity')
        this.getTicketData();
      }
      if(from == 'duedate') {
        this.loading = true;
        this.hasDataPopulated = false;
        this.ticketData = '';
        window.emitter.emit('updateTimelineActivity')
        this.getTicketData();
      }
    },
    scrollToTarget(id){
      return scrollToElement(id)
    },
    replyMethod() {
      this.replyCompBtn = this.replyCompBtn == 'reply' ? 'hide_reply' : 'reply';
      this.internalCompBtn = 'add_note'
      if(this.replyCompBtn == 'hide_reply') {
        this.scrollToTarget('actions-card')
      }
    },
    noteMethod() {
      this.internalCompBtn = this.internalCompBtn == 'add_note' ? 'hide_note' : 'add_note';
      this.replyCompBtn = 'reply'
      if(this.internalCompBtn == 'hide_note') {
        this.scrollToTarget('actions-card')
      }
    },
    activityMethod() {
      this.activityCompBtn = this.activityCompBtn == 'show_activity' ?  'hide_activity' : 'show_activity';
      this.currentActivity = this.currentActivity == 'ticket-conversation' ? 'ticket-activity' : 'ticket-conversation';
    },
    hideMethod() {
      this.associateCompBtn = 'hide_associates';
      setTimeout(()=>{
        this.$refs.inboxAssociates.scrollCurrent();
        setTimeout(()=>{
          window.emitter.emit('showHideDiv');
        },1500)
      },1)
    },
    subString(value, count = 30){
      return getSubStringValue(value,count);
    },
    getTicketData() {
      // I don't know why ticket `id` is stored in `ticketNum` variable
      this.$store.dispatch('setRatingTypes', this.ticketNum);
      this.$store.dispatch('setTicketId', this.ticketNum);
      this.$store.dispatch('updateTicketActions',this.ticketNum);
	  // let additionalParam = this.currentTicketCategory ? '?category='+this.currentTicketCategory : '';
	    const urlParams = parseUrlParams();
		if(urlParams.hasOwnProperty('category') && urlParams.category === 'archived'){
			this.showThreadActions = false;
		}
	    let queryString = Object.entries(urlParams).map(([key, value]) => {
		    return `${encodeURIComponent(key)}=${encodeURIComponent(value)}`;
	    }).join('&');
      axios.get('/api/agent/ticket-details/'+this.ticketNum+'?'+queryString).then(res=>{
        this.dataCounter +=1;
        this.loading = false;
        this.refresh = false;
        this.hasDataPopulated = true;
        this.actionsPopulated = true;
        this.ticketData = res.data.data.ticket;
        this.replyUser = this.ticketData.user;
        this.ticket_ratings = this.ticketData.ratings;
        this.ticketMerged = this.ticketData.ticketMerged;
        this.ratingTypes()
        this.timerActions();
      }).catch(err=>{
        this.loading = false;
        this.hasDataPopulated = true;
        this.actionsPopulated = true;
      });
    },

    ratingTypes() {
      this.system_ratings =  this.getDefaultRatings;
    },
    handelLoader(loader){
      this.showLoader = loader;
    },

    loadLabel(label) {
      return renderLabelWithEmoji(label);
    },

    removeTitle(label) {

      return label.replace('Elea Review: ','');
    },

    loadColor(label) {
      const colorMap = {
        'Elea Review: Immediate Action Required': '#a70000',
        'Elea Review: Action Recommended': '#ff8c00',
        'Elea Review: Monitor': '#008000'
      };
      return colorMap[label] || null;
    },

    loadSVGIcon(label) {
      const iconMap = {
        'Elea Review: Immediate Action Required': 'elea_immediate_action',
        'Elea Review: Action Recommended': 'elea_action_recommended',
        'Elea Review: Monitor': 'elea_monitor'
      };
      return iconMap[label] || null;
    },

    renderDynamicTooltip(label){
      if(label.includes('Elea Review')){
        return this.removeTitle(label)
      }else{
        return this.loadLabel(label)
      }
    },

    processLabel(labelName) {
      // Extract emoji short codes and their positions
      let emojiMatches = [...labelName.matchAll(/:\w+:/g)];
      let textWithoutEmojis = labelName.replace(/:\w+:/g, '');

      // Get the substring of the text without emojis
      let subStringText = this.subString(textWithoutEmojis);

      // If subStringText is undefined or empty, return the original labelName with emojis
      if (!subStringText || !subStringText.trim()) {
        return this.loadLabel(labelName);
      }

      // Reinsert the emoji short codes at their original positions
      let finalText = subStringText;
      emojiMatches.forEach(match => {
        let position = match.index;
        if (position < subStringText.length) {
          finalText = finalText.slice(0, position) + match[0] + finalText.slice(position);
        } else {
          finalText += match[0];
        }
      });

      return this.loadLabel(finalText);
    },

    iframeMethod(data) {
      //if it's not coming from reloading, then don't change the state of the card
      //coming from component MoreEvents.vue
      if(!data.reload) {
        this.integrateAppBtn = data.integration_btn === 'hide_app' ?  'show_app' : 'hide_app';
      }
      this.integration_data = data.integration_data;
    }

  },
  components : {
	  BulletListLoader,
    'timeline-actions':TimelineActions,
    'timeline-data':TimelineDetails,
    'timeline-user' :TimelineRequester,
    'rating-component':RatingComponent,
    'ticket-conversation':InboxThreads,
    'ticket-activity':InboxTicketActivity,
    'inbox-associates':InboxAssociates,
    'ticket-reply':InboxReply,
    'ticket-note':InboxNotes,
    'svg-icon-handler': SvgIconHandler,
    'timeline-integration': IframeInjection,
  }
};
</script>

<style scoped>
#timeline_rate { margin-top: -10px; }
#style-3::-webkit-scrollbar-track
{
  background-color: #f1f1f1;
  border-radius:10px;
}
#style-3::-webkit-scrollbar
{
  width: 6px;
  background-color: #f1f1f1;
}
#style-3::-webkit-scrollbar-thumb
{
  background-color: #c1c1c1;
  border-radius: 10px;
}
#ticket_tags {
  background-color: lightgray;
  color: #444;
}
.timeline_title { width: 95%; }
.callout a { color: #337ab7 !important; text-decoration: none !important; }
#act_data{ min-height: 500px;max-height: 500px; overflow-y: auto; }
#act_data::-webkit-scrollbar-track
{
  background-color: #f1f1f1;
  border-radius:10px;
}
#act_data::-webkit-scrollbar
{
  width: 6px;
  background-color: #f1f1f1;
}
#act_data::-webkit-scrollbar-thumb
{
  background-color: #c1c1c1;
  border-radius: 10px;
}
.badge { font-size: 54% !important; }
.mt-04 { margin-top: 4px !important; }
.timelinebtns .btn-xs { font-size: .75rem !important;}
.border-b { border: 1px solid #337ab7; }
.maximized-logs { overflow: scroll; }
.maximized-logs::-webkit-scrollbar-track
{
  background-color: #f1f1f1;
  border-radius:10px;
}
.maximized-logs::-webkit-scrollbar
{
  width: 6px;
  background-color: #f1f1f1;
}
.maximized-logs::-webkit-scrollbar-thumb
{
  background-color: #c1c1c1;
  border-radius: 10px;
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Apply the rotation animation when the button has a class of "rotating" */
.btn-tool.rotating i {
  animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
}

.tags-padding{
  padding-top: 4px;
  padding-bottom: 0.3rem
}
.dropdown-menu-class {
  bottom: 100% !important;
  top: auto !important;
}

.item-hover:hover {
	background: #e3e6e8;
}

.pb-11 {
	padding-bottom: 11px;
}
</style>
