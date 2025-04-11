<script setup>
import { ref } from 'vue'
import { getSubStringValue } from '../../../../../../helpers/extraLogics'
import Loader from "../../../../../Extra/Loader.vue";

const props = defineProps({
  integrationData: { type: Array, default: () => [] }
});

const cardOpen = ref(true);
const url = ref(props.integrationData[0]?.app_url || '');
const selectedIndex = ref(0);
const hasLoaded = ref(false);

const toggleCard = () => {
  cardOpen.value = !cardOpen.value;
};

const updateData = (index, data) => {
  if(url.value !== data.app_url) {
    hasLoaded.value = false;
  }
  selectedIndex.value = index;
  url.value = data.app_url
};

const handleIframeLoad = () => {
  hasLoaded.value = true;
};

const subString = (name) => {
  return getSubStringValue(name, 14)
}
</script>

<template>

  <div class="card card-light card-tabs">

    <div v-if="props.integrationData" class="card-header border-0 p-0 pt-2 d-flex">

      <ul class="nav nav-tabs col-sm-10" :class="{ 'tabs-disabled' : !cardOpen }" id="custom-tabs-one-tab" role="tablist">

        <li class="nav-item" v-for="(data, index) in props.integrationData.slice(0,3)">
          <span class="nav-link card-header-link cursor-pointer" v-tooltip="data.app_name" :class="{'active': index === selectedIndex}" id="custom-tabs-one-home-tab"
                @click="updateData(index, data)" data-bs-toggle="pill" role="tab" aria-controls="custom-tabs-one-home">{{subString(data.app_name)}}</span>
        </li>

        <li v-if="props.integrationData.length > 3" class="nav-item dropdown">
          <span class="nav-link dropdown-toggle pointer" data-bs-toggle="dropdown" role="tab" aria-expanded="false">{{lang('more')}}</span>
          <ul class="dropdown-menu min-content-width">
            <li v-for="(data, index) in props.integrationData.slice(3)">
              <span class="dropdown-item cursor-pointer" v-tooltip="data.app_name" :class="{'active': index + 3 === selectedIndex}" id="custom-tabs-one-home-tab"
                    @click="updateData(index + 3, data)" data-bs-toggle="pill" role="tab" aria-controls="custom-tabs-one-home">
                {{subString(data.app_name)}}
              </span>
            </li>
          </ul>
        </li>
      </ul>

      <button type="button" class="btn btn-tool col-sm-2" @click="toggleCard">

        <i :class="{'fas fa-angle-up' : cardOpen, 'fas fa-angle-down' : !cardOpen }" class="fs-25 pl-28" ></i>
      </button>

    </div>

    <div v-show="cardOpen"  class="card-body parent-class box-profile">

      <div class="child-class">
        <Loader v-if="!hasLoaded"></Loader>
      </div>

      <iframe :src="url" loading="lazy" @load="handleIframeLoad" class="border-0" width="100%" height="500px"></iframe>

      <a v-if="hasLoaded" :href="url" target="_blank" class="btn btn-primary w-100 btn-block">
        <i class="fas fa-external-link mr-2"> </i> {{trans('view_more_info')}}
      </a>
    </div>
  </div>

</template>

<style scoped>
.min-content-width { max-height: 250px; overflow-y: auto; }
.tabs-disabled { pointer-events: none; opacity: 0.5 }
.parent-class{ position: relative; }
.child-class { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
.pl-28{ padding-left: 28px; }
</style>