<template>
<div class="col-sm-12">

  <alert componentName="file-system-settings" />

  <faveo-box :title="lang('settings_file_system_page_header')">

      <template #headerMenu>

          <div class="card-tools switch-pos">

              <div class="flex">

                  <label class="switch_mb">{{lang('s3_private_bucket')}}</label>

                  <status-switch slot="headerMenu" name="s3_status" :value="s3_status" :onChange="onChange"
                                 classname="btn-tool" :bold="true">
                  </status-switch>
              </div>
          </div>
      </template>

        <custom-loader v-if="isLoading"></custom-loader>

        <div class="row" v-focus-first-input>
          <text-field
              classname="col-sm-6" :onChange="onChange" rows="1"
              :label="lang('settings_file_system_allowed_files')"
              :value="allowedFiles" type="textarea" name="allowedFiles"
			  :keyupListener="triggerEvent"
              :hint="lang('settings_file_system_allowed_files_hint')"
              :placehold="lang('settings_file_system_allowed_files_placeholder')"
              :required="true"
          />

          <text-field v-if="is_installed"
              classname="col-sm-6" :onChange="onChange" rows="1"
              :label="lang('wkhtmltopdf_path')"
              :value="defaultPath" type="textarea" name="defaultPath"
              :keyupListener="triggerEvent"
              :hint="lang('settings_file_system_wkhtmltopdf_path')"
              :placehold="lang('enter_a_value')"
              :required="false"
          />
        </div> <!--row-->

        <div class="row">

          <div class="col-sm-6">

            <label class="label_align">
              <input class="checkbox_align" type="checkbox" name="showPublicDiskWithDefaultDisk" v-model="showPublicDiskWithDefaultDisk" :keyupListener="triggerEvent">&nbsp;{{lang('file-manager-show-public-folder')}}
            </label>

          </div>

        </div>

        <template #actions>
            <div class="card-footer">
                <button id="agent-submit" class="btn btn-primary" type="button" :disabled="isLoading" @click="onSubmit">
                    <span class="fas fa-save" id="submit-btn"></span>&nbsp; {{ lang('submit')}}
                </button>
            </div>
        </template>
  </faveo-box>
</div>
</template>

<script>

import axios from 'axios';
import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";
import {errorHandler,successHandler} from "../../../../helpers/responseHandler";
import TextField from "../../../MiniComponent/FormField/TextField.vue";
import StatusSwitch from "../../../MiniComponent/FormField/Switch.vue";

  export default {

    name: "FileSystemSettings",

    components: {
        'text-field': TextField,
        'static-select' : StaticSelect,
	    'status-switch' : StatusSwitch
    },

    props: {
      disks: {
        type: String,
        required: true,
      }
    },

    data() {
      return {
        isLoading: false,
        allowedFiles: null,
        showPublicDiskWithDefaultDisk: 0,
	      s3_status : 'status',
        defaultPath: '',
        is_installed: false
      }
    },

    computed: {
      selectOptions() {
        return JSON.parse(this.disks);
      }
    },

	  watch : {

		s3_status(newValue,oldValue) {

			if(oldValue != 'status') {

				  let endPoint = newValue ? '/enable-s3-private-bucket' : 'disable-s3-private-bucket';

				  this.updateBucket(endPoint);
				}
		}
	  },

    beforeMount() {

      this.getDefaultSettingsValues();

	    this.getS3Data();

      this.getWkhtmltopdfInstallation();

    },

    methods: {

	    getS3Data() {

		    this.isLoading = true;

		    axios.get('/check-private-bucket').then(res=>{

			    this.s3_status = res.data.data.isPrivateBucketEnabled ? true : false;

			    this.isLoading = false;

		    }).catch(err=>{

			    errorHandler(err, 'file-system-settings');

			    this.isLoading = false;
		    });
	    },

      onChange(value, name){

        this[name]= value;
      },

	    updateBucket(endPoint) {

		    this.isLoading = true;

			axios.post(endPoint).then(res=>{

				successHandler(res, 'file-system-settings');

				this.isLoading = false;

			}).catch(err=>{

				errorHandler(err, 'file-system-settings');

				this.isLoading = false;
			});
	    },

      async onSubmit() {
        this.isLoading = true

        try {
          let response = await axios.put('file-system-settings', {
            disk: this.disk,
            allowedFiles: this.allowedFiles,
            defaultPath: this.defaultPath,
            showPublicDiskWithDefaultDisk: this.showPublicDiskWithDefaultDisk ? 1 : 0,
          })
          successHandler(response, 'file-system-settings');
          this.$store.dispatch('unsetValidationError');
        } catch (e) {
          errorHandler(e, 'file-system-settings');
        } finally {
          this.isLoading = false
        }
      },

      async getDefaultSettingsValues() {

        try {
          let response = await axios.get('file-system-settings-values')

          let data = response.data.data;

          this.allowedFiles = data.allowed_files;

          this.defaultPath = data.defaultPath;

          this.showPublicDiskWithDefaultDisk = Boolean(data.show_public_folder_with_default_disk);

        } catch (e) {
          Object.assign(this.$data, this.$options.data.apply(this))
        }

      },
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },

      getWkhtmltopdfInstallation() {
        this.isLoading= true;

        axios.get('/wkhtmltopdf/installation').then(res=>{

          this.is_installed = res.data.data.is_installed ? true : false;

          this.isLoading = false;

        }).catch(err=>{

          errorHandler(err, 'file-system-settings');

          this.isLoading = false;
        });
      }
    }

}
</script>

<style scoped>
.checkbox_align {
  width: 13px; height: 13px; padding: 0; vertical-align: bottom; position: relative; top: -4px; overflow: hidden; cursor: pointer;
}

.label_align {
  display: block; padding-left: 15px; text-indent: -15px; font-weight: 500 !important; padding-top: 6px;
}

.switch_mb { margin-top: -7px; }
</style>

<style>
	.switch-pos{position: relative; top: 6px;}
</style>
