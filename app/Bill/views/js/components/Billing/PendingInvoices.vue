<template>

	<router-link v-if="pending" id="pending-invoices" class="nav-link font-1" to="/billing/invoices?status=0">
          <span v-tooltip="trans('invoices')">
  <i class="far fa-file-pdf"></i>
</span>
    	<span  class="badge text-bg-danger navbar-badge" style="position: relative; top: -7px; left: -3px; font-weight: bold">{{pending}}</span>
  	</router-link>
</template>

<script>
	
	export default {

		name : 'pending-invoices',

		data() {

			return {
        pending : '',

      }
		},

		beforeMount() {

			this.getCount()
		},

		methods : {

			getCount() {

				axios.get('/bill/package/get-user-invoice?meta=true&all-users=1&status=0').then(res=> {

          		this.pending = res.data.data.total;

        		}).catch(err=>{

          		this.pending = 0;
        		})
			}
		}
	};
</script>
<style >
	
	.navbar-badge { padding : 1px 4px !important;
		background-color:greenyellow !important;
	}


</style>