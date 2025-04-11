@extends('themes.default1.installer.layout.installer')

@section('license')
    done
@stop

@section('environment')
    done
@stop

@section('searchDriver')
    active
@stop

@section('content')
    <div ng-app="myApp">
        <h1 style="text-align: center;">Search Driver Setup</h1>
        <p class="wc-setup-content">Enter your connection details.</p>

        @if(\Illuminate\Support\Facades\Session::has('fails'))
            <div class="wc-setup-content">
                <div class="woocommerce-message woocommerce-tracker">
                    <div class="fail">
                        <span id="fail">{!! \Illuminate\Support\Facades\Session::get('fails') !!}!</span><br/><br/>
                    </div>
                </div>
            </div>
        @endif

        {!! html()->form('POST', url('/search-config'))->id('databaseform')->open() !!}
        <table ng-controller="MainController">
            <tr>
                <td>
                    <label for="box10">Driver</label>
                </td>
                <td>
                    <select class="form-control" name="driver" id="driver_type" style="width:280px;height:26px;font-size: 15px">
                        <option value="database" @if(\Cache::get('search-driver') == 'database') selected @endif>Database</option>
                        <option value="meilisearch" @if(\Cache::get('search-driver') == 'meilisearch') selected @endif>Meilisearch</option>
                        <option value="algolia" @if(\Cache::get('search-driver') == 'algolia') selected @endif>Algolia</option>
                    </select>
                </td>
                <td>
                    <button id="driver_tooltip_database" type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="{{trans('lang.database')}}" data-content="{{trans('lang.database_search_description')}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fas fa-question-circle" style="padding: 0px;"></i>
                    <button id="driver_tooltip_meilisearch" type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="{{trans('lang.meilisearch')}}" data-content="{{trans('lang.meilisearch_search_description')}}" style="padding: 0px;border: 0px; border-radius: 5px;display: none"><i class="fas fa-question-circle" style="padding: 0px;"></i>
                    <button id="driver_tooltip_algolia" type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="{{trans('lang.algolia')}}" data-content="{{trans('lang.algolia_search_description')}}" style="padding: 0px;border: 0px; border-radius: 5px;display: none"><i class="fas fa-question-circle" style="padding: 0px;"></i>
                    </button>
                </td>
            </tr>
            <tr id="m_host" style="display: none">
                <td>
                    <label for="box11">Host<span style="color: red;font-size:12px;">*</span></label>
                </td>
                <td>
                    {!! html()->text('host', 'http://localhost:7700') !!}
                </td>
            </tr>
            <tr id="m_master_key" style="display: none">
                <td>
                    <label for="box12">Master Key<span style="color: red;font-size:12px;">*</span></label>
                </td>
                <td id="read_host_input">
                    {!! html()->text('master_key', '') !!}
                </td>
            </tr>
            <tr id="a_id" style="display: none">
                <td>
                    <label for="box11">App Id<span style="color: red;font-size:12px;">*</span></label>
                </td>
                <td>
                    {!! html()->text('a_id', '') !!}
                </td>
            </tr>
            <tr id="a_secret_key" style="display: none">
                <td>
                    <label for="box12">App Secret Key<span style="color: red;font-size:12px;">*</span></label>
                </td>
                <td id="read_host_input">
                    {!! html()->text('a_secret_key', '') !!}
                </td>
            </tr>
        </table>

        <p class="setup-actions step">
            <input type="submit" id="submitme" class="button-primary button button-large button-next" value="Continue">
            <a href="{!! route('license-agreement') !!}" class="button button-large button-next" style="float: left">Previous</a>
        </p>
        <br>
        {!! html()->form()->close() !!}
    </div>
    <script src="{{assetLink('js','jquery-3-latest')}}"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.8.2/angular.min.js"></script>
    <script src="{{assetLink('js','angular2')}}" type="text/javascript"></script>
    <script type="text/javascript">
        function CheckPortForInput(e) {
            var code = e.which || e.keyCode;
            if (e.ctrlKey != true){
                if((code >=48 && code<= 57) || (code >=96 && code<= 105) || code == 8 || code == 46 || e.keyCode == 9 || e.keyCode == 13) {
                    return true;
                }
            } else {
                if((code == 65 || code == 97) || (code == 88 || code == 120) || (code == 86 || code == 118)) {
                    return true;
                }
            }
            return false;
        }
    </script>
    <script type="text/javascript">

        var type = $('#driver_type').val();

        if(type == 'database') {
            $('#m_host').hide();
            $('#m_master_key').hide();
            $('#a_id').hide();
            $('#a_secret_key').hide();
            $('#driver_tooltip_database').show();
            $('#driver_tooltip_meilisearch').hide();
            $('#driver_tooltip_algolia').hide();
        } else if(type == 'algolia') {
            $('#m_host').hide();
            $('#m_master_key').hide();
            $('#a_id').show();
            $('#a_secret_key').show();
            $('#driver_tooltip_database').hide();
            $('#driver_tooltip_meilisearch').hide();
            $('#driver_tooltip_algolia').show();
        } else if(type == 'meilisearch'){
            $('#m_host').show();
            $('#m_master_key').show();
            $('#a_id').hide();
            $('#a_secret_key').hide();
            $('#driver_tooltip_database').hide();
            $('#driver_tooltip_meilisearch').show();
            $('#driver_tooltip_algolia').hide();
        }

        @if($errors->has('host'))
        addErrorClass('host');
        @endif
        @if($errors->has('host'))
        addErrorClass('host');
        @endif
        @if($errors->has('databasename'))
        addErrorClass('databasename');
        @endif
        @if($errors->has('username'))
        addErrorClass('username');
        @endif
        @if($errors->has('password'))
        addErrorClass('password');
        @endif

        $('#databaseform').on('submit', function(e){
            var driver = $('#driver_type').val();
            var fields = (driver == 'meilisearch') ? ['host', 'master_key'] : ['a_id', 'a_secret_key'];
            $("#databaseform input[type=text]").each(function(){
                if($(this).attr('name') == fields[0] || $(this).attr('name') == fields[1]){
                    if ($(this).val() == '') {
                        $(this).css('border-color','red')
                        $(this).css('border-width','1px');
                        empty_field = 1;
                    } else {
                        empty_field = 0;
                    }
                }
            });
            if (empty_field != 0 && driver != 'database') {
                e.preventDefault();
                alert('Please fill all required values.');
            }
        });

        $('input[type=text]').on('blur', function(){
            if($(this).attr('name') == 'host' || $(this).attr('name') == 'master_key' || $(this).attr('name') == 'a_id' || $(this).attr('name') == 'a_secret_key'){
                if ($(this).val() == '') {
                    addErrorClass($(this).attr('name'));
                }
            }
        })

        function addErrorClass(name){
            var target = document.getElementsByName(name);
            $(target[0]).css('border-color','red');
            $(target[0]).css('border-width','1px');
        }

        $('input').on('focus', function(){
            $(this).css('border-color','#A9A9A9')
            $(this).css('border-width','1px');
        })

        function toggleSSLSettings()
        {
            var x = document.getElementById('additional_ssl_config');
            x.style.display = x.style.display === "none" ? "block" : "none";
        }

        $('#driver_type').change(function () {
            var type = $('#driver_type').val();

            if(type == 'database') {
                $('#m_host').hide();
                $('#m_master_key').hide();
                $('#a_id').hide();
                $('#a_secret_key').hide();
                $('#driver_tooltip_database').show();
                $('#driver_tooltip_meilisearch').hide();
                $('#driver_tooltip_algolia').hide();
            } else if(type == 'algolia') {
                $('#m_host').hide();
                $('#m_master_key').hide();
                $('#a_id').show();
                $('#a_secret_key').show();
                $('#driver_tooltip_database').hide();
                $('#driver_tooltip_meilisearch').hide();
                $('#driver_tooltip_algolia').show();
            } else if(type == 'meilisearch'){
                $('#m_host').show();
                $('#m_master_key').show();
                $('#a_id').hide();
                $('#a_secret_key').hide();
                $('#driver_tooltip_database').hide();
                $('#driver_tooltip_meilisearch').show();
                $('#driver_tooltip_algolia').hide();
            }
        })
    </script>
    </div>
@stop