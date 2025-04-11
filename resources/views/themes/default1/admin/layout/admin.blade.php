<!DOCTYPE html>
<html  ng-app="fbApp">
 <?php
    $company = App\Model\helpdesk\Settings\Company::where('id', '=', '1')->first();
    $portal = App\Model\helpdesk\Theme\Portal::where('id', '=', 1)->first();
    $title = App\Model\helpdesk\Settings\System::where('id', '=', '1')->value('name');
    $title_name = isset($title) ? $title : "SUPPORT CENTER";
    $navbar_class = $portal->admin_header_color ? str_replace("skin","navbar-dark navbar", $portal->admin_header_color) : 'navbar-light';

    if (str_contains($portal->admin_header_color, 'skin')) {
       
        $sidebar_class = str_replace("skin","sidebar-dark", $portal->admin_header_color); 
    } else {
        
        $sidebar_class = $portal->admin_sidebar_color;
    }
    
    $brand_class = $navbar_class != 'navbar-light' ? $navbar_class : '';
 ?>

 <?php
      try {
        
        $authController = new App\Http\Controllers\Auth\AuthController();

        // auth user data
        $authInfo = $authController->getLoggedInClientInfo();

        $whiteLabel = (\Event::dispatch('helpdesk.apply.whitelabel')) ? true : false;

        $tag = Config::get('app.tags');

        $version = Config::get('app.version');

      } catch(\Exception $e) {
        // ignore exception
      }
    ?>

        <style>

      .form-control { font-size: inherit !important; }

      .sidebar { overflow-y: hidden; }

      .sidebar:hover { overflow-y: auto !important; }

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
        background-color: #6c757d;
        color: #fff;
      }
    </style>
 <style type="text/css">


    .modal-backdrop.fade,.modal-backdrop.show {
    display: none;
    }

    .dropdown-item { backface-visibility: hidden; }
 
.breadcrumb-item+.breadcrumb-item::before {
 content: '>\00a0' !important; 
}

label {
    font-weight: 500 !important;
}

.card-title { font-weight: 500 !important; }

.navbar-light { background-color: #fff !important; }

.font-1, .font-1 i { font-size: 1rem !important; }

.form-control:focus { box-shadow: none !important; border-color: #ced4da !important; }


     body{
        padding-right: 0 !important;
        overflow-x: hidden;
    }

    div.dataTables_wrapper div.dataTables_processing { width: 0 !important; }

    #chumper{
      /*display: table-cell!important;*/
    }

 </style>
    <head>
        <meta charset="UTF-8">
           @yield('meta-tags')

         <title> @yield('title') {!! strip_tags($title_name) !!} </title>
        <meta name="api-base-url" content="{{ url('/') }}" />
        <meta name="csrf-token" content="{{ csrf_token() }}">
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <meta name="api-base-url" content="{{ url('/') }}" />
        <!-- faveo favicon -->
    
        <link href="{{$portal->icon}}" rel="shortcut icon">
       
        <!-- Bootstrap 3.4.1 -->
        <!-- <link rel="stylesheet" href="{{assetLink('css','bootstrap-latest')}}"> -->
        <!-- <link href="{{assetLink('css','bootstrap-5')}}" rel="stylesheet" type="text/css" /> -->

        <!-- Font Awesome Icons -->
        <!-- <link href="{{assetLink('css','font-awesome')}}" rel="stylesheet" type="text/css" /> -->
        <link href="{{assetLink('css','font-awesome-6')}}" rel="stylesheet" type="text/css" />
        <!-- Ionicons -->
        <link href="{{assetLink('css','ionicons')}}" rel="stylesheet" type="text/css" media="none" onload="this.media='all';">
        <!-- Theme style -->
        <link href="{{assetLink('css','adminlte-4')}}" rel="stylesheet" type="text/css" id="adminLTR" media="none" onload="this.media='all';"/>

        <link rel="stylesheet" href="{{assetLink('css','new-overlay')}}">

        <link rel="stylesheet" href="{{assetLink('css','pagination')}}">

        <link rel="stylesheet" href="{{assetLink('css','glyphicon')}}">

        <!-- Google Font: Source Sans Pro -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,600,700&display=fallback">

        <link  href="{{assetLink('css','editor')}}" rel="stylesheet" type="text/css" media="none" onload="this.media='all';">
        <script src="{{assetLink('js','jquery-3-latest')}}" type="text/javascript"></script>
        <script src="{{assetLink('js','polyfill')}}"></script>
        <style type="text/css">

.nav-sidebar .nav-header:not(:first-of-type) {
    padding-left : 0.5rem !important;
}

table.dataTable { width: -webkit-fill-available !important; }
button.close { margin-top: -4px !important; }
.modal-header h4 { margin-top: 0px !important; }

.modal-title {
  font-weight: 400 !important;
}

.custom-select-sm { font-size: 100% !important; margin: auto; }

    #lang_div{width: 290px;}

.user-panel img {
        height: 2.1rem !important;
    }
    #company_image{text-align: center !important;}
  
    .brand-image{float: none !important;margin-left: 0px !important;}

    .container-fluid { padding-bottom: 1px; }

.hide {
    display: none!important;
}

.select2-search__field {
    width: 100% !important;
}
.select2-container .select2-selection--multiple {
    height: 34px;
    border-radius: 0.25rem !important;
    border: 1px solid #d2d6de !important;
    overflow-y: auto;
}
.select2-container {
    display: block;
    width: 100%;
}
.loading {
    background-image: url(http://www.fotos-lienzo.es/media/aw_searchautocomplete/default/loading.gif);
    background-repeat: no-repeat;
}
.loading:after {
    content: "Sending...";
    text-align: right;
    padding-left: 25px;
}
.select2-selection__choice {
    color: #444 !important;
}
.list-group-item {
    margin-bottom: auto !important;
}

.color-picker-container { height: 36px !important; }

        </style>

        <script type="text/javascript" src="{{asset('browser-detect.min.js')}}"></script>

        @yield('HeadInclude')
        <!-- rtl brecket -->
<!--  <style type="text/css">
     *:after {
    content: "\200E‎";
}
 </style> -->
       <style>

@if(isPlugin('ServiceDesk'))
     .content-heading-anchor{
          margin-top: -44px;
     }
@endif
@if(Lang::getLocale() == "ar")
.datepicker {
   direction: rtl;
}
.datepicker.dropdown-menu {
   right: initial;
}
@endif


               input[type=number]::-webkit-inner-spin-button,
               input[type=number]::-webkit-outer-spin-button {
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
                margin: 0;
               }
            </style>
@yield('custom-css')

  </head>
  
    <body class="sidebar-mini layout-fixed layout-navbar-fixed text-sm" ng-controller="MainCtrl" style="display: none;">

        <div class="wrapper">

            @if($portal->admin_header_color)
            <nav class="main-header navbar navbar-expand {{$navbar_class}}">
            @else
            <nav class="main-header navbar navbar-expand navbar-light">
            @endif
              
                <ul class="navbar-nav">
                      
                    <li class="nav-item">
                    
                        <a class="nav-link" data-widget="pushmenu" href="#" role="button" onclick="togglePush()"><i class="fa fa-bars"></i></a>
                    </li>

                    <li class="nav-item d-none d-sm-inline-block" @yield('settings')>

                        <a href="{{url('panel/dashboard')}}" class="nav-link">{!! Lang::get('lang.agent_panel') !!}</a>
                    </li>
                </ul>
                  <ul class="navbar-nav ml-auto">
                    
                    <li class="nav-item d-none d-sm-inline-block">

                        <a href="{{url('admin')}}" class="nav-link" onclick="removeurl()">{!! Lang::get('lang.admin_panel') !!}</a>
                    </li>

                    <!-- START NOTIFICATION -->
                    @include('themes.default1.inapp-notification.notification')

                    <!-- END NOTIFICATION -->

                    <li class="nav-item dropdown">
                        <?php $src = Lang::getLocale().'.png'; ?>
                        <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="true">
                            <img src="{{assetLink('image','flag').'/'.$src}}" ></img>
                        </a>
                        <div class="dropdown-menu dropdown-menu-sm dropdown-menu-right p-0" id="lang_div">
                            @foreach($langs as $key => $value)
                                <?php
                                    $src = $key.".png";
                                ?>
                                
                                <a href="#" class="dropdown-item" id="{{$key}}" onclick="changeLang(this.id)">
                                    <img src="{{assetLink('image','flag').'/'.$src}}"></img>&nbsp;{{$value[0]}}&nbsp;
                                        @if(Lang::getLocale() == "ar")
                                        &rlm;
                                        @endif
                                        ({{$value[1]}})</a>
                                    @endforeach
                        </div>
                    </li>

                    <?php
                           $onerrorImage = assetLink('image','contacthead');
                            ?>

                    <!-- User Account: style can be found in dropdown.less -->
                    <li class="nav-item dropdown user-menu">
                        <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                            @if(Auth::user())
                            <img src="{{Auth::user()->profile_pic}}" onerror="this.src='{{$onerrorImage}}'" class="user-image img-circle elevation-2" alt="User Image"/>
                           <span class="d-none d-md-inline" title="{{Auth::user()->fullname}}">{{(ucfirst(str_limit(Auth::user()->fullname, 15)))}}</span>
                            @endif
                        </a>
                        <ul class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                            <!-- User image -->
                            <li class="user-header bg-secondary">
                                @if(Auth::user())
                                <img src="{{Auth::user()->profile_pic}}" onerror="this.src='{{$onerrorImage}}'" 
                                class="img-circle elevation-2" alt="User Image" />
                                <p title="{{Auth::user()->fullname}}" style="margin-top: 0px;">{{Auth::user()->fullname}}
                                    <small class="text-capitalize">{{Auth::user()->role}}</small>
                                </p>
                                @endif
                            </li>
                            <!-- Menu Footer-->
                            <li class="user-footer">
                                
                                <a href="{{url('panel/profile')}}" class="btn btn-primary btn-flat">{!! Lang::get('lang.profile') !!}</a>
                                
                                <a href="#" class="btn btn-danger btn-flat float-right" id="logout">{!! Lang::get('lang.sign_out') !!}</a>
                                
                            </li>

                        </ul>

                    </li>
                </ul>
            </nav>

            <!-- Left side column. contains the logo and sidebar -->
            <aside class="main-sidebar 123 elevation-4 {{$sidebar_class}}">
                
            <a href="{{$company->website}}" class="brand-link {{$brand_class}}" id="company_image">

                  <img src='{{$portal->logo}}' class="brand-image" alt="Company Log0" style="opacity: .8">
                </a>
               
               <div id="navigation-container">

                    <admin-navigation-bar :auth="{{ json_encode($authInfo) }}" from="admin"></admin-navigation-bar>
               </div>
            </aside>

            <!-- Right side column. Contains the navbar and content of the page -->
            <div class="content-wrapper">
                <!-- Content Header (Page header) -->
                <div class="content-header">
                  <div class="container-fluid">
                    <div class="row mb-2">
                      <div class="col-sm-4">
                        <h1 class="m-0 text-dark">@yield('PageHeader')</h1>
                      </div><!-- /.col -->
                      <div class="col-sm-8">

                        @if(Breadcrumbs::exists())
                        {!! Breadcrumbs::render() !!}
                        @endif
                      </div><!-- /.col -->
                    </div><!-- /.row -->
                  </div><!-- /.container-fluid -->
                </div>

                <!-- Main content -->
                <section class="content">
                    <div class="container-fluid">
                    @if($dummy_installation == 1 || $dummy_installation == '1')
                    <div class="alert alert-info alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                        <i class="icon fa  fa-exclamation-triangle"></i> {{Lang::get('lang.dummy_data_installation_message')}} <a href="{{route('clean-database')}}">{{Lang::get('lang.click')}}</a> {{Lang::get('lang.clear-dummy-data')}}
                    </div>
                    @else
                        @if (!$is_mail_conigured)
                            <div class="alert alert-warning">
                                <i class="fa fa-exclamation-triangle"></i>
                                @if (\Auth::user()->role == 'admin')
                                    {{Lang::get('lang.system-outgoing-incoming-mail-not-configured')}}&nbsp;<a href="{{URL::route('emails.create')}}">{{Lang::get('lang.confihure-the-mail-now')}}</a>
                                @else
                                    {{Lang::get('lang.system-mail-not-configured-agent-message')}}
                                @endif
                            </div>
                        @endif
                    @endif

                    {{--  this script can be used to store data which is common among all pages  --}}
                    <script type="text/javascript">
                        @php
                            $user = Auth::user();
                        @endphp
                        sessionStorage.setItem('full_name', '{{ $user->full_name }}');
                        sessionStorage.setItem('profile_pic', '{!! $user->profile_pic !!}');
                        sessionStorage.setItem('user_id', '{{ $user->id }}');
                        sessionStorage.setItem('is_rtl', '{{ App::getLocale() == "ar" ? 1 : 0}}');
                        sessionStorage.setItem('header_color', '{{ $portal->admin_header_color }}');
                        sessionStorage.setItem('data_time_format', '{{ dateTimeFormat() }}');
                        sessionStorage.setItem('date_format', '{{ dateFormat() }}');
                        sessionStorage.setItem('timezone', '{{ agentTimeZone() }}');
                        sessionStorage.setItem('user_role', '{{ $user->role }}');
                    </script>
                    <script src="{{bundleLink('js/lang')}}" type="text/javascript"></script>
                    <script src="{{bundleLink('js/common.js')}}" type="text/javascript"></script>
                    <script src="{{bundleLink('js/navigation.js')}}" type="text/javascript"></script>
                    <div class="custom-div-top" id="custom-div-top"></div>
                    @yield('content')
                    <div class="custom-div-bottom" id="custom-div-bottom"></div>
                </div>
                </section><!-- /.content -->
                <!-- /.content-wrapper -->
            </div>



            <footer class="main-footer">


                  @if(!isWhiteLabelEnabled())
                <!--  <div style="position: fixed;right:0;bottom:0">
                    <button data-bs-toggle="control-sidebar" onclick="openSlide()" style="margin-right:20px"  class="btn btn-primary helpsection">
                        {!! Lang::get('lang.have_a_question') !!}
                   &nbsp;&nbsp;<i class="fa fa-question-circle" aria-hidden="true"></i></button>
                </div> -->
             @endif

                <div class="float-right d-none d-sm-block">

                   @if(isWhiteLabelEnabled())
                    <span style="font-weight: 500">Version</span> {!! Config::get('app.tags') !!}

                    @else
                    <span style="font-weight: 500">Version</span> {!! Config::get('app.version') !!}

                    @endif



                </div>
                <?php
                $company = App\Model\helpdesk\Settings\Company::where('id', '=', '1')->first();
                ?>
                <span>{!! Lang::get('lang.copyright') !!} &copy; {!! date('Y') !!}  

                    @if($company->website)
                    
                    <a href="{!! $company->website !!}" target="_blank">{!! $company->company_name !!}</a>.

                    @else
                     <a class="text-primary">{!! $company->company_name !!}</a>.

                    @endif

                </span>

               @if(isWhiteLabelEnabled())
                   {!! Lang::get('lang.all_rights_reserved') !!}
                @else
                 {!! Lang::get('lang.all_rights_reserved') !!}. {!! Lang::get('lang.powered_by') !!} <a href="https://www.faveohelpdesk.com/" target="_blank">Faveo</a>

                @endif



                 <!-- {!! Lang::get('lang.powered_by') !!} <a href="http://www.faveohelpdesk.com/" target="_blank">Faveo</a> -->
            </footer>

            @if(!isWhiteLabelEnabled())
            <div id="help-widget">
                <help-widget :from="'admin'"></help-widget>
            </div>

            <script src="{{bundleLink('js/helpwidget.js')}}" type="text/javascript"></script>
            @endif
        
        </div><!-- ./wrapper -->
        <script  type="text/javascript">
            localStorage.setItem('PATH', '{{asset("/")}}');
            localStorage.setItem('CSRF', '{{ csrf_token() }}');
            localStorage.setItem('GUEST', '{{Auth::guest()}}');
            localStorage.setItem('LANGUAGE', '{{Lang::getLocale()}}');
            localStorage.setItem('PLUGIN', '{{isPlugin()}}');
        </script>

        <script type="text/javascript" src="{{assetLink('js','popper')}}"></script>
        <!-- Bootstrap 3.3.2 JS -->
        <script src="{{assetLink('js','bootstrap-5')}}" type="text/javascript"></script>
        <!-- <script src="{{assetLink('js','bootstrap-latest')}}" type="text/javascript"></script> -->

        <!-- AdminLTE App -->
        <script src="{{assetLink('js','adminlte-4')}}" type="text/javascript"></script>
        <!-- iCheck -->

        <!-- select2 -->
        <script src="{{assetLink('js','nprogress')}}" type="text/javascript"></script>



@if(isPlugin('ServiceDesk'))
<script>
    $(function(){
        $('.content-heading-anchor').next().removeClass('content');
    })
</script>
@endif
@if (trim($__env->yieldContent('no-toolbar')))
    <h1>@yield('no-toolbar')</h1>
@else

@endif
<script type="text/javascript">
    $.ajaxSetup({
        headers: { 'X-CSRF-Token' : $('meta[name=csrf-token]').attr('content') }
    });
    $('#Form').submit(function (e) {
        if ($('#mobile').parent().hasClass('has-error')) {
            var alert_msg = "{{Lang::get('lang.please-check-mobile-number')}}";
            alert(alert_msg);
            e.preventDefault();
        } else {
            var $this = $('#submit');
            $this.button('loading');
            $('#Edit').modal('show');
        }

    });

    // logout click function
    $("#logout").click(function(){
    $.ajax({
        /* the route pointing to the post function */
        url: '{{url("auth/logout")}}',
        type: 'POST',
        data: { "_token": "{{ csrf_token() }}"},
        /* remind that 'data' is the response of the AjaxController */
        success: function (response) { 
             window.location.href = response.data;
             }
        }); 
    });
</script>

<script type="text/javascript">
$(document).ready(function(){
  $('[data-bs-toggle="tooltip"]').tooltip();
});

if(JSON.parse(localStorage.getItem('pushmenu')) == true) {
    
    document.getElementById('admin_body').classList.add('sidebar-collapse')
}

function togglePush() {

    let pushmenu = JSON.parse(localStorage.getItem("pushmenu")) == true ? false : true;

    localStorage.setItem("pushmenu", pushmenu);
}
</script>
<script src="{{bundleLink('js/admin.js')}}" type="text/javascript"></script>
<script src="{{assetLink('js','angular')}}" type="text/javascript"></script>
<script src="{{assetLink('js','angular-moment')}}" type="text/javascript"></script>
<script src="{{assetLink('js','bsSwitch')}}" type="text/javascript"></script>
<script src="{{assetLink('js','angular-desktop-notification')}}" type="text/javascript"></script>

<script src="{{assetLink('js','ui-bootstrap-tpls')}}"></script>
<script src="{{assetLink('js','main')}}"></script>
<script src="{{assetLink('js','handleCtrl')}}"></script>
<script src="{{assetLink('js','nodeCtrl')}}"></script>
<script src="{{assetLink('js','nodesCtrl')}}"></script>

<script src="{{assetLink('js','treeCtrl')}}"></script>
<script src="{{assetLink('js','uiTree')}}"></script>
<script src="{{assetLink('js','uiTreeHandle')}}"></script>
<script src="{{assetLink('js','uiTreeNode')}}"></script>

<script src="{{assetLink('js','uiTreeNodes')}}"></script>
<script src="{{assetLink('js','helper')}}"></script>
<script src="{{assetLink('js','ng-flow-standalone')}}" ></script>
<script src="{{assetLink('js','fusty-flow')}}" ></script>

<script src="{{assetLink('js','fusty-flow-factory')}}" ></script>
<script src="{{assetLink('js','ng-file-upload')}}"></script>
<script src="{{assetLink('js','ng-file-upload-shim')}}"></script>
<script src="{{assetLink('js','tw-currency-select')}}"></script>
<script src="{{assetLink('js','angular-admin-script')}}" type="text/javascript"></script>
<script src="{{assetLink('js','new-overlay')}}" type="text/javascript"></script>
@yield('FooterInclude')
@stack('scripts')
    <style>
        /* This piece of code will be rendered at bottom
           so whenever someone tries to hide powered by Faveo from custom css
           then it will restrict it from hiding
        */
        footer.main-footer > a:last-child {
            display: contents;
            visibility: visible;
        }
    </style>
</body>
</html>
