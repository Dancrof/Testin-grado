<template>
  <div title="">
    <button class="btn btn-light" v-tooltip="lang('edit')" @click="onEditFormField(fieldData)">
      <i class="fa-solid fa-gear" aria-hidden="true"></i>
    </button>
    <span class="dropdown" v-if="canAddChild()">
      <button class="btn btn-light" v-tooltip="lang('add_child')" data-bs-toggle="dropdown"><i class="fas fa-plus" aria-hidden="true"></i></button>
      <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu">
        <li v-for="(item, index) in menuItems" :key="item.id" @click="onChildClick(index, selectedOption)" class="nav-item">
          <a class="nav-link text-dark" href="javascript:void(0);">{{ item.title }}</a>
        </li>
      </ul>
    </span>
    <button class="btn btn-secondary" v-tooltip="lang('delete')" v-if="fieldData.is_deletable" @click="removeElementAt()">
      <i class="fa-solid fa-trash" aria-hidden="true"></i>
    </button>
  </div>
</template>

<script>
import { boolean } from "../../../../../helpers/extraLogics";
import {useStore} from 'vuex';
import {computed} from "vue";

export default {

    setup() {

        const store = useStore();

        return {
            // getter
            menuItems: computed(() => store.getters.getFormMenus),
            categoryType: computed(() => store.getters.getFormCategoryType)
        };
    },

  props: {

    // Field data object
    fieldData: {
      type: Object,
      required: true
    },

    // Function to execute for editing field properties
    onEditFormField: {
      type: Function,
      required: true
    },

    // Function to add new node element
    onChildClick: {
      type: Function,
      required: false
    },

    // `true` if a node is not a root node
    selectedOption: {
      type: [String, Object],
      required: false
    }
  },
  data: () => {
    return {
    }
  },

  methods: {
    // emit event to remove element from array, `reference_id` AND `reference_type` is used for form groups
    removeElementAt() {
      window.emitter.emit('onRemoveElement', {'fieldData': this.fieldData, reference_id : this.fieldData.reference_id, reference_type : this.fieldData.reference_type});
    },

    canAddChild() {

      if(this.categoryType != 'ticket' && this.categoryType != 'user' && this.fieldData.label == 'Department') return false;

      return typeof this.selectedOption !== 'string' && boolean(this.selectedOption);
    }
  }
};
</script>

<style lang="css" scoped>
.fb-movable-button {
  cursor: move;
}
.dropdown-menu {
  left: -125px;
  top: -125px;
}
</style>