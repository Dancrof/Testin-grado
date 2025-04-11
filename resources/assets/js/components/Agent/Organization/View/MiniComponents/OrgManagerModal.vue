<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
	
		<template #title>
		
			<h4 class="modal-title">{{lang('assign_manager')}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading" class="row">

				<dynamic-select :label="lang('select_manager')" :multiple="true" name="managers"
								classname="col-sm-12" :apiEndpoint="'/search/organization/manager/'+orgId" :value="managers" :onChange="onChange">

				</dynamic-select>
			</div>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" :size="60" />
			</div>
		</template>

		<template #controls>
			
			<button type="button" @click="onSubmit()" class="btn btn-primary" id="submit_btn" :disabled="isDisabled">

				<i class="fa fa-check"></i> {{lang('assign')}}
			</button>
		</template>
	</modal>
</template>

<script>
	
	import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

	import axios from 'axios'
	import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {
		
		name : 'org-manager-modal',

		description : 'Assign Manger to Organization Modal component',

		props:{
			
			showModal:{type:Boolean,default:false},

			orgId : { type : [String,Number], default : '' },

			onClose:{type: Function},

			managerList : { type : Array, default : ()=>[] },
		},

		data(){
			
			return {

				isDisabled:true,

				containerStyle:{ width:'600px' },

				loading:false,

				managers : this.managerList
			}	
		},

		methods:{

		onChange(value, name){
			
			this[name]= value;

			this.isDisabled = value === '' ? true : false;
		},

		onSubmit(){

			this.loading = true
			
			this.isDisabled = true

			let ids = [];

			for(var i in this.managers){

				ids.push(this.managers[i].id)
			}
			var obj={'user':ids};

			axios.post('/add/organization/manager?org_id='+this.orgId,obj).then(res=>{
				
				this.loading = false;
				
				this.isDisabled = true
			
				successHandler(res,'org-view');
				
				window.emitter.emit('refreshOrgData');
				
				this.onClose();
				
			}).catch(err => {
				
				this.loading = false;
				
				this.isDisabled = false
				
				errorHandler(err,'org-view');

				this.onClose();
			})
		},
	},

	components:{
		
		"dynamic-select": DynamicSelect,
	}
};
</script>