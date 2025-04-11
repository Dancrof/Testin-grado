<template>
  <faveo-box :title="trans('when_'+pageType+'_satisfies_these_conditions')">

    <div class="row">
      <div class="col-sm-3">
        <label class="radio-inline ">
          <input type="radio" class="form-check-input" name="matcher" @change="onchange('any')" value="any" :checked="matcher === 'any'"> &nbsp;{{lang('match_any_of_below')}}
        </label>
      </div>

      <div class="col-sm-3">
        <label class="radio-inline">
          <input type="radio" class="form-check-input" name="matcher" @change="onchange('all')" value="all" :checked="matcher === 'all'"> &nbsp;{{lang('match_all_of_below')}}
        </label>
      </div>
	  </div>

    <faveo-automator-rule v-for="(rule, index) in updatedRules" :key="rule._id" :rule="rule" :index="index"
      :categories="categories" :catChange="onCatChange"/>

    <div style = "margin-top: 1rem">
      <a @click="addNew()" href="javascript:;"><span><i class="fas fa-plus-circle"></i> {{trans('add_new_rule')}}</span></a>
    </div>
  </faveo-box>
</template>

<script>

import { Rule } from '../../../helpers/AutomatorUtils'
import {boolean} from "../../../helpers/extraLogics";
import FaveoAutomatorRule from "./FaveoAutomatorRule.vue";

export default {

  name: 'rule-list',

  props: {
    categories: { type: Array, required: true },
	  pageType : { type : String, default : 'ticket' }
  },

  data: () => {
    return {
      matcher: '',
      ruleList : []
    }
  },

  beforeMount () {

    this.ruleList = this.$store.getters.getAutomatorRules;
    
    this.matcher = this.$store.getters.getAutomatorDataByKey('matcher')

    if (!boolean(this.ruleList)) {
      this.addNew()
    }
  },

  computed: {

    // ...mapGetters(['getAutomatorRules']);

    updatedRules() {

      return this.ruleList;
    }
  },

  methods: {

    onCatChange() {

      this.ruleList = [];

      this.ruleList = this.$store.getters.getAutomatorRules;
		window.emitter.emit('deletedItem');
    },

    addNew () {
      this.$store.dispatch('addNewElementToAutomatorProperty', { key: 'rules', value: new Rule() });
    },

    onchange (value) {
      this.matcher = value
      this.$store.dispatch('setAutomatorDataByKey', { key: 'matcher', value: value })
    }
  },

  components: {
    'faveo-automator-rule': FaveoAutomatorRule,
  }

}
</script>

<style scoped>

.form-check-input{
  cursor: pointer;
}

</style>