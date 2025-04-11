@extends('themes.default1.admin.layout.admin')
<?php
        $title = App\Model\helpdesk\Settings\System::where('id', '=', '1')->first();
        if (($title->name)) {
            $title_name = $title->name;
        } else {
            $title_name = "SUPPORT CENTER";
        }
        
        ?>
@section('meta-tags')
<meta name="title" content="{!! Lang::get('lang.social-login-settings-page-title') !!} :: {!! strip_tags($title_name) !!} ">
<meta name="description" content="{!! Lang::get('lang.social-login-settings-page-description') !!}">

@stop
@section('custom-css')
<link href="{{assetLink('css','faveo-css')}}" rel="stylesheet" type="text/css" />
@stop
@section('Settings')
active
@stop

@section('settings-bar')
active
@stop

@section('social-login')
class="active"
@stop

@section('HeadInclude')
@stop
<!-- header -->
@section('PageHeader')
<h3>{!! Lang::get('lang.social-login') !!}</h3>
@stop
<!-- /header -->
<!-- breadcrumbs -->
@section('breadcrumbs')
<ol class="breadcrumb">

</ol>
@stop
@section('content')
    <div id="app-admin">
        <social-login-settings></social-login-settings>
    </div>
@stop
