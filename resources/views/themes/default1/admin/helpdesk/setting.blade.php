@extends('themes.default1.admin.layout.admin')
@section('HeadInclude')
@stop
<!-- header -->
@section('PageHeader')
<h1>{!! Lang::get('lang.admin_panel') !!}</h1>
@stop
<!-- /header -->
<!-- breadcrumbs -->
@section('breadcrumbs')
@stop
<!-- /breadcrumbs -->
<!-- content -->

<style type="text/css">
    
    .content-wrapper { height: auto !important; }

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

     .settingdivblue span { margin-top: 3px; }

     .fw_600 { font-weight: 600; }
    .settingiconblue p{
        text-align: center;
        font-size: 16px;
        word-wrap: break-word;
        font-variant: small-caps;
        font-weight: 500;
        line-height: 30px;
    }
</style>
@section('content')
    
    <div id="app-admin">
        
        <admin-settings></admin-settings>
    </div>
@stop
