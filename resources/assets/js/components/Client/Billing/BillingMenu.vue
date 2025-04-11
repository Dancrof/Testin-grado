<template>
	
	<li class="nav-item dropdown" :class="[{'active': subIsActive('billing')},{float: language == 'ar'}]">
					
		<a class="dropdown-toggle nav-link"  id="navbarDropdownBill" role="button" 
			data-bs-toggle="" aria-haspopup="true" aria-expanded="false" :class="{'active': subIsActive('billing')}">{{lang('billing')}}
		</a>

		<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" :class="{nav_dropdown : language == 'ar'}" id="bill_nav_dropdown">
						
			<li>
						
				<router-link class="dropdown-item" to="/billing-package-list" :class="{align: language == 'ar'}" id="bill_purchase">
					{{ lang('purchage') }}
				</router-link>
			</li>
						
			<li v-if="!Array.isArray(auth.user_data)"> 

				<router-link class="dropdown-item" to="/billing-user-packages" :class="{align: language == 'ar'}" id="bill_packages">
					{{lang('my_packages')}}
				</router-link>
			</li>
				
			<li v-if="!Array.isArray(auth.user_data)">
							
				<router-link class="dropdown-item" to="/billing-user-invoices" :class="{align: language == 'ar'}" id="bill_invoices">
					{{ lang('my_invoices') }}
				</router-link>
			</li>
		</ul>
	</li>
</template>

<script type="text/javascript">

	export default {

		props:{

			layout : { type : Object, default : ()=>{}},

			auth : { type : Object, default : ()=>{}},

			language : { type : String, default : ''},
		},

		methods : {

			subIsActive(input) {
		   	
		   	if(input === 'billing'){

		   		let page_path = this.$route.path.split('/');
		   		
		  		return page_path[page_path.length - 1].includes(input) 		
		   	
		   	} 
		  },
		}
	};
</script>

<style scoped>
	.sub-menu:hover{
		display:block !important;
	}
	#biling:hover ~ .sub-menu {
		display: block !important;
	}
	#bill_purchase, #bill_packages, #bill_invoices { background: unset !important; }
</style>