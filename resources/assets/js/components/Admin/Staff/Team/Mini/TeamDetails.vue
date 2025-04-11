<template>
	
	<div class="card card-light card-outline">

		<div class="card-body box-profile">
			
			<div class="text-center">
				
				<faveo-image-element id="teamimg" :source-url="basePathVersion()+'/themes/default/admin/images/team.jpg'"
					:classes="['profile-user-img img-fluid img-rounder img-circle']" alternative-text="Team Image"/>
			</div>

			<h3 class="profile-username text-center" v-tooltip="teamData.name">{{subString(teamData.name)}}</h3>

			<p class="text-muted text-center">{{trans('team')}}</p>

			<ul class="list-group list-group-unbordered mb-3">
				
				<li class="list-group-item">
					
					<b>{{trans('teamlead_name')}}</b> 

					<a v-if="!teamData.lead" class="float-end">--</a>

					<a v-else class="float-end" target="_blank" v-tooltip="teamData.lead.full_name" :href="basePath()+'/panel/user/'+teamData.lead.id">
						{{subString(teamData.lead.full_name,13)}}
					</a>
				</li>

				<li class="list-group-item">
					
					<b>{{trans('team_size')}}</b> <a class="float-end badge text-bg-info text-white">{{teamData.team_size}}</a>
				</li>

				<li class="list-group-item">
					
					<b>{{trans('status')}}</b> <a class="float-end" :class="[teamData.status == 'Active' ? 'text-success' : 'text-danger']">{{teamData.status}}</a>
				</li>

				<li class="list-group-item">

					<div>

						<b>{{trans('departments')}}</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								
						<a v-if="!teamData.departments.length" class="float-end">--</a>

						<template v-else>

							<template v-for="(dept,index) in teamData.departments">

								<router-link :to="'/department/'+dept.id"  class="float-end" v-tooltip="dept.name">

									{{subString(dept.name)}}<span v-if="index != Object.keys(teamData.departments).length - 1">, </span>
								</router-link>
							</template>
						</template>
					</div>
				</li>
			</ul>

      <div class="d-grid">

        <router-link :to="'/team/'+teamData.id+'/edit'" class="btn btn-primary btn-block">

          <b> <i class="fas fa-edit"> </i>	{{trans('edit')}} </b>
        </router-link>
      </div>
		</div>
	</div>
</template>

<script>

    import {getSubStringValue} from "../../../../../helpers/extraLogics";

	export default {

		name : 'team-details',

		description : 'Team details  page',

		props : { 

			teamData : { type : Object , default : () => {} }
		},

		methods :{
		
			subString(name,length=20){

				return getSubStringValue(name,length)
			}
		}
	};
</script>