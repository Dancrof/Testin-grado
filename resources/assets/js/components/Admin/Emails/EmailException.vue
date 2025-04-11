<template>

	<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

		<template #title>

			<h4 class="modal-title">{{ trans('exception') }}</h4>
		</template>

		<template #fields>

			<div class="mod_width">
        <p v-if="exception.message">{{exception.message}}</p>
				<p v-if="content" v-html="content" class="trace"></p>
			</div>
		</template>
	</modal>
</template>

<script>
export default {

	name : 'email-exception-modal',

	props:{

		showModal:{type:Boolean,default:false},

		onClose:{type: Function},

		exception : { type : [String, Object], default: '' },
	},

	data:()=>({

		containerStyle:{ width:'950px' },

		content : '',

	}),

	beforeMount() {

		this.updateContent()
	},

	methods:{

		updateContent() {
			
			if(this.exception && this.exception.trace) {

				this.content = this.contentParser(this.exception.trace.replaceAll('<br />\r\n', ""));
			}
		},
		
		contentParser(value) {

			var parser = new DOMParser();

			var doc = parser.parseFromString(value, 'text/html');

			const root = doc.getElementsByTagName('body')[0];

			const anchors  = root.querySelectorAll('a');

			anchors.forEach(anchor => {

				let anchorArr = anchor.href.replace(this.basePath(),'').split('/');

				let modifiedArr = anchorArr.filter(item => item);

				if(modifiedArr[0] == 'change-approval' || (modifiedArr[0] == 'service-desk' && modifiedArr[1] == 'contract-approval')) {

					anchor = anchor;

				} else {

					const span = doc.createElement('a');

					if(!anchor.href.includes('/panel/') && !anchor.href.includes('/ticket-conversation/') && !anchor.href.includes('/agent/export/download/') && !anchor.href.includes('/check-ticket/')) {

						span.setAttribute('href',anchor.href.replace(this.basePath(),this.basePath()+'/panel'));

					} else {

						span.setAttribute('href',anchor.href);
					}

					span.innerText = anchor.innerText;

					anchor.parentNode.replaceChild(span, anchor);

				}
			});

			return root.innerHTML;
		}
	}
};
</script>

<style type="text/css">

.mod_width{
	max-height: 400px;
	overflow-x: hidden;
	overflow-y: auto;
}
.trace {
	background: black !important;
	color: aliceblue;
	padding: 10px;
	font-family: monospace;
	font-size: 13px;
	line-height: 1.5 !important;
}

p{
	word-break:break-word;
}
</style>
