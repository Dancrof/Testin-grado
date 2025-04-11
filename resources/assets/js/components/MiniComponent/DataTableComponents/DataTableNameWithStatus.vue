<template>

  <div class="name-container">
    <div class="name">
      <router-link class="redirect-link" :to="data.view_url">
        <span v-tooltip="data.name">{{ data.name }}</span>
      </router-link>
    </div>
    <div class="name-status">
      <span class="badge" :class="labelClass">{{lang(data.status)}}</span>&nbsp;
      <span v-if="overdue" class="badge text-bg-danger">{{ lang('task-plugin-overdue') }}</span>
    </div>
  </div>

</template>

<script setup>

import {  computed } from 'vue';

const props = defineProps({

  data: { type: Object, required: true}
})


const labelClass = computed(() => {
  switch (props.data.status) {
    case "Open":
      return 'text-bg-success';
    case "Closed":
      return 'text-bg-danger';
    case "In-progress":
      return 'text-bg-warning';
    default:
      return 'text-bg-light'
  }
});

const overdue = computed(() => {
  const today = new Date().toISOString();
  return today > props.data.end_date;
});

</script>

<style scoped>

.name-container{
  display: flex;
  flex-direction: column;
}

.redirect-link{
  margin-bottom: 0;
}
</style>