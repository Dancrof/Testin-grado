<script setup>

import {onBeforeMount, ref} from "vue";

import ReuseLoader from "../../../Client/Pages/ReusableComponents/Loader.vue";

import globalMixin from "../../../../mixins/globalMixin";
import FieldSettings from "../../Manage/NewFormBuilder/Builder/FieldSettings.vue";
import Alert from "../../../MiniComponent/Alert.vue";

import {errorHandler, successHandler} from "../../../../helpers/responseHandler";
const { basePathVersion } = globalMixin.methods;

import {useRoute, useRouter} from "vue-router";
const router = useRouter();
const route = useRoute();
import {useStore} from "vuex";
const store = useStore();

const props = defineProps({

	auth : { type : Object, default : () => {} }
});

const formMenus = ref([]);

const hasMenuLoaded = ref(false);
const hasSettingsLoaded = ref(true);
const loading = ref(false);

const selectedFieldType = ref('');
const getMenu = () => {

	axios.get('api/get-form-menu/ticket').then(res => {

		formMenus.value = res.data.data.map((sub) => ({
			...sub,
			showOnlyIcon : false
		})).filter(obj => obj.data_type !== 'section');

		hasMenuLoaded.value = true;
	});
}

const onMouseEnter = (item) => {

	item.showOnlyIcon = true;
}

const onMouseLeave = (item) => {

	item.showOnlyIcon = false;
}

const onAdd = (item) => {

	hasSettingsLoaded.value = false;

	setTimeout(()=>{

		hasSettingsLoaded.value = true;
	},1000);

	selectedFieldType.value = item
}

const applySettings = () => {

	if(selectedFieldType.value.options && selectedFieldType.value.options.length) {

		for (let i = 0; i < selectedFieldType.value.options.length; i++) {

			selectedFieldType.value.options[i].sort_order = i;
		}
	}

	loading.value = true;

	axios.post('/post/field-managers/ticket', selectedFieldType.value).then(res=>{

		loading.value = false;

		successHandler(res,'ticket-fields-form');

		if(route.name === 'ticket.fields.edit') {

			getData(route.params.id,route.params.type);

		} else  {

			setTimeout(()=>{

				router.push({ name: 'ticket.fields.index' });

			},3000);
		}
	}).catch(err => {

		loading.value = false;

		errorHandler(err,'ticket-fields-form');
	})
}

onBeforeMount(()=>{

	getMenu();

	if(route.name === 'ticket.fields.edit') {

		getData(route.params.id,route.params.type);
	}
});

const getData = (field_id,field_type) => {

	loading.value = true;

	axios.get('/field-manager/ticket?data_type='+field_type+'&id='+field_id+'&time='+Date.now()).then(res=> {

		loading.value = false;

		selectedFieldType.value = res.data.data;

	}).catch(err=>{

		loading.value = false;

		errorHandler(err,'ticket-fields-form')
	});
}

const getClass = (menu) => {
	
	if(!menu.count) { return 'bg-light pe-none' };

	if(route.name === 'ticket.fields.edit') {

		return selectedFieldType.value.title === menu.title ? 'bg-primary pe-none' : 'bg-light pe-none'
	}

	return selectedFieldType.value.title === menu.title ? 'bg-primary pe-none' : 'bg-light'
}

const onLangRemoved = () =>{

	loading.value = true;

	setTimeout(()=>{

		if(route.name === 'ticket.fields.edit') {

			getData(route.params.id,route.params.type);

		} else {

			loading.value = false;
		}
	},3100);
};

window.emitter.on('formLangRemovedInDb',onLangRemoved);
window.emitter.on('formLangRemoved',onLangRemoved);

</script>

<template>

	<div class="col-sm-12">

		<Alert component-name="ticket-fields-form"></Alert>

		<div class="card card-light">

			<div class="card-header">

				<h3 class="card-title">{{ trans('add_field') }}</h3>
			</div>

			<div class="card-body">

				<ReuseLoader v-if="!hasMenuLoaded || loading"></ReuseLoader>

				<div v-if="hasMenuLoaded && !loading" class="row">

					<div class="col-sm-4">

						<div class="row">

							<div v-for="(menu,index) in formMenus" class="col-sm-6" :key="index">

								<div class="info-box menu-info-box" :class="getClass(menu)" :key="menu.id" @click="onAdd(menu)"
									 @mouseenter="onMouseEnter(menu)" @mouseleave="onMouseLeave(menu)">

									<div v-if="(route.name === 'ticket.fields.edit' && selectedFieldType.title !== menu.title) || !menu.count" class="overlay"></div>

									<span v-if="menu.icon_class && !menu.showOnlyIcon" class="info-box-icon menu-icon">

										<i :class="['fas', menu.icon_class]"></i>
									</span>

									<div class="info-box-content" :class="menu.showOnlyIcon && selectedFieldType.title !== menu.title ? 'text-center' : ''">

										<span class="info-box-text">

											<template v-if="!menu.showOnlyIcon">{{ menu.title }}&nbsp;
												<small class="badge badge-count-right p-1">{{ menu.count ? menu.count : 0 }}</small>
											</template>

											<template v-if="menu.showOnlyIcon && menu.count"> <i class="fas fa-plus fa-2x text-muted"></i></template>

										</span>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="col-sm-8">

						<ReuseLoader v-if="!hasSettingsLoaded"></ReuseLoader>

						<div v-else class="row">

							<div class="col-sm-12">

								<FieldSettings v-if="selectedFieldType" :field-data="selectedFieldType" :auth="auth" :showCloseBtn="false" from="ticket-fields-form" :fieldUpdate="applySettings"
								               settingBtnName="save" :showInModal="false">

								</FieldSettings>

								<template v-else>

									<div class="row no-drag-form-card">

										<div class="text-center pt-4 no-drag-fields">

											<i class="fas fa-mouse-pointer"></i>
											<img :src="basePathVersion()+'/themes/default/common/images/drag.png'" alt="form-no-drag"
												 class="no-select-img">

											<h5>{{ trans('select_an_element_from_the_left') }}</h5>
										</div>
									</div>
								</template>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>

	.menu-info-box {
		cursor: pointer;
		min-height: 40px !important;
		border: 1px dashed #c0c3c4;
		margin-bottom: 0.5rem !important;
		padding: 0px !important;
	}

	.no-drag-form-card { min-height: 170px; }

	.no-drag-fields { top: 0; left: 0; right: 0; bottom: 0; opacity: 0.3; }

	.no-select-img { width: 200px; height: 200px; }

	.menu-icon { font-size: 1.3rem!important; width: 60px!important; }

	.cursor-drag { cursor : move; }
	
	.badge-count-right { background-color: #adb5bd !important; color: #fff; float: right; margin-top: 5px;}
</style>