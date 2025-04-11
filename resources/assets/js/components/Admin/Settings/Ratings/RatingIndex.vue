<template>
    <div class="col-sm-12">
        <alert componentName="dataTableModal"/>

        <faveo-box :title="lang('list_of_current_ratings')">

			<template #headerMenu>

				<div class="card-tools">
					<a id="edit-button" @click="onClickEvent" href="javascript:;">
						<span title="Edit" class="btn btn-light btn-sm"><i class="fa fa-eye"></i> {{lang('manage_auto_request_ratings')}}</span>
					</a>
					<router-link class="btn btn-tool" to="/rating/create" v-tooltip="lang('add')">
						<i class="glyphicon glyphicon-plus"></i>
					</router-link>
				</div>
			</template>

            <div class="row" id="rating-index">

                <data-table
                    :url="apiUrl"
                    :dataColumns="columns" :option="options"
                    scroll_to ="rating-index"
                    class="col-sm-12"
                />

            </div>

        </faveo-box>
        <transition  name="modal">
        <rating-modal v-if="showModal" :onClose="onClose" :showModal="showModal"></rating-modal>
    </transition>
    </div>
</template>

<script>

    import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";
	import RatingAutoRequestModal from "./RatingAutoRequestModal.vue";

    export default {
        name: 'RatingIndex',
        
        components: { 'rating-modal': RatingAutoRequestModal },

        data() {
            return {
                
                apiUrl: 'ratings-list',

                loading: false,

                columns: ['name', 'rating_scale', 'is_default', 'action'],

                showModal: false,

                options: {
                  headings: { name: this.trans('name'), rating_scale : this.trans('rating_scale'), is_default : this.trans('status'), action: this.trans('actions')},

                    sortIcon: { base : 'glyphicon', up: 'glyphicon-chevron-down',down: 'glyphicon-chevron-up' },

                    texts: { filter: '', limit: '' },

                    pagination:{ chunk:5,nav: 'fixed',edge:true },

                    sortable:  ['name', 'rating_scale'],

                    filterable:  ['name'],

                    columnsClasses : {
                        name: 'rating__name',
                        rating_scale: 'rating__scale',
                        is_default: 'ratind__active',
                        action: 'rating__action'
				    },
                },
            }
        },

        beforeMount () {
            let dynamicOptions = {
                templates: {
                    action: (f,row)=>{
						return this.h(DataTableActions,{ data : row })
					},
                    is_default: function(createElement, row) {

                        let span = this.h('span', {

                            'class' : row.is_default ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'

                        }, row.is_default ? this.trans('active') : this.trans('inactive'));

                        return this.h('a', {

                        }, [span]);
                    },
                },

                requestAdapter(data) {

                    return {

                        'sort_field' : data.orderBy ? data.orderBy : 'id',

                        'sort_order' : data.ascending ? 'desc' : 'asc',

                        'search_query' : data.query.trim(),

                        page : data.page,

                        limit : data.limit,
                    }
                },

                responseAdapter({data}) {
                    return {
                        data: data.data.map(data => {
                            data.delete_url = this.basePath() + '/delete-rating/' + data.id;
                            data.edit_url = '/rating/' + data.id + '/edit';
                            return data;
                        }),

                        count: data.total
                    }
                },

	            orderBy: { column: 'id', ascending: true },
            };

            this.options = {...this.options, ...dynamicOptions};
        },

        methods: {
            onClickEvent() {
                this.showModal = true; 
            },

            onClose() {
                this.showModal = false;
            },
        }
    }
</script>

<style>
    .rating__name {
        width: 40% !important;
        word-break: break-all;
    }

    .rating__scale {
        width: 20% !important;
        word-break: break-all;
    }

    .rating__active {
        width: 20% !important;
        word-break: break-all;
    }

    .rating__action {
        width: 20% !important;
        word-break: break-all;
    }
</style>
