<template>

	<div class="col-sm-12">

		<div class="row" v-if="pageLoad">
		
			<custom-loader></custom-loader>
		</div>
		
		<alert componentName="article-version"/>

		<div class="row">

			<div :class="loading ? 'col-sm-12' : 'col-sm-8'">

				<div class="card card-light">
					
					<div class="card-header">
						
						<h3 class="card-title">{{trans('article')}}</h3>

						<div v-if="!loading && versionDetails.is_restore" class="card-tools">
							
							<button type="button" class="btn btn-primary btn-sm" @click="restoreVersion()">
								<i class="fas fa-reply"> </i> &nbsp;{{trans('restore')}}
							</button>
						</div>
					</div>	

					<div class="card-body scrollable-article">
						
						<dl v-if="loading" class="row">
							
							<reuse-loader :animation-duration="4000" :size="60"/>
						</dl>

						<dl class="row" v-if="!loading">
			                
			                <template v-if="versionDetails && versionDetails.mod_contents.name">

				                <dt class="col-sm-2">{{trans('name')}}</dt>
				                
				                <dd class="col-sm-10"><h5><span v-html="versionDetails.mod_contents.name"></span></h5></dd>
				            </template>

				            <template v-if="versionDetails && versionDetails.mod_contents.summary">
				            	
				            	<dt class="col-sm-2">{{trans('summary')}}</dt>
				                
				                <dd class="col-sm-10"><span v-html="versionDetails.mod_contents.summary"></span></dd>
				            </template>

				            <template v-if="versionDetails && versionDetails.mod_contents.description">
				            	
				            	<dt class="col-sm-2">{{trans('description')}}</dt>
				                
				                <dd class="col-sm-10"><span v-html="versionDetails.mod_contents.description"></span></dd>
				            </template>
			            </dl>
					</div>
				</div>
			</div>

			<div class="col-sm-4" v-if="!loading">
				
				<article-revisions :articleId="articleId" from="revision" :versionId="versionId"></article-revisions>
			</div>
		</div>
	</div>
</template>

<script>
	
	import { successHandler, errorHandler } from "../../../../../helpers/responseHandler";

	import axios from 'axios';
	import ArticleRevisions from "./ArticleRevisions.vue";

	export default {

		name : 'article-version-details',

		data () {

			return {

				articleId : '',

				versionId : '',

				loading : false,

				versionDetails : '',

				pageLoad : false,
			}
		},

		beforeMount () {

			const path = window.location.pathname;

			let urlArray = path.split("/");

			let idArray = urlArray.filter(function (item) {
				return (parseInt(item) == item);
			});

			this.articleId = idArray[0];

			this.versionId = idArray[1];

			this.getVersionDetails();
		},

		methods : {

			restoreVersion() {

				this.pageLoad = true;

				axios.get('/api/article/restore-version/'+this.articleId+'/'+this.versionId).then(res=>{

					successHandler(res,'article-version');

					this.pageLoad = false;

					setTimeout(()=>{

						this.$router.push({ path : '/article/'+this.articleId+'/edit' })

					},2000);

				}).catch(err=>{

					errorHandler(err,'article-version');

					this.pageLoad = false;
				})
			},

			getVersionDetails() {

				this.loading = true;

				axios.get('/api/article/version/'+this.articleId+'/'+this.versionId).then(res=>{

					this.versionDetails = res.data.message;

					this.loading = false;

				}).catch(err=>{

					this.loading = false;

					this.versionDetails = '';
				})
			},
		},

		components : {

			'article-revisions': ArticleRevisions
		}
	}
</script>

<style scoped>
	
	.scrollable-article {
    	height: 600px;
    	overflow-y: auto;
	}
</style>

<style>
	
	ins.diffmod,ins.diffins { color: green; }

	del.diffmod,del.diffdel { color: red; }

	del a,del { color: red; }

	ins a,ins { color: green; }

	ins img { border : 3px solid green !important; }

	.diffmod img { border : 3px solid green !important; }

</style>
