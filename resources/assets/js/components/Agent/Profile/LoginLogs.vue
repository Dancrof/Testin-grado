<template>
	
	<div id="login-logs">

    <!-- The logs switch component -->
		<logs-switch v-if="showBtn" :userId="userId" :btnStyle="btnStyle" :panel="panel" :alertName="alertName"></logs-switch> <br v-if="alertName != 'edit_agent_profile'">

    <!-- The alert component -->
		<alert componentName="dataTableModal" />

    <!-- The faveo box component -->
		<faveo-box :title="trans('login-logs')">

			<template #customActions>
				<div  class="card-tools">

					<button v-if="showBtn" class="btn btn-tool" @click="showModal = true" v-tooltip="lang('logout-from-all-devices')">

						<i class="fas fa-power-off"> </i>
					</button>
          <!-- The refresh button -->
					&nbsp;&nbsp;<span>
           <div class="btn btn-tool" :class="loading ? 'rotating': ''" data-card-widget="refresh" @click="refreshTable()" :disabled="loading || sessions.length === 0" v-tooltip="lang('refresh')">

            <i class="fas fa-sync-alt"></i>
          </div>
        </span>
				</div>
			</template>

      <!-- The sessions div -->

      <template v-if="sessions.length !== 0">
        <ul class="nav nav-tabs">

          <template v-for="(value, heading) in sessionsData">

            <li v-if="value.length > 0" class="nav-item cursor-pointer">

              <a id="sessions_tab" class="nav-link" v-tooltip="trans(SessionTooltip(heading))" :class="{ active: category === heading }" data-bs-toggle="pill"
                 @click="callSession(value, heading)">

                <b>{{trans(heading)}}</b>
              </a>
            </li>
          </template>

          <li class="nav-item ms-auto mt-04">
            <div v-if="!showDetails" @click="showAllSession()" class="float-start pt-2">

              <a href="javascript:;" class="float-end"><b>{{trans('view_all_sessions')}}</b></a>
            </div>
          </li>
        </ul>

        <div class="card-body ps-0 pe-0">
          <div v-if="showDetails" class="row">

            <template v-for="item in categoryData" :key="item">

              <div :class="panel === 'agent' && profilePage ? singleCard ? 'col-sm-12' : 'col-sm-6' :'col-lg-4 col-md-6 col-sm-12 mb-3'">

                <div class="card sessions-card">

                  <div class="card-body">

                    <div class="row">

                      <div class="col-12">

                        <div class="row">

                          <div class="col-3 pe-0">

                            <div class="icon-container">

                              <i :class="[iconProvider(item,'device'), item.device_family.includes('Device') ? 'fa-3x' : 'device-session']" ></i>

                              <i v-if="item.device_family !== 'Postman'" :class="[item.device_family.includes('Device') || item.device_family.includes('faveomobileapp') ? 'device-icons' : 'device-icon', iconProvider(item, 'platform')]"></i>
                            </div>
                          </div>
                          <div class="col-9 ps-0">

                            <a href="javascript:;" @click="showIndividualInfo(item)" class="text-muted device-style pe-1"><b>{{deviceType(item)}}</b></a>

                            <a href="javascript:;"  @click="showTablesInfo(deviceType(item,'table'))"><i class="fas fa-info-circle fa-1x text-muted"  v-tooltip="trans('login_device_info')"></i> </a>

                            <div class="login-info-text" v-if="item.current_session">{{trans('current_session')}}</div>

                            <div class="login-info-text" v-else v-tooltip="formattedTime(item.login_at)">{{trans('last_accessed_on')}}{{timeDiffForPast(item.login_at)}}</div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </template>
          </div>

          <div v-if="showIndividualDetails">

            <section class="ps-3">

              <div class="row">

                <div class="col-sm-12" :class="panel === 'agent' && !profilePage ? 'ps-0': ''">

                  <div class="row pb-4">

                    <div class="col-sm-8" :class="panel === 'agent' && !profilePage ? 'ps-0': ''">

                      <div class="row pt-2">

                        <div class="col-sm-2 pe-0">

                          <div class="icon-container pe-0">
                            <i :class="[iconProvider(individualInfo,'device'), 'fa-4x' ]" ></i>
                            <i v-if="individualInfo.device_family !== 'Postman' || individualInfo.platform"
                               :class="[individualInfo.device_family.includes('Device') || individualInfo.device_family.includes('faveomobileapp') ? 'pc-icons' : 'pc-icon', iconProvider(individualInfo, 'platform')]">

                            </i>
                          </div>

                        </div>
                        <div v-if="individualInfo.device_family" class="col-sm-9 "
                             :class="profilePage && panel !== 'client' && !individualInfo.device_family.includes('Device') ? 'ps-3' : 'ps-0'">

                          <b class="mb-0 text-muted">{{deviceType(individualInfo, 'info')}}</b>
                          <span class="ps-1" v-if="individualInfo.current_session">
                          <i class="fas fa-circle-check indicator"></i>
                        </span>
                          <span>
                          <a href="javascript:;" class="ps-1" @click="showTablesInfo(deviceType(individualInfo, 'table'))">
                            <i class="fas fa-info-circle fa-1x text-muted" v-tooltip="trans('login_device_info')"></i>
                          </a>
                        </span>


                          <div v-if="individualInfo.current_session">{{trans('active_session')}}</div>

                          <div v-else >{{timeDiffForPast(individualInfo.login_at)}}</div>

                        </div>
                        <div class="pt-4" v-else>

                          <h6>{{trans('unknown_device')}}</h6>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="row">

                <div class="col-sm-6 pb-4">

                  <h6 class="text-muted">{{lang('login_at')}}</h6> {{ individualInfo.login_at ? formattedTime(individualInfo.login_at): '---'}}
                </div>

                <div v-if="individualInfo.device_family !== 'Postman'" class="col-sm-6 pb-4">

                  <h6 class="text-muted">{{lang('operating_system')}}</h6>

                  <div>

                    <i v-if="individualInfo.platform" :class="iconProvider(individualInfo, 'platform')" class="fa-2x"></i>&nbsp;

                    {{individualInfo.platform ? individualInfo.platform: '---'}}
                  </div>
                </div>

                <div v-if="individualInfo.device_family !== 'Postman' && !individualInfo.device_family.includes('faveomobileapp')" class="col-sm-6 pb-4">

                  <h6 class="text-muted">{{lang('browser')}}</h6>

                  <div>

                    <i v-if="individualInfo.browser" class="fa-2x" :class="iconProvider(individualInfo, 'browser')"></i>&nbsp;

                    {{ individualInfo.browser ? individualInfo.browser : '---'}}
                  </div>
                </div>

                <div class="col-sm-6 pb-4">

                  <h6 class="text-muted">{{lang('ip_address')}}</h6>

                  {{individualInfo.ip_address !== '::1' ? individualInfo.ip_address: '---'}}
                </div>

                <div class="col-sm-6 pb-4">

                  <h6 class="text-muted">{{lang('location')}}</h6>

                  <div v-if="individualInfoLocation">

                    {{individualInfoLocation.city}}, {{individualInfoLocation.state_name}}, {{individualInfoLocation.country}}
                  </div>
                  <div v-else>

                    {{ '---' }}
                  </div>
                </div>
              </div>
            </section>
          </div>

          <!-- The div for showing the device list -->
          <div v-if="ShowDeviceList" id="login_logs_index">

            <data-table :url="tableUrl" :panel="panel" :dataColumns="columns" :btnStyle="btnStyle" :inputStyle="inputStyle" disableLoader="true" :show_pagination="show_pagination" @loaderState="handelLoader" :option="options" scroll_to ="login-logs" :componentTitle="componentTitle">

            </data-table>
          </div>
        </div>
      </template>
      <template v-if="sessions.length === 0 && !loading">
        <div class="no-data-section">{{trans('no_data_available')}}</div>
      </template>



		</faveo-box>

		<transition name="modal">
				
			<logout-modal v-if="showModal" :onClose="onClose" :inputStyle="inputStyle" :btnStyle="btnStyle" :showModal="showModal" :panel="panel" :userId="userId" :alertName="alertName">
				
			</logout-modal>
		</transition>

    <transition name="modal">

      <login-logs-info v-if="showInfoModal" :onClose="onInfoClose" :showModal="showInfoModal" :loginLogsInfo="infoData" ></login-logs-info>
		</transition>
	</div>
</template>

<script>

    import LogoutModal from "./LogoutModal.vue";

    import LogsSwitch from "./LogsSwitch.vue";

	import {useStore} from "vuex";

	import {computed} from "vue";

  import LoginLogsInfo from "./LoginLogsInfo.vue";
    import axios from "axios";
    import {errorHandler} from "../../../helpers/responseHandler";
    import ToolTip from "../../MiniComponent/ToolTip.vue";
	
	export default {

		name : 'login-logs',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

        timeDiffForPast : computed(()=>store.getters.timeDiffForPast)
			}
		},

		props : {

			userId : { type : [String, Number], default : '' },

			showBtn : { type : Boolean, default : false },

			alertName : { type : String, default : 'edit_agent_profile'},

			btnStyle : { type : Object, default : ()=>{} },

			inputStyle : { type : Object, default : ()=>{} },

			panel : { type : String, default : 'agent' }
		},

		data () {

			return {

				columns : ['device_family', 'platform', 'browser', 'location','login_at', 'info'],

				apiUrl : '/api/login/info/'+this.userId,

				options : {},

				showModal : false,

				showSwitch : false,

				componentTitle: 'loginLogs',

        loading: true,

        showInfoModal: false,

        infoData: {},

        show_pagination: true,

        sessions: [],

        singleCard: false,

        profilePage: false,

        sessionsData: {
          'web_session': [],
          'mobile_web_session': [],
          'mobile_app_session': [],
          'third_party_session': [],
        },

        showIndividualDetails: false,

        showDetails : true,

        individualInfo: [],

        tableUrl:{
          'web_session': '',
          'mobile_web_session': '',
          'mobile_app_session': '',
          'third_party_session': ''
        },

        ShowDeviceList: false,

        individualInfoLocation: {},

        category: 'web_session',

        categoryData: [],
			}
		},

		beforeMount () {

      const path = window.location.pathname;

      path.includes('profile') ? this.profilePage = true : this.profilePage = false;

			const self = this;

			this.options = {

        headings : {
          device_family : self.lang('device'),
          platform :self.lang('platform_OS') ,
          browser : self.lang('browser'),
          location : self.lang('location'),
          login_at : self.lang('login_at') ,
          info: self.lang('info') },

				texts: { filter: "", limit: "" },

				columnsClasses : {

          device_family: 'login-device',

					platform: 'login-plat',
					
					browser: 'login-browser',

					location: 'login-location',

					login_at: 'login-at',

          info: 'login-info'
					
				},

				templates: {

					login_at(h, row) {

						return self.formattedTime(row.login_at)
					},

          device_family(h, row) {

            const iconClass = self.iconProvider(row, 'device');

            const deviceName = self.deviceType(row, 'info');

            // Create the icon element
            const iconElement = self.h('i', { class: [iconClass, 'fa-2x'] });

            // Create a text node for the device name
            const nameElement = self.h('span',{ class: 'ms-2' }, deviceName);

            // Combine the icon and name elements
            return self.h('div', [iconElement, nameElement]);
          },

          platform(h,row){

            if(row.device_family === 'Postman') {

              return '--';
            }else{
              let icon = self.h('i', {
                'class': [self.iconProvider(row, 'platform'), 'fa-2x'],
              });

              let buttonProps = {
                'data-bs-toggle':'tooltip' ,
                'data-bs-placement':'top' ,
                'title': row.platform // Replace with your tooltip text
              };

              return self.h('div', buttonProps, [icon]);
            }
          },

          browser(h, row){

            if(row.device_family === 'Postman' ||  row.device_family.includes('faveomobileapp')) {
              return '--';
            }else{
              let icon = self.h('i', {
                'class': [self.iconProvider(row, 'browser'),'fa-2x'],
              });

              let buttonProps = {
                'data-bs-toggle':'tooltip' ,
                'data-bs-placement':'top' ,
                'title': row.browser // Replace with your tooltip text
              };

              return self.h('div', buttonProps, [icon]);
            }
          },

          location(h, row){

            let location, city, state, country;

            try {
              location = row.location ? JSON.parse(row.location) : null;
              city = location?.city;
              state = location?.state_name;
              country = location?.country;
            } catch(e) {
              return '--'; // Return '---' if row.location is not a valid JSON string
            }

            return location ? self.h('p', {}, `${city}, ${state}, ${country}`) : '--';
          },

          info(h, row) {

            let icon = self.h('i', {
              'class': 'fas fa-info-circle fa-1x text-muted'
            });

            let buttonProps = {
              class: 'btn btn-tool',
              'data-bs-toggle':'v-tooltip' ,
              'data-bs-placement':'top' ,
              'title':self.lang('info')
            };

            if (row.browser === null && row.device === null && row.device_family === null) {
              buttonProps.class += ' disabled';
            } else {
              buttonProps.onClick = () => {
                self.openInfo(row);
              };
            }
            return self.h('button', buttonProps, [icon]);
          }
				},
				
				sortable: ['login_at'],

				filterable: ['device_family', 'platform', 'browser', 'login_at'],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
			  	
			  		return {
				 		
				 		'sort-field': data.orderBy ? data.orderBy : "id",
				 		
				 		'sort-order': data.ascending ? "desc" : "asc",

            'search-query': data.query.trim(),
				 		
				 		limit: data.limit
			  		};
				},

				responseAdapter({ data }) {

			  		return {

				 		data: data.data.data,

				 		count: data.data.total
			  		};
				},

				orderBy: { column: 'id', ascending: true },
		 	};

      this.getInitialSessions()
		},

    mounted() {

      this.adjustCardSize();
      window.addEventListener('resize', this.adjustCardSize);
    },
    beforeDestroy() {
      window.removeEventListener('resize', this.adjustCardSize);
    },

		methods : {

      async getInitialSessions() {
      // fetch initial sessions data
        try {
          this.loading = true;
          const res = await axios.get(this.apiUrl + '?need_all=0');
          this.loading = false;
          this.sessions = res.data.data;
          this.sessionsData = {
            'web_session': [],
            'mobile_web_session': [],
            'mobile_app_session': [],
            'third_party_session': []
          };

          let sessionArray = Object.values(this.sessions)

          // Iterate over sessionArray
          sessionArray.forEach(item => {
            let category;

            if(item.device_family !== null && item.device_family !== undefined) {
              if (item.device_family.includes('PC')) {
                category = 'web_session';
              } else if (item.device_family.includes('Device')) {
                category = 'mobile_web_session';
              } else if(item.device_family.includes('faveomobileapp')) {
                category = 'mobile_app_session';
              }else{
                category = 'third_party_session';
              }
              // Push session data into respective category array
              this.sessionsData[category].push(item);
            }

            this.callSession( this.sessionsData['web_session'], 'web_session');
          });
        } catch (err) {
          this.loading = false;
          errorHandler(err);

        }
      },

      callSession(value, heading) {
        // Function to switch between session categories
        this.category = heading;
        this.categoryData = value;

        this.showDetails = true;
        this.showIndividualDetails = false;
        this.ShowDeviceList = false;
      },


			onClose(){
				
				this.showModal = false;
			},

			refreshTable() {
        // refresh session data table
        this.getInitialSessions();
				window.emitter.emit('loginLogsrefreshData');
			},

      handelLoader(loader){

        this.loading = loader;
      },

      openInfo(data){
        // open individual session info modal
        this.infoData = data;
        this.showInfoModal = true;
      },

      onInfoClose(){
        // close individual session info modal
        this.showInfoModal = false;
      },

      deviceType(data, from = ''){
        // Function to determine the device type, considering 'Postman' as a separate type
        const check = data.device_family;
        let system;

        if(check === null){
          system = this.lang('unknown_device');
        }else if (check.includes('faveomobileapp') && from !== 'table') {
          system =  from === 'info' ? data.device.replace('-faveomobileapp', '') : check.replace('-faveomobileapp', '');

        }else{
          system = data.device_family;
        }

         return system
      },

      iconProvider(data, type) {
        // Function to provide the appropriate icon class based on the type (device, browser, or platform)
        switch (type) {
          case 'device':
            return this.deviceIcon(data, type);
            break;
          case 'browser':
            return this.browserIcon(data);
            break;
          case 'platform':
            return this.platformIcon(data);
            break;
        }
      },

      deviceIcon(data) {
        // Function to determine the icon class based on the device type
        const check = data.device_family;
        let iconClass;

        if(check !== null){

          switch (true) {
            case check.includes('PC'):
              iconClass = 'fa-solid fa-desktop text-muted';
              break;
            case check.includes('Device') || check.includes('faveomobileapp'):
              iconClass = 'fa-solid fa-mobile text-muted';
              break;
            case check.includes('Postman'):
              iconClass = 'fa-solid fa-rocket text-muted';
              break;
            default:
              iconClass = 'fa-solid fa-desktop text-muted';
          }
        }else{

          iconClass = 'fa-regular fa-circle-question text-muted'
        }
        // Default icon class
        return iconClass
      },

      browserIcon(data){
        // Function to determine the icon class based on the browser
        const check = data.browser;
        let iconClass;
        if(check !== null ){
          switch (true) {
            case check.includes('Chrome'):
              iconClass = 'fa-brands fa-chrome text-muted';
              break;
            case check.includes('Opera'):
              iconClass = 'fa-brands fa-opera text-muted';
              break;
            case check.includes('Edge') || check.includes('Edge'):
              iconClass = 'fa-brands fa-edge text-muted';
              break;
            case check.includes('Firefox'):
              iconClass = 'fa-brands fa-firefox text-muted';
              break;
            case check.includes('Mobile Safari'):
              iconClass = 'fa-brands fa-safari text-muted';
              break;
            case check.includes('Postman'):
              iconClass = 'fa-solid fa-rocket text-muted';
              break;
            default:
              iconClass = 'fa-brands fa-chrome text-muted';
          }
          // Default icon class
          return iconClass;
        }
      },

      platformIcon(data){
      // Function to determine the icon class based on the platform
        const check = data.platform;
        let iconClass;
        if(check!==null){
          switch (true) {
            case check.includes('Linux') || check.includes('Ubuntu'):
              iconClass = 'fa-brands fa-ubuntu text-muted';
              break;
            case check.includes('Android'):
              iconClass = 'fa-brands fa-android text-muted';
              break;
            case check.includes('iOS') || check.includes('Mac'):
              iconClass = 'fa-brands fa-apple text-muted';
              break;
            case check.includes('Window'):
              iconClass = 'fa-brands fa-windows text-muted';
              break;
            case check.includes('Postman'):
              iconClass = 'fa-solid fa-rocket text-muted';
              break;
            default:
              iconClass = 'fa-brands fa-windows text-muted';
          }
          // Default icon class
          return iconClass;
        }
      },

      showIndividualInfo(data){
        // show's individual session info
        this.showDetails = false;
        this.showIndividualDetails = true;
        this.individualInfo = data;
        if (data.location !== undefined) {
          this.individualInfoLocation = JSON.parse(data.location);
        } else {
          this.individualInfoLocation = {};
        }
      },

      showAllSession(){

        // show's all sessions for a specific category
        this.showDetails = true;
        this.showIndividualDetails = false;
        this.ShowDeviceList = false;
      },

      showTablesInfo(data){

        // show's sessions for a specific device type
        this.tableUrl =  this.apiUrl+'?deviceFilter='+ data.trim();
        this.showDetails = false;
        this.showIndividualDetails = false;
        this.loading = true;
        this.ShowDeviceList = true;
      },

      SessionTooltip(title) {

        // provide's tooltip text based on session category
        if (title === 'web_session') {
          return 'web_session_tooltip';
        } else if (title === 'mobile_web_session') {
          return 'mobile_web_session_tooltip';
        } else if (title === 'mobile_app_session') {
          return 'mobile_app_session_tooltip';
        } else if (title === 'third_party_session') {
          return 'third_party_session_tooltip';
        }
      },

      adjustCardSize() {

        // adjust card size based on screen width
        const sessions = document.querySelector('#login-logs');

        if (sessions) {
          sessions.offsetWidth > 400 ? this.singleCard = false : this.singleCard = true;
        }
      },
		},

		components : {

			'logout-modal' : LogoutModal,

			'logs-switch' : LogsSwitch,

      'login-logs-info' : LoginLogsInfo,

      'tool-tip' : ToolTip,
		}
	};
</script>

<style scoped>
	.login-device,.login-at,.login-out,.login-plat, .login-browser { min-width: 150px !important; max-width: 300px; word-break: break-all;}

	#login_logs_index .VueTables .table-responsive {
		overflow-x: auto;
	}

	#login_logs_index .VueTables .table-responsive > table{
		width : max-content;
		min-width : 200px !important;
		max-width : max-content;
		overflow: auto !important;
	}

  @keyframes rotate {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  /* Apply the rotation animation when the button has a class of "rotating" */
  .btn-tool.rotating i {
    animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
  }

  .pointer-cursor {

    cursor: pointer !important;
  }

  span .device-name{

    font-weight: bold;
  }

  .login-plat, .login-browser{
    font-size: 1.4rem;
    padding-top: 5px;
  }

  .icon-container {
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    width: 100%;
    height: 100%;
    padding-right: 10px;
  }

  .device-icon, .device-icons {
    position: absolute;
    font-size: 14px;

  }

  .device-icon{
    padding-bottom: 12px;
  }

  .device-icons{
    color: #fff !important;
  }

  .pc-icons, .pc-icon{
    position: absolute;
    font-size: 20px;
  }

  .pc-icons{
    color: #fff !important;
  }

  .pc-icon{
    padding-bottom: 15px;
  }

  .device-session{
    font-size: 2.6em;
  }

  .login-plat .table-icons{
    font-size: 1.5em !important;
  }

  .login-plat{
    font-size: 1.5em !important;
  }

  .login-info-text{
    font-size: 12px !important;
    cursor: default;
  }

  .sessions-card {
    min-width: 255px !important;
  }

  .login-device .icon-container {
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    width: 100%;
    height: 100%;
    padding-right: 10px;
  }

  .indicator {
    color: #4CAF50 !important;
  }

  .cursor-pointer{
    cursor: pointer;
  }

</style>