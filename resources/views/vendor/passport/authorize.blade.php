<!DOCTYPE html>
<html lang="en">
<?php
  $appLogo = \App\Model\helpdesk\Developer\OauthFaveoAttributes::where('client_id',$client->id)->value('profile_pic');
  $portal = \App\Model\helpdesk\Theme\Portal::first();
  $companyUrl = config('app.url');
  $urlWithoutHttps = str_replace("https://", "", $companyUrl);
  $homePageUrl = \App\Model\helpdesk\Developer\OauthFaveoAttributes::where('client_id', $client->id)->value('homepage_url');
  $companyLogo = $portal->getOriginal('logo');
  $usWhiteLabel = isWhiteLabelEnabled() ? trans('lang.us_oauth') : 'Faveo';

  ?>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{trans('lang.authorization_request')}}</title>
    <link href="https://fonts.googleapis.com/css?family=Lato:400,700|Rubik:400,500&display=swap" rel="stylesheet">
    <link href="{{assetLink('css','font-awesome-6')}}" rel="stylesheet" type="text/css" />
    <link href="{{assetLink('css','adminlte-4')}}" rel="stylesheet" type="text/css" id="adminLTR" media="none" onload="this.media='all';"/>
    <link href="{{$portal->getOriginal('icon')}}" rel="shortcut icon">

    <style>
        body {
            font-family: 'Lato', sans-serif;
            background-color: #E2EAF7 !important;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            min-height: 100vh;
        }

        #loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.7); /* Semi-transparent background */
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999; /* Ensure it's on top of other content */
        }

        #loader::after {
            content: "";
            border: 6px solid #f3f3f3; /* Light grey */
            border-top: 6px solid #3498db; /* Blue */
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 2s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .mx-auto {
            margin-right: auto !important;
            margin-left: auto !important;
        }

        .logo-container{
            display: flex;
            justify-content: center;
            padding:30px 0 10px 0;
        }

        .content-container{
            display: flex;
            justify-content: center;
            padding-bottom: 0;
        }

        .card {
            background-color: #FFFFFF;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            border-radius: 8px;
            max-width: 630px !important;
            display: flex;
            justify-content: center;
        }

        .company-details{
            display: flex;
            justify-content: center;
            position: fixed;
            bottom: 10px;
            width: 100%;
            transform: translateX(-50%);
            left: 50%;
        }

        .card-header{
            text-align: left;
            background-color: #FFFFFF !important;
            align-items: center;
        }

        .card-footer{
            background-color: #FFFFFF !important;
        }

        .card-body {
            text-align: center;
            align-items: center;
        }

        /* Responsive Adjustments */
        @media only screen and (max-width: 900px) {
            .card {
                max-width: 360px !important;
            }
        }

    </style>
</head>
<body>
<div id="loader"></div>

<div id='data-container' class="container" style="display:none">

    <div class="logo-container">
        @if(empty($appLogo) && empty($companyLogo))

        @else
            <img src="{{$companyLogo}}" height="100" width="160" style="color: blue" alt="company-logo">
        @endif
    </div>

    <div class='content-container'>
        <div class="card bg-white">
            <div class="card-header pb-0 pt-3">
                <h6 class="p-0 text-muted">{{trans('lang.sign_in_with_oauth', ['application_name' => isWhiteLabelEnabled() ? trans('lang.us_oauth') : 'Faveo'])}}</h6>
            </div>
            <div class="card-body pb-0">
                <h3>Sign in to {!! $urlWithoutHttps !!}</h3>
                <p>
                    <img src="{!! \Auth::user()->profile_pic !!}" alt="Profile Picture" style="border-radius: 50%; max-height: 70px; max-width: 70px;">
                    <br>
                    <span class="client-info">
                        <small class="text-muted"><strong>{{ $client->name }}</strong> {{trans('lang.wants_to_access_your')}} <strong>{{\Auth::user()->user_name}}</strong> {{trans('lang.account')}}</small>
                    </span>
                </p>
                <p class="pb-0 text-muted">{!! trans('lang.by_cont_oauth', ['product' => isWhiteLabelEnabled() ? trans('lang.we_oauth') : 'Faveo']) !!} <a href="{!!$homePageUrl!!}" target="_blank" style="color: #3c8dbc;">{!! $client->name !!}</a>.
                    @if(!isWhiteLabelEnabled())
                        See our<a href="{!!$homePageUrl!!}" target="_blank" style="color: #3c8dbc;"> {{trans('lang.privacy_policy')}}</a> and <a href="{!!$homePageUrl!!}" target="_blank" style="color: #3c8dbc;">{!! trans('lang.terms_of_use') !!}.</a>
                    @endif
                </p>
                <p class="text-muted">{!! trans('lang.do_what_may',['product'=> isWhiteLabelEnabled() ? trans('lang.us_oauth') : 'Faveo']) !!} <a href="{!! $companyUrl !!}/auth/login" target="_blank" style="color: #3c8dbc;">{!! trans('lang.faveo_account',['product' => isWhiteLabelEnabled() ?: 'Faveo']) !!}</a>.</p>
                <hr>
            </div>

            <div class="card-footer">
                <div class="buttons">
                    <form method="post" action="{{ route('passport.authorizations.deny') }}">
                        @csrf
                        @method('DELETE')
                        <input type="hidden" name="state" value="{{ $request->state }}">
                        <input type="hidden" name="client_id" value="{{ $client->getKey() }}">
                        <input type="hidden" name="auth_token" value="{{ $authToken }}">
                        <button class="btn btn-secondary float-start">{{trans('lang.Cancel_req')}}</button>
                    </form>
                    <form method="post" action="{{ route('passport.authorizations.approve') }}">
                        @csrf
                        <input type="hidden" name="state" value="{{ $request->state }}">
                        <input type="hidden" name="client_id" value="{{ $client->getKey() }}">
                        <input type="hidden" name="auth_token" value="{{ $authToken }}">
                        <button type="submit" class="btn btn-primary width-full ws-normal float-end">{{trans('lang.auth_req_third')}} {!! $client->name !!}</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="company-details">

    <?php
    $company = App\Model\helpdesk\Settings\Company::where('id', '=', '1')->first();
    ?>
    @if(isWhiteLabelEnabled())
        <p class="text-muted">
            <span>&copy; {{\Carbon\Carbon::now()->year}}
          <a href="{{optional($company)->website}}" target="_blank" style="color: #3c8dbc;">{{ optional($company)->company_name }}.</a>
            </span>
        </p>
    @else
        <p class="text-muted">
            <span>&copy; {{\Carbon\Carbon::now()->year}}
          <a href="{{optional($company)->website}}" target="_blank" style="color: #3c8dbc;">{{ optional($company)->company_name }}.</a>
            </span> {{ trans('lang.all_rights_reserved') }}. {{ trans('lang.powered_by') }} <a href="https://www.faveohelpdesk.com/" target="_blank" style="color: #3c8dbc;">Faveo</a>
        </p>
    @endif
</div>

<script src="{{assetLink('js','jquery-3-latest')}}" type="text/javascript"></script>
<script src="{{assetLink('js','ui-bootstrap-tpls')}}"></script>
<script src="{{assetLink('js','bootstrap-5')}}" type="text/javascript"></script>
<script src="{{assetLink('js','adminlte-4')}}" type="text/javascript"></script>
<script>
    // Show loader initially
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById('loader').style.display = 'flex';
        document.getElementById('data-container').style.display = 'none';
    });

    // Hide loader when everything is loaded
    window.onload = function() {
        document.getElementById('loader').style.display = 'none';
        document.getElementById('data-container').style.display = 'block';
    };
</script>
</body>
</html>
