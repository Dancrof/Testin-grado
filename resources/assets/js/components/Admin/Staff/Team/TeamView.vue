<template>

	<div class="col-sm-12">

		<div class="row">

			<div v-if="loading" class="col-sm-12">

				<reuse-loader :animation-duration="4000" color="#1d78ff" :size="50"/>
			</div>

			<template v-if="!loading">

				<div class="col-sm-3">

					<team-details :teamData="teamData"></team-details>
				</div>

				<div class="col-sm-9">

					<team-members disableLoader="true" :id="teamId"></team-members>

					<team-tickets disableLoader="true" :id="teamId" :name="teamData.name"></team-tickets>

					<team-report :id="teamId"></team-report>
				</div>
			</template>
		</div>
	</div>
</template>

<script>

	import {getIdFromUrl} from "../../../../helpers/extraLogics";

	import axios from 'axios'

    import TeamDetails from "./Mini/TeamDetails.vue";
    import TeamMembers from "./Mini/TeamMembers.vue";
    import TeamTickets from "./Mini/TeamTickets.vue";
    import TeamReport from "./Mini/TeamReport.vue";

	export default {

		name : 'team-view',

		description : 'Team view page',

		data() {
			
			return {
				
				teamId : '',

				teamData : '',
				
				loading : true
			}
		},

		beforeMount(){
			
			const path = window.location.pathname;
			
			this.teamId = getIdFromUrl(path);
			
			this.getTeamData(this.teamId)
		},

		methods : {

			getTeamData(id){
				
				axios.get('/api/admin/team-profile/'+id).then(res=>{
					
					this.teamData = res.data.data;
					
					this.loading  = false;

				}).catch(err=>{
					
					this.loading  = false;
				})
			}
		},

		components : {
			
			'team-details' : TeamDetails,
			
			'team-members' : TeamMembers,
			
			'team-tickets' : TeamTickets,
			
			'team-report' : TeamReport
		}
	};
</script>