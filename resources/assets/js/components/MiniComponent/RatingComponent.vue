<template>

	<div class="row">
		
		<div class="col-md-12">

			<div :class="[classname, {left1: lang_locale == 'ar'}]" class="ticketratings" id="ticketratings"> &nbsp;

				<table>

					<tbody>

						<tr>
							<th class="cursor-default"><div class="ticketratingtitle" :style="labelStyle">{{ lang(rating.name) }}&nbsp;</div></th>

							<td  class="star-rating-control">

               <star-rating v-model="all_ratings.rating_value" :star-size="18" :read-only="readOnlyStar"
                     :show-rating="false" :max-rating="all_ratings.rating_scale"
                      :rating="all_ratings.rating_value"
                />

<!--								<div id="star-rating">-->

<!--									<star-rating v-tooltip.top="toolTipMessage" :rating="rating.rating_value" :star-size="18" :show-rating="false" :max-rating="rating.rating_scale"-->
<!--									:read-only="true"></star-rating>-->

<!--								</div>-->
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</template>
<script>

import RatingPopOver from "./RatingPopOver.vue";

import {useStore} from 'vuex'
import {computed} from "vue";

	export default {
    components: {
      RatingPopOver
    },


		setup() {

			const store = useStore();

			return {

				getDefaultRatings : computed(()=>store.getters.getDefaultRatings),

				getRatingTypes : computed(()=>store.getters.getRatingTypes)
			}
		},

    props:{

			/**
			 * rating data
			 * @type {Object}
			 */
			rating : {type : Object},

			ratings : {type : Array},

			labelStyle : { type : Object, default : ()=> {} },

			classname : { type : String, default : '' },

	    readOnlyStar : { type : Boolean, default : false }

		},

		data() {
			return {
				/**
				 * getting matched rating with props data
				 * @type {Object}
				 */
				matched_rating:{},

				/**
				 * rating value
				 * @type {Number}
				 */
				rating_value:0,

				/**
				 * locale of the user
				 * @type {String}
				 */
				lang_locale:'',

				all_ratings : '',

			}
		},

		watch:{
			// getting updated values using watch function
			rating(newValue,oldValue) {

				return newValue;
			},

		},

		computed: {
      toolTipMessage() {
        if (!this.rating.questions) {
          return '';
        }

        return {
          content: this.rating.questions,
          html: true,
          classes: ['star-rating-tooltip'],
          // targetClasses: ['it-has-a-tooltip'],
          // offset: 100,
          delay: {
            show: 500,
            hide: 300,
          },
        }
      }

		},

		created() {
			// locale of the user
			this.lang_locale = localStorage.getItem('LANGUAGE');

      // |||||||||||||||||||||||[ Important ]||||||||||||||||||||||||||||||
      // |||||||||||||||||||||||[ Notice ]||||||||||||||||||||||||||||||
      // Commented below code because from now onwards system has only one default rating at a time, which will be
      // passed as a prop; keeping the commented code for legacy purposes

			// matching rating value with system ratings to getting values
			// if(this.rating !== undefined){
      //
			// 	this.rating_value = this.rating.rating_value
      //
			// 	this.matched_rating = findObjectByKey(this.getRatingTypes, 'id',this.rating.id);
      //
			// }

		},

		beforeMount(){
			

			this.ratingTypes();
		},

		methods: {
			ratingTypes() {
        this.all_ratings = this.getDefaultRatings;
        this.loading = false;
      },
		}

	};
</script>

<style lang="scss">

#ticketratings{
	float: right;
  margin-top: -15px;
  cursor: pointer;
}

.ticketratingtitle { font-weight: 400 !important; }

.lh-1{ line-height: 1 !important; }

.popover {
  $color: #f9f9f9;

  .popover-inner {
    background: $color;
    color: black;
    padding: 0;
    border-radius: 5px;
    box-shadow: 0 5px 30px rgba(black, .1);
  }

  .popover-arrow {
    border-color: lightslategray;
  }
}

.vue-star-rating { cursor: default !important;}

.cursor-default{
  cursor: default;
}

</style>
