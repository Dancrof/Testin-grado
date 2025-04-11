<template>

	<div class="btn-group">

		<button type="button" class="btn btn-md btn-light dropdown-toggle sortval bg-white" data-bs-toggle="dropdown">
			{{ticketPer}}
		</button>

		<div class="dropdown-menu dropdown-menu-right kb-sort-dropdown">

			<template v-for="limit in limitMenu">

				<a class="dropdown-item" @click="onLimit(limit)" href="javascript:;" id="limit">

					{{limit.value}}
				</a>
			</template>
		</div>
	</div>
</template>
<script>
	export default{

		props:['ticketper'],

		data(){

			return{

				ticketPer:this.ticketper,

				limitMenu: [
					{ value: 10 },
					{ value: 25 },
					{ value: 50 },
					{ value: 100 }
				]
			}
		},

		methods:{

			onLimit(x){

				this.ticketPer = x.value;

				this.$emit('message', x.value);
			}
		}
	}
</script>