<template>
	<div class="col-sm-12">
		<alert componentName="template-index"></alert>
		<div class="card card-light" v-if="!pageLoad">
			<div class="card-header">
				<h3 class="card-title">{{ trans('notifications-channels')}}</h3>
			</div>
			<!-- /.box-header -->
			<div class="card-body">
				<div class="row">
					<div class="col-md-2 col-sm-6" v-for="channel in channels">
						<div class="settingiconblue">
							<div class="settingdivblue">
								<router-link :to="'/notify/manage/channels/'+channel.channel+'/template-sets'+((plugin)?'?plugin='+plugin:'')"
								             v-tooltip="trans(channel.desc_lang_key)">
                                <span class="fa-stack fa-2x">
                                    <i :class="[channel.icon, 'fa-stack-1x']"></i>
                                </span>
								</router-link>
							</div>
							<div class="text-center text-sm fw_400">{{ trans(channel.channel) }}</div>
						</div>
					</div>
				</div>
				<!-- /.row -->
			</div>
			<!-- ./box-body -->
		</div>
		<div class="row" v-else>
			<custom-loader :duration="4000"></custom-loader>
		</div>
	</div>
</template>

<script>
import {errorHandler,successHandler} from "../../../../../../resources/assets/js/helpers/responseHandler";
import axios from 'axios'

export default {
	name : 'template-index',
	data () {
		return {
			channels : null,
			pageLoad : true,
			plugin   : null,
		}
	},
	beforeMount() {
		this.plugin = new URL(location.href).searchParams.get('plugin');
		this.getNotificationChannels();
	},

	methods : {
		getNotificationChannels() {
			axios.get('notify/api/notification-channels').then(res => {
				this.pageLoad = false;
				this.channels = res.data.data;
				successHandler(res,'template-index');

			}).catch(err => {
				this.pageLoad = false;
				errorHandler(err,'template-index');
			});
		}
	}
};
</script>
<style type="text/css" scoped>
.settingiconblue {
	padding-top: 0.5rem;
	padding-bottom: 0.5rem;
}

.settingdivblue {
	width: 80px;
	height: 80px;
	margin: 0 auto;
	text-align: center;
	border: 5px solid #C4D8E4;
	border-radius: 100%;
	padding-top: 5px;
}

.settingdivblue span { margin-top: 3px; }

.fw_400 { font-weight: 400; }
.settingiconblue p{
	text-align: center;
	font-size: 16px;
	word-wrap: break-word;
	font-variant: small-caps;
	font-weight: 500;
	line-height: 30px;
}
</style>