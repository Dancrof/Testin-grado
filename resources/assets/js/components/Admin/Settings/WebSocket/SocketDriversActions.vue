<template>
  <div v-if="data">
    <!-- Conditional rendering based on data's config value -->
		<span v-if="data.config === 0" v-tooltip="data.status ? trans('activated') : trans('activate')">
      <!-- Button for activation -->
			<button class="btn btn-light table_btn" @click="showModal = true" :disabled="data.status">

				<i class="fas fa-check-circle"></i>
			</button>
		</span>

    <span v-if="data.config === 1" v-tooltip="data.status ? trans('configured') : trans('configure')">
      <!-- Button for configuration -->
			 <button class="btn btn-light table_btn"
               @click="redirectToCacheDriver">

      <i class="fas fa-cog"></i>
    </button>
		</span>

    <!-- Modal for activating the driver -->
    <transition name="modal">

      <driver-activate-modal v-if="showModal" :onClose="onClose" :showModal="showModal"  :driver="data.driver">

      </driver-activate-modal>
    </transition>
  </div>
</template>

<script>

import DriverActivateModal from "./SocketDriverActivateModal.vue";

export default {
  name: "SocketDriversActions",

  description: "Socket table action component",

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
    redirectToCacheDriver() {
        this.$router.push(`/websockets/${ this.data.driver}`);
    },
  },

  components: {
   'driver-activate-modal' : DriverActivateModal
  }
}
</script>

<style scoped>

</style>