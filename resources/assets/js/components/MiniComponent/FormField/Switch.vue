<template>
    <div :class="classname">
        <toggle v-model="enabled" class="toggle-switch" />
    </div>

</template>

<script>
import {boolean} from '../../../helpers/extraLogics';

export default {
  name: "status-switch",

  description: "Switch for turning ON/OFF status of a feature in a fancy way",

  props: {
    /**
     * the name of the state in parent class, for looking into the vuex store for errors
     * @type {String}
     */
    name: { type: [String, Number], required: true },

    /**
     * selected value of the field.
     * list of already selected element ids that has to be displayed
     * @type {Number|Boolean}
     */
    value: { type: [Boolean, Number], default: false },

    /**
     * name of the class (for css, not really required)
     * @type {String}
     */
    classname: { type: String, default: "" },

    /**
     * The function which will be called as soon as value of the field changes
     * It should have two arguments `value` and `name`
     *     `value` will be the updated value of the field
     *     `name` will be thw name of the state in the parent class
     *
     * An example function :
     *         onChange(value, name){
     *             this[name]= selectedValue
     *         }
     *
     * @type {Function}
     */
    onChange: { type: Function, Required: true },

    /**
     * Whether switch should be bold (true|false or 0|1)
     * @type {Boolean|Number}
     */
    bold: { type: [Boolean, Number], default: false }
  },

  data() {
    return {
      /**
       * whether status is ON(true or 1) or OFF(false or 0)
       * @type {Number|Boolean}
       */
      enabled: boolean(this.value)
    };
  },

  watch: {
    enabled(newVal) {
      //calls onChange method of parent component to update values
      this.onChange(newVal, this.name);
    },

    value(newVal){
      this.enabled = boolean(this.value)
    }
  }
};
</script>

<style src="@vueform/toggle/themes/default.css"></style>

<style>
.toggle-switch {
    --toggle-bg-on: #28a745;
    --toggle-border-on: #28a745;
    --toggle-bg-off: #d9534f;
    --toggle-border-off: #d9534f;
}
.toggle-off { opacity: 0.5; }

.toggle-switch #toggle { display: none !important; }

.toggle{
  width: 40px !important;
  height: 15px !important;
}

.toggle-handle{
  width: 15px !important;
  height: 15px !important;
}

.toggle-container:focus {
  box-shadow: none !important;
  outline: none !important;
}
</style>
