<template>

	<div class="email-status">

		<template v-if="data[status+'_status']">

			<span v-if="typeof data[status+'_status'] == 'string'">{{  trans(data[status+'_status']) }}</span>

			<template v-if="typeof data[status+'_status'] == 'object'">

				<span :class="'badge text-bg-'+data[status+'_status'].class" v-tooltip="formattedTime(data[status+'_status'].updated_at)">

					{{  trans(data[status+'_status'].status) }}
				</span>

				<i v-if="data[status+'_status'].exception" class="fas fa-question-circle text-primary ms-1 pointer"
					@click="showModal = true">

				</i>
			</template>
		</template>

		<span v-else>--</span>

		<transition name="modal">

			<email-exception v-if="showModal" :onClose="onClose" :showModal="showModal" :exception="data[status+'_status'].exception">

			</email-exception>
		</transition>
	</div>
</template>

<script>

	import {useStore} from "vuex";

	import {computed} from "vue";

	import EmailException from "./EmailException.vue";

	export default {

		name : 'email-status',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),
			}
		},

		props : {

			data : { type : Object, default : ()=>{} },

			status : { type : String, default : '' }
		},

		data () {

			return {

				showModal : false
			}
		},

		methods : {

			onClose() {

				this.showModal = false;
			}
		},

		components : {

			'email-exception' : EmailException
		}
	}
</script>