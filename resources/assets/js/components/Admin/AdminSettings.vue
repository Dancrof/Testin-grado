<template>

	<div class="col-sm-12">

		<alert componentName="admin-settings"></alert>

		<template v-for="(navigationCategory, index) in navigationArray">

			<template v-if="navigationCategory.main_navigation && navigationCategory.name == trans('helpdesk')">

				<template v-for="(navigation, index) in navigationCategory.navigations">

					<div v-if="navigation.hasChildren" class="card card-light">

						<div class="card-header">

							<h3 class="card-title">{{navigation.name}}</h3>
						</div>

						<div class="card-body">

							<div class="row">

								<template v-for="(nav,index) in navigation.children">

									<div class="col-md-2 col-sm-6">

										<div class="settingiconblue">

											<div class="settingdivblue">


<!--                        <router-link v-if="nav.routeString == 'pulse'" :to="'/'+nav.routeString">

&lt;!&ndash;                          it was a custom SVG icon for the '/pulse' route for now it was commented only elea Ai PR was going to release will use this code
                          &lt;!&ndash; Renders a custom SVG icon for the '/pulse' route &ndash;&gt;
                          <svg-icon-handler hover-color="#3C8DBC" icon-from="laravel-pulse" color="#3C8DBC" height="65" width="50" />&ndash;&gt;
                        </router-link>-->

												<a v-if="nav.routeString == 'horizon'" :href="nav.redirectUrl">

													<span class="fa-stack fa-2x"> <i :class="nav.iconClass" class="fa-stack-1x"></i></span>
												</a>

                        <a v-else-if="nav.routeString == '__clockwork/app'" :href="nav.redirectUrl">

                          <span class="fa-stack fa-2x"> <i :class="nav.iconClass" class="fa-stack-1x"></i></span>
                        </a>

                        <a v-else-if="nav.routeString == 'pulse'" :href="nav.redirectUrl">

                          <span class="fa-stack fa-2x"> <i :class="nav.iconClass" class="fa-stack-1x"></i></span>
                        </a>

												<router-link v-else :to="'/'+nav.routeString">

													<span class="fa-stack fa-2x"> <i :class="nav.iconClass" class="fa-stack-1x"></i></span>
												</router-link>
											</div>

											<div class="text-center fs-7 fw_400">{{nav.name}}</div>
										</div>
									</div>
								</template>
							</div>
						</div>
					</div>
				</template>
			</template>

			<template v-else-if="navigationCategory.main_navigation && navigationCategory.name != 'Helpdesk'">

				<div class="card card-light">

					<div class="card-header">

						<h3 class="card-title">{{navigationCategory.name}}</h3>
					</div>

					<div class="card-body">

						<div class="row">

							<template v-for="(nav,index) in navigationCategory.navigations">

								<div class="col-md-2 col-sm-6">

									<div class="settingiconblue">

                      <!-- Otherwise, uses router-link to navigate to the specified routeString -->
										<div class="settingdivblue" :class="nav.routeString == 'elea/settings' ? 'pt-2' : ''">

                      <router-link v-if="nav.routeString == 'elea/settings'" :to="'/'+nav.routeString">
                        <!-- Renders a custom SVG icon for the 'elea/settings' route -->
                        <svg-icon-handler hover-color="#3C8DBC" icon-from="elea_icon" color="#3C8DBC" height="45" width="35" />
                      </router-link>

                      <!-- Check if the routeString is 'service-desk/agent-software/settings' and call isValidLicense method on click -->
                      <a v-else-if="nav.routeString === 'service-desk/agent-software/settings'" @click="isValidLicense" href="javascript:;">

                        <span class="fa-stack fa-2x"> <i :class="nav.iconClass" class="fa-stack-1x"></i></span>
                      </a>

											<router-link v-else :to="'/'+nav.routeString">
                        <!-- Renders a font-awesome icon for other routes -->
												<span class="fa-stack fa-2x"> <i :class="nav.iconClass" class="fa-stack-1x"></i></span>
											</router-link>
										</div>

										<div class="text-center text-sm fw_400">{{nav.name}}</div>
									</div>
								</div>
							</template>
						</div>
					</div>
				</div>
			</template>

			<template v-else>

				<div class="card card-light">

					<div class="card-header">

						<h3 class="card-title">{{navigationCategory.name}}</h3>
					</div>

					<div class="card-body">

						<div class="row">

							<template v-for="(navigation, index) in navigationCategory.navigations">



                                    <div class="col-md-2 col-sm-6">

                                        <div class="settingiconblue">

                                            <div class="settingdivblue">

                                                <popover hover arrow placement="right">

                                                    <a href="javascript:;">

                                                        <span class="fa-stack fa-2x">

                                                            <i :class="navigation.iconClass" class="fa-stack-1x"></i>
                                                        </span>
                                                    </a>

                                                    <template #content>

                                                        <template v-for="(nav,index) in navigation.navigations">

                                                            <div class="row">

                                                                <div class="col-sm-12 col-md-2">

                                                                    <div class="settingiconblue" v-tooltip="nav.name">

                                                                        <div class="settingdivblue_mini">

                                                                            <a :href="basePath()+'/admin/'+nav.routeString">

                                                                                <span class="fa-stack fa-1x"> <i :class="nav.iconClass" class="fa-stack-1x"></i></span>
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </template>
                                                    </template>
                                                </popover>
                                            </div>
                                            
                                            <div class="text-center text-sm fw_400">{{navigation.name}}</div>
                                        </div>
                                    </div>
							</template>
						</div>
					</div>
				</div>
			</template>
		</template>

    <transition name="modal">
      <!-- Agent License Modal component with showModal prop and onClose event -->
      <agent-license-modal :showModal="showLicenseModal" :onClose="()=>{this.showLicenseModal = false}"/>
    </transition>

		<div class="row" v-if="loading">

			<reuse-loader :animation-duration="4000" :size="60"/>
		</div>
	</div>
</template>

<script>

import axios from 'axios';

import { errorHandler } from "../../helpers/responseHandler";

import {lang} from '../../helpers/extraLogics';
import SvgIconHandler
  from "../../../../../app/Plugins/EleaAssistant/views/js/components/miniComponent/SvgIconHandler.vue";

import AgentLicenseModal
  from "../../../../../app/Plugins/ServiceDesk/views/js/components/Admin/AgentSoftware/AgentLicenseModal.vue";

export default  {

	name : 'admin-settings',

  components: {
    'agent-license-modal' : AgentLicenseModal,
    'svg-icon-handler' : SvgIconHandler
  },

	data () {

		return {

			loading : false,

			navigationArray : [],

      showLicenseModal: false
		}
	},

	beforeMount() {

		this.getNavigations();
	},

	methods : {

		getNavigations() {

			this.loading = true;

			axios.get('/api/admin/navigation?meta=true').then(res=>{

				this.loading = false;

				let mainNavs = res.data.data.filter(({ main_navigation }) => main_navigation);

				let otherNavs = {
					name : lang('additional_confiurations'),
					main_navigation : false,
					navigations : res.data.data.filter(({ main_navigation }) => !main_navigation)
				}

				if(otherNavs.navigations.length) {

					mainNavs.push(otherNavs);
				}

				this.navigationArray = mainNavs;

			}).catch(err=>{

				this.loading = false;

				errorHandler(err,'admin-settings');
			})
		},

    async isValidLicense() {

      try {
        // Make an API call to check the license status
        const response = await axios.get('service-desk/license-status');

        // If the response status is 200, navigate to the agent software page and hide the license modal
        if (response.status === 200) {
          this.$router.push('/service-desk/agent-software');
          this.showLicenseModal = false;
        }
      } catch (error) {
        // If there is an error in the API call, show the license modal
        this.showLicenseModal = true;
      }
    }
	}
};
</script>

<style>
	.popper .settingiconblue {

		padding: 10px;
	}
</style>
<style scoped>

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

.settingdivblue_mini {
	width: 50px;
	height: 50px;
	margin: 0 auto;
	text-align: center;
	border: 5px solid #C4D8E4;
	border-radius: 100%;
	padding-top: 5px;
}

.fs_13 { font-size: 12px !important; font-weight: 500;word-break: break-word; }

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
.nav_body { height: 160px;overflow-y: auto; }

.nav_body::-webkit-scrollbar-track
{
	background-color: #f1f1f1;
	border-radius:10px;
}

.nav_body::-webkit-scrollbar
{
	width: 6px;
	background-color: #f1f1f1;
}

.nav_body::-webkit-scrollbar-thumb
{
	background-color: #c1c1c1;
	border-radius: 10px;
}

.vue-popover{
	top:auto !important;
	left:75% !important;
	width: 63px !important;
	background: unset !important;
	padding: unset !important;
	bottom: 30% !important;
}

.nav_card {margin-bottom: 0px;margin-left: -5px;margin-right: -5px;margin-top: -5px;}
</style>