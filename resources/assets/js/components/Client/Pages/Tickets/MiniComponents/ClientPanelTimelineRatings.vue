<template>
	
	<div :class="[(lang_locale === 'ar') ? 'float-start' : 'float-end']">
	
		<template v-if="getDefaultRatings">
	
			<table>
	
				<tbody>
            <tr>
              <td id="rating_align" class="star-rating-control">

                <div class="ticketratingtitle text-end mt-1"><b>{{ lang(all_ratings.name)  }}</b>&nbsp;&nbsp;</div>

                <star-rating v-model="all_ratings.rating_value" :star-size="18"
                     :show-rating="false" :max-rating="all_ratings.rating_scale"
							 @update:rating="setCurrentSelectedRating"
                     :read-only="readOnlyStar" :rating="all_ratings.rating_value"
                />

              </td>
            </tr>
				</tbody>
			</table>
		</template>

		<template>
			
			<div v-if="loading" class="row">

				<client-panel-loader :size="60" :color="layout.portal.client_header_color"></client-panel-loader>
			</div>
		</template>
	</div>
</template>
<script>

import { mapGetters } from 'vuex'

import {successHandler} from '../../../../../helpers/responseHandler'

	export default {

		props:{

			layout : {type : Object, default : ()=>{}},

			auth : {type : Object, default : ()=>{}},

			department : { type : String, default :''},

			ticketId : { type : [String, Number], default : ''},
			
			commentId : { type : [String, Number], default : ''},

			area : { type : String, default :''},

			from : { type : String, default : ''}

		},

		data() {
			return {

				matched_rating:{},

				rating_value:0,

				lang_locale : this.layout.language,

				all_ratings : '',

				default_ratings : '',

				loading : true,

				request_data : ''
			}
		},

		computed: { 

			...mapGetters(['getDefaultRatings']),

      readOnlyStar() {
        return !!this.all_ratings.rating_value;
      }
		},

		beforeMount(){
			
			this.$Progress.start();

			this.ratingTypes();
		},

		methods: {

      ratingTypes() {

        this.all_ratings = this.getDefaultRatings;

        this.$Progress.finish();

        this.loading = false;
      },

			setCurrentSelectedRating(rating) {
        this.$Progress.start();
        this.loading = true;

        let formObject = {
          user_id: this.auth.user_data.id,
          rating_id: this.all_ratings.rating_id,
          rating_value: rating,
          ticket_id: this.ticketId
        };

        // axios.post('api/add-rating',formObject).then((res)=>{
        //   successHandler(res,'statusBox')
        //   this.$Progress.finish();
        //   this.loading = false;
        // }).catch((error)=>{
        //   this.loading = false;
        //   this.$Progress.fail();
        // })
        axios.get('api/get-encrypted-rating/'+this.ticketId+'/'+rating).then((res)=>{
          successHandler(res)
          this.$Progress.finish();
          this.loading = false;
          this.redirect('/rating/'+res.data.encryptedRatingDetails)
        }).catch((error)=>{
          this.loading = false;
          this.$Progress.fail();
        })
			},
		}

	};
</script>

<style scoped>
.cancel{
	color: red;
	font-size: medium;
	margin-right: 3px;
	cursor: pointer;
	margin-top: 11px;
}
#rate{
	margin-bottom: 15px !important
}
#rating_align{
	display: inline-flex !important;
}
.comment-meta .cancel {
	margin-top: 5px !important;
}
.vue-star-rating{
	margin-top: -2px !important;
}
</style>
