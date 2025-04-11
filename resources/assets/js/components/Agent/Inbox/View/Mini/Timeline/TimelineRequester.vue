<template>

  <div class="card card-light">

    <div class="card-header pointer" @click="toggleCard">

      <h3 class="card-title"> {{trans('requester_and_tickets')}} </h3>

      <div class="card-tools">

        <button type="button" class="btn btn-tool">

          <i :class="{'fas fa-angle-up' : cardOpen, 'fas fa-angle-down' : !cardOpen }" class="fs-25"></i>
        </button>
      </div>
    </div>

    <div v-if="cardOpen" class="card-body box-profile">

      <div class="user-details">

        <div class="image-container mb-3">

          <img class="img-circle img-bordered-sm me-2 img-40" :src="user.profile_pic" alt="user image">

          <router-link :to="'/user/'+user.id">
            {{user.full_name}}
          </router-link>
        </div>

        <ul class="list-group list-group-unbordered mb-3">

          <li class="list-group-item">

            <label>{{trans('role')}}</label> <span class="float-end">{{user.role}}</span>
          </li>

          <li class="list-group-item">

            <label>{{trans('email')}}</label> <span class="float-end" v-tooltip="user.email">{{subString(user.email,30)}}</span>
          </li>

          <li class="list-group-item">

            <label>{{trans('mobile')}}</label> <span class="float-end">{{user.mobile}}</span>
          </li>

          <li v-if="boolean(org)" class="list-group-item">

            <label>{{ trans('organization') }}</label>

            <ul class="float-end">

              <li v-for="organization in org">

                <router-link v-tooltip="organization.name" :to="organization.href.replace(basePath(),'')">
                  {{subString(organization.name,30)}}
                </router-link>
              </li>
            </ul>
          </li>
        </ul>
      </div>

      <div v-if="latestTickets.length" class="ticket-label text-muted border-bottom"> <label>{{lang('latest_tickets')}} </label> </div>

      <div class="col-md-12 info-row">

        <div class="timeline">

          <div v-for="ticket in latestTickets">

            <i class="far fa-dot-circle timeline-icon bg-secondary"></i>

            <div class="timeline-item">

	            <span class="time badge text-white p-1 mt-3 me-2" :style="{backgroundColor: ticket.statuses.icon_color}" >{{ticket.statuses.name}}</span>

              <h3 class="timeline-header">

                <router-link v-tooltip="ticket.ticket_number" :to="'/thread/'+ticket.first_thread.ticket_id">
                  #{{ticket.ticket_number}}
                </router-link>
<br>
                <span class="thread_time"><i class="far fa-clock"></i> {{formattedTime(ticket.updated_at)}} </span>

              </h3>

              <div class="timeline-body">
                <p>
                  {{ticket.first_thread.title}}
                </p>
              </div>

            </div>
          </div>

          <div class="last-element" v-if="latestTickets.length">
            <i class="fas fa-ellipsis-h bg-gray timeline-icon"></i>
            <span class="text-md" :class="{'requester-timeline-text': appLanguage === 'ar'}">

              <router-link :to="'/user/'+user.id"> {{trans('view_all_tickets')}} </router-link>

            </span>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script>

import { getSubStringValue } from "../../../../../../helpers/extraLogics";
import {useStore} from "vuex";
import {computed} from "vue";

export default {

  name : 'timeline-requester',

  setup() {
    const store = useStore();

    return {

      formattedTime: computed(() => store.getters.formattedTime),
    }
  },

  data() {

    return {

      cardOpen : true,
    }
  },

  props : {

    user : { type : Object, default : () => {}},

    latestTickets: {type: Array, default: () => []},

    org : { type : Array, default : () => []},

    archive : { type : Boolean , default : false},
  },

  methods : {

    toggleCard() {

      this.cardOpen = !this.cardOpen;
    },

    subString(value,length = 15){

      return getSubStringValue(value,length)
    },

    showUserProfile(id){

      return this.basePath()+'/panel/user/'+id;
    }
  }
};
</script>

<style scoped>
.user-details{
  margin-bottom: 40px;
}
.thread_time {
  font-size: 12px;
  color: #999999;
}
.ticket-label{
  margin-bottom: 12px;
  margin-top: 12px;
}
.list-group-unbordered > .list-group-item{
  display: flex!important;
  justify-content: space-between!important;
  align-items: center!important;
  padding-top: 1rem!important;
  padding-bottom: 1rem!important;
}

.list-group-unbordered > .list-group-item label {
  margin-bottom: 0!important;
}
.timeline .last-element{
  height: 30px!important;
  display: flex!important;
  align-items: flex-end!important;
}

.timeline .last-element span{
  margin-left: 60px;
}

.image-container .img-40{
  height: 40px!important;
  width: 40px!important;
}

.requester-timeline-text{
  margin-right: 64px;
}
</style>