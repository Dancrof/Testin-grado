<template>

	<div class="btn-group">

		<router-link v-if="data.edit_url" :to="data.edit_url">

			<span :title="trans('edit')" class="btn btn-light table_btn btn-sm" id="client_actions_edit_btn"><i class="fa fa-edit"></i></span>

		</router-link>


		<a v-if="data.deactivate_url" id="delete-button" @click="showModalMethod" href="javascript:;">

			<span :title="trans('deactivate')" class="btn btn-light table_btn btn-sm" id="client_actions_delete_btn" :disabled="disabled"><i class="fas fa-trash"></i></span>
		</a>

		<transition  name="modal">
		 
		 	<deactivate-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :layout="data.layout" 
			 	:deleteUrl="'/org/delete/user/'+data.id">

			</deactivate-modal>
		</transition>
		
	</div>

</template>

<script type="text/javascript">

	import {boolean} from '../../../../helpers/extraLogics'

    import DeactivateModal from "../Tickets/MiniComponents/DeactivateModal.vue";

	export default {
		
		name:"data-table-actions",

		description: "Contains edit, delete and view buttons as group which can be used as a component as whole. It is built basically for displaying edit, delete and view button in a datable.",		
		
		props: {
	
			data : { type : Object, required : true },

		
		},

		data(){
			return{
				
				showModal : false,

				disabled : ''
			}
		},

		created(){
			this.disabled = boolean(this.data.is_default)
		},

		watch : {
			data(newValue,oldValue){
				this.disabled = boolean(newValue.is_default) 
				return newValue
			}
		},
		
		methods:{

			showModalMethod(){
				if(this.data.is_default){
					if(boolean(this.data.is_default)){
					this.showModal = false
				} else {
						window.emitter.emit("cropModalChanged","");
					this.showModal = true
					}
				} else {
					window.emitter.emit("cropModalChanged","");
					this.showModal = true
				}
			},

			onClose(){
		        this.showModal = false;
		        this.$store.dispatch('unsetValidationError');
		    },
		},

		components:{
			'deactivate-modal' : DeactivateModal,
		}
	};

</script>

<style scoped>
	#client_actions_edit_btn {
		/* border: 1px solid #f2ebeb !important; */
	}
	#edit-button,#edit-modal-button {
		color: black !important;
	}
</style>