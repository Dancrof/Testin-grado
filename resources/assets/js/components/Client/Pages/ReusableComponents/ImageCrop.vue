<template>

	<div :class="classname">
		
		<input ref="fileInput" type="file" @change="onFileSelected"  multiple style="display:none">
		
		<div class="user-block">

      <div class="image-container" @click="$refs.fileInput.click()">

        <div class="row" v-if="loading">

          <custom-loader :duration="4000"></custom-loader>

        </div>

			  <faveo-image-element id="image" :classes="['img-circle']" :source-url="value" alternative-text="User Image"/>

        <div class="camera_logo text-center" :class="{translateCameraIcon: lang_locale !== 'ar'}">
          <i class="fas fa-camera text-lg text-white"></i>
        </div>

      </div>
					
		</div>

<!--		<button data-bs-toggle="modal" @click="$refs.fileInput.click()" class="btn-bs-file btn btn-sm btn-light"-->
<!--		 id="crop_change_img">-->
<!--			<i class="fas fa-edit"></i>&nbsp;{{ lang('change_image') }}-->
<!--		</button>-->

		<modal v-if="showModal" :showModal="showModal" :onClose="onClose" :containerStyle="containerStyle" 
		:language="language">

            <template #title>

                <div>

                    <h4>{{lang('profile_pic')}}</h4>
                </div>
            </template>

			<template #fields>
				<div class="">
                    <vue-cropper ref='cropper' :guides="true" :view-mode="2"
                        drag-mode="crop"
                        :auto-crop="true"
                        :auto-crop-area="0.5"
                        :min-container-width="570"
                        :min-container-height="300"
                        :background="true"
                        :rotatable="true"
                        :src="imageSrc"
                        :img-style="crop"
                        :crop="cropImage">
                    </vue-cropper>
                </div>

        <div class="rotate-button">
          <button v-if="imageSrc" @click="rotateImage" id="rotate" >
            <i class="fas fa-sync-alt"></i>&nbsp;{{trans('rotate')}}</button>
          <button v-if="imageSrc" @click="changeRatio(0)" id="ratio" :class="{ 'active': aspectRatio === 0 }" class="m-1">
            &nbsp;{{trans('no_ratio')}}</button>
          <button v-if="imageSrc" @click="changeRatio(1)" id="ratio" :class="{ 'active': aspectRatio === 1 }" class="m-1">
            &nbsp;{{'1:1 '+trans('ratio')}}</button>
          <button v-if="imageSrc" @click="changeRatio(2)" id="ratio" :class="{ 'active': aspectRatio === 2 }" class="m-1">
            &nbsp;{{'16:9 '+trans('ratio')}}</button>
        </div>

			</template>

            <template #controls>

                <button type="button" @click = "onSubmit" class="btn btn-custom float-end" :style="btnStyle" id="crop_action"
                        :class="{left : language === 'ar'}"><i class="fa fa-check"></i> {{lang('proceed')}}
                </button>
            </template>
		</modal>  
</div>
</template>

<script type="text/javascript">

// import VueCropper from 'vue-cropperjs';

import VueCropper from 'vue-cropperjs';
import 'cropperjs/dist/cropper.css';


import Modal from "../../../Common/Modal.vue";
import Loader from "../../ClientPanelLayoutComponents/ReusableComponents/Loader.vue";
import FaveoImageElement from "../../../Common/FaveoImageElement.vue";

export default {

	name: "image-crop",

	description: "Image cropper component",

	props: {

		name: { type: String, required: true },

		onChange: { type: Function, Required: true },

		value : { type: [Object,String] , default : '' },

		classname : { type: [String, Object] , default : '' },

		language : { type : String, default :''},

    btnStyle : { type : Object, default : ()=>{}},

	},

	data() {
		return {

			base:window.axios.defaults.baseURL,
			
			selectedFile:this.value,
			
			showModal : false,

			containerStyle:{ width:'800px' },

			crop: { width: '400px', height: '300px' },

			imageSrc:'', 

			cropImg: '', 

			resultImage : '',

      lang_locale: '',

      aspectRatio : 0,

      isValidImage : true,

      loading : false,
		};
	},

	mounted() {

		this.selectedFile = this.value;
	},

  created() {
    // getting locale from localStorage
    this.lang_locale = this.appLanguage;
  },

	/**A watcher metod has been added since at firt the changevalue is empty and fetch the data accordingly
	 * we need a watcher to update it with new value
	 * @type {String}
	 */
	watch: {
		value(newVal) {
			this.selectedFile = newVal;
		}
	},

	methods:{
		
		async onFileSelected(e) {

			const file = e.target.files[0];

			if (!file.type.includes('image/')) {

				alert('Please select an image file');
				
				return;
			}

      let formData = new FormData();

      formData.append('image', file);

      this.loading = true;

      try {
        await axios.post('scanner/scan/file', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        });

        this.loading = false;

      } catch (err) {

          this.loading = false;

        this.$store.dispatch('setAlert', {
          type: 'danger',
          message: this.lang('malicious_message'),
          component_name: 'layout'
        });

          this.isValidImage = false;

          return;
      }


      if (typeof FileReader === 'function') {
				
				this.showModal = true;

				window.emitter.emit("cropModalChanged","");

				var element=this.$refs.fileInput;

				this.selectedFile = file;

				const reader = new FileReader();

				reader.onload = (event) => {

					this.imageSrc = event.target.result;

					this.$refs.cropper.replace(event.target.result);
				};

				reader.readAsDataURL(file);

				element.value="";

			} else {
				
				alert('Sorry, FileReader API not supported');
			}
		},

		cropImage() {

			this.cropImg = this.$refs.cropper.getCroppedCanvas().toDataURL();
		},

		rotateImage() {
			
			this.$refs.cropper.rotate(90);
		},

		onClose(){

			this.showModal = false;

			window.emitter.emit("cropModalChanged",'form_border');

		},

		onSubmit(){

			var ImageURL = this.cropImg;
			
			// Split the base64 string in data and contentType
			var block = ImageURL.split(";");
			
			// Get the content type
			var contentType = block[0].split(":")[1];// In this case "image/gif"
			
			// get the real base64 content of the file
			var realData = block[1].split(",")[1];// In this case "iVBORw0KGg...."

			// Convert to blob
			this.resultImage = this.b64toBlob(realData,contentType);

			const data = {};

			data['name'] = this.selectedFile.name;

			data['image'] = this.cropImg;

			data['file'] = this.resultImage;

			this.onChange(data,this.name);

			this.onClose();
		},

		b64toBlob(b64Data, filename,contentType, sliceSize) {
			
			contentType = contentType || '';
			
			sliceSize = sliceSize || 512;
			
			var byteCharacters = atob(b64Data);
			
			var byteArrays = [];

			for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
				
				var slice = byteCharacters.slice(offset, offset + sliceSize);

				var byteNumbers = new Array(slice.length);

				for (var i = 0; i < slice.length; i++) {

					byteNumbers[i] = slice.charCodeAt(i);
				}

				var byteArray = new Uint8Array(byteNumbers);

				byteArrays.push(byteArray);
			}
			
			var blob = new Blob(byteArrays, {type: contentType});
			
			return blob;
		},

    changeRatio(value){

      this.$refs.cropper.setAspectRatio(value);
      this.aspectRatio = value
    }
	},

	components: {
		
		VueCropper,
		
		'modal': Modal,

		'loader':Loader,

		'faveo-image-element': FaveoImageElement
	}
};
</script>

<style scoped>
	.img-circle{
		border: 5px solid #ccccc8 !important;
		width: 130px !important;
		height: 130px !important;
		border-radius: 50% !important;
	}
	.user-block{
		position: relative;
		top: 20px;
		left: 37px;
	}
	#crop_change_img{
		margin-left: 36px !important;
		margin-top : 30px !important;
	}

  #rotate{
    margin-top: 4px;
    margin-bottom: 5px;
  }

  #rotate ,#ratio{
    border-radius: 5px;
  }

  .rotate-button {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .rotate-button button.active {
    background-color: #007bff; /* Change to your desired active background color */
    color: #fff; /* Change to your desired active text color */
  }
  .image-container{
    width: max-content;
    margin: auto;
    position: relative!important;
    overflow: hidden;
    border-radius: 50%;
  }
  .camera_logo{
    position: absolute;
    opacity: 0; /* Initially hide the camera icon element */
    padding: .2rem;
    left: 50%;
    bottom: 0;
    right: 0;
    width: 100%;
    background-color: rgba(0,0,0,0.32);
    transition: opacity .2s ease-in-out;
  }
  .image-container:hover .camera_logo {
    transition: all 0.3s ease-in-out;
    opacity: 1; /* Display the camera icon element when the trigger is hovered */
  }

  .translateCameraIcon {
    transform: translate(-50%);
  }
</style>
