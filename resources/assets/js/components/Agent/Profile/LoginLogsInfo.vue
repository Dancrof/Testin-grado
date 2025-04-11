<template>

  <!-- Modal container -->
  <modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle">

    <!-- Title section of the modal -->
    <template #title>

      <h4 class="modal-title">{{trans('log_session_detail')}}</h4>
    </template>

    <template #fields>

      <section class="ps-3">

        <div class="row">

          <div class="col-sm-12">

            <div class="row pb-4">

              <div class="col-sm-8">

                <div class="row pt-2">

                  <div class="col-sm-2 pe-0">

                    <!-- Container for device icon -->
                    <div class="icon-container">
                      <i :class="[deviceIconClass, loginLogsInfo.device_family.includes('Device') || loginLogsInfo.device_family.includes('faveomobileapp') ? 'fa-3x' : 'device-session']" ></i>
                      <i v-if="loginLogsInfo.device_family !== 'Postman'" :class="[loginLogsInfo.device_family.includes('Device') || loginLogsInfo.device_family.includes('faveomobileapp') ? 'device-icons' : 'device-icon', platformIconClass]"></i>
                    </div>
                  </div>
                  <div v-if="loginLogsInfo.device_family" class="col-sm-9">

                    <!-- Device family information -->
                    <b class="mb-0 text-muted">{{deviceType(loginLogsInfo)}}</b>
                    <span v-if="loginLogsInfo.current_session" class="ps-1" > <i class="fas fa-circle-check indicator"></i></span>
                    <div v-if="loginLogsInfo.current_session" class="ps-1" >{{trans('active_session')}}</div>
                    <div v-else>{{timeDiffForPast(loginLogsInfo.login_at)}}</div>

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
            <!-- Login time information -->
            <h6 class="text-muted">{{lang('login_at')}}</h6> {{ loginLogsInfo.login_at ? formattedTime(loginLogsInfo.login_at): '---'}}
          </div>

          <!-- Operating system information -->
          <div v-if="loginLogsInfo.device_family !== 'Postman'" class="col-sm-6 pb-4">

            <h6 class="text-muted">{{lang('operating_system')}}</h6>
            <div >
              <i v-if="loginLogsInfo.platform" :class="platformIconClass"></i>&nbsp;
              {{loginLogsInfo.platform ? loginLogsInfo.platform: '---'}}
            </div>
          </div>

          <div v-if="loginLogsInfo.device_family !== 'Postman' && !loginLogsInfo.device_family.includes('faveomobileapp')" class="col-sm-6 pb-4">

            <!-- Browser information -->
            <h6 class="text-muted">{{lang('browser')}}</h6>
            <div>
              <i v-if="loginLogsInfo.browser" :class="browserIconClass"></i>&nbsp;
              {{ loginLogsInfo.browser ? loginLogsInfo.browser : '---'}}
            </div>
          </div>

          <div class="col-sm-6 pb-4">
            <!-- IP address information -->
            <h6 class="text-muted">{{lang('ip_address')}}</h6>
            {{loginLogsInfo.ip_address !== '::1' ? loginLogsInfo.ip_address: '---'}}
          </div>

          <div class="col-sm-6 pb-4">

            <h6 class="text-muted">{{lang('location')}}</h6>
            <!-- Location information -->
            <div v-if="location">
              {{location.city}}, {{location.state_name}}, {{location.country}}
            </div>
            <div v-else>{{ '---' }}</div>
          </div>
        </div>
      </section>
    </template>
  </modal>
</template>

<script setup>

import {computed, onMounted, ref} from 'vue';

import {useStore} from 'vuex';

import {lang} from '../../../helpers/extraLogics';

const props = defineProps({

  loginLogsInfo: {type: Object, default:()=> {}},

  showModal:{type:Boolean,default:false},

  onClose:{type: Function},
})

const store = useStore();
const deviceIconClass = ref('');
const browserIconClass = ref('');
const platformIconClass = ref('');
const location = ref({});


onMounted(()=>{
  deviceIcon(props.loginLogsInfo);
  browserIcon(props.loginLogsInfo);
  platformIcon(props.loginLogsInfo);

  let locationObj  = props.loginLogsInfo.location;
// Stringify the object back to JSON format without the backslashes
  location.value =  JSON.parse(locationObj);
})

// Computed property for formatted time
const formattedTime = computed(()=>store.getters.formattedTime);

// Computed property for time difference
const timeDiffForPast = computed(()=>store.getters.timeDiffForPast);

// determines device icon class
const deviceIcon = (data) => {
  // Function to determine the icon class based on the device family
  const check = data.device_family;
  let icon;
  if(check !== null){
    switch (true) {
      case check.includes('PC'):
        icon = 'fa-solid fa-desktop fa-4x text-muted';
        break;
      case check.includes('Device') || check.includes('faveomobileapp'):
        icon = 'fa-solid fa-mobile fa-4x text-muted';
        break;
      case check.includes('Postman'):
        icon = 'fa-solid fa-rocket fa-3x text-muted';
        break;
      default:
        icon = 'fa-question-circle-o fa-3x text-muted';
    }
  }else{
    icon = 'fa-regular fa-circle-question fa-3x';
  }

  // Set the icon class to deviceIconClass
  return deviceIconClass.value = icon;
}

// determines browser icon class
const browserIcon = (data) => {
  // Function to determine the icon class based on the browser
  const check = data.browser;
  let icon;
  switch (true) {
    case check.includes('Chrome'):
      icon = 'fa-brands fa-chrome fa-2x text-muted';
      break;
    case check.includes('Opera'):
      icon = 'fa-brands fa-opera fa-2x text-muted';
      break;
    case check.includes('Edge') || check.includes('Edge'):
      icon = 'fa-brands fa-edge fa-2x text-muted';
      break;
    case check.includes('Firefox'):
      icon = 'fa-brands fa-firefox text-muted';
      break;
    case check.includes('Mobile Safari'):
      icon = 'fa-brands fa-safari fa-2x text-muted';
      break;
    case check.includes('Postman'):
      icon = 'fa-solid fa-rocket fa-2x text-muted';
      break;
    default:
      icon = 'fa-brands fa-chrome fa-2x text-muted';
  }
  // Set the icon class to browserIconClass
  return browserIconClass.value = icon;
}

// determines platform icon class
const platformIcon = (data) => {

  // Function to determine the icon class based on the platform
  const check = data.platform;
  let icon;
  switch (true) {
    case check.includes('Linux') || check.includes('Ubuntu'):
      icon = 'fa-brands fa-ubuntu fa-2x text-muted';
      break;
    case check.includes('Android'):
      icon = 'fa-brands fa-android fa-2x text-muted';
      break;
    case check.includes('iOS') || check.includes('Mac'):
      icon = 'fa-brands fa-apple fa-2x text-muted';
      break;
    case check.includes('Window'):
      icon = 'fa-brands fa-windows fa-2x text-muted';
      break;
    case check.includes('Postman'):
      icon = 'fa-solid fa-rocket fa-2x text-muted';
      break;
    default:
      icon = 'fa-brands fa-windows fa-2x text-muted';
  }
  // Set the icon class to platformIconClass
  return platformIconClass.value = icon;
}

const deviceType = (data) => {
  // Function to determine the device type, considering 'Postman' as a separate type
  const check = data.device_family;
  let system;

  if(check === null){
    system = this.lang('unknown_device');
  }else if (check.includes('faveomobileapp')) {
    system = data.device.replace('-faveomobileapp', '');

  }else{
    system = data.device_family;
  }

  return system
}

// Container style object
const containerStyle = ref({ width:'800px' });

</script>


<style scoped>
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
  font-size: 20px;

}

.device-icon{
  padding-bottom: 16px;
}

.device-icons{
  color: #fff !important;
}

.indicator {
  color: #4CAF50 !important;
}
</style>