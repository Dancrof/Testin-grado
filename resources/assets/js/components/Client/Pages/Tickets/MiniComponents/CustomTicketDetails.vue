<template>

	<div class="row mt-4" :class="{align1: lang_locale == 'ar'}" style="min-height: 100px;">

		<template v-for="customField in ticket.custom_field_values">

			<div v-if="boolean(customField.value)" class="col-sm-6 custom_tic_detail">

				<div class="row">

					<div class="col-sm-6" v-if="customField.label.length > 25" v-tooltip="customField.label">

            <b>{{ subString(customField.label, 25)}}</b>
          </div>

					<div class="col-sm-6" v-else><b>{{customField.label}}</b></div>

					<div class="col-sm-6">

						<ul class="style-ul" v-if="Array.isArray(customField.value)">

							<li v-for="(value, index) in customField.value">

								<span v-tooltip="value">{{subString(value,20)}}&nbsp;</span>
							</li>
						</ul>

						<template v-else>

					<span v-if="customField.field_type === 'date'" v-tooltip="customField.value">
						{{ customField.value }}
					</span>

							<span v-else v-tooltip="customField.value">{{ subString(customField.value,25) }}</span>
						</template>
					</div>
				</div>
			</div>
		</template>

		<div v-if="ticket.custom_field_values.length % 2 !== 0" class="col-sm-6 custom_tic_detail"></div>

		<template v-if="loading">

			<loader :color="layout.portal.client_header_color" :animation-duration="4000" :size="60"/>
		</template>
	</div>
</template>

<script>

import { mapGetters } from 'vuex';

import { getSubStringValue } from '../../../../../helpers/extraLogics'
import Loader from "../../../ClientPanelLayoutComponents/ReusableComponents/Loader.vue";

export default {

	name : 'custom-ticket-details',

	description : 'Custom Ticket deatils page',

	props : {

		layout : { type : Object, default : ()=>{}},

		auth : { type : Object, default : ()=>{}},

		ticket : { type : Object, default : ()=>{}}
	},

	data(){

		return {

			loading : false,

			lang_locale : this.layout.language
		}
	},

	computed: {

		...mapGetters(['formattedTime','formattedDate'])
	},

	methods : {

		subString(value,length = 25){

			return getSubStringValue(value,length)
		},
	},

	components :{

		'client-panel-loader' : Loader
	}

};

</script>

<style scoped>

.content {

	margin-top: 5px !important
}
.custom_tic_detail {
	padding: 15px;
	border-top: 1px solid #dddddd;
}

.style-ul{
  margin-left: -24px;
}

</style>
