@extends('themes.default1.admin.layout.admin')

@section('Settings')
active
@stop

@section('settings-bar')
active
@stop

@section('plugin')
class="active"
@stop

@section('custom-css')
  <link href="{{assetLink('css','dataTables-bootstrap')}}" rel="stylesheet" type="text/css" media="none" onload="this.media='all';">
@stop
<!-- header -->
@section('PageHeader')
<h1>{!! Lang::get('lang.login-log-setting') !!}</h1>
@stop
<!-- /header -->
<!-- breadcrumbs -->
@section('breadcrumbs')
<ol class="breadcrumb">
</ol>
@stop

@section('content')
    
    <div id="app-admin">
    
        <login-log-settings :days="{!! $days !!}"></login-log-settings>
    </div>
@stop