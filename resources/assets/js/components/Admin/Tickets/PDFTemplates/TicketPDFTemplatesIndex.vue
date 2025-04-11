<template>

    <div id="list_of_ticket_pdf_templates" class="col-sm-12">

        <alert componentName="dataTableModal"/>

        <div class="card card-light ">

            <div class="card-header">

                <h3 class="card-title">{{trans('list_of_ticket_pdf_templates')}}</h3>

                <div class="card-tools">

                    <router-link to="/ticket-pdf-template/create" class="btn-tool" v-tooltip="{content:trans('create_ticket_pdf_template'), placement:'left'}">

                        <i class="glyphicon glyphicon-plus"> </i>
                    </router-link>
                </div>
            </div>

            <div class="card-body" id="my_ticket_pdf_templates">

                <data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to="list_of_ticket_pdf_templates"></data-table>
            </div>
        </div>
    </div>
</template>

<script>

import {useStore} from 'vuex';

import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";

import {computed} from "vue";

export default {

    name : 'ticket-pdf-templates',

    description : 'Ticket PDF Templates List',

	setup() {

		const store = useStore();

		return {

			formattedTime : computed(()=>store.getters.formattedTime),

			formattedDate : computed(()=>store.getters.formattedDate)
		}
	},

    data() {

        return {

            columns: ['name', 'created_at', 'action'],

            options: {},

            apiUrl : '/api/get/pdfTemplates'
        }
    },

    beforeMount(){

        const self= this;

        this.options = {

            sortIcon: {

                base : 'glyphicon',

                up: 'glyphicon-chevron-down',

                down: 'glyphicon-chevron-up'
            },

            headings: {

              name: this.trans('name'),

              created_at : this.trans('created_date'),

              action: this.trans('actions')
            },

            columnsClasses : {

                name: 'tic-pdf-tem-name',

                created_at : 'tic-pdf-tem-created',

                action : 'tic-pdf-tem-action',
            },

            texts: { filter: '', limit: '' },

            templates: {

                created_at : function(h,row){

                    return row.created_at && row.created_at != '0000-00-00 00:00:00' ? self.formattedTime(row.created_at) : '--'
                },

                action: (f,row)=>{
					return self.h(DataTableActions,{data:row})
				}
            },

            sortable: ['name', 'created_at'],

            filterable: ['name', 'created_at'],

            pagination: { chunk:5,nav: 'fixed',edge:true },

            requestAdapter(data) {

                return {

                    'sort-field': data.orderBy ? data.orderBy : 'created_at',

                    'sort-order': data.ascending ? 'desc' : 'asc',

                    'search-query':data.query.trim(),

                    page:data.page,

                    limit:data.limit,
                }
            },

            responseAdapter({data}) {

                return {

                    data: data.data.data.map(data => {

                        data.edit_url = '/ticket-pdf-template/' + data.id + '/edit';

                        data.delete_url =  self.basePath() + '/api/delete/ticket-pdf-template/'+ data.id;

                        return data;
                    }),
                    count: data.data.total
                }
            },

	        orderBy: { column: 'created_at', ascending: true },
        }
    }
};
</script>

<style>

.tic-pdf-tem-name,.tic-pdf-tem-created,.tic-pdf-tem-action{
    max-width: 250px; word-break: break-all;
}

#my_ticket_pdf_templates .VueTables .table-responsive {
    overflow-x: auto;
}

#my_ticket_pdf_templates .VueTables .table-responsive > table{
    width : max-content;
    min-width : 100%;
    max-width : max-content;
    overflow: auto !important;
}
</style>