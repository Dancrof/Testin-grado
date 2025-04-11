<template>
	
	<div class="sidebar-wrapper" id="scroll-bar" @scroll="handleScroll">
		
		<div class="user-panel mt-3 pb-3 d-flex">

			<div class="image">

				<faveo-image-element id="sidebar-profile-img" :source-url="profilePic" :classes="['rounded-circle brand-image']"
					alternative-text="User Image"/>
        </div>

        	<div class="info d-flex">

        		<router-link class="profile_name brand-text" v-if="from == 'agent'" to="/profile">{{subString(fullName)}}</router-link>

          	<a v-else class="d-block brand-text" :title="fullName" :href="basePath()+'/panel/profile'">{{subString(fullName)}}</a>
        </div>
		</div>

		<slot></slot>
	</div>
</template>

<script>

    import { getSubStringValue } from "../../helpers/extraLogics";

    export default {

		props : {

			auth : { type : Object, default : ()=> {}},

			from : { type : String, default : '' }
		},

      mounted() {
        const SELECTOR_SIDEBAR_WRAPPER = ".sidebar-wrapper";
        const Default = {
          scrollbarTheme: "os-theme-light",
          scrollbarAutoHide: "leave",
          scrollbarClickScroll: true,
        };
        const sidebarWrapper = this.$el.querySelector(SELECTOR_SIDEBAR_WRAPPER);
        if (
            sidebarWrapper &&
            typeof OverlayScrollbarsGlobal?.OverlayScrollbars !== "undefined"
        ) {
          OverlayScrollbarsGlobal.OverlayScrollbars(sidebarWrapper, {
            scrollbars: {
              theme: Default.scrollbarTheme,
              autoHide: Default.scrollbarAutoHide,
              clickScroll: Default.scrollbarClickScroll,
            },
          });
        }
      },

		computed : {
			
			sidebarStyle(){
				
				if(this.isRtlLayout){
					
					return {'margin-right': '-8px'}
				}
					
					return {'margin-left': '-8px'}
			},

			fullName(){
				
				return this.auth.user_data.full_name;
			},

        	profilePic(){
            return this.auth.user_data.profile_pic;
        	}
    	},

		methods : {

			subString(value){

				return getSubStringValue(value,20)
			},
		},
	};
</script>

<style scoped>
	.profile_name { background-color: unset !important; }

	#sidebar-profile-img { height: 2.1rem !important;}

  .user-panel{
    border-bottom: 1px solid #4f5962;
  }

  .user-panel .image{
    display: inline-block;
    padding-left: .8rem;
  }
</style>