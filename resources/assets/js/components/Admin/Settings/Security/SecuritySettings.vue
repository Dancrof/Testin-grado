<template>

	<div class="col-sm-12">

		<alert componentName="security"></alert>

		<faveo-box :title="trans('security_settings')">

			<div class="row" v-if="!hasDataPopulated || loading">

				<reuse-loader :animation-duration="4000" :size="60"/>
			</div>

            <div class="row" v-if="hasDataPopulated" v-focus-first-input>

                <number-field :label="trans('max_attempt')" :value="backlist_threshold" name="backlist_threshold" classname="col-sm-6"
                    :onChange="onChange" placeholder="n" type="number" :keyupListener="triggerEvent" :required="true" :hint="trans('security_msg2')">

                </number-field>

                <number-field :label="trans('lockout_period')" :value="lockout_period" name="lockout_period" classname="col-sm-6"
                    :onChange="onChange" placeholder="n" :show-minutes="true" type="number" :keyupListener="triggerEvent" :required="true" :hint="trans('security_msg3')">

                </number-field>

            </div>

            <div class="row">

              <static-select :label="lang('pwd_reset_max_attempts')" :hint="lang('pwd_reset_max_attempts_tooltip')"
                             :elements="options" name="max_attempts" :value="max_attempts"
                             classname="col-md-6" :onChange="onChange" :required="true">
              </static-select>

              <number-field name="password_reset_attempts_awaiting_time" :value="password_reset_attempts_awaiting_time" :label="lang('password_reset_attempts_awaiting_time')" :onChange="onChange"
                            :hint="lang('password_reset_attempts_awaiting_time_tooltip')" :show-minutes="true" classname="col-md-6" :required="true"></number-field>

            </div>

            <div class="row">

              <number-field name="expiry_time" :value="expiry_time" :label="lang('password_reset_link_expiry_time')" :onChange="onChange"
                            :hint="lang('password_reset_link_expiry_time_tooltip')" :show-minutes="true" classname="col-md-6" :required="true"></number-field>

              <div class="col-sm-6">

                <label for="is_2fa_enforced">{{trans('enforce_2fa')}}</label>
                <tool-tip :message="trans('2fa_enforce_tip')" size="small"></tool-tip>
                <br>

                <status-switch name="is_2fa_enforced" :value="is_2fa_enforced" :onChange="onChange" classname="float-start"
                               :bold="true">

                </status-switch>
              </div>
            </div>

            <template #actions>

                <div class="card-footer" v-if="hasDataPopulated">

                    <button class="btn btn-primary" @click="onSubmit()">

                        <i class="fas fa-save"></i> {{trans('save')}}
                    </button>
                </div>
            </template>
		</faveo-box>

		<div class="row" v-if="pageLoad">

			<custom-loader :duration="4000"></custom-loader>
		</div>
	</div>
</template>

<script>

	import TextField from "../../../MiniComponent/FormField/TextField.vue";

	import NumberField from '../../../MiniComponent/FormField/NumberField.vue';

	import Switch from '../../..//MiniComponent/FormField/Switch.vue';

	import ToolTip from "../../..//MiniComponent/ToolTip.vue";

	import axios from 'axios';

    import { errorHandler, successHandler } from "../../../../helpers/responseHandler";

    import { securitySettingsValidation } from '../../../../helpers/validator/securitySettingRules.js';

  import StaticSelect from "../../../MiniComponent/FormField/StaticSelect.vue";

	export default {

		name : 'security-settings',

		data () {

			return {

				backlist_threshold : '',

				lockout_period : '',

				loading : false,

				hasDataPopulated : false,

				pageLoad : false,

				securityId : '',

				is_2fa_enforced : false,

        max_attempts : 3,

        expiry_time : '',

        password_reset_attempts_awaiting_time : 60,

        options : [
          { id : 1, name : 1 },
          { id : 2, name : 2 },
          { id : 3, name : 3 },
        ]
			}
		},

		beforeMount() {

			this.getInitialValues();
		},

		methods : {

			getInitialValues() {

				this.loading = true;

				axios.get('/api/security').then(res=>{

					this.backlist_threshold = res.data.data.backlist_threshold;

					this.lockout_period = res.data.data.lockout_period;

					this.is_2fa_enforced = res.data.data.is_2fa_enforced;

					this.securityId = res.data.data.id;

					this.loading = false;

					this.hasDataPopulated = true;

          this.max_attempts =  res.data.data.password_reset_max_attempts;

          this.expiry_time = res.data.data.password_reset_link_expiry;

          this.password_reset_attempts_awaiting_time = res.data.data.password_reset_attempts_awaiting_time;

				}).catch(err=>{

					this.loading = false;

					this.hasDataPopulated = true;
				})
			},

			isValid(){

				const { errors , isValid } = securitySettingsValidation(this.$data)

				return isValid
			},


			onChange(value, name) {
				this[name] = value;
			},

			onSubmit() {

				if (this.isValid()) {

					this.pageLoad = true;

					const data = {};

					data['backlist_threshold'] = this.backlist_threshold;

					data['lockout_period'] = this.lockout_period;

					data['is_2fa_enforced'] = this.is_2fa_enforced ? 1 : 0;

					data['password_reset_max_attempts'] = this.max_attempts;

					data['password_reset_link_expiry'] = this.expiry_time;

          data['password_reset_attempts_awaiting_time'] = this.password_reset_attempts_awaiting_time;

					data['_method'] = 'PATCH';

					axios.post('/api/security/'+this.securityId, data).then(res => {

						this.pageLoad = false;

						successHandler(res,'security');

						this.getInitialValues();

						setTimeout(()=>{

							window.emitter.emit('securitySettingsUpdated',this.is_2fa_enforced ? true : false);
						},1000);

					}).catch(err => {

						this.pageLoad = false;

						errorHandler(err,'security');
					});
				}
			},
      triggerEvent(event) {
        var key = event.which || event.keyCode;
        if (key === 13) { // 13 is enter
          this.onSubmit();
        }
      },
		},

		components : {
      'static-select' : StaticSelect,

			'text-field' : TextField,

			"number-field": NumberField,

			'status-switch': Switch,

			'tool-tip' : ToolTip
		}
	};
</script>
