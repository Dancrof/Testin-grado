<template>

  <div  id="org-forms" class="card card-light ">

    <div class="card-header pointer" @click="showCardBody = !showCardBody">

      <h3 class="card-title"> {{lang('list_of_form_categories')}} </h3>

      <div class="card-tools">
        <button type="button" class="btn btn-tool">
          <i :class="{'fas fa-angle-up' : showCardBody, 'fas fa-angle-down' : !showCardBody }" class="fs-25"></i>
        </button>
      </div>
    </div>

    <div v-if="showCardBody" class="card-body">
      <div class="tab-content">
        <div class="active tab-pane">
          <data-table :url="apiUrl" :dataColumns="columns"  :option="options" ></data-table>
        </div>
      </div>
    </div>

    <div>
      <transition name="modal">

        <OrgDetachModal :showModal="showDetachModal" :org-id="id" :category-id="categoryId" :onClose="onClose"></OrgDetachModal>

      </transition>
    </div>

  </div>

</template>

<script>

import {mapGetters} from "vuex";

import DetachModal
  from "../../../../../../../../app/Plugins/Calendar/views/js/components/MiniComponents/DetachModal.vue";
import OrgDetachModal from "./OrgCategoryDetachModal.vue";

export default {

  name : 'org-forms',

  description : 'Organization Forms',

  props : {

    id : { type: String, required: true },
  },

  computed :{
    ...mapGetters(['formattedTime','formattedDate'])
  },

  created() {
    window.emitter.on('hideOrganizationForms', () => {
      this.showCardBody = false;
    })
  },

  beforeMount() {
    const self = this;

    this.options = {

      sortIcon: {

        base : 'glyphicon',

        up: 'glyphicon-chevron-down',

        down: 'glyphicon-chevron-up'
      },

      headings : {
        'name' : this.trans('name'),

        'type' : this.trans('type'),

        'updated_at' : this.trans('updated_at'),

        'action' : this.trans('action')
      },

      columnsClasses : {

        name : 'form-name',

        type : 'form-type',

        updated_at: 'form-updated_at',

      },

      texts : {

        filter : '',

        limit : ''
      },

      templates: {

        name (h, row) {
          return row.name
        },

        type (h, row) {
          return row.type
        },

        updated_at (h, row) {
          return self.formattedTime(row.updated_at)
        },

        action(createElement, row) {
          let icon = self.h('i', {
            'class': 'fa fa-unlink'
          });

          let title = row.id === 1 ? this.trans('default_field_is_not_detachable') : this.trans('detach');

          const anchorProps = {
            class: 'btn btn-primary',
            title : title,

            onClick: () => {
              if (row.id !== 1) {
                self.onDetach(row.id);
              }
            }
          };

          if (row.id === 1) {
            anchorProps.style = 'cursor: not-allowed; background-color:grey';
          }

          return self.h('a', anchorProps, [icon]);
        }

      },

      sortable:  [],

      pagination : { chunk : 5, nav : 'scroll' },

      requestAdapter() {
        return {
          'paginate' : 1,
        }
      },

      responseAdapter({data}) {

        return {

          data: data.data.data,

          count: data.data.data.length
        }
      },
    }
  },

  data() {
    return {
      showCardBody : false,

      detachUrl : '',

      detachParams : {},

      showDetachModal : false,

      categoryId : 0,

      options : {},

      apiUrl: '/api/dependency/form-categories?organization=' + this.id,

      columns : ['name', 'type', 'updated_at', 'action'],
    }
  },

  methods : {
    onDetach(id) {
      this.categoryId = id;
      this.showDetachModal = true;
    },

    onClose() {
      this.showDetachModal = false;
    }
  },

  components : {
    OrgDetachModal,
    DetachModal
  },
}
</script>

<style scoped>

.fs-25 { font-size: 25px !important; }
</style>
