<template>

	<div id="org_members">

		<alert componentName="OrgMembers"/>

		<div class="card card-light ">

			<div class="card-header">

        <h3 class="card-title" v-tooltip="trans('contacts_of') +' '+ name">{{trans('contacts_of')}} {{subString(name,40)}}</h3>

				<div class="card-tools">

          <button v-if="loading" type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

            <i class="fas fa-sync-alt"></i>
          </button>

          <router-link to="/user/create" class="btn-tool" v-tooltip="trans('create_contact')">

            <i class="glyphicon glyphicon-plus"></i></router-link>

          <a href="javascript:;" v-tooltip="trans('attach_contacts')" @click="showModal = true">

            <i class="fas fa-users"> </i>

          </a>
        </div>
			</div>

			<div class="card-body">

        <data-table :url="apiUrl" ref="membersTable"  :dataColumns="columns" :disableLoader="disableLoader" @loaderState="handelLoader" :option="options"
                    scroll_to="org_members" componentTitle="OrgMembers">
        </data-table>

			</div>
		</div>

    <transition name="modal">

      <org-user-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :orgId="orgData.id"
                      :usersList="usersList">

      </org-user-modal>

    </transition>

	</div>
</template>

<script>

	import { getSubStringValue } from "../../../../helpers/extraLogics";

	import {useStore} from 'vuex';

	import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

	import {computed} from "vue";
	import {RouterLink} from "vue-router";
	import DataTableStatuses from "../../../MiniComponent/DataTableComponents/DataTableStatuses.vue";
	import OrgUserModal from "./MiniComponents/OrgUserModal.vue";

	export default {

		name : 'org-members',

		description : 'Organization members list',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},

		props : {

			data : { type : Object, default : ()=> {} },

			id : { type : [String,Number], default : ''},

			name : { type : String , default : 'Organization'},

      orgData: { type: Object, default: () => { } },

      usersList: { type: Array, default: () => [] },

      reloadDetails : { type : Function },

      disableLoader : {type: Boolean, default: false}
    },

		data() {

			return {

        showModal: false,

				columns: ['name','user_name', 'email', 'labels', 'phone_number', 'info', 'action'],

				options: {},

				apiUrl:'/api/admin/get-users-list?org-ids[0]='+this.id,

        loading: true,
			}
		},

		beforeMount(){


			const self= this;

			this.options = {

				sortIcon: {

					base : 'glyphicon',

					up: 'glyphicon-chevron-down',

					down: 'glyphicon-chevron-up'
				},

				headings: {

					name: this.lang('name'),

					user_name: this.lang('user_name'),

					email : this.lang('email'),

          labels : this.lang('labels'),

					phone_number : this.lang('mobile'),

					info: this.lang('account_info'),

					action: this.lang('actions')
				},

				columnsClasses : {

         	user_name: 'org-name',

					email : 'org-email',

					phone_number : 'org-phone',

        },

				texts: { filter: '', limit: '' },

				templates: {

					name: function(createElement, row) {

						return self.h(RouterLink, {

								to: '/user/' + row.id,

						}, row.name);
					},

					user_name: function(createElement, row) {

						return self.h(RouterLink, {
							to: '/user/' + row.id
						}, row.user_name);
					},

					phone_number(h, row) {

						return row.phone === ' Not available' || !row.phone ? '---' : row.phone;
					},

					email(h, row) {

						return row.email ? row.email : '---';
					},

          updated_at : function(h,row){

          	return self.formattedTime(row.updated_at)
          },

						labels : function(h, row) {
							let labels = '';
							row.labels.map(function(label) {
								labels = labels + label.title + ', ';
							});
							labels = labels.slice(0,-2);
							return labels;
						},

					info : (f,row)=>{
						return self.h(DataTableStatuses,{data : row})
					},

					action: (f,row)=>{
						return self.h(DataTableActions,{data : row})
					}
				},

				sortable:  ['user_name', 'email', 'phone_number', 'active', 'ban', 'updated_at'],

				filterable:  ['user_name', 'email', 'phone_number', 'active', 'ban','updated_at'],

				pagination:{chunk:5,nav: 'fixed',edge:true},

				requestAdapter(data) {

	        return {

	          'sort-by': data.orderBy ? data.orderBy : 'updated_at',

	          order: data.ascending ? 'desc' : 'asc',

	          'search-query':data.query.trim(),

	          page:data.page,

	          limit:data.limit,
	        }
	      },

			 	responseAdapter({data}) {

					return {

						data: data.data.users.map(data => {

							data.from = 'agent';

							data.edit_url = '/user/' + data.id + '/edit';

							data.view_url = '/user/' + data.id ;

						return data;
					}),
						count: data.data.total
					}
				},

				orderBy: { column: 'updated_at', ascending: true },
			}
		},
    watch: {
      orgData: {
        handler(val) {
          if(val) {
            window.emitter.emit('OrgMembersrefreshData');
          }
        },
        immediate: true
      }
    },

		methods : {

      reloadData(from) {

        this.afterAction(from);
      },

			subString(name,length = 15){

				return getSubStringValue(name,length)
			},
      onClose() {
        this.showModal = false;
        this.$store.dispatch('unsetValidationError');
      },

      handelLoader(loader){

        this.loading = loader;
      }
		},

		components : {

      'org-user-modal': OrgUserModal,
		}
	};
</script>

<style>
	 .org-name,.org-email,.org-phone{ min-width: 150px;; word-break: break-all;}

	 #org_members .VueTables .table-responsive {
		overflow-x: auto;
	}

	#org_members .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
	}

   @keyframes rotate {
     from {
       transform: rotate(0deg);
     }
     to {
       transform: rotate(360deg);
     }
   }

   /* Apply the rotation animation when the button has a class of "rotating" */
   .btn-tool.rotating i {
     animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
   }
</style>
