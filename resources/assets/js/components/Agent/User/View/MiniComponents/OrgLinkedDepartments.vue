<template>

	<div class="org-link-dept">

		<template v-if="data.departments.length">

			<template v-for="dept in data.departments">

				<span class="link_badge">{{ dept.name }}

					<a href="javascript:;" class="text-muted" @click="removeOrgDept(dept)">
						<i class="fas fa-times"></i>
					</a>
				</span>
			</template>
		</template>

		<template v-else>--</template>

		<modal v-if="showDelete" :showModal="showDelete" :onClose="() => showDelete = false"
			:containerStyle="{ width : '500px' }">

			<template #title>

				<h4 class="modal-title">{{lang('detach')}}</h4>
			</template>

			<template #alert><alert componentName="dept_remove"/></template>

			<template #fields>

				<reuse-loader v-if="loading"></reuse-loader>

				<span v-if="!loading">{{lang('are_you_sure')}}</span>
			</template>

			<template #controls>
				<button type="button" @click = "onRemoveConfirm()" class="btn btn-primary">
					<i class="fas fa-unlink"></i>&nbsp;{{lang('detach')}}
				</button>
			</template>
		</modal>
	</div>
</template>

<script>

import axios from 'axios';

import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

export default {

	name:"contract-name",

	description: "Contract name component.",

	props: {

		data : { type : Object, required : true },
	},

	data(){
		return{

			showDelete : false,

			deleteObj : '',

			loading : false
		}
	},

	methods:{

		removeOrgDept(value) {

			this.showDelete = true;

			this.deleteObj = value;
		},

		onRemoveConfirm() {

			this.loading =  true;

			axios.delete('/api/user/remove_user_department/'+this.data.user_id+'/' + this.data.org_id +'/'+this.deleteObj.id).then(res=>{

				this.loading = false;

				this.deleteObj = '';

				successHandler(res,'dept_remove');

				setTimeout(()=>{

					this.showDelete = false;

					window.emitter.emit('orgDeptRemoved');

					this.$store.dispatch('unsetAlert');

				},2000);

			}).catch(err=>{

				errorHandler(err,'dept_remove')
			});
		},
	}
};

</script>

<style type="text/css" scoped>
	.link_badge { border: 1px solid #aeafb0;border-radius: 0.25rem;padding: 3px;margin: 3px;}

	.text-muted:hover {
		color: #6c757d!important;
	}
</style>