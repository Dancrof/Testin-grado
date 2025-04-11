<template>
	<p class="text-muted">{{ lang('copyright') }} © {{moment().year()}}

		<a :href="layout.company.website" target="_blank" id="copyright_link">

			{{ layout.company.company_name }}.

		</a>

    <template v-if="whiteLabel"> {{ trans('all_rights_reserved') }}. </template>

    <template v-else>

      {{ trans('all_rights_reserved') }}. {{ trans('powered_by') }} <a id="copyright_link" href="https://www.faveohelpdesk.com/" target="_blank">Faveo</a>
    </template>
	</p>		
</template>

<script>
	
	import moment from 'moment'

	export default {

		name : 'client-panel-copyright',

		description : 'Client panel copyright component',

		props : {

			layout : { type : Object, default : ()=>{}},

      whiteLabel : { type : Boolean , default : false},
		},

		data(){

			return {

				moment:moment
			}
		}
	};
</script>
<style scoped>
#copyright_link{
  color: #3c8dbc;
}
</style>