<template>
	
	<div id="filter-div" class="card-tools">
			
		<button type="button" class="btn btn-tool dropdown-toggle" data-bs-toggle="dropdown" id="labels-button"
			@click="getFields()" v-tooltip="trans('add_custom_field')">

			<i class="fas fa-plus"> </i>  
		</button>
	
		<ul id="filter-dropdown" class="dropdown-menu dropdown-menu-right filter_menu" @click="$event.stopPropagation()">

			<li v-if="loading" class="field_loader nav-item">
				
				<loader :size="30" :duration="4000" :color="'#1d78ff'"></loader>
			</li>

			<template v-if="!loading">
				
				<li class="nav-item">
					
					<div class="form-group has-feedback has-search filter_div">
					 
					 	<input type="text" class="form-control" name="label" :placeholder="trans('search')" v-model="search">
				  </div>
				</li>
			
				<li v-for="field in filteredList" class="nav-item fields" @click="onClick(field)">
					
					<a :class="['nav-link',{'active' : selectedFields.map(a => a.id).includes(field.id)}]" href="javascript:;">

						<i v-if="selectedFields.map(a => a.id).includes(field.id)" class="fa fa-check field_select"></i>

						<span id="field_title" :title="trans(field.label)">	{{subString(field.label)}}</span>
					</a>
						
				</li>

				<li v-if="customFields.length === 0">
					
					<p class="text-center">{{trans('no_results_found')}}</p>
				</li>
			</template>
		</ul>
	</div>
</template>

<script>

	import axios from 'axios';

	import { getSubStringValue } from '../../helpers/extraLogics'

	export default{

		name : 'custom-filter',

		description : 'Custom Fields Filter Component',

		props : {

			updateFilterFields : { type : Function, default : ()=> {} },

			selectedFilterFields : { type : Array, default : ()=> []},

			endPoint : { type : String, required : true}
		},

		data(){

			return {

				customFields : [],

				loading : true,

				selectedFields : this.selectedFilterFields,

				search : '',

				locale : '',
			}
		},

		created() {

			window.emitter.on('clearCustomFields',this.clearFields)
		},

		computed : {

			filteredList() {
		     
		      return this.customFields.filter(field => {
		     
		        return field.label.toLowerCase().includes(this.search.toLowerCase())
		      })
		    }
		},

		methods :{

			clearFields() {

				this.selectedFields = [];
			},

			subString(value){

				return getSubStringValue(value,10)
			},

			onCancel(){

				var element = document.getElementById("filter-div");
			
				element.classList.remove("open");
			},

			onClick(field){

			   if(this.selectedFields.map(a => a.id).includes(field.id)){

			   	for(var i in this.selectedFields){

						if (this.selectedFields[i].id == field.id) { 
							
							this.selectedFields.splice(i, 1);
							
							break;
					 	}
					}
			   	
			   } else {

			   	field['name'] = 'custom_'+field.id;
					
					field['type'] = 'text';
					     	
				   field.value = '';
				        	
				   field.className = 'col-sm-4';

			   	this.selectedFields.push(field)
			   }

				this.updateFilterFields(this.selectedFields)
			},

			getFields(){
				
				this.loading = true;

				axios.get(this.endPoint).then(res=>{

					this.loading = false;

					this.customFields = res.data.data;

				}).catch(error=>{

					this.loading = false;
				})
			},

			getCustomFields(endpoint,element) {

				this.customFields = [];

				this.selectedFields = [];

				axios.get(endpoint).then(res=>{

					let data = res.data.data;

					if(data.length){

					for(var i in data){

						if(element.length){

							for(var k in element){

								if(element[k].key == data[i].unique){

									data[i].name = element[k].key;
					
									data[i].type = 'text';
								        	
								   	data[i].className = 'col-sm-4';

									if(!data[i].value){

										if(data[i].type == 'checkbox'){

											data[i].value = element[k].value.split(',');
										
										} else {
										
											data[i].value = element[k].value;	
										}
										
										this.selectedFields.push(data[i]);

										if(this.selectedFields.length === element.length){
												
											this.updateFilterFields(this.selectedFields);
										}
									}
								}
							}
						}

						for(var j in this.selectedFields){

							if(this.selectedFields[j].id == data[i].id){
								
								data[i].value=this.selectedFields[j].value;
							}
						}
					}

					this.customFields = data;
				}

				}).catch(error=>{})
			},
		}
	};
</script>

<style scoped>
	
	.filter_div{	margin: 6px 2px 2px 2px; }

	.fields:hover,.fields>.active{ background: #eee; }
	
	.fields,#field_title{ cursor: pointer; }

	.field,#field_title{ margin : 3px; }

	.fields{ padding: 1px; }

	.filter_menu{ width: 200px; max-height: 400px; overflow-y: auto; overflow-x: hidden; padding: 5px;}

	.has-search .form-control-feedback { color: #ccc; }

	.field_select{ margin-left : 4px; }

	.field_loader { margin-top: 10px;margin-bottom: 10px; }
</style>