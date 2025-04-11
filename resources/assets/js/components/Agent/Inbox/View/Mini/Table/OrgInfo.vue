<template>

 <span class="inbox-info">

	 <popover hover arrow placement="right">
     <!-- display the organization name in details-->
		 <a :href="from.link" target="_blank" data-container="body" data-bs-toggle="popover" data-placement="right"
        :data-content="hoverContent">{{ from.name }}</a>

		 <template #content v-if="from">

			 <div class='card card-light card-widget mb-0 org-toolip'>

				 <div class='card-header pad-7'>

					 <div class="user-panel d-flex">

              <!--  logo provided  or default logo  if it's null-->
						 <div class="hover-img">

							<img :src="from.logo ? from.logo : basePathVersion()+'/themes/default/common/images/org.png'" class="img-fluid img-circle" id="org_img" alt="Org Image">
						 </div>

						 <div class="info">

							 <a class="d-block">

								 {{this.subString(from.name)}}
							 </a>
						 </div>
					 </div>
				 </div>

				 <div class='card-body info-body'>

					 <ul class='nav nav-stacked'>

						 <li id='b_bottom'>

							 <a id='cus-link' >
                 <!-- address of the organization-->
                 <i class="fas fa-map-marker-alt"></i>
                 &nbsp;<span v-html="from.tooltip ? from.tooltip : '---'"></span>
							 </a>
						 </li>
					 </ul>
				 </div>
			 </div>
		 </template>
	 </popover>

</span>

</template>

<script>

import { boolean,getSubStringValue } from "../../../../../../helpers/extraLogics";

export default{

  props : {

    from : { type : Object, default : ()=> {} },

  },

  computed:{

    hoverContent(){

      if(boolean(this.from)){

        return `
            <div class='card card-light card-widget mb-0 org-toolip'>

              <div class='card-header pad-7'>

              <div class="user-panel d-flex">

                <div>

                  <img src=${this.from.logo !== null ? this.from.logo : this.basePathVersion()+'/themes/default/common/images/org.png'} class="img-circle" id="org_img" alt="Org Image">
                </div>

                <div class="info">

                  <a class="d-block">
                    ${this.subString(this.from.name)}
                  </a>
                </div>
              </div>
              </div>

              <div class='card-body info-body'>

                <ul class='nav nav-stacked'>

                  <li id='b_bottom'>
                    <a id='cus-link'>

                        ${this.from.tootlip  ? this.from.tooltip : "---"}
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          `
      } else { return '' }
    }
  },

  methods:{

    // manages the text length of name
    subString(value,length = 25){

      return getSubStringValue(value,length)
    },
  }
};
</script>

<style scoped>
/*Globally required*/
.popover-body { padding : 0 !important; }

.pad-7 { padding: 7px !important; }

.info-body { padding: 15px !important; padding-left: 7px !important;}

.user-panel img {
  height: 2rem !important;
  width: 2rem !important;
}

.org-toolip{
  max-width: 300px;
}
</style>