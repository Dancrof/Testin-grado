<template>
  <div class="col-sm-12">

    <div class="card card-light card-tabs">

      <div class="card-header p-0 pt-1">

        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">

          <li v-for="section in tabs" :key="section.id" class="nav-item">

            <a  id="settings_tab" @click="associates(section.id)" class="nav-link cursor-pointer"
                :class="{ active: category === section.id }" data-bs-toggle="pill" role="tab">

              {{ lang(section.title) }}
            </a>
          </li>
        </ul>
      </div>
      <!-- Tab content -->
      <div class="card-body">

        <div class="tab-content">

          <div class="tab-pane active" role="tabpanel">

            <!-- Dynamic component rendering -->
            <component :is="currentComponent" :whiteLabel="whiteLabel" :category="category"></component>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import {useRoute} from "vue-router";
import PluginsPage from "./PluginsPage.vue";
import AvailablePlugins from "./AvailablePlugins.vue";

const route = useRoute();

const category = ref('installed_plugins');

onMounted(()=>{

  route.query.type ? associates(route.query.type) : '';
})

const props = defineProps({

  whiteLabel : { type : Boolean, default : false },
})

const tabs = ref([
  // tab options
  {id: 'installed_plugins', title: 'installed_plugins'},
  {id: 'available_plugins', title: 'available_plugins'}, // Corrected typo in 'listener'
]);

const currentComponent = computed(() => {
  // Dynamically select the current component based on the category
  switch (category.value) {
    case 'installed_plugins':
      return PluginsPage;
    case 'available_plugins':
      return AvailablePlugins;
    default:
      return null;
  }
});

const associates = (selectedCategory) => {
  // Update the category when a tab is clicked
  category.value = selectedCategory;
}
</script>

<style scoped>

.cursor-pointer{
  cursor: pointer;
}
</style>
