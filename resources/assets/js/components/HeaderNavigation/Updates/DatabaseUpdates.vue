<template>
	
		<div class="lockscreen-wrapper">

  			<div class="card">
             
             <div class="card-header">
  					
  					<h3 class="card-title fs_title">Database Update Required</h3>           	
             </div>
             
             <div class="card-body box-profile">
  
                <span>
        
                	File system has been updated but your database is still on the older version! Before we send you on your way, we have to update your database to the latest version.

                	<br><br>
                	The update process may take a little while, so please be patient. We will redirect you back once your database updation is complete.
                </span>
            </div>

            <div class="card-footer bg-white text-center border-0">
              <div class="d-grid">
                <button class="btn btn-primary btn-block" :class="loading ? 'rotating' : ''" @click="onClick" :disabled="isDisabled">

                  <i class="fas fa-sync"> </i> Click here to update Database
                </button>
              </div>
            </div>
         </div>
  		</div>
</template>

<script>

	import axios from 'axios'

	export default {

		name : 'database-updates',

		data () {

			return {

				loading : false,

				isDisabled : false
			}
		},

		methods : {

			onClick() {

				this.loading = true;

				this.isDisabled = true;

				axios.post('/update-database').then(res=>{

					this.loading = false;

					this.redirect('/auth/login');

				}).catch(err=>{

					this.loading = false;

					this.isDisabled = false;

					this.redirect('/')
				})
			}
		},
	};
</script>

<style scoped>
	
	.w_100 {
		width: 200px;
    	height: 120px;
    	object-fit: contain;
    	object-position: 50% 50%;
	}

	.fs_title { font-size: 1.3rem !important; }

	.lockscreen-logo {
		margin-bottom: 15px !important;
	}

	.lockscreen-wrapper { margin-top: 15% !important; }

  @keyframes rotate {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }
  /* Apply the rotation animation when the button has a class of "rotating" */
  .rotating i {
    animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
  }

  .lockscreen {
    background-color: #e9ecef;
  }
</style>