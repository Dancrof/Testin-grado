<template>
	
	<li>

		<span class="mailbox-attachment-icon has-img">

			<a :href="attachment.view_url" target="_blank">
				
				<img class="img"  :id="attachment.id" :src="attachment.thumbnail_url" alt="">
			</a>
		</span>

		<div class="mailbox-attachment-info">
			
			<a  class="mailbox-attachment-name" v-tooltip="attachment.name">

				{{subString(attachment.name)}}
			</a>

			<span class="mailbox-attachment-size"> {{attachment.size}}
				
				<a :href="attachment.download_url" target="_blank" class="btn btn-light btn-sm pull-right float-end btn_blue" :class="classname" v-tooltip="trans('download')">

					<i class="fa fa-download"></i>
				</a>
			</span>
		</div>
	</li>
</template>

<script>
	
	import { getSubStringValue } from '../../helpers/extraLogics'

	export default {

		name : 'ticket-attachment',

		description : 'Ticket Attachment Component',

		props : {

			attachment : { type : Object, default : ()=>{} },

			classname : { type : String, default : '' }
		},

		methods : {

			subString(value){
			
				return getSubStringValue(value,10)
			}
		}
	};
</script>

<style scoped>
	
	#img_at{
    	height: 120px !important;
    	padding-top: 25px;
    	padding-bottom: 25px;
	}

	.info_btn{ font-size: 15px !important; padding: 0 !important; margin: -3px !important; }

	.btn_blue{ color : #337ab7 !important;border: none !important; background: transparent; }

	.mailbox-attachments li{float:left;width:120px;border:1px solid #eee;margin-bottom:10px;margin-right:10px}

	.mailbox-attachment-name{font-weight:bold;color:#666}

	.mailbox-attachment-icon,.mailbox-attachment-info,.mailbox-attachment-size{display:block}

	.mailbox-attachment-info{padding:10px;background:#f4f4f4}

	.mailbox-attachment-size{color:#999;font-size:12px}

	.mailbox-attachment-icon{text-align:center;font-size:65px;color:#666;padding:20px 10px}


  .mailbox-attachment-icon.has-img {
    width: 120px;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
  }
  .mailbox-attachment-icon.has-img > img {
    max-width: 100%;
    max-height: 100%;
    object-fit: cover; /* Ensures the image covers the container proportionally */
  }
  .img{
    height: 80px!important;
    width: 80px!important;
  }
</style>