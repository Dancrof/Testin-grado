<template>
  <faveo-box :title="trans('involves_any_of_these_events')">

    <faveo-automator-event v-for="(event, index) in eventList" :key="event._id" :event="event" :index="index" :pageType="pageType"/>

    <div style = "margin-top: 1rem">
      <a @click="addNew()" href="javascript:;"><span><i class="fas fa-plus-circle"></i> {{trans('add_new_event')}}</span></a>
    </div>
  </faveo-box>
</template>

<script>
import { Event } from '../../../helpers/AutomatorUtils'
import { boolean } from '../../../helpers/extraLogics'
import FaveoAutomatorEvent from "./FaveoAutomatorEvent.vue";

export default {

  name: 'event-list',
	
	props : {
	  
	  pageType : { type : String, default : '' }
	},

  data: () => {
    return {
      eventList: [],
    }
  },

  beforeMount () {
    this.eventList = this.$store.getters.getAutomatorDataByKey('events')

    if (!boolean(this.eventList)) {
      this.addNew()
    }
  },

  methods: {
    addNew () {
      this.$store.dispatch('addNewElementToAutomatorProperty', { key: 'events', value: new Event() });
    },
  },

  components: {
    'faveo-automator-event': FaveoAutomatorEvent,
  }

}
</script>

<style scoped>
.event-label {
  line-height: 2.5;
  text-align: right;
}

.faveo-trash {
  padding-right: 1rem;
  line-height: 1.5;
}
</style>