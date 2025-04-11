<template>
	
	<div class="btn-group" id="ticket-sort">
		
		<button type="button" class="btn btn-md btn-light dropdown-toggle sortval" data-bs-toggle="dropdown">
			<i class="fas fa-sort"></i>&nbsp;
		</button>
		
		<div class="dropdown-menu dropdown-menu-left" style="">
				
			<template v-for="(sorting,index) in sortingMenu">
				
				<a class="dropdown-item" @click="sort(sorting,index)" href="javascript:;">
					
					<i :class="sorting.class"> </i> {{trans(sorting.name)}}  {{trans(sorting.order_name)}}
				</a>
			</template>

<!--			<template v-for="sorting in extraMenu">-->

<!--				<a class="dropdown-item" @click="filter(sorting)" href="javascript:;">-->

<!--					<i :class="sorting.class"> </i> {{trans(sorting.name)}}-->
<!--				</a>-->
<!--			</template>-->
		</div>
	</div>
</template>

<script>
	
	export default {
	
	props : {

		tableHeader : { type : String, default : ''},

    sortPreferences : { type: Object, default: () => {} }
	},

	data() {
		
		return {

			buttonStyle : { 'background-color':this.tableHeader + ' !important','color':'#fff', 'margin-top' : '2px' },

			// extraMenu : [
      //
			// 	{
			// 		name: "all",
			// 		value: '',
			// 		class: "fas fa-list-ul",
			// 	}
			// ],

			sortingMenu: [
				{
					name: "ticket_number",
					value: "ticket_number",
					order: "asc",
					class: "fas fa-sort-amount-down",
					order_name: "ascending"
				},
				{
					name: "updated_date",
					value: "updated_at",
					order: "asc",
					class: "fas fa-sort-amount-down",
					order_name: "ascending"
				},
				{
					name: "created_date",
					value: "created_at",
					order: "asc",
					class: "fas fa-sort-amount-down",
					order_name: "ascending"
				},
        {
          name: "answered",
          value: "isanswered",
          order: "desc",
          class: "fas fa-check"
        },
        {
          name: "un_answered",
          value: "isanswered",
          order: "asc",
          class: "fas fa-times",
        },
			],
		};
	},

  mounted() {

    this.sortPref();
  },

  watch : {
    sortPreferences() {
      this.sortPref();
    }
  },

	methods: {

		filter(value) {

			this.$emit("filter", value);

			$(".sortval").html(
          this.trans(value.name) + " " + this.trans('tickets')  + '&nbsp<span class="caret"></span>'
      );
		},

		sort(x, y) {

      if (x.value == "isanswered") {

        this.$emit("sort", x);

        $(".sortval").html(
           this.trans(x.name) + " " + this.trans('tickets')  + '&nbsp<span class="caret"></span>'
        );
      }

      else if (x.order == "asc") {
		
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
		},

    sortPref() {

      //This function is added to show the saved preference on mounting of this component and show whatever value is coming from DB
      // like e.g. from backend res is coming as sort_preferences:{'sort_field': 'created_at', 'sort_order':'asc'}
      //then we can check from sortingMenu object and get the name, icon, etc. info
      const sortObj = this.sortPreferences;

      if (sortObj.sort_field === "isanswered") {

        if(sortObj.sort_order === 'asc') {

          $(".sortval").html(
              this.trans('un_answered') + " " + this.trans('tickets')  + '&nbsp<span class="caret"></span>'
          );

        } else {

          $(".sortval").html(
              this.trans('answered') + " " + this.trans('tickets')  + '&nbsp<span class="caret"></span>'
          );
        }
      }

      else if (sortObj.sort_order === "asc") {

        this.sortingMenu.forEach(sortMen => {

          if(sortMen.value === sortObj.sort_field) {

            $(".sortval").html(
                this.trans(sortMen.name) + " " + this.trans('ascending') + '&nbsp<span class="caret"></span>'
            );

            sortMen.order = "desc";

            sortMen.class = "fas fa-sort-amount-up";

            sortMen.order_name = this.trans("descending");
          }

        });

      } else {

        this.sortingMenu.forEach(sortMen => {

          if(sortMen.value === sortObj.sort_field) {

            $(".sortval").html(
                this.trans(sortMen.name) + " " + this.trans('descending') + '&nbsp<span class="caret"></span>'
            );

            sortMen.order = "asc";

            sortMen.class = "fas fa-sort-amount-down";

            sortMen.order_name = this.trans("ascending");
          }

        })
      }
    },
	}
};

</script>