<template>

	<div class="health-monitor" :class="healthSectionClass">

		<div :class="[monitorClass, monitorClassCondition]" v-if="widgetOpen">

			<div class="health-header">

				<div class="health-option">

					<h5 id="health-head"><i class="fas fa-exclamation-triangle text-white" aria-hidden="true"> </i>&nbsp;{{trans('needing_attention')}}</h5>
				</div>
			</div>

			<div class="health-body card-danger-outline-left">

				<div v-for="item in alertList" class="card mb-2 red-body">

					<div class="card-body p-2">

						<h6><i class="fas fa-exclamation-triangle" aria-hidden="true"> </i>&nbsp;<b>{{ item.check }}</b></h6>

						<p v-html="item.value"></p>
					</div>
				</div>
			</div>

      <div class="health-footer card-footer card-danger-outline-left pt-1">

      </div>
		</div>

		<div v-if="!loading && alertList.length" class="monitor-tooltip">

			<a id="health-sidebar" :class="btnClass" @click="toggleHealthMonitor" >

				<i :class="iconClass"></i>

				<span class="badge text-bg-secondary alert-count">{{ alertList.length > 9 ? '9+' : alertList.length }}</span>
			</a>

			<div class="health-tooltip" v-if="!widgetOpen">

				<p class="health-tooltip-p">{{trans('health_monitor')}}</p>
			</div>
		</div>
	</div>
</template>

<script>

import axios from 'axios';
import {mapGetters} from "vuex";

export default {

	name : 'help-widget',

	props : {

		from : { type : String, default : '' },

    data : { type : [String, Object], default : '' || {} },
	},

	data() {

		return {

			monitorClass : 'monitor',

			btnClass : 'health-monitor-section',

			iconClass : 'prime fas fa-heartbeat',

			widgetOpen : false,

			alertList : [],

			loading : true,
		}
	},

	beforeMount() {

		this.getData();
	},

	methods :{

		toggleHealthMonitor() {

			this.widgetOpen = !this.widgetOpen;

			this.monitorClass = this.monitorClass == 'monitor' ? 'monitor is-visible' : 'monitor';

			this.btnClass = this.btnClass == 'health-monitor-section' ? 'health-monitor-section is-float is-visible' : 'health-monitor-section';

			this.iconClass = this.iconClass == 'prime fas fa-heartbeat' ? 'prime fas fa-times is-active is-visible' : 'prime fas fa-heartbeat';

		},

		getData() {

			axios.get('/health/system/alerts').then(res=>{

				this.alertList = res.data.data;

				this.loading=false;

			}).catch(err=>{

				this.loading=false;
			});
		},
	},

  computed: {

    // Maps the 'isSettingActive' getter from the Vuex store
    ...mapGetters(['isSettingActive']),

    // Checks if the 'isSettingActive' getter exists in the Vuex store
    hasIsSettingActiveGetter() {
      return this.$store.getters.hasOwnProperty('isSettingActive');
    },

    healthSectionClass() {
      return {
        'help-section-true': this.hasIsSettingActiveGetter && this.isSettingActive('conversation-widget'),
        'help-section-false': !( this.hasIsSettingActiveGetter && this.isSettingActive('conversation-widget'))
      };
    },

    monitorClassCondition() {
      return {
        'monitor-default': this.hasIsSettingActiveGetter && this.isSettingActive('conversation-widget'),
        'monitor-custom': !(this.hasIsSettingActiveGetter && this.isSettingActive('conversation-widget') )
      };
    }
  }
};
</script>


<style scoped>

#health-head{ position: relative;top: 17px;}

.health-monitor { right: 0px; position: fixed;margin: 1em; 	z-index: 9999;}

.help-section-true{
  bottom: 70px;
}

.help-section-false{
  bottom: 0;
}

.health-monitor-section {
	display: block;
	width: 56px;
	height: 56px;
	border-radius: 50%;
	text-align: center;
	color: #f0f0f0;
	margin: 25px auto 35px;
	box-shadow: 0 0 4px rgba(0, 0, 0, .14), 0 4px 8px rgba(0, 0, 0, .28);
	cursor: pointer;
	-webkit-transition: all .1s ease-out;
	transition: all .1s ease-out;
	position: relative;
	z-index: 998;
	overflow: hidden;
	background: red;
}

.health-monitor-section > i {
	font-size: 2em;
	line-height: 55px;
	-webkit-transition: all .2s ease-out;
	-webkit-transition: all .2s ease-in-out;
	transition: all .2s ease-in-out;
	color: white;
}

.monitor {
	position: fixed;
	right: 15px;
	width: 400px;
	font-size: 12px;
	line-height: 22px;
	font-weight: 500;
	-webkit-font-smoothing: antialiased;
	font-smoothing: antialiased;
	opacity: 0;
	box-shadow: 1px 1px 100px 2px rgba(0, 0, 0, 0.22);
	border-radius: 10px;
	-webkit-transition: all .2s ease-out;
	-webkit-transition: all .2s ease-in-out;
	transition: all .2s ease-in-out;
}

.monitor-default{
  bottom: 180px;
}

.monitor-custom{
  bottom: 110px;
}

.health-header {
	font-size: 13px;
	font-weight: 500;
	color: #f3f3f3;
	height: 80px;
	background: red;
	border-top-left-radius: 10px;
	border-top-right-radius: 10px;
	padding-top: 8px;
}

.monitor.is-visible {
	opacity: 1;
	-webkit-animation: zoomIn .2s cubic-bezier(.42, 0, .58, 1);
	animation: zoomIn .2s cubic-bezier(.42, 0, .58, 1);
}

.health-option {
	float: left;
	font-size: 15px;
	list-style: none;
	position: relative;
	height: 100%;
	width: 100%;
	text-align: center;
	letter-spacing: 0.5px;
	font-weight: 400
}

.health-body {
	background: #eedbe1;
	width: 100%;
	display: inline-block;
	min-height: 300px;
	max-height: 430px;
	overflow-y: auto;
  padding: 15px 15px 0 15px;
	margin-bottom: -7px;
}

.health-footer{
  background: #eedbe1;
  border-bottom-right-radius: 10px;
  border-bottom-left-radius: 10px;
}

/*Chatbox scrollbar*/

::-webkit-scrollbar {
	width: 6px;
}

::-webkit-scrollbar-track {
	border-radius: 0;
}

::-webkit-scrollbar-thumb {
	margin: 2px;
	border-radius: 10px;
	background: rgba(0, 0, 0, 0.2);
}
/*Element state*/

.is-active {
	-webkit-transform: rotate(180deg);
	transform: rotate(180deg);
	-webkit-transition: all 1s ease-in-out;
	transition: all 1s ease-in-out;
}

.is-float {
	box-shadow: 0 0 6px rgba(0, 0, 0, .16), 0 6px 12px rgba(0, 0, 0, .32);
}

/*Animation*/

@-webkit-keyframes zoomIn {
	0% {
		-webkit-transform: scale(0);
		transform: scale(0);
		opacity: 0.0;
	}
	100% {
		-webkit-transform: scale(1);
		transform: scale(1);
		opacity: 1;
	}
}

@keyframes zoomIn {
	0% {
		-webkit-transform: scale(0);
		transform: scale(0);
		opacity: 0.0;
	}
	100% {
		-webkit-transform: scale(1);
		transform: scale(1);
		opacity: 1;
	}
}

@-webkit-keyframes load {
	0% {
		-webkit-transform: scale(0);
		transform: scale(0);
		opacity: 0.0;
	}
	50% {
		-webkit-transform: scale(1.5);
		transform: scale(1.5);
		opacity: 1;
	}
	100% {
		-webkit-transform: scale(1);
		transform: scale(1);
		opacity: 0;
	}
}

@keyframes load {
	0% {
		-webkit-transform: scale(0);
		transform: scale(0);
		opacity: 0.0;
	}
	50% {
		-webkit-transform: scale(1.5);
		transform: scale(1.5);
		opacity: 1;
	}
	100% {
		-webkit-transform: scale(1);
		transform: scale(1);
		opacity: 0;
	}
}
/* SMARTPHONES PORTRAIT */

@media only screen and (min-width: 300px) {
	.monitor {
		width: 250px;
	}
}
/* SMARTPHONES LANDSCAPE */

@media only screen and (min-width: 480px) {
	.monitor {
		width: 300px;
	}
}
/* TABLETS PORTRAIT */

@media only screen and (min-width: 768px) {
	.monitor {
		width: 300px;
	}
}
/* TABLET LANDSCAPE / DESKTOP */

@media only screen and (min-width: 1024px) {
	.monitor {
		width: 400px;
	}
}

/*health-tooltip */
.monitor-tooltip {
	position: relative;
	border-radius: 9px;
	transition: all 0.3s ease-in-out;
	cursor: default;
}

.health-tooltip {
	visibility: hidden;
	z-index: 1;
	opacity: .40;
	padding: 5px 8px 0px 8px;
	background: red;
	color: white;
	position: absolute;
	top: -45%;
	left: unset;
	right: 1%;
	border-radius: 9px;
	transform: translateY(9px);
	transition: all 0.3s ease-in-out;
	box-shadow: 0 0 3px rgba(56, 54, 54, 0.86);
	white-space: pre;
}

.health-tooltip::after {
	content: " ";
	width: 0;
	height: 0;
	border-style: solid;
	border-width: 8px 0.5px 0px 16.5px;
	border-color: red transparent transparent transparent;
	position: absolute;
	left: 35%;
}
.monitor-tooltip:hover .health-tooltip{
	visibility: visible;
	transform: translateY(-10px);
	opacity: 1;
	transition: .3s linear;
	animation: odsoky 1s ease-in-out infinite  alternate;
}

.health-tooltip-p { margin-bottom: 5px !important; }

.red-body { background: #fdfdfe; }

.alert-count {
	position: fixed;
	right: 14px;
	border-radius: 50%;
	height: 20px;
	width: 20px;
	font-size: 12px;
}

.card-danger-outline-left { border-left: 3px solid #dc3545 !important; }

</style>