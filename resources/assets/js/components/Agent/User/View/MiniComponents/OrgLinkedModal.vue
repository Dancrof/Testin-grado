<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle" :key="counter">

		<template #title>

			<h4 class="modal-title">{{ deptCondition ? trans('linked_org_dept') : trans('linked_org')}}</h4>
		</template>

		<template #fields>

			<div class="height-limit" id="org-linked-table">

				<alert componentName="org-linked-datatable"/>

				<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="org-linked-list">

				</data-table>

			</div>

			<div class="row" v-if="loading">

				<custom-loader :duration="4000"></custom-loader>
			</div>
		</template>
	</modal>
</template>

<script>

import DataTableActions from "../../../../MiniComponent/DataTableComponents/DataTableActions.vue";

import OrgLinkedDepartments from "./OrgLinkedDepartments.vue";
import {RouterLink} from "vue-router";

import { lang } from "../../../../../helpers/extraLogics";

export default {

	name : 'product-assets',

	description : 'Product asset Modal component',

	props:{

		showModal:{type:Boolean,default:false},

		onClose:{type: Function, default : ()=>{}},

		userId : { type : [String, Number], default : ''},

		deptCondition : { type : [Boolean, Number], default : false }
	},

	data() {

		return {

			columns: this.deptCondition ? ['organization', 'organization_Departments', 'action'] : ['organization', 'action'],

			options: {},

			apiUrl:'api/user/get_organization_with_department/'+this.userId,

			containerStyle:{ width:'950px' },

			loading : false,

			counter : 0
		}
	},

	created() {
		window.emitter.on('orgDeptRemoved',this.refreshLink);
	},

	beforeMount() {

		const self = this;

		this.options = {

			sortIcon: {

				base : 'glyphicon',

				up: 'glyphicon-chevron-down',

				down: 'glyphicon-chevron-up'
			},

      headings: {

        'organization' : lang('organisation'),

        'organization_Departments' : lang('organisation_departments'),

      },

			texts: { filter: '', limit: '' },

			columnsClasses : {

				organization : 'org-linked-organization',

				departments : 'org-linked-department',
			},

			templates: {

        organization: function(createElement, row) {

          return self.h(RouterLink, {

              to: '/organizations/' + row.org_id,

          }, row.organization);
        },

				organization_Departments : (f,row)=>{
					return self.h(OrgLinkedDepartments,{data:row})
				},

				action: (f,row)=>{
					return self.h(DataTableActions,{data:row})
				}
			},

			sortable:  [],

			filterable:  false,

			pagination:{chunk:5,nav: 'fixed',edge:true},

			requestAdapter(data) {

				return {

					'sort-field' : data.orderBy ? data.orderBy : 'id',

					'sort-order' : data.ascending ? 'desc' : 'asc',

					'search-query' : data.query,

					page : data.page,

					limit : data.limit,
				}
			},

			responseAdapter({data}) {

				window.emitter.emit('linkedOrgTotal', data.data.total);

				return {

					data: data.data.data.map(data => {

						data.delete_url = self.basePath() + '/api/remove-user-org/'+self.userId+'/' + data.org_id;

						data.alertComponentName = "org-linked-datatable";

						data.deleteicon = "fas fa-unlink";

						 data.deleteTip = "detach";

						data.deleteTitle = "detach";

						return data;
					}),
					count: data.data.total
				}
			},

			orderBy: { column: 'id', ascending: true },
		}
	},

	methods:{

		refreshLink() {

			this.counter += 1;
		}
	}
};
</script>

<style type="text/css">
.height-limit{
	overflow-y: auto;
	max-height: 400px;
	overflow-x: hidden;
	padding-left: 10px;
	padding-right: 10px;
}
</style>
