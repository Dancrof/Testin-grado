<template>

  <span id="column-list">

	 <div class="btn-group float-end">

		<button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="true"
				id="dropdown-menu-columns" @click="getInitialColumns">

			<i class="fas fa-columns"> </i> {{lang('columns')}}
		</button>

		<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right"
			 aria-labelledby="dropdown-menu-columns" id="scrollable-ul"  @scroll="handleScroll">

        <draggable-element :list="columns" handle=".drag-btn" class="report-column-element" itemKey="id">

				    <template #item="{element, index}">

				    	<a href="javascript:;" class="dropdown-item report-column-list" :key="element.id">

				    		<input  type="checkbox"  class="form-check-input" @click="checkBoxClicked(element)" :value="element.key" :disabled="saveColumnsData.length === 1 && element.is_visible" v-model="element.is_visible"
                        v-tooltip="saveColumnsData.length === 1 && element.is_visible ? trans('atleast_one_column_needs_to_be_selected'): ''">

				    		<span @click="(event) => onLabelClick(event, element)" class="column-label" :title="element.hover ? element.hover : element.label">&nbsp;&nbsp;{{getSubString(element.label,30)}}</span>

				    		<span
                    class="float-end margin-horizontal-5 drag-btn"
                    title="Move this column"
                    @click="preventToCloseBox">
				    		  <i class="fas fa-arrows-alt-v" aria-hidden="true"></i>
				    		</span>
				    	</a>
				    </template>
			  </draggable-element>

        <infinite-loading v-if="next_page" @infinite="getColumns">
			  			<template #spinner><span></span></template>
			  			<template #complete><span></span></template>
        </infinite-loading>

        <div v-if="showLoader" class="mb-3">
			 	  <reuse-loader  :animation-duration="4000" :size="20"/>
        </div>


         <div class="column-list-btn-element" slot="footer">

					  <button type="button" id="save-columns" class="btn btn-sm btn-primary" @click="saveColumns" :disabled="saveColumnsData.length > max_count"
                    v-tooltip="saveColumnsData.length > max_count && !showLoader ? trans('column-tooltip') + max_count +' '+ trans('columns') : ''">

					  	<i class="fas fa-sync"> </i> {{lang('apply')}}
					  </button>
			</div>
		</div>
	</div>
	  <!-- it will only come when data has been populated -->
	 <custom-loader v-if="loading && hasDataPopulated"></custom-loader>
  </span>
</template>

<script>

import axios from 'axios';

import {errorHandler, successHandler} from "../../../../../helpers/responseHandler";

import draggable from 'vuedraggable'

export default {

	name : 'column-list',

	data(){
		return {

			/**
			 * If waiting for server to respond
			 */
			loading: false,

			/**
			 * If first time api call has been made
			 */
			hasDataPopulated: false,

			/**
			 * List of columns
			 */
			columns: [],

			/**
			 * Currently Editing column
			 */
			column: {},

			apiUrl: '',

      next_page: true,

      showLoader: false,

      max_count: 0,

      saveColumnsData: [],
			
			filterObj : {}
		}
	},

	props : {

		/**
		 * Url endpoint for getting table columns
		 */
		tableColumns: {
			type: Array,
			required: true
		},

		reportId:{
			type: Number,
			default: null
		},

    columnId:{
      type: Number,
      default: null
    },
	},

	beforeMount(){

		this.hasDataPopulated = false;

    this.saveColumnsData = this.tableColumns;

    if(this.tableColumns.length > 0){

      this.getInitialColumns();
    }

	},
	
	created(){
		window.emitter.on('onFilterSelected', (value) => {
			this.filterObj = value;
		});
	},

	methods: {

		/**
		 * Saves selected column on the server
		 * @return {Void}
		 */
		saveColumns(){

      this.columns.forEach((element, index) => { element.order = index + 1 });

      this.saveColumnsData.forEach((element) => {
        let correspondingColumn = this.columns.find(column => column.id === element.id);
        if(correspondingColumn) {
          element.order = correspondingColumn.order;
        }
      });

      // Sort the saveColumnsData array based on the order property
      this.saveColumnsData.sort((a, b) => a.order - b.order);

			if(this.reportId){
				this.apiUrl = 'api/agent/report-columns/' + this.reportId;
			}else{
				this.apiUrl = '/user-export-columns';
			}

			this.loading = true;

      axios.post(this.apiUrl,  this.saveColumnsData ).then(res => {

        window.emitter.emit('onColumnUpdate', this.saveColumnsData);

				successHandler(res, 'dataTableModal');

			}).catch(err => {

				errorHandler(err, 'dataTableModal');

			}).finally(() => {

				this.loading = false;
			})
		},

		onLabelClick(event, clickedColumn){

      if(!(this.saveColumnsData.length === 1 && element.is_visible)){
        clickedColumn.is_visible = !clickedColumn.is_visible;
        this.handelSaveColumns(clickedColumn);
      }
			this.preventToCloseBox(event);
		},

		preventToCloseBox(event) {
			event.stopPropagation();
		},

    checkBoxClicked(element){
      element.is_visible = !element.is_visible;
      this.handelSaveColumns(element);
    },

    getInitialColumns(){

      this.columns = [];

      this.page = 1;

      this.getColumns();
    },

    getColumns($state, isRefresh = false){

      this.showLoader = true;
	    
	    let params = {
		    page: this.page
	    }
	    
	    const filterKeys = ['change_type_ids', 'asset_type_ids'];
	    
	    filterKeys.forEach(key => {
		    if(this.filterObj.hasOwnProperty(key) && this.filterObj[key]){
			    this.filterObj[key].forEach((obj,index) => {
					params[`${key}[${index}]`] = obj.id ? obj.id : obj;
			    });
		    }
	    })
	    
      axios.get('api/agent/report-columns/paginate/'+this.columnId,{params:params}).then(res => {

        this.max_count = res.data.data.max_count;

        if(isRefresh){
          this.columns = res.data.data.report_columns.data;
        }else{

          this.columns.push(...res.data.data.report_columns.data)
        }

        this.columns.map((column) => {
          column.is_visible = column.is_visible ? true : false;
        })

        $state && $state.loaded();

        this.next_page = res.data.data.report_columns.next_page_url === null ? false : true;

        !this.next_page ? $state && $state.complete() : this.page++;

        this.showLoader = false;

      }).catch(err=>{

        this.showLoader = false;

        errorHandler(err, 'dataTableModal')
      })
    },

    handelSaveColumns(element){

      const savedColumnIndex = this.saveColumnsData.findIndex(column => column.id === element.id);

      // If the column is not in the saveColumnsData array and is_visible is true, add it
      if (savedColumnIndex === -1 && element.is_visible) {
        this.saveColumnsData.push(element);
      }
      // If the column is in the saveColumnsData array and is_visible is false, remove it
      else if (savedColumnIndex !== -1 && !element.is_visible) {
        this.saveColumnsData.splice(savedColumnIndex, 1);
      }
    }
	},

	components : {

		'draggable-element': draggable,
	}
}
</script>

<style scoped>

.report-column-element{
	min-width: max-content;
	min-height: 30px;
}

.column-label {
	cursor: pointer;
}

.form-check-input{
  margin-left: -0.5rem !important;
  cursor: pointer;
}

.drag-btn {
	cursor: move;
	visibility: hidden;
}

.report-column-list:hover>.drag-btn{
	visibility: visible;
}
.column-list-btn-element {
  padding: 10px 10px 10px 0;
  position: sticky;
  bottom: 0;
  background-color: white;
  width: 100%;
}
#dropdown-menu-columns{
	margin-top: 10px;
	margin-left: 10px;
}

#scrollable-ul {
  max-height: 280px;
  overflow-y: auto;
  overflow-x: hidden;
  border: 1px solid gainsboro;
  padding: 10px 10px 0 10px;
}
</style>
