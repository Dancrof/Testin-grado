<!DOCTYPE html>
<?php
$lang = \Lang::getLocale();
$class = $lang == 'ar' ? "ar": "nonar";
?>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <style type="text/css">
            .ar {
                direction: rtl;
                text-align: right;
                font-family: 'dejavu sans, arial', sans-serif;
            }

            .nonar{
                font-family: 'dejavu sans, arial,', sans-serif;
                font-size: small;
            }

            .info-row{
                border-top: 1px solid #f4f4f4;
                padding: 10px;
                height: 30px;
                box-sizing: border-box;
                font-family: 'dejavu sans, arial', sans-serif;
            }

            .twemoji { width: 20px;height: 20px; }
        </style>
    </head>
    <body class="{!! $class !!}">
        <?php $ticketDetails =  $ticketDetails->getData(); $ticketDetails = $ticketDetails->data->ticket;
        $portal = App\Model\helpdesk\Theme\Portal::where('id', '=', 1)->first();
        ?>
        <aside>
            <div style="max-height: 127px!important; max-width:300px!important; float: right; align-content: center">
                <img src="{{$portal->logo}}"  style="max-height: 127px!important; max-width:300px!important; opacity: .8"/>
            </div>
            <br><br><br><br>
        </aside>
        <h2><u>{!! "#".$ticketDetails->ticket_number."" !!}</u></h2>
        <br>
        <table class="result_table" border="1" width="100%" align="center">
            <tr class="info-row">
                <td><b>{{trans('lang.subject')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->title  !!}</td>
            </tr>
            @if ($ticketDetails->status->name)
                <tr class="info-row">
                    <td><b>{{trans('lang.status')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->status->name  !!}</td>
                </tr>
            @endif
            <tr class="info-row">
                <td><b>{{trans('lang.departments')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->departments->name  !!}</td>
            </tr>
            <tr class="info-row">
                <td><b>{{trans('lang.help_topic')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->helptopic->name  !!}</td>
            </tr>
            @if($allTicketDetails)
            @if ($ticketDetails->last_replier)
            <tr class="info-row">
                <td><b>{{trans('lang.last_replier')}}:</b></td><td>&nbsp;
                    @if ($ticketDetails->last_replier->first_name)
                        {!! $ticketDetails->last_replier->first_name  !!}
                    @endif
                    @if ($ticketDetails->last_replier->last_name)
                        {!! $ticketDetails->last_replier->last_name  !!}
                    @endif
                </td>
            </tr>
            @endif
            @if ($ticketDetails->user)
            <tr class="info-row">
                <td><b>{{trans('lang.requester')}}:</b></td><td>&nbsp;
                    @if ($ticketDetails->user->first_name)
                        {!! $ticketDetails->user->first_name  !!}
                    @endif
                    @if ($ticketDetails->user->last_name)
                        {!! $ticketDetails->user->last_name  !!}
                    @endif
                </td>
            </tr>
            @endif
            @if ($ticketDetails->user)
            <tr class="info-row">
                <td><b>{{trans('lang.creator')}}:</b></td><td>&nbsp;
                    @if ($ticketDetails->user->first_name)
                        {!! $ticketDetails->user->first_name  !!}
                    @endif
                    @if ($ticketDetails->user->last_name)
                        {!! $ticketDetails->user->last_name  !!}
                    @endif
                </td>
            </tr>
            @endif
            @if($ticketDetails->assigned_team)
            <tr class="info-row">
                <td><b>{{trans('lang.assigned_team')}}:</b></td>
                <td>&nbsp;&nbsp;{!! $ticketDetails->assigned_team->name !!}</td>
            </tr>
            @endif
            @if($ticketDetails->assigned)
            <tr class="info-row">
                <td><b>{{trans('lang.assigned_agent')}}:</b></td>
                <td>&nbsp;&nbsp;{!! $ticketDetails->assigned->full_name!!}</td>
            </tr>
            @endif
            @if ($ticketDetails->source)
            <tr class="info-row">
                <td><b>{{trans('lang.source')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->source->name  !!}</td>
            </tr>
            @endif
            @if ($ticketDetails->type)
            <tr class="info-row">
                <td><b>{{trans('lang.type')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->type->name  !!}</td>
            </tr>
            @endif
            @if ($ticketDetails->priority)
            <tr class="info-row">
                <td><b>{{trans('lang.priority')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->priority->name  !!}</td>
            </tr>
            @endif
            @if ($ticketDetails->sla_plan)
            <tr class="info-row">
                <td><b>{{trans('lang.sla_plans')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->sla_plan->name  !!}</td>
            </tr>
            @endif
            @if($ticketDetails->location)
            <tr class="info-row">
                <td><b>{{trans('lang.location')}}:</b></td><td>&nbsp;&nbsp;{!! $ticketDetails->location->name  !!}</td>
            </tr>
            @endif

            @if(isset($ticketApproverDetails->data))
            @foreach($ticketApproverDetails->data as $approver)
                <tr class="info-row"><td><b>{{trans('lang.approved_workflow')}}:</b></td><td>&nbsp;&nbsp;<b>{{$approver->name}}</b></td></tr>
                @foreach($approver->approval_levels as $key => $approver_level)
                <tr class="info-row"><td><b>{{trans('lang.level')}} {{$key + 1}}:</b></td><td>&nbsp;&nbsp;<b>{{$approver_level->name}}</b></td></tr>
                    @foreach($approver_level->approve_users as $userKey => $approve_users)
                        <tr class="info-row">
                            <td><b>{{trans('lang.approver')}} {{$userKey + 1}}:</b></td><td>&nbsp;&nbsp;{!! $approve_users->full_name  !!}</td>
                        </tr>
                    @endforeach
                    @foreach($approver_level->approve_user_types as $userTypeKey => $approve_user_types)
                        <tr class="info-row">
                            <td><b>{{trans('lang.approver_type')}} {{$userTypeKey + 1}}:</b></td><td>&nbsp;&nbsp;{!! $approve_user_types->name  !!}</td>
                        </tr>
                    @endforeach
                @endforeach
            @endforeach
            @endif
            <?php if(count($ticketDetails->custom_field_values) > 0){ $customFields = $ticketDetails->custom_field_values; ?>
                @foreach ($customFields as $customField)
                <tr class="info-row">
                    <td><b>{{ $customField->label }}  :</b></td>
                    <td>
                        &nbsp;&nbsp;
                        @if (gettype($customField->value) == 'string')
                            {{ $customField->value }}
                        @endif
                        @if (in_array(gettype($customField->value), ['double', 'integer']))
                            {{ str_replace(',', '', number_format($customField->value)) }}
                        @endif
                        @if (gettype($customField->value) == 'array')
                            {{ implode(', ', $customField->value) }}
                        @endif
                    </td>
                </tr>
                @endforeach
            <?php } ?>
                <tr class="info-row">
                    <td><b>{{trans('lang.created_at')}}:</b></td><td>&nbsp;{!! faveoDate($ticketDetails->created_at)  !!}</td>
                </tr>
                @if ($ticketDetails->updated_at)
                    <tr class="info-row">
                        <td><b>{{trans('lang.updated_at')}}:</b></td><td>&nbsp;{!! faveoDate($ticketDetails->updated_at)  !!}</td>
                    </tr>
                @endif
            @endif

        </table>
        <br>
        <h3>{!! trans("lang.ticket-conversation-title") !!}</h3>
        <ul>
            @foreach ($ticketConversations as $ticketConversation)
                <?php
                    $name = $ticketConversation->first_name ? $ticketConversation->first_name.' '.$ticketConversation->last_name: "System";
                ?>
                <li>
                    <div style="margin-top:-2px">{!! trans("lang.posted_by_on", ["user"=> "<strong>".htmlentities($name)."</strong>", "time"=> faveoDate($ticketConversation->created_at)]) !!}
                    @if ($ticketConversation->is_internal)
                        ({!! trans("lang.as_internal_note") !!})
                    @endif
                    </div>
                    <div style="background-color: rgba(0,0,0,0.04); padding: 5px;" class="{!! $class !!}">{!! $ticketConversation->formatted_body !!}</div>
                    <br>
                </li>
            @endforeach
        </ul>
        @if($ticketActivitys && $allTicketDetails)
        <h3>{!! trans("lang.ticket_approval_activity") !!}</h3>
            <ul>
            @foreach ($ticketActivitys as $ticketActivity)
                <li>
                    <div style="margin-top:-2px">{!! trans("lang.approved_by_on", [ "time"=> faveoDate($ticketActivity->created_at)]) !!}
                    </div>
                    <div style="background-color: rgba(0,0,0,0.04); padding: 5px;" class="{!! $class !!}">{!! $ticketActivity->text !!}</div>
                    <br>
                </li>
            @endforeach
        </ul>
        @endif
        @if($requesterDetailsVisible && $requesterDetails)
        <h3>{!! trans("lang.requester") !!}</h3>
        <br>
        <table class="result_table">
            <tr class="info-row">
                <td><b>{{trans('lang.user_name')}}:</b></td><td>&nbsp;{!! $requesterDetails->user_name  !!}</td>
            </tr>
            <tr class="info-row">
                <td><b>{{trans('lang.email')}}:</b></td><td>&nbsp;{!! $requesterDetails->email  !!}</td>
            </tr>
            @if($requesterDetails->location)
                <tr class="info-row">
                    <td><b>{{trans('lang.location')}}:</b></td><td>&nbsp;{!! $requesterDetails->location->title  !!}</td>
                </tr>
            @endif
            @if($requesterDetails->country_code && $requesterDetails->mobile)
                <tr class="info-row">
                    <td><b>{{trans('lang.mobile')}}:</b></td>
                    <td>&nbsp;+{{ $requesterDetails->country_code }} {{ $requesterDetails->mobile }}</td>
                </tr>
            @elseif($requesterDetails->mobile)
                <tr class="info-row">
                    <td><b>{{trans('lang.mobile')}}:</b></td>
                    <td>&nbsp;{{ $requesterDetails->mobile }}</td>
                </tr>
            @endif
            @if($requesterDetails->phone_country_code && $requesterDetails->phone_number)
                <tr class="info-row">
                    <td><b>{{trans('lang.phone_number')}}:</b></td>
                    <td>&nbsp;+{{ $requesterDetails->phone_country_code }} {{ $requesterDetails->phone_number }}
                        @if($requesterDetails->ext)
                            <span>- {{ $requesterDetails->ext }}</span>
                        @endif
                    </td>
                </tr>
            @elseif($requesterDetails->phone_number)
                <tr class="info-row">
                    <td><b>{{trans('lang.phone_number')}}:</b></td>
                    <td>&nbsp;{{ $requesterDetails->phone_number }}
                        @if($requesterDetails->ext)
                            <span>- {{ $requesterDetails->ext }}</span>
                        @endif
                    </td>
                </tr>
            @endif
        @if(!empty($requesterDetails->organizations))
                <?php
                $org = [];
                foreach ($requesterDetails->organizations as $organization) {
                    $org[] = $organization->name;
                }
                $org = implode(',', $org)
                ?>
                <tr class="info-row">
                    <td><b>{{trans('lang.organizations')}}:</b></td><td>&nbsp;{!! $org  !!}</td>
                </tr>
            @endif
        </table>
        <br>
        @endif
        @if($agentDetailsVisible && $assignedAgentDetails)
            <h3>{!! trans("lang.assigned_agent") !!}</h3>
            <br>
            <table class="result_table">
                <tr class="info-row">
                    <td><b>{{trans('lang.user_name')}}:</b></td><td>&nbsp;{!! $assignedAgentDetails->user_name  !!}</td>
                </tr>
                <tr class="info-row">
                    <td><b>{{trans('lang.email')}}:</b></td><td>&nbsp;{!! $assignedAgentDetails->email  !!}</td>
                </tr>
                @if($assignedAgentDetails->location)
                    <tr class="info-row">
                        <td><b>{{trans('lang.location')}}:</b></td><td>&nbsp;{!! $assignedAgentDetails->location->title  !!}</td>
                    </tr>
                @endif
                @if($assignedAgentDetails->country_code && $assignedAgentDetails->mobile)
                    <tr class="info-row">
                        <td><b>{{trans('lang.mobile')}}:</b></td>
                        <td>&nbsp;+{{ $assignedAgentDetails->country_code }} {{ $assignedAgentDetails->mobile }}</td>
                    </tr>
                @elseif($assignedAgentDetails->mobile)
                    <tr class="info-row">
                        <td><b>{{trans('lang.mobile')}}:</b></td>
                        <td>&nbsp;{{ $assignedAgentDetails->mobile }}</td>
                    </tr>
                @endif
                @if($assignedAgentDetails->phone_country_code && $assignedAgentDetails->phone_number)
                    <tr class="info-row">
                        <td><b>{{trans('lang.phone_number')}}:</b></td>
                        <td>&nbsp;+{{ $assignedAgentDetails->phone_country_code }} {{ $assignedAgentDetails->phone_number }}
                            @if($assignedAgentDetails->ext)
                                <span>- {{ $assignedAgentDetails->ext }}</span>
                            @endif
                        </td>
                    </tr>
                @elseif($assignedAgentDetails->phone_number)
                    <tr class="info-row">
                        <td><b>{{trans('lang.phone_number')}}:</b></td>
                        <td>&nbsp;{{ $assignedAgentDetails->phone_number }}
                            @if($assignedAgentDetails->ext)
                                <span>- {{ $assignedAgentDetails->ext }}</span>
                            @endif
                        </td>
                    </tr>
                @endif
                @if(!empty($assignedAgentDetails->departments))
                    <?php
                    $dept = [];
                    foreach ($assignedAgentDetails->departments as $department) {
                        $dept[] = $department->name;
                    }
                    $dept = implode(',', $dept)
                    ?>
                    <tr class="info-row">
                        <td><b>{{trans('lang.departments')}}:</b></td><td>&nbsp;{!! $dept  !!}</td>
                    </tr>
                @endif
            </table>
            <br>
        @endif
    </body>
</html>
