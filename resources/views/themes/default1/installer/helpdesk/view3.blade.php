@extends('themes.default1.installer.layout.installer')

@section('searchDriver')
    done
@stop

@section('license')
done
@stop

@section('environment')
done
@stop

@section('database')
active
@stop

@section('content')
<div ng-app="myApp">
    <h1 style="text-align: center;">Database Setup</h1>
    <p class="wc-setup-content">Enter your database connection details.</p>

    @if(Cache::has('fails'))
    <div class="wc-setup-content">
        <div class="woocommerce-message woocommerce-tracker">
            <div class="fail">
                <span id="fail">{!! Lang::get('lang.fails') !!}! {{Cache::get('fails')}}</span><br/><br/>
            </div>
        </div>        
    </div>  
    <?php Cache::forget('fails')?>
    @endif

    @if($errors->has('default') || $errors->has('host') || $errors->has('port') || $errors->has('databasename') || $errors->has('username') || $errors->has('password'))
    <div class="wc-setup-content">
        <div class="woocommerce-message woocommerce-tracker">
            <div class="fail">
                {!! $errors->first('default', '<spam id="fail">:message</spam><br/>') !!}
                {!! $errors->first('host', '<spam id="fail">:message</spam><br/>') !!}
                {!! $errors->first('port', '<spam id="fail">:message</spam><br/>') !!}
                {!! $errors->first('databasename', '<spam id="fail">:message</spam><br/>') !!}
                {!! $errors->first('username', '<spam id="fail">:message</spam><br/>') !!}
                {!! $errors->first('password', '<spam id="fail">:message</spam><br/>') !!}
                {!! $errors->first('db_ssl_key', '<spam id="fail">:message</spam><br/>') !!}
                {!! $errors->first('db_ssl_cert', '<spam id="fail">:message</spam><br/>') !!}
                {!! $errors->first('db_ssl_ca', '<spam id="fail">:message</spam><br/>') !!}
                <br/>
            </div>
        </div>
    </div>
    @endif

    {!! html()->form('POST', url('/config'))->id('databaseform')->open() !!}
    <table ng-controller="MainController">
        <tr>
        <td>
            <label for="box10">Database type</label>
        </td>
        <td>
            <select name="default" id="database_type" style="width:280px;height:26px;">
                <option value="mysql" selected>Default</option>
                <option value="cluster">Write/Read nodes</option>
            </select>
        </td>

        </tr>
        <tr id="write_host" style="display: none">
            <td>
                <label for="box11">Write Host<span style="color: red;font-size:12px;">*</span></label>
            </td>
            <td>
                {!! html()->text('write_host', '192.168.1.1') !!}
            </td>
        </tr>
        <tr id="read_host" style="display: none">
            <td>
                <label for="box12">Read Host<span style="color: red;font-size:12px;">*</span></label>
            </td>
            <td id="read_host_input">
                {!! html()->text('read_host', '192.168.1.2') !!}
            </td>
            <td>
                <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="{{trans('lang.read_node')}}" data-content="{{trans('lang.read_node_description')}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                </button>
            </td>
        </tr>
        <tr id="default_host">
            <td>
                <label for="box1">Host<span style="color: red;font-size:12px;">*</span></label>
            </td>
            <td>
                {!! html()->text('host', 'localhost')->required() !!}
            </td>
            <td>
                <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="@{{Hosttitle}}" data-content="@{{Hostcontent}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                </button>
            </td>
        </tr>
        <tr>
            <td>
                <label for="box2">MySQL port number</label>
            </td>
            <td>
                {!! html()->text('port', null)->attribute('onkeydown', 'return CheckPortForInput(event)') !!}
            </td>
            <td>
                <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="@{{Porttitle}}" data-content="@{{Portcontent}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                </button>
            </td>
        </tr>
        <tr>
            <td>
                <label for="box3">Database Name<span style="color: red;font-size:12px;">*</span></label>
            </td>
            <td>
                {!! html()->text('databasename', null)->required() !!}
            </td>

        </tr>
        <tr>
            <td>
                <label for="box4">Username<span style="color: red; font-size: 12px;">*</span></label>
            </td>
            <td>
                {!! html()->text('username', null)->required() !!}
            </td>
       
        </tr>
        <tr>
            <td>
                <label for="box5">Password</label>
            </td>
            <td>
                <input type="password" name="password"> 
            </td>
    
        </tr>
        </table>
        <p class="wc-setup-content" ng-controller="MainController">Want secure connection to your database? <a href="javascript:toggleSSLSettings()">Click here</a>
        <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="@{{SSLConnectiontitle}}" data-content="@{{SSLConnectionSettingcontent}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                </button></p>
        <table id="additional_ssl_config" style="display:none;" ng-controller="MainController">
        <tr>
            <td>
                <label for="box6">Path to SSL Key File</label>
            </td>
            <td>
                <input type="text" name="db_ssl_key"> 
            </td>
            <td>
                <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="@{{SSLKeytitle}}" data-content="@{{SSLKeycontent}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                </button>
            </td>
        </tr>
        <tr>
            <td>
                <label for="box7">Path to SSL Cert File</label>
            </td>
            <td>
                <input type="text" name="db_ssl_cert"> 
            </td>
            <td>
                <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="@{{SSLCerttitle}}" data-content="@{{SSLCertcontent}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                </button>
            </td>
        </tr>
        <tr>
            <td>
                <label for="box8">Path to SSL CA File</label>
            </td>
            <td>
                <input type="text" name="db_ssl_ca"> 
            </td>
            <td>
                <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="@{{SSLCAtitle}}" data-content="@{{SSLCAcontent}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                </button>
            </td>
        </tr>
        <tr>
            <td>
                <label for="box9">Verify SSL Peer</label>
            </td>
            <td>
                <select name="db_ssl_verify" style="width:280px;height:26px;">
                    <option value="true">YES</option>
                    <option value="false" selected>NO</option>
                </select>
            </td>
            <td>
                <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="@{{VerifySSLtitle}}" data-content="@{{VerifySSLcontent}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                </button>
            </td>
        </tr>
    </table>
    <br>
    <p ng-controller="MainController">
        <input id="dummy-data" class="input-checkbox" type="checkbox" name="dummy-data">
            <label for="dummy-data" style="color:#3AA7D9">Install with dummy data</label>
            <button type="button" data-bs-toggle="popover" tabIndex="-1" data-placement="right" data-arrowcolor="#eeeeee" data-bordercolor="#bbbbbb" data-title-backcolor="#cccccc" data-title-bordercolor="#bbbbbb" data-title-textcolor="#444444" data-content-backcolor="#eeeeee" data-content-textcolor="#888888" title="@{{DummyDataTitle}}" data-content="@{{DummyDataContent}}" style="padding: 0px;border: 0px; border-radius: 5px;"><i class="fa fa-question-circle" style="padding: 0px;"></i>
                            </button>
    </p>
    <p class="setup-actions step">
        <input type="submit" id="submitme" class="button-primary button button-large button-next" value="Continue">
        <a href="{!! route('search-driver-setup') !!}" class="button button-large button-next" style="float: left">Previous</a>
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
        var empty_field = 0;
        $("#databaseform input[type=text]").each(function(){
            if($(this).attr('name') == 'host' || $(this).attr('name') == 'databasename' || $(this).attr('name') == 'username'){
                if ($(this).val() == '') {
                    $(this).css('border-color','red')
                    $(this).css('border-width','1px');
                    empty_field = 1;
                } else {
                    empty_field = 0;
                }
            }
        });
        if (empty_field != 0) {
            e.preventDefault();
            alert('Please fill all required values.');
        }
    });

    $('input[type=text]').on('blur', function(){
        if($(this).attr('name') == 'host' || $(this).attr('name') == 'databasename' || $(this).attr('name') == 'username'){
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

    $('#database_type').change(function () {
        var type = $('#database_type').val();

        if(type == 'cluster') {
            $('#write_host').show();
            $('#read_host').show();
            $('#default_host').hide();
        } else {
            $('#write_host').hide();
            $('#read_host').hide();
            $('#default_host').show();
        }
    })
</script>
</div>
@stop