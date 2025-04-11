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
<meta name="title" content="{!! Lang::get('lang.security_settings-page-title') !!} :: {!! strip_tags($title_name) !!} ">
<meta name="description" content="{!! Lang::get('lang.security_settings-page-description') !!}">

@stop

@section('Settings')
active
@stop

@section('security')
class="active"
@stop

@section('PageHeader')
<h1>{!! Lang::get('lang.settings') !!}</h1>
@stop

@section('header')
@stop

@section('content')

    <div id="app-admin">
        
        <security-settings></security-settings>
    </div>
@stop
