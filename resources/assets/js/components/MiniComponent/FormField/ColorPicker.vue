<template>

	<div class="form-group">

		<div class="input-group my-colorpicker2">
			<input type="text" class="form-control" v-model="colorValue" ref="colorPicker">
      <span class="input-group-text"><i class="fas fa-square" :style="'font-size: 20px;color: ' + getColorValue()"></i></span>
		</div>
	</div>

</template>

<script>
export default {
	props: {
		color : { type : String, default : '' },
		name : { type : String, default : '' },
		onColor : { type : Function, default : () =>{} },
		disabled : { type : Boolean, default : false },
		showError : { type : [Boolean,String,Number], default : false },
		colorError : { type : String, default : '' },
	},

	data () {

		return {

			colorValue : this.color
		}
	},

	mounted() {
		this.colorValue = this.color;
		$(this.$refs.colorPicker).colorpicker({
			format: 'hex',
			color: this.colorValue,
		}).on('colorpickerChange', (event) => {
			this.colorValue = event.color ? event.color.toString() : '';
			this.onChange(this.colorValue)
		});
	},

	methods: {

		getColorValue() {

			return this.colorValue ? this.colorValue : '#ffffff';
			
		},

		onChange(value) {

			this.onColor(value,this.name)
		}
	}
};
</script>

<style>

.red-border { border-color: #d73925 !important; }
</style>