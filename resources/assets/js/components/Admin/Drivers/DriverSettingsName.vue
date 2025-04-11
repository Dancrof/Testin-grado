<template>
<span>
    <!-- Display the name of the driver -->
		<span>{{data.name}}</span>
		&nbsp;
  <!-- Conditionally show a tooltip and a link if tooltip data is available -->
		<a v-if="data.tooltip_message" :class="data.document_link === null ? 'drivers-alert' : ''" v-tooltip="data.tooltip_message" :href="data.document_link" target="_blank">
      <!-- Icon for additional information -->
			<i class="fas fa-question-circle"></i>
		</a>
	</span>
</template>
<script>
export default {
  name: "DriverSettingsName",

  description: "drivers name column table component",

  props: {
    // passing driver data to the component
    data : { type : Object, required : true },
  },
}
</script>
<style scoped>

.drivers-alert{
  cursor: help;
}
</style>