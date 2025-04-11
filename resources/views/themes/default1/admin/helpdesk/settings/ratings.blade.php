@extends('themes.default1.admin.layout.admin')
<?php
        $title = App\Model\helpdesk\Settings\System::where('id','1')->value('name');
        $titleName = ($title) ? $title :"SUPPORT CENTER";
 ?>
@section('meta-tags')


<meta name="title" content="{!! Lang::get('lang.ratings_lists-page-title') !!} :: {!! strip_tags($titleName) !!} ">

<meta name="description" content="{!! Lang::get('lang.ratings_lists-page-description') !!}">


@stop

@section('custom-css')
 <link href="{{assetLink('css','dataTables-bootstrap')}}" rel="stylesheet" type="text/css" media="none" onload="this.media='all';">
@stop

@section('Tickets')
active
@stop

@section('ratings')
class="active"
@stop

@section('PageHeader')
<h1>{!! Lang::get('lang.ratings') !!}</h1>
@stop

@section('header')
@stop

@section('content')

    <div id="app-admin">
        <rating-index></rating-index>
    </div>

@stop