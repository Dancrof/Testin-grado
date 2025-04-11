<template>

<transition name="page" mode="out-in">
	
	<span v-if="route=='/mytickets'">
	
		<a @click="storePath(route)" :class="classname" href="javascript:;" :id="'client_widget_'+classname"
			:style="{ 'background-image': 'url(' + imageUrl +  'news.png' +'  )', 'color' : link_color }">	
			
			{{ label }}
		</a>
	</span>

	<span v-else>

		<router-link :to="route" :class="classname"  :id="'client_widget_'+classname"
			:style="{ 'background-image': 'url(' + imageUrl + classname + '.png' +'  )', 'color' : link_color }">
			
			{{ label }}
		</router-link>
	</span>
</transition>
</template>

<script>
	
	export default {
	
		props:{
	
			route:{type:String,required:true},
	
			classname:{type:String},
	
			label:{type:String,required:true},

			layout : { type : Object , default : ()=>{}},

			auth : { type : Object , default : ()=>{}}
		},

		data() {
			
			return {
			
				imageUrl : '',
 
				base : this.auth.system_url,

				link_color : this.layout.portal.client_header_color,
				
				token:null
			}
		},

    beforeMount() {

      this.imageUrl = this.layout.cdn ? 'https://hermescdn.co.in'+'/'+ this.appVersion +'/themes/default/client/images/' : this.auth.system_url +'/'+ this.appVersion + '/themes/default/client/images/';
    },

    methods:{
		
			storePath(x){

				if(!Array.isArray(this.auth.user_data)){
					
					this.$router.replace({ name: "MyTickets"}).catch(()=>{});
				} else {
					
					localStorage.setItem('redirectPath',x);
					
					this.$router.replace({ name: "Login"}).catch(()=>{});
				}
			}
		}
	};
</script>

<style scoped>

</style>