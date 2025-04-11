<template>
  <faveo-box :title="trans('when_an_action_performed_by')">

    <div class="row">
      <div class="col-sm-4">
        <label class="radio-inline form-check">
          <input type="radio" class="form-check-input" name="actionsPerformer" @change="onchange('agent')" value="agent" :checked="actionsPerformer === 'agent'"> &nbsp;{{lang('agent')}}
        </label>
      </div>
	
	    <template v-if="pageType == 'ticket'">
		
		    <div class="col-sm-4">
			    <label class="radio-inline form-check">
				    <input type="radio" class="form-check-input" name="actionsPerformer" @change="onchange('requester')" value="requester" :checked="actionsPerformer === 'requester'"> &nbsp;{{lang('requester')}}
			    </label>
		    </div>
		
		    <div class="col-sm-4">
			    <label class="radio-inline form-check">
				    <input type="radio" class="form-check-input" name="actionsPerformer" @change="onchange('agent_requester')" value="agent_requester" :checked="actionsPerformer === 'agent_requester'"> &nbsp;{{lang('agent_or_requester')}}
			    </label>
		    </div>
	    </template>
	  </div>

  </faveo-box>
</template>

<script>

export default {

  name: 'action-performer',
	
	props : {
		
		pageType : { type : String, default : 'ticket' }
	},

  data: () => {
    return {
      actionsPerformer: 'agent',
    }
  },

  beforeMount () {
    this.actionsPerformer = this.$store.getters.getAutomatorDataByKey('actionsPerformer')
  },

  methods: {
    onchange (value) {
      this.$store.dispatch('setAutomatorDataByKey', { key: 'actionsPerformer', value: value })
    }
  }
}
</script>

<style scoped>

.form-check-input{
  margin-left: -1rem !important;
  cursor: pointer;
}

</style>