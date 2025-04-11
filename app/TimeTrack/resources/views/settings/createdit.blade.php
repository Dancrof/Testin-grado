@extends('themes.default1.admin.layout.admin')

@section('Settings')
    active
@stop

@section('settings-bar')
    active
@stop

@section('worktime')
    class="active"
@stop

@section('HeadInclude')
@stop
<!-- header -->
@section('PageHeader')
    <h1>{{ Lang::get('timetrack::lang.worktime_type') }}</h1>
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

    <div id="app-timetrack">
        <worktime-type-create-edit></worktime-type-create-edit>
    </div>
@stop