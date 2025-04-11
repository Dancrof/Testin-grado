<template>
	<div className="fm-disk-list">
		<ul className="list-inline">
			<li className="list-inline-item" v-for="(disk, index) in disks" v-bind:key="index">
                <span className="badge"
					  v-on:click="selectDisk(disk)"
					  v-bind:class="[disk === selectedDisk ? 'badge text-bg-secondary' : 'badge text-bg-light']">
                    <i className="fa-fw far fa-hdd"/> {{ disk }}
                </span>
			</li>
		</ul>
	</div>
</template>

<script>
export default {
	name: 'DiskList',
	props: {
		// manager name - left or right
		manager: {type: String, required: true},
	},
	computed: {
		/**
		 * Disk list
		 * @returns {Array}
		 */
		disks() {
			return this.$store.getters['fm/diskList'];
		},

		/**
		 * Selected Disk for this manager
		 * @returns {default.computed.selectedDisk|(function())|default.selectedDisk|null}
		 */
		selectedDisk() {
			return this.$store.state.fm[this.manager].selectedDisk;
		},
	},
	methods: {
		/**
		 * Select disk
		 * @param disk
		 */
		selectDisk(disk) {
			if (this.selectedDisk !== disk) {
				this.$store.dispatch('fm/selectDisk', {
					disk,
					manager: this.manager,
				});
			}
		},
	},
};
</script>

<style lang="scss">
.fm-disk-list {

	ul.list-inline {
		margin-bottom: 0.5rem;
	}

	.badge.badge-light {
		cursor: pointer;
	}
}
</style>
