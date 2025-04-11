<template>
	<div id="ticket-template-details">

		<div class="row" v-focus-first-input>
			
			<text-field :label="trans('name')" type="text" name="name" :value="name" :onChange="onChange" :placehold="lang('enter_a_value')"
			            :required="true" classname="col-sm-6" rules="required" :autofocus="true">
				
			</text-field>
			
		</div>
	</div>
</template>

<script>

import {useStore} from 'vuex'
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import {computed} from "vue";

export default {

	setup() {

		const store = useStore();

		return {

			getTemplateAdditionalInfo : computed(()=>store.getters.getTemplateAdditionalInfo)
		}
	},

	props : {
		
		template_mode : { type : String, default : '' },
	},
	
	data () {
		
		return {
			
			name: ''
		};
	},
	
	components: {
		
		'text-field': TextField,
	},
	
	beforeMount () {
		
		if(this.template_mode == 'edit'){
			this.formatState(this.getTemplateAdditionalInfo);
		}
	},
	
	methods: {
		
		onChange (value, name) {
			
			this[name] = value;
			
			this.$store.dispatch('updateTemplateProperties', { key: name, value: this[name] });
		},
		
		formatState(valueObject) {
			
			for (const [name, value] of Object.entries(valueObject)) {
			
				this[name] = value;
			}
		}
	},
	
	watch: {
		
		getTemplateAdditionalInfo: {
			
			handler(valueObject) {
			
				this.formatState(valueObject);
			},
			
			deep: true
		}
	}
};
</script>

<style scoped>

	#ticket-template-details {
		/*margin-bottom: 2rem;*/
	}
</style>