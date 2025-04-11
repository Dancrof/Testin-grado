@extends('themes.default1.admin.layout.admin')
<?php
        $title = App\Model\helpdesk\Settings\System::where('id','1')->value('name');
        $titleName = ($title) ? $title :"SUPPORT CENTER";
 ?>
@section('meta-tags')


<meta name="title" content="{!! Lang::get('lang.labels_edit-page-title') !!} :: {!! strip_tags($titleName) !!} ">
<meta name="description" content="{!! Lang::get('lang.labels_edit-page-description') !!}">
@stop
@section('Tickets')
active
@stop

@section('manage-bar')
active
@stop

@section('labels')
class="active"
@stop

@section('HeadInclude')
<!--select 2-->
<link href="{{assetLink('css','select2')}}" rel="stylesheet" media="none" onload="this.media='all';"/>
<link href="{{assetLink('css','bootstrap-colorpicker')}}" rel="stylesheet" type="text/css"  media="none" onload="this.media='all';"/>
@stop
<!-- header -->
@section('PageHeader')
<h1>{{Lang::get('lang.labels')}}</h1>
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
    
        <label-create-edit></label-create-edit>
    </div>
@stop
