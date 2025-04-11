<template>
	<div class="col-sm-12">
		<alert componentName="templates-list-index"></alert>
		<div class="card card-light" v-if="!pageLoadnig">
			<div class="card-header">
				<h3 class="card-title">{{ trans('templates')}}</h3>
			</div>
			<!-- /.box-header -->
			<div class="card-body"  v-if="list.length == 0">
				<center><p>{{ trans('no_data_found') }}</p></center>
			</div>
			<div class="card-body" v-else>
				<ul class="nav nav-tabs" id="custom-content-below-tab" role="tablist">
					<li v-for="(value, name, index) in list" :class="['nav-item']">
						<a :class="['nav-link', (index === 0) ? 'active':'']" :id="name+'-tab'" data-bs-toggle="pill" :href="'#'+name" role="tab" :aria-controls="name" aria-selected="true" v-tooltip="trans(name+'_desc_key')">{{trans(name+'_lang_key')}}</a>
					</li>
				</ul>
				<div class="tab-content" id="custom-content-below-tabContent">
					<div v-for="(values, name, index) in list" :class="['tab-pane', 'fade',  (index === 0) ? 'active show': '']" :id="name" role="tabpanel" :aria-labelledby="name">
						<table class="table table-bordered table-condensed">
							<thead>
							<tr>
								<th style="width: 20%">{{trans('name')}}</th>
								<th style="width: 70%">{{trans('description')}}</th>
								<th style="width: 10%">{{trans('actions')}}</th>
							</tr>
							</thead>
							<tbody>
							<tr v-for="value in values">
								<td style="width: 20%">{{trans(value.template)}}</td>
								<td style="width: 70%">{{trans(value.desc_lang_key)}}</td>
								<td style="width: 10%">
									<router-link class="btn btn-primary" :to="'/notify/manage/channels/'+channel+'/template-sets/'+id+'/templates/'+value.templates[0].id" v-tooltip="trans('edit')"><i class="fas fa-edit"></i></router-link>
								</td>
							</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- ./box-body -->
		</div>
		<div class="row" v-else>
			<custom-loader :duration="4000"></custom-loader>
		</div>
	</div>
</template>
<script>
import axios from 'axios';
import {getIdFromUrl} from "../../../../../../resources/assets/js/helpers/extraLogics";
import { successHandler, errorHandler } from '../../../../../../resources/assets/js/helpers/responseHandler'
import ToolTip from "../../../../../../resources/assets/js/components/MiniComponent/ToolTip.vue";

export default {
	name : 'templates-list-index',
	data() {
		return {
			plugin : null,
			id     : null,
			channel:'',
			pageLoadnig : true,
			list : [],
		}
	},

	beforeMount() {
		let locationURL = new URL(location.href);
		this.plugin = locationURL.searchParams.get('plugin');
		this.id = getIdFromUrl(window.location.pathname);
		this.channel = location.href.substring(location.href.indexOf('channels/')+9, location.href.indexOf('/template-sets'))
		this.getTemplatesList();
	},

	methods : {
		getTemplatesList() {
			let url = 'notify/api/templates?set_id='+this.id+((this.plugin)?'&plugin='+this.plugin:'');
			axios.get(url).then(res => {
				this.list = res.data.data;
				this.pageLoadnig = false;
				successHandler(res,'template-edit');

			}).catch(err => {
				this.pageLoadnig = false;
				errorHandler(err,'template-edit');
			});
		}
	},
	components : {

	    "tool-tip": ToolTip,

	}
}
</script>