<template>

	<div id="tags-div" class="btn-group">

			<button type="button" class="btn btn-xs btn-light dropdown-toggle" data-bs-toggle="dropdown" id="tags-button">

				<i class="fas fa-tag"> </i> {{lang('tags')}}

				<span class="caret"></span>
		</button>

		<ul class="dropdown-menu" @click="$event.stopPropagation()" id="dropdown-tag">

			<li v-if="!loading" class="px-2">
				<dynamic-select :label="lang('tags')" :multiple="true" name="tags"  classname="col-sm-12"
					apiEndpoint="/api/dependency/tags" :value="tags" :onChange="onChange" :labelStyle="labelStyle"
					:taggable="true" callingFrom="ticket-tags">

				</dynamic-select>
			</li>

			<div class="tags_menu"  id="tags-dropdown">

				<li v-if="loading" class="mt-3 mb-2">

					<loader :size="30" :duration="4000" :color="'#1d78ff'"></loader>
				</li>

				<template v-if="!loading">

					<li v-for="tag in selectedTags" class="tags active" @click="onClick(tag)">

					 	<i class="fas fa-tag" :class="{cancel : isRtlLayout, cancel_ar : !isRtlLayout}"> </i>

						<label id="tag_title" v-tooltip="{content: loadLabel(trans(tag)), html: true}">{{loadLabel(subString(tag))}}</label>

						<i class="fas fa-times" :class="{cancel_ar : isRtlLayout, cancel : !isRtlLayout}"></i>

					</li>

					<li class="tag_button">

						<button class="btn btn-xs btn-light" @click="onCancel()"
							:class="{right : isRtlLayout, left : !isRtlLayout}">

							<i class="fas fa-times"> </i> {{lang('cancel')}}

						</button>

						<button class="btn btn-xs btn-primary left" @click="onSubmit()"
							:class="{left : isRtlLayout, right : !isRtlLayout}" :disabled="ticketObj.tags.length === 0 && tags.length === 0">

							<i class="fas fa-check"> </i> {{lang('apply')}}

						</button>
					</li>
				</template>
			</div>
		</ul>
	</div>
</template>

<script>
	
	import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";

	import axios from 'axios';

  import {getSubStringValue, renderLabelWithEmoji} from "../../../../../../../helpers/extraLogics";
	import DynamicSelect from "../../../../../../MiniComponent/FormField/DynamicSelect.vue";

	export default{

		name : 'ticket-label',

		description : 'Ticket label component',

		props : {

			ticketObj : { type : Object, default : ()=>{}},

			reloadDetails : { type : Function },

      		archive:{type: Boolean, default: true},
		},

		data(){

			return {

				tags : [],

				loading : false,

				checked :false,

				selectedTags : [],

				show_loader : false,

				search : '',

				labelStyle : { display : 'none'},
			}
		},

		beforeMount(){

			this.getSelectedTags();
		},

		methods :{

			onChange(value,name) {

				this[name] = value;
			},

			getSelectedTags(){

				if(this.ticketObj.tags){

					this.ticketObj.tags.forEach(el=>{

						this.selectedTags.push(el.name)
					})
				}
			},

			subString(value){

				return getSubStringValue(value,30)
			},

			onCancel(){

				var element = document.getElementById("dropdown-tag");

  				element.classList.remove("show");

  				this.loading = false
			},

			onClick(tag){

				if(this.selectedTags.includes(tag)){

					for(var i in this.selectedTags){

						if (this.selectedTags[i] === tag) {

					      this.selectedTags.splice(i, 1);

					      break;
					   }
					}
				} else {
					this.selectedTags.push(tag)
				}
			},

			onSubmit(){


				if(this.tags.length > 0){

					this.tags.forEach(el=>{

						if(!this.selectedTags.includes(el.name)){

							this.selectedTags.push(el.name)
						}
					});
				}

				this.loading = true;

				const data = {};

				data['ticket_id'] = this.ticketObj.id;

				data['tags'] = this.selectedTags;

				axios.post('/add-tag',data).then(res=>{

					this.loading = false;

					this.tags = [];

					this.onCancel();

					this.reloadDetails('tag');

					successHandler(res,'timeline');

				}).catch(error=>{

					this.loading = false;

					errorHandler(error,'timeline');

					this.selectedTags = this.selectedTags.filter((value)=>{ return value.length < 21;});

				})
			},

      loadLabel(label) {
        return renderLabelWithEmoji(label);
      }
		},

		components : {

			'dynamic-select': DynamicSelect,
		}
	};
</script>

<style scoped>

	.btn-sm {
   	background-image: inherit !important;
	}

	.btn-group{
		margin-left: 0 !important;
	}
	.tags_div{
		margin: 6px 3px 3px 3px;
	}

	.tags:hover,.active{
		background: #eee;
	}

	.tags{
		cursor: pointer;
		margin: 2px;
	}

	#tag_title{
		cursor: pointer;
		margin-bottom: 3px !important;
    	font-weight: 500;
	}

	.tags_menu{
		width: 300px;
    padding: 10px;
    max-height: 200px;
    overflow-y: auto;
    overflow-x: hidden;
    padding-top: 0 !important;
	}

	#tags-dropdown::-webkit-scrollbar-track
  {
    background-color: #f1f1f1;
    border-radius:10px;
  }

  #tags-dropdown::-webkit-scrollbar
  {
    width: 6px;
    background-color: #f1f1f1;
  }

  #tags-dropdown::-webkit-scrollbar-thumb
  {
    background-color: #c1c1c1;
    border-radius: 10px;
  }

	.tag_button{
		margin: 3px;
		margin-top: 10px;
	}

	.left{
		float : left;
	}

	.right{
		float : right;
	}

	.has-search .form-control-feedback {

    color: #ccc;
	}

	.cancel{
		float: right;
    margin: 4px;
	}

	.cancel_ar{
		float: left;
    margin: 4px;
	}

	#tag_icon{
		margin-left: 5px;
	}

	#tags-div .btn-xs { font-size: .75rem !important;}
</style>
