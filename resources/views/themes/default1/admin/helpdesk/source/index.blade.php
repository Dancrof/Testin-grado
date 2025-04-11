@extends('themes.default1.admin.layout.admin')

@section('Tickets')
active
@stop

@section('manage-bar')
active
@stop

@section('source')
class="active"
@stop

<!-- header -->
@section('PageHeader')
<h1>{{trans('lang.source')}}</h1>
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
        <source-index></source-index>
    </div>
@stop
