<template>
  <div class="menu mt-3">
    <div  id="drag__body">
      <div class="btn-group mb-2 w-100">

        <a class="btn btn-light field-btn" href="javascript:;" @click="toggleFields('fields')"
           :class="type == 'fields' ? 'active-blue' : ''">
          {{ trans('form_fields') }}
        </a>

        <a v-if="formGroupList && formGroupList.length > 0 && getFormCategoryType !== 'user' && getFormCategoryType !== 'organisation' && getFormCategoryType !== 'license'"
           class="btn btn-light field-btn" href="javascript:;" @click="toggleFields('groups')"
           :class="type == 'groups' ? 'active-blue' : ''">
          {{ trans('form_groups') }}
        </a>
      </div>

        <draggable-element v-if="type == 'fields'" class="form__menulsit row" :list="getFormFilteredMenu" :group="{ name: 'faveo-form-builder', pull: 'clone', put: false }" :clone="cloneElement">

      <template #item="{ element, index }">

        <div class="col-sm-6">

          <div class="info-box menu-info-box bg-light" :key="element.id" v-tooltip="element.title">

                        <span v-if="element.icon_class" class="info-box-icon menu-icon">

                            <i :class="['fas', element.icon_class]"></i>
                        </span>

            <div class="info-box-content">

              <span class="info-box-text">{{ element.title }}</span>
            </div>
          </div>
        </div>
      </template>
    </draggable-element>

    <draggable-element v-if="type == 'fields' && !isFormGroup" class="form__menulsit row" :list="getFormSection" :group="{ name: 'faveo-form-section', pull: 'clone', put: false }" :clone="cloneElement">

      <template #item="{ element, index }">

        <div class="col-sm-12 text-center">

          <div class="info-box menu-info-box bg-light" :key="element.id" v-tooltip="element.title">

                        <span v-if="element.icon_class" class="info-box-icon menu-icon">

                            <i :class="['fas', element.icon_class]"></i>
                        </span>

            <div class="info-box-content">

              <span class="info-box-text">{{ element.title }}</span>
            </div>
          </div>
        </div>
      </template>
    </draggable-element>

    <template v-if="type == 'groups'">

      <draggable-element v-if="formGroupList && formGroupList.length > 0 && getFormCategoryType !== 'user' && getFormCategoryType !== 'organisation' && getFormCategoryType !== 'license'" class="form__menulsit row"
                         :list="formGroupList" :group="{ name: 'faveo-form-builder', pull: 'clone', put: false }" :clone="cloneElement">

        <template #item="{ element, index }">

          <div class="col-sm-12">

            <div class="info-box menu-info-box bg-light mb-2" :key="element.id" v-tooltip="element.name">

                            <span class="info-box-icon menu-icon">

                                <i class="fas fa-layer-group"></i>
                            </span>

              <div class="info-box-content">

                <span class="info-box-text">{{ element.name }}</span>
              </div>
            </div>
          </div>
        </template>
      </draggable-element>
    </template>
    </div>
  </div>
</template>

<script>

import draggable from 'vuedraggable';

import { mapGetters } from 'vuex';

export default {

  components: {

    'draggable-element': draggable,
  },

  props: {
    // List of form groups
    formGroupList: {
      type: Array,
      required: true
    },

    // type of form-field (fields/form-group)
    type : { type : String, default : 'fields' },

    isFormGroup : { type : Boolean, default : false }
  },

  data() {
    return {
      isSticky: false, // flag to use for fixing form menu pallet on top
      headerWidth: '100%',
      stickyNavTop: 0,
      stickyOffsetCounter: 0,
      topBarWidth: 0,
      type: 'fields'
    }
  },

  computed: {

    /**
     * returns section field values
     * @param {void}
     * @return {Array}
     * */
    getFormSection() {

      return this.getFormMenus.filter(obj=> obj.type === 'section')
    },

    /**
     * returns form field values
     * @param {void}
     * @return {Array}
     * */
    getFormFilteredMenu() {

      return this.getFormMenus.filter(obj=> obj.type != 'section')
    },

    // Getting the formMenu and category type values from store
    ...mapGetters(['getFormMenus','getFormCategoryType'])
  },

  created() {
    // Adding scroll event for sticky form navbar
    window.addEventListener('scroll', this.stickyNav);
  },

  methods: {
    /**
     * Toggle between form fields and form groups view
     * @param {String} viewType - Type of view to toggle ('fields' or 'groups')
     */
    toggleFields(viewType) {
      this.type = viewType;
    },
    /**
     * Clone element
     * Assign timestamp to `groupid` if field type is group
     * else assign timestamp to `id`
     *
     * This will resolve the DOM update error in loop for type group
     */
    cloneElement(data) {
      let newData = JSON.parse(JSON.stringify(data));
      const currentTimestamp = this.getCurrentTimestamp();
      if (newData.type === 'group') {
        newData.groupid = currentTimestamp;
      } else {
        newData.id = currentTimestamp;
      }
      newData.form_identifier = currentTimestamp;
      return newData;
    },

    /**
     * this method will return timestamp
     * @param {void}
     * @return {Date}
     * */
    getCurrentTimestamp() {
      return new Date().getTime();
    },

    // Used for fixing/unfixing form menu top bar
    stickyNav() {
      let scrollTop = this.getWindowScrollTop();
      if (scrollTop > this.stickyNavTop) {
        this.isSticky = true;
        this.stickyOffsetCounter++;
        if (this.stickyOffsetCounter == 1) {
          this.topBarWidth = this.getStickyBoxOffset();
        }
        this.headerWidth = this.topBarWidth;
      } else {
        this.stickyOffsetCounter = 0;
        this.isSticky = false;
        this.headerWidth = '100%';
      }
    },

    /**
     * this method will return navbar position value
     * @param {void}
     * @return {Number}
     * */
    getWindowScrollTop(){
      return $(window).scrollTop();
    },

    /**
     * this method will return navbar offset value
     * @param {void}
     * @return {Number}
     * */
    getStickyBoxOffset() {
      return this.$refs.stickyBox.offsetWidth + 'px';
    }
  },

  beforeDestroy() {
    // removing the scroll event listener
    window.removeEventListener('scroll', this.stickyNav);
  }
};
</script>

<style scoped>

.menu-icon {
  font-size: 1.1rem !important;
  width: 49px!important;
  margin-left: -8px!important;
}

.menu-info-box {
  cursor : move;
  min-height: 40px !important;
  border: 1px dashed #c0c3c4;
}
.info-box-text{
  font-size: small;
  position: absolute;
  margin-left: -16px;
  margin-right: 4px;
}
.field-btn { margin-right: 0px !important;  border: 1px solid #999b9b; }
.active-blue {
  border-bottom: 2px solid #42a5f5;
}

</style>