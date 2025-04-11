<template>
  <div class="element-list-box">
    <span v-if="listElements.length === 0">--</span>
    <template v-if="listElements.length > 0">
      <div v-for="element in listElements" :key="element.id">
        <template v-if="element.url && element.url.includes('admin')">
          <a :href="element.url">{{element.name}}</a>
        </template>
        <template v-else-if="element.url">
          <router-link :to="element.url">{{element.name}}</router-link>
        </template>

        <template v-else>
          <a href="javascript:;">{{element.name}}</a>
        </template>
      </div>
      <div>
        <button class="btn btn-light btn-sm" v-if="displayShowAllButton" @click="readMore">{{trans('show_all')}}</button>
        <button class="btn btn-light btn-sm" v-if="!isReadMore" @click="readLess">{{trans('show_less')}}</button>
      </div>
    </template>
  </div>
</template>

<script>
  export default {
    name: "SimpleTableListElements",

    props: ['data', 'index', 'column'],

    data() {
      return {
        limit: 2, // Limit of data element to show
        isReadMore: true // used to toggle buttons `show_all` and `show_less`
      }
    },

    computed: {
      /** List down elements on the basis of limit */
      listElements: function() {
        let listData = this.data[this.column];

        if (!listData) {
          return [];
        }

        return listData.slice(0, this.limit);
      },

      /**
       * Check whether to show the show all button or not
       * Keeping maximum length as 2 here, show button if more than 2 elements present
       */
      displayShowAllButton: function() {
        return this.isReadMore && this.data[this.column].length > 2;
      },

      urlTarget() {
        return (this.data.listElementObj.redirectUrl) ? '_blank' : '';
      },
    },

    methods: {
      /**
       * onReadMore click operation
       */
      readMore() {
        this.isReadMore = false;
        this.limit = this.data[this.column].length;
      },

      /**
       * onReadLess click operation
       */
      readLess() {
        this.isReadMore = true;
        this.limit = 2;
      },

      url(element) {
        return (this.data.listElementObj.redirectUrl) ? this.data.listElementObj.redirectUrl.replace(this.basePath(),'')  + element.id : '';
      }
    }
  }
</script>

<style scoped>
  .element-list-box {
    max-width: 300px;
    max-height: 100px;
    overflow: auto;
  }
</style>