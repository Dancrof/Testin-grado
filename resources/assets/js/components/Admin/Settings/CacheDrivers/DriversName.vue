<template>
<span>
    <!-- Display the name of the driver -->
		<span>{{data.name}}</span>
		&nbsp;
  <!-- Conditionally show a tooltip and a link if tooltip data is available -->
		<a :class="!data.document_link ? 'drivers-tooltip' : ''" v-if="data.tooltip" v-tooltip="data.tooltip" :href="data.document_link" target="_blank">
      <!-- Icon for additional information -->
			<i class="fas fa-question-circle"></i>
		</a>
	</span>
</template>
<script>
export default {
  name: "DriversName",

  props: {
    // passing driver data to the component
    data : { type : Object, required : true },
  },
}
</script>
<style scoped>

.drivers-tooltip{
    cursor: help;
}

</style>