<template>

	<div class="card card-widget widget-user-2">
		
		<div class="widget-user-header bg-warning">
			
			<div class="widget-user-image">
				
				<faveo-image-element id="org_man" :source-url="manager.profile_pic" :classes="['img-circle elevation-2']" 
					alternative-text="User Avatar"/>
			</div>

			<router-link :to="'/agent/'+manager.id+'/edit'" v-tooltip="trans('edit')" class="float-end">

				<i class="fas fa-edit"></i>
			</router-link>
			
			<h3 class="widget-user-username" v-tooltip="manager.full_name">{{subString(manager.full_name)}}</h3>
			
			<h5 class="widget-user-desc fs-14">{{trans('department_manager')}}</h5>
		</div>
		
		<div class="card-footer p-0">
			
			<ul class="nav flex-column">
				
				<li class="nav-item">
					
					<a class="nav-link text-dark"> {{trans('email')}}  

						<span class="float-end" v-tooltip="manager.email">{{manager.email ? subString(manager.email) : '--'}}</span>
					</a>
				</li>

				<li class="nav-item">
					
					<a class="nav-link text-dark"> {{trans('phone')}}  

						<span class="float-end" v-tooltip="manager.phone_number">
							
							{{manager.phone_number ? subString(manager.phone_number) : '--'}}
						</span>
					</a>
				</li>
			</ul>
		</div>
	</div>
</template>

<script>

    import {getSubStringValue} from "../../../../../helpers/extraLogics";

	export default{

		name : '',

		description : '',

		props : {

			manager : { type : Object, default : ()=>{}}
		},

		methods : {

			subString(name,length = 15){
			
				return getSubStringValue(name,length)
			},
		}
	};
</script>

<style scoped>
	
	.widget-user-2 .widget-user-username { font-weight: 300 !important; }

	.fs-14 { font-size: 14px !important; }
</style>