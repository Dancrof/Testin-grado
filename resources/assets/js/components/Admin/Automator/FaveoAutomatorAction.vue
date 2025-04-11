<template>
  <div :class="['row', 'faveo-automator-action',(field && field.disabled)?'disabledDiv':'']">

	  <custom-loader v-if="loading"></custom-loader>

    <span class="col-sm-auto"><i class="fas fa-trash faveo-trash" @click="deleteAction()"></i></span>

    <dynamic-select v-if="!loading"
      classname="col-sm-5"
      :labelStyle="{display: 'none'}"
      :multiple="false"
      :id="'action-' + action._id"
      :name="'action-' + action._id"
      :api-endpoint="actionEndpoint"
        :api-parameters="getApiParameters"
      optionLabel="label"
      :value="field"
      :onChange="onFieldChange"
      :clearable="false"
      :strlength="60" :removeVal="false">
    </dynamic-select>

    <template v-if="field !== null">
      <div v-if="field.data_type === 'custom'" class="col-sm-12" :key="index">
        <automator-custom-type-field :field="field" :action-email="action.action_email" :index="index" />
      </div>
      <div v-else class="col-sm-6" :key="JSON.stringify(field)">
        <automator-form-field
          :key="action._id"
          enforcerType="action"
          :form-field="field"
          :enforcer-object="action"
          :labelStyle="{display: 'none'}">
        </automator-form-field>
      </div>
    </template>
  </div>
</template>

<script>
import { Action } from '../../../helpers/AutomatorUtils'
import {useStore} from "vuex";
import {computed} from "vue";
import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
import AutomatorFormField from "./AutomatorFormField.vue";
import AutomatorCustomTypeField from "./AutomatorCustomTypeField.vue";

export default {

  name: 'faveo-automator-action',

	
    setup(){

        const store = useStore()

        return {
	       
			actionList : computed(()=>store.getters.getAutomatorActions),
	        
            selectedActionKeys : computed(()=>store.getters.getSelectedActionKeys)
        }
    },

  props: {
    action: { type: Action, required: true },
    index: { type: Number, required: true },
	  actionEndpoint: { type: String, default: '' }
  },

  data: () => {
    return {
      field: null,
	    pageType : '',
		loading : false
    }
  },

	created () {
		window.emitter.on('deletedItem', this.deletedItem);
	},

  beforeMount () {
	  
	  this.field = this.action.field;

	  let paramsSearch = new URLSearchParams(window.location.search);

	  this.pageType = paramsSearch.get("page_type") ? paramsSearch.get("page_type") : 'ticket';
  },

  methods: {

    onFieldChange (value) {

      this.field = value;

      this.$store.dispatch('onFieldChange', { key: 'actions', index: this.index, field: this.field })
    },

    deleteAction () {
      window.emitter.emit('deleteItem', { type : 'action', index: this.index, id : this.action._id});
    },

	  deletedItem() {

		  this.loading = true;

		  setTimeout(()=>{
			  this.loading = false
		  },1);
	  }
  },

  computed : {
	  
	  getApiParameters(){
		  
		  return {
			  'ignore_ids': this.actionList.filter(obj => obj.field).map(obj => obj.field.id),
		  };
	  },
    /**
     * Gives form fields which can be selected. Form fields which are already selected cannot be selected again
     */
    // selectableFormFields(){
    //   // check what all fields has already been selected and return the rest of it
    //   return this.formFields.filter((formField)=> {
	//
	//
    //     if (this.pageType != 'ticket') {
	//
	//
    //       if (this.selectedActionKeys.includes("status_id")) {
	//
    //         if (!this.selectedActionKeys.includes("cab_id")) {
	//
    //           this.selectedActionKeys.push("cab_id");
    //         }
	//
    //       } else if (this.selectedActionKeys.includes("cab_id")) {
	//
    //         if (!this.selectedActionKeys.includes("status_id")) {
	//
    //           this.selectedActionKeys.push("status_id");
    //         }
    //       }
    //     }
	//
    //     return !this.selectedActionKeys.includes(formField.unique);
	//
    //   });
    // }
  },

  components: {
    'dynamic-select': DynamicSelect,
    'automator-form-field': AutomatorFormField,
    'automator-custom-type-field': AutomatorCustomTypeField
  }

}
</script>

<style scoped>

.faveo-trash {
  padding-right: 1rem;
  line-height: 1.5;
  pointer-events: all;
}

.faveo-automator-action {
  padding-top: 1.5rem;
}

.faveo-automator-action:hover {
  box-shadow: 0 -1px 1px -1px rgba(0,0,0,.2), 0 1px 1px 0 rgba(0,0,0,.14), 0 1px 3px 0 rgba(0,0,0,.12);
}

.disabledDiv {
    pointer-events: none;
    background-color: rgb(224, 224, 224, 0.4);
}

</style>
