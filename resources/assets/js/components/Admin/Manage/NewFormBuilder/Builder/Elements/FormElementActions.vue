<script setup>

import {computed} from "vue";

import {useStore} from "vuex";
const store = useStore();

import {useRoute, useRouter} from "vue-router";
const router = useRouter();
const currentRoute = useRoute();

import {boolean} from "../../../../../../helpers/extraLogics";

/**
 * Computed property to get form menus from the store
 */
const menuItems = computed(() => store.getters.getFormMenus);
/**
 * Computed property to get form category type from the store
 */
const categoryType = computed(() => store.getters.getFormCategoryType);

/**
 * Component properties:
 * - fieldData: Object - The data of the field being edited.
 * - onEditFormField: Function - Function to handle editing of the form field.
 * - isChild: Boolean - Indicates if the component is a child component.
 * - auth: Object - Authentication information.
 */
const props = defineProps({

	elementData: { type: Object, required: true },

	onEditFormField: { type: Function, required: true },

	onChildClick: { type: Function, required: false },

	onColumnClick: { type: Function, required: false },

	selectedOption: { type: [String, Object], required: false },

	isSection : { type : Boolean, default : false},

	sectionDeletable : { type : Boolean, default : false},
})

/**
 * Function to determine whether to show redirect link
 * @param {String} value - The value of the unique identifier
 * @returns {Boolean} - Indicates whether to show redirect link
 */
const showRedirect = (value) => {

	let links = ['requester', 'status_id', 'priority_id', 'location_id', 'asset_type_id', 'product_id',
		'source_id', 'help_topic_id', 'department_id', 'team_id', 'type_id', 'assigned_id', 'asset_ids'
	];

	if (categoryType.value === 'change') {

		links = links.filter(link => link !== 'status_id' && link !== 'priority_id');
	}

	return links.includes(value.unique)
}

/**
 * Function to handle redirect
 * @param {String} value - The value of the unique identifier
 */
const onRedirect = (value) => {

	const routes = {
		requester: 'panel/user/list',
		status_id: categoryType.value === 'asset' ? 'Asset Status' : 'Status',
		priority_id: 'Ticket Priority',
		location_id: 'Locations',
		source_id: 'Source',
		help_topic_id: 'Helptopic',
		department_id: 'Departments',
		team_id: 'Teams',
		type_id: 'Ticket Types',
		assigned_id: 'Agents',
		asset_type_id: 'Asset Type',
		product_id: 'Products',
		asset_ids: 'panel/service-desk/assets'
	};

	const route = routes[value.unique];

	if (route) {

		if (value.unique === 'requester' || value.unique === 'asset_ids') {

			window.location.href = route;

		} else {

			router.push({ name: route });
		}
	}
}

/**
 * Function to update column size
 * @param {String} type - The type of column
 */
const updateColumnSize = (type) => {

	window.emitter.emit('updateColumnSize',type);

	props.onColumnClick(type,props.elementData)
}

/**
 * Function to remove element at specified index
 */
const removeElementAt = () => {

	window.emitter.emit('onRemoveElement', {'fieldData': props.elementData, reference_id : props.elementData.reference_id, reference_type : props.elementData.reference_type});
}

/**
 * Function to check if child can be added
 * @returns {Boolean} - Indicates whether child can be added
 */
const canAddChild = () => {

	if(categoryType.value !== 'ticket' && categoryType.value !== 'requester' && props.elementData.label === 'Department') return false;

  if(Array.isArray(props.selectedOption) && props.selectedOption.length) {
    return !props.selectedOption[0].hasOwnProperty('extraKey')
  }

	return typeof props.selectedOption !== 'string' && boolean(props.selectedOption) && !props.selectedOption.hasOwnProperty('extraKey');
}

const onChildSelect = (item, index, selectedOption) => {
	props.onChildClick(index, selectedOption);
	window.emitter.emit('updateMenuOnChildSelect', item);
}

const isFieldDeletable = computed(() =>{
	if(currentRoute.name === 'ticket.sections.create' || currentRoute.name === 'ticket.sections.edit' || props.elementData.id.toString().length > 10) {
		return true;
	} else {
		return !props.sectionDeletable;
	}
})
</script>

<template>

	<div :class="isSection ? 'card-tools' : 'btn-group'">

		<template v-if="isSection">

			<div class="btn-group">

				<button type="button" class="btn btn-tool dropdown-toggle" data-bs-toggle="dropdown" data-offset="-52"
					aria-expanded="false" v-tooltip="trans('settings')">

					<i class="fas fa-cog"></i>
				</button>

				<div class="dropdown-menu" role="menu">

					<a @click="updateColumnSize('single', elementData)" href="javascript:;" class="dropdown-item">
						{{ trans('single-column') }}
					</a>

					<a @click="updateColumnSize('double', elementData)" href="javascript:;" class="dropdown-item">
						{{ trans('double-column') }}
					</a>

					<a href="javascript:;" class="dropdown-item" @click="onEditFormField(elementData)">

						{{ trans('edit') }}
					</a>

					<a class="dropdown-item text-danger" v-if="elementData.is_deletable" @click="removeElementAt()" href="javascript:;">
						{{ trans('delete') }}
					</a>
				</div>
			</div>
		</template>

		<template v-else>

			<span v-if="showRedirect(elementData)" class="btn btn-sm form_elem_btn" v-tooltip="trans('edit')" @click="onRedirect(elementData)">

				<i class="fas fa-pencil-alt text-gray text-md" aria-hidden="true"></i>
			</span>

			<span class="btn btn-sm form_elem_btn" v-tooltip="trans('settings')" @click="onEditFormField(elementData)">

				<i class="fas fa-cog text-gray text-md" aria-hidden="true"></i>
			</span>

			<span class="dropdown btn btn-sm form_elem_btn" v-if="canAddChild()" data-bs-toggle="dropdown">

				<span v-tooltip="trans('add_child')"><i class="fas fa-plus text-md" aria-hidden="true"></i></span>
			</span>

      <ul class="dropdown-menu form-drop p-1" role="menu" aria-labelledby="dropdownMenu">

        <template v-for="(item, index) in menuItems.filter(obj => obj.data_type !== 'section')" :key="item.id">

          <li v-if="item.count && item.count >= 1" @click="onChildSelect(item, index, selectedOption)" class="nav-item p-2 py-1">

            <a class="nav-link text-dark" href="javascript:void(0);">{{ item.title }}</a>
          </li>

          <li v-else class="nav-item disabled-nav"><span class="nav-link text-dark">{{ item.title }}</span></li>
        </template>
      </ul>

			<span class="btn btn-sm form_elem_btn" v-tooltip="trans('delete')" v-if="elementData.is_deletable" @click="removeElementAt()">

				<i class="far fa-trash-alt text-md" aria-hidden="true"></i>
			</span>
		</template>
	</div>
</template>

<style lang="css" scoped>
	.fb-movable-button {
		cursor: move;
	}
	.dropdown-menu {
		left: -125px;
		top: -125px;
	}
	.form-drop{
		z-index: 9999 !important;
		max-height: 200px !important;
		overflow-y: auto !important;
	}
	
	.form_elem_btn:hover {
		background-color: #eee !important;
		border-radius: 0px !important;
	}

  .disabled-nav { opacity: .3; cursor: not-allowed; }
</style>
