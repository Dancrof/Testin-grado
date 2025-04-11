<!DOCTYPE html>

<html>
  
  <?php
    $segment = "";
    $company = App\Model\helpdesk\Settings\Company::where('id', '=', '1')->first();
    $portal = App\Model\helpdesk\Theme\Portal::where('id', '=', 1)->first();
    $title = App\Model\helpdesk\Settings\System::where('id', '=', '1')->value('name');
    $is2faEnforced = App\Model\helpdesk\Settings\Security::where('id',1)->value('is_2fa_enforced');
    $is2faActiveForUser = \App\User::where('id',\Auth::user()->id)->value('is_2fa_enabled');
    $isUpdatedVersion = (Schema::hasColumn('settings_system', 'is_updated'))?
      App\Model\helpdesk\Settings\System::where('id',1)->value('is_updated'):0;
    $title_name = isset($title) ? $title : "SUPPORT CENTER";
    $rtl_class = "";

    if (str_contains($portal->agent_header_color, 'skin')) {
       
      $portal->agent_sidebar_color = str_replace("skin","sidebar-dark", $portal->agent_header_color); 
    } else {
        
      $portal->agent_sidebar_color = $portal->agent_sidebar_color;
    }

    $portal->agent_header_color = $portal->agent_header_color ? str_replace("skin","navbar-dark navbar", $portal->agent_header_color) : 'navbar-light';
    ?>

  <head>
  
    <meta charset="UTF-8">
  
    <base href="{{url('/panel/')}}">
  
    @yield('meta-tags')
    
    <title> {!! strip_tags($title_name) !!} </title>

    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    
    <meta name="_token" content="{!! csrf_token() !!}"/>
    
    <meta name="csrf-token" content="{{ csrf_token() }}">
    
    <meta name="api-base-url" content="{{ url('/') }}" />

    <link href="{{$portal->icon}}" rel="shortcut icon">

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,600,700&display=fallback">

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

{{--    <link rel="stylesheet" href="{{assetLink('css','pagination')}}">--}}

    <link rel="stylesheet" href="{{assetLink('css','glyphicon')}}">

      <link rel="stylesheet" href="{{assetLink('css','bs-color-picker')}}">

    <style>

        body {
            font-family: 'Source Sans Pro';
        }

        .btn-xs {
            padding: .125rem .25rem;
            font-size: .75rem;
            line-height: 1.5;
            border-radius: .15rem;
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

        .tox-tinymce-aux { z-index: 10000 !important; }

        .v-select input::placeholder { opacity: 0.3 !important; }

        ::placeholder { opacity: 0.7 !important; }

        .colorpicker-bs-popover { z-index: 9999 !important; }

        *:focus-visible {
            outline: none !important;
        }
        .modal-open {
            overflow: auto!important;
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

        ::-ms-reveal { display: none; }

        .rte-autocomplete{
            position: absolute;
            top: 0px;
            left: 0px;
            display: block;
            z-index: 1000;
            float: left;
            min-width: 160px;
            padding: 5px 0;
            margin: 2px 0 0;
            list-style: none;
            background-color: #fff;
            border: 1px solid #ccc;
            border: 1px solid rgba(0,0,0,0.2);
            -webkit-border-radius: 6px;
            -moz-border-radius: 6px;
            border-radius: 6px;
            -webkit-box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            -moz-box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            -webkit-background-clip: padding-box;
            -moz-background-clip: padding;
            background-clip: padding-box;
            font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
            font-size: 14px;
        }

        .rte-autocomplete:before {
            content: '';
            display: inline-block;
            border-left: 7px solid transparent;
            border-right: 7px solid transparent;
            border-bottom: 7px solid #ccc;
            border-bottom-color: rgba(0, 0, 0, 0.2);
            position: absolute;
            top: -7px;
            left: 9px;
        }

        .rte-autocomplete:after {
            content: '';
            display: inline-block;
            border-left: 6px solid transparent;
            border-right: 6px solid transparent;
            border-bottom: 6px solid white;
            position: absolute;
            top: -6px;
            left: 10px;
        }

        .rte-autocomplete > li.loading {
            background: url("http://www.ajaxload.info/cache/FF/FF/FF/00/00/00/1-0.gif") center no-repeat;
            height: 16px;
        }

        .rte-autocomplete > li > a {
            display: block;
            padding: 3px 20px;
            clear: both;
            font-weight: normal;
            line-height: 20px;
            color: #333;
            white-space: nowrap;
            text-decoration: none;
        }

        .rte-autocomplete >li > a:hover, .rte-autocomplete > li > a:focus, .rte-autocomplete:hover > a, .rte-autocomplete:focus > a {
            color: #fff;
            text-decoration: none;
            background-color: #0081c2;
            background-image: -moz-linear-gradient(top,#08c,#0077b3);
            background-image: -webkit-gradient(linear,0 0,0 100%,from(#08c),to(#0077b3));
            background-image: -webkit-linear-gradient(top,#08c,#0077b3);
            background-image: -o-linear-gradient(top,#08c,#0077b3);
            background-image: linear-gradient(to bottom,#08c,#0077b3);
            background-repeat: repeat-x;
            filter: progid:DXImageTransform.Microsoft;
        }

        .rte-autocomplete >.active > a, .rte-autocomplete > .active > a:hover, .rte-autocomplete > .active > a:focus {
            color: #fff;
            text-decoration: none;
            background-color: #0081c2;
            background-image: -moz-linear-gradient(top,#08c,#0077b3);
            background-image: -webkit-gradient(linear,0 0,0 100%,from(#08c),to(#0077b3));
            background-image: -webkit-linear-gradient(top,#08c,#0077b3);
            background-image: -o-linear-gradient(top,#08c,#0077b3);
            background-image: linear-gradient(to bottom,#08c,#0077b3);
            background-repeat: repeat-x;
            outline: 0;
            filter: progid:DXImageTransform.Microsof;
        }

        .iti {
            width: 100%;
            --iti-path-flags-1x: url({{assetLink('image','mflags')}});
            --iti-path-flags-2x: url({{assetLink('image','mflags2x')}});
            --iti-path-globe-1x: url({{assetLink('image','mglobe')}});
            --iti-path-globe-2x: url({{assetLink('image','mglobe2x')}});
        }

        .mb2 { margin-bottom: 2px; position: relative; left: 4px; }
    </style>

    <style>

      .main-header { border-bottom: unset !important;}
    </style>


    <script type="text/javascript" src="{{asset('browser-detect.min.js')}}" async></script>

    <script src="{{assetLink('js','jquery-3-latest')}}" type="text/javascript" media="none" onload="this.media='all';">
        
    </script>

    <!-- for recaptcha session storage we are using this file-->
    @include('themes.default1.common.recaptcha')

    <script src="{{assetLink('js','polyfill')}}"></script>

    <script src="{{assetLink('js','select2')}}" type="text/javascript"></script>

    <!-- check if lanuage is RTL, if yes, inject bootstrap-RTL -->

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

    <?php \Event::dispatch('customcss-event', [['fired_at' => 'agentlayout','request' => Request()]]); ?>

      @vite(['resources/assets/js/agent.js'])
  </head>
  
  <body id="layout_body" class="layout-fixed fixed-header bg-body-tertiary sidebar-expand-lg sidebar-mini app-loaded fs-7 {{$rtl_class}}">
  

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

    <div id="app-agent">

      <agent-panel-renderer :auth-info="{{ json_encode($authInfo) }}" :company-info="{{ json_encode($company) }}" 
        :version="{{ json_encode($version) }}" :portal-info="{{ json_encode($portal) }}" :white-label="{{ json_encode($whiteLabel) }}" 
        :tag="{{ json_encode($tag) }}" :dummy-install="{{ json_encode($dummy_installation) }}" 
        :is-mail-configured="{{ json_encode($is_mail_conigured) }}" :is2fa-enforced="{{ json_encode($is2faEnforced) }}"
        :is2fa-enabled="{{ json_encode($is2faActiveForUser) }}" :is-updated-version="{{ json_encode($isUpdatedVersion) }}">
          
      </agent-panel-renderer>
    </div>
    @include('themes.default1.common.socket')
    <script type="text/javascript" src="{{ bundleLink('js/lang' ) }}"></script>

{{--    <script type="text/javascript" src="{{ bundleLink('js/common.js') }}"></script>--}}

{{--    <script type="text/javascript" src="{{ bundleLink('js/agent.js') }}"></script>--}}
    
    <script type="text/javascript" src="{{assetLink('js','popper')}}"></script>
    <!-- Bootstrap 4. JS -->
    <script src="{{assetLink('js','bootstrap-5')}}" type="text/javascript"></script>
    <!-- Slimscroll -->
    <script src="{{assetLink('js','nprogress')}}" type="text/javascript"></script>
    <!-- full calendar-->
    <script src="{{assetLink('js','adminlte-4')}}" type="text/javascript"></script>
    
{{--    <script src="{{assetLink('js','daterangepicker-min')}}" type="text/javascript" ></script>--}}

{{--    <script src="{{assetLink('js','moment-latest')}}"></script>--}}

{{--    <script src="{{assetLink('js','moment-timezone')}}"></script>--}}
{{--    --}}
{{--    <script type="text/javascript" src="{{assetLink('js','moment-timezone-with-data')}}"></script>--}}

    <script type="text/javascript" src="{{assetLink('js','tinymce')}}"></script>

    <script type="text/javascript" src="{{assetLink('js','bs-color-picker')}}"></script>

    <script>
        window.socketsEnabled = @json(socketsEnabled('reverb'));
    </script>

    <!-- <script src="{{assetLink('js','new-overlay')}}" type="text/javascript"></script> -->

    <?php
      // plugins can add inject scripts or bundles by listening to this event in agent panel.
      Event::dispatch('agent-panel-scripts-dispatch');
    ?>

    <?php Event::dispatch('show.calendar.script', []); ?>

    <?php Event::dispatch('load-calendar-scripts', []); ?>
    {{-- This event is no more required as now the customJs scripts are being handled at the front-end --}}
    {{--    <php \Event::dispatch('timeline-customjs', [['fired_at' => 'agentlayout','request' => Request()]]); ?>--}}

    @stack('scripts')
  </body>
</html>