@extends('themes.default1.installer.layout.installer')

@section('searchDriver')
done
@stop

@section('license')
done
@stop

@section('environment')
done
@stop

@section('database')
done
@stop

@section('locale')
done
@stop

@section('license-code')
done
@stop

@section('ready')
active
@stop

@section('content')

        <a class="twitter-share-button" target="_blank" href="https://twitter.com/intent/tweet?text=I just set up a new HELPDESK with @faveohelpdesk www.faveohelpdesk.com" @if(isWhiteLabelEnabled()) style="display:none;" @endif>
            <img src="https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQ-uhinU3OzXKj9zlFO7dFxHaChqyHPcWWg5nWgMqYt6N5b3knK" style="width: 86px; float: right;">
        </a>

        <h1 id="helpdesk-header" style="text-align: center;display: none">{!! Lang::get('lang.your_helpdesk_is_ready') !!}</h1>
<div class="woocommerce-message woocommerce-tracker" id="finished-setup-msg" style="display: none">
                <p>{!! Lang::get('lang.all_right_sparky_you_have_made_it') !!}</p>

            </div>

        <div id="show-install">
            <div class="row">
                <div class="col-md-2">
                </div>
                <div class="col-md-9" style="text-align: center" id='loader' >
                    <img src="{{assetLink('image','gifloader')}}"><br/>
                    <p><strong>Please wait, Finishing setup...</strong></p><br/><br/>
                </div>

            </div>
        </div>
        <div class="setup-next-steps">
            <div class="setup-next-steps-first">
                <h2>{!! Lang::get('lang.next_step') !!}</h2>
                <ul>

                    <li class="setup-product"><a class="button button-primary button-large" href="{!! url('auth/login') !!}" style="float: none; text-align: center; font-size: 24px;    padding: 15px;     line-height: 1;">{!! trans('lang.login_to_faveo') !!}</a>
                    </li>
                </ul>
            </div>
            <div class="setup-next-steps-last" @if(isWhiteLabelEnabled()) style="display:none;" @endif>
                <h2>{!! Lang::get('lang.learn_more') !!}</h2>
                <ul>
                    <li class="video-walkthrough"><a target="_blank" href="https://www.youtube.com/channel/UC-eqh-h241b1janp6sU7Iiw">{!! Lang::get('lang.video_walk_through') !!}</a>
                    </li>
                    <li class="sidekick"><a target="_blank" href="https://support.faveohelpdesk.com/knowledgebase">{!! Lang::get('lang.knowledge_base') !!}</a>
                    </li>

                    <li class="newsletter"><a href="mailto:support@ladybirdweb.com">{!! Lang::get('lang.email_support') !!}</a>
                    </li>
                    <br>
                    <br>
                    <br>
                </ul>
            </div>
        </div>
   <script>
       document.onreadystatechange = function () {
           if(document.readyState == "complete") {
               $('#show-install').hide();
               $('#finished-setup-msg').show();
               $('#helpdesk-header').show();
           }
       }
   </script>
  @stop