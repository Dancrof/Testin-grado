<template>

	<div class="card card-light card-outline">

		<template v-if="loading || !orgData">

			<div class="row">

				<reuse-loader :animation-duration="4000" :size="40"/>
			</div>
		</template>

		<template v-if="orgData && !loading">

			<div class="card-body box-profile">

				<div class="text-center">

					<faveo-image-element id="org_img" :source-url="orgImage" :classes="['profile-user-img img-fluid img-rounder img-circle']"
															 alternative-text="Org Image"/>

				</div>

				<h3 class="profile-username text-center" v-tooltip="orgData.name">{{subString(orgData.name,20)}}</h3>

				<p class="text-muted text-center">{{trans('organisation')}}</p>

        <div class="d-grid">

          <router-link :to="'/organizations/'+orgData.id+'/edit'" class="btn btn-primary btn-block" v-tooltip="trans('edit')">

            <i class="fas fa-edit"> </i> {{trans('edit')}}
          </router-link>
        </div>

				<ul class="list-group list-group-unbordered mb-3">

					<li class="list-group-item">

						<label>{{trans('domain')}}</label>

						<a class="float-end"  v-tooltip="orgData.domain">{{subString(orgData.domain ? orgData.domain : '---',20)}}</a>
					</li>

					<li class="list-group-item">

						<label>{{trans('address')}}</label>

						<a class="float-end"  v-tooltip="orgData.address">{{subString(orgData.address ? orgData.address : '---',30)}}</a>
					</li>

					<li class="list-group-item">

						<label>{{trans('phone')}}</label>

						<a class="float-end"  v-tooltip="orgData.phone">{{subString(orgData.phone ? orgData.phone : '---',20)}}</a>
					</li>

					<li v-if="orgData.ext" class="list-group-item">

						<label>{{trans('ext')}}</label>

						<a class="float-end"  v-tooltip="orgData.phone">{{subString(orgData.ext,20)}}</a>
					</li>

					<li v-if="editVisibilty" class="list-group-item">

						<b>{{trans('labels')}}</b>
						<div class="float-end">

							<template v-for="(label,index) in orgData.labels">

								<a  target="_blank" v-tooltip="{content: loadLabel(label.title), html: true }" class="badge me-1" :style="{'backgroundColor' : label.color, 'color': '#FFF'}">
								<span v-html="subString(loadLabel(label.title))"></span>
								</a>
							</template>
						</div>
					</li>

					<li class="list-group-item">

						<label>{{trans('description')}}</label>

						<a class="float-end"  v-tooltip="orgData.internal_notes">

							{{subString(orgData.internal_notes ? orgData.internal_notes : '---',30)}}
						</a>
					</li>

          <li class="list-group-item" v-for="value in orgData.custom_field_values">
            <label>{{value.label}}</label>

            <template v-if="Array.isArray(value.value)">
              <div class="float-end cursor-pointer">
                <template v-for="(item, index) in value.value">
                  <a v-tooltip="tooltipText(item, 30)">{{ subString(item, 30) }}</a>
                  <span style="color: #3c8dbc" v-if="index !== value.value.length - 1">, </span>
                </template>
              </div>
            </template>

            <a v-else class="float-end cursor-pointer" v-tooltip="value.value">{{ subString(value.value, 30) }}</a>
          </li>


        </ul>

        <div class="d-grid">

          <a href="javascript:;" class="btn btn-primary btn-block" @click="showModal = true">

            <i class="glyphicon glyphicon-plus"> </i> {{trans('add_manager')}}
          </a>
        </div>
			</div>
		</template>

		<transition name="modal">

			<org-manager-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :orgId="orgData.id"
												 :managerList="managerList">

			</org-manager-modal>
		</transition>
	</div>
</template>

<script>

import {getSubStringValue, renderLabelWithEmoji} from "../../../../helpers/extraLogics";

import {useStore} from 'vuex'
import {computed} from "vue";
import OrgManagerModal from "./MiniComponents/OrgManagerModal.vue";

export default{

	setup() {

		const store = useStore();

		return {

			formattedTime : computed(()=>store.getters.formattedTime),

			formattedDate : computed(()=>store.getters.formattedDate)
		}
	},

	props : {

		data: { type: [Object, String], default: '' },

    orgData:{type: [Object, String, Number], default: ''},

    managerList : { type : Array, default : ()=>[] },
	},

	data(){

		return {

			showModal : false,

			loading : false,

			labels: '',

			orgImage : '',

			editVisibilty : false ,
		}
	},

	beforeMount(){

		if(this.orgData.label_field && this.orgData.label_field.length >0){
			this.editVisibilty = this.orgData.label_field[0].display_for_agent;
		}

		this.orgImage = this.orgData.logo ? this.orgData.logo :
				this.basePathVersion()+'/themes/default/common/images/org.png';
	},

	methods : {

		subString(name,length = 15){

			return getSubStringValue(name,length)
		},

		onClose(){

			this.showModal = false;

			this.$store.dispatch('unsetValidationError');
		},

    tooltipText(label, content) {
      return label.length > content ? label : '';
    },

    loadLabel(label) {
      // Processes the given label to include emojis.
      return renderLabelWithEmoji(label);
    }
	},

	components : {

		'org-manager-modal' : OrgManagerModal
	}
};
</script>

<style scoped>
#org_img { height : 100px !important; }
</style>

