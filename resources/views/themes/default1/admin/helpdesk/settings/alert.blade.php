@extends('themes.default1.admin.layout.admin')
<?php
$title = App\Model\helpdesk\Settings\System::where('id','1')->value('name');
$titleName = ($title) ? $title :"SUPPORT CENTER";
?>
@section('meta-tags')


    <meta name="title" content="{!! Lang::get('lang.alert_notices_setitngs-page-title') !!} :: {!! strip_tags($titleName) !!} ">

    <meta name="description" content="{!! Lang::get('lang.alert_notices_setitngs-page-description') !!}">


@stop

@section('Tickets')
    active
@stop

@section('tickets-bar')
    active
@stop

@section('alert')
    class="active"
@stop

<!-- header -->
@section('PageHeader')
    <h1>{{Lang::get('lang.settings')}}</h1>
@stop
<!-- /header -->
<!-- breadcrumbs -->
@section('breadcrumbs')
    <ol class="breadcrumb">

    </ol>
@stop
<!-- /breadcrumbs -->
<!-- content -->
@section('content')
    
    <div id="app-admin">

        <alert-and-notices></alert-and-notices>
    </div>
@stop
