<template>

	<li class="nav-item dropdown">
		
		<a class="nav-link" data-bs-toggle="dropdown" href="javascript:;">
			
			<img :src="basePathVersion()+'/themes/default/common/images/flags/'+language+'.png'" />

		</a>
		
		<div class="dropdown-menu dropdown-menu-sm dropdown-menu-end p-0" id="lang_div">
			
			<template v-for="language in langSorted">
				
				<a href="javascript:;" class="dropdown-item" @click="changeLang(language.locale)">
				
					<img :src="basePathVersion()+'/themes/default/common/images/flags/'+language.locale+'.png'" class="me-2" />

					&nbsp; {{ language.name }} &nbsp;&rlm;({{ language.translation }})&rlm;
				</a>
			</template>

			<template v-if="loading">
						
				<div class="row" id="load">
							
					<reuse-loader :animation-duration="4000" :size="30"/>
				</div>
			</template>
		</div>
	</li>
</template>

<script type="text/javascript">
	
	export default {

		name : 'language-dropdown',

		description : 'Language  dropdown component',

		props : {

			language : { type : String, default : 'en'}
		},

		data(){

			return {

				loading : false,

				languages : ''
			}
		},

		watch : {

		},

		computed : {

			langSorted() {
				
				return _.orderBy(this.languages, 'name', 'asc');
			},
		},

		beforeMount(){

			this.getLanguages();
		},

		methods : {

			getLanguages(){

				this.loading = true;

				axios.get('api/dependency/languages?meta=true').then(response => {
					
					this.loading = false;

					this.languages=response.data.data.languages;

					this.$store.dispatch('setAllLangs',this.languages)
					
				}).catch(error=>{

					this.loading = false;
				});
			},

			changeLang(locale) {

				axios.post('api/user-language?locale='+locale).then(res=>{
				
					window.location.reload();
				})
			},
		}
	};
</script>

<style scoped>
	
	.lang{
		cursor: pointer;
	}

	#load{
		margin-top:10px;margin-bottom:10px
	}

	#lang_div{
		width: 290px;
	}
</style>