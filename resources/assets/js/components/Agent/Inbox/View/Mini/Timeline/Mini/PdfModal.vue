<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>

			<h4 class="modal-title">{{trans('generate_pdf')}}</h4>
		</template>

		<template #fields>

			<template v-if="!loading">
				<div class="row">

					<radio-button :options="radioOptions" :label="trans('select_an_action')" name="pdf" :value="pdf"
								  :onChange="onChange" classname="form-group col-sm-12" optionClass="col-sm-4"></radio-button>

				</div>

				<div v-if="pdf === 'default'" class="row">

					<template v-if="loggedUserRole == 'agent'">
						<div class="col-sm-12" v-for="item in defaultOptions.slice(0,3)" :key="item.key">

							<checkbox :name="item.key" :value="item.checked" :label="item.name" :title="item.name" :onChange="onCheck" :id="item.key"
									  defaultClass="" labelClass="fw-400"/>
						</div>
					</template>
					<template v-else>
						<div class="col-sm-12" v-for="item in defaultOptions" :key="item.key">

							<checkbox :name="item.key" :value="item.checked" :label="item.name" :title="item.name" :onChange="onCheck" :id="item.key"
									  defaultClass="" labelClass="fw-400"/>
						</div>
					</template>
				</div>

				<div v-if="pdf === 'custom'" class="row">

					<dynamic-select :label="trans('templates')" :multiple="false" name="template" :required="true"
									classname="col-sm-12" apiEndpoint="/api/get/pdfTemplates"
									:value="template" :onChange="onChange">

					</dynamic-select>

				</div>
			</template>

			<div v-if="loading" class="row">

				<reuse-loader :animation-duration="4000" color="#1d78ff" :size="size" />
			</div>
		</template>

		<template #controls>
			<button type="button" @click="generatePdf" class="btn btn-primary" id="submit_btn">

				<i class="fas fa-check"></i> {{trans('generate_pdf')}}
			</button>
		</template>

	</modal>
</template>

<script>
	
	import RadioButton from "../../../../../../MiniComponent/FormField/RadioButton.vue";
	import Checkbox from "../../../../../../MiniComponent/FormField/Checkbox.vue";
	import DynamicSelect from "../../../../../../MiniComponent/FormField/DynamicSelect.vue";
  import axios from "axios";
  import {errorHandler, successHandler} from "../../../../../../../helpers/responseHandler";
  import TextField from "../../../../../../MiniComponent/FormField/TextField.vue";

	export default {
		
		name : 'generate-pdf-modal',

		props:{
			
			showModal:{type:Boolean,default:false},

			ticket : { type : Object, default : ()=>{} },

			onClose:{type: Function, default : ()=>{} }
		},

		data:()=>({
			
			containerStyle:{ width:'860px' },

			loading:false,

			pdf : 'default',

			radioOptions:[],

            defaultOptions : [
                { key : 'ticketConversation', name : 'ticket_conversations', checked : false },
                { key : 'internalNote', name : 'ticket_conversation_with_notes', checked : false },
                { key : 'allTicketDetails', name : 'ticket_conversation_with_details', checked : false },
                { key : 'requesterDetails', name : 'ticket_conversation_with_requester_details', checked : false },
                { key : 'assignedAgentDetails', name : 'ticket_conversation_with_agent_details', checked : false },
            ],

            template : ''
        }),

    beforeMount() {
      this.radioOptions = [{name:'default_pdf_template',value:'default'}, {name:'customized_pdf_template',value:'custom'}]
    },
    methods:{

            onCheck(value,name) {

                this.defaultOptions.forEach(function(element) {

                    if(element.key == name) {

                        element.checked = value;

                        return;
                    }
                });
            },

            onChange(value, name){

                this[name]= value;

                if(name === 'pdf') {

                    this.defaultOptions.forEach(function(element) {

                        element.checked = false;
                    });
                }
            },

            generatePdf(){

                let link = '';

                if(this.pdf === 'default') {

                    for(let i in this.defaultOptions) {

                        link += this.defaultOptions[i].key+"="+this.defaultOptions[i].checked+"&";
                    }
                } else {

                    if(this.template) {

                        link = 'template_id='+this.template.id;

                        this.$store.dispatch('unsetValidationError');

                    } else {


                        this.$store.dispatch('setValidationError', {'template' : 'This field is required'});

                        return
                    }
                }

                if(link[link.length-1] === '&') {

                    link = link.slice(0, -1);
                }

                this.loading = true;

              axios.get('/ticket/print/'+this.ticket.id+"?"+link)
                  .then(res => {

                    if (res.data.message) {
                      successHandler(res, 'timeline')
                      this.onClose()
                      this.loading = false;
                    } else {
                      this.loading = false;
                      this.openInNewTab(this.basePath() + '/ticket/print/'+this.ticket.id+"?"+link )
                      this.onClose();
                    }

                  })
                  .catch(err =>{

                    this.onClose();

                    errorHandler(err, 'timeline');
                  });
            },

            openInNewTab(url) {
                const newWindow = window.open(url, '_blank');
                if (newWindow) {
                   newWindow.focus();
                }
            },
        },

	components:{
        'checkbox': Checkbox,

        'dynamic-select': DynamicSelect,

		'radio-button': RadioButton,

    'text-field' : TextField

	}
};
</script>