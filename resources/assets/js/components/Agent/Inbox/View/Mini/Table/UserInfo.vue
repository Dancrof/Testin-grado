<template>

 <span class="inbox-info">

	 <popover hover arrow placement="top">

		 <router-link class="user_name pop" :to="showUser(from)" data-container="body" data-toggle="popover" data-placement="right"
			  :data-content="hoverContent" target="_blank">

			 <span class="emphasize"> {{ subString(fullName, strLen) }}

			  	<span>{{ subString(getUserName, strLen) }}</span>
			 </span>
		 </router-link>

		 <template #content v-if="from">

			 <div class='card card-light card-widget'>

				 <div class='card-header pad-7'>

					 <div class="user-panel d-flex">
             <div class="hover-img">
          <img v-if="from.profile_pic" :src="from.profile_pic" class="img-circle imgupdate img-rounder" alt="User Image">

          <img v-else src="https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png" class="img-circle img-rounder" alt="Image">

             </div>

						 <div class="info">

							 <a class="d-block font-weight-bold font-size-14">

								 {{from.first_name != '' ? subString(from.first_name+" "+from.last_name) : subString(from.user_name)}}
							 </a>
						 </div>
					 </div>
				 </div>

				 <div class='card-body info-body'>

					 <ul class='nav nav-stacked'>

						 <li id='b_bottom'>

							 <a id='cus-link' :title=from.email >

								 <i class='fas fa-envelope'></i>&nbsp;
								 <span class="pr_1">{{from.email ? subString(from.email) : "---"}}</span>
							 </a>
               <br>
                <a v-if="this.from.mobile || this.from.phone_number" id='cus-link mt-1' :title=from.mobile>

								 <i class='fas fa-phone me-1'></i>&nbsp;{{from.mobile ? "+"+from.country_code+" "+subString(from.mobile) : "---"}}
							 </a>
						 </li>
					 </ul>
				 </div>
			 </div>
		 </template>
	 </popover>

  <span v-if="isUnassigned" style="color: red">{{lang('unassigned')}}</span>
</span>

</template>

<script>
  
  import { boolean,getSubStringValue } from "../../../../../../helpers/extraLogics";

  export default{
    
    props : {

      from : { type : Object, default : ()=> {} },

      tableHeader : { type : String, default : '' },

	    strLen : { type : Number, default : 25 }

    },

    computed:{
      
      fullName() {
        
        return boolean(this.from) ? `${this.from.first_name} ${this.from.last_name}` : '';
      },
      
      getUserName() {
        
        return (boolean(this.from) && (this.from.first_name=='' || this.from.first_name==null) && this.from.user_name) ? this.from.user_name : '';
      },
      
      isUnassigned() {
        
        return (this.fullName === '' && this.getUserName === ''); 
      },
      
      hoverContent(){

        if(boolean(this.from)){

          return `
            <div class='card card-light card-widget mb-0'>

              <div class='card-header pad-7'>

              <div class="user-panel d-flex">
                
                <div>

                  <img src=${this.from.profile_pic} class="img-circle" alt="User Image">
                </div>
                
                <div class="info">
                  
                  <a class="d-block">
                    ${this.from.first_name !== '' ?  this.subString(this.from.first_name+" "+this.from.last_name) : this.subString(this.from.user_name)}
                  </a>
                </div>
              </div>
              </div>

              <div class='card-body info-body'>

                <ul class='nav nav-stacked'>

                  <li id='b_bottom'>
                    <a id='cus-link' title=${this.from.email} >

                      <i class='fas fa-envelope'></i>&nbsp;
                        ${this.from.email  ? this.subString(this.from.email) : "---"}
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

      subString(value,length = 25){
        // to set the length different for the email and name Data
        return getSubStringValue(value,value.includes('@') ?length = 50: length)
      },
      
      //show user page
      showUser(x){
        
        return boolean(x) ? '/user/'+x.id : '';
      }
    }
  };
</script>

<style scoped>
  /*Globally required*/
  .popover-body { padding : 0 !important; }

  .pad-7 { padding: 7px !important; }

  .info-body { padding: 15px !important; padding-left: 7px !important;}
  .fa-envelope{margin-right: 4px!important;}
  .imgupdate{border: 2px solid #3788d8; height: 32px!important;}

  .row>span {
    width: auto;
  }

  .card-widget{
    margin-bottom: 0 !important;
  }
</style>