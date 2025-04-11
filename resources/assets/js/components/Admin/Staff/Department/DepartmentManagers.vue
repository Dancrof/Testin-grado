
<template>

	<div class="btn-group">
		
		<span v-if="data.managers.length > 0" >
			
			<a id="managers" v-for="(manager,index) in data.managers" :href="basePath()+'/panel/user/'+manager.id"
				target="_blank">
				{{manager.full_name}}
				<span v-if="index != Object.keys(data.managers).length - 1">, </span>
			</a>
		</span>

		<span v-else >--</span>
	</div>
</template>

<script>

	export default {
		
		name:"data-table-managers",

		description: "Contains managers list",		
		
		props: {
			
			data : { type : Object, required : true }
		}
	};

</script>

<style type="text/css">
	#managers{
		word-wrap: break-word !important;
	}
</style>