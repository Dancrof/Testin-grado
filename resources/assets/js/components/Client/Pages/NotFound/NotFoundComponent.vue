<template>
	
	<div class="row">

		<meta-component :dynamic_title="lang('oops_page_not_found')" :layout="layout"></meta-component>

		<div id="content" class="site-content col-md-8 offset-md-2">

			<article class="hentry error404 text-center">

        <h1 v-if="statusText" class="error-title"><i class="far fa-frown text-danger" :style="linkStyle"></i><span class="visible-print text-danger"></span></h1>

        <h1 v-else class="error-title">4<i class="far fa-frown text-danger" :style="linkStyle"></i><span class="visible-print text-danger"></span>4</h1>

				<h2 v-if="statusText" class="entry-title text-muted" v-html="newStatus"></h2>

				<h2 v-else class="entry-title text-muted">{{lang('page_could_not_be_found')}}</h2>

				<div class="entry-content clearfix">

					<p><router-link to="/" replace :style="linkStyle" id="not_found_to_home">{{ lang('go_to_home') }}</router-link></p>

				</div>
			</article>
		</div>
	</div>
</template>

<script>

export default {

	name : 'bad-request-component',

	description : '404 Error Component',

	props:{

		layout : { type : Object, default : ()=>{}},

		statusText:{type:String},
	},

	data () {

		return {

			linkStyle : { color : this.layout.portal.client_header_color + ' !important'},
      newStatus:''
		}
	},
  created() {
    this.newStatus = this.$store.getters.getStatusText
  },
  computed: {
    statusText() {
      return this.$store.getters.getStatusText;
    }
  },

};
</script>
<style scoped>
	.margin{
		margin-left: -30px !important
	}	
	.error-title{
		margin-bottom: 0px !important
	}
</style>