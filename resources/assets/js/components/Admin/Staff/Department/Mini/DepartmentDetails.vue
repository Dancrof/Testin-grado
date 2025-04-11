<template>
	
	<div class="card card-light card-outline">

		<div class="card-body box-profile">
			
			<div class="text-center">
				
				<faveo-image-element id="deptimg" :source-url="basePathVersion()+'/themes/default/admin/images/department.jpg'"
					:classes="['profile-user-img img-fluid img-rounder img-circle']" alternative-text="Department Image"/>
			</div>

			<h3 class="profile-username text-center" v-tooltip="deptData.name">{{subString(deptData.name)}}</h3>

			<p class="text-muted text-center">{{trans('department')}}</p>

			<ul class="list-group list-group-unbordered mb-3">
				
				<li class="list-group-item">
					
					<b>{{trans('department_size')}}</b> <a class="float-end badge text-bg-info text-white">{{deptData.size}}</a>
				</li>
				
				<li class="list-group-item">
					
					<b>{{trans('business_hour')}}</b> 
					
					<a class="float-end" v-tooltip="deptData.business_hour ? deptData.business_hour.name : ''">
						{{deptData.business_hour ? subString(deptData.business_hour.name) : '--'}}
					</a>
				</li>

				<li class="list-group-item">

					<div>

						<b>{{trans('teams')}}</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								
						<a v-if="!deptData.teams.length" class="float-end">--</a>

						<template v-else>

							<template v-for="(team,index) in deptData.teams">

								<router-link :to="'/team/'+team.id" class="float-end" v-tooltip="team.name">

									{{subString(team.name)}}<span v-if="index != Object.keys(deptData.teams).length - 1">, </span>
								</router-link>
							</template>
						</template>
					</div>
				</li>
			</ul>

      <div class="d-grid">

        <router-link :to="'/department/'+deptData.id+'/edit'" class="btn btn-primary btn-block">

          <b> <i class="fas fa-edit"> </i>	{{trans('edit')}} </b>
        </router-link>
      </div>
		</div>
	</div>
</template>

<script>

	import {getSubStringValue} from "../../../../../helpers/extraLogics";

	export default {

		name : 'dept-details',

		description : 'Department details  page',

		props : { 

			deptData : { type : Object , default : () => {} }
		},

		methods :{
		
			subString(name){

				return getSubStringValue(name,20)
			}
		}
	};
</script>