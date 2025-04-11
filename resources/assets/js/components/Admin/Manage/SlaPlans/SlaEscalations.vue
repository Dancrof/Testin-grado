<template>
	
	<div class="card card-light">
		
		<div class="card-header">
			
			<h3 class="card-title">{{lang('set_escalation')}}</h3>

			<tool-tip :message="lang('what_happens_when_this_SLA_is_violated?')" size="medium"></tool-tip>
		</div>

		<div class="card-body">
			
			<div>
				
				<p v-html="lang('set_escalation_rule_when_a_ticket_is_not_responded_on_time')" id="desc"></p>

				<dynamic-sla-field :fieldsArr="responded" fieldGroup="responded" :onFieldChange="getFields" from="violated">
					
				</dynamic-sla-field>
			</div><br>

			<div>
				
				<p v-html="lang('set_escalation_hierarchy_when_a_ticket_is_not_resolved_on_time')" id="desc"></p>

				<dynamic-sla-field :fieldsArr="resolved" fieldGroup="resolved" :onFieldChange="getFields" from="violated">
					
				</dynamic-sla-field>
			</div>
		</div>	
	</div>
</template>

<script>
	
	import ToolTip from "../../../MiniComponent/ToolTip.vue";
    import DynamicSlaField from "./MiniComponents/DynamicSlaField.vue";

    export default {

		name  : 'sla-escalations',

		description : 'SLA Escalation settings page',

		props : {

			getUpdateArray : { type : Function },

			violated : { type : Array, default : ()=>[]}
		},

		data(){

			return { 

				responded : [],

				resolved : [],
			}
		},

		beforeMount(){

			if(this.violated.length > 0){

				for(let i in this.violated){

                    if(this.violated[i].reminder_delta.includes('~')) {

                        let reminder = this.violated[i].reminder_delta.split('~');

                        let delta = reminder[reminder.length -2].split('::');

                        this.violated[i]['option'] = reminder[reminder.length -1];

                        this.violated[i]['reminder_delta'] = delta[delta.length -1];

                        if(this.violated[i].type === 'responded' || this.violated[i].type === 'response'){

                            this.responded.push(this.violated[i])

                        } else {

                            this.resolved.push(this.violated[i])

                        }
                    }
				}
			}
		},

		methods : {

			getFields(name,array){

				this[name] = array;

				this.getUpdateArray(this.responded, this.resolved)
			}
		},

		components : {

			"tool-tip": ToolTip,

			"dynamic-sla-field": DynamicSlaField,
		}
	};
</script>

<style scoped>
	#desc {
		margin: 5px 0px 10px 0px !important;
	}
</style>