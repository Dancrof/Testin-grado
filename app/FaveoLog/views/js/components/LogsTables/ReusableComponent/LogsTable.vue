<template>

	<div class="col-md-12">

		<data-table id="logs_table" v-if="apiEndpoint" :url="apiEndpoint" :dataColumns="columns"  :option="options"
			:scroll_to ="id" :componentTitle="componentTitle"/>			
	</div>
</template>

<script>
	
	export default {

		props : {

			columns : { type : Array, default : ()=> [] },

			options : { type : Object, default : ()=> {} },

			apiUrl :  { type : String, default : '' },

			id : { type : String , default : ''},

			componentTitle: { type: String, default: '' },

			sender_mails : { type : Array, default : ()=>[] },

			reciever_mails : { type : Array, default : ()=>[] },
		},

		data(){
			return {
				apiEndpoint : this.apiUrl+'&sender_mails='+this.sender_mails+ '&reciever_mails='+this.reciever_mails
			}
		},

		watch : {

			sender_mails(newValue,oldValue){

				let r_mails = this.reciever_mails.map(a => a.email);

				let result = newValue.map(a => a.email);

				this.apiEndpoint = this.apiUrl+'&sender_mails='+result+'&reciever_mails='+r_mails;

				return newValue
			},

			reciever_mails(newValue,oldValue){

				let s_mails = this.sender_mails.map(a => a.email);

				let result = newValue.map(a => a.email);

				this.apiEndpoint = this.apiUrl+'&sender_mails='+s_mails+'&reciever_mails='+result;

				return newValue
			},

			apiEndpoint(newValue,oldValue){
				return newValue
			}
		}
	};
</script>

<style scoped>
		.pad{
			border-top: 1px solid #efefef;
    	padding: 8px;
		}
		#logs_table{
			padding-bottom: 60px
		}
</style>