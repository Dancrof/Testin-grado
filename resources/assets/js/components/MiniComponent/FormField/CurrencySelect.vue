<template>

	<form-field-template :name="name" :classname="classname" :label="label" :required="required">

		<v-select
			:name="name"
			v-model:modelValue="selectedCurrency"
			class="v-select-custom-styles"
			label="currency"
			:options="options"
			:reduce="option => option.currency"
			:clearable="clearable"
			:transition="transition"
			:closeOnSelect="closeOnSelect"
			:components="!showDeselectBtn ? { Deselect } : null"
			:placeholder="lang('select_currency')"
		>
			<template #option="{ currency }">
				<currency-option :currency="currency" />
			</template>

			<template #selected-option="{ currency }">
				<currency-option :currency="currency" />
			</template>

			<template #no-options>
				<span style="color: darkgray">No results</span>
			</template>
		</v-select>
	</form-field-template>
</template>

<script>

import vSelect from "vue-select";
import FormFieldTemplate from "./FormFieldTemplate.vue";
import CurrencyOption from "./CurrencyOption.vue";

export default {

	name: "CurrencySelect",

	components: {

		'currency-option' : CurrencyOption,

		'v-select': vSelect,

		'form-field-template': FormFieldTemplate,
	},

	props: {

		label: { type: String, default: '' },

		classname: { type: String, default: "" },

		name: { type : String, default : '' },

		value: { type : String, default : '' },

		options: { type : Array, default: ()=>[] },

		showDeselectBtn: { type : Boolean, default : true },

		onChange : { type : Function, default : ()=>{} },

		required: { type: [Boolean, Number], default: false },

		clearable: { type: Boolean, default: true },

		transition: { type: String, default: "fade"},

		clearSearchOnSelect: { type: Boolean, default: true },

		closeOnSelect: { type: Boolean, default: true },
	},

	data() {

		return {

			Deselect: {

				render: h => h("span", "")
			}
		};
	},

	computed: {

		selectedCurrency: {

			get() {

				return this.value;
			},

			set(value) {

				this.onChange(value,this.name);
			}
		}
	}
};
</script>

<!--<style lang="scss">-->
<!--@import "../styles/variables";-->
<!--.v-select-custom-styles {-->
<!--	width: $vs-dropdown-min-width;-->
<!--	.vs__dropdown-option {-->
<!--		padding: 10px 15px;-->
<!--	}-->
<!--}-->
<!--</style>-->