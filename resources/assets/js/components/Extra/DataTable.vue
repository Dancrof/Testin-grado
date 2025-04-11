<template>
	<div class="datatable">
		
		<div v-if="showTable" class="row float-end me-0 mb-3">
			
			<template v-if="option.filterable">
				
				<input type="text" class="form-control globe-search" v-model="search_str"
				       @keyup.enter="checkFile()" :style="inputStyle" :placeholder="lang('type_and_enter_to_search')">
			</template>
		</div>
		
		<v-server-table v-if="showTable" ref="table" :url="endPoint" :columns="columnArray" :options="optionsObject" @error="onError" :name="scroll_to" @loaded="onLoaded" :style="styleObj" :key="counter">

            <template #id="{row}">

                <input type="checkbox" @change="unmarkAll()" :value="scroll_to === 'plugins-list' ? row.path : row.id"
                       :disabled="scroll_to === 'plugins-list' ? (row.is_update === null || row.license_status === 0 || row.is_update === 2) : false" v-model="markedRows">
            </template>

            <template v-if="isLoading && !disableLoader" #afterTable>

                <custom-loader loaderType='clip-loader' :color="color"></custom-loader>
            </template>
		</v-server-table>

		<div v-if="!showTable && error_message" class="callout callout-danger bg-danger">
			
			<p><i class="fa fa-exclamation-triangle"> </i> {{lang(error_message)}}</p>
		</div>

		<div v-if="loading && !disableLoader" class="row faveo-datatable-loader">
			
			<loader :animation-duration="4000" :color="color" :size="60"/>
        </div>


        <div class="pagination-container">

            <div v-if="showTable && !loading && show_pagination">

	            <template v-if="total == 1">{{trans('one_record')}}</template>

	            <template v-if="total > 1 && total <= 10">{{ total }} {{trans('records')}}</template>

	            <template v-if="total > 10">{{trans('showing')}} {{ from }} to {{ to }} of {{ total }} {{trans('records')}}</template>
            </div>

            <div v-if="showTable && !loading && show_pagination && total > 10" class="float-end mr-0 pt-2">

                <simple-pagination :panel="panel" :btnStyle="btnStyle" :next_page="next_page" :prev_page="prev_page" :onPagination="onPagination">

                </simple-pagination>
            </div>
        </div>
    </div>
</template>

<script>

	import { errorHandler } from '../../helpers/responseHandler';

    import {ServerTable, EventBus} from 'v-tables-3';

    if(window.app){

        app.use(ServerTable);
    }

    import PageLoader from '../../components/Client/Pages/ReusableComponents/Loader.vue';

	import SimplePagination from "../Common/SimplePagination.vue";
	export default {

		name:'datatable',

		description:'Datatable that handles formatting queries in a way that it makes it easy to integrate with external APIs',

		props:{

			/**
			 * Columns in the datatable.
			 * Columns should atleast have title and field as
			 * @return {Array}  columns in the datatable.(array of objects)
			 */
			dataColumns: {type: Array, required: true},

			option:{type:Object},

			url:{type:String},

			tickets : {type:Function,default : ()=>[]},

			scroll_to : { type: String, default : ''},

			componentTitle : { type : String, default : ''},

			color : { type : String, default : '#1d78ff'},

			/**
			 * Alert component name to dispatch alert box
			 */
			alertComponentName: { type: String, default: '' },

			inputStyle: {type:Object, default :  ()=>{} },

		      show_pagination : { type : Boolean, default : false },

		      disableLoader : {type: Boolean, default: false},

		      btnStyle : {type : Boolean, default : ()=>{}},

		      panel : { type : String, default : 'agent' }
		},

		data(){
			
			return{

				columnArray : this.dataColumns,

				optionsObj : this.option,

				endPoint : this.url,

				showTable : true,

				error_message : '',

				loading : true,

				markedRows : [],

				allMarked : false,

                styleObj : { display : 'none'},

                isLoading: false,

                counter : 0,
				
				search_str : '',

		        next_page : '',

		        prev_page : '',

		        total: '',

		        to: '',

		        from: ''
			}
		},

		watch: {

			url(newValue,oldValue){
				
				this.endPoint = newValue
			},
			
			option(newValue,oldValue){
			
				this.optionsObj = newValue
			},
			
			dataColumns(newValue,oldValue){
				
				this.columnArray = newValue

		        if(this.show_pagination){

		            this.endPoint = this.url;
		        }
			},
			
			markedRows(newValue,oldValue){
				
				this.tickets(this.markedRows)
				
				return newValue
			}
        },

		computed : {

			optionsObject() {

                const self = this;

                self.optionsObj.texts = {
                  noResults: self.trans('no_matching_records'),
                  loading: self.trans('loading')
                };

                if(self.optionsObj.headings && self.optionsObj.headings.hasOwnProperty('id')){

                    self.optionsObj.headings.id = function(){

                        return self.h('input',{

                            type : 'checkbox',

                            modelValue : self.allMarked,

                            onChange(event) {

                                self.allMarked = event.target.checked;

                                self.toggleAll()
                            }
                        })
                    }
                }

				this.optionsObj.debounce = 700;

                if(this.show_pagination) {

                    this.optionsObj['pagination'] = { show : false };
                }

                return this.optionsObj
			}
		},

        mounted() {

            if(this.show_pagination){

                EventBus.on('vue-tables.pagination', () => {

                    this.endPoint = this.url;
                });
            }

	        EventBus.on('vue-tables.limit', (value) => {

		        window.emitter.emit('updatedLimit', value);
	        });

            EventBus.on('vue-tables.'+this.scroll_to+'.loading', () => {

                this.$emit('loaderState', true);

	            this.isLoading = true;
            });

            EventBus.on('vue-tables.'+this.scroll_to+'.loaded', () => {

	            this.isLoading = false;

                this.$emit('loaderState',false);
            });

            EventBus.on('vue-tables.'+this.scroll_to+'.error', () => {

				this.isLoading = false;

                this.$emit('loaderState',false);
            });
        },

		created(){

			window.emitter.on(this.componentTitle+'refreshData',this.onUpdate)

			window.emitter.on(this.componentTitle+'uncheckCheckbox',this.unselectAll)
		},

		methods :{

			checkFile() {
				this.$refs.table.setLimit(10);
				this.$refs.table.setFilter(this.search_str)
			},

			unmarkAll() {
				this.allMarked = false;
			},

			unselectAll() {
				this.allMarked = false;
				this.markedRows = [];
			},

      toggleAll() {
        this.markedRows = this.allMarked ? this.$refs.table.data.map(row => this.scroll_to === 'plugins-list' ?
            ((row.is_update === null || row.license_status === 0 || row.is_update === 2) ? null : row.path) : row.id).filter(Boolean) : [];
      },

			onUpdate() {
				this.counter++;
			},

			onError(data){
				
				if(data?.status === 404){

					window.location.href = window.axios.defaults.baseURL + '/404';

					return
				}

				if(this.alertComponentName && data && data.response && data.response.status) {

					errorHandler(data, this.alertComponentName)

				} else {

					if(data && data.response) {

						this.error_message = data.response.data.message;

						this.onUpdate();
					}
				}

				if(data && data.response && data.response.data.message === 'Invalid API end-point'){

					this.$refs.table.refresh();

					this.showTable = true;

					this.loading = true;
				} else {

					this.showTable = true

					this.loading = false
				}
			},

            onLoaded(resp){

                if(this.show_pagination){
          
		            this.next_page = resp.data.data.next_page_url;

		            this.prev_page = resp.data.data.prev_page_url;

		            this.total = resp.data.data.total;

		            this.to = resp.data.data.to;

		            this.from = resp.data.data.from;
		        }

				this.loading = false

				this.styleObj.display = 'block'
			},

            onPagination(direction) {

                const targetUrl = direction === 'next' ? this.next_page : this.prev_page;

                if (targetUrl) {

                    const url = new URL(targetUrl);

                    const pageValue = url.searchParams.get("page");

                    this.endPoint = this.updateQueryParam(this.endPoint, "page", pageValue);
                }
            },

            updateQueryParam(url, param, value) {

                url = url.replace(/([?&])page=\d+/, '');

                const separator = url.includes('?') ? '&' : '?';

                return `${url}${separator}${param}=${value}`;
            }
		},

		components : {

            'simple-pagination': SimplePagination,

			'loader': PageLoader
		}
	};
</script>

<style type="text/css">

.VueTables__row a {
  text-decoration: none !important;
}

table{
		border-collapse: collapse;
	}
	.datatable{
		padding-top:10px !important;
		padding-bottom: 45px !important;
	}
	.VueTables__search-field input, .globe-search{
		width : 300px !important;
	}

	.VueTables__search{
		float : right;
	}

	.datatable .VueTables__search{
		display: none;
	}

	.VueTables__limit{
		float : left !important;
		margin-left: -10px;
	}
	.VuePagination__pagination{
			margin-top: -5px !important;
			margin-right: -15px !important;
			float: right !important;
	}
	.VuePagination{
		margin-top: 10px !important;
	}
	.VuePagination__count {
		display: contents !important;
		margin-top: -10px !important;
	}
	.VuePagination .text-center{
		text-align: left !important;
		width: inherit;
	}
	/*.undefined{*/
	/*	margin-left: 10px !important;*/
	/*}*/
	.VueTables__columns-dropdown button {
		background: none !important;
		border: 1px solid #d4d3d3 !important;
		margin-right: 5px !important;
	}
	.VueTables__columns-dropdown ul li a input{
		width: 13px; height: 13px; padding: 0; margin:0; vertical-align: bottom; position: relative; top: -3px;
		overflow: hidden;
	}
	.overlay-loader {
	  position: absolute;
	  top: 0;
	  width: 100%;
	  height: 100%;
	  background-color: white;
	  opacity: 0.8;
	  filter: blur(5px);
	}

	.clip-loader {
	  position: absolute;
	  left: 50%;
	  right: 50%;
	  bottom: 70%;
	  top: 30%;
	}
	.faveo-datatable-loader {
		margin-top: 30px;
		margin-bottom: 30px;
	}
	.VueTables__table {
		font-size: 14px !important;
	}

	/*.VueTables__table th{
		font-weight: 500 !important;
	}*/
  .pagination-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

.VueTables__sort-icon {
  padding-left: 10px !important;
  cursor: pointer !important;
}

.VueTables__limit-field .form-control{
  cursor: pointer!important;
  appearance: auto!important;
}

.datatable .VueTables__limit-field label{
  display: none !important;
}

.VueTables .table-responsive{
  width: 100% !important;
}
</style>
