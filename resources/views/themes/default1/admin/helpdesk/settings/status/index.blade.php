@extends('themes.default1.admin.layout.admin')

<?php
        $title = App\Model\helpdesk\Settings\System::where('id', '=', '1')->first();
        if (($title->name)) {
            $title_name = $title->name;
        } else {
            $title_name = "SUPPORT CENTER";
        }
        
        ?>
@section('meta-tags')


<meta name="title" content="{!! Lang::get('lang.status_lists-page-title') !!} :: {!! strip_tags($title_name) !!} ">

<meta name="description" content="{!! Lang::get('lang.status_lists-page-description') !!}">


@stop

@section('Tickets')
active
@stop

@section('status')
class="active"
@stop

@section('PageHeader')
<h1>{!! Lang::get('lang.status') !!}</h1>
@stop

@section('content')
	
	<div id="app-admin">
        
      <status-index></status-index>
   </div>
@stop