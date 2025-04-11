<template>
  <div class="infinite-dropdown">

    <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-bs-toggle="dropdown" @click.once="getData" :id="id" :title="dropdownTitleNonTruncated">
        {{ trans('ratings') }}
    </button>

    <div id="infinite-list" class="dropdown-menu dropdown-menu-right" style="max-height: 20vh; overflow-y: auto">

      <template v-if="loading" class="row">
        <reuse-loader :animation-duration="4000" color="#1d78ff" :size="20"/>
      </template>

      <template v-else>

        <template v-if="payload.length">
          <a class="dropdown-item" href="javascript:;" v-for="item in payload"
             :class="selectedEntry === item[nameKey] ? 'active' : ''" :key="item[nameKey]"
             :id="id" @click="itemSelected(item)" :title="item[nameKey]"
          >
            {{ dropdownItemName(item[nameKey]) }}
          </a>

        </template>

        <template v-else>
          <a  class="dropdown-item"  href="javascript:;"> {{ trans('no-records') }} </a>
        </template>

      </template>

    </div>

  </div>
</template>

<script>
  import { getSubStringValue } from "../../helpers/extraLogics";

  export default {
    name: "InfiniteDropdown",

    props: {
      id : { type: String, default: ''},
      label: { type: String, default: ''},
      api: { type: String, default: '' },
      limit: { type: Number, default: 10 },
      nameKey: { type: String, default: 'name' },
      eventKey: { type: String, required: true }
    },

    mounted() {
      const listElm = document.querySelector('#infinite-list');

      if (listElm) {
        listElm.addEventListener('scroll', e => {
          if(listElm.scrollTop + listElm.clientHeight >= listElm.scrollHeight) {
            this.loadMore();
          }
        });
      }
    },

    computed: {
      dropdownTitle() {
        return this.selectedEntry ? getSubStringValue(this.selectedEntry, 20) : this.trans(this.label);
      },

      dropdownTitleNonTruncated() {
        return this.selectedEntry ? this.selectedEntry : this.trans(this.label);
      }
    },

    data() {
      return {
        loading: false,
        page: 1,
        payload: [],
        selectedEntry: '',
        searchQuery: '',
        lastPage: 1,
      }
    },

    methods: {
      async getData() {
        this.loading = true;

        try {
          let response = await axios.get(`${this.api}?search_query=${this.searchQuery}&limit=${this.limit}&page=${this.page}`);
          this.payload = [...this.payload, ...response.data.data];
          this.payload.map((rating) => {
            if (rating.is_default) {
              this.selectedEntry = rating.name;
            }
          });
          this.page = response.data.current_page;
          this.lastPage = response.data.last_page;
        } catch (e) {
          this.payload = null;
        } finally {
          this.loading = false;
        }
      },

      loadMore() {
        if (this.page >= this.lastPage) { return }
        this.page++;
        this.getData();
      },

      itemSelected(selectedItem) {
        this.selectedEntry = selectedItem[this.nameKey];
        window.emitter.emit(this.eventKey, {...selectedItem, type: this.eventKey});
      },
      dropdownItemName(name) {
        return getSubStringValue(name, 20);
      }
    }
  }
</script>

<style scoped>
  a.dropdown-item.active {
    color: #fff !important;
    background-color: #337ab7;
    text-decoration: none;
    overflow: hidden;
  }
</style>