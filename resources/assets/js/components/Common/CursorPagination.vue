<template>

  <div v-if="prev_page_url || next_page_url" class="simple-pagination">

    <button class="btn btn-primary" @click="onPagination('previous')" :disabled="!prev_page_url">

      <i class="fas fa-arrow-left"></i> &nbsp; {{ trans('previous') }}
    </button>

    <button class="btn btn-primary" @click="onPagination('next')" :disabled="!next_page_url">

      {{ trans('next') }} &nbsp;<i class="fas fa-arrow-right"></i>
    </button>
  </div>
</template>

<script>
export default {
  name : 'cursor-pagination',
  props : {
    prev_page_url : { type : [String,null], default : '' },
    next_page_url : { type : [String,null], default : '' },
    onPagination : { type : Function, default : ()=>{} }
  },
}
</script>