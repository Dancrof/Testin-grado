<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose">

		<template #title>

			<h4 class="modal-title">{{ data.check }}</h4>
		</template>

		<template #fields>

			<div id="log_desc">

				<table class="table table-bordered table-striped">

					<thead>
						<tr>
							<th v-for="head in data.headers">{{ head}}</th>
						</tr>
					</thead>

					<tbody>
						<tr v-for="column in data.columns">
							<td v-for="value in column">{{ value }}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</template>
	</modal>
</template>

<script>

export default {

	name : 'health-table-modal',

	props:{

		showModal:{type:Boolean,default:false},

		onClose:{type: Function, default : ()=>{}},

		data : { type : Object, default : ()=>{} }
	}
};
</script>

<style type="text/css" scoped>

#log_desc{
	overflow: auto;
	word-break: break-all;
	min-height: 150px;
	max-height: 350px;
}
</style>