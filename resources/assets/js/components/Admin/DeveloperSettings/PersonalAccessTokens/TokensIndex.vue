<script setup>

import {onBeforeMount, ref, h } from "vue";

import Alert from "../../../MiniComponent/Alert.vue";
import FaveoBox from "../../../MiniComponent/FaveoBox.vue";
import Datatable from "../../../Extra/DataTable.vue";
import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";
import {lang} from "../../../../helpers/extraLogics";

import globalMixin from "../../../../mixins/globalMixin";
const { basePath } = globalMixin.methods;

import {useStore} from "vuex";
const store = useStore();

// Columns data for table
const columns = ref(['name', 'author', 'expiry_token', 'actions']);

// table options
const options = ref({});

// endpoint for fetching data
const apiUrl = '/get-api-applications';

onBeforeMount(()=>{

    options.value = {

        headings : {  name: lang('name'),
          author: lang('author'),
          expiry_token : lang('expiration_date'),
          actions: lang('actions') },

        columnsClasses : {
            name: 'token-name',
            author: 'token-author',
            expiry_token: 'token-expiry',
            actions: 'token-actions'
        },

        sortIcon: {

            base : 'glyphicon',

            up: 'glyphicon-chevron-down',

            down: 'glyphicon-chevron-up'
        },

        texts: { filter: "", limit: "" },

        templates: {

            actions: (f,row)=>{

                return h(DataTableActions,{data:row})
            },

            author: (f, row) => {

                return h('a', {

                    href: basePath()+ '/panel/user/' + row.author.id

                }, row.author.full_name);
            },

            expiry_token: (f,row) => {

                return row.expiry_token === 'never' ? 'Never' : store.getters.formattedTime(row.expiry_token);
            }
        },

        sortable: [ 'name' ],

        filterable: [ 'name' ],

        pagination: { chunk: 5, nav: "scroll" },

        requestAdapter(data) {

            return {

                'sort-field': data.orderBy ? data.orderBy : "id",

                'sort-order': data.ascending ? "desc" : "asc",

                'search-query': data.query.trim(),

                page: data.page,

                limit: data.limit
            };
        },

        responseAdapter({ data }) {

            return {

                data: data.data.data.map(data => {

                    data.edit_url = "/personal-access-token/" + data.id + '/edit';

                    data.delete_url = basePath() + "/delete-api-application/" + data.id;

					data.deleteMessage = 'are_you_sure_you_want_to_delete';

                    return data;
                }),

                count: data.data.total
            };
        },

	    orderBy: { column: 'id', ascending: true },
    }
});

</script>

<template>

    <div id="tokens-index" class="col-sm-12">

        <Alert component-name="dataTableModal"></Alert>

        <FaveoBox :title="trans('lists_of_personal_access_tokens')">

            <template #customActions>

                <div class="card-tools">

                    <router-link class="btn btn-tool pointer-cursor" to="/personal-access-token/create" v-tooltip="trans('create_personal_access_token')">

                        <i class="glyphicon glyphicon-plus"> </i>
                    </router-link>
                </div>
            </template>

            <Datatable :url="apiUrl" :dataColumns="columns" :option="options" scroll_to="tokens-index">

            </Datatable>
        </FaveoBox>
    </div>
</template>

<style>

    .token-name,.token-author, .token-expiry, .token-actions{
        max-width: 250px; word-break: break-all;
    }

    #tokens-index .VueTables .table-responsive {
        overflow-x: auto;
    }

    #tokens-index .VueTables .table-responsive > table{
        width : max-content;
        min-width : 100%;
        max-width : max-content;
        overflow: auto !important;
    }
</style>