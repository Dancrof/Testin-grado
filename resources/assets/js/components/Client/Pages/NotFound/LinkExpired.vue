<template>

  <div class="mt-5">

    <meta-component :dynamic_title="lang('oops_link_expired')" :layout="layout"></meta-component>

    <div id="content" class="site-content">

      <article class="hentry error404 text-center">

        <h1 class="error-title">4<i class="far fa-frown text-danger" :style="linkStyle"></i><span class="visible-print text-danger"></span>4</h1>

        <h2 class="entry-title text-muted mt-4"> {{lang('page_expired')}}</h2>

        <div class="entry-content clearfix mt-5">

          <p><router-link to="/" replace class="btn btn-custom" :style="btnStyle" id="go_to_home">{{ lang('go_to_home') }}</router-link></p>

        </div>
      </article>
    </div>
  </div>
</template>
<script>
export default {

  name : 'link-expired-component',

  description : 'Link Expired Component',

  props : {

    layout : { type : Object, default : ()=>{}},
  },

  data () {

    return {

      linkStyle : { color : this.layout.portal.client_header_color + ' !important'},

      btnStyle : {

        borderColor : this.layout.portal.client_button_border_color,
	      color : this.layout.portal.client_button_font_color + ' !important',
        backgroundColor : this.layout.portal.client_button_color,
      },
    }
  }
};
</script>
<style scoped>

.error-title{
  margin-bottom: 0px !important
}
</style>