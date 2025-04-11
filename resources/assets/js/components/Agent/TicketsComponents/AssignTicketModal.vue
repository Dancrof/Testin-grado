<template>
	
	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">
	
		<template #title>
		
			<h4 class="modal-title">{{lang('assign_tickets')}}</h4>
		</template>

        <template #fields>

            <div v-if="!loading" class="row">

                <radio-button :options="radioOptions" :label="lang('assign_to')" name="assign" :value="assign"
                              :onChange="onChange" classname="form-group col-sm-4" ></radio-button>

                <div v-if="assignChange" id="assign_change">
                    <loader :size="30" :duration="4000" :color="'#1d78ff'"></loader>
                </div>

                <dynamic-select v-if="!assignChange && assign != 'assign_to_me'"
                                :label="lang('whome_do_you_want_to_assign_ticket')" :multiple="false"
                                name="assign_to"  classname="col-sm-8" :api-endpoint="'api/dependency/' + assign + ((assign == 'teams')?'?meta=true':'')"
                                :api-parameters="getApiParameters"
                                :value="assign_to" :onChange="onChange" strlength="65">
                </dynamic-select>
            </div>

            <div v-if="loading" class="row">

                <reuse-loader :animation-duration="4000" color="#1d78ff" :size="size" />
            </div>
        </template>

        <template #controls>

            <button type="button" @click="onSubmit()" class="btn btn-primary" id="submit_btn"
                    :disabled="isDisabled">

                <i class="far fa-hand-point-right"></i> {{lang('assign')}}
            </button>
        </template>
	</modal>
</template>

<script type="text/javascript">

    import {errorHandler,successHandler} from "../../../helpers/responseHandler";

	import axios from 'axios'
    import DynamicSelect from "../../MiniComponent/FormField/DynamicSelect.vue";
    import RadioButton from "../../MiniComponent/FormField/RadioButton.vue";

	export default {
		
		name : 'assign-ticket-modal',

		description : 'Assign ticket Modal component',

		props:{
			
			showModal:{type:Boolean,default:false},

			ticketIds : { type : Array, default : ()=>[] },

			tickets : { type : Array, default : ()=>[] },

			onClose:{type: Function, default : ()=>{} },

			componentTitle : { type : String, default :'UserTickets'},

			reloadTickets : { type : Function, default: () => {} },

			deptId : { type : [String, Number], default: '' },

			teamId : { type : [String, Number], default: '' },
		},

		data:()=>({
			
			isDisabled:true,

			containerStyle:{ width:'800px' },

			loading:false,

			size: 60,
	
			assign_to : '',

			assign : 'agents',

			radioOptions:[{name:'agent',value:'agents'},{name:'team',value:'teams'},{name:'assign_to_me',value:'assign_to_me'}],

			assignChange : false,
		}),

		computed :  {

			getApiParameters(){

				let params = {};

				params['supplements[ticket_id]'] = this.ticketIds;

				params['supplements[no_email]'] = 1;
				
				if(this.deptId) { params['department_ids[]'] = this.deptId;	}

				if(this.teamId) { params['team_id'] = this.teamId;	}

				if(this.tickets.length) {

					//returns department ids
					let filtered = this.tickets.filter(item => this.ticketIds.includes(item.id)).map((obj)=>obj.department.id);

					// removes duplicate department ids
					params['department_ids'] = filtered.filter((value,index)=> filtered.indexOf(value) === index);
				}
				
				return params;
			}
		},

		methods:{

		onChange(value, name){
			
			this[name]= value;

			if(name === 'assign'){

				this.assignChange = true;

	        	setTimeout(()=>{
	          
	          	this.assignChange = false;
	        	},1)

				this.assign_to = value != 'assign_to_me' ? '' : { id : sessionStorage.getItem('user_id') };

				this.isDisabled = value == 'assign_to_me' ? false : true;
			}

			if(name === 'assign_to'){
				
				this.isDisabled = value ? false : true
			}
		},

		onSubmit(){

			this.loading = true
			
			this.isDisabled = true

			var obj={
				'assign_to' : this.assign === 'teams' ? 'team_' + this.assign_to.id : 'user_' + this.assign_to.id, 
				'_method' : 'PATCH'
			};

			axios.post('/ticket/assign?ticket_id='+this.ticketIds,obj).then(res=>{
				
				this.loading = false;
				
				this.isDisabled = true

				this.reloadTickets('assign');

				successHandler(res,this.componentTitle);
				
				window.emitter.emit(this.componentTitle+'refreshData');
				
				window.emitter.emit(this.componentTitle+'uncheckCheckbox')

				window.emitter.emit('refreshUserReport')

				window.emitter.emit('refreshOrgReport')
				
				this.onClose();
				
			}).catch(err => {
				
				this.loading = false;
				
				this.isDisabled = false
				
				errorHandler(err,this.componentTitle);

				this.onClose();
			})
		},
	},

	components:{

		"dynamic-select": DynamicSelect,

		'radio-button': RadioButton,
	}
};
</script>

<style type="text/css">
	
	#assign_change{
	  padding: 10px;
	}
</style>