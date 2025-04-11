@extends('themes.default1.admin.layout.admin')

@section('Tickets')
active
@stop

@section('tickets-bar')
active
@stop

@section('location')
class="active"
@stop

@section('custom-css')
     <link href="{{assetLink('css','dataTables-bootstrap')}}" rel="stylesheet" type="text/css" media="none" onload="this.media='all';">
@stop
<!-- header -->
@section('PageHeader')
<h1>{!! Lang::get('lang.location') !!}</h1>
@stop
<!-- /header -->
<!-- breadcrumbs -->
@section('breadcrumbs')
<ol class="breadcrumb">
</ol>
@stop

<!-- content -->
@section('content')
    
    <div id="app-location">
        
        <locations-index></locations-index>
    </div>
    
    <script type="text/javascript" src="{{ bundleLink('js/systemLocation.js') }}"></script>
@stop
