<script setup>

import {computed, onBeforeMount, ref} from "vue";
import {errorHandler} from "../../../../helpers/responseHandler";
import Alert from "../../../MiniComponent/Alert.vue";
import ReuseLoader from "../../../Client/Pages/ReusableComponents/Loader.vue";

// The list of forms.
const formsList = ref([]);
// Indicates whether loading is in progress.
const loading = ref(true);
/**
 * Fetches the list of forms from the server.
 */
const getForms = () => {

	loading.value = true;

	axios.get('/admin/manage/forms').then(res=>{

		formsList.value = res.data.data;
		
		loading.value = false;

	}).catch(err=>{

		loading.value = false;

		errorHandler(err,'forms-entry-page')
	})
}

/**
 * Computed property for grouping forms by type.
 */
const groupedForms = computed(() => {

	return formsList.value.reduce((grouped, field) => {

		if (!grouped[field.type]) {

			grouped[field.type] = [];
		}

		grouped[field.type].push(field);

		return grouped;
	}, {});
});

onBeforeMount(()=>{

	getForms();
});

</script>

<template>

	<div class="col-sm-12">

		<Alert component-name="forms-entry"></Alert>

		<ReuseLoader v-if="loading"></ReuseLoader>

		<div class="card card-light" v-for="(group, type) in groupedForms">

			<div class="card-header">

				<h3 class="card-title text-capitalize">{{ trans(type) }}</h3>
			</div>

			<div class="card-body">

				<div v-if="!loading" class="row">

					<div class="col-md-2 col-sm-6" v-for="(form,index) in group" :key="index">

						<div class="settingiconblue">

							<div class="settingdivblue">

								<router-link :to="!form.is_multiple ? '/new/forms/'+form.category+'/'+form.id+'/edit' : '/new/forms/'+form.category+'/list'" v-tooltip="trans(form.title)">

									<span class="fa-stack fa-2x">

										<i :class="['fas ' + form.icon_class, 'fa-stack-1x']"></i>
									</span>
								</router-link>
							</div>

							<div class="text-center text-sm fw_400">{{ trans(form.title) }}</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>
</style>