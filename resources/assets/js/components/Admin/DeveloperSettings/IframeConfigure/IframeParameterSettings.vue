<script setup>
import  { ref, onMounted } from 'vue';
import { useStore } from 'vuex'
import axios from "axios";
import Alert from "../../../MiniComponent/Alert.vue";
import DynamicSelect from "../../../MiniComponent/FormField/DynamicSelect.vue";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import CustomLoader from "../../../MiniComponent/Loader.vue"
import {successHandler, errorHandler} from "../../../../helpers/responseHandler";
import {getIdFromUrl, lang} from "../../../../helpers/extraLogics";

const store = useStore();

const loading = ref(false);
const componentTitle = ref('iframe-param-config');
const faveoAttributeList = ref([]); // variable to store the list of faveo attributes
const faveoAttributesFromApi = ref([]); //variable to store the attributes fetched from api
const showAddMoreOption = ref(true); // boolean whether to show `add more` button or not
const integrationId = ref(null);
const type = ref('ticket');
const rows = ref([
  {
    id: 1,
    faveoAttribute: "faveo_attribute_1",
    customAttribute: "custom_attribute_1",
    customAttributeValue: "",
    faveoAttributeValue: "",
  },
]); // default row

//function to filter the faveo attributes, i.e. remove the already selected attributes from the list
const filterFaveoAttributes = () => {
  const alreadySelected = rows.value.map(item => item.faveoAttributeValue?.id);

  faveoAttributeList.value = faveoAttributesFromApi.value.filter((attribute) => {
    return !alreadySelected.includes(attribute.id);
  });
  showAddMoreOption.value = faveoAttributeList.value.length > 0;
}

//function to handle the change event of the input fields
const onChange = (value, name) => {

  const index = name.replace(/[^0-9]/g, '') - 1;

  if (name.includes("faveo_attribute_")) {
    rows.value[index].faveoAttributeValue = value;
    rows.value[index].isDeleteAble = index > 0;
  }

  if (name.includes("custom_attribute_")) {
    rows.value[index].customAttributeValue = value;
    rows.value[index].isDeleteAble = index > 0;
  }

  filterFaveoAttributes();
};

const switchTab = (tab) => {

  store.dispatch("unsetValidationError");

  type.value = tab;
  loading.value = true;
  rows.value = [
    {
      id: 1,
      faveoAttribute: "faveo_attribute_1",
      customAttribute: "custom_attribute_1",
      customAttributeValue: "",
      faveoAttributeValue: "",
    },
  ];

  getMappings();
};

//function to add new rows when `add new` button is clicked
const addNewRow = (faveoAttributeValue = null, customAttributeValue = null, id = null) => {

  store.dispatch('unsetValidationError');

  const index = rows.value.length + 1;

  rows.value.push({
    id: id ?? index,
    faveoAttribute: "faveo_attribute_" + index,
    customAttribute: "custom_attribute_" + index,
    faveoAttributeValue: faveoAttributeValue,
    customAttributeValue: customAttributeValue,
    isDeleteAble: rows.value.length > 0,
  });

  // Update `isDeleteAble` for all rows dynamically
  rows.value.forEach((row) => {
    row.isDeleteAble = rows.value.length > 1;
  });
};

//function to delete the mapping
const deleteMapping = (id) => {
  rows.value = rows.value.filter((row) => row.id !== id);
  rows.value.forEach((row) => {
    row.isDeleteAble = rows.value.length > 1;
  });
  if (rows.value.length === 1) {
    rows.value[0].isDeleteAble = false;
  }

  if (rows.value.length === 0) {
    rows.value = [
      {
        id: 1,
        faveoAttribute: "faveo_attribute_1",
        customAttribute: "custom_attribute_1",
        customAttributeValue: "",
        faveoAttributeValue: "",
      },
    ];
  }

  filterFaveoAttributes();
};

//function to fetch the data from the backend
const getMappings = () => {

  loading.value = true;

  let data = type.value === 'user' ? 'requester' : type.value;

  axios.get("/api/get-attributes/"+integrationId.value+'?category='+data).then(res => {

    loading.value = false;

    faveoAttributeList.value = res.data.data.faveo_attributes;

    faveoAttributesFromApi.value = res.data.data.faveo_attributes;

    if (!res.data.data.mappings.length) return;

    rows.value = [];

    res.data.data.mappings.forEach((data) => {
      addNewRow(data.faveo_attribute, data.custom_attribute, data.id);
    });

    if (rows.value.length === 1) {
      rows.value[0].isDeleteAble = false;
    }

    filterFaveoAttributes();

  }).catch(err => {

    errorHandler(err, componentTitle.value);
  })
};

//function to submit the mappings
const submitMappings = () => {

  store.dispatch("unsetValidationError");

  loading.value = true;

  const mappings = [];

  rows.value.forEach((row) => {

    mappings.push({
      custom_attribute: row.customAttributeValue,
      faveo_attribute: row.faveoAttributeValue?.id,
    });

  });

  let data = {};
  data['integration_id'] = integrationId.value;
  data['category'] = type.value === 'user' ? 'requester' : type.value;
  data['mappings'] = mappings;

  axios.post("/api/set-attributes", data).then(res => {

    loading.value = false;

    successHandler(res, componentTitle.value);

    getMappings();

  }).catch(err => {

    if(err.response) {

      errorHandler(err, componentTitle.value);
    }

    loading.value = false;
  })
};

onMounted(() => {

  integrationId.value = getIdFromUrl(window.location.pathname);

  getMappings();
});
</script>

<template>
  <div class="col-sm-12">
    <Alert :componentName="componentTitle" />

    <div class="row" v-if="loading">
      <CustomLoader :duration="4000"></CustomLoader>
    </div>

    <div class="card card-light card-tabs" v-if="!loading">

      <div class="card-header p-0 pt-1 card-tabs">
        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
          <li class="nav-item">
            <a id="settings_tab" class="nav-link" :class="{ active: type === 'ticket' }" @click="switchTab('ticket')">
              {{ lang('ticket') }}
            </a>
          </li>
          <li class="nav-item">
            <a id="settings_tab" class="nav-link" :class="{ active: type === 'user' }" @click="switchTab('user')">
              {{ lang('user_tab') }}
            </a>
          </li>
        </ul>
      </div>

      <div class="card-body">
        <div class="card card-light cardbottom">
          <div class="card-header">
            <h3 class="card-title">{{ lang('attribute_mappings') }}</h3>
          </div>

          <div class="card-body">


            <div v-for="(row, index) in rows" :key="index" class="row">
              <!-- Custom Attribute Field -->
              <TextField :label="lang('third_party_keys')" :hint="lang('third_party_tooltip')"
                         :name="row.customAttribute" :value="row.customAttributeValue" classname="col-md-5"
                         :onChange="onChange" :required="true">

              </TextField>

              <!-- Faveo Attribute Field -->
              <DynamicSelect :label="lang('faveo_values')" :hint="lang('faveo_value_tooltip')" :elements="faveoAttributeList"
                             :name="row.faveoAttribute" :value="row.faveoAttributeValue" classname="col-md-5"
                             :onChange="onChange" :required="true">

              </DynamicSelect>

              <!-- Delete Button -->
              <div class="col-md-2">

                <button v-if="rows.length > 1" v-tooltip="lang('delete_attribute')" type="button" class="btn btn-light table_btn"
                        @click="deleteMapping(row.id)">

                  <i class="fa fa-trash" aria-hidden="true"></i>
                </button>
              </div>

            </div>

            <a v-if="showAddMoreOption" href="javascript:;" @click="addNewRow(null, null)" v-tooltip="lang('add_new_attribute')">
              <i class="fas fa-plus-circle"></i>
              {{ lang('add_new') }}
            </a>

          </div>

          <div class="card-footer">
            <button class="btn btn-primary" @click="submitMappings()" :disabled="loading">
              <i class="fas fa-save"></i> {{ lang('save') }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
#settings_tab {
  cursor: pointer;
  margin-bottom: -1px;
}
.table_btn{
  margin-top: 28px!important;
}
</style>