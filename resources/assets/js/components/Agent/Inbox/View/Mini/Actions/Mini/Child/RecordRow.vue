<template>

	<tbody v-if="track">

		<tr  style="background:none !important" id="row" @mouseenter="showButton(track.id)" 
			@mouseleave="hideButton(track.id)">
			
			<td class="mailbox-name" style="border-bottom: 1px solid #f4f4f4;border-top:none !important">
			
				<div for="Time and amount details">
			
					<label class="row-label">
						<span v-if="track.user">
							<router-link :to="'/agent/'+track.user.id" target="_blank">{{track.user.full_name}}</router-link>
							<span style="color:#bab8b8;font-size: 12px;font-weight: normal;"> logged&nbsp;</span>
						</span>
						<a href="javascript:;" @click="editTimeTrack(track)">{{lang('worktime')}}
			
							<span style="color:#bab8b8;font-size: 12px;font-weight: normal;"> (hr:min) : &nbsp;
							</span>
						</a>
					</label>
					
					<span style="font-weight:bold">  {{(Math.floor(track.work_time/60) < 10 ) ? ("0"+Math.floor(track.work_time/60)):Math.floor(track.work_time/60)}}:{{(track.work_time%60 < 10) ? ("0" + track.work_time%60): track.work_time%60}}</span> &nbsp;
					
					<div v-if="show === track.id" class="float-end">
						
						<button id="btn" class="btn btn-primary btn-sm" @click="editTimeTrack(track)">

							<i class="far fa-edit"></i>
						</button>
						
						<button id="del" class="btn btn-secondary btn-sm" @click="getDeleteId(track)">

							<i class="fas fa-trash"></i>
						</button>
					</div>
				</div>
				
				<div for="description" >
				
					<p style="word-wrap: break-word;">{{trans(track.description)}}</p>
				</div>		
				
				<div for="created time details"  style="margin-top:-15px">

					<span id="span">{{trans('created_on')}}: {{formattedTime(track.created_at)}}&nbsp;</span>&nbsp;&nbsp;

					<span id="span">{{trans('modified_on')}}: {{formattedTime(track.updated_at)}}&nbsp;</span>

					<span id="span" v-if="track.worktime_type"><a :href="'worktime-type/'+track.worktime_type.id">{{trans('worktime_type')}}: {{track.worktime_type.name}}</a></span>
				</div>										
			</td>
		</tr>
		
		<transition name="modal">
			
			<record-event v-if="showModal" :onClose="onClose" :showModal="showModal" :trackData="trackData"  
				:deleteTrack="deleteTrack" :editTrack="editTrack" :updateData="reloadData">
					
			</record-event>
		</transition>
	</tbody>	
</template>

<script>

import {useStore} from 'vuex'
import {computed} from "vue";
import RecordTimeModal from "../../../Timeline/Mini/RecordTimeModal.vue";

	export default {

		name : 'record-row',

		description : 'Time track table row component',

		setup() {

			const store = useStore();

			return {

				formattedTime : computed(()=>store.getters.formattedTime),

				formattedDate : computed(()=>store.getters.formattedDate)
			}
		},

		props : {
			
			track : { type:Object, default : ()=> {} },

			current : { type:[Number, String], default : '' },

			reloadData : { type : Function }
		},

		components:{

			'record-event': RecordTimeModal,
		},

		data() {
			
			return {
				
				show:null,

				showModal:false,

				deleteTrack:false,

				editTrack : false,

				trackData:{},

				paramsObj:{},

				curPage:this.current
			}
		},

		methods:{

			showButton(x) {

				this.show = x;
			},

			hideButton(x) {
				this.show = null;
			},

			editTimeTrack(track){
			
				this.trackData = track;

				this.editTrack = true;
			
				this.showModal = true;
			},

			onClose(){
				
				this.paramsObj['page']=this.curPage;
				
				this.showModal = false;
				
				this.deleteTrack = false;

				this.editTrack = false;
				
				this.trackData = '';
				
				this.$store.dispatch('unsetValidationError');
			},

			getDeleteId(track){
				
				this.trackData = track;
				
				this.deleteTrack = true;
				
				this.showModal = true;
			}
		}
	};
</script>

<style scoped>
	
	.btn-sm{ background-image: none !important; }
	
	#span { color: #999;font-size: 11px;line-height:2; }
</style>