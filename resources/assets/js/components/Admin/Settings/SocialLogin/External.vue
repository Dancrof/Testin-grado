<template>
    <div class="col-sm-12">

        <alert componentName="External" />

        <div class="row" v-if="loading">

			<custom-loader :duration="4000"></custom-loader>	

		</div>
        <div v-else>

            <div class="card card-light">

                <div class="card-header">
                    
                    <h3 class="card-title">  {{ lang(this.providerName) }} Settings</h3>
                </div>

                <div class="card-body">

                    <div class="row">

                        <radio-button 
                            :options="radioOptionsAllowLogin" 
                            :label="lang('allow_external_login')" 
                            name="allow_external_login" 
                            :value="allow_external_login"
                            :onChange="onChange" 
                            classname="form-group col-sm-6" 
                            :hint="lang('allow_external_login_tooltip')"></radio-button>
                        <radio-button 
                            :options="radioOptionsAllowUser" 
                            :label="lang('allow_users_to_access_system_url')" 
                            name="allow_users_to_access_system_url" 
                            :value="allow_users_to_access_system_url"
                            :onChange="onChange" 
                            classname="form-group col-sm-6" 
                            :hint="lang('allow_users_to_access_system_url_tooltip')"></radio-button>
                    </div>

                    <div class="row">

                        <text-field id="client-id" :label="lang('validation_api_parameter')" :value="validate_api_parameter" type="text" name="validate_api_parameter" :onChange="onChange" :hint="lang('validation_api_parameter_tooltip')"
                            classname="col-sm-6" :disabled="allow_external_login == 0" :required="true">
                        
                        </text-field>

                        <text-field id="client-secret" :label="lang('validation_api_url')" :value="validate_token_api" type="text" name="validate_token_api" :onChange="onChange" :hint="lang('validation_api_url_tooltip')"
                            classname="col-sm-6" :disabled="allow_external_login == 0" :required="true">
                        
                        </text-field>

                    </div>

                    <div class="row">

                        <text-field id="redirect-url" :label="lang('redirect-url')" :value="redirect_unauthenticated_users_to" type="text" name="redirect_unauthenticated_users_to" :onChange="onChange" :hint="lang('user_redirection_url_tooltip')"
                            classname="col-sm-6" :disabled="allow_external_login == 0" :required="true">
                        
                        </text-field> 

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

import { successHandler, errorHandler} from "../../../../helpers/responseHandler";

import axios from 'axios';

import { validateExternalSettingSocialLogin } from "../../../../helpers/validator/externalSettingSocialLogin";

export default {
    
    name : 'settings',

    description : 'settings component',

    data(){

        return{

            loading: false,

            providerName: 'facebook',

            iconClass : 'fas fa-save',

            btnName : 'save',

            validate_api_parameter: '',

            validate_token_api: '',

            redirect_unauthenticated_users_to: '',

            allow_external_login : 1,

            allow_users_to_access_system_url: 1,

            radioOptionsAllowLogin:[{name:'Yes',value:1},{name:'No',value:0}],

            radioOptionsAllowUser:[{name:'Yes',value:1},{name:'No',value:0}],
        }
    },

    beforeMount(){

        const self = this;

        const path = window.location.pathname;
        
        this.getValues(path);

    },
        
    methods:{
        
        isValid() {
            
            const { errors, isValid } = validateExternalSettingSocialLogin(this.$data);

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
                fd.append('allow_external_login', this.allow_external_login)
                fd.append('allow_users_to_access_system_url', this.allow_users_to_access_system_url)
                fd.append('validate_api_parameter', this.validate_api_parameter)
                fd.append('validate_token_api', this.validate_token_api)
                fd.append('redirect_unauthenticated_users_to', this.redirect_unauthenticated_users_to)
                fd.append('_method','PATCH')
                const config = { headers: { 'Content-Type': 'multipart/form-data' } }
                
                axios.post('/api/admin/social/media-update', fd,config).then(res => {
                    
                    this.loading = false
                    
                    successHandler(res,'External')

                }).catch(err => {
                    this.loading = false
                    
                    errorHandler(err, 'External')
                });
    
            }
        },

        checkStatus(){
            if( this.radioOptionsAllowLogin === 0 ){
                return true;
            }else {
                return false;
            }
        },

        getValues(path){

            let str = path.split("/");

            this.providerName = str[str.length-1];

            this.getInitialValues();
            
        },

        getInitialValues(){
            
            axios.get('/api/admin/social/media-settings/'+this.providerName).then(res=>{

                this.validate_api_parameter = res.data.data.validate_api_parameter;

                this.validate_token_api = res.data.data.validate_token_api;

                this.allow_external_login  = res.data.data.allow_external_login,

                this.allow_users_to_access_system_url = res.data.data.allow_users_to_access_system_url,

                this.redirect_unauthenticated_users_to = res.data.data.redirect_unauthenticated_users_to

            }).catch(error=>{
                
                console.log( error );

            });
            
        },
        onChange(value, name) {

            this[name] = (value === null) ? '' : value
        },
    },

    components : {

        'alert' : require('components/MiniComponent/Alert'),

        'custom-loader' : require('components/MiniComponent/Loader'),

        "text-field": require("components/MiniComponent/FormField/TextField"),

        "radio-button": require("components/MiniComponent/FormField/RadioButton"),
    }
}
</script>