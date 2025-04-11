<template>
  <span id="column-list">

	 <div v-if="showDropdown" class="btn-group float-end">

		<button type="button" class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="true"
			id="dropdown-menu-columns" @click="getInitialColumns">

			<i class="fas fa-columns"> </i> {{lang('columns')}}
		</button>

		<div class="dropdown-menu dropdown-menu-right" role="menu" x-placement="bottom-end"
			aria-labelledby="dropdown-menu-columns" id="scrollable-ul" @scroll="handleScroll">

			<draggable-element :list="parsedColumns" handle=".drag-btn" class="report-column-element" itemKey="id">

				<template #item="{element, index}">

					<a href="javascript:;" class="dropdown-item report-column-list" :key="element.id" @click="preventToCloseBox">

						<input type="checkbox"  class="form-check-input" @click="checkBoxClicked(element)" :value="element.key"
                   v-model="element.is_visible" :disabled="saveColumnsData.length === 1 && element.is_visible"
                   v-tooltip="saveColumnsData.length === 1 && element.is_visible ? trans('atleast_one_column_needs_to_be_selected'): ''" >

						<span @click="(event) => onLabelClick(event, element)" class="column-label" v-tooltip="element.hover ? element.hover : element.label"> &nbsp;{{subString(element.label,30)}}</span>

						<button v-if="element.is_custom" class="btn btn-secondary btn-sm float-end" @click="() => onDelete(element.id)">
						  <i class="fas fa-trash"></i>
						</button>

						<button v-if="element.is_custom" class="btn btn-primary btn-sm float-end margin-horizontal-5" @click="()=> onEdit(element)">
						  <i class="fas fa-edit"></i>
						</button>

						<span
							class="float-end margin-horizontal-5 drag-btn"
							title="Move this column"
							@click="preventToCloseBox">
						  <i class="fas fa-arrows-alt-v" aria-hidden="true"></i>
						</span>
					</a>
				</template>
			</draggable-element>

      <infinite-loading v-if="next_page && !showLoader" @infinite="getColumns">
						<template #spinner><span></span></template>
						<template #complete><span></span></template>
      </infinite-loading>

      <div v-if="showLoader" class="mb-3">
				<reuse-loader  :animation-duration="4000" :size="20"/>
      </div>

      	<div class="column-list-btn-element" slot="footer">

					<button type="button" id="save-columns" class="btn btn-sm btn-primary mb-1" @click="saveColumns" :disabled="saveColumnsData.length > max_count"
                  v-tooltip="saveColumnsData.length > max_count && !showLoader ? trans('column-tooltip') + max_count+' '+ trans('columns') : ''">

						<i class="fas fa-sync"> </i> {{lang('apply')}}
					</button>

					<button v-if="showAddColumn" class="btn btn-sm btn-primary mb-1" id="add-custom-column" @click="() => showAddCustomColumn = true">

					  <i class="glyphicon glyphicon-plus"> </i> {{lang('add_custom_column')}}
					</button>
				 </div>
		</div>
	</div>

	 <custom-column
		v-if="showAddCustomColumn"
		:add-custom-column-url="addCustomColumnUrl"
		:short-code-url="shortCodeUrl"
		:column="column"
		:closeView="hideCustomColumn"
		:isEditing="isEditingCustomColumn"
	 />

	 <!-- it will only come when data has been populated -->
	 <custom-loader v-if="loading && hasDataPopulated"></custom-loader>

  </span>
</template>

<script>

import axios from 'axios';
import {errorHandler, successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
import draggable from 'vuedraggable'
import CustomReportColumn from "./CustomReportColumn.vue";
import {getSubStringValue} from "../../../../../../resources/assets/js/helpers/extraLogics";

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

		/**
		 * If custom column pop is visible
		 */
		showAddCustomColumn: false,

		// If a modal is opened in edit mode
		isEditingCustomColumn: false,

    showLoader: false,

     next_page: true,

     max_count: 0,

     saveColumnsData: [],
		 
		 filterObj : {},

     showDropdown: true
	 }
  },

  props : {

    filterParams: {
      type: Object,
      default: () => {}
    },
	 /**
	  * Url endpoint for getting table columns
	  */
	 tableColumns: {
		type: Array,
		required: true
	 },

	 /**
	  * Url endpoint for adding custom column
	  */
	 addCustomColumnUrl: {
		type: String,
		required: true
	 },

	 /**
	  * Url endpoint for deleting custom column
	  */
	 deleteCustomColumnUrl: {
		type: String,
		required: true
	 },

	 /**
	  * Url endpoint for getting short codes
	  */
	 shortCodeUrl: {
		type: String,
		required: true
	 },

	 /**
	  * Report id
	  * used for column apply/update
	  */
	 subReportId: {
		type: Number,
		required: true
	 },

	 /**
	  * Index value of the report
	  * used for updating changed value
	  */
	 reportIndex: {
		type: Number,
		required: true
	 },

    reportId: {
      type: Number,
      required: true
    },

	  showAddColumn: { type: Boolean, default: true}
  },

  beforeMount(){

	 this.hasDataPopulated = false;

	 this.columns = this.tableColumns;

   this.saveColumnsData = this.tableColumns;

   this.filterObj = this.filterParams;

   if(this.tableColumns.length > 0){

     this.getInitialColumns();
   }

  },

  created(){
	 window.emitter.on('refresh-report', this.getInitialColumns);
	  window.emitter.on('onFilterSelected', (value) => {
		  this.filterObj = value;
	  });
  },

	computed:{

		parsedColumns() {

			this.columns.forEach(obj=>{

				obj['is_visible'] = obj.is_visible ? true : false
			})

			return this.columns
		}
	},

  methods: {

	  subString(value,length = 20){

		  return getSubStringValue(value,length)
	  },

		/**
		 * Gets data from server
		 * @return {Void}
		 */
		getDataFromServer(){

		  this.loading = true;

		  axios.get('api/agent/report-columns/' + this.subReportId).then(res => {

			 this.columns = res.data.data;

			 window.emitter.emit('onColumnUpdate', { columns : this.columns });

		  }).catch(err => {

			 errorHandler(err, "tabular-report-layout");

		  }).finally(res => {

			 this.loading = false;
			 this.hasDataPopulated = true;
		  });
		},

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

     this.saveColumnsData.sort((a, b) => a.order - b.order);

		this.loading = true;

		axios.post('api/agent/report-columns/' + this.subReportId,  this.saveColumnsData )
		  .then(res => {
         window.emitter.emit('onReportsColumnUpdate', this.saveColumnsData);
			 successHandler(res, 'tabular-report-layout');
		  }).catch(err => {
			 errorHandler(err, 'tabular-report-layout');
		  }).finally(() => {
			 this.loading = false;
		  })
	 },

	 onDelete(id){
     this.updateDropdown()
		this.loading = true;
		axios.delete(this.deleteCustomColumnUrl + '/' + id).then(res => {
		  successHandler(res, 'tabular-report-layout');
		  this.getInitialColumns();
		}).catch(err => {
		  errorHandler(err, 'tabular-report-layout');
		}).finally(() => {
		  this.loading = false;
		})
	 },

	 onLabelClick(event, clickedColumn){

     if(!(this.saveColumnsData.length === 1 && element.is_visible)) {
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

	 onEdit(column){
		this.showAddCustomColumn = true;
		this.isEditingCustomColumn = true;
		this.column = column;
    this.updateDropdown()
	 },

    updateDropdown(){
      this.showDropdown = false;
      setTimeout(() => {
        this.showDropdown = true;
      }, 1)
    },

	 hideCustomColumn() {
		this.showAddCustomColumn = false;
		this.isEditingCustomColumn = false;
		this.column = {};
	 },

    getInitialColumns(){

      this.columns = [];

      this.page = 1;

      this.getColumns()
    },

    getColumns($state, isRefresh = false){

      this.showLoader = true;
	  
	  let params = {
		page: this.page
	  }
	    
	    const filterKeys = ['dept-ids', 'helptopic-ids'];

	    filterKeys.forEach(key => {
		    if(this.filterObj.hasOwnProperty(key) && this.filterObj[key]){
			    params[`${key}[]`] = this.filterObj[key].map(obj => obj.id ? obj.id : obj);
		    }
	    })
      
      axios.get('api/agent/report-columns/paginate/'+this.reportId,{params:params}).then(res => {

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

        errorHandler(err, 'tabular-report-layout')
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
	 'custom-column': CustomReportColumn,
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
    margin-left: -1rem !important;
    cursor: pointer;
  }

  .drag-btn {
	 cursor: move;
	 visibility: hidden;
  }

  .report-column-list:hover>.drag-btn{
	 visibility: visible;
  }

  .report-column-list{
    cursor: default;
  }
  .report-column-list:active {
    color: #212529 !important;
    background-color: transparent !important;
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
    min-width: 300px;
    overflow-y: auto;
    overflow-x: auto;
    border: 1px solid gainsboro;
    padding: 10px 10px 0 10px;
  }
</style>
