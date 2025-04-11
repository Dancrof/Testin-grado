<template>
  <div class="row faveo-automator-action">

    <span class="col-sm-auto"><i class="fas fa-trash faveo-trash" @click="deleteEvent()"></i></span>

    <dynamic-select
      classname="col-sm-3"
      :labelStyle="{display: 'none'}"
      :multiple="false"
      :id="'event-' + event._id"
      :name="'event-' + event._id"
      :apiEndpoint="'api/enforcer-events?type='+pageType"
      :value="eventObj.field"
      :onChange="onFieldChange"
      rules="required"
      :clearable="false">
    </dynamic-select>

    <template v-if="eventObj.field && eventObj.data_type === 'api'">
      <label class="col-sm-1 event-label">{{trans('from')}}</label>
      <dynamic-select
        classname="col-sm-3"
        :key="eventObj.field.id + 'from'"
        :labelStyle="{display: 'none'}"
        :multiple="false"
        :apiEndpoint="apiInfoUrl"
		:name="'from-' + event._id"
        :value="eventObj.from"
        :onChange="onChange"
        rules="required"
        :strlength="15"
        :clearable="false">
      </dynamic-select>

      <label class="col-sm-1 event-label">{{trans('to')}}</label>
      <dynamic-select
        classname="col-sm-3"
        :key="eventObj.field.id + 'to'"
        :labelStyle="{display: 'none'}"
        :multiple="false"
        :apiEndpoint="apiInfoUrl"
		:name="'to-' + event._id"
        :value="eventObj.to"
        :onChange="onChange"
        rules="required"
        :strlength="15"
        :clearable="false">
      </dynamic-select>
    </template>

  </div>

</template>

<script>
import { Event, isLocalElement } from '../../../helpers/AutomatorUtils'
import { MULTIPLE_PROPERTY_HELPER, boolean } from '../../../helpers/extraLogics'
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";

export default {

  name: 'faveo-automator-event',

  props: {
    event: { type: Event, required: true },
    index: { type: Number, required: true },
	  pageType : { type : String, default : 'ticket' }
  },

  data: () => {
    return {
      eventObj: null
    }
  },

  beforeMount () {
    this.eventObj = JSON.parse(JSON.stringify(this.event));
  },

  computed: {
    apiInfoUrl () {
      return MULTIPLE_PROPERTY_HELPER.convertStringOfPropertiesToObject(this.eventObj.api_info).url;
    },

    selectedField () {
      return isLocalElement(this.eventObj._id) ? null : this.eventObj.field;
    }
  },

  methods: {

    deleteEvent () {
      window.emitter.emit('deleteItem', { type : 'event', index: this.index, id : this.eventObj._id});
    },

    onFieldChange (value) {
      this.eventObj = new Event(this.eventObj._id, value, null, null, value.data_type, value.api_info )
      this.updateEventDataToStore();
    },

    onChange (value, name) {

		if(name.includes('from-')){
			this.eventObj['from'] = value;
		} else if(name.includes('to-')) {
			this.eventObj['to'] = value;
		} else {
			this.eventObj[name] = value;
		}

      this.updateEventDataToStore();
    },

    updateEventDataToStore () {
      this.$store.dispatch('updateEventData', { index: this.index, value: this.eventObj });
    }
  },

  components: {
    'dynamic-select': DynamicSelect,
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