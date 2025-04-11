<template>

	<span v-html="customFormattedTime(data[keyName],timestampFormat)"></span>
</template>

<script>

	import {useStore} from "vuex";
	import {computed} from "vue";

	export default {

		setup() {

			const store = useStore();

			return {

				customFormattedTime : computed(()=>store.getters.customFormattedTime)
			}
		},

		props: ['data', 'keyName','timestampFormat'],
	}
</script>