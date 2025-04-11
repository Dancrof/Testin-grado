<template>

  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="modalStyle">

    <template #alert>
    <alert componentName="templateModal"/>
    </template>
    <template #title>
      <h4 class="modal-title">{{lang(modalTitle)}}</h4>
    </template>

    <template #fields>

      <div class="row">
        <dynamic-select :label="lang('template')" :multiple="false" name="template"
          classname="col-sm-3" apiEndpoint="/api/dependency/article-templates" :value="template" :onChange="onChange"  :placeholder="lang('search_or_select')"
          :clearable="template ? true : false" strlength="30">
        </dynamic-select>

        <div class="col-sm-9">
          <custom-loader :duration="4000" v-if="isLoading" />
          <label for="preview-panel">{{lang('preview')}}</label>
          <div class="panel" id="preview-panel">
            <div class="panel-body body-max-height">
              <blockquote v-html="previewBody"></blockquote>
            </div>
          </div>
        </div>
      </div>

    </template>

    <template #controls>
		<div>
			<button class="btn btn-primary" :disabled="!template"
					@click="templateOperation('append')"><i class="glyphicon glyphicon-plus"> </i> {{lang('append')}}</button>
			<button class="btn btn-primary" :disabled="!template"
					@click="templateOperation('overwrite')"> <i class="fas fa-exchange-alt"> </i> {{lang('overwrite')}}</button>
		</div>
    </template>

  </modal>

</template>

<script>
import axios from 'axios';
import DynamicSelect from "../../../../MiniComponent/FormField/DynamicSelect.vue";

export default {

  name: 'template-modal',

  props: {

    /** is show modal or not */
    showModal: {
      type: Boolean,
      required: true
    },

    /** Function to be performed when close/cancel button clicked */
    onClose: {
      type: Function,
      required: true
    },

    /** Model title to show as header */
    modalTitle: {
      type: String,
      required: true
    }
  },

  data: () => {
    return {
      modalStyle: { width : '70vw'},
      previewBody: '<p>Select one template to see the preview!</p>',
      template: '',
      isLoading: false
    }
  },

  methods: {
    onChange(newValue, name) {
      this[name] = newValue;

      if(name === 'template') {
        if(newValue) {
          this.getAndUpdateTemplateBody(newValue.id);
        } else {
          this.previewBody = '<p>Select one template to see the preview!</p>';
        }
      }
    },

    getAndUpdateTemplateBody(templateId) {
      this.isLoading = true;
      axios.get('/article/template/' + templateId)
      .then(response => {
        this.previewBody = response.data.data.description;
      })
      .catch(error => {
        this.previewBody = `<div class="alert alert-danger" role="alert">${error}</div>`;
      })
      .finally(() => {
        this.isLoading = false;
      })
    },

    templateOperation(operation) {
      if(this.template === '') {
        return;
      }
      window.emitter.emit('applyTemplate', { operation: operation, data: this.previewBody });
    }
  },

  components: {
    'dynamic-select': DynamicSelect
  }
}
</script>

<style scoped>
#preview-panel {
  margin-bottom: 0 !important;
}
.modal-body {
  padding: 1.5rem;
}
.body-max-height {
  overflow: auto;
  max-height: 30vh;
}
blockquote { margin : 0 !important; border-left: .7rem solid #c1c1c1 !important; padding: 0.1rem 0.7em !important;}

</style>