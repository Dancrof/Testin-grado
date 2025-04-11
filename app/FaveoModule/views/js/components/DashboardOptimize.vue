<template>
	
	<div class="col-sm-12">

    <alert componentName="dashboard-optimize"></alert>

    <div class="row" v-if="updateModuleLoad">

      <custom-loader :duration="4000"></custom-loader>
    </div>

    <div v-if="moduleLoad" class="p-50">

      <reuse-loader :animation-duration="4000" color="#1d78ff" :size="60"/>
    </div>

    <template v-else>

      <template v-for="module in moduleData">

        <div class="card card-light">

          <div class="card-header">

            <h3 class="card-title mt-2">{{ trans('dashboard') }}</h3>

            <div class="card-tools switch-pos">

				<toggle v-model="module.admin_enable" class="toggle-switch" />

<!--              <status-switch-->
<!--                  :value="module.admin_enable"-->
<!--				  :onChange="onChange"-->
<!--               >-->
<!--              </status-switch>-->
            </div>
          </div>

          <div class="card-body">

            <div class="row">

              <div class="col-sm-12">

                <div class="alert alert-info">
                  {{ module.description }}
                </div>

                <div class="row p-2">

                  <div v-if="subModuleLoad" class="col-sm-12 p-50">

                    <loader :animation-duration="4000" color="#1d78ff" :size="60"/>
                  </div>

                  <template v-if="!subModuleLoad && !moduleLoad">

                    <table class="table table-striped border">

                      <thead>

                      <tr>

                        <th>{{trans('title')}}</th>

                        <th>{{trans('cache')}}</th>

                        <th>{{trans('action')}}</th>
                      </tr>
                      </thead>

                      <tbody>

                      <tr v-for="(sub,index) in subModuleData" :key="index" :class="!module.admin_enable ? 'row_disable' : ''">

                        <td>{{ trans(sub.label) }}</td>

                        <td>

                          <div class="input-group">

                            <input type="number" min="0" v-model="sub.cache" max="999" class="form-control cache-field"
                                   @input="onInput(sub)"
                                   @keypress="checkValue"
                                   @paste="onPaste"
                                   :disabled="!sub.display">

                              <div type="button" class="btn btn-light disabled cursor-default border">

                                {{trans('minutes')}}
                              </div>
                          </div>


                        </td>

                        <td>

							<toggle v-model="sub.display" class="toggle-switch" />

<!--                          <status-switch :onChange="onChange"-->
<!--                              :value="sub.display">-->
<!--                          </status-switch>-->
                        </td>
                      </tr>
                      </tbody>
                    </table>
                  </template>
                </div>
              </div>
            </div>
          </div>

          <div class="card-footer" v-if="!subModuleLoad && !moduleLoad">

            <button class="btn btn-primary float-end" @click="updateDashboard(module,subModuleData)">

              <i class="fas fa-sync-alt"></i>&nbsp;{{trans('update')}}
            </button>
          </div>
        </div>
      </template>
    </template>
	</div>
</template>

<script>

	import {mapGetters} from "vuex";

  import {errorHandler, successHandler} from "../../../../../resources/assets/js/helpers/responseHandler";
	import Switch from "../../../../../resources/assets/js/components/MiniComponent/FormField/Switch.vue";

  export default {
		
		name : 'dashboard-optimize',
		
		data () {
			
			return {
		
				moduleData : [],
				
				subModuleData : [],
				
				moduleLoad : false,

				subModuleLoad : false,

        updateModuleLoad : false
			}
		},
		
		beforeMount() {
			
			this.getModuleData();
		},

    computed :{

      ...mapGetters(['formattedTime'])
    },
		
		methods : {

			getModuleData() {
				
				this.moduleLoad = true;
				
				axios.get('/api/modules').then(res=>{

					this.moduleData = res.data.data.helpdesk;
					
					this.moduleLoad = false;
					
					this.getSubModulesData();

				}).catch(err=>{

					this.moduleLoad = false;
					
				});
			},
			
			getSubModulesData() {

				this.subModuleLoad = true;

				axios.get('/api/sub-module/1?panel=admin').then(res=>{

					this.subModuleData = res.data.message.map((sub) => ({
						...sub,
						display: sub.display ? sub.display : false,
						cache: sub.cache ? sub.cache : 0,
					}));

					this.subModuleLoad = false;

				}).catch(err=>{

					this.subModuleLoad = false;
				});
			},

			onInput(sub) {
				
				if (sub.cache.toString().length <= 3) {
					
					return true;
					
				} else {
					
					sub.cache = sub.cache.toString().substring(0, sub.cache.toString().length - 1);
				}
			},
			
			checkValue(evt) {
				
				evt = (evt) ? evt : window.event;
				
				let charCode = (evt.which) ? evt.which : evt.keyCode;
				
				if ((charCode > 31 && (charCode < 48 || charCode > 57))) {
				
					evt.preventDefault();;
				
				} else {
				
					return true;
				}
			},
			
			onPaste(evt) {
				
				evt = (evt) ? evt : window.event;
				
				evt.preventDefault();
			},
			
			onChange(value, name) {
			
				this[name] = value;
			},
			
			updateDashboard(module,sub_module) {

        this.updateModuleLoad = true;

        let data = {};

        data['module_id'] = module.id;

        data['panel'] = 'admin';

        data['is_enabled'] = module.admin_enable ? 1 : 0;

        data['sub_module'] = sub_module.map((obj) => ({
          id:obj.id,
          display: obj.display ? 1 : 0,
          cache: obj.display ? parseInt(obj.cache) : 0,
        }));

        axios.post('/update/sub-module',data).then(res=>{

          successHandler(res,'dashboard-optimize');

          this.updateModuleLoad = false;

          this.getModuleData();

        }).catch(err=>{

          errorHandler(err,'dashboard-optimize');

          this.updateModuleLoad = false;
        });
			}
		},
		
		components : {

			"status-switch": Switch
		}
	}
</script>

<style scoped>

	.p-50 {
		padding: 50px;
	}
	
	.border_opt { border-radius: 0.25rem !important; }
	
	.switch-pos{position: relative; top: 6px;}

  .row_disable {
    opacity: 0.5;
    pointer-events: none;
  }
</style>

<style src="@vueform/toggle/themes/default.css"></style>

<style>
.toggle-switch {
	--toggle-bg-on: #28a745;
	--toggle-border-on: #28a745;
	--toggle-bg-off: #d9534f;
	--toggle-border-off: #d9534f;
}
.toggle-off { opacity: 0.5; }
</style>