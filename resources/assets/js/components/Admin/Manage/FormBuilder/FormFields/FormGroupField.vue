<template>
  <div class="row form-field">

    <div class="col-md-3 form-field-label">
      <img width="16" height="16" id="enter-arrow" v-if="isChild" :src="basePathVersion() + imageUrl" alt="">
      <input type="text" readonly :value="fieldData.name">
    </div>
    <div class="col-md-6">
      <input class="form-control" type="text" :placeholder="lang('this_is_form_group')" disabled />
    </div>
    <div class="col-md-3" style="display: flex;">

      <span class="space-filler"></span>

      <div class="form-field-actions-btn">
        <form-field-actions :on-edit-form-field="onEditFormField" :field-data="fieldData" />
      </div>

    </div>
  </div>

</template>

<script>

import FormFieldActions from "./FormFieldActions.vue";

export default {

  components: {
    'form-field-actions': FormFieldActions
  },

  props: {

    // Field data object
    fieldData: {
      type: Object,
      required: true
    },

    // `true` if a node is not a root node
    isChild: {
      type: Boolean,
      default: () => false
    }
  },

  data: () => {
    return {
      imageUrl: '/themes/default/client/images/enterarrow.png'
    }
  },

  methods: {

    // Open edit page for form group by ID
    onEditFormField() {

	  this.$router.push({ path : this.fieldData.edit_url });
    }
  },
}
</script>

<style lang="css" scoped>
.form-field-label > input {
  font-weight: 600;
  padding: 5px;
  width: 85%;
  border: 1px dashed #fff;
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

</style>
