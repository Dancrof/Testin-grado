<template>
	
	<div class="inbox-pop">

		<a href="javascript:;" ref="right_click_menu"  v-on:contextmenu=" openContextMenu($event)" v-tooltip="details.title"
			:class="{'fw-400': details.isanswered}" @mousedown="scrollClick($event)">

      <span class="ticket-no" :data-pjax="details.id">[#{{details.ticket_number}}]&nbsp;{{ dirCode }}</span>

      {{ subString(details.title, 50) }}&nbsp;{{ dirCode }}({{ dirCode }}{{ details.thread_count }})
    </a>

		<popover click arrow placement="right">

			<a class="tic-pop me-1" href="javascript:;" @click="getPopData(details.id)" v-tooltip="trans('click_to_see_details')">

				<i class="fas fa-question-circle tic-pop-i">

				</i>
			</a>

			<template #content>

				<template v-if="!hasData">

					<div class="row" id="load_margin">

						<reuse-loader :animation-duration="4000" color="#1d78ff" :size="30"/>
					</div>
				</template>

				<template v-if="hasData">

					<div class="card card-light card-widget m_5">

					<div class="card-header pad-10">

						<div class="user-block">

						<faveo-image-element id="popover-img" :source-url="details.from.profile_pic" :classes="['img-circle']"/>

						<div>
						<span class="username text-capitalize mb-6"
							v-tooltip="popUpData.user_name ? popUpData.user_name : popUpData.email">

							<a href="javascript:;">
								{{popUpData.user_name ? subString(popUpData.user_name,30) : subString(popUpData.email,30) }}
							</a>
						</span>

						<span class="description fw-400">{{lang('created_at')}} :  {{formattedTime(popUpData.created_at)}}

						</span></div>
						</div>
					</div>

					<div class="card-body pb-0 pad-10">

						<p v-html="popUpData.body"></p>
					</div>
				</div>
				</template>
			</template>
		</popover>
		<span v-if="details.attachment_count !== 0" class="me-1"><i class="glyphicon glyphicon-paperclip cursor-pointer" v-tooltip="trans('attachment')"> </i></span>

		<span v-if="details.collaborator_count !== 0 && details.collaborator_count !== null" class="me-1"><i class="fas fa-users"></i></span>

		<template v-for="(label,index) in details.labels">

      <a v-if="label && label.value.includes('Elea Review')" href="javascript:;" v-tooltip="{content: renderDynamicTooltip(label.value), html: true}" class="badge me-1"
         :style="{'borderColor' : label.color, 'color': label.color, 'border': 'solid 1px'}"  :class="{'tags-padding': !label.value.includes('Elea Review')}">
        <span>
            <svg-icon-handler :hover-color="loadColor(label.value)" :color="loadColor(label.value)" height="15" width="15" icon-from="elea_c_icon"/>&nbsp;{{subString(removeTitle(label.value))}}
        </span>
      </a>

			<a v-else href="javascript:;" v-tooltip="{content: renderDynamicTooltip(label.value), html: true}" class="badge me-1"
         :style="{'backgroundColor' : label.color, 'color': '#FFF'}" :class="{'tags-padding': !label.value.includes('Elea Review')}">
        <span class="p-2" v-html="processLabel(label.value)"></span>
			</a>

		</template>
	</div>
</template>

<script>

import {getQueryParams, getSubStringValue, renderLabelWithEmoji} from "../../../../../../helpers/extraLogics";

	import {useStore} from 'vuex'

	import axios from 'axios'
	import {computed} from "vue";
import SvgIconHandler
  from "../../../../../../../../../app/Plugins/EleaAssistant/views/js/components/miniComponent/SvgIconHandler.vue";

	export default {

		name : 'ticket-popover',

    components: {

      'svg-icon-handler' : SvgIconHandler
    },

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime)
			}
		},

		props : {

			details : { type : Object, default : ()=> {} },

			tableHeader : { type : String, default : ''},

			onTicketClick : { type : Function }
		},

		data () {

			return {

				bgStyle : { background : this.tableHeader },

				hasData : false,

				popUpData : '',

				delay: 300,
				
				clicks: 0,
				
				timer: null
			}
		},

    methods : {

			subString(value,length = 10){

				return getSubStringValue(value,length)
			},

			getPopData(id) {

				this.hasData = false;
				
				axios.get('/ticket/tooltip?'+getQueryParams({ticketid : id})).then(res=>{

					this.hasData = true;

					this.popUpData = res.data;

				}).catch(err=>{

					this.hasData = false;
				})
			},

			onClick(id,e){

				if(!e.target.className.includes('tic-pop') && !e.target.className.includes('tic-pop-i')) {

					this.$store.dispatch('setTicketId', id);

					this.clicks++

					if(this.clicks === 1) {

						this.timer = setTimeout(()=> {

							this.clicks = 0

							this.onTicketClick(id)

						}, this.delay);
					} else{

						this.redirectMethod(id);
					}
				}
		  },

		  redirectMethod(id,tab) {

		  		this.clicks = 0;

				clearTimeout(this.timer);  

				if(tab == '_blank') {
					
					window.open(this.basePath()+'/panel/thread/' + id + '?' + getQueryParams(), "_blank");

				} else {

					this.$router.push({ path : '/thread/'+id, query : this.$route.query})
				}
		  },

			openContextMenu(e){
				
				let titleEl=this.$refs.right_click_menu;

                titleEl.href = this.basePath()+"/panel/thread/"+this.details.id;
			},
			
			scrollClick(e) {

				if (e.button === 1) {

					this.openContextMenu();
				}
			},

      loadLabel(label) {
        return renderLabelWithEmoji(label);
      },

      removeTitle(label) {

        return label.replace('Elea Review: ','');
      },
      loadColor(label) {
        const colorMap = {
          'Elea Review: Immediate Action Required': '#a70000',
          'Elea Review: Action Recommended': '#ff8c00',
          'Elea Review: Monitor': '#008000'
        };
        return colorMap[label] || null;
      },

      loadSVGIcon(label) {
        const iconMap = {
          'Elea Review: Immediate Action Required': 'elea_immediate_action',
          'Elea Review: Action Recommended': 'elea_action_recommended',
          'Elea Review: Monitor': 'elea_monitor'
        };
        return iconMap[label] || null;
      },

      renderDynamicTooltip(label){
        if(label.includes('Elea Review')){
          return this.removeTitle(label)
        }else{
          return this.loadLabel(label)
        }
      },

      processLabel(labelName) {
        // Extract emoji short codes and their positions
        let emojiMatches = [...labelName.matchAll(/:\w+:/g)];
        let textWithoutEmojis = labelName.replace(/:\w+:/g, '');

        // Get the substring of the text without emojis
        let subStringText = this.subString(textWithoutEmojis);

        // If subStringText is undefined or empty, return the original labelName with emojis
        if (!subStringText || !subStringText.trim()) {
          return this.loadLabel(labelName);
        }

        // Reinsert the emoji short codes at their original positions
        let finalText = subStringText;
        emojiMatches.forEach(match => {
          let position = match.index;
          if (position < subStringText.length) {
            finalText = finalText.slice(0, position) + match[0] + finalText.slice(position);
          } else {
            finalText += match[0];
          }
        });

        return this.loadLabel(finalText);
      }
		},

    computed: {
      // Returns '\u200F' (rlm;) if the appLanguage is 'ar',otherwise returns '\u200E' (lrm;).
      dirCode() {

        return this.appLanguage === 'ar' ? '\u200F' : '\u200E';
      }
    },
	};
</script>

<style scoped>
	
	.vue-popover{ width: 60% !important; top:auto !important; left:auto !important; }
	
	#load_margin { margin-top: 15px;margin-bottom: 15px; width: 300px; height: 50px; }

	.m_5 { margin : -5px; }

	.ticket_label{ font-size: 10px; }

	.mb-6 { margin-bottom: 6px; }

	.fw-400 { font-weight: 400; }

	.pad-10 { padding: 10px; }

  .tags-padding{
    padding-top: 4px;
    padding-bottom: 0.3rem
  }

  .card-widget{
    margin-bottom: 0 !important;
  }
</style>