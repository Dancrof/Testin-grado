@extends('themes.default1.admin.layout.admin')
@section('HeadInclude')
@stop
<!-- header -->
@section('PageHeader')
    <h1>{!! Lang::get('lang.third_party_apps') !!}</h1>
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
        <third-party-app-index></third-party-app-index>
    </div>
@endsection
