@extends('themes.default1.admin.layout.admin')

@section('Manage')
active
@endsection

<!-- header -->
@section('PageHeader')
<h1>
    {!! trans('report::lang.daily-report-settings') !!}
</h1>
@endsection
<!-- breadcrumbs -->
@section('breadcrumbs')
<ol class="breadcrumb">
</ol>
@endsection
<!-- /breadcrumbs -->

@section('content')
<div id="faveo-report">
    <daily-report-settings></daily-report-settings>
</div>
<script src="{{bundleLink('js/systemReport.js')}}" type="text/javascript"></script>
@stop
