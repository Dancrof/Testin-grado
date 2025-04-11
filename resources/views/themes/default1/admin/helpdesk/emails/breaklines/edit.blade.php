@extends('themes.default1.admin.layout.admin')

@section('meta-tags')
<meta name="title" content="{!! trans('lang.breaklines_edit-page-title') !!} :: {!! strip_tags($titleName) !!} ">
<meta name="description" content="">
<meta name="csrf-token" content="{{ csrf_token() }}">
@stop

@section('breaklines')
active
@stop

@section('breaklines-bar')
active
@stop

@section('breaklines')
class="active"
@stop

@section('HeadInclude')
@stop
<!-- header -->
@section('PageHeader')
<h1>{{trans('lang.edit_breakline')}}</h1>
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
<create-upate-breakline></create-upate-breakline>
</div>
@stop
