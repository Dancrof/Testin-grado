<script setup>
import { ref, onMounted } from 'vue'
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import axios from "axios";
import { errorHandler, successHandler } from "../../../../helpers/responseHandler";
import { validateIframeSettings } from "../../../../helpers/validator/validateIframeSettings"
import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
import FaveoBox from "../../../MiniComponent/FaveoBox.vue";
import {getIdFromUrl} from "../../../../helpers/extraLogics";
import Alert from "../../../MiniComponent/Alert.vue";
import Loader from "../../../MiniComponent/Loader.vue";

import { useRouter } from "vue-router";
const router = useRouter();


// Variables
const loading = ref(false);
const hasDataPopulated = ref(false);
const page_title = ref('create_new_iframe_configuration');
const radioOptions = ref([{name: 'active',value:1},{name: 'inactive',value:0}]);
const integrationTypeOptions = ref([ { name: 'Iframe Url', id: 'url' } ]);
const integration_status = ref(1);
const integration_id = ref('');
const id = ref(null);
const icon_class = ref({'icon_class' : 'fas fa-tv'});
const button_name = ref('Iframe');
const btnName = ref('save');
const iconList = ref([]);
const iconClass = ref('fas fa-save');
const integrationSettingsData = ref('');
let form = ref({
  integration_type : "",
  app_name : "",
  app_url : "",
  routes: [],
  teams: [],
  agents: [],
  departments: []
})

onMounted(() => {

    const path = window.location.pathname;

    getValues(path);

    getIconList();
  })

//Methods
const getValues = (path) => {

  const integrationId = getIdFromUrl(path);

  if (path.indexOf("edit") >= 0) {

    page_title.value = 'edit_iframe_configuration';

    iconClass.value = 'fas fa-sync-alt'

    btnName.value = 'update'

    hasDataPopulated.value = false;

    getInitialValues(integrationId);

  } else {

    loading.value = false;

    hasDataPopulated.value = true
  }
};

const getInitialValues = (integrationId) => {

  loading.value = true;

  integration_id.value = integrationId

  axios.get('/integration-details/' + integrationId).then(res=>{

    hasDataPopulated.value = true;

    loading.value = false;

    integrationSettingsData.value = res.data.data.integration;

    updateStatesWithData(integrationSettingsData.value);

  }).catch(err=>{

    loading.value = false;

    errorHandler(err, 'IframeCreateEdit');
  })
};

const updateStatesWithData = (data) => {

  integration_status.value = data.integration_status;

  form.value.app_name = data.app_name;

  form.value.app_url = data.app_url;

  form.value.departments = data.departments;

  form.value.teams = data.teams;

  form.value.agents = data.users;

  form.value.routes = data.routes;

  form.value.integration_type = data.integration_type;

  button_name.value = data.button_name;

  icon_class.value = { "icon_class": data.button_icon };
};

const getIconList = () => {

  axios.get('/json/icon-list.json').then((response) => {

    iconList.value = response.data.data;

  }).catch((error) => {

    iconList.value = [];
  })
};

const onChange = (value, name) => {

  form.value[name] = value;

  if(name === 'integration_status') {

    integration_status.value = value

  } else if(name === 'button_name') {

    button_name.value = value;

  } else if(name === 'icon_class') {

    icon_class.value = value
  }
};

const extractIds = (values) => {

  if(!values) return [];

  const arr = [];

  for(let value of values) {

    arr.push(value.id)
  }

  return arr;
};

const isValid = () => {

  const { errors, isValid } = validateIframeSettings(form.value);

  return isValid;
};

const onSubmit = () => {

  if(isValid()) {

    let data = {};

    data['integration_status'] = integration_status.value ? 1 : 0;

    data['id'] = integration_id.value;

    data['integration_type'] = form.value.integration_type;

    data['app_name'] = form.value.app_name;

    data['app_url'] = form.value.app_url;

    data['department_ids'] = extractIds(form.value.departments);

    data['team_ids'] = extractIds(form.value.teams);

    data['user_ids'] = extractIds(form.value.agents);

    data['route_ids'] = extractIds(form.value.routes);

    data['button_name'] = button_name.value;

    data['button_icon'] = icon_class.value.icon_class

    let apiUrl = integration_id.value ? '/api/integration-setting/'+integration_id.value : '/api/integration-setting';

    axios.post(apiUrl,data).then(res=> {

      loading.value = false;

      successHandler(res,'IframeCreateEdit');

      if(!integration_id.value){

        setTimeout(()=>{

          router.push({ name : 'Iframe Configuration'})
        },3000);

      } else {

        getInitialValues(integration_id.value)
      }

    }).catch(err=>{

      loading.value = false;

      errorHandler(err,'IframeCreateEdit')
    })
  }
};

</script>

<template>
  <div id="main" class="col-sm-12">

    <div class="row" v-if="!hasDataPopulated || loading">

      <Loader></Loader>
    </div>

    <Alert component-name="IframeCreateEdit"></Alert>

    <FaveoBox :title="trans(page_title)" v-if="hasDataPopulated">

      <div class="row">

        <TextField :label="trans('app_name')" :value="form.app_name" type="text" name="app_name" :onChange="onChange"
                    :placehold="lang('enter_a_value')" classname="col-sm-4" :required="true">

        </TextField>

        <StaticSelect :label="trans('integration_type')" :elements="integrationTypeOptions" name="integration_type"
                       :onChange="onChange" :value="form.integration_type" classname="col-sm-4" :required="true">

        </StaticSelect>

        <TextField :label="trans('iframe_url')" v-if="form.integration_type === 'url'" :value="form.app_url" type="text" name="app_url" :onChange="onChange"
                    :placehold="lang('enter_a_value')" classname="col-sm-4" :required="true">

        </TextField>
      </div>

      <div class="row">

        <DynamicSelect :label="trans('departments')" :hint="lang('required_at_least_one_user')" :multiple="true" name="departments" classname="col-sm-4"
                        apiEndpoint="/api/dependency/departments" :value="form.departments" :onChange="onChange"
                        :strlength="30" :required="false">

        </DynamicSelect>

        <DynamicSelect :label="trans('teams')" :multiple="true" name="teams" classname="col-sm-4"
                        apiEndpoint="/api/dependency/teams" :value="form.teams" :onChange="onChange"
                        :strlength="30" :required="false">

        </DynamicSelect>

        <DynamicSelect :label="trans('agents')" :multiple="true" name="agents" classname="col-sm-4"
                        apiEndpoint="/api/dependency/agents" :value="form.agents" :onChange="onChange"
                        :strlength="30" :required="false">

        </DynamicSelect>
      </div>

      <div class="row">

        <DynamicSelect :label="trans('routes')" :multiple="true" name="routes" classname="col-sm-4"
                        apiEndpoint="/api/get-routes" :value="form.routes" :onChange="onChange"
                        :strlength="30" :required="true">

        </DynamicSelect>

        <TextField :label="trans('button_name')" :value="button_name" type="text" name="button_name" :onChange="onChange"
                    :placehold="lang('enter_a_value')" classname="col-sm-4" :required="true">

        </TextField>

        <DynamicSelect name="icon_class" :label="trans('icon_class')" :value="icon_class" :onChange="onChange"
                        classname="col-sm-4" :elements="iconList" :multiple="false" option-label="icon_class" :required="true" :clearable="false">

        </DynamicSelect>
      </div>

      <div class="row">

        <RadioButton :options="radioOptions" :label="lang('status')" name="integration_status" :value="integration_status"
                      :onChange="onChange" classname="form-group col-sm-4"/>

      </div>

      <template #actions>

        <div class="card-footer" slot="actions">

          <button class="btn btn-primary" type="button" @click="onSubmit">

            <i :class="iconClass"> </i> {{trans(btnName)}}
          </button>

        </div>

      </template>
    </FaveoBox>

  </div>
</template>
