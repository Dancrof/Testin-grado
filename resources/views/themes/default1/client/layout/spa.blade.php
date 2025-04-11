<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <base href="{{url('/')}}">

    <meta name="csrf-token" content="{{ csrf_token() }}">

    <meta name="api-base-url" content="{{ url('/') }}"/>

    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>

    <link href="{{assetLink('css','widgetbox')}}" rel="stylesheet" type="text/css"/>

    <link href="{{assetLink('css','bootstrap-5')}}" rel="stylesheet" type="text/css"/>

    <link href="{{assetLink('css','font-awesome-6')}}" rel="stylesheet" type="text/css"/>

    <link href="{{assetLink('css','client-custom-css')}}" rel="stylesheet" type="text/css"/>

    <link href="{{assetLink('css','jquery-rating')}}" rel="stylesheet" type="text/css"/>

    <script src="{{assetLink('js','jquery-3-latest')}}" type="text/javascript" media="none" onload="this.media='all';">

    </script>

    <!-- for recaptcha session storage we are using this file-->
    @include('themes.default1.common.recaptcha')

    </script>

    <script src="{{assetLink('js','polyfill')}}"></script>

    <link href="{{assetLink('css','select2')}}" rel="stylesheet" type="text/css"/>

    <link rel="stylesheet" href="{{assetLink('css','glyphicon')}}">

    <style>

        .btn .caret {
            margin-left: 0;
        }
         .caret {
             display: inline-block;
             width: 0;
             height: 0;
             margin-left: 2px;
             vertical-align: middle;
             border-top: 4px dashed;
             border-top: 4px solid\9;
             border-right: 4px solid transparent;
             border-left: 4px solid transparent;
         }
         .caret {
             border-top: 4px solid !important;
         }
        .btn-light:hover {
            border-color: #c6c7c8;
        }
        .v-select input::placeholder { opacity: 0.3 !important; }

        ::placeholder { opacity: 0.7 !important; }

        .userContent{
           width:70%;
           margin-left: 16%;
       }
       .boxChange{
           display: flex;
           justify-content: space-between;
       }

        .userIcon {
            left: 71px;
            top: 3px;
            position: absolute;
        }

        *:focus-visible {
            outline: none !important;
        }

        .VueTables .table-responsive > table {
            border-collapse: collapse !important;
        }

        #app-client-panel .VuePagination__pagination {
            margin-top: -5px !important;
            margin-right: 0px !important;
            float: right !important;
            /*display: flex !important;*/
            padding-left: 5px;
        }

        @media (min-width: 1200px) {

            .container {
                max-width: 1170px;
            }
        }

        .footer_align {
            direction: rtl;
        }

        .text-small {
            font-size: 14px;
        }

        a:hover {
            text-decoration: none !important;
            color: #1e2125 !important;
        }

        .center-of-page {
            left: 12% !important;
            top: 40% !important;
        }

        .btn-default {
            background-color: #f8f9fa;
            border-color: #ddd;
            color: #444;
        }

        .form-helper h3 {
            text-align: center;
        }

        .form-helper {
            margin-bottom: 50px !important;
            display: inline-block;
        }

       .card {
           box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2);
           margin-bottom: 1rem;
       }

       .mb2 { margin-bottom: 2px; position: relative; left: 4px; }

        .iti {
            width: 100%;
            --iti-path-flags-1x: url({{assetLink('image','mflags')}});
            --iti-path-flags-2x: url({{assetLink('image','mflags2x')}});
            --iti-path-globe-1x: url({{assetLink('image','mglobe')}});
            --iti-path-globe-2x: url({{assetLink('image','mglobe2x')}});
        }

        #faveo-form-client-panel .c-form-radio{ padding-left: 1.9rem !important; margin-left: 0px !important; }
        #faveo-form-client-panel .c-form-checkbox { padding-left: 0.8rem !important; }

        .btn { box-shadow: none !important; }

        .btn-check:checked+.btn, .btn.active, .btn.show, .btn:first-child:active, :not(.btn-check)+.btn:active {
            color: #000;
            background-color: #c6c7c8;
            border-color: #babbbc;
            box-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
        }

        table {
            --bs-table-bg: transparent;
            --bs-table-accent-bg: transparent;
            --bs-table-striped-color: #212529;
            --bs-table-striped-bg: rgba(0, 0, 0, 0.05);
            --bs-table-active-color: #212529;
            --bs-table-active-bg: rgba(0, 0, 0, 0.1);
            --bs-table-hover-color: #212529;
            --bs-table-hover-bg: rgba(0, 0, 0, 0.075);
            width: 100%;
            margin-bottom: 1rem;
            color: #212529;
            vertical-align: top;
            border-color: #dee2e6;
        }

        .custom-input {
            position: relative;
            top: 1px !important;
        }

        .check_align {
            top: -3px !important;
        }
    </style>

    <!-- check if lanuage is RTL, if yes, inject bootstrap-RTL -->

    <?php
    $lang = App::getLocale();
    if ($lang == 'ar') {
        echo "<style>#app-client-panel { direction: rtl; }</style>";
        $bootstrapRTLPath = assetLink('css', 'bootstrap-rtl');
        $intlRTLPath = assetLink('css','intlTelInput-rtl');
        echo "<link href=$bootstrapRTLPath rel='stylesheet' type='text/css'/>";
        echo "<link href=$intlRTLPath rel='stylesheet' type='text/css' />";
    } else {
        echo "<style>#app-client-panel { direction: ltr; }</style>";
        $intlLTRPath = assetLink('css','intlTelInput');
        echo "<link href=$intlLTRPath rel='stylesheet' type='text/css' />";
    }
    ?>

    <?php
    try {
        $seo = new \App\Http\Controllers\Client\helpdesk\SeoController();
        $layoutController = new \App\Http\Controllers\Client\helpdesk\ClientLayoutController();
        $authController = new App\Http\Controllers\Auth\AuthController();
        // layout data
        $layout = $layoutController->getLayoutData();

        $whiteLabel = isWhiteLabelEnabled();
        // auth user data
        $authInfo = $authController->getLoggedInClientInfo();
        // dd($layout, $authInfo);
        $response = $seo->getUrlandAppendTitleDescription();
        $meta = json_decode($response->content())->data;

        $is2faEnforced = App\Model\helpdesk\Settings\Security::where('id', 1)->value('is_2fa_enforced');

        $isUpdatedVersion = (Schema::hasColumn('settings_system', 'is_updated')) ?
            App\Model\helpdesk\Settings\System::where('id', 1)->value('is_updated') : 0;
    } catch (\Exception $e) {
        \Logger::exception($e,'default');
    }
    ?>

    <meta name="title" content="{!! $meta->title !!} :: {!! strip_tags($meta->company_name) !!}">

    <meta name="description" content="{!! $meta->description !!}">

    <meta content="{!! $meta->company_logo !!}" property="og:image">
    <?php \Event::dispatch('customcss-event', [['fired_at' => 'clientlayout', 'request' => Request()]]); ?>

    <style>
        .card-title {
            float: left;
            font-size: 1rem;
            font-weight: 400;
            margin: 0;
        }

        .card-header > .card-tools {
            float: right;
            margin-right: -.625rem;
        }

        .btn-tool {
            background-color: transparent;
            color: rgba(31, 45, 61, .8);;
            font-size: .875rem;
            margin: -.75rem 0;
            padding: .25rem .5rem;
        }

        .range_btn {
            font-size: 13px;
        }

        .btn-primary {
            background-color: #337ab7 !important;
            border-color: #337ab7 !important;
        }

        ::-ms-reveal {
            display: none;
        }
    </style>

    @vite(['resources/assets/js/app.js'])
</head>

<body>

<script type="text/javascript">
    @php
        $user = Auth::user();
        $tag = Config::get('app.tags');
        $lang = App::getLocale();
    @endphp
    sessionStorage.setItem('data_time_format', '{{ dateTimeFormat() }}');
    sessionStorage.setItem('date_format', '{{ dateFormat() }}');
    sessionStorage.setItem('timezone', '{{ agentTimeZone() }}');
    sessionStorage.setItem('userLoggedIn', '{{ $user }}');
    sessionStorage.setItem('app_version', '{{$tag}}');
    sessionStorage.setItem('app_language', '{{$lang}}');
    sessionStorage.setItem('is_rtl', '{{ App::getLocale() == "ar" ? 1 : 0}}');
</script>
@include('themes.default1.common.socket')

<div id="app-client-panel">

    <client-panel-renderer :layout-details="{{ json_encode($layout) }}"
                           :is2fa-enforced="{{ json_encode($is2faEnforced) }}"
                           :auth-info="{{ json_encode($authInfo) }}"
                           :is-updated-version="{{ json_encode($isUpdatedVersion) }}"
                           :white-label="{{ json_encode($whiteLabel) }}" >

    </client-panel-renderer>
</div>

<script type="text/javascript" src="{{ bundleLink('js/lang' ) }}"></script>

{{--		<script type="text/javascript" src="{{ bundleLink('js/common.js') }}"></script>--}}

{{--		<script type="text/javascript" src="{{ bundleLink('js/app.js') }}"></script>--}}

<script src="{{assetLink('js','select2')}}"></script>

<script type="text/javascript" src="{{assetLink('js','popper')}}"></script>

<script type="text/javascript" src="{{assetLink('js','bootstrap-5')}}"></script>

<script type="text/javascript" src="{{assetLink('js','superfish')}}"></script>

<script type="text/javascript" src="{{assetLink('js','mobilemenu')}}"></script>

<script type="text/javascript" src="{{assetLink('js','tinymce')}}"></script>

<script type="text/javascript">
    localStorage.setItem('LANGUAGE', '{{Lang::getLocale()}}');
</script>
{{-- This event is no more required as now the customJs scripts are being handled at the front-end --}}
{{--		<php \Event::dispatch('timeline-customjs', [['fired_at' => 'clientlayout','request' => Request()]]); ?>--}}

<?php
// adding scripts for plugins
// there's no point in adding the entire script, so we can use dynamic import
// emit an event which ldap is listening to
\Event::dispatch('client-panel-scripts-dispatch');
?>


</body>
</html>