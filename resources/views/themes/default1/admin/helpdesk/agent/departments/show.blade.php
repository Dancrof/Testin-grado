@extends('themes.default1.admin.layout.admin')

@section('HeadInclude')
@stop
<!-- header -->
@section('PageHeader')

<h1>{!! Lang::get('lang.department_profile') !!} </h1>

@stop
<!-- /header -->
<!-- breadcrumbs -->
@section('breadcrumbs')

@stop
<!-- /breadcrumbs -->
<!-- content -->
@section('content')
	
	<div id="app-admin">
        
      <department-view></department-view>
   </div>
@stop