<template>

  <div :class="classname">
    <label :style="labelStyle">{{ label }}</label>
    <tool-tip v-if="hint !=''" :message="hint" size="small"></tool-tip>
    <div class="row">
        <span v-for="(option,index) in options" :class="class_name">
            <input class="check_align mt-1" :name="name" v-model="checked" type="checkbox" :value="option.value ? option.value : option.id" @keyup="keyupListener($event,name)" @keydown="keydownListener($event,name)"
                   @keypress="keypressEvt($event,name)">
	        <span class="ms-1" v-tooltip="option.hover ? option.hover : ''">{{lang(option.name ? option.name : option.label)}}&nbsp;&nbsp;</span>
         </span>
    </div>
  </div>


</template>

<script>
import ToolTip from '../../../components/MiniComponent/ToolTip.vue'
export default {
  name : "checkbox",

  description : "Checkbox with default css class and other required props to be used throughout the project",

  props : {

    options : {type:Array,default:()=>{}},

    value : {type: Array, default: ()=>[]},

    name : {type: String, default: 'check'},

    label : {type: String, default: 'label'},

    classname : {type: String, default: 'col-sm-4'},

    class_name : {type: String, default: 'col-sm-4'},

    spanClass : { type : String, default : 'check_inline'},

    keyupListener: { type: Function , default : ()=>{} },

    keydownListener: { type: Function , default : ()=>{} },

    keypressEvt: { type: Function ,  default : ()=>{} },



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
    onChange:{type: Function, Required: true},

    /**
     * Hint regarding what the field is about (it will be shown as tooltip message)
     * @type {String}
     */
    hint: { type: String, default: "" },

	  /**
	   * for show labels of the fields
	   * @type {Object}
	   */
	  labelStyle:{type:Object},
  },

  data(){
    return {

      /**
       * value of the checkbox field
       * @type {Boolean}
       */
      checked: this.value
    }
  },

  watch:{

    value(newValue,oldValue){
      this.checked = newValue
    },

    checked(newVal){
      //calls onChange method of parent component to update values
      this.onChange(newVal, this.name)
    }
  },

  components:{
    'tool-tip': ToolTip
  }

};

</script>

<style type="text/css">
.absolute {
  position: absolute;
  margin-left: 5px;
}

.check_align {
  width: 13px;
  height: 13px;
  padding: 0;
  margin:0;
  vertical-align: bottom;
  position: relative;
  top: -4px;
  margin-top: 10px !important;
  overflow: hidden;
  cursor: pointer;
}

.check_inline { display: inline; }

.check_grid { display: grid; }
</style>
