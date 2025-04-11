@extends('themes.default1.admin.layout.admin')

@section('Tickets')
active
@stop

@section('tickets-bar')
active
@stop

@section('bill')
class="active"
@stop
<!-- header -->
@section('PageHeader')
<h1>{!! trans('lang.bill') !!}</h1>
@stop
<!-- breadcrumbs -->
@section('breadcrumbs')
<ol class="breadcrumb">
</ol>
@stop
<!-- /breadcrumbs -->
@section('content')
   
   <div id="app-billing">

      <bill-options></bill-options>
   </div>

   <script type="text/javascript" src="{{ bundleLink('js/systemBilling.js') }}"></script>
@stop