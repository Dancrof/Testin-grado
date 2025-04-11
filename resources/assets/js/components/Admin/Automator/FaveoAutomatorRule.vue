<template>
  <div :class="['row', 'faveo-automator-rule',(field && field.disabled)?'disabledDiv':'']">

  	<custom-loader v-if="loading"></custom-loader>

    <div class="col-sm-3 rule-menu">
      <span><i class="fas fa-trash faveo-trash" :class="[(field && field.disabled)?'disabledDiv':'']" @click="deleteRule()"></i></span>
      <span class="offset-md-2 max-width-max-content rule_btns">
        <template v-for="section in categories">
          <a href="javascript:;"
            :class="[{'faveo-active-border': category === section.name}, 'btn btn-light me-1']"
            v-tooltip="trans(section.name+'_field')"
            @click="onCategoryChange(section.name)">
            <i :class="section.icon"></i>
          </a>
        </template>
      </span>
    </div>

    <dynamic-select v-if="!loading"
      classname="col-sm-3"
      :labelStyle="{display: 'none'}"
      :multiple="false"
      :id="'rule-' + rule._id"
      :name="'rule-' + rule._id"
		:apiEndpoint="categories.find(obj => obj.name === category).api_info"
      optionLabel="label"
      :value="field"
      :onChange="onFieldChange"
      :strlength="50"
      :clearable="false">
    </dynamic-select>

    <template v-if="field !== null">

      <dynamic-select v-if="!loading"
        classname="col-sm-3"
        :labelStyle="{display: 'none'}"
        :multiple="false"
		:name="'relation-' + rule._id"
        :elements="relationList"
        optionLabel="name"
        :value="relation"
        :onChange="onRelationChange"
        :strlength="35"
        :clearable="false">
      </dynamic-select>

      <!--   automator form field should rerender whenever a field or category is changes else it might show values of old selection   -->
      <div class="col-sm-3" :key="JSON.stringify(field) + JSON.stringify(category)">
	      <automator-form-field
          :key="rule._id"
          enforcerType="rule"
          :form-field="field"
          :enforcer-object="rule"
          :multipleField="multipleField"
          :labelStyle="{display: 'none'}">
        </automator-form-field>
      </div>

    </template>

  </div>
</template>

<script>
import {Rule,getRelationList} from "../../../helpers/AutomatorUtils";
import {useStore} from "vuex";
import {computed} from "vue";
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
import AutomatorFormField from "./AutomatorFormField.vue";
export default {

  name: 'faveo-automator-rule',

  props: {
    rule: { type: Rule, required: true },
    // formFields: { type: Object, required: true },
    index: { type: Number, required: true },
    categories: { type: Array, required: true },
    catChange : { type : Function }
  },

    setup() {

      const store = useStore();

      return {
          selectedRuleKeys : computed( ()=> store.getters.getSelectedRuleKeys )
      }
    },

  data ()  {
    return {
	    // formFieldsObj : this.formFields,
      category: '',
      field: null,
      relation: null,
      relationList: [],
		  loading : false,
      multipleField: false
    }
  },
	
	computed : {

	    // selectableRules() {
		//
		//     if(this.selectedRuleKeys.includes("cc")){
		//
		// 		return this.formFieldsObj[this.category].filter(item => item.unique != "cc")
		//     };
		//
		// 	return this.formFieldsObj[this.category];
	    // }
	},

	created () {
		window.emitter.on('deletedItem', this.deletedItem);
	},

  beforeMount () {
    this.category = this.rule.category;
    this.field = this.rule.field;
    this.relation = this.rule.relation;
    if (this.field) {
      this.relationList = getRelationList(this.field.data_type);
    }
  },

  methods: {

    onFieldChange (value) {
      this.field = value;
      this.refreshRelationList();
      this.$store.dispatch('onFieldChange', { key: 'rules', index: this.index, field: this.field });
	  window.emitter.emit('updateAutomatorField')
    },

    refreshRelationList () {
      if (this.field) {
        this.relationList = getRelationList(this.field.data_type);
        this.onRelationChange(this.relationList[0])
      } else {
        this.relationList = []
      }
    },

    onRelationChange (value) {
      this.relation = value;
      this.$store.dispatch('onRelationChange', { key: 'rules', index: this.index, relation: this.relation });
		window.emitter.emit('updateAutomatorField')
    },

    onCategoryChange (value) {
      this.field = null;
      this.category = value;

      this.$store.dispatch('onCategoryChange', { key: 'rules', index: this.index, value: new Rule (this.rule._id, this.category) });

      this.catChange()

		window.emitter.emit('updateAutomatorField')
    },

    deleteRule () {
      window.emitter.emit('deleteItem', { type : 'rule', index: this.index, id :this.rule._id});
    },

	  deletedItem() {

		this.loading = true;

		setTimeout(()=>{
			this.loading = false
		},1);
	  }
  },

  watch: {
    relation(newVal, oldVal) {
      window.emitter.emit('updateRelation', newVal.id);
      if(newVal.id === 'less_than_and_greater_than'){
       this.multipleField = true;
      }else{
        this.multipleField = false;
      }
    }
  },

  components: {
    'dynamic-select': DynamicSelect,
    'automator-form-field': AutomatorFormField,
  }

}
</script>

<style scoped>

.rule-menu {
  line-height: 2.5;
}

.rule-menu > .faveo-trash {
  margin-right: 1rem;
}

.faveo-trash {
  pointer-events: all;
}

.rule-menu > .active {
  background-color: lightblue;
}

.faveo-automator-rule {
  padding-top: 1.5rem;
}

.faveo-automator-rule:hover {
  box-shadow: 0 -1px 1px -1px rgba(0,0,0,.2), 0 1px 1px 0 rgba(0,0,0,.14), 0 1px 3px 0 rgba(0,0,0,.12);
}

.faveo-active-border {
  color: #333 !important;
  background-color: #e6e6e6 !important;
  border: 2px solid #3c8dbc;
}
.rule_btns { position: relative; top: -2px;}

.disabledDiv {
    pointer-events: none;
    background-color: rgb(224, 224, 224, 0.4);
}
</style>