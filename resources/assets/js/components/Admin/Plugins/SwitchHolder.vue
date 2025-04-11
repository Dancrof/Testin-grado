<template>

    <div class="btn-group">

        <status-switch 
            :name="data.path"
            :value="data.status"
            :key="Math.random()"
            :onChange="onChange"
        />

    </div>

</template>

<script>

import Switch from "../../../components/MiniComponent/FormField/Switch.vue";
import { errorHandler, successHandler } from "../../../helpers/responseHandler";

export default {
    components : {
        "status-switch":Switch
    },
    props:['data'],

    methods: {

        onChange(value,name) {
            this.statusChange(name);

        },
        statusChange(name) {
            axios.post('plugin/status/'+name)
            .then((res) => {
                successHandler(res,'dataTableModal');
                setTimeout(()=>{
                    window.emitter.emit('refreshData');
                    window.emitter.emit('updateSideNav');
                },10);

				if(['ServiceDesk','DataArchive','EleaAssistant','AttachmentScanner'].includes(name)) {
					location.reload();
				}
            })
            .catch((err) => {
                errorHandler(err,'dataTableModal');
            })
        }
    }

}
</script>