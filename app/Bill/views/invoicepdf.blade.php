<!DOCTYPE html>
<?php
$lang = \Lang::getLocale();
$class = $lang == 'ar' ? "ar": "nonar";
?>
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
   <title>{{trans('Bill::lang.invoice')}}</title>
   <style type="text/css">
      .ar {
         direction: rtl;
         text-align: right;
         font-family: 'dejavu sans, arial', sans-serif;
      }

      .nonar{
         font-family: 'dejavu sans, arial,', sans-serif;
         font-size: small;
      }

      body{
         margin: 100px !important;
      }
   </style>
   <link rel="stylesheet" href="{{assetLink('css','bootstrap')}}">
   <!-- Font Awesome Icons -->
</head>
<body class="{!! $class !!}">
<div  class="row">
   <div  class="col-sm-4">
      <?php $output = $invoiceInfo['order']['status'] ? 'paid' : 'unpaid';?>
      <h3  class="page-header"><i  class="fas fa-globe"></i> {{strtoupper(trans("lang.$output"))}}
      </h3>
   </div>
</div>

<div  class="invoice-info">
   <div  class="row">
      <div  class="col-sm-4">
         <div  class="invoice_box box-solid">
            <div  class="box-header">
               <h4  class="box-title">{{trans('lang.from')}}</h4>
            </div>
            <div  class="box-body">
               @foreach($invoiceInfo['from'] as $key => $value)
                  @if($key !== 'website')
                     <b>{!! $key !!} </b>: <span>{!! $value ? $value : trans('lang.not_mentioned') !!}</span><br/>
                  @endif
               @endforeach
            </div>
         </div>
      </div>
      <div  class="col-sm-4">
         <div  class="invoice_box box-solid">
            <div  class="box-header">
               <h4  class="box-title">{{trans('lang.to')}}</h4>
            </div>
            <div  class="box-body">
               <address ><strong >{{$invoiceInfo['order']['user']['full_name']}}</strong><br >
                  <b> {{trans('lang.email')}}</b>: <span >{{!empty($invoiceInfo['order']['user']['email']) ? $invoiceInfo['order']['user']['email'] : trans('lang.not_mentioned')}}</span>
               </address>
            </div>
         </div>
      </div>
      <div  class="col-sm-4">
         <div  class="invoice_box box-solid">
            <div  class="box-header">
               <h4  class="box-title">{{trans('Bill::lang.invoice_details')}}</h4>
            </div>
            <div  class="box-body">
               <address ><b >{{trans('Bill::lang.invoice')}}</b> <span>#{{$invoiceInfo['invoice_id']}}</span><br >
                  <b>{{trans('Bill::lang.order_id')}}</b> : <span >{{$invoiceInfo['order']['order_id']}}</span><br >
                  <b>{{trans('Bill::lang.paid_on')}}</b> : <span >{{$invoiceInfo['paid_date'] ? faveoDate($invoiceInfo['paid_date']) : null}}</span><br >
               </address>
            </div>
         </div>
      </div>
   </div>
</div>
<div  class="row">
   <div  class="col-md-12">
      <div  class="invoice_box box-solid">
         <div  class="box-header">
            <h4  class="box-title">{{trans('Bill::lang.package')}}</h4>
         </div>
         <div  class="box-body">
            <table  class="table table-striped">
               <thead >
               <tr >
                  <th class="{!! $class !!}">{{trans('lang.name')}}</th>
                  <th class="{!! $class !!}">{{trans('lang.description')}}</th>
                  <th class="{!! $class !!}">{{trans('Bill::lang.validity')}}</th>
                  <th class="{!! $class !!}">{{trans('Bill::lang.price')}}</th>
               </tr>
               </thead>
               <tbody >
               <tr >
                  <td >{{$invoiceInfo['order']['package']['name']}}</td>
                  <td >{{$invoiceInfo['order']['package']['description']}}</td>
                  <td >{{($invoiceInfo['order']['package']['validity']) ? : 'One time'}}</td>
                  <td  id="product_price">
                     <div data-v-36779b28=""  id="Price" class="form-group">
                        <label for="Price" style="display: none;">{{trans('Bill::lang.price')}}</label> <label style="color: rgb(220, 53, 69); display: none;">*</label> <!---->
                        <div>
                           <span data-v-36779b28="" class="inline">{{$invoiceInfo['order']['package']['price']}}</span> <!---->
                        </div>
                     </div>
                  </td>
               </tr>
               </tbody>
            </table>
         </div>
      </div>
   </div>
</div>
<div  class="row">
   <div  class="col-md-12">
      <div  class="invoice_box box-solid">
         <div  class="box-header">
            <h4  class="box-title">{{trans('Bill::lang.transaction_details')}}</h4>
         </div>
         <div  class="box-body">
            <table  class="table table-striped">
               <thead >
               <tr >
                  <th class="{!! $class !!}">{{trans('Bill::lang.id')}}</th>
                  <th class="{!! $class !!}">{{trans('Bill::lang.payment_method')}}</th>
                  <th class="{!! $class !!}">{{trans('Bill::lang.amount_paid')}}</th>
                  <th class="{!! $class !!}">{{trans('Bill::lang.paid_date')}}</th>
                  <th class="{!! $class !!}">{{trans('lang.status')}}</th>
               </tr>
               </thead>
               @foreach($invoiceInfo['transactions'] as $transaction)
                  <tbody >
                  <tr >
                     <td >{{$transaction['transactionId']}}</td>
                     <td >{{$transaction['payment_method']}}</td>
                     <td >{{$transaction['amount_paid']}}</td>
                     <td >{{faveoDate($invoiceInfo['paid_date'])}}</td>
                     <td >
                           <?php
                           $outputStatus = $transaction['status'] ? 'Sucessful' : 'Unsucessful';
                           $btnClass = $transaction['status']? 'btn-success': 'btn-danger';
                           ?>
                        <a  id="status">
                           <span  title="Status" id="edit_btn" class="btn btn-xs {{$btnClass}}">
                        	{{$outputStatus}}
                           </span>
                        </a>
                     </td>
                  </tr>
                  </tbody>
               @endforeach
            </table>
         </div>
      </div>
   </div>
</div>
<div  class="row">
   <div  class="col-md-12">
      <div  class="invoice_box box-solid">
         <div  class="box-header">
            <h4  class="box-title">{{trans('Bill::lang.payment_details')}}</h4>
         </div>
         <div  class="box-body">
            <table  class="table">
               <tbody >
               @if($invoiceInfo['paid_date'])
                  <tr >
                     <th class="{!! $class !!}"  style="width: 50%;">{{trans('Bill::lang.paid_on')}} : </th>
                     <td >{{faveoDate($invoiceInfo['paid_date'])}}</td>
                  </tr>
               @endif
               <tr >
                  <th class="{!! $class !!}" style="width: 50%;">{{trans('Bill::lang.paid_amount')}} : </th>
                  <td >{{currencySymbol(commonSettings('bill', 'currency')).' '.$invoiceInfo['amount_paid']}}</td>
               </tr>
               <tr >
                  <th class="{!! $class !!}" style="width: 50%;">{{trans('Bill::lang.balance')}} : </th>
                  <td >{{currencySymbol(commonSettings('bill', 'currency')).' '.($invoiceInfo['amount_paid'] - $invoiceInfo['payable_amount'])}}</td>
               </tr>
               <tr >
                  <th class="{!! $class !!}" >{{trans('lang.total')}}  :</th>
                  <td >{{currencySymbol(commonSettings('bill', 'currency')).' '.$invoiceInfo['payable_amount']}}</td>
               </tr>
               </tbody>
            </table>
            <br>
         </div>
      </div>
   </div>
</div>
</body>
<script src="{{assetLink('js','bootstrap-5')}}" type="text/javascript"></script>
</html>