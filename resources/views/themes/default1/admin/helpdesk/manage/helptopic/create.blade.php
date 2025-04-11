@extends('themes.default1.admin.layout.admin')
<?php
        $title = App\Model\helpdesk\Settings\System::where('id','1')->value('name');
        $titleName = ($title) ? $title :"SUPPORT CENTER";
 ?>
@section('meta-tags')

<meta name="title" content="{!! Lang::get('lang.help_topics_create-page-title') !!} :: {!! strip_tags($titleName) !!} ">

<meta name="description" content="{!! Lang::get('lang.help_topics_create-page-description') !!}">

@stop

@section('Manage')
active
@stop

@section('manage-bar')
active
@stop

@section('help')
class="active"
@stop

@section('PageHeader')

<h1>{!! Lang::get('lang.help_topics') !!}</h1>
@stop

@section('breadcrumbs')
<ol class="breadcrumb">
</ol>
@stop
<!-- /breadcrumbs -->
<!-- content -->
@section('content')
    
    <div id="app-admin">
        
        <help-topic-create-edit></help-topic-create-edit>
    </div>
@stop
