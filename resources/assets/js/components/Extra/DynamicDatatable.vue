<template>
  <div id="dynamic-datatable-container">
    <data-table
      id="dynamic-datatable"
      :url="dataUrl"
      :dataColumns="columnNames"
      :option="options"
      :tickets="tickets"
      :show_pagination="show_pagination"
      scroll_to="dynamic-datatable">
    </data-table>
  </div>
</template>

<script>

import { carbonToMomentFormatter} from '../../helpers/extraLogics';
import UserTableActions from "../Agent/User/UserTableActions.vue";
import DataTableStatuses from "../MiniComponent/DataTableComponents/DataTableStatuses.vue";
import HyperLinkInstance from "./Tables/HyperLinkInstance.vue";
import TimeStampInstance from "./Tables/TimeStampInstance.vue";
import DataTableActions from "../MiniComponent/DataTableComponents/DataTableActions.vue";
import assetImage from "../../../../../app/Plugins/ServiceDesk/views/js/components/Asset/assetImage.vue";
import DataTableStatus from "../MiniComponent/DataTableComponents/DataTableStatus.vue";
import DataTableNameWithStatus from "../MiniComponent/DataTableComponents/DataTableNameWithStatus.vue";
import SimpleTableListElements from "./SimpleTableListElements.vue";
import DataTableTaskStatus
  from "../../../../../app/Plugins/Calendar/views/js/components/MiniComponents/DataTableTaskStatus.vue";

export default {
	
  data(){
    return {

      /**
       * Name of the columns in array format
       * @type {Array}
       */
      columnNames: [],

      /**
       * Datatable options
       * @type {Object}
       */
      options: {},

      /**
       * Contains the key and component of the data
       * for eg. for priority, we dynamically create a component with name priority-hyperlink,
       * not the mapping of this, will be stored in this variable. Like so :
       * { "priority" : "priority-hyperlink" }
       * @type {Object}
       */
      templateObject: {},
    }
  },

  props : {

    /**
     * Api endpoint for getting table data
     */
    dataUrl: {
      type: String,
      required: true
    },

    /**
     * Object with key and label of a column
     * for eg. { ticket_number : "Ticket Number" }
     * @type {Object}
     */
    columns: {type: Object, required: true},

    tickets : {type:Function,default : ()=>[]},

    /**
     * Array of objects of column
     * @type {Object}
     */
    columnsMeta: {type: Array, required: true},

    /**
     * ticket filter paramaters
     * @type {Object}
     */
    filterParams: {type: Object, required: true},
	
	  staticColumns : { type : Array, default : ()=>[] },

    reportType: {type : String, default:''},

    show_pagination : { type : Boolean, default : false },

    showNameWithStatus: {type: Boolean, default: false},

    deleteMessage: {type: String, default: ''},

	  perpage: { type: [Number, String], default: 10 },

	  perPageValues: { type: Array, default: () => [10,25,50,100,200,500] }
  },

  beforeMount() {

    this.prepareDynamicComponents();

    this.updateColumnNames();

    this.updateOptions();
  },

  methods: {

    /**
     * Prepares component dynamically so that additional files should not be written for that
     * @return {Void}
     */
    prepareDynamicComponents()
    {
        // loop over all columns and whichever is html,
        // render it like html
        // whichever is timestamp, render it like timestamp
        this.columnsMeta.map(column => {

          // making "." replace with a "-", so that it can be a valid component name
          let key = column.key.replace(/\./g, '-');

          if(column.is_html){

	          let colName = column.key.split('.');

	          this.getHyperlinkInstance(key, column.key,colName[0]);
          }

          // formatting columns which are non custom, custom columns will be formatted from backend
          if(column.is_timestamp){
            let timestampFormat = carbonToMomentFormatter(column.timestamp_format);
            this.getTimestampInstance(key, column.key, timestampFormat);
          }
        })
    },

    /**
     * takes column keys and assign to columnNames state
     * @return {void}
     */
    updateColumnNames(){
		
      this.columnNames = Object.keys(this.columns);

      if(this.staticColumns.length) {

        this.staticColumns.map(obj=>{

          if(obj == 'id') {

            this.columnNames.unshift(obj)

          } else {

            this.columnNames.push(obj)
          }
        });
      }
    },

    sortableFields(){
      let sortables = [];

      this.columnsMeta.map(column => {
        if(column.is_sortable){
          sortables.push(column.key);
        }
      })
      return sortables;
    },

    /**
     * create hyperlink vue instance of dependencies dynamically
     * @param  {string} componentName
     * @param  {string} hyperlinkPath path of the dependency in the API
     *                                for eg. in {priority: {id:1, name:'hyperlink'}},
     *                                it will be priority.name
     * @return {void}
     */
      getHyperlinkInstance(componentName, keyName, colName){

        // mapping keyname with componentName in template so that datatable can mount it as a component
      this.templateObject[keyName] = (f, row, index) => {

        if (this.showNameWithStatus) {
          if (keyName === 'name') {
            return this.h(DataTableNameWithStatus, { data: row });
          } else if (['tickets.url', 'changes.url', 'users.url', 'teams.url'].includes(keyName)) {
            return this.h(SimpleTableListElements, { data: row, index, column: colName });
          }  else if (keyName === 'closed_by.full_name' || keyName === 'created_by.full_name') {
            return this.h(HyperLinkInstance, { data: row, keyName, colName });
          }
        }else{
          return this.h(HyperLinkInstance, { data: row, keyName, colName, reportType: this.reportType });
        }
      }
      },

    /**
     * create hyperlink vue instance of dependencies dynamically
     * @param  {string} componentName
     * @param  {string} hyperlinkPath path of the dependency in the API
     *                                for eg. in {priority: {id:1, name:'hyperlink'}},
     *                                it will be priority.name
     * @return {void}
     */
    getTimestampInstance(componentName, keyName, timestampFormat){
      
      // mapping keyname with componentName in template so that datatable can mount it as a component

		this.templateObject[keyName] = (f,row)=>{

			return this.h(TimeStampInstance,{ data : row, keyName: keyName, timestampFormat : timestampFormat});
		}
    },

    updateOptions(){

      const from = this.reportType;

      const deleteMessage = this.deleteMessage;

      this.options =  {

        headings: this.columns ? { ...this.columns, id: 'Id', user_actions : this.trans('user_actions') ,
          asset_image : this.trans('asset_image'), actions: this.trans('actions') , active: this.trans('active'),
          info: this.trans('info'), taskstatus:this.trans('status'), status: this.trans('status')} : null,

	      perPage: this.perpage,

        perPageValues : this.perPageValues,

        sortIcon: {

          base : 'glyphicon',

          up: 'glyphicon-chevron-down',

          down: 'glyphicon-chevron-up'
        },

        templates: {

          user_actions : (f,row)=>{

            return this.h(UserTableActions,{ data : row})
          },

          asset_image : (f,row)=>{

            return this.h(assetImage,{data:row})
          },

			actions : (f,row)=>{

				return this.h(DataTableActions,{ data : row})
			},

			info : (f,row)=>{

				return this.h(DataTableStatuses,{ data : row})
			},

      status: (f, row)=>{

        return  this.h(DataTableStatus,{data: row})
      },

      taskstatus: (f, row)=>{

        return  this.h(DataTableTaskStatus,{data: row})
      },

			...this.templateObject
		},

        texts : {
          'filter': '',
          'limit': ''
        },

        responseAdapter({data}) {
          window.emitter.emit('dataCount',data.data.total)

          window.emitter.emit('responseData',data)

          let responseData = from ? data.data[from] : data.data.data;

          // Check if responseData is an array and add deleteMessage to each object
          if (Array.isArray(responseData)) {
            responseData = responseData.map(item => {
              // Only add deleteMessage if it's not an empty string or null
              if (deleteMessage && deleteMessage.trim() !== '') {
                item.deleteMessage = deleteMessage;
              }
              return item;
            });
          }

          return {

            data: responseData,

            count: data.data.total
          }
        },

        requestAdapter: (data) => {

          let defaultParams = {
            "sort-field": data.orderBy,

            "sort-order": data.ascending ? 'desc' : 'asc',

            "search-query": data.query.trim(),

            "limit": data.limit,
          };

          if (!this.show_pagination) {
            defaultParams["page"] = data.page;
          }

          return { ...this.filterParams, ...defaultParams }
        },

	      // orderBy: { ascending: false },
        // we need this only for body of the ticket. For others its width can
        // be taken as max content
        columnsClasses: {
					ticket_number: 'ticket_number',
          subject: 'subject',
          periods: 'periods',
          version: 'version',
          persons: 'persons',
          actions: 'actions'
  			},

        sortable: this.sortableFields(),
	      
	      filterable : true
      }
    },
  },

  watch : {
    filterParams(){
      window.emitter.emit('refreshData');
    },
    columns(){
      this.prepareDynamicComponents();
      this.updateColumnNames();
      this.updateOptions();
      window.emitter.emit('refreshData');
    }
  }
}
</script>

<style>

  #dynamic-datatable-container .turn_around_time_department{
    min-width: 130px !important;
  }

  #dynamic-datatable-container .ticket_number {
    min-width: 130px;
  }

  #dynamic-datatable-container .subject {
    min-width: 300px;
    max-width: 300px;
  }

  #dynamic-datatable-container .version {
    min-width: 300px;
    max-width: 300px;
  }

  #dynamic-datatable-container .persons {
    min-width: 100px;
    max-width: 150px;
  }

  #dynamic-datatable-container .periods {
    min-width: 100px;
    max-width: 150px;
  }

  #dynamic-datatable-container .actions {
    min-width: 110px;
    max-width: 180px;
  }

  #dynamic-datatable-container td{
    max-width: 250px !important;
  }

  #dynamic-datatable-container .VueTables__sortable {
    min-width: 100px;
  }

  /* overwriting datatable loader class  */
  .faveo-datatable-loader {
		margin-top: 0px !important;
		margin-bottom: 0px !important;
	}
  #dynamic-datatable {
    padding-bottom: 45px;
  }
  
  #dynamic-datatable-container .VueTables .table-responsive > table{
	  width : max-content;
	  min-width : 100%;
	  max-width : max-content;
	  overflow: auto !important;
  }
</style>
