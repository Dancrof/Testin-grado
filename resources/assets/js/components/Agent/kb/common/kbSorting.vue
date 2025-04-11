<template>

	<div class="btn-group">

	    <button type="button" class="btn btn-md btn-light dropdown-toggle sortval bg-white" data-bs-toggle="dropdown">
	      <i class="fas fa-sort"></i>&nbsp;
	    </button>
			
		<div class="dropdown-menu dropdown-menu-end kb-sort-dropdown">

			<template v-for="(sorting,index) in sortingMenu">
				
				<a class="dropdown-item" @click="sort(sorting,index)" href="javascript:;" id="sort">

					<i :class="sorting.class"> </i> {{trans(sorting.name)}}  {{trans(sorting.order_name)}}
				</a>
			</template>
		</div>
	</div>
</template>

<script>

	export default{

	props:{
    sortingMenu: {
      type: Array,
      required: true
    },
  },

	methods:{
	//sorting function
		sort(x,y){
      if (x.order == "asc") {

        this.$emit("sort", x);

        $(".sortval").html(
            this.trans(x.name) + " " + this.trans(x.order_name) + '&nbsp<span class="caret"></span>'
        );

        this.sortingMenu[y].order = "desc";

        this.sortingMenu[y].class = "fas fa-sort-amount-up";

        this.sortingMenu[y].order_name = this.trans("descending");

      } else {

        this.$emit("sort", x);

        $(".sortval").html(
            this.trans(x.name) + " " + this.trans(x.order_name) + '&nbsp<span class="caret"></span>'
        );

        this.sortingMenu[y].order = "asc";

        this.sortingMenu[y].class = "fas fa-sort-amount-down";

        this.sortingMenu[y].order_name = this.trans("ascending");
      }
		}
	}
};
</script>

<style scoped>
.rtl .dropdown-menu{
  right: inherit;
}
</style>