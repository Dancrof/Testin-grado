<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="divStyle">

		<template #title>
	
			<h4 class="modal-title">{{lang('change_requester')}}</h4>
		</template>

		<template #fields>

			<div v-if="!loading" class="row">

				<dynamic-select :label="lang('users')" :multiple="false" name="user" :required="true"
								classname="col-sm-12" apiEndpoint="/api/dependency/users?meta=true&package_filter=true"
								:value="user" :onChange="onChange" :clearable="user ? true : false" strlength="60">

				</dynamic-select>
			</div>

			<div class="row" v-if="loading">

				<reuse-loader :duration="4000" :size="60"></reuse-loader>

			</div>
		</template>

		<template #controls>
			
			<button type="button"  @click="onSubmit" class="btn btn-primary" :disabled="isDisabled">
			
				<i class="fas fa-sync-alt"></i> {{lang('update')}}
			</button>
		</template>
	</modal>
</template>

<script>

	import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";

	import axios from 'axios'
	import DynamicSelect from "../../../../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {

		name:'change-requester-modal',

		description: 'Change requester modal component',

		props:{

			showModal : { type : Boolean, default : false },

			onClose : { type : Function },

			ticketId : { type : [String, Number], default : '' },

			reloadDetails : { type : Function }
		},

		data(){
			
			return {

				isDisabled:false,

				loading:false,

				user : '',

				divStyle : { width : '500px' }
			} 
		},

		beforeMount() {

			this.isDisabled = this.user ? false : true;
		},

		methods:{

			onChange(value,name) {

				this[name] = value;

				this.isDisabled = value ? false : true;
			},

			onSubmit(){
				
				this.loading = true;

				this.isDisabled = true;

				const data = {};

				data['owner_id']=this.user.id;
				
				axios.post('/api/change-owner/'+this.ticketId,data).then(res=>{

					this.reloadDetails('requester');

					successHandler(res,'timeline');

					this.loading = false;

					this.isDisabled = false;

					this.onClose();

				}).catch(err=>{

					errorHandler(err,'timeline');

					this.loading = false;

					this.isDisabled = false;

					this.onClose();
				})
			},
		},

		components:{

			'dynamic-select': DynamicSelect,
		},
	};
</script>