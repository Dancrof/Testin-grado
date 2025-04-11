<template>
	
	<div class="col-sm-12">
		
		<div class="row">
			
			<div class="col-md-12">
				
				<alert componentName="org-view"/>
			</div>
		</div>

		<div v-if="!loading && orgData" class="row">

			<div class="col-md-4" :key="counter">
	
				<org-details :orgData="orgData" :managerList="orgManagers"></org-details>

				<template v-if="orgManagers.length > 0">
					
					<org-managers v-for="manager in orgManagers"  :key="manager.id" :manager="manager">
						
					</org-managers>
				</template>
			</div>

			<div class="col-md-8">

        <org-members v-if="orgId" :id="orgId" :name="orgData.name" disableLoader="true" :orgData.sync="orgData"></org-members>

				<org-tickets v-if="orgId" :id="orgId" disableLoader="true" :name="orgData.name"></org-tickets>

				<org-departments v-if="orgData.OrganizationDepartmentStatus" disableLoader="true" :id="orgId"></org-departments>

        <org-forms v-if="orgData.loggedInUserRole === 'admin'" :id="orgId"> </org-forms>

				<div id="org-page-div">{{orgPageMounted()}}</div>

        <div id="org-page-table">{{orgPageVisible()}}</div>

        <org-report v-if="orgId" :id="orgId" :name="orgData.name"></org-report>
			</div>
		</div>

		<div v-else class="row">
				
			<reuse-loader :animation-duration="4000" :size="60"/>
		</div>

	</div>
</template>

<script>

	import {getIdFromUrl} from "../../../helpers/extraLogics";

	import axios from 'axios'

  import {errorHandler} from "../../../helpers/responseHandler";
	import OrgDetails from "./View/OrgDetails.vue";
	import OrgManagers from "./View/OrgManagers.vue";
	import OrgMembers from "./View/OrgMembers.vue";
	import OrgDepartments from "./View/OrgDepartments.vue";
	import OrgTickets from "./View/OrgTickets.vue";
	import OrgReport from "./View/OrgReport.vue";
  import OrgForms from "./View/MiniComponents/OrgForms.vue";

	export default {
		
		name : 'org-view',

		description : 'Organization view page',

    props : {

      authInfo : { type : Object, default :  ()=>{}}
    },

		data() {
			return {

				orgId : '',

        org_id: '',

				orgData : '',

				orgManagers : [],

        location : '',


        loading : true,

				counter : 0
			}
		},

		created(){

			window.emitter.on('refreshOrgData',this.refreshOrgDetails)
		},

		beforeMount(){

			const path = window.location.pathname;

      let splitPath = path.split('/');

      this.location = splitPath[splitPath.length-2];
			
			this.orgId = getIdFromUrl(path);

			this.getInitialValues(this.orgId)
		},

		methods :{

      refreshOrgDetails(from = ''){

        if(from){

          setTimeout(()=>{

            this.loading = true;

            this.getInitialValues(this.orgId);
          },2000);
        } else {

          this.getInitialValues(this.orgId, true);
        }
        },

			getInitialValues(id, refresh){

				axios.get('/api/organization/view/'+id+'?date='+Date.now()).then(res=>{

					this.orgData = res.data.data.organization;

					this.orgManagers = res.data.data.manager;

					if(refresh) { this.counter += 1 };

					this.loading = false

				}).catch(err=>{

					this.loading = false

          errorHandler(err,'org-view');

          this.redirect('/panel/dashboard');
        })
			},


			orgPageVisible(){
				
				window.emitter.emit('org-page-mounted',{org_id : this.orgId,'from' : 'org', 'disableLoader':'true'});
			},

			orgPageMounted(){

				window.emitter.emit('org-page-mounted',{org_id : this.orgId,'from' : 'org', 'disableLoader':'true'});
			},
		},

		components : {
      OrgForms,

			'org-details' : OrgDetails,

			'org-managers' : OrgManagers,

			'org-members' : OrgMembers,

			'org-departments' : OrgDepartments,

			'org-tickets' : OrgTickets,

			'org-report' : OrgReport
		}
	};
</script>

<style scoped>

	#dept_mgr{
		min-height: 120px;
	}
	.pad_0 {
		padding: 0 !important;
	}
</style>