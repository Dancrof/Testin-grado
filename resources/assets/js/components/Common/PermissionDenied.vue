<template>
  <span class="permission-update" v-tooltip="{ content: tooltipContent, html: true }">
    {{name}}
  </span>
</template>

<script setup>

const props = defineProps({
  name: String,
  tooltipContent: String,
});

</script>

<style scoped>
.permission-update {
  margin-left: 6px;
  color: #3c8dbc;
  cursor: default;
}
</style>