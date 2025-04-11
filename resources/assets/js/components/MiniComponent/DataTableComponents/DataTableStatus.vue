<template>

  <div class="btn-group">

    <a v-if="data.hasOwnProperty('status')" id="status">

        <span title="Status"
              :class="{'btn btn-success btn-sm pointer_normal':data.status,'btn btn-danger btn-sm pointer_normal':!data.status}"
              id="edit_btn">{{ data.status ? lang('active') : lang('inactive') }}</span>
    </a>

    <a v-else id="status">
      <span title="Status"
            :class="{'btn btn-success btn-sm pointer_normal':data.response,'btn btn-danger btn-sm pointer_normal':!data.response}"
            id="edit_btn">{{ data.response ? lang('sent') : lang('failed') }}</span>
    </a>
  </div>

</template>

<script type="text/javascript">

export default {

    name: "data-table-status",

    description: "Contains active and inactive status",

    props: {

      /**
       * component will display buttons based on the indexes present in the `data` object
       * For eg : if you want this component to display delete button, `data` should have
       * an index `delete` which should be the API endpoint which can be used to delete
       * the data.
       * @type {Object}
       */
      data: {type: Object, required: true}

  },

};

</script>

<style type="text/css">

</style>