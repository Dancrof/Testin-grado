<template>
  <div class="main-div">
    <faveo-box box-class="card card-light" :title="lang('filter')">
        <div class="row" v-for="data in componentMetaData">
          <div class="col-md-4" v-for="item in data.section">
            <date-time-field v-if="item.hasOwnProperty('type') && item.type === 'date'"
                             :label="item.label"
                             :value="item.value"
                             type="datetime"
                             :key="item.name"
                             :id="item.name"
                             :name="item.name"
                             :onChange="onChange"
                             :range="item.range"
                             :required="false"
                             format="MMMM DD YYYY, h:mm a"
                             :clearable="false"
                             :disabled="false"
                             :editable="true"
                             :currentYearDate="false"
                             :time-picker-options="item.timeOptions"
                             :isDateSelector="false"
                             :confirm="true"
            >
            </date-time-field>
            <dynamic-select v-else
                            :key="item.name"
                            :id="item.name"
                            :name="item.name"
                            :apiEndpoint="item.url"
                            :elements="item.elements"
                            :multiple="item.isMultiple"
                            :label="lang(item.label)"
                            :value="item.value"
                            :onChange="onChange"
                            :strlength="item.strlength"
                            :clearable="item.value ? true : false">
            </dynamic-select>
          </div>
        </div>

        <template #actions>
            <div class="card-footer">
                <button id="apply-btn" class="btn btn-primary" type="button" @click="onApply">
                    <span class="fas fa-check"></span>&nbsp; {{ lang('apply')}}
                </button>
                <button id="apply-btn" class="btn btn-primary single-btn" type="button" @click="onReset">
                    <span class="fas fa-undo"></span>&nbsp; {{ lang('reset')}}
                </button>
                <button id="apply-btn" class="btn btn-secondary single-btn" type="button" @click="onCancel">
                    <span class="fas fa-times"></span>&nbsp; {{ lang('cancel')}}
                </button>
            </div>
        </template>
    </faveo-box>

  </div>
</template>

<script>

    import DynamicSelect from "../MiniComponent/FormField/DynamicSelect.vue";
    import DateTimeField from "../MiniComponent/FormField/TimeRangeField.vue";

    export default {
        name : "advance-filter",

        description : "",

        components: {
          DateTimeField,
        'dynamic-select': DynamicSelect
      },

        props:{
          metaData: { type:Array, required: true },
        },

        methods:{

        /**
         * The function which will be called whaen value of the field changes.
         * @param {value}
         * `value` will be the updated value of the field
         * @param {name}
         * `name` will be thw name of the state in the parent class    
         * @return {Void} 
         */
        onChange(value, name){
            this.selectedFilters[name] = value;
        },

        onCancel() {
          this.$emit('selectedFilters', 'closeEvent');
        },

        onApply() {
          this.$emit('selectedFilters',this.selectedFilters);
        },
        onReset() {
          this.selectedFilters = {};
          this.$emit('selectedFilters', 'resetEvent');
        }
      },

        data(){
            return{

                /**
                 * Values that has been selected
                 * @type {Null|String}
                 */
                selectedFilters: {},

                /**
                 * It closes the field dropdown once a value is selected.
                 * For single-select, it will be true. For multi-select it will be false
                 * @type {Boolean}
                 */
                close_on_select: !this.multiple,

                isShowFilter: false,

                componentMetaData: this.metaData,

            }
        },
};
</script>
