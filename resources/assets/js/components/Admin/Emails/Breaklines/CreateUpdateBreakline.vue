<template>

	<div class="col-sm-12">

		<div class="row" v-if="hasDataPopulated === false || loading === true">

			<custom-loader :duration="loadingSpeed"></custom-loader>

		</div>

		<alert></alert>

		<faveo-box :title="trans(title)">

			<div class="row" v-focus-first-input>

				<text-field :label="lang('breakline')" :value="breakline" type="text" name="breakline" :onChange="onChange" :placehold="lang('enter_a_value')"
					classname="col-sm-6" :required="true" :keyupListener="triggerEvent" :hint="trans('breakline_note')">

				</text-field>
      		</div>

			<div class="row">

        		<div class="form-group col-sm-2">

					<label for="is_active">{{lang('status')}}</label>

					<status-switch name="is_active" :value="is_active" :onChange="onChange" classnane="float-start"
								   :bold="true">

					</status-switch>
        		</div>
      		</div>

            <template #actions>

                <div class="card-footer">

                    <button type="button" v-on:click="onSubmit" :disabled="loading" class="btn btn-primary update-btn">

                        <span :class="iconClass"></span> &nbsp;{{ trans(btnName) }}

                    </button>
                </div>
            </template>
    	</faveo-box>
  	</div>
</template>

<script>

	import axios from "axios";

	import {errorHandler, successHandler} from "../../../../helpers/responseHandler";

	import { validateBreaklines } from "../../../../helpers/validator/breaklinesRules";

	import { getIdFromUrl } from "../../../../helpers/extraLogics";
    import TextField from "../../../MiniComponent/FormField/TextField.vue";
    import RadioButton from "../../../MiniComponent/FormField/RadioButton.vue";
    import Switch from "../../../MiniComponent/FormField/Switch.vue";
    import ToolTip from "../../../MiniComponent/ToolTip.vue";

	export default {

		name: "create-upate-breakline",

  		description: "breakline page",

		beforeMount() {

			this.setMode();

			this.getInitialValues();
		},

  		data: function () {

    		return {

				id: null,

				breakline: "",

				hasDataPopulated: false,

				loadingSpeed: 4000,

				loading: true,

				iconClass: "fas fa-save",

				expressionRadioOptions: [
					{ name: "Yes", value: "yes" },
					{ name: "No", value: "no" },
				],

				expression: "yes",

				is_active: null,

				title: "create_breakline",

				mode: "create",

				btnName: "save",
    		};
  		},

  		methods: {

			onChange(value, name) {

				this[name] = value;
			},

    		isValid() {

				const { errors, isValid } = validateBreaklines(this.$data);

				if (!isValid) {

					return false;
      			}

				return true;
    		},

    		onSubmit() {

				if (this.isValid()) {

					this.loadingSpeed = 8000;

					this.loading = true;

					let data = {};

					data['id'] = this.id;

					data["breakline"] = this.breakline;

					data["is_active"] = this.is_active ? 1 : 0;

					axios.post("/api/create-update-breakline", data).then((res) => {

						this.loading = false;

              			successHandler(res);

              			if(!this.id){

							setTimeout(() => {

								this.$router.push({ name : "Breaklines Index"});
							}, 3000);
              			}
					}).catch((err) => {

              			this.loading = false;

              			errorHandler(err);
          			});
      			}
    		},

			setMode() {

				const path = window.location.pathname;

				this.mode = path.indexOf("edit") >= 0 ? "edit" : "create";

			},

    		getInitialValues() {

				this.loading = true;

				if (this.mode === "edit") {

					this.iconClass = "fas fa-sync";

					this.btnName = "update";

					this.title = this.lang('edit_breakline');

					const path = window.location.pathname;

					const breaklineId = getIdFromUrl(path);

        			axios.get(`/api/edit-breakline/${breaklineId}`).then((res) => {

						this.updateStatesWithData(res.data.message);

						this.hasDataPopulated = true;

						this.loading = false;

					}).catch((err) => {

						this.loading = false;

						errorHandler(err);
					});
      			} else {

					this.hasDataPopulated = true;

					this.loading = false;
      			}
    		},

			updateStatesWithData(breaklineData) {

				const self = this;

				const stateData = this.$data;

				Object.keys(breaklineData).map((key) => {

					if (stateData.hasOwnProperty(key)) {

						self[key] = breaklineData[key];

					}
				});

				self["api_key"] = breaklineData["key"];
			},
        triggerEvent(event) {
          var key = event.which || event.keyCode;
          if (key === 13) { // 13 is enter
            this.onSubmit();
          }
        },
  		},

		components: {

			"text-field": TextField,

			"radio-button": RadioButton,

			"status-switch": Switch,

			"tool-tip": ToolTip,
		},
	};
</script>
