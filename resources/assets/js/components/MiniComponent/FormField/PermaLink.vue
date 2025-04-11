<template>

    <form-field-template :label="label" :labelStyle="labelStyle" :name="name" :classname="classname" :hint="hint" :required="required">

          <p class="row">
            <span id="edit_slug" class="col-md-12">

              <span v-if="!showLink">{{ textVal }}</span>

              <span v-tooltip="linkAdd" v-if="showLink">{{ textVal }}{{ subString(linkVal, 16, 16) }}</span>

              <input class="form-control"
                     :type="type"
                     v-model="changedValue"
                     v-on:input="onChange(changedValue, name)"
                     :placeholder="placehold"
                     :maxlength="max"
                     :style="fieldStyle"
              />

              <span v-if="showBtn" id="edit_slug">
			          <button class="btn btn-light btn-xs" @click="showField()">
			            <i class="fas fa-pencil-alt"></i>&nbsp;{{lang('edit')}}
			          </button>
              </span>

              <span v-if="!showBtn" id="edit_slug">
              <button class="btn btn-light" @click="hideField()">
                <i class="fas fa-check"></i>&nbsp;{{lang('ok')}}
              </button>
            </span>
            </span>

          </p>
          

    </form-field-template>

</template>

<script type="text/javascript">
import FormFieldTemplate from "./FormFieldTemplate.vue";

export default {
  name: "text-field",

  description: "text field component along with error block",

  props: {
    /**
     * the label that needs to be displayed
     * @type {String}
     */
    label: { type: String, required: true },

    /**
     * Hint regarding what the field is about (it will be shown as tooltip message)
     * @type {String}
     */
    hint: { type: String, default: "" }, //for tooltip message

    /**
     * selected value of the field.
     * list of already selected element ids that has to be displayed
     * @type {Number|Boolean}
     */

    value: { type: [String,null], required: true },

    /**
     * the name of the state in parent class
     * @type {String}
     */
    name: { type: String, required: true },

    /**
     * Type of the text field. Available options : text, textarea, password, number
     * @type {String}
     */
    type: { type: String, default: "text" },

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
     * classname of the form field. It can be used to give this component any bootstrap class or a custom class
     * whose css will be defined in parent class
     * @type {String}
     */
    classname: { type: String, default: "" },

    /**
     * Whether the given field is required or not.
     * If passed yes, an asterik will be displayed after the label
     * @type {Boolean}
     */
    required: { type: Boolean, default: false },

    length: {type: [Number,String], default: 2000},

    /**
    * for show labels of the fields
    * @type {Object}
    */
    labelStyle:{type:Object},

    placehold : { type: String, default : ''},

    max : { type : [Number, String] , default : 250},

    link : { type :  String , default :''},

    disabled : { type : Boolean, default : false },

    updateSlug : { type : Function },

    from : { type : String, default : '' }

  },
  data() {
    return {
      /**
       * The updated value in the text field
       * @type {String}
       */
      changedValue: this.value,

      linkVal : this.link,

      base : window.axios.defaults.baseURL,

      fieldStyle : { display : 'none !important'},

      showBtn : true,

      textVal : '',

      showLink : true
    };
  },

  computed: {

    linkAdd() {
      return this.textVal + this.linkVal;
    }
  },

  mounted() {
    this.changedValue = this.value;
    this.textVal = this.from === 'category' ? this.basePath() + '/category-list/' : this.basePath() +'/show/'
  },

  /**A watcher metod has been added since at firt the changevalue is empty and fetch the data accordingly
   * we need a watcher to update it with new value
   * @type {String}
   */
  watch: {
    value(newValue,oldValue) {

      this.changedValue = newValue;

      var regex = newValue.replace(/[^\w\s-]/gi, '').toLowerCase();
      
      var regex1 = regex.replace(/_+/g,'')
      
      this.linkVal = regex1.replace(/\s+/g,"-");
    },
  },

  methods:{
    showField(){
      this.showLink = false;
      this.fieldStyle.display = 'block !important';
      this.showBtn = false;
    },
    hideField(){
      this.fieldStyle.display = 'none !important';
      this.showLink = true;
      this.showBtn = true;
       this.updateSlug(this.linkVal);
    },
    subString(name, count, suffixCount) {
      if (!name || typeof name !== 'string') return '';

      const nameLength = name.length;

      // If the total length of count and suffixCount exceeds or matches the length of the string
      if (count + suffixCount >= nameLength) {
        return name; // Return the whole string without any ellipsis
      }

      // Extract the start and end substrings
      const startSubString = name.substring(0, count);
      const endSubString = name.substring(nameLength - suffixCount, nameLength);

      return `${startSubString}...${endSubString}`;
    }
  },

  components: {
    "form-field-template": FormFieldTemplate
  }
};
</script>

<style scoped>
#edit_slug{
  word-break: break-all;
  display: flex;
  align-items: center;
  gap: 7px;
}

#edit_slug .form-control{
  width: 250px;
}

.mt_2 { margin-top: 2px; }
</style>
