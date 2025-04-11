<template>
  <faveo-box :title="trans('perform_these_actions')">

    <faveo-automator-action v-for="(action, index) in actionList" :key="action._id" :action="action" :actionEndpoint="actionEndpoint" :index="index" />

	  <div style = "margin-top: 1rem">
		  <a @click="addNew()" href="javascript:;"><span><i class="fas fa-plus-circle"></i> {{trans('add_new_action')}}</span></a>
	  </div>

<!--	  <template v-if="pageType != 'ticket'">-->
<!--		-->
<!--		  <div v-if="actionList.length < formFields.length-1" style = "margin-top: 1rem">-->
<!--			  <a @click="addNew()" href="javascript:;"><span><i class="fas fa-plus-circle"></i> {{trans('add_new_action')}}</span></a>-->
<!--		  </div>-->
<!--	  </template>-->
<!--	  -->
<!--	  <template v-else>-->
<!--		  -->
<!--		  <div v-if="actionList.length < formFields.length" style = "margin-top: 1rem">-->
<!--			  <a @click="addNew()" href="javascript:;"><span><i class="fas fa-plus-circle"></i> {{trans('add_new_action')}}</span></a>-->
<!--		  </div>-->
<!--	  </template>-->
  </faveo-box>
</template>

<script>
import { Action } from '../../../helpers/AutomatorUtils'
import {boolean} from "../../../helpers/extraLogics";
import {useStore} from "vuex";
import {computed} from "vue";
import FaveoAutomatorAction from "./FaveoAutomatorAction.vue";

export default {

  name: 'action-list',

    setup(){

        const store = useStore()

        return {
            actionList : computed(()=>store.getters.getAutomatorActions)
        }
    },

  props: {
    // formFields: { type: Array, required: true },
	  actionEndpoint: { type: String, default: '' }
  },
	
	data () {
	  
	  return  {
		  pageType : '',
	  }
	},

  beforeMount () {

    if (!boolean(this.actionList)) {
      this.addNew()
    }
	
	  let paramsSearch = new URLSearchParams(window.location.search);
	
	  this.pageType = paramsSearch.get("page_type") ? paramsSearch.get("page_type") : 'ticket';
  },

  methods: {

    addNew () {
      this.$store.dispatch('addNewElementToAutomatorProperty', { key: 'actions', value: new Action() });
    }
  },

  components: {
    'faveo-automator-action': FaveoAutomatorAction,
  }

}
</script>

<style>

</style>