<template>
  <div class="main-div__formbuilder">

    <draggable-element v-bind="dragOptions"
       :component-data="{
          tag: 'div',
          type: 'transition-group',
          name: !isDragInProgress ? 'flip-list' : null
        }"
       class="item-container" :list="originalValue" @start="isDragInProgress = true" @end="isDragInProgress = false"
       @input="dragChangeEventEmitter" :empty-insert-threshold="230" :disabled="isDisableDraging" itemKey="id">

      <template #item="{element, index}">

        <div class="item-group form-field-element" :title="lang('move')" :key="element.groupid || element.id">

          <!-- text/number/date/email/file/textarea/htmltextarea/float -->
          <FBSimpleFields v-if="isSimpleFields(element) || element.title === 'Api'" :field-data="element" :on-edit-form-field="onShowSettingModal" :isChild="isChild"/>

          <!-- select -->
          <FBSelect v-if="element.title !== 'Api' && (element.type === 'api' || element.type === 'select' || element.type === 'select2' || element.type === 'multiselect')" :field-data="element" :isDisabled="isDisableSelectBox(element)" :on-edit-form-field="onShowSettingModal" :on-child-click="onChildClick" :isChild="isChild"/>


          <!-- checkbox -->
          <FBCheckbox v-if="element.type=='checkbox'" :field-data="element" :on-edit-form-field="onShowSettingModal" :on-child-click="onChildClick" :isChild="isChild"/>

          <!-- radio -->
          <FBRadio v-if="element.type=='radio'" :field-data="element" :on-edit-form-field="onShowSettingModal" :on-child-click="onChildClick" :isChild="isChild"/>

          <!-- Form group -->
          <form-group-field v-if="element.type=='group'" :field-data="element" :isChild="isChild"/>

          <!-- Custom form type -->
          <FBCustom v-if="element.type=='custom'" :field-data="element" :on-edit-form-field="onShowSettingModal" :isChild="isChild"/>

        </div>
      </template>

    </draggable-element>

    <transition name="modal">
      <form-builder-setting-modal title="settings" v-if="showSettingModal" :onCloseSettingModal="onCloseSettingModal" :isShowSettingModal="showSettingModal" :field-data="selectedFormFieldObject" />
    </transition>

  </div>
</template>

<script>

import draggable from 'vuedraggable';
import { computed }  from 'vue';
import { useStore } from 'vuex';
import FBSimpleFields from "./FormFields/FBSimpleFields.vue";
import FBSelect from "./FormFields/FBSelect.vue";
import FBCheckbox from "./FormFields/FBCheckbox.vue";
import FBRadio from "./FormFields/FBRadio.vue";
import FormGroupField from "./FormFields/FormGroupField.vue";
import FBCustom from "./FormFields/FBCustom.vue";
import FormBuilderSettingModal from "./ChangeProperties/FormBuilderSettingModal.vue";

export default {
  name: 'draggable-form-field-item',

  components: {
    'FBSimpleFields': FBSimpleFields,
    'FBSelect': FBSelect,
    'FBCheckbox': FBCheckbox,
    'FBRadio': FBRadio,
    'form-group-field': FormGroupField,
    'FBCustom': FBCustom,
    'form-builder-setting-modal': FormBuilderSettingModal,
    'draggable-element': draggable
  },

    setup() {

        const store = useStore();

        return {
            // getter
            isDisableDraging: computed(() => store.getters.isDisableDraging),
        };
    },


  props: {

    // v-model binded value
    value: {
      type: Array,
      default: null
    },

    // list elements
    list: {
      type: Array,
      default: null
    },

    // `true` if a node is not a root node
    isChild: {
      type: Boolean,
      default: () => false
    },

    keyVal : {
      type : [String, Number],
      default : ''
    }
  },

  data: function () {
    return {

      isDragInProgress: false,

      menuItems: null, // Possible form fields type

      selectedFormFieldObject: null,

      showSettingModal: false, // Falg to show/hide stting modal,
    }
  },

  beforeMount() {
    this.menuItems = this.$store.getters.getFormMenus;
  },

  created() {
    window.emitter.on('formFieldSettingsApplied', this.onCloseSettingModal);
  },

  computed: {

    dragOptions() {
    
      return {

        animation: 200,
    
        group: this.isChild ? "faveo-form-builder-" + (this.keyVal ? this.keyVal : Math.random())  :'faveo-form-builder',
    
        disabled: false,
    
        ghostClass: 'ghost'
      }
    },

    originalValue() {
      return this.value ? this.value : this.list;
    },
  },
  methods: {

    // Drag change event emitter, listener is in draggable plugin
    dragChangeEventEmitter(value) {
      this.$emit('input', value);
    },

    isSimpleFields(field) {
      const simpleFields = ['text', 'number', 'date', 'email', 'file','image', 'textarea', 'htmltextarea', 'taggable','float'];
      return simpleFields.indexOf(field.type) > -1;
    },

    // returns true, to disable dropdown if default field OR some spacial case
    isDisableSelectBox(field) {
      return field.default === 1 && field.title !=='Help Topic' && field.title !== 'Department';
    },

    // Add new node element for nested fields
    onChildClick(childElementIndex, selectedOption) {
      let clonedMenuItem = JSON.parse(JSON.stringify(this.menuItems));
      const currentTimestamp = this.getCurrentTimestamp();
      clonedMenuItem[childElementIndex].form_identifier = currentTimestamp;
      clonedMenuItem[childElementIndex].id = currentTimestamp;
      if(Array.isArray(selectedOption)) {
        for (let i = 0; i < selectedOption.length; i++) {
          selectedOption[i].nodes.push(clonedMenuItem[childElementIndex]);
        }
      } else {
        selectedOption.nodes.push(clonedMenuItem[childElementIndex]);
      }
    },


    onShowSettingModal(data) {
      this.selectedFormFieldObject = data;
      this.$store.commit('updateIsDisableDraging', true);
      this.showSettingModal = true;
    },

    onCloseSettingModal() {
      this.$store.commit('updateIsDisableDraging', false);
			this.showSettingModal = false;
    },

    getCurrentTimestamp() {
      return new Date().getTime();
    },
  
  },

};
</script>

<style scoped>
.item-container {
  background-color: #fff
}
.dropdown-menu {
  left: -125px;
  top: -125px;
}
.item {
  margin: 0.3rem;
  padding: 1rem;
  border: solid #dedddd 1px;
}
.form-field-element {
  cursor: move;
  margin-bottom: 0.1rem;
  padding: 1rem 0 0.5rem 0.5rem;
}
.form-field-label > input {
  padding: 5px;
  border: 1px dashed #fff;
  text-align: right;
}
.form-field-element:hover {
  box-shadow: 0 -1px 1px -1px rgba(0,0,0,.2), 0 1px 1px 0 rgba(0,0,0,.14), 0 1px 3px 0 rgba(0,0,0,.12);
}
.item-sub {
  margin: 0 0 0 1rem;
}
.space-filler {
  flex: 1 1 auto;
}
.form-field-actions-btn {
  visibility: hidden;
  margin-right: 1rem;
}
.form-field:hover .form-field-actions-btn{
  visibility: visible;
}
.fb__icon {
  cursor: pointer;
  color: #545454;
}
</style>

<style lang="css">
.form-field:hover .form-field-actions-btn{
  visibility: visible;
}
</style>
