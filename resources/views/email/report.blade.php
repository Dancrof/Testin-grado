<?php
$date = now();
$ticketUrl = Config::get('app.url').'/thread/';
?>
<html>
<body>
<table align="center" border="0" cellpadding="0" cellspacing="0" width="600" style="outline:1px solid #e4e4e4">
    <tbody>
    <tr>
        <td valign="top" style="background-color:#3d9eed">
            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width:100%">
                <tbody>
                <tr>
                    <td valign="top">
                        <table align="left" border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width:100%">
                            <tbody>
                            <tr>
                                <td style="text-align:center;padding:20px;font-family:Arial,'Helvetica Neue',Helvetica,sans-serif;width:66px">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width:66px;display:inline-block">
                                        <tbody>
                                        <tr>
                                            <td style="text-align:center;text-transform:uppercase;border:1px solid #fff;background-color:#fff;width:66px">
                                                <span style="font-weight:600;color:#3d9eed;font-size:12px;line-height:20px">{{$date->format('M')}}</span>
                                            </td>
                                        </tr>
                                        <tr style="border:1px solid #fff;height:40px;font-weight:400">
                                            <td style="border:1px solid #fff;width:66px;text-align:center">
                                                <span style="font-size:20px;color:#fff;font-weight:500!important">{{$date->format('d')}}</span>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                                <td style="border-bottom:0!important">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:left;margin-top:auto;margin-bottom:auto;display:inline-block;border-bottom:0">
                                        <tbody>
                                        <tr>
                                            <td>
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tbody>
                                                    <tr>
                                                        <td>
                                                            <h2 style="color:#fff;margin:0;font-size:22px;line-height:30px">{{$dailyReportName}}</h2>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-bottom:0">
                                                    <tbody>
                                                    <tr>
                                                        <td>
                                                            <h3 style="color:#fff;font-weight:300!important;margin:0;font-size:18px;line-height:30px">{{$date->format('l')}}</h3>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top" style="font-family:Arial,'Helvetica Neue',Helvetica,sans-serif;border-right:1px solid #e4e4e4;border-bottom:1px solid #e4e4e4">
            <table cellpadding="0" cellspacing="0" width="100%" style="background-color:#f4f5f8">
                <tbody>
                <tr>
                    <td style="padding:0 20px 20px 20px">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width:100%">
                            <tbody>
                            <tr style="padding-top:20px">
                                <td>
                                    <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width:100%;background-color:#fff;border:1px solid #d4d7dc;border-radius:3px;margin-top:20px">
                                        <tbody>
                                        <tr>

                                            <td align="center" style="padding:20px 30px 0 30px">
                                                <h2 style="text-align:center;font-weight:400;margin:0;margin-top: 9px">Greetings, {{$receiverName}}</h2>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" style="padding:10px 30px 20px 30px"><span style="font-size:13px;line-height:20px;color:#777;font-weight:400!important;font-style:italic"></span></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            @foreach($componentValues as $componentValue)
                                @if(is_object($componentValue))
                                    <?php
                                    $values = $componentValue->data->toArray()
                                    ?>
                                    @if($values)
                                        <tr style="padding-top:20px">
                                            <td>
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width:100%;background-color:#fff;border:1px solid #d4d7dc;margin-top:20px">
                                                    <tbody>
                                                    <tr>
                                                        <td valign="top" style="padding-left:20px;padding-top:20px">
                                                            <a href="" style="text-decoration:none;margin:0">

                                                                <h4 style="color:#3d9eed;font-size:16px;font-weight:500;display:inline-block;margin:7px">{{$componentValue->key}}</h4>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding:8px 20px 20px 20px">
                                                            <table border="0" cellpadding="0" cellspacing="0"  style="min-width:100%">

                                                                <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <table cellpadding="5" cellspacing="5" width="100%" style="border-radius: .25rem;min-width:100%;" >
                                                                            <td colspan="15">
                                                                                <div>

                                                                                    <hr style="margin-top:0px;background-color: lightgrey">

                                                                                </div>
                                                                            </td>
                                                                            @foreach($values as $value)
                                                                                <?php $dueAt = $value['duedate']?changeTimezoneForDatetime($value['duedate'],'UTC','UTC')->format(dateTimeFormat()):false; ?>

                                                                                <tr style="font-family:Sans-Serif;">
                                                                                    <td style="width: 300px"><a href="{{$ticketUrl.$value['id']}}" style="text-decoration: none!important"><span style="color: black;font-size: 15px">{{$value['ticket_number']}}</span><br><span style="color: grey;font-size: 12px">{{array_first($value['thread'])['title']}}</span></a></td>
                                                                                    <td style="color: red;font-size: 12px"><span>{{ !$dueAt ?'':'Due At: '.$dueAt}}</span></td>
                                                                                </tr>
                                                                            @endforeach
                                                                            <tr style="padding-top:20px">
                                                                                <?php $url = parse_url($componentValue->redirectTo)['query'] ?>
                                                                                <td>
                                                                                    <a href="{{url("panel/tickets?$url")}}" style="text-decoration:none" target="_blank"><span style="font-size:14px;color:#3d9eed">{{$componentValue->additionalData == 0 ?'': '+'.$componentValue->additionalData.' more' }} </span></a>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr></tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    @endif
                                @endif
                            @endforeach
                            @foreach($componentValues as $componentValue)
                                @if(is_array($componentValue))
                                    <?php
                                    $title  = $componentValue['key'];
                                    $values = is_array($componentValue['data']) ? $componentValue['data'] : $componentValue['data']->data;
                                    ?>
                                    @if($values)
                                        <tr style="padding-top:20px">
                                            <td>
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width:100%;background-color:#fff;border:1px solid #d4d7dc;margin-top:20px">
                                                    <tbody>
                                                    <tr>
                                                        <td valign="top" style="padding-left:20px;padding-top:20px">
                                                            <a href="" style="text-decoration:none;width: auto">

                                                                <h4 style="color:#3d9eed;font-size:16px;font-weight:500;display:inline-block;margin:7px">{{$title}}</h4>

                                                            </a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding:8px 20px 20px 20px">
                                                            <table border="0" cellpadding="0" cellspacing="0"  style="min-width:100%">
                                                                <tbody>


                                                                <tr>
                                                                    <td>
                                                                        <table cellpadding="5" cellspacing="5" width="100%" style="border-radius: .25rem; min-width:100%;" >
                                                                            <td colspan="15">
                                                                                <div>
                                                                                    <hr style="margin-top:0px;background-color: lightgrey">
                                                                                </div>
                                                                            </td>
                                                                            @if($title == "Requires Immediate Action")
                                                                                @foreach($values as $value)

                                                                                    <tr style="font-family: Sans-Serif;">
                                                                                        <td style="width: 300px;">{!! $value->title !!}
                                                                                            <?php $metaData = array_keys($value->metaData, 1,true);?>
                                                                                            @foreach ($metaData as $meta)
                                                                                                <a style="border-radius: 3px;font-size: 70%;font-weight:700;padding: 1px 6px 1px 3px;text-decoration: none!important;color: {{$meta == "assigned_to_me" ? "#fff":"#1f2d3d" }};background-color:{{$meta == "assigned_to_me" ? "#17a2b8":"#ffc107" }}">{{ucfirst(str_replace('_',' ',$meta))}}</a>
                                                                                            @endforeach
                                                                                        </td>
                                                                                        <td style=""><span style="color: red;font-size: 12px">{{array_first($value->attributes)->key.': '.array_first($value->attributes)->value}}</span></td>
                                                                                    </tr>
                                                                                @endforeach
                                                                                @if($componentValue['actionLimit'])
                                                                                    <tr style="padding-top:20px">
                                                                                        <td>
                                                                                            <a href="{{url('panel/dashboard')}}" style="text-decoration:none" target="_blank"><span style="font-size:14px;color:#3d9eed">View More </span></a>
                                                                                        </td>
                                                                                    </tr>
                                                                                @endif
                                                                            @endif
                                                                            @if($title == "System summary for last 24 hours")
                                                                                @foreach($values as $value)

                                                                                    <tr style="font-family: Sans-Serif">
                                                                                        <td  style="color: Black;font-size: 14px">{{$value->title}}</td>
                                                                                        <td><span style="background:#ffffff;border:1px solid lightblue;color:#3d9eed;padding:.1rem .325rem;font-size:10px;line-height:1.5;text-transform:uppercase;font-weight:600;border-radius:4px;margin-right:.125rem">{{array_first($value->attributes)->value}}</span></td>
                                                                                    </tr>
                                                                                @endforeach
                                                                            @endif
                                                                            @if($title == "Todo")
                                                                                @foreach($values as $value)

                                                                                    <tr style="font-family: Sans-Serif">
                                                                                        <td  style="color: Black;font-size: 15px;"><span>&#8594;</span>&nbsp;<i>@if($value['status'] == 'completed')<strike>{{$value['name']}}</strike>@else {{$value['name']}} @endif</i>
                                                                                            <a style="border-radius: 3px;font-size: 70%;font-weight:700;padding: 1px 6px 1px 3px;text-decoration: none!important;color:#fff;background-color:@if($value['status'] == "completed") green @elseif($value['status'] == "in-progress") #17a2b8 @elseif($value['status'] == 'pending') red @endif">{{$value['status']}}</a>
                                                                                        </td>
                                                                                    </tr>
                                                                                @endforeach
                                                                                @if($componentValue['todoLimit'])
                                                                                    <tr style="padding-top:20px">
                                                                                        <td>
                                                                                            <a href="{{url('panel/dashboard')}}" style="text-decoration:none" target="_blank"><span style="font-size:14px;color:#3d9eed">View More </span></a>
                                                                                        </td>
                                                                                    </tr>
                                                                                @endif
                                                                            @endif
                                                                        </table>

                                                                    </td></tr></tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    @endif
                                @endif
                            @endforeach

                            <tr style="padding-top:20px">
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width:100%;">
                                        <tbody>
                                        <tr>
                                            <td style="padding:8px 20px 20px 20px">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="min-width:100%">
                                                    <tbody>
                                                    <tr>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" style="min-width:200px;width:200px;margin-bottom:16px">

                                                            </table>
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" style="min-width:200px;width:200px;margin-bottom:16px">

                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style="padding-top:12px">
                                                        <td>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
    </tr>
    </tbody>
</table>
</body>
</html>



