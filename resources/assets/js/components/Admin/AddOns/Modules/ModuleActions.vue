<template>

    <div class="btn-group">

         <custom-loader v-if="loading"></custom-loader>

        <status-switch 
            :name="data.option_name"
            :value="data.status"
            :key="Math.random()"
            :onChange="onChange"
        />

    </div>

</template>

<script>

import Switch from "../../../../components/MiniComponent/FormField/Switch.vue";

import {errorHandler,successHandler} from "../../../../helpers/responseHandler";

export default {

    name : 'module-actions',

    props: {
            
        data : { type : Object, required : true }
    },

    data () {

        return {

            loading : false
        }
    },

    methods: {

        onChange(value,name) {
            
            this.statusChange(value,name);
        },

        statusChange(value,name) {

            this.loading = true;

            let data = {};

            data['current_module_name'] = name;

            data['current_module_status'] = value;
            
            axios.post('/api/change/modules/status',data).then((res) => {

                this.loading = false;

                successHandler(res,'dataTableModal');
                
                window.emitter.emit('refreshData');
                
            }).catch((err) => {
                
                this.loading = false;
                
                errorHandler(err,'dataTableModal');
            })
        }
    },

    components : {
        "status-switch":Switch
    }
};
</script>