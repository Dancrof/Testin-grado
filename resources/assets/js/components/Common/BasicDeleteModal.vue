<template>

<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

	<template #title>

		<h4 class="modal-title">{{trans('delete')}}</h4>
	</template>

	<template #fields>

      <span v-if="!loading && from === 'charts'">{{trans('are_you_sure_you_want_to_delete')}}</span>
      <span v-if="!loading && from === 'widget'">{{trans('are_you_sure_you_want_to_delete_this_widget')}}</span>

		<div class="row" v-if="loading">

			<reuse-loader :duration="4000"></reuse-loader>
		</div>
	</template>

	<template #controls>

		<button type="button" id="submit_btn"  @click = "onSubmit" class="btn btn-secondary" :disabled="isDisabled">

			<i class="fas fa-trash"></i> {{trans('delete')}}
		</button>
	</template>
</modal>
</template>

<script>

import {errorHandler, successHandler} from "../../helpers/responseHandler";

import Modal from "./Modal.vue";

import axios from 'axios'

export default {

	name:'basic-delete-modal',

	description:'Basic delete modal Component',

	props:{

		showModal : { type : Boolean, default : false },

		onClose : { type : Function },

		deleteUrl : { type : String , default : ''},

		alert : { type : String , default : ''},

		redirectUrl : { type : String , default : ''},

		updateList : { type : Function, default : ()=>{}},

    from : { type : String , default : ''}
	},

	data(){

		return {

			isDisabled:false,

			loading:false,

			containerStyle:{ width:'500px' },
		}
	},

	methods:{

		onSubmit(){

			this.loading = true

			this.isDisabled = true

			axios.delete(this.deleteUrl).then(res=>{

        if(this.from === 'widget'){
          window.emitter.emit('reloadTopWidgets');
          window.emitter.emit('updateAgentSidebar');
        }else{
          this.updateList();
        }

				this.loading = false;

				this.isDisabled = true

				successHandler(res,this.alert);

				this.onClose();

				if(this.redirectUrl){

					setTimeout(()=>{

						return this.$router.push({path:this.redirectUrl})
					},3000)
				}

			}).catch(err => {

				this.loading = false

				this.onClose()

				errorHandler(err,this.alert)
			})
		},
	},

	components: {
		Modal
	}
};
</script>