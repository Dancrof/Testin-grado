<style scoped>
@import 'css/rtl.css';

.option-select:hover{
  background-color: #fff0ad !important;
  cursor: pointer !important;
  color: #856404 !important;
}
.option-select{
  padding: 0 2px 0 12px !important;
  font-size: 14px !important;
}

.select-button{
  border-color: #b0b085e6 !important;
  font-size: 14px !important;
  line-height: 21px !important;
}

.select-button:hover{
  color: #856404 !important;
}

.dropdown-item.alertDay {
  background-color: #fff0ad !important;
  color: #856404 !important;
}

.select-button .btn:focus {
  box-shadow: none;
  background-color: transparent;
}

.option-container{
  width: 100% !important;
  max-width: 100% !important;
  min-width: 0 !important;
  padding: 0 !important;
  border-color: #b0b085e6 !important;
}

.alert-wrapper{
  z-index: 9999;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  font-size:14px !important;
  line-height: 21px !important;
}

.remind-option{
  font-weight: 500 !important;
  font-size: 11px !important;
  line-height: 21px !important;
}

.alert-description {
  display: flex;
  justify-content: right;
  align-items: center;
  height: 100%;
  text-align: center;
}

.alert-message{
  font-size: 14px !important;
  line-height: 21px !important;
}

.color-shift-progress-bar {
  width: 100%;
  height: 5px;
  background: linear-gradient(90deg, transparent 0, #00e1ff 200px, transparent 0);
  background-size: 200% 10px;
  animation: color-move-animation 2s linear infinite;
}

@keyframes color-move-animation {
  0% {
    background-position: 100% 0;
  }
  100% {
    background-position: -100% 0;
  }
}

#alert_close{
  margin-bottom: 5px !important;
}
</style>

<template>

  <div v-for="(item, index) in alertContent" :key="index">

    <div ref="alertWrapperElements" v-if="item.use === 1" class="alert-warning alert-wrapper mb-0 pt-2 ps-3 pe-2 pb-1"
         :style="{ top: item.topPosition + 'px',backgroundColor: getAlertBackgroundColor(index),
       zIndex: index === alertContent.length - 1 ? 9999 : 99999999 }">

      <div class="row">

        <div class="col-sm-12 alert-description">

          <div class="col-sm-10">

              <span style="vertical-align: top;"> <i class="fas fa-warning"></i></span>
              <span class="alert-message" v-html="item.description"></span>
          </div>

          <div class="remind-select float-end pe-4">

            <label class="remind-option pe-2">{{'Remind me after : '}}</label>
            <div class="btn-group select-button">

              <button type="button" class="dropdown-toggle select-button alert-warning btn btn-outline"
                      :style="{backgroundColor: getAlertBackgroundColor(index)}" style="margin-right: 0px !important;"
                      data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">

                {{item.selectedOption }}
                <i class="fa fa-angle-down"></i>
              </button>

              <div class="dropdown-menu option-container">

                <div
                    class="dropdown-item option-select"
                    @click="updateSelectedOption(item,'1 Day')"
                    :class="{ alertDay: item.selectedOption === '1 Day' }"
                >1 Day</div>

                <div
                    class="dropdown-item option-select"
                    @click="updateSelectedOption(item,'3 Days')"
                    :class="{ alertDay: item.selectedOption === '3 Days' }"
                >3 Days</div>

                <div
                    class="dropdown-item option-select"
                    @click="updateSelectedOption(item,'7 Days')"
                    :class="{ alertDay: item.selectedOption === '7 Days' }"
                >7 Days</div>
              </div>
            </div>
          </div>
          <button type="button" @click="onCloseAlert(item)" class="btn-close p-2" id="alert_close"></button>
        </div>
      </div>
    </div>
  </div>
<div class="content-container" v-bind:style="{ marginTop: alertContent ? this.alertWrapper +'px !important' : '' }">
	<div v-if="getUserLoadStatus" id="page" class="hfeed site text-small">

		<header id="masthead" class="site-header" role="banner">

			<div class="container">

				<client-panel-navigation :layout="layout" :auth="auth"></client-panel-navigation>

				<div id="header-search" class="site-search clearfix">

					<client-panel-header-search v-if="layout.kb_settings.status" :layout="layout"></client-panel-header-search>
				</div>
			</div>
		</header>

		<div class="site-hero clearfix" :style="{'background-color' : layout.portal.client_header_color}">

			<div class="container">

				<client-panel-breadcrumbs :layout="layout"></client-panel-breadcrumbs>
			</div>
		</div>

		<div id="main" class="site-main clearfix">
			<div class="container">

				<div class="content-area">

					<alert componentName="layout"></alert>


					<router-view :key="$route.fullPath" :auth="auth" :layout="layout"></router-view>

					<vue-progress-bar class="color-shift-progress-bar"></vue-progress-bar>
				</div>
			</div>
		</div>

		<footer id="colophon" class="site-footer" role="contentinfo" :class="{footer_align : layout.language === 'ar'}">

			<div class="container">

				<client-panel-footer :layout="layout"></client-panel-footer>

				<div class="row">

					<div class="site-info col-md-6" :class="{'float1 align1' : layout.language === 'ar'}">

						<client-panel-copyright :layout="layout" :white-label="whiteLabel"></client-panel-copyright>
					</div>

					<div class="site-social text-end col-md-6" :class="{'left rem' : layout.language === 'ar'}">

						<client-panel-social-widgets :layout="layout"></client-panel-social-widgets>
					</div>
				</div>
			</div>
		</footer>
	</div>

	<div v-else class="row">
    <client-panel-loader :size="100" :color="layout.portal.client_header_color"></client-panel-loader>
  </div>

</div>
</template>

<script>

	import { mapGetters } from 'vuex';
    import Header from "./ClientPanelLayoutComponents/Header.vue";
    import Search from "./ClientPanelLayoutComponents/Search.vue";
    import Breadcrumbs from "./ClientPanelLayoutComponents/Breadcrumbs.vue";
    import Footer from "./ClientPanelLayoutComponents/Footer.vue";
    import CopyRight from "./ClientPanelLayoutComponents/CopyRight.vue";
    import SocialWidgets from "./ClientPanelLayoutComponents/SocialWidgets.vue";
    import Loader from "./ClientPanelLayoutComponents/ReusableComponents/Loader.vue";

	export default {

		name:'client-panel-layout',

		description:'Client panel Layout Component',

		props : {

			layout : { type : Object, default : ()=> {}},

			auth : { type : [Object, Array], default : ()=> []},

      isUpdatedVersion : { type : [Boolean,Number], default : false },

      whiteLabel : { type : Boolean , default : false},
		},

    data: {
      selectedOption: "1 Day",

      alertWrapper: 0,

      alertData: '',

      alertContent:'',

      screenSize:''
    },

		computed:{

			...mapGetters(['getUserLoadStatus']),
		},

    beforeMount() {

      if(this.auth.user_data.id && this.auth.user_data.role !== 'user'){
        this.checkForUpdate();
      }
    },

    updated() {
      // This hook is called whenever the component's DOM is updated.
      // We can access the updated element and log its height.
      this.logAlertWrapperHeight();
    },
    mounted() {
      // This hook is called when the component is mounted in the DOM.
      // We can log the initial height here if needed.
      this.logAlertWrapperHeight();

      var screenWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;

      this.screenSize =  screenWidth/4;

      // Add the resize event listener
      window.addEventListener('resize', this.onWindowResize);
    },
    beforeDestroy() {
      // Remove the resize event listener when the component is destroyed
      window.removeEventListener('resize', this.onWindowResize);
    },

    methods: {

      getAlertBackgroundColor(index) {
        const baseColor = "#fff3cd"; // Initial color
        const step = 5; // Color step (adjust to your preference)

        // Calculate the new color based on the index
        const r = parseInt(baseColor.slice(1, 3), 16) + index * step;
        const g = parseInt(baseColor.slice(3, 5), 16) + index * step;
        const b = parseInt(baseColor.slice(5, 7), 16) + index * step;

        // Ensure that RGB values stay within the valid range (0-255)
        const clamp = (value) => Math.min(255, Math.max(0, value));

        return `rgb(${clamp(r)}, ${clamp(g)}, ${clamp(b)})`;
      },

      updateSelectedOption(item, option) {
        item.selectedOption = option;
      },

      async checkForUpdate() {
        try {
          // Fetch alert data
          const alertResponse = await axios.post('/display-pop-ups');
          this.alertData = alertResponse.data.map(item => ({
            ...item,
            selectedOption: "1 Day",
            topPosition: 0
          }));

          // Fetch and update descriptions
          const decryptedDescriptions = [];
          for (const item of this.alertData) {
            try {
              const data = { value: item.description };
              const res = await axios.post('/give-me-read', data);
              decryptedDescriptions.push(res.data);
            } catch (error) {
              console.log(error);
              decryptedDescriptions.push('');
            }
          }

          // Update the description field with the decrypted values
          this.alertData.forEach((item, index) => {
            item.description = decryptedDescriptions[index].replace('18px' , '14px');
          });

          // Fetch days data
          const daysResponse = await axios.get('/get-days');
          const responseData = daysResponse.data.data;
          for (const item of this.alertData) {
            const itemId = item.id.toString();
            if (responseData.hasOwnProperty(itemId)) {
              const days = responseData[itemId];
              item.selectedOption = days === 1 ? "1 Day" : `${days} Days`;
            }
          }

          this.alertContent = this.alertData;

          // Log the alert wrapper height
          await this.logAlertWrapperHeight();

        } catch (error) {
          console.log(error);
        }
      },

      onCloseAlert(item){

        if (!Array.isArray(this.alertContent)) {
          this.alertContent = [];
        }

        const currentIndex = this.alertContent.findIndex(alert => alert.id === item.id);

        if (currentIndex > -1) {

          this.alertContent.splice(currentIndex, 1); // Remove the closed alert
        }

        const data = {};

        data['pop_id'] = item.id;

        let days = parseInt(item.selectedOption.match(/\d+/)[0], 10);

        data['days'] = days = '' ? 1: days;

        data['user_id'] = this.auth.user_data.id;

        axios.post('/post-days',data).then(res=>{

          this.checkForUpdate();

        }).catch(error=>{
          console.log(error)
        })
      },

      logAlertWrapperHeight() {

        this.$nextTick(() => {
          // Get an array of elements with the ref 'alertWrapper'
          const alertWrapperContainers = this.$refs.alertWrapperElements;

          if (alertWrapperContainers) {
            // Initialize a variable to store the total height
            let totalHeight = 0;

            // Iterate through each element and calculate the client height
            alertWrapperContainers.forEach((element, index) => {
              if (element) {
                const clientHeight = element.clientHeight;

                totalHeight += clientHeight;

                // Calculate the top position for the current alert
                const topPosition = totalHeight - clientHeight;
                this.alertContent[index].topPosition = topPosition;
              }
            });

            // Assign the total height to the alertWrapper
            this.alertWrapper = totalHeight;
          }
        });
      },

      onWindowResize() {
        // Handle the resize event here
        // You can log the updated height again or perform any other actions
        this.logAlertWrapperHeight();
      },

    },

		components:{
			
			'client-panel-navigation' : Header,
			
			'client-panel-header-search' : Search,
			
			'client-panel-breadcrumbs' : Breadcrumbs,
			
			'client-panel-footer' : Footer,
			
			'client-panel-copyright' : CopyRight,
			
			'client-panel-social-widgets' : SocialWidgets,

			'client-panel-loader' : Loader
		},
	};
</script>