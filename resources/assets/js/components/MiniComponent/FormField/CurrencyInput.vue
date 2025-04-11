<template>

    <form-field-template :label="label" :labelStyle="labelStyle" :name="name"  :classname="classname" :hint="hint" 
        :required="required">
        <span class="inline" >
                
            <input class="form-control" :style="formStyle"
                :type="type"
                id="number"
                v-model="changedValue"
                v-on:input="onChange(changedValue, name)"
                @keypress="checkValue"  
                @paste="onPaste"
                min="1"
                @blur="focusOut" @focus="focusIn"
                :placeholder="placeholder"
            /> 
        </span>
    </form-field-template>

</template>

<script type="text/javascript">

    import FormFieldTemplate from "./FormFieldTemplate.vue";

    export default {
        name:'time-field',

        description:'time field component along with error block',

        props:{

            label: { type: String, required: true },

            hint: { type:String, default: '' }, //for tooltip message

            value: { required: true },

            name: { type: String, required: true },

            type: {type: String, default: 'text'},

            onChange:{type: Function, Required: true},

            classname : {type: String, default:''},

            required: { type: Boolean, default: false},

            labelStyle:{type:Object},

            formStyle:{type:Object},

            max : { type : [String, Number], default :''},

            placeholder : { type : String, default : ''},

            from : { type : String, default : '' }

        },
        data(){
            return {
                
                
                changedValue: this.value,

                currencyValue : this.value
            }
        },

        created() {
            
            window.emitter.on('removeVal',this.initialState)
        },

        mounted(){

            this.changedValue = this.value;
            
            this.currencyValue = this.value;

            this.focusOut();
        },

        watch: {
            
            value(newVal) {
            
                this.changedValue = newVal;
            
                this.currencyValue = newVal;
            }
        },


        methods:{

            focusOut: function() {

                // // Recalculate the currencyValue after ignoring "$" and "," in user input
                this.currencyValue = parseFloat(this.changedValue.replace(/[^\d\.]/g, ""))
                
                // Ensure that it is not NaN. If so, initialize it to zero.
                // This happens if user provides a blank input or non-numeric input like "abc"
                if (isNaN(this.currencyValue)) {
                    this.currencyValue = 0
                }
                
                // Format display value based on calculated currencyValue
                
                this.changedValue = new Intl.NumberFormat().format(this.changedValue);

                this.changedValue = this.changedValue == 0 ? '' : this.changedValue;
            },
            
            focusIn: function() {

                // Unformat display value before user starts modifying it
                this.changedValue = this.currencyValue.toString();

                this.changedValue = this.changedValue == 0 ? '' : this.changedValue;
            },

            checkValue ($event) {
               
               let keyCode = ($event.keyCode ? $event.keyCode : $event.which);

               // only allow number and one dot
               if ((keyCode < 48 || keyCode > 57) && (keyCode !== 46 || this.changedValue.indexOf('.') != -1)) { // 46 is dot
               
                $event.preventDefault();
               }

               // restrict to 2 decimal places
               if(this.changedValue!=null && this.changedValue.indexOf(".")>-1 && $event.target.selectionStart > this.changedValue.indexOf(".") && (this.changedValue.split('.')[1].length > 1)){
                
                $event.preventDefault();
               }
            },

            /**
             * method for check values on paste 
             * @return {Boolean}
             */
            onPaste(evt) {

                evt = (evt) ? evt : window.event;
                
                if (evt.clipboardData.getData('Text').match(/[^\d]/)) {
                    
                    evt.preventDefault();
                }   
            },

            /**
             * initial state of the data
             * @return {Void}
             */
            initialState(){
                this.changedValue = 0;
                this.changedValue = this.changedValue == 0 ? '' : this.changedValue;
            }
        },
        components:{
            'form-field-template' : FormFieldTemplate
        }
    };

</script>

<style scoped>
    .inline {
        display:inline;
    }
    .form-control {
        display:inline !important;
    }
</style>