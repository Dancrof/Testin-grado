<template>
	<div class="ml_10">

	<div v-if="list.length > 0 && !loading">

        <draggable
            :list="list"
            class="list-group"
            ghost-class="ghost"
        >
            <template #item="{ element, index }">

                <breakline-menu :item="element" :indexValue="index" :formList="list"></breakline-menu>

            </template>
        </draggable>

		<div class="col-sm-12 mt-4 ms-1">
			<button class="btn btn-primary" @click="reOrder()" href="javascript:;">
			<span class="fas fa-save"> </span> {{lang('save')}}
		</button>&nbsp;
		<button  @click="showTable()" class="btn btn-secondary" href="javascript:void(0);">
			<span class="fas fa-times"> </span> {{lang('cancel')}}
		</button>
		</div>
	</div>
	<div v-if="loading" class="row" style="margin-bottom:30px">
		<reuse-loader :animation-duration="4000" color="#1d78ff" :size="60" :class="{spin: lang_locale == 'ar'}" />
	</div>
</div>
</template>

<script>

    import {errorHandler} from "../../../../helpers/responseHandler";
    import ReorderMenuBlock from "./ReorderMenuBlock.vue";
    import draggable from 'vuedraggable';

	export default {

		data(){

			return {

				list : [],

				base :  window.axios.defaults.baseURL,

				lang_locale : '',

				loading : true
			}
		},

		props : {
			
			url : { type : String, default : ''},

			onClose : { type : Function , default : ()=>[]},

			reorder_type : { type : String, default : 'breakline'},
		},

		components: {
            'breakline-menu': ReorderMenuBlock,
            draggable,
      	},

      	beforeMount(){
      		this.lang_locale = localStorage.getItem('LANGUAGE');
      		axios.get(this.url).then(res=>{
		      this.list = res.data.message.breakline
		      this.loading = false
		    }).catch(err=>{ 
		      this.loading = false
		    })
      	},

      	methods : {
		    reOrder(list){
		    	this.loading = true
		    	var fd = new FormData();
		    	for(var i in this.list){
					fd.append('enforcers['+i+'][id]', this.list[i].id);
					fd.append('enforcers['+i+'][breakline]', this.list[i].breakline);
				}
				fd.append('type', this.reorder_type);
				const config = { headers: { 'Content-Type': 'multipart/form-data' } };
		    	axios.post('/api/reorder-enforcer-list',fd,config).then(res=>{
		      		this.loading = false
		    		this.onClose()
		    		successHandler(res,'dataTableModal')
		    	}).catch(err=>{
		    		this.loading = false
		    		this.onClose()
		    		errorHandler(err,'dataTableModal')
		    	})
		    },
		    showTable(){
		    	this.onClose()
		    }
      	}
	};
</script>

<style scoped>

	.ml_10 { margin-left: -10px; }
</style>