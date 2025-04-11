<template>

	<div class="col-sm-4 margin-bottom-15" v-if="showField">

		<label>{{label}}</label>

		<v-select
			multiple
			class='faveo-dynamic-select'
			ref='faveoDynamicSelect'
			:id="api+keyname"
			v-model:modelValue="filter_selected"
			label="name"
			:options="filter_options"
      :placeholder="lang('search_or_select')"
			:filterable="false"
            @update:modelValue="onValueChange"
			@search="onSearch"
			@open="onOpen"
			@close="onClose"
			@search:blur="clearSearchQuery"
		>
      <template #spinner="{ loader }" >
        <loader v-if="isLoading" class="loader-area" :duration="4000" :size="20"></loader>
      </template>
		<template #no-options="{search, searching}">
 			<span></span>
			<template v-if="searching">{{lang('no_results_found_for')}} <em>{{ search }}</em>. </template>
			<template v-else>
				<span v-if="!isLoading && !hasNextPage">{{lang('no_options_found')}}</span>
<!--				<loader v-if="isLoading && !hasNextPage" :duration="4000" :size="25"></loader> -->
			</template>
		</template>

			<template #option="option">

				<div class="d-center" :title="keyname === 'label-ids' ? (loadLabel(option.name)) : option.name">

					<faveo-image-element v-if="option.profile_pic" id="faveo-dynamic-select-img" :source-url="option.profile_pic"
                                         img-height="20" img-width="20" alternative-text="User"/>
          <i :style="{ color: option.icon_color }" :class="option.icon_class || option.icon" aria-hidden="true"></i>

          <template v-if="keyname === 'label-ids'">
            <span v-html="loadLabel(subString(option.name))"></span>
          </template>
          <template v-else>
            {{ subString(option.name) }}
          </template>
				</div>
			</template>

			<template #selected-option="option">

				<div class="selected d-center" :title=" keyname === 'label-ids' ? (loadLabel(option.name)) : option.name">

					<faveo-image-element id="faveo-dynamic-select-img" v-if="option.profile_pic" :source-url="option.profile_pic"
                                         img-height="20" img-width="20" />
          <i :style="{ color: option.icon_color }" :class="option.icon_class || option.icon" aria-hidden="true"></i>

          <template v-if="keyname === 'label-ids'">
            <span v-html="loadLabel(subString(option.name))"></span>
          </template>
          <template v-else>
            {{ subString(option.name) }}
          </template>
				</div>
			</template>

			<template #list-footer v-if="hasNextPage">
				<li ref="load" >
<!--					<loader :duration="4000" :size="25"></loader>-->
				</li>
			</template>
		</v-select>

	</div>
</template>
<script>

	import vSelect from "vue-select";

  import {getSubStringValue, renderLabelWithEmoji, parseUrlParams} from "../../../../helpers/extraLogics";

	import _ from 'lodash';

		export default {

			props: {
				label: {
					type: String,
					required: true
				},
				api: {
					type: String,
					required: true
				},
				keyname: {
					type: String
				},
				base: {
					type: String
				},
				meta: {
					type: Boolean
				},

				/**
			 * selected options(Gets updated to `filter_selected` as soon as its value changes) (Array of objects)
			 * @type {Array}
			 */
			value: {
				type: Array
			},

			/**
			 * method that gets called as soon as any option is selected here, to notify parent about the updated values
			 * @type {Function}
			 */
			updateFilter: {
				type: Function
			},

			/**
			 * If this component is required to be reset
			 * @type {Boolean}
			 */
			reset: {
				type: Boolean
			}
		},

		data(){
			return{
				filter_options:[],
				filter_selected:[],
				filter_obj: {},
				isLoading: false,
				page: 0,
				observer: null,
				next_page_url: '',
				searchQuery: '',
                showField:false
			}
		},

		components: {
			'v-select': vSelect,
		},

		mounted() {

            this.filter_selected = this.value;
            // Intentionally added 1 sec timeout for avoiding initial errors on page load
            setTimeout(()=>{
                this.showField = true
            },1);

			this.observer = new IntersectionObserver(this.infiniteScroll);
		},

		watch: {

			// value(val){
			// 	/**
			// 	 * Triger `input` event if value changed
			// 	 * Used in case of autofill the selected values
			// 	 * Though it's not a good practice to emit event of plugin wrapper, we don't have any solution to update the sected valyes to the parent
			// 	 * This should be ommited when this component will be rewritten
			// 	 */
			// 	this.$refs.faveoDynamicSelect.$emit("input", val);
			// },

            // TODO This `value` watcher needs refactoring
            value(newValues, oldValues) {
                this.filter_selected = newValues;
                this.tagsChanged(this.keyname,newValues);
            },

			reset(val){
				if(val){
					this.filter_selected = [];
					this.filter_obj = {};
				}
			}
		},

		computed: {
			hasNextPage() {
				return this.next_page_url !== null;
			}
		},

		methods: {

            onValueChange(value) {
                this.tagsChanged(this.keyname,value);
            },

			subString(value) {
				
				return getSubStringValue(value, 35)
			},

			onSearch(searchQuery) {
				this.page = 1;
				this.searchQuery = searchQuery;
				this.search(this);
			},

			search: _.debounce((vm) => {
				vm.getDataFromServer(true);
			}, 350),

			getDataFromServer(isRefresh, target) {
				this.isLoading = true;
				axios.get('api/' + this.base + '/' + this.api, { params: this.getApiParams() })
				.then((response) => {
					this.postApiResponseOperations(response.data.data, isRefresh, target)
				})
				.catch((error) => {
					console.log(error);
				})
				.finally(() => {
					this.isLoading = false;
				})
			},

			async postApiResponseOperations(responseData, isRefresh, target) {
				this.next_page_url = responseData.next_page_url;
				if(isRefresh) {
					this.filter_options = responseData.data;
				} else {
					const ul = target.offsetParent;
      		const scrollTop = target.offsetParent.scrollTop;
					this.filter_options.push(...responseData.data);
					await this.$nextTick();
      		ul.scrollTop = scrollTop;
				}
			},

			getApiParams() {
				const urlParams = parseUrlParams();
				return {
					...urlParams,
					'search-query': this.searchQuery || undefined,
					'page': this.page || undefined,
					'meta': this.meta || undefined,
					'paginate': 1
				}
			},

			clearSearchQuery() {
				this.$refs.faveoDynamicSelect.onEscape()
			},

			//tag changed
			tagsChanged(x,arrayList){
				if(arrayList && arrayList.length!=0){
					var filterArray=[];
					for(var i in arrayList){
						filterArray.push(arrayList[i].id);
					};
					this.filter_obj[x]=filterArray;
				}
				else{
					this.filter_obj[x]=[];
				}

				this.$emit('selected',this.filter_obj);
				let selectedFilterWithKey = {};
				selectedFilterWithKey[this.keyname] = this.filter_selected;
				this.updateFilter(selectedFilterWithKey);
			},

			async infiniteScroll ([{isIntersecting, target}]) {
				if (isIntersecting) {
					this.page += 1;
					this.getDataFromServer(false, target)
				}
			},

			async onOpen(something) {
				if (this.hasNextPage) {
					await this.$nextTick();
					this.observer.observe(this.$refs.load);
				}
			},

			onClose() {
				this.observer.disconnect();
        this.isLoading = false;
			},

      loadLabel(label) {
        return renderLabelWithEmoji(label);
      }
		}
	}
</script>

<style scoped>
#faveo-dynamic-select-img {
	border: 1px solid transparent;
	width: 18px;
	border-radius: 10px;
	margin-top: -1px;
}

.vs__actions .loader-area {
  order: -1; /* Place the loader before other actions */
  margin-right: 5px; /* Adjust the margin as needed */
}

</style>
