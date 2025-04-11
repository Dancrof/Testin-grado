<template>

    <div class="col-sm-12">

        <alert componentName="template-set-list-index"/>

        <div class="card card-light ">

            <div class="card-header">

                <h3 id="template-set-index" class="card-title">{{trans('list_of_templates_sets')}}</h3>

                <div class="card-tools">

                  <a href="javascript:;" class="btn-tool dropdown-toggle" data-bs-toggle="dropdown">

                    <i class="glyphicon glyphicon-plus"> </i>
                  </a>

                  <div class="dropdown-menu dropdown-menu-right" role="menu" v-show="showDrop">

                    <a class="dropdown-item pointer-cursor" v-tooltip="trans('clone_language_set')" @click="toggleModal">

                      <i class="glyphicon glyphicon-plus"> </i>&nbsp;{{trans('clone_language_set')}}
                    </a>
                    <hr class="m-0">
                    <a class="dropdown-item pointer-cursor" v-tooltip="trans('create_translated_set')" @click="toggleTranslateModal">

                      <i class="fas fa-language"> </i>&nbsp;{{trans('create_translated_set')}}
                    </a>

              </div>
                </div>
            </div>

            <div class="card-body" id="template-set-list">
                <data-table :url="apiUrl" :dataColumns="columns" :option="options" scroll_to ="template-set-index"/>
            </div>
        </div>
        <transition name="modal">
          <template-set-create-modal v-if="showModal" :showModal="showModal" :onClose="onClose" :languages="languages" :apiUrl="apiUrl"></template-set-create-modal>
        </transition>

      <transition name="modal">
        <template-translation-set-create-modal v-if="showTranslateModal" :showTranslateModal="showTranslateModal" :onClose="onClose" :languages="languages" :apiUrl="apiUrl"></template-translation-set-create-modal>
      </transition>

    </div>
</template>

<script>

    import axios from 'axios'

	import {useStore} from "vuex";
	import {computed} from "vue";
	import DataTableActions
		from "../../../../../../resources/assets/js/components/MiniComponent/DataTableComponents/DataTableActions.vue";
	import TemplateSetCreateModal from "./TemplateSetCreateModal.vue";
    import TemplateTranslationSetCreateModal from "./TemplateTranslationSetCreateModal.vue";

    export default {
        name : 'template-set-list-index',
		setup(){

			const store = useStore()

			return {

				formattedTime : computed(()=> store.getters.formattedTime)
			}
		},
        data() {
            return {
                apiUrl : 'notify/api/template-sets',
                plugin : null,
                channel: null,
                columns: [ 'name', 'active', 'template_language', 'department', 'actions'],
                showModal : false,
                showTranslateModal : false,
                languages: [],
                options: {},
                showDrop: false
            }
        },

        beforeMount() {

            const self = this;
            let locationURL = new URL(location.href);
            this.plugin = locationURL.searchParams.get('plugin');
            let workingURL  = locationURL.pathname.substring(0,locationURL.pathname.lastIndexOf('/'));
            this.channel = workingURL.substring(workingURL.lastIndexOf('/')+1);
            this.apiUrl = this.apiUrl+'?channel='+this.channel;
            this.getLanguagesMenu();
            this.options = {

                sortIcon: {

                    base : 'glyphicon',

                    down: 'glyphicon-chevron-up',

                    up: 'glyphicon-chevron-down'
                },

              headings : {
                name : this.trans('name'),
                active : this.trans('status'),
                template_language : this.trans('language_code'),
                department : this.trans('department'),
                actions : this.trans('actions')
              },


              columnsClasses : {
                    name : 'template-list-name',
                    active : 'template-list-active',
                    template_language : 'template-list-language',
                    department : 'template-list-department',
                    actions : 'template-list-actions'
                },

                texts: { filter: '', limit: ''},

                templates: {
                    active : function(createElement, row) {

                        let span = self.h('span', {

                            'class' : row.active ? 'btn btn-success btn-sm pointer_normal' : 'btn btn-danger btn-sm pointer_normal'

                        }, row.active ? 'Active' : 'Inactive');

                        return self.h('a', {
                                class:'pointer_normal'
                        }, [span]);
                    },

                    department(h,row) {

                        return row.department ? row.department.name : '--'
                    },
                    actions : (f,row) =>{
						return self.h(DataTableActions,{data:row})
					}
                },

                sortable:  [ 'name', 'active', 'template_language'],

                filterable:  ['name', 'template_language'],

                pagination: { chunk:5,nav: 'fixed', edge:true },

                requestAdapter(data) {
                    return {

                        'sort-field' : data.orderBy ? data.orderBy : 'id',

                        'sort-order' : data.ascending ? 'desc' : 'asc',

                        'search-query' : data.query.trim(),

                        page : data.page,

                        limit : data.limit,
                    }
                },

                responseAdapter({data}) {

                    return {

                        data: data.data.data.map(data => {

                            data.status_toggle_url = self.basePath() + '/notify/api/template-sets/change-status/' + data.id;
                            data.view_url = '/notify/manage/channels/'+self.channel+'/template-sets/' + data.id +'/templates'+((self.plugin)?'?plugin='+self.plugin:'');
                            data.delete_url = self.basePath() + '/notify/api/delete-template-sets/' + data.id;
                            data.active_status = data.active;
                            data.alertComponentName = "template-set-list-index";
                            return data;
                        }),

                        count: data.data.total
                    }
                },

	            orderBy: { column: 'id', ascending: true }
            }

      setTimeout(()=>{

      this.showDrop = true;
    },1000);
    },

        methods: {
            toggleModal() {
                this.showModal = !(this.showModal);
            },

            toggleTranslateModal() {
                this.showTranslateModal = !(this.showTranslateModal);
            },

            onClose() {
                this.showModal = false;
              this.showTranslateModal = false;
            },

            getLanguagesMenu()
            {
                axios.get('api/dependency/languages?meta=true').then(res => {
                    this.languages = res.data.data.languages.map(function(value, index){
                        return {"name":value.name+' ('+value.translation+')', "value": value.locale};
                    });
                }).catch(err => {
                });
            },
        },

        components : {
          "template-translation-set-create-modal" :TemplateTranslationSetCreateModal,
            "template-set-create-modal" : TemplateSetCreateModal
        }
    };
</script>
<style scoped>
.pointer-cursor{
  cursor: pointer                                                                                                                                                                                                                         ;
}
</style>