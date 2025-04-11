<template>
	
	<div class="col-sm-12">
	
		<alert componentName="language" />

		<custom-loader v-if="loading" :duration="4000"></custom-loader>

		<div class="card card-light">
			
			<div class="card-header">
				
				<h3 class="card-title">{{trans('language-settings')}}</h3>

			</div>

			<div class="card-body" id="lang-table">
				
				<data-table v-if="apiUrl" :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="lang-table" :key="updateTable">
					
				</data-table>
			</div>
		</div>
	</div>
</template>

<script>

	import axios from "axios";

    import { successHandler, errorHandler } from "../../../../helpers/responseHandler";
  import LanguageAction from "./LanguageAction.vue";

    export default {
		
		name: "languages-index",

		description: "Languages table component",

		data(){

			return {

				columns: [ "language", "native_name", "iso_code", "system_default_language", "action"],

				options: {},

				apiUrl: "api/admin/language-list",

				loading : false,

				updateTable : 0
			}
		},

		beforeMount() {

			const self = this;

			this.options = {
			
				texts: { filter: "", limit: "" },
	
				headings: {

          language : this.trans('language'),

          native_name: this.trans('native_name'),

          iso_code: this.trans('iso-code'),

          system_default_language : this.trans('system_default'),

          action : this.trans('action')
				},

				columnsClasses : {

					language: 'lang-name',

					native_name : 'lang-native',

					iso_code : 'lang-iso',

          system_default_language : 'lang-default'
				},

				templates: {

          system_default_language(createElement, row) {
						
						return self.h('span', {
							
								'class' : row.system_default_language ? 'btn btn-light text-success btn-sm pointer_normal' : 'btn btn-light text-danger btn-sm pointer_normal'
						}, row.system_default_language ? this.lang('Yes') : this.lang('No'));
					},

					language(createElement,row) {

						return self.h('span', {innerHTML: row.language});
					},
          action: (f,row)=>{
            return self.h(LanguageAction,{data:row})
          },
				},
				
				sortable: ["language", "native_name", "iso_code"],

				filterable: ["language", "native_name", "iso_code"],
				
				pagination: { chunk: 5, nav: "scroll" },
				
				requestAdapter(data) {
					
					return {
						
						'sort-field' : data.orderBy ? data.orderBy : "language_name",
						
						'sort-order' : data.ascending ? "asc" : "desc",
						
						'search-query' : data.query.trim(),
						
						page: data.page,
						
						limit: data.limit
					};
				},

				responseAdapter({ data }) {  

					self.total_records = data.data.total;      
				
					return {
						
						data: data.data.data,
						
						count: data.data.total
					};
				},

				orderBy: { column: 'language_name', ascending: true },
			};
		},

		methods: {
			
			makeDefault(iso) {

				this.loading = true;

				axios.patch('api/admin/update-system-language/'+iso).then(res=>{

					this.loading = false;

					this.updateTable += 1;

					successHandler(res,'language');

					location.reload();

				}).catch(err=>{

					this.loading = false;

					errorHandler(err,'language');
				})
			}
		}
	};
</script>

<style>

	.lang-name,.lang-native,.lang-iso,.lang-default{
		max-width: 200px; word-break: break-all;
	}
	
	#lang-table .VueTables .table-responsive {
		overflow-x: auto;
	}

	#lang-table .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
  .lang-default{
    width: 150px!important;
  }
</style>
