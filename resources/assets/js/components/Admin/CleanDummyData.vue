<template>
	
	<div class="col-sm-12">
		
		<alert componentName="dummy-data"></alert>
		
		<div class="card card-light">
			<div class="card-header">
				<h3 class="card-title">{{ trans('clean-data-box-title') }}</h3>
			</div><!-- /.box-header -->
			<div class="card-body">
				<ul>
					<li>{{ trans('clean-dummy-ticket-conversation') }}</li>
					<li>{{ trans('clean-dummy-notification') }}</li>
					<li>{{ trans('clean-dummy-users') }}</li>
					<li>{{ trans('clean-other-data') }}</li>
					<li>{{ trans('clean-user-created-data') }}</li>
				</ul>
			</div>
			
			<div class="card-footer">
				
				<button type="button" class="btn btn-secondary" @click="showModal = true">
					
					<i class="fas fa-trash"> </i> {{ trans('clean-data-btn') }}
				</button>
			</div>
		</div>
		
		<modal v-if="showModal" :showModal="true" :onClose="() => showModal = false" :containerStyle="{ width : '500px'}">
			
			<template #title>
				
				<h4 class="modal-title">{{trans('cleaning-database')}}</h4>
			</template>
			
			<template #fields>
				
				<div v-if="loading" class="text-center">
					
					<center><h6> {{trans('cleaning-in-progress')}}</h6></center>
					<center><h6> {{trans('do-not-refresh')}} </h6></center>
					<div class="spinner-border"></div>
				</div>
				
				
				<span v-if="!loading">{{trans('are_you_sure_you_want_to_delete')}}</span>
				
            </template>
			
			<template #controls>
				
				<button type="button" @click="onSubmit" class="btn btn-secondary">
					<i class="glyphicon glyphicon-ok" aria-hidden="true"></i>&nbsp;{{lang('confirm')}}
				</button>
			</template>
		</modal>
	</div>
</template>

<script>

import axios from 'axios';

import store from "../../../store";

export default  {
	
	name : 'clean-data',
	
	props : {
		
		dummyInstall : { type : Boolean, default : false }
	},
	
	data () {
		
		return {
			
			loading : false,
			
			showModal : false
		}
	},
	
	beforeMount() {
		
		if(!this.dummyInstall) {

			this.$router.push({ path : '/admin'})
		}
	},
	
	methods : {
		
		onSubmit() {
			
			this.loading = true;
			
			axios.post('/post-clean-dummy-data').then(res=>{

				this.showModal = false;

				this.loading = false;
				
				store.dispatch('setAlert', { type: 'success', message: 'Dummy data removed successfully', component_name: 'dummy-data' });
				
				setTimeout(()=>{
					
					this.redirect('/admin/')
				},2000);
				
			}).catch(err=>{

				this.loading = false;

				this.showModal = false;
			});
		}
	}
};
</script>