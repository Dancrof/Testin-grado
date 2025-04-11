<template>

	<faveo-box box-class="card card-light " :title="lang('filter')">

		<template slot="customActions">

			<custom-filter v-if="showCustomFilter" :updateFilterFields="updateFields" :selectedFilterFields="selectedFields"
				:endPoint="endPoint" ref="custom_table_filter">

			</custom-filter>
		</template>

		<div v-if="loading" class="card-body">

			<div class="row">

				<custom-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
			</div>
		</div>

		<div v-else id="table-filter">

			<div class="row" v-for="section in componentMetaData">

				<template v-for="item in section.section">

					<dynamic-select v-if="item.type !== 'date' && item.type !== 'number' && item.type !== 'text' && item.type !== 'time'"
						:key="item.name"
						:id="item.name"
						:name="item.name"
						:apiEndpoint="item.url"
						:classname="item.className"
						:elements="item.elements"
						:multiple="item.isMultiple"
						:label="lang(item.label)"
						:value="item.value"
						:onChange="onChange"
						strlength="35"
						:hint="lang(item.hint)"
						>
					</dynamic-select>

					<number-range-field v-if="item.type === 'number'"
						:label="lang(item.label)"
						:formStyle="formStyle"
						:value="item.value"
						:key="item.name"
						:id="item.name"
						:name="item.name"
						:classname="item.className"
						type="text"
						:onChange="onChange"
						:min_placeholder="item.min_placeholder"
						:max_placeholder="item.max_placeholder"
						:required="false">
					</number-range-field>

					<text-field v-if="item.type === 'text'"
						:label="lang(item.label)"
						:value="item.value"
						:key="item.name"
						:id="item.name"
						:name="item.name"
						:onChange="onChange"
						:classname="item.className"
						:required="false">

					</text-field>

					<date-time-field v-if="item.type === 'date'"
						:label="item.label"
						:value="item.value"
						type="datetime"
						:key="item.name"
						:id="item.name"
						:name="item.name"
			         :onChange="onChange"
			         :range="item.range"
			         :required="false"
			         format="MMMM DD YYYY, h:mm a"
			         :classname="item.className"
			         :clearable="false"
			         :disabled="false"
			         :editable="true"
			         :pickers="item.pickers"
			         :currentYearDate="false"
			         :time-picker-options="item.timeOptions"
			         :isDateSelector="false"
			         :numberStyle="numberStyle"
			         :confirm="true"
	          	>
	        		</date-time-field>

          <time-field v-if="item.type === 'time'"
                      :label="lang(item.label)"
                      :value="moment(item.value, 'HH:mm')"
                      type="time"
                      :key="item.name"
                      :id="item.name"
                      :name="item.name"
                      :onChange="onChange"
                      :required="false"
                      :place="item.placeholder"
                      format="HH:mm"
                      :classname="item.className"
                      :time-picker-options="item.timeOptions"
          >
          </time-field>
				</template>
			</div>
		</div>

		<template #actions>

			<div class="card-footer">

				<button id="filter-apply-btn" class="btn btn-primary" type="button" @click="onApply">

					<span class="fas fa-check"></span>&nbsp; {{ lang('apply')}}
				</button>

				<template v-if="saveFilter">

					<template v-if="filterNum">

						<button id="filter-upd" class="btn btn-primary" type="button" @click="onSave('update')">

							<span class="fas fa-sync"></span>&nbsp; {{ lang('update')}}
						</button>

						<button id="filetr-del" class="btn btn-secondary" type="button" @click="onSave('delete')">

							<span class="fas fa-trash-alt"></span>&nbsp; {{ lang('delete')}}
						</button>
					</template>

					<button v-else id="filetr-save" class="btn btn-primary" type="button" @click="onSave('save')">

						<span class="fas fa-save"></span>&nbsp; {{ lang('save')}}
					</button>
				</template>

				<button id="reset-btn" class="btn btn-primary" type="button" @click="onReset">

					<span class="fas fa-undo"></span>&nbsp; {{ lang('reset')}}
				</button>

				<button v-if="from !== 'report'" id="filter-cancel-btn" class="btn btn-secondary" type="button" @click="onCancel">

					<span class="fas fa-times"></span>&nbsp; {{ lang('cancel')}}
				</button>
			</div>
		</template>

		<save-table-filter v-if="showModal"
			:filterName="filterName"
			:icon="icon_class"
			:filterValues="selectedFilters"
			:filterId="selectedFilterId"
			:toggleFilterPopUp="toggleFilterPopUp"
			:source="filterFor"
			:filterArray="componentMetaData"
			:intitialDepartments="departments" :initialAgents="agents"
			:mode="filterMode"
			:redirectTo="redirectTo"
			:deleteUrl="deleteUrl"
			:closeFilter="closeFilter"
			:save_endpoint="save_endpoint">

		</save-table-filter>
	</faveo-box>
</template>

<script>

	import DynamicSelect from "../MiniComponent/FormField/DynamicSelect.vue";
    import TimeRangeField from "../MiniComponent/FormField/TimeRangeField.vue";
    import NumberRangeField from "../MiniComponent/FormField/NumberRangeField.vue";
    import TextField from "../MiniComponent/FormField/TextField.vue";
    import CustomFieldFilter from "./CustomFieldFilter.vue";
    import SaveTableFilter from "./SaveTableFilter.vue";
  import DateTimePicker from "../MiniComponent/FormField/DateTimePicker.vue";
  import moment from "moment";

    export default {

		name : "table-filter",

		description : "Table filter component",

		props:{

			metaData: { type:Array, required: true },

			appliedFilters : { type : Object, default : ()=>{}},

			from : { type : String, default  :''},

			showCustomFilter : { type : Boolean, default : false },

			updateFields : { type : Function, default : ()=>{}},

			selectedFields : { type : Array, default : ()=> []},

			endPoint : { type : String, default :'' },

			saveFilter : { type : Boolean, default : false },

			filterFor : { type : String, default : '' },

			filterNum : { type : [String, Number], default : ''},

			redirectTo : { type : String, default :'' },

			deleteUrl : { type : String, default : '' },

			closeFilter : { type : Function, default : () => {} },

			save_endpoint : { type : String, default : '' }
		},

		data(){

			return{

        moment: moment,

				selectedFilters: this.appliedFilters,

				close_on_select: !this.multiple,

				isShowFilter: false,

				componentMetaData: this.metaData,

				loading : false,

				formStyle : { width:'49.5%' },

				numberStyle : { width : '20%' },

				showModal : false,

				filterName : '',

				selectedFilterId : this.filterNum,

				departments : [],

				agents : [],

				filterMode : '',

				icon_class : ''
			}
		},

		beforeMount() {

			this.updateSelectedFieldValues();

			if(this.filterNum) { this.getFilterValue() }
		},

		methods:{

			updateSelectedFieldValues() {

				for(var i in this.selectedFields){

					this.onChange(this.selectedFields[i].value, this.selectedFields[i].name)
				}
			},

			onChange(value, name){

        if (name === 'scheduled_by') {
          // Emit the event when schedule_by field changes
          if (value && value.name) {
            this.$emit('scheduleByChanged', value.name);
          }
        }

        if(name === 'executed_at' && value !== null){
          this.selectedFilters[name] = moment(value, 'HH:mm').format('HH:mm');
        }else{

          this.selectedFilters[name] = value;
        }
			},

			onCancel() {

				this.$emit('selectedFilters', 'closeEvent');
			},

			onApply() {

				this.$emit('selectedFilters',this.selectedFilters);
			},

			onSave(mode){

				this.filterMode = mode;

				this.showModal = true;
			},

			toggleFilterPopUp(visiblity){

				this.showModal = visiblity;
			},

			onReset() {

				this.selectedFilters = {};

				this.loading = true;

				setTimeout(()=>{
					this.loading = false
				},1000)

				this.$emit('selectedFilters', 'resetEvent');
			},

			getFilterValue() {

				this.loading = true;

				axios.get('/service-desk/api/agent/'+this.filterFor+'-filter/'+this.selectedFilterId).then(res=>{

					this.loading = false;

					let filtersFromBackend = {};

					let editArr = []

					res.data.data.fields.map(element => {

						if(element.key.indexOf('custom_') !== -1){

							editArr.push(element);

							filtersFromBackend[element.key] = element.value;

						} else {

							filtersFromBackend[element.key] = element.value_meta;
						}
					})

					if(editArr.length){ this.appendCustomFieldFilter(editArr); }

					this.selectedFilters = filtersFromBackend;

					this.componentMetaData.map(function (obj) {

					  obj.section.map(function(row){

				  		if(filtersFromBackend.hasOwnProperty(row.name)) {

				  			row.value = filtersFromBackend[row.name];
				  		}
					  })
					});

					this.selectedFilterId = res.data.data.id;

					this.filterName = res.data.data.name;

					this.icon_class = { icon_class : res.data.data.icon_class};

					this.departments = res.data.data.departments;

					this.agents = res.data.data.agents;

				}).catch(err=>{

				})
			},

			appendCustomFieldFilter(element){
				this.$refs.custom_table_filter.getCustomFields(this.endPoint,element)
			},
		},

		components: {

			'dynamic-select': DynamicSelect,

			'date-time-field': TimeRangeField,

			'number-range-field': NumberRangeField,

			'text-field': TextField,

			'custom-filter' : CustomFieldFilter,

			'save-table-filter' : SaveTableFilter,

      'time-field': DateTimePicker
		}
	};
</script>

<style>
	#table-filter #range_count, #table-filter #range_option{
		background: transparent;
	}
</style>