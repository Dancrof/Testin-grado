<template>
	
	<div class="select-all">

		<input type="checkbox" id="all" v-model="selectAll" class="cursor_pointer">
		
		<label for="all" class="maxi-lab"></label>
	</div> 
</template>

<script>
	
	export default {
		
		props : { 

			selected : { type : Array , default : ()=>[]},

			tickets : { type : Array , default : ()=>[]}
		},

		computed:{
			
			selectAll: {
				
				get() {
					
					if(this.tickets.length){
						
						return this.tickets ? this.selected.length == this.tickets.length : false;
					}
					else{
						
						return false;
					}
				},
				
				set(value) {

					if (value) {
						
						window.emitter.emit('selectTicket',value);
					}
					else{
						window.emitter.emit('selectTicket',false);
					}
				}
			},
		}
	};
</script>

<style scoped>
  
  .select-all{
    
    display: inline-block;
  }

  .cursor_pointer { cursor: pointer; }
</style>