<template>
	
	<div class="card card-light" :class="{'note-card' : !replyZindex}">
		
		<div class="card-header">

			<h3 class="card-title">{{trans('add_note')}}</h3>

      <div class="card-tools">

        <button v-if="showCanned" class="btn btn-light btn-sm" @click="toggleCanned">

          <i class="fas fa-minus"></i> {{trans('hide_canned_response')}}
        </button>

        <button v-else class="btn btn-light btn-sm" @click="toggleCanned">

          <i class="glyphicon glyphicon-plus"></i> {{trans('add_canned_response')}}
        </button>
      </div>
		</div>

		<div class="card-body">

      <div class="row">

        <dynamic-select v-if="showCanned" :label="trans('response')" name="response" :value="response"
                        :onChange="onChange" :strlength="30"
                        :multiple="false" classname="col-sm-6" apiEndpoint="/api/dependency/canned-responses"
        >

        </dynamic-select>
      </div>

			<div  class="form-group">
							
				<div class="row me-3" :key="counter" v-focus-first-input>

					<time-field v-if="getTicketActions.show_thread_worktime && !fieldLoader" :label="trans('worktime')" :formStyle="formStyle"
						:value="worktime" type="number" name="worktime" :onChange="onChange" classname="col-sm-6"
						:required="getTicketActions.require_thread_worktime">

					</time-field>

					<dynamic-select v-if="getTicketActions.show_worktime_type && !fieldLoader && worktime" :label="trans('worktime_type')" name="worktime_type" :value="worktime_type"
									:onChange="onChange" :strlength="30" :multiple="false" classname="col-sm-6"
									apiEndpoint="api/worktime-type-list" :required="getTicketActions.require_worktime_type_field && worktime"></dynamic-select>
					<div v-if="getTicketActions.show_thread_worktime && fieldLoader" class="col-sm-6 load_margin">

						<reuse-loader :size="30" :duration="4000"></reuse-loader>
					</div>
				</div>

				<div class="row ps-2" :key="counter">

					<add-media :attachments="attachments" :inlineFile="inline" :description="internal_note" classname="col-sm-12" name="internal_note" :onAttach="setAttachments" :onInline="setInlineImages" :onInput="onChange" page_name="internal_note"
							   :id="getTicketActions.show_thread_worktime ? 'inbox_thread' : 'focus_editor'">
					</add-media>

					<div v-if="loading">

						<custom-loader :size="60" :duration="4000"></custom-loader>
					</div>
				</div>
			</div>
		</div>

		<div class="card-footer">

			<button type="button" class="btn btn-primary" @click="onSubmit" :disabled="!internal_note || loading">

				<i class="fas fa-sync-alt"> </i> {{trans('update')}}
			</button>
		</div>
	</div>
</template>

<script>
	
	import axios from 'axios'

	import {errorHandler} from "../../../../../../../helpers/responseHandler";

	import {useStore} from 'vuex';

    import { validateNoteSettings } from "../../../../../../../helpers/validator/noteRules";
	import {computed} from "vue";
	import TimeField from "../../../../../../MiniComponent/FormField/TimeField.vue";
	import AddMedia from "../../../../../../MiniComponent/FormField/AddMedia.vue";
	import DynamicSelect from "../../../../../../MiniComponent/FormField/DynamicSelect.vue";

	export default {

		name : 'inbox-notes',

		description : 'Inbox Internal Notes Component',

		setup() {

			const store = useStore();

			return {

				getTicketActions : computed(()=>store.getters.getTicketActions)
			}
		},

		props : {

			id : { type : [String, Number], default : '' },

			updateThreads : { type : Function }
		},

		data() {

			return {

				worktime:0,

                worktime_type: '',

				internal_note : '',

				loading : false,

				formStyle : { width:'40%' },

				fieldLoader : false,

				attachments : [],

				inline : [],

				counter : 0,

				replyZindex : false,

        notify_department : [],

        notify_agent : [],

        notify_team : [],

        showCanned : false,
			}
		},

		created () {

			window.emitter.on('fileModal',this.getModal)
		},

		methods : {

      toggleCanned() {

        this.showCanned = !this.showCanned;
      },

      getModal(value) {

				this.replyZindex = value;
			},

			setAttachments(files){
				this.attachments = files;
			},

			setInlineImages(files){
				this.inline = files;
			},

			onChange(value, name){
				this[name]= value;

        if(name == 'response') {

          if(value){

            axios.get('/get-canned-response-message/'+value.id + '/' +this.id).then(res=>{

              this.internal_note = res.data.data.message + this.internal_note.replace("<p id='extra_p'>&nbsp;</p>",'');

              this.attachments = res.data.data.attachments;

            }).catch(err=>{

              this.internal_note = '';

              this.attachments = [];
            })
          } else {

            this.internal_note = '';

            this.attachments = [];
          }
        }

      },
            isValid() {

                const { errors, isValid } = validateNoteSettings(this.$data);

                return isValid;
            },
			onSubmit() {
                this.worktime_type = this.worktime_type || '';
                if(this.isValid()) {

                    /** Perform sanity check for required fields */
                    if (!this.internal_note) {
                        return;
                    }

                    this.loading = true;

                    if (this.worktime != 0) {
                        this.saveTimeTrack();
                    }

                 this.getNotifyIds();

                    const params = {
                        content: this.internal_note,
                        ticket_id: this.id,
                        is_internal_note: true,
                        attachment: this.attachments,
                        notify_department : this.notify_department.length ? this.notify_department.toString() : '',
                        notify_team : this.notify_team.length ? this.notify_team.toString() : '',
                        notify_agent : this.notify_agent.length ? this.notify_agent.toString() : ''
                    }

                    axios.post('api/thread/reply/' + this.id, params).then(res => {
                        this.counter++;
                        this.loading = false;
                        this.internal_note = '';
                        this.notify_agent = [];
                        this.notify_team = [];
                        this.notify_department = [];
                        this.attachments = []
                        this.worktime = 0;
                        this.fieldLoader = true;
                        setTimeout(() => {
                            this.fieldLoader = false;
                        }, 1)

                      this.$store.dispatch('setAlert', { type: 'success', message: this.lang('internal_note') + ' ' + this.lang('added_successfully'), component_name: 'timeline' });

                        this.updateThreads('note');

						window.emitter.emit('closeNoteBox');

                    }).catch(err => {
                        this.loading = false;
                        errorHandler(err, 'timeline')
                    })
                }
			},

      getNotifyIds() {

        var parser = new DOMParser();

        var doc = parser.parseFromString(this.internal_note, 'text/html');

        const root = doc.getElementsByTagName('body')[0];

        const elements = root.querySelectorAll('[title="mention_link"]');

        elements.forEach(anchor => {

          let anchorArr = anchor.href.replace(this.basePath(),'').split('/');

          let modifiedArr = anchorArr.filter(item => item);

          if(modifiedArr[modifiedArr.length - 2] == 'user') {

            this.notify_agent.push(modifiedArr[modifiedArr.length - 1]);
          }

          if(modifiedArr[modifiedArr.length - 2] == 'department') {

            this.notify_department.push(modifiedArr[modifiedArr.length - 1]);
          }

          if(modifiedArr[modifiedArr.length - 2] == 'team') {

            this.notify_team.push(modifiedArr[modifiedArr.length - 1]);
          }
        })
      },

			saveTimeTrack() {
				
				const data = {};

				data['work_time'] = this.worktime;

				data['entrypoint'] = 'note';

                if(this.worktime_type) {
                    data['worktime_type'] = this.worktime_type.id;
                }
				
				axios.post('ticket/'+this.id+'/time-track',data).then(res=>{
					 
					 this.worktime = 0;
                     this.worktime_type = '';
					 window.emitter.emit('refreshTimeTrack')
					 
				}).catch(err=>{
                    this.worktime_type = '';
                    this.worktime = 0;
				})
			}
		},

		components : {
			
			'time-field': TimeField,

			"add-media": AddMedia,

            'dynamic-select': DynamicSelect,
		}
	};
</script>

<style scoped>
	
	.load_margin { margin-top: 50px; margin-bottom: 50px; }

	.note-card { z-index: 0; }
</style>