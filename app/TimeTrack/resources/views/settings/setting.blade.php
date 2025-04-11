@extends('themes.default1.admin.layout.admin')


@section('time-track')
class="active"
@endsection

<!-- header -->
@section('PageHeader')
<h1>
    {!! trans('lang.time-track') !!}
</h1>
@endsection
<!-- breadcrumbs -->
@section('breadcrumbs')
<ol class="breadcrumb">
</ol>
@endsection
<!-- /breadcrumbs -->
@section('content')

<div id="app-timetrack">
    <timetrack-settings></timetrack-settings>
</div>
@endsection
