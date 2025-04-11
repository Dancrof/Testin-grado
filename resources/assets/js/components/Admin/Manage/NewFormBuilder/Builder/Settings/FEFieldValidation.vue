<script setup>

/**
 * Props for the component.
 * @prop {Object} formFieldData - The form field data object.
 */
const props = defineProps({

	formFieldData: { type: Object, required: true }
})
</script>

<template>

	<div class="pt-0 ps-2 pe-2 pb-2">

		<div class="row">

			<div class="col-sm-12 form-group mb-3">

				<label>{{lang('pattern_regex')}}</label>

				<input type="text" class="form-input-box" v-model="formFieldData.pattern" :placeholder="lang('pattern_help_message')">
			</div>

			<div class="col-sm-12 form-group mb-3">

				<label>{{lang('validation_message')}}</label>

				<input type="text" class="form-input-box" v-model="formFieldData.validation_message">
			</div>
		</div>
	</div>
</template>

<style scoped>
	.form-input-box {
		display: block;
		width: 100%;
		height: 34px;
		padding: 6px 12px;
		font-size: 14px;
		line-height: 1.42857143;
		color: #555;
		background-color: #fff;
		background-image: none;
		border: 1px solid #ccc;
		border-radius: 4px;
		-webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
		box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
		-webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
		-o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
	}
</style>