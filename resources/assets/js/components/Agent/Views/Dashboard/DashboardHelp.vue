<template>
  <span v-if="helplink || description">
    <a v-if="helplink" :href="helplink" target="__blank">
      <tool-tip slot="headerTooltip" :message="description" size="medium"></tool-tip>
    </a>
    <tool-tip v-if="!helplink && description" slot="headerTooltip" :message="description" size="medium"></tool-tip>
  </span>
</template>

<script>
import ToolTip from "../../../MiniComponent/ToolTip.vue";

export default {

  name: 'dashboard-help',

  props: {
    helplink: {
      type: String,
      default: ''
    },
    description: {
      type: String,
      default: ''
    }
  },

  data: () => {
    return {

    }
  },

  components: {
    'tool-tip': ToolTip,
  }
}
</script>

<style>

</style>