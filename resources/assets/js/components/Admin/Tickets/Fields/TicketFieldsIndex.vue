<script setup>

import {h, onBeforeMount, ref} from "vue";
import Datatable from "../../../Extra/DataTable.vue";
import Alert from "../../../MiniComponent/Alert.vue";
import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

import {useStore} from "vuex";
import {useRoute} from "vue-router";
import {lang} from "../../../../helpers/extraLogics";
const store = useStore();

const route = useRoute();

const selectedCategory = ref('formFields');

const categories = ref([
	{id : 'formFields', title : 'fields'},
	{id : 'sections', title : 'sections'},
])

const listApiUrl = ref('/get/field-managers/ticket?relation=formFields');

const tableColumns = ref(['label', 'data_type', 'created_at', 'actions']);

const tableOptions = ref({});

const tabLoading = ref(false);

const changeCategory = (category) => {

	if (selectedCategory.value !== category) {

		const newUrl = window.location.origin + window.location.pathname;
		history.replaceState({}, document.title, newUrl);

		tabLoading.value = true;

		selectedCategory.value = category;

		listApiUrl.value = '/get/field-managers/ticket?relation='+category;

		setTimeout(() => {

			tabLoading.value = false;
		}, 1)
	}
}

onBeforeMount(()=>{

	if(route.query && route.query.page) {

		selectedCategory.value = route.query.page;

		listApiUrl.value = '/get/field-managers/ticket?relation='+selectedCategory.value;
	}

	tableOptions.value = {

		sortIcon: { base : 'glyphicon', up: 'glyphicon-chevron-down', down: 'glyphicon-chevron-up' },

		texts: { filter: '', limit: '' },
		
		columnsClasses : {
			
			data_type: 'field-data-type',
		},
		
		headings: {
			label: lang('label'),
			data_type: lang('data_type'),
			created_at: lang('created_at'),
			actions: lang('actions')
		},

		sortable:  ['label', 'created_at', 'data_type'],

		filterable:  ['label', 'created_at', 'data_type'],

		pagination: { chunk : 5, nav : 'fixed', edge : true},

		requestAdapter(data) {

			return {

				'paginate' : 1,

				'sort-field' : data.orderBy ? data.orderBy : 'id',

				'sort-order' : !data.ascending ? 'desc' : 'asc',

				'search-query' : data.query.trim(),

				page : data.page,

				limit : data.limit,
			}
		},

		responseAdapter({data}) {

			return {

				data: data.data.data.map(data => {

					data.edit_url = '/ticket-fields/edit/'+selectedCategory.value+'/'+data.data_type+'/'+data.id;

					data.delete_url = data.delete_api;

					data.alertComponentName = 'ticket-fields-index';

					return data;
				}),

				count: data.data.total
			}
		},

		orderBy: { column: 'id', ascending: true },

		templates : {

			created_at: (f,row) => {

				return store.getters.formattedTime(row.created_at);
			},

			actions: (f,row)=>{

				return h(DataTableActions,{data:row})
			},
		}
	}
});

</script>

<template>

	<div class="col-sm-12">

		<Alert componentName="ticket-fields-index"></Alert>

		<div class="card card-light card-tabs">

			<div class="card-header p-0 pt-1">

				<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">

					<li v-for="(item,index) in categories" class="nav-item" :key="index">

						<a class="nav-link" :class="{ active: selectedCategory === item.id }" data-bs-toggle="pill" href="javascript:;" role="tab" aria-selected="true"
							@click="changeCategory(item.id)">{{trans(item.title)}}
						</a>
					</li>

					<li class="nav-item ms-auto mt-1 me-2">

						<router-link :to="'/ticket-fields/'+selectedCategory+'/create'" class="btn btn-tool" v-tooltip="trans('create')" href="javascript:;">

							<i class="glyphicon glyphicon-plus"></i>
						</router-link>
					</li>
				</ul>
			</div>

			<div class="card-body" id="fields-list">

				<div class="tab-content">

					<div class="tab-pane fade active show" role="tabpanel">

						<Datatable :url="listApiUrl" :data-columns="tableColumns" :option="tableOptions" scroll_to ="fields-list">

						</Datatable>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>

	.mt-04 { margin-top: 4px !important; }
</style>

<style>
	.field-data-type {
		text-transform: capitalize !important;
	}
</style>