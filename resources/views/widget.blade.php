<!DOCTYPE html>

<html>

   <head>

      <meta charset="UTF-8">

      <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>

      <meta name="_token" content="{!! csrf_token() !!}"/>

      <meta name="csrf-token" content="{{ csrf_token() }}">

      <meta name="api-base-url" content="{{ url('/v3/') }}" />

      <link href='https://fonts.googleapis.com/css?family=Lato&subset=latin,latin-ext' rel='stylesheet' type='text/css'>

      <link href='https://fonts.googleapis.com/css?family=Rubik&subset=latin,latin-ext' rel='stylesheet' type='text/css'>

      <link href="{{assetLink('css','bootstrap-5')}}" rel="stylesheet" type="text/css" />

      <link href="{{assetLink('css','font-awesome-6')}}" rel="stylesheet" type="text/css" />

      <link href="{{assetLink('css','intlTelInput')}}" rel="stylesheet" type="text/css"/>

      <style>

         *:focus-visible { outline: none !important; }

         .text-small { font-size: 14px; }

         a:hover { text-decoration: none !important; }

         .center-of-page { left: 12% !important; top: 40% !important; }

         .btn-default { background-color: #f8f9fa; border-color: #ddd; color: #444; }

         .tox-notification--warning { display: none !important; }

         body {
            overflow: hidden;
         }

         body,html,#chat-widget {
            width: 100%;
            height: 100%;
         }
         body {
            font-family: "Work Sans",sans-serif;
            font-feature-settings: "liga","kern";
            text-rendering: optimizeLegibility;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            background: #b8c4da;
         }

         body::-webkit-scrollbar-track
         {
            background-color: #f1f1f1;
            border-radius:10px;
         }

         body::-webkit-scrollbar
         {
            width: 6px;
            background-color: #f1f1f1;
         }

         body::-webkit-scrollbar-thumb
         {
            background-color: #c1c1c1;
            border-radius: 10px;
         }

         .phpdebugbar {
            display: none !important;
         }

         #chat-widget .c-form-radio, #chat-widget .c-form-checkbox { padding-left: 1.9rem !important; }

         /*#chat-widget .col-md-6 {*/
         /*   -ms-flex: 0 0 50%;*/
         /*   flex: 0 0 50%;*/
         /*   max-width: 50%;*/
         /*}*/

         #chat-widget .col-sm-8 {
            -ms-flex: 0 0 66.666667%;
            flex: 0 0 66.666667%;
            max-width: 66.666667%;
         }

         #chat-widget .col-sm-4 {
            -ms-flex: 0 0 33.333333%;
            flex: 0 0 33.333333%;
            max-width: 33.333333%;
         }

         .selected-flag .selected-dial-code { padding-left: 35px !important; }

         .selected-flag .iti-flag { margin-left: 8px !important; }

      </style>

      @vite(['resources/assets/js/chatWidget.js'])

   </head>

   <body>

      <?php

         try {

            $whiteLabel = count((\Event::dispatch('helpdesk.apply.whitelabel')))>1 ? true : false;

         } catch(\Exception $e) {
            // ignore exception
         }
      ?>

      <div id="chat-widget">

         <chat-widget :white-label="{{ json_encode($whiteLabel) }}"></chat-widget>
      </div>

      <script type="text/javascript" src="{{assetLink('js','tinymce')}}"></script>

      <script src="{{bundleLink('js/lang')}}" type="text/javascript"></script>

   </body>
</html>