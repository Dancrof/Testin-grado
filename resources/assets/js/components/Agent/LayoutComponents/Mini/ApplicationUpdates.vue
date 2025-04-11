<template>

	<li v-if="updatesCount > 0" class="nav-item dropdown">
			<a class="nav-link font-1" data-bs-toggle="dropdown" href="javascript:;"
				v-tooltip="trans('application_updates')">
				<div>
					<i class="fas fa-sync-alt"></i>
					<div class="indicator"  v-if="updatesCount > 0" :style="{'border-color':indicatorBackground}"></div>
				</div>
			</a>
		<div class="dropdown-menu dropdown-menu-lg dropdown-menu-end">
			<span v-if="!updatesCount" class="dropdown-header">You have {{updatesCount}} update(s)</span>

			<template  v-if="updatesCount" >

				<span class="dropdown-header">New version(s) available.</span>

				<div class="dropdown-divider"></div>

				<a href="javascript:;" class="dropdown-item">

					<template v-if="callingFrom == 'admin'">

						Please <router-link to="/check-updates"> click here </router-link> to update your system.
					</template>

					<template v-else>

						Please <a :href="basePath()+'/admin/check-updates'"> click here </a> to update your system.
					</template>
				</a>
			</template>
		</div>
	</li>
</template>

<script>
	
	export default {

		name : 'system-updates',

		props : {

			callingFrom : { type : String, default : '' },
			headerBackground: {type: String, default : '' }
		},

		data() {

			return {
				updatesCount : '',
				backgroundColors : {
					"navbar-light" : "#f8f9fa",
					"navbar-dark navbar-blue" : "#3c8dbc",
					"navbar-dark navbar-black": "#343a40",
					"navbar-dark navbar-green" : "#28a745",
					"navbar-dark navbar-purple" : "#6f42c1",
					"navbar-dark navbar-red" : "#dc3545",
					"navbar-light navbar-yellow": "#ffc107",
					"navbar-light navbar-orange": "#fd7e14",
				},
				indicatorBackground : "#FFF"
			}
		},

		beforeMount(){
			this.indicatorBackground = this.backgroundColors[this.headerBackground]
			this.getUpdate();
		},

		methods : {

			getUpdate(){

				this.loading = true;

				axios.get('/auto-update/notification').then(res=>{

					this.loading = false;

					this.updatesCount = res.data.data.count;
				
				}).catch(err=>{

					this.loading = false;

					this.updatesCount = 0;
				})
			}
		}
	};
</script>

<style scoped>
	
	.navbar-badge { padding : 1px 4px !important; }
	.indicator {
		position: absolute;
		top: 21%;
		right: 20%;
		left: 50%;
		bottom: 36%;
		background-color: #03f4fc;
		border: 3px solid;
		border-radius: 50%;
	}
</style>