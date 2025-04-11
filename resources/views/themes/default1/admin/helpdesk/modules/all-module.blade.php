@extends('themes.default1.admin.layout.admin')

@section('Plugins')
active
@stop

@section('settings-bar')
active
@stop

@section('modules')
active
@stop

<!-- header -->
@section('PageHeader')
<h1>{!! Lang::get('lang.modules') !!}</h1>
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
    
    <modules-index></modules-index>
  </div>
@stop