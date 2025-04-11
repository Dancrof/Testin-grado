<template>
	
	<div class="btn-group" id="ticket-count">
		
		<button type="button" class="btn btn-md btn-light dropdown-toggle" data-bs-toggle="dropdown">
			{{perpage}}
		</button>
		
		<div class="dropdown-menu dropdown-menu-left">
				
			<template v-for="count in ticketCounts">
				
				<a class="dropdown-item" @click="changeCount(count)" href="javascript:;">{{count}}</a>
			</template>
		</div>
	</div>
</template>
<script>

	export default{

		props : {

			tableHeader : { type : String, default : ''},

			perpage : { type : [Number,String], default : ''}
		},

		data(){
			
			return{
				
				buttonStyle : { 'background-color':this.tableHeader + ' !important','color':'#fff' },
				
				ticketCounts:[10,25,50,100],
			}
		},

		methods:{

			changeCount(x){

				this.$emit('ticketCount', x);
			}
		}
	};
</script>

<style scoped>
	
/*	#ticket-count{

		margin: 2px;
	}

	.mleft2{ margin-left: 2px; }*/
</style>