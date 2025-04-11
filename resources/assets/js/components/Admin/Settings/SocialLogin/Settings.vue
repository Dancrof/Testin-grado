<template>
    <div class="col-sm-12">
        
        <alert componentName="Settings" />

        <div class="row" v-if="loading">

			<custom-loader :duration="4000"></custom-loader>	

		</div>

        <div v-else>

            <div class="card card-light">

                <div class="card-header">
                    
                    <h3 class="card-title">  {{ lang(this.displayedProviderName) }} {{lang('settings')}} </h3>
                </div>

                <div class="card-body">

                    <div class="row" v-focus-first-input>

                        <text-field id="client-id" :label="lang('client-id')" :value="client_id" type="text" name="client_id" :onChange="onChange" :placehold="lang('enter_a_value')"
                            classname="col-sm-6" :required="true">
                        
                        </text-field>

                        <text-field id="client-secret" :label="lang('client-secret')" :value="client_secret" type="text" name="client_secret" :onChange="onChange" :placehold="lang('enter_a_value')"
                            classname="col-sm-6" :required="true">
                        
                        </text-field>

                    </div>

                    <div class="row">

                        <text-field id="redirect-url" :label="lang('redirect-url')" :value="redirect" type="text" name="redirect" :onChange="onChange" :placehold="lang('enter_a_value')"
                            classname="col-sm-6" :required="true">
                        
                        </text-field> 

                        <radio-button :options="radioOptions" :label="trans('activate_login_via') + ' ' + lang(providerName)" name="status" :value="status"
                                    :onChange="onChange" classname="form-group col-sm-6" ></radio-button>
                    </div>
                </div>

                <div class="card-footer">

                    <button id="submit_btn" class="btn btn-primary" @click="onSubmit()">
                        <i :class="iconClass"></i> {{lang(btnName)}}
                    </button>
                </div>
            </div>
        </div>
    
    </div>
</template>

<script>

import {successHandler,errorHandler} from "../../../../helpers/responseHandler";

import axios from 'axios';

import { validateSettingSocialLogin } from  '../../../../helpers/validator/settingSocialLogin.js';
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    
export default {
    
    name : 'settings',

    description : 'settings component',

    data(){

        return{
            loading: false,

            providerName: 'facebook',

            iconClass : 'fas fa-save',

            btnName : 'save',

            client_id: '',

            client_secret: '',

            redirect: '',

            status : 1,

            radioOptions:[{name:'yes',value:1},{name:'no',value:0}],
        }
    },
  computed:{
    displayedProviderName() {
      return this.providerName === 'linkedin-openid' ? 'LinkedIn' : this.providerName;
    }
  },

    beforeMount(){

        const self = this;

        const path = window.location.pathname;
        
        this.getValues(path);

    },
        
    methods:{

        getValues(path){

            let str = path.split("/");

            this.providerName = str[str.length-1];

            this.getInitialValues();
            
        },

        getInitialValues(){
            
            axios.get('/api/admin/social/media-settings/'+this.providerName).then(res=>{
                
                this.status = res.data.data.status;
                this.client_id = res.data.data.client_id ? res.data.data.client_id : '';
                this.client_secret = res.data.data.client_secret ? res.data.data.client_secret : '';
                this.redirect = res.data.data.redirect;
            
            }).catch(error=>{
                
                console.log( error );
                // errorHandler(error,'settings')

            });
            
        },
        onChange(value, name) {

            this[name] = value;

            if(value === null){

                this[name] = '';
            }
        },

        isValid() {

            const { errors, isValid } = validateSettingSocialLogin(this.$data);
            
            if (!isValid) {
            
                return false;
            }
            return true;
        },

        onSubmit(){

            if(this.isValid()){

                this.loading = true;
                 
                var fd = new FormData();
                
                fd.append('provider_name', this.providerName)
                fd.append('client_id', this.client_id)
                fd.append('client_secret', this.client_secret)
                fd.append('redirect', this.redirect)
                fd.append('status', this.status)
                fd.append('_method','PATCH')
                const config = { headers: { 'Content-Type': 'multipart/form-data' } }
                
                axios.post('/api/admin/social/media-update', fd,config).then(res => {
                    
                    this.loading = false;
                    
                    successHandler(res,'Settings')

                }).catch(err => {
                    this.loading = false
                    
                    errorHandler(err, 'Settings')
                });
            }
        }
    },

    components : {

        "text-field": TextField,

        "radio-button": RadioButton,
    }
}
</script>