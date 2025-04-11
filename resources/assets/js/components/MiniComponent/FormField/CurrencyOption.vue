<template>
	<div class="vcs-select-option">
		<div :class="`currency-flag currency-flag-${currency.toLowerCase()}`"></div>
		<span class="vcs-select-option-desc">{{ currency }}</span>
	</div>
</template>

<script>
	export default {

		name: "SelectOption",

		props: {

			currency: { type : String, default : '' }
		}
	};
</script>

<style lang="scss">
.vcs-select-option {
	display: flex;
	align-items: center;
	.vcs-select-option-desc {
		margin-left: 1rem;
	}
}
</style>