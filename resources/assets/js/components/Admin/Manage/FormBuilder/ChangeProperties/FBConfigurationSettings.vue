<template>
  <div>
    <div class="row mt-2 p-2">
      <div class="col-md-6" v-if="isAgentConfig(formFieldData)">
        <label>{{lang('agent')}}</label>
        <div class="form-check">
          <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.display_for_agent" id="display-for-agent" @click="onCheckboxClick('required_for_agent')">
          <label class="form-check-label" for="display-for-agent">{{lang('display_in_form')}}</label>
        </div>
        <div class="form-check" v-if="formFieldData.title !== 'Captcha'">
          <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.required_for_agent" :disabled="!formFieldData.display_for_agent && formFieldData.title !== 'Captcha'" id="required-for-agent">
          <label class="form-check-label" for="required-for-agent">{{lang('required_when_submitting_the_form')}}</label>
        </div>
      </div>

      <div class="col-md-6" v-if="defaultCategories.includes(formCategoryType) ? formFieldData.title !== 'CC' && formFieldData.title !== 'Assigned' && formFieldData.is_user_config : formFieldData.title !== 'CC' && formFieldData.title !== 'Assigned'">
        <label>{{lang('client')}}</label>
        <div class="form-check">
          <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.display_for_user" id="display-for-client">
          <label class="form-check-label" for="display-for-client" @click="onCheckboxClick('required_for_user')">{{lang('display_in_form')}}</label>
        </div>
        <div class="form-check" v-if="formFieldData.title !== 'Captcha'">
          <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" v-model="formFieldData.required_for_user" :disabled="!formFieldData.display_for_user && formFieldData.title !== 'Captcha'" id="required-for-clinet">
          <label class="form-check-label" for="required-for-clinet">{{lang('required_when_submitting_the_form')}}</label>
        </div>
      </div>
    </div>

    <api-info-block v-if="formFieldData.title === 'Api'" :form-field-data="formFieldData" :update-api-info="updateApiInfo"/>

      <div class="col-md-12" style="padding-top: 10px;" v-if="!formFieldData.default">
          <label for="shortcode">{{lang('shortcode')}}</label>
          <tool-tip :message="lang('ticket_custom_field_shortcode_value')" size="small"></tool-tip>
          <input type="text" name="shortcode" id="shortcode" @keydown.space.prevent class="form-control" v-model="formFieldData.shortcode"/>
      </div>

    <div class="col-md-12" style="padding-top: 10px;" v-if="formFieldData.title != 'Captcha'">
      <label for="description">{{lang('description')}}</label>
      <textarea name="description" id="description" class="form-control" v-model="formFieldData.labels_for_form_field[0].description" :placeholder="lang('form_field_tooltip_description_message')"></textarea>
    </div>

    <div>

      <div class="d-flex">

        <div class="col-md-6" v-if="formFieldData.title=='Description' && formFieldData.title != 'Captcha' && formCategoryType == 'ticket'">
          <div class="form-check">
            <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" id="add-media-cb" v-model="formFieldData.media_option">
            <label for="add-media-cb">{{lang('can_agent_add_media')}}</label>
          </div>
        </div>

        <div class="col-md-6" v-if="formFieldData.title != 'Captcha'">
          <div class="form-check">
            <input class="form-check-input" type="checkbox" :false-value="0" :true-value="1" id="form-tooltip" v-model="formFieldData.show_description_under_form_field">
            <label for="form-tooltip">{{lang('show_description_under_form_field')}}</label>
          </div>
        </div>
      </div>

      <div class="col-md-12" v-if="formFieldData.title ==='Captcha'" style="padding-top: 10px;">
        <p><strong>{{lang('captcha_config_message')}} <a :href="basePath() + '/recaptcha'" target="_new" style="text-decoration:underline">{{lang('here')}}</a>
        </strong>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { computed }  from 'vue';
import { useStore } from 'vuex';
import ApiInfoBlock from "./ApiInfoBlock.vue";
import ToolTip from "../../../../MiniComponent/ToolTip.vue";

export default {

  name: 'FB-configuration-settings',

    setup() {

        const store = useStore();

        return {
            // getter
            formCategoryType: computed(() => store.getters.getFormCategoryType),
        };
    },

  props: {

    // Form field data
    formFieldData: {
      type: Object,
      required: true
    },
  },

  data: () => {
    return {
      defaultCategories : ['ticket', 'organisation', 'user', 'asset', 'change', 'license']
    }
  },

  methods: {
    // uncheck `required_when_submitting_the_form` field if `display_in_form` field get unchecked
    onCheckboxClick(key) {
      this.formFieldData[key] = false;
    },

    updateApiInfo(apiInfo) {
      this.formFieldData['api_info'] = apiInfo;
    },

    isAgentConfig(formField) {
      if (this.formCategoryType === 'group') {
        return true;
      }
      const isDefault = this.defaultCategories.includes(this.formCategoryType)

      if (!isDefault) {
        return false;
      }

      return formField.is_agent_config;
    }
  },

  components: {
    'tool-tip' : ToolTip,
    'api-info-block': ApiInfoBlock
  }

}
</script>

<style scoped>

input[type=checkbox]{
  cursor: pointer !important;
}
</style>