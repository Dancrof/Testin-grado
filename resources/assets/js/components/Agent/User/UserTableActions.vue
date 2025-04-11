<template>

	<div class="user-table-actions">

		<template v-if="data.from == 'admin'">

			<router-link v-if="data.edit_url" class="btn btn-light table_btn" :to="data.edit_url" v-tooltip="lang('edit')">

				<i class="fas fa-edit"></i>
			</router-link>

			<template v-if="data.role != 'user'">

				<button type="button" class="btn btn-light table_btn dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" v-tooltip="lang('view')">

					<i class="fas fa-eye"></i>
				</button>

				<div class="dropdown-menu dropdown-menu-end">

					<a class="dropdown-item" :href="data.view_url"> {{trans('view_user')}} </a>

					<a class="dropdown-item" :href="data.agent_view_url"> {{trans('view_agent')}} </a>
				</div>
			</template>

			<a v-if="data.role === 'user'" class="btn btn-light table_btn" :href="data.view_url"
				v-tooltip="lang('view')">

				<i class="fas fa-eye"></i>
			</a>
		</template>

		<template v-else>
			
			<router-link v-if="data.edit_url" class="btn btn-light table_btn" :to="data.edit_url" v-tooltip="lang('edit')">

				<i class="fas fa-edit"></i>
			</router-link>

			<div v-if="data.role != 'user'" class="btn-group">
			
				<button type="button" class="btn btn-light table_btn dropdown-toggle" data-bs-toggle="dropdown" v-tooltip="lang('view')">
				
					<i class="fas fa-eye"></i>
				</button>
			
				<div class="dropdown-menu dropdown-menu-right">
					
					<router-link class="dropdown-item" :to="data.view_url"> {{trans('view_user')}} </router-link>

					<router-link class="dropdown-item" :to="data.agent_view_url"> {{trans('view_agent')}} </router-link>
				</div>
			</div>

			<router-link v-if="data.role === 'user'" class="btn btn-light table_btn" :to="data.view_url" 
				v-tooltip="lang('view')">

				<i class="fas fa-eye"></i>
			</router-link>
		</template>
	</div>

</template>

<script>

	export default {

		name:"user-table-actions",

		description: "User table edit componnet",

		props: {

			data : { type : Object, required : true },
		},
	};
</script>
