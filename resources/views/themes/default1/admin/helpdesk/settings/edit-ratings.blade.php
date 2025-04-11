@extends('themes.default1.admin.layout.admin')
<?php
        $title = App\Model\helpdesk\Settings\System::where('id','1')->value('name');
        $titleName = ($title) ? $title :"SUPPORT CENTER";
 ?>
@section('meta-tags')


<meta name="title" content="{!! Lang::get('lang.ratings_edit-page-title') !!} :: {!! strip_tags($titleName) !!} ">

<meta name="description" content="{!! Lang::get('lang.ratings_edit-page-description') !!}">


@stop

@section('Tickets')
active
@stop

@section('ratings')
class="active"
@stop

@section('HeadInclude')
@stop

<!-- header -->
@section('PageHeader')
<h1>{!! Lang::get('lang.rating_update') !!}</h1>
@stop

<!-- content -->
@section('content')
    <div id="app-admin">
        <rating-create-edit :edit="true" ></rating-create-edit>
    </div>
@stop