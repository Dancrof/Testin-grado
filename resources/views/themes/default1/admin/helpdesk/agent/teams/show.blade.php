@extends('themes.default1.admin.layout.admin')

@section('HeadInclude')
@stop
<!-- header -->
@section('PageHeader')

<h1>{!! Lang::get('lang.team_profile') !!} </h1>

@stop
<!-- /header -->
<!-- breadcrumbs -->
@section('breadcrumbs')

@stop
<!-- /breadcrumbs -->
<!-- content -->
@section('content')
    
    <div id="app-admin">
        
        <team-view></team-view>
    </div>
@stop
