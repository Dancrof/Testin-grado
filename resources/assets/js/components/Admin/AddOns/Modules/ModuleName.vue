<template>

	<p>{{data.name}} <tool-tip :message="data.tooltip" size="small"></tool-tip></p>

</template>

<script type="text/javascript">
	
	import ToolTip from "../../../../components/MiniComponent/ToolTip.vue";

	export default {
		
		name:"module-name",
		
		props: {
			
			data : { type : Object, required : true }
		},

		components : {

			'tool-tip' : ToolTip
		}
	};
</script>

<style type="text/css">
</style>