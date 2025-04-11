@extends('themes.default1.admin.layout.admin')
<?php
        $title = App\Model\helpdesk\Settings\System::where('id','1')->value('name');
        $titleName = ($title) ? $title :"SUPPORT CENTER";
 ?>
@section('meta-tags')
<meta name="title" content="{!! Lang::get('lang.tags_lists-page-title') !!} :: {!! strip_tags($titleName) !!} ">
<meta name="description" content="{!! Lang::get('lang.tags_lists-page-description') !!}">
@stop

@section('Tickets')
active
@stop

@section('manage-bar')
active
@stop

@section('tags')
class="active"
@stop

<!-- header -->
@section('PageHeader')
<h1>{{trans('lang.tags')}}</h1>
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
        <tags-index></tags-index>
    </div>
@stop
