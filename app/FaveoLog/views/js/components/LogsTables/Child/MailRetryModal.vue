<template>

    <modal v-if="showModal" :showModal="showModal" :onClose="onClose"
           :containerStyle="containerStyle">

        <template #title>

            <h4 class="modal-title">{{lang('retry')}}</h4>
        </template>

        <template #fields>

            <div v-if="!loading">
                    <span>
                        {{lang('are_you_sure')}}
                    </span>
            </div>

            <div v-if="loading" class="row">

                <reuse-loader :animation-duration="4000" color="#1d78ff"/>
            </div>
        </template>

        <template #controls>

            <button type="button" id="submit_btn" @click="onSubmit()" class="btn btn-primary" :disabled="isDisabled">

                <i class="fas fa-redo" aria-hidden="true"></i> {{lang('retry')}}
            </button>
        </template>
    </modal>
</template>

<script>

import {errorHandler,successHandler} from "../../../../../../../resources/assets/js/helpers/responseHandler";

import axios from 'axios'

export default {

    name : 'retry-modal',

    props:{

        showModal:{type:Boolean,default:false},

        onClose:{type: Function},

        data : { type : Object }
    },

    data:()=>({

        isDisabled:false,

        containerStyle:{ width:'500px' },

        loading:false,
    }),

    methods:{

        onSubmit(){

                this.loading = true

                this.isDisabled = true

                axios.get('/retry/mail-log/'+ this.data.id).then(res=>{

                    this.loading = false

                    this.isDisabled = false

                    successHandler(res,'dataTableModal');

                    window.emitter.emit('mailLogsrefreshData');
                    
                    window.emitter.emit('retryLogActionPerformed');

                    this.onClose();

                }).catch(err => {

                    this.loading = false

                    this.isDisabled = false

                    errorHandler(err,'dataTableModal')
                })
            }
    },
};
</script>