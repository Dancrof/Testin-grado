@extends('themes.default1.admin.layout.admin')

@section('meta-tags')
<meta name="title" content="{!! trans('lang.client_filter-page-title') !!} :: {!! strip_tags($titleName) !!} ">
<meta name="description" content="">
@stop


@section('client-filter')
active
@stop

@section('client-filter-bar')
active
@stop

@section('client-filter')
class="active"
@stop

@section('HeadInclude')
@stop
<!-- header -->
@section('PageHeader')
<h1>{{trans('lang.client-filter')}}</h1>
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
		
		<client-filter-settings></client-filter-settings>
	</div>
@stop
