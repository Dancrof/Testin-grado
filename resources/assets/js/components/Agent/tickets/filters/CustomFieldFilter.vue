<template>

	<div class="card-tools">
			
		<a href="javascript:;" class="btn-tool dropdown-toggle" data-bs-toggle="dropdown" v-tooltip="trans('add_custom_field')"
			@click="clearAndCallCustomFields">
			
			<i class="glyphicon glyphicon-plus"> </i>
		</a>
			
		<div class="dropdown-menu dropdown-menu-right dropdown-menu-lg custom_filter_menu" role="menu" 
			@click="$event.stopPropagation()" id="filter-container" @scroll="handleFilterScroll()">
			
			<span class="dropdown-header">{{trans('filter_custom_field')}}</span>

			<div class="px-2">

				<input type="text" class="form-control" :placeholder="lang('filter_here')" v-model="search">
			</div> 

			<template v-if="visibileCustomFields.length">
				
				<template v-for="(field,index) in visibileCustomFields">
					
					<a :id="'form-field-'+index" role="menuitem" tabindex="-1" href="javascript:;" class="dropdown-item" 
						@click="toggleFormFieldVisibility(field)" :class="{ 'selected-field' : field.selected }">
						
						<span v-if="field.selected==1">
								
							<span aria-hidden="true" class="fas fa-check"></span>
						</span>&nbsp;

						<!-- For child Fields -->
						<span v-if="field.isChild" class="ms-2">
								
							<span aria-hidden="true" class="fas fa-arrow-right"></span>
						</span>&nbsp;
							
						<span style="position: absolute;margin-top: -1px" :title="field.hover ? field.hover : field.label">{{getSubString(field.label,30)}}</span>
					</a>
				</template>
			 </template>
			
			<a v-if="!visibileCustomFields.length && !loading" class="dropdown-item">{{ trans('no_results_found') }}</a>

			<div v-if="loading" style="padding :35px;">
				
				<loader :size="30" :duration="4000" :color="'#1d78ff'"></loader>
		  </div>
		</div>
	</div>
</template>
<script>

	import axios from 'axios';
	
	import {errorHandler} from "../../../../helpers/responseHandler";
	
	import {debounce} from "lodash";

	export default{

		data(){
			
			return{
			
				allCustomFields:[],
			
				selectedCustomFields: this.selectedFilters,
			
				searchedCustomFields:[],
			
				search:'',
			
				loading: true,
				//For updating Filter Object 
				updatedFilterValues : this.customFilters,

				valuesInEdit : [],

				filterOpen : false,
				
				hasMoreData: true,
				
				page: 1,
			}
		},

		props:{

			selectedFilters: {type: Array, required: true},

			//Filter Object coming from TicketFilter Component
			customFilters : { type : Object, default : ()=>{}},

			//Method for updating Filter Object 
			updatedFieldValues : { type : Function },

			showLoader : { type : Function, default : ()=> {} },
			
			filterId: { type: [String, Number], default: ''},
			
			defaultFiltersObj: { type: Object, default: ()=>{} }
		},
		
		beforeMount() {
			
			setTimeout(()=>{

				this.getCustomFields()
			},1000)
		},

		methods:{
			
			clearAndCallCustomFields() {
				this.allCustomFields = [];
				this.loading = true;
				this.search = "";
				this.searchedCustomFields = [];
				this.hasMoreData = true;
				this.page= 1;
				this.getCustomFields();
			},
			
			handleFilterScroll: debounce ( function ()  {
				const filterContainer = document.getElementById('filter-container');
				const scrollHeight = filterContainer.scrollHeight;
				const scrollTop = filterContainer.scrollTop;
				const clientHeight = filterContainer.clientHeight;
				
				if (scrollTop + clientHeight >= scrollHeight - 100 && !this.loading && this.hasMoreData) {
					
					this.getCustomFields();
				}
			}, 200),
			
			async getCustomFields (){
				
				try {
					// if(this.valuesInEdit.length){
						
						// this.showLoader(true);
						
						// this.setUpdatedField(this.allCustomFields)
						
						// return
					// }
					
					this.toggleOptions();
					
					this.loading = true;
					
					let search = location.search.substring(1);
					let val;
					let filterKey;
					if(search) {
						val = JSON.parse('{"' + decodeURI(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/=/g,'":"').replace(/%2F/g, '\/') + '"}')
					}
					if(val) {
						filterKey = Object.keys(val).find(key => key.includes('custom_'))
					}
					
					let params = {
						category: 'ticket',
						page: this.page,
						time: Date.now(),
						module: 'filter',
						filter_id: this.filterId,
						filter_key: filterKey || ''
					}
					
					const filterKeys = ['dept-ids', 'department_ids', 'dept_ids', 'helptopic-ids'];
					
					filterKeys.forEach(key => {
						if(this.defaultFiltersObj.hasOwnProperty(key) && this.defaultFiltersObj[key]){
							params[`${key}[]`] = this.defaultFiltersObj[key].map(obj => obj.id);
						}
					})
					
					const response = await axios.get('/custom-field-flattened', { params : params});
					
					if (response.data.data.data.length > 0) {
						
						for(var i in response.data.data.data){
							
							if(response.data.data.data[i].selected === undefined){
								
								response.data.data.data[i].selected = 0;
							}
							
							for(var j in this.selectedCustomFields){
								
								if(this.selectedCustomFields[j].id === response.data.data.data[i].id){
									
									response.data.data.data[i].selected = 1;
									
									response.data.data.data[i].value=this.selectedCustomFields[j].value;
								}
							}
						}
						
						this.allCustomFields = [...this.allCustomFields, ...response.data.data.data];
						
						this.setUpdatedField(this.allCustomFields)
						
						this.page++;
						
						this.filterOpen = true;
						
						this.showLoader(false);
						
						this.hasMoreData = true;
						
					} else {
						// No more data, set the flag to false
						this.hasMoreData = false;

						this.checkPresentFields();
					}
					
				} catch (error) {
					
					errorHandler(error)
				
				} finally {
				
					this.loading = false;
					
					this.showLoader(false);
				}
			},
			
			setSelectedField(data){

				if(data.length>0){
				
					for(var i in data){
				
						// if key `selected` is not present in the object,
						// we initialise it with zero
						if(data[i].selected == undefined){
				
							data[i].selected = 0;
						}
				
						for(var j in this.selectedCustomFields){
				
							if(this.selectedCustomFields[j].id == data[i].id){
				
								data[i].selected = 1;
				
								data[i].value=this.selectedCustomFields[j].value;
							}
						}
					}
					
					this.allCustomFields = data;

					this.setUpdatedField(this.allCustomFields)
				}
			},

			//For updating selected Custom fields
			setUpdatedField(data){

				if(data.length>0){

					for(var i in data){

						if(this.valuesInEdit.length){

							for(var k in this.valuesInEdit){

								if(this.valuesInEdit[k].key == data[i].key){

									data[i].selected = 1;

									if(!data[i].value){

										if(data[i].data_type == 'checkbox'){

											data[i].value = this.valuesInEdit[k].value.split(',');
										
										} else {
										
											data[i].value = this.valuesInEdit[k].value;
										}
										
										this.selectedCustomFields.push(data[i]);

										if(this.selectedCustomFields.length === this.valuesInEdit.length){
											
											this.$emit('custom',this.selectedCustomFields);
										}
									}
								}
							}
						}

						// if key `selected` is not present in the object,
						// we initialise it with zero
						if(data[i].selected == undefined){
							
							data[i].selected = 0;
						}

						for(var j in this.selectedCustomFields){

							if(this.selectedCustomFields[j].id == data[i].id){
								
								data[i].selected = 1;
								
								data[i].value=this.selectedCustomFields[j].value;
							}
						}
					}

					this.allCustomFields = data;

					this.checkPresentFields();
				}
			},

			checkPresentFields(){

				let keysInAllFields = this.allCustomFields.map(field => field.key);

				this.selectedCustomFields.forEach(field => {

					if (!keysInAllFields.includes(field.key)) {

						field.selected=0;

						this.selectedCustomFields = this.selectedCustomFields.filter(function(el) {

							return el.id !== field.id;
						});
					}
				});


				this.$emit('custom',this.selectedCustomFields);
			},

			/**
			 * * NOTE: this has been moved to a seperate method because jquery has been
			 * defined as a global object and cannot be mocked in test cases
			 * @param  {Object} x DOM element reference
			 * @return {undefined}
			 */
			unbindClickInContainer(x){
				$(x.target).attr('@click',null).unbind('click');
			},

			/**
			 * Toggles option in the dropdown
			 * NOTE: this has been moved to a seperate method because jquery has been
			 * defined as a global object and cannot be mocked in test cases
			 * @return {undefined}
			 */
			toggleOptions(){
				$(".custom-menu").dropdown("toggle");
			},

			/**
			 * Toggles form field visiblilty
			 * @param  {Object} formFieldObject
			 * @return {undefined}
			 */
			toggleFormFieldVisibility(formFieldObject){
				
				//Finding the index of clicked item
				let index = this.allCustomFields.findIndex(obj => obj.key == formFieldObject.key);
				
				if(!formFieldObject.selected){
				
					formFieldObject.selected=1;
				
					formFieldObject.value='';
				
					this.selectedCustomFields.push(formFieldObject);
					
					//Removing existing object and replacing new Object with Selected value
					this.allCustomFields.splice(index, 1, formFieldObject);
				}
				else{

					formFieldObject.selected=0;
					
					//Deleting Key:Value pair from Filter Object after unseleting
					delete  this.updatedFilterValues[formFieldObject.key];
					
					// For Updating the Filter Object in TicketFilgter Component
					this.updatedFieldValues(this.updatedFilterValues)
					
					//Removing existing object and replacing new Object with Selected value
					this.allCustomFields.splice(index, 1, formFieldObject);
					
					this.selectedCustomFields = this.selectedCustomFields.filter(function(el) {
					
						return el.id != formFieldObject.id;
					});
				}
				
				this.$emit('custom',this.selectedCustomFields);
			},

			/**
			 * Filters fields which matches the query
			 * @param  {string} searchQuery
			 * @return {Array}
			 */
			searchFilter(searchQuery){
				return this.allCustomFields.filter(field => {
					searchQuery = searchQuery.toLowerCase();
					let label = field.label.toLowerCase();
					return label.indexOf(searchQuery) !== -1;
				})
			},
		},

		watch : {
			search(val){
				this.searchedCustomFields = this.searchFilter(val);
			}
		},

		computed :{
			visibileCustomFields(){
				return this.search == '' ? this.allCustomFields : this.searchedCustomFields;
			}
		}
	};
</script>

<style scoped>

	.selected-field{ background: #f7f8f9; }

	.custom_filter_menu { max-height: 350px;overflow-y: auto; }
	
	#filter-container {
		height: 400px;
		overflow-y: auto;
		overflow-x: hidden;
	}
	
	#filter-container::-webkit-scrollbar-track
	{
		background-color: #f1f1f1;
		border-radius:10px;
	}
	#filter-container::-webkit-scrollbar
	{
		width: 6px;
		background-color: #f1f1f1;
	}
	#filter-container::-webkit-scrollbar-thumb
	{
		background-color: #c1c1c1;
		border-radius: 10px;
	}
</style>