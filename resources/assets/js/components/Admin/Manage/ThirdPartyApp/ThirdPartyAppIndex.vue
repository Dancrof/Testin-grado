<template>
  <div class="col-sm-12">
    <alert componentName="dataTableModal"/>

    <div class="card card-light">
      <div class="card-header">
        <h3 class="card-title">{{lang('third_party_apps')}}</h3>
        <div class="card-tools">

          <a href="javascript:;" class="btn-tool dropdown-toggle" data-bs-toggle="dropdown">

            <i class="glyphicon glyphicon-plus"> </i>
          </a>

          <div class="dropdown-menu dropdown-menu-right" role="menu" v-show="showDrop">

            <router-link id="create" class="dropdown-item" to="/third-party-app/create?page_type=basic" v-tooltip="lang('basic_auth_toottip')">
              {{lang('basic_auth')}}
            </router-link>
            <hr class="m-0">
            <router-link id="create" class="dropdown-item" to="/third-party-app/create?page_type=oauth" v-tooltip="lang('oauth_auth_tootip')">
              {{lang('oauth_auth')}}
            </router-link>
          </div>
        </div>

     
      </div>

      <div class="card-body">

        <data-table :url="apiUrl" :dataColumns="columns"  :option="options"></data-table>
      </div>
    </div>
  </div>
</template>

<script>

import DataTableStatus from "../../../MiniComponent/DataTableComponents/DataTableStatus.vue";
import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

export default {

  name : 'third-party-index',

  data() {

	  return {

		  base:window.axios.defaults.baseURL,

		  columns: ['name', 'app_id', 'status', 'auth' , 'action'],

		  options: {

        headings: { name: this.trans('name'), app_id: this.trans('app_id'), status: this.trans('status'), auth: this.trans('auth'), action:this.trans('action')},

			  texts: {
				  filter: '',
				  limit: ''
			  },
			  templates: {
				  status: (f,row)=>{
					  return this.h(DataTableStatus,{ data : row})
				  },
				  action: (f,row)=>{
					  return this.h(DataTableActions,{ data : row})
				  },
          app_id: (f, row)=>{
            return row.app_id ? row.app_id : '--'
          }
			  },
			  sortable:  ['name', 'status'],
			  filterable:  ['name', 'status'],

			  pagination:{chunk:5,nav: 'fixed',edge:true},

			  requestAdapter(data) {
				  return {
					  sort_field: data.orderBy ? data.orderBy : 'id',
					  sort_order: data.ascending ? 'desc' : 'asc',
					  search_query:data.query.trim(),
					  page:data.page,
					  limit:data.limit,

				  }
			  },
			  responseAdapter({data}) {
				  return {
					  data: data.data.data.map(data => {

						  data.edit_url = '/third-party-app/'+data.id+'/edit';

						  data.delete_url = window.axios.defaults.baseURL + '/api/admin/third-party-apps/' + data.id;

						  data.active = (data.active == '1') ? 'active' : 'inactive';

						  return data;
					  }),
					  count: data.data.total
				  }
			  },

			  orderBy: { column: 'id', ascending: true },
		  },

		  /**
		   * api url for ajax calls
		   * @type {String}
		   */
		  apiUrl:'api/admin/third-party-apps',

      showDrop: false
	  }
  },

  beforeMount() {
    setTimeout(()=>{

      this.showDrop = true;
    },1000);
  }
};
</script>

<style type="text/css" scoped>
.box-header h3{
  font-family: Source Sans Pro !important
}
.box.box-primary {
  padding: 0px !important;
}
.right{
  float: right;
}
</style>
