@extends('themes.default1.agent.layout.agent')
@extends('themes.default1.agent.layout.sidebar')

@section('meta-tags')
<meta name="title" content="{!! strip_tags($titleName) !!} ">
<meta name="description" content="">
@stop


@section('custom-css')
<link href="{{assetLink('css','dataTables-bootstrap')}}" rel="stylesheet"  type="text/css"/>
@stop

@section('article')
active
@stop

@section('all-article')
class="active"
@stop

@section('PageHeader')
<h1>{{trans('lang.article_version_lists')}}</h1>
@stop
<style>
    table { table-layout:fixed; word-break:break-all; word-wrap:break-word; }
</style>


@section('content')
    
    <div id="app-agent">
        
    </div>

    <script src="{{asset('js/agent.js')}}" type="text/javascript"></script>

@stop
