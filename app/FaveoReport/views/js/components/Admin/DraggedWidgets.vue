<template>

	<div class="daily-widget">
		
		<table class="report_table">
   							
			<tbody>
				
				<tr>

			        <td class="report_head">
			        
			            <h4 class="report_head_h4">{{ticket.key}}</h4>
			        </td>

			        <td class="report_delete">

			        	<a class="btn btn-light btn-sm" @click="onDelete(ticket)" v-tooltip="trans('delete')">

			        		<i class="fas fa-trash"></i> 
			        	</a>
			        </td>
			    </tr>

			    <tr>

				    <td class="report_line" colspan="2"><hr class="report_line_hr"></td>
				</tr>

				<template v-if="ticket.id == 'system_analysis'">
	      			
	      			<tr>

		                <td class="report_content">{{trans('received_tickets')}}</td>

		                <td><span class="report_count">10</span></td>
		            </tr>

		            <tr>

		                <td class="report_content">{{trans('exceptions_caught')}}</td>

		                <td><span class="report_count">03</span></td>
		            </tr>
	      		</template>

	      		<template v-else-if="ticket.id == 'todo_list'">
	      			
	      			<tr>

                        <td class="report_content"><span>→</span>&nbsp;<i>{{trans('todo_eg')}}</i></td>
                    </tr>
	      		</template>

	      		<template v-else>
	      			
	      			<tr>
			                                 		
		         		<td class="report_content">

		         			<a><span>{{trans('sample_report_num')}}</span><br>
		             			<span class="report_content_title">{{trans('sample_report_tic')}}</span>
		             		</a>

		             		<template v-if="ticket.id == 'requires_immediate_action'">

                      &nbsp;<a class="report_badge">{{trans('assigned_to_me')}}</a>&nbsp;
		             			
		             			<a class="report_badge_1">{{trans('reopened')}}</a>
		             		</template>
		             	</td>
		         		
		         		<td class="report_content_date">

		         			<span>{{trans('sample_report_due')}}</span>
		         		</td>
		      		</tr>
	      		</template>
			</tbody>
		</table>
	</div>
</template>

<script>
	
	export default {
  		
  		props: {
			
			ticket: { type: Object,default: () => ({}) },

			removeItem : { type : Function }
  		},

  		methods : {

			onDelete(value) {

				this.removeItem(value);
			}
  		}
	};
</script>

<style scoped>

	.report_table { min-width:100%;background-color:#fff;border:1px solid #d4d7dc;margin-top:20px; }

	.report_head { padding-left:20px;padding-top:20px; }

	.report_head_h4 { color:#3d9eed;font-size:16px;font-weight:500;display:inline-block;margin:7px }

	.report_content { padding:8px 20px 20px 25px;width: 70%; }

	.report_line { padding-left: 25px;padding-right: 25px; }

	.report_line_hr { margin-top:10px;background-color:lightgrey; }

	.report_content_title { color:grey;font-size:12px; }

	.report_content_date { color:red;font-size:12px; }

	.daily-widget { cursor: move; }

	.report_badge { border-radius: 3px;font-size: 70%;font-weight: 700;padding: 1px 6px 3px 3px;text-decoration: none !important;color: rgb(255, 255, 255);background-color: rgb(23, 162, 184); }

	.report_badge_1 { border-radius: 3px;font-size: 70%;font-weight: 700;padding: 1px 6px 3px 3px;text-decoration: none !important;color: #1f2d3d;background-color: #ffc107; }

	.report_count { background:#ffffff;border:1px solid lightblue;color:#3d9eed;padding:.1rem .325rem;font-size:10px;line-height:1.5;text-transform:uppercase;font-weight:600;border-radius:4px;margin-right:.125rem }

	.report_delete { text-align: right;padding-right: 25px;padding-top: 20px; }
</style>
