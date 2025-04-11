@extends('themes.default1.admin.layout.admin')
<?php
        $title = App\Model\helpdesk\Settings\System::where('id','1')->value('name');
        $titleName = ($title) ? $title :"SUPPORT CENTER";
 ?>
@section('meta-tags')

<meta name="title" content="{!! Lang::get('lang.queue_edit-page-title') !!} :: {!! strip_tags($titleName) !!} ">

<meta name="description" content="{!! Lang::get('lang.queue_edit-page-description') !!}">

@stop

@section('Emails')
active
@stop

@section('emails-bar')
active
@stop

@section('queue')
class="active"
@stop

@section('HeadInclude')
@stop

@section('PageHeader')
<h1>{{$queue->name}}</h1>
@stop

@section('breadcrumbs')
<ol class="breadcrumb">
</ol>
@stop

@section('content')

    <div id="app-admin">
        
        <queue-settings></queue-settings>
    </div>
@stop