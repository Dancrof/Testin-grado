<template>

	<div style="padding-left: 3rem; padding-right: 3rem;">

	  <dynamic-select v-if="field.key === 'mail_agent'" :label="trans('agent')" name="users" apiEndpoint="/api/dependency/agents" :value="users" :onChange="onChange" rules="required" :required="true" :multiple="true"></dynamic-select>

	  <text-field :label="trans('subject')" type="text" :name="`${field.key}_subject`" :value="subject" :onChange="onChange" :placehold="lang('enter_a_value')" rules="required" :required="true"></text-field>

	  <tiny-editor-with-validation :label="trans('body')" :name="`${field.key}_body`" :id="`${field.key}_body`" :value="body || ''" :onChange="onChange" rules="required" :required="true"></tiny-editor-with-validation>

  </div>
</template>

<script>

import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
import TextField from "../../MiniComponent/FormField/TextField.vue";

export default {
  name: 'automator-custom-type-field',

  props: {
    field: { type: Object, required: true },
    actionEmail: { type: Object, required: true },
    index: { type: Number, required: true },
  },

  data: () => {
    return {
      users: null,
      subject: '',
      body: ''
    }
  },

  beforeMount() {
    this.users = this.actionEmail.users;
	this.subject = this.actionEmail.subject;
	this.body = this.actionEmail.body;
  },

  methods: {
    onChange (value, name) {
      this.$store.dispatch('updateActionEmail', { index: this.index, key: name.replace(this.field.key+'_',''), value: value })
    }
  },

  components: {
    'dynamic-select': DynamicSelect,
    'text-field': TextField,
  }
}
</script>

<style>

</style>