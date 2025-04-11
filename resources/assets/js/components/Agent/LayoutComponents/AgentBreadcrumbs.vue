<template>
	
	<div class="app-content-header">
				
		<div class="container-fluid">
			
			<div class="row mb-2">
				
				<div class="col-sm-6 d-flex">
					
					<h3 class="m-0">{{trans(getTitle())}}</h3>
          
          <div v-if="showEditBtn && inDashboard" id="editPage-btn" class="ms-2" :class="isRtl ? 'dropstart' : ''">

            <button type="button" class="btn btn-sm border" data-bs-toggle="dropdown" aria-expanded="false">

              <i class="fas fa-ellipsis-v"></i>
            </button>

            <div class="dropdown-menu" role="menu">
              <a type="button" class="dropdown-item" @click="redirectToEditPage" :disabled="isAdminEnabled" v-tooltip="trans('dashboard_edit')">

                <i class="fas fa-edit"></i> &nbsp; {{trans('edit')}}
              </a>
            </div>
          </div>

				</div>
				
				<div v-if="$route.meta.crumb" class="col-sm-6">
					
					<ol class="breadcrumb float-sm-end">
						
						<li><i class="fas fa-home text-muted"></i>&nbsp;&nbsp;</li>

						<li v-if="$route.meta.crumb.link" class="breadcrumb-item">

							<router-link :to="$route.meta.crumb.link.to">{{trans($route.meta.crumb.link.name)}}</router-link>
						</li>
						
						<li v-if="$route.meta.crumb.root_link" class="breadcrumb-item">

							<router-link :to="$route.meta.crumb.root_link.to">{{trans($route.meta.crumb.root_link.name)}}</router-link>
						</li>

						<li v-if="$route.meta.crumb.parent_link" class="breadcrumb-item">

							<router-link :to="$route.meta.crumb.parent_link.to">{{trans($route.meta.crumb.parent_link.name)}}</router-link>
						</li>

						<li v-if="$route.meta.crumb.root" class="breadcrumb-item active" aria-current="page">{{trans($route.meta.crumb.root)}}</li>

						<li v-if="$route.meta.crumb.active" class="breadcrumb-item active" aria-current="page">{{trans(getActive($route.meta.crumb.active))}}</li>
					</ol>
				</div>
			</div>
		</div>
	</div>
</template>

<script>

  import {boolean} from '../../../helpers/extraLogics';
	
	export default {

		name : 'bread-crumbs',

    data(){

      return{
        showEditBtn: false,

        inDashboard: true,

        isAdminEnabled: false,

        isRtl: false
      }
    },

    beforeMount() {

      this.isRtl = boolean(sessionStorage.getItem('is_rtl'));
    },

    created() {

      window.emitter.on('edit-dashboard', (value) => {

        this.inDashboard = value;
      });

      window.emitter.on('isAdminEnabled', (value) => {

        this.isAdminEnabled = value;
      });
    },

		methods : {

			getTitle() {

				return !this.$route.meta.title ? this.$route.query['show[]'] : this.$route.meta.title == 'from_report' ? this.$route.params.type : this.$route.meta.title;
			},

			getActive(value) {

				return value == 'from_report' ? this.$route.params.type : value
		
			},

      redirectToEditPage() {

        this.inDashboard = false;

        window.emitter.emit('editDash', true);
      }
		},

    watch: {
      '$route.href': {
        immediate: true,
        handler(newPath, oldPath) {
          if(newPath.includes('/panel/dashboard')){
            this.showEditBtn = true;
          }else{
            this.showEditBtn = false;
          }
        }
      }
    },
	};
</script>