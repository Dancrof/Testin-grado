<template>

  <div class="simple-pagination pt-2">

    <button class="btn" :class="[panel === 'client' ? 'btn-custom' : 'btn-primary']" @click="onPagination('previous')"
            :style="btnStyle" :disabled="!prev_page">

      <i class="fas fa-arrow-left"></i> &nbsp; {{ trans('previous') }}
    </button>

    <button class="btn" :class="[panel === 'client' ? 'btn-custom' : 'btn-primary']" @click="onPagination('next')"
            :style="btnStyle" :disabled="!next_page">

      {{ trans('next') }} &nbsp;<i class="fas fa-arrow-right"></i>
    </button>
  </div>
</template>

<script>
export default {
  name : 'simple-pagination',
  props : {
    prev_page : { type : [String,null], default : '' },
    next_page : { type : [String,null], default : '' },
    onPagination : { type : Function, default : ()=>{} },
    btnStyle : {type : Boolean, default : ()=>{}},
    panel : { type : String, default : 'agent' }
  }
}
</script>