<template>
  <div v-if="data">
    <!-- Conditional rendering based on data's config value -->
    <span v-if="data.is_configurable === 0" v-tooltip="data.status ? trans('activated') : trans('activate')">
      <!-- Button for activation -->
			<button class="btn btn-light table_btn driver_btn" @click="showModal = true" :disabled="data.status">

				<i class="fas fa-check-circle"></i>
			</button>
		</span>

    <span v-if="data.is_configurable === 1" v-tooltip="data.status ? trans('configured') : trans('configure')">
      <!-- Button for configuration -->
			 <button class="btn btn-light table_btn driver_btn"
               @click="redirectToDriverSettings">

      <i class="fas fa-cog"></i>
    </button>
		</span>

    <!-- Modal for activating the driver -->
    <transition name="modal">

      <driver-settings-activate-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :driver="data">

      </driver-settings-activate-modal>

    </transition>
  </div>
</template>

<script>

import DriverSettingsActivateModal from "./DriverSettingsActionModal.vue";

export default {
  name: "DriversSettingsActions",

  description: "drivers table action component",

  props: {
    // passing driver data to the component
    data : { type : Object, required : true },
  },

  data () {

    return {

      showModal : false // State for controlling modal visibility
    }
  },

  methods : {
    // Method to close the modal
    onClose() {

      this.showModal = false;
    },

    // Methode to redirect to `Configuration Page`.
    redirectToDriverSettings() {
        this.$router.push(`/search-driver/settings/${ this.data.id}`);
    },
  },

  components: {
    'driver-settings-activate-modal':DriverSettingsActivateModal
  }
}
</script>

<style scoped>

.driver_btn{
  cursor: pointer !important;
}

</style>