<!DOCTYPE html>

<html>

    <?php

        $company = App\Model\helpdesk\Settings\Company::where('id', '=', '1')->first();

        $portal = App\Model\helpdesk\Theme\Portal::where('id', '=', 1)->first();

        $title = App\Model\helpdesk\Settings\System::where('id', '=', '1')->value('name');

        $title_name = $title ?? "SUPPORT CENTER";

        $is2faEnforced = App\Model\helpdesk\Settings\Security::where('id',1)->value('is_2fa_enforced');

        $is2faActiveForUser = \App\User::where('id',\Auth::user()->id)->value('is_2fa_enabled');

        $isUpdatedVersion = (Schema::hasColumn('settings_system', 'is_updated'))?
                             App\Model\helpdesk\Settings\System::where('id',1)->value('is_updated'):0;

        $rtl_class = "";

        if (str_contains($portal->admin_header_color, 'skin')) {

            $portal->admin_sidebar_color = str_replace("skin","sidebar-dark", $portal->admin_header_color);

        }

        $portal->admin_header_color = $portal->admin_header_color ? str_replace("skin","navbar-dark navbar", $portal->admin_header_color) : 'navbar-light';
    ?>

    <head>

        <meta charset="UTF-8">

        <base href="{{url('/admin/')}}">

        @yield('meta-tags')

        <title> {!! strip_tags($title_name) !!} </title>

        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>

        <meta name="_token" content="{!! csrf_token() !!}"/>

        <meta name="csrf-token" content="{{ csrf_token() }}">

        <meta name="api-base-url" content="{{ url('/') }}" />

        <link href="{{$portal->icon}}" rel="shortcut icon">

        <!-- Google Font: Source Sans Pro -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

        <?php

            if(App::getLocale() == 'ar'){

                $rtl_class = "rtl";

                $adminRTLPath = assetLink('css','adminlte-4-rtl');
                $intlRTLPath = assetLink('css','intlTelInput-rtl');

                echo "<link href=$adminRTLPath rel='stylesheet' type='text/css' />";
                echo "<link href=$intlRTLPath rel='stylesheet' type='text/css' />";

            } else {

                $rtl_class = "";

                $adminLTRPath = assetLink('css','adminlte-4');
                $intlLTRPath = assetLink('css','intlTelInput');

                echo "<link href=$adminLTRPath rel='stylesheet' type='text/css' />";
                echo "<link href=$intlLTRPath rel='stylesheet' type='text/css' />";
            }
        ?>

        <link href="{{assetLink('css','font-awesome-6')}}" rel="stylesheet" type="text/css" />

        <!-- Ionicons -->
        <link href="{{assetLink('css','ionicons')}}" rel="stylesheet"  type="text/css" />

        <link href="{{assetLink('css','jquery-rating')}}" rel="stylesheet" type="text/css" />

        <link href="{{assetLink('css','daterangepicker')}}"  rel="stylesheet" type="text/css" />

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <link href="{{assetLink('css','nprogress')}}" rel="stylesheet" type="text/css"/>

        <link href="{{assetLink('css','select2')}}" rel="stylesheet" type="text/css"  media="none" onload="this.media='all';"/>

    <!-- <link rel="stylesheet" href="{{assetLink('css','new-overlay')}}"> -->

{{--        <link rel="stylesheet" href="{{assetLink('css','pagination')}}">--}}

        <link rel="stylesheet" href="{{assetLink('css','glyphicon')}}">

        <link rel="stylesheet" href="{{assetLink('css','bs-color-picker')}}">

        <style>

            /* Default striped rows (light theme) */
            .table-striped tbody tr:nth-of-type(odd) {
                background-color: rgba(0, 0, 0, 0.05); /* Light gray */
                color: #212529; /* Default text color */
            }

            /* Dark mode striped table */
            .table-dark.table-striped tbody tr:nth-of-type(odd) {
                background-color: rgba(255, 255, 255, 0.05); /* Slightly lighter shade */
                color: #ffffff; /* White text */
            }

            /* Striped columns */
            .table-striped-columns>:not(caption)>* > :nth-child(odd) {
                background-color: rgba(0, 0, 0, 0.05); /* Light gray */
                color: #212529;
            }
            body {
                font-family: 'Source Sans Pro';
            }

            .list-group-unbordered>.list-group-item {
                border-left: 0;
                border-radius: 0;
                border-right: 0;
                padding-left: 0;
                padding-right: 0;
            }

            .user-panel img {
                width: 2.1rem;
            }
            
            .parent_field {
                 border: 1px dashed #ddd;
                 border-radius: .25rem;
                padding: 0.15rem;
            }

            .field-active {
                box-shadow: 0 -1px 1px -1px rgba(0,0,0,.2), 0 1px 1px 0 rgba(0,0,0,.14), 0 1px 3px 0 rgba(0,0,0,.12);
                background: #e9ecef;
            }

            .form-field-element {
                margin-bottom: 0.5rem;
                padding: 0.5rem 0 0.5rem 0.5rem;
                -webkit-column-break-inside: avoid;
            }

            .form-field-element:hover {
                box-shadow: 0 -1px 1px -1px rgba(0,0,0,.2), 0 1px 1px 0 rgba(0,0,0,.14), 0 1px 3px 0 rgba(0,0,0,.12);
                background-color: #f9f9f9 !important;
            }

            .form-field-element:hover .card-form-label input, .form-field-element:hover .form-field-label input {
                border: 1px solid #eee;
                background: #fff !important;
            }

            input:-webkit-autofill,
            textarea:-webkit-autofill,
            select:-webkit-autofill {
                -webkit-box-shadow: 0 0 0px 1000px #fff inset !important;
                box-shadow: 0 0 0px 1000px #fff inset !important;
            }
            .tox-tinymce-aux { z-index: 10000 !important; }

            .v-select input::placeholder { opacity: 0.3 !important; }

            ::placeholder { opacity: 0.7 !important; }

            .colorpicker-bs-popover { z-index: 9999 !important; }

            *:focus-visible {
                outline: none !important;
            }

            .form-control { font-size: inherit !important; }

            .sidebar-wrapper { overflow-y: hidden; }

            .sidebar-wrapper:hover { overflow-y: auto !important; }

            #scroll-bar::-webkit-scrollbar-track
            {
                border-radius:10px;
            }

            #scroll-bar::-webkit-scrollbar
            {
                width: 6px;
            }

            #scroll-bar::-webkit-scrollbar-thumb
            {
                background-color: #7e7e7e;
                border-radius: 10px;
            }

            .sidebar-dark-black .nav-sidebar>.nav-item>.nav-link.active, .sidebar-light-black .nav-sidebar>.nav-item>.nav-link.active {
                background-color: #6c757d !important;
                color: #fff !important;
            }

            .font-1, .font-1 i { font-size: 1rem !important; }

            .main-header { border-bottom: unset !important;}

            ::-ms-reveal { display: none; }

            .row_disable {
                opacity: 0.5;
                pointer-events: none;
            }


            .settingiconblue {
                padding-top: 0.5rem;
                padding-bottom: 0.5rem;
            }

            .settingdivblue {
                width: 80px;
                height: 80px;
                margin: 0 auto;
                text-align: center;
                border: 5px solid #C4D8E4;
                border-radius: 100%;
                padding-top: 5px;
            }

            .fs_13 { font-size: 12px !important; font-weight: 500;word-break: break-word; }

            .settingdivblue span { margin-top: 3px; }

            .fw_400 { font-weight: 400; }

            .settingiconblue p{
                text-align: center;
                font-size: 16px;
                word-wrap: break-word;
                font-variant: small-caps;
                font-weight: 500;
                line-height: 30px;
            }

            .iti {
                width: 100%;
                --iti-path-flags-1x: url({{assetLink('image','mflags')}});
                --iti-path-flags-2x: url({{assetLink('image','mflags2x')}});
                --iti-path-globe-1x: url({{assetLink('image','mglobe')}});
                --iti-path-globe-2x: url({{assetLink('image','mglobe2x')}});
            }

            .pe-none { pointer-events: none !important; }

            .mb2 { margin-bottom: 2px; position: relative; left: 4px; }
            
            .cursor-default { cursor: default !important; background-color: #F2F2F2 !important; }

            .cache-field { max-width: 150px!important; }
        </style>

        <script type="text/javascript" src="{{asset('browser-detect.min.js')}}" async></script>

        <script src="{{assetLink('js','jquery-3-latest')}}" type="text/javascript" media="none" onload="this.media='all';">

        </script>

        <!-- for recaptcha session storage we are using this file-->
        @include('themes.default1.common.recaptcha')

        <script src="{{assetLink('js','polyfill')}}"></script>

        <script src="{{assetLink('js','select2')}}" type="text/javascript"></script>

        <!-- check if language is RTL, if yes, inject bootstrap-RTL -->

        <?php
            try {

                $authController = new App\Http\Controllers\Auth\AuthController();

                // auth user data
                $authInfo = $authController->getLoggedInClientInfo();

                $whiteLabel = isWhiteLabelEnabled();

                $tag = Config::get('app.tags');

                $version = $whiteLabel ? '' : Config::get('app.version');

            } catch(\Exception $e) {
                // ignore exception
            }
        ?>

        @yield('custom-css')

        <?php \Event::dispatch('customcss-event', [['fired_at' => 'adminlayout','request' => Request()]]); ?>

        @vite(['resources/assets/js/admin.js'])
    </head>

    <body id="layout_body" class="layout-fixed fixed-header sidebar-expand-lg sidebar-mini bg-body-tertiary app-loaded fs-7 {{$rtl_class}}">

        <script type="text/javascript">
            @php
                $user = Auth::user();
                $lang = App::getLocale();
            @endphp
            sessionStorage.setItem('full_name', '{{ $user->full_name }}');
            sessionStorage.setItem('logged_in_user_mail', '{{ $user->email }}');
            sessionStorage.setItem('profile_pic', '{!! $user->profile_pic !!}');
            sessionStorage.setItem('user_id', '{{ $user->id }}');
            sessionStorage.setItem('is_rtl', '{{ App::getLocale() == "ar" ? 1 : 0}}');
            sessionStorage.setItem('header_color', '{{ $portal->agent_header_color }}');
            sessionStorage.setItem('data_time_format', '{{ dateTimeFormat() }}');
            sessionStorage.setItem('date_format', '{{ dateFormat() }}');
            sessionStorage.setItem('timezone', '{{ agentTimeZone() }}');
            sessionStorage.setItem('user_role', '{{ $user->role }}');
            sessionStorage.setItem('userLoggedIn', '{{ $user }}');
            sessionStorage.setItem('app_version', '{{$tag}}');
            sessionStorage.setItem('app_language', '{{$lang}}');
        </script>

        <div id="app-admin">

            <admin-panel-renderer
                    :auth-info="{{ json_encode($authInfo) }}"
                    :company-info="{{ json_encode($company) }}"
                    :version="{{ json_encode($version) }}"
                    :portal-info="{{ json_encode($portal) }}"
                    :white-label="{{ json_encode($whiteLabel) }}"
                    :tag="{{ json_encode($tag) }}"
                    :dummy-install="{{ json_encode($dummy_installation) }}"
                    :is-mail-configured="{{ json_encode($is_mail_conigured) }}"
                    :is2fa-enforced="{{ json_encode($is2faEnforced) }}"
                    :is2fa-enabled="{{ json_encode($is2faActiveForUser) }}"
                    :is-updated-version ="{{ $isUpdatedVersion }}">

            </admin-panel-renderer>
        </div>
        @include('themes.default1.common.socket')

        <script type="text/javascript" src="{{ bundleLink('js/lang' ) }}"></script>

{{--        <script type="text/javascript" src="{{ bundleLink('js/common.js') }}"></script>--}}

{{--        <script type="text/javascript" src="{{ bundleLink('js/admin.js') }}"></script>--}}

        <script type="text/javascript" src="{{assetLink('js','popper')}}"></script>
        <!-- Bootstrap 4. JS -->
        <script src="{{assetLink('js','bootstrap-5')}}" type="text/javascript"></script>
        <!-- Slimscroll -->
        <script src="{{assetLink('js','nprogress')}}" type="text/javascript"></script>
        <!-- full calendar-->

        <script src="{{assetLink('js','adminlte-4')}}" type="text/javascript"></script>

{{--        <script src="{{assetLink('js','daterangepicker-min')}}" type="text/javascript" ></script>--}}

{{--        <script src="{{assetLink('js','moment-latest')}}"></script>--}}

{{--        <script src="{{assetLink('js','moment-timezone')}}"></script>--}}

{{--        <script type="text/javascript" src="{{assetLink('js','moment-timezone-with-data')}}"></script>--}}

        <script type="text/javascript" src="{{assetLink('js','tinymce')}}"></script>

        <script type="text/javascript" src="{{assetLink('js','bs-color-picker')}}"></script>

        <script>
            window.socketsEnabled = @json(socketsEnabled('reverb'));
        </script>
        <!-- <script src="{{assetLink('js','new-overlay')}}" type="text/javascript"></script> -->

{{-- This event is no more required as now the customJs scripts are being handled at the front-end --}}
{{-- <php \Event::dispatch('timeline-customjs', [['fired_at' => 'adminlayout','request' => Request()]]); ?> --}}

        <?php \Event::dispatch('admin-panel-scripts-dispatch') ?>

        @stack('scripts')
    </body>
</html>