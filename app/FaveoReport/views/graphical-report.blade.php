<!DOCTYPE html>
<html>
    <head>
        <title> {{ $reportDownload->type ?? 'Report' }}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

        <style type="text/css">
            body{
                font-size : 70%;
                color: black;
            }
            img {
                width: 100%;
                max-height: 900px;
            }
        </style>

    </head>
    <body>
    <h2 style="text-align: center">{{$reportDownload->type ? \Illuminate\Support\Str::headline($reportDownload->type) : 'Report'}}</h2>        <br>
        <div style="background-color: rgba(0,0,0,0.04); padding: 2px 2px 2px 2px;">{!! $image !!}</div>
{{--        <div style="background-color: rgba(0,0,0,0.04); padding: 2px 2px 2px 2px; border: 1px solid black;">--}}
{{--            <p><img src="https://lakshya.localhost/faveo/public/storage/graphical_reports/report.png" style="width: 100%;"/></p>--}}
{{--        </div>--}}
{{--        https://lakshya.localhost/faveo/public/api/view-attachment-kb?expires=8021177653&hash=eyJpdiI6ImRUVytBd0N1dHRNRFowUzlIRHIrNUE9PSIsInZhbHVlIjoiOFZOUnAwVUhrd2t1SDlhdXBlY1JQaDhrS0hZNUtmeGFLQ2FLTnpCeUFHZ3NuZkVIOWltQTN6TmgxbTVBcjN0RyIsIm1hYyI6ImU4ZjI0MjVjYzU0Zjc0MzUzNWIzN2E1MTBiYzliNjc2MGUzNzYzZGU1YzBjZDExMDMxYWI5MjU4MWNlNTMyYzkiLCJ0YWciOiIifQ%3D%3D&no-auth=1&signature=0842eaf8c84c18cd0397f0143610809ffdc5dc14b38ba96c92643c6db1578361--}}
    {{--    <img src="https://png.pngtree.com/png-vector/20200312/ourmid/pngtree-modern-flat-design-concept-of-digital-marketing-with-giant-megaphone-and-png-image_2157858.jpg" alt="report">--}}
    {{--    <img src="https://lakshya.localhost/faveo/public/v3/api/view-attachment-kb?hash=eyJpdiI6Inlzb1MrcXFmTm83bTNGY2ZJWFFxclE9PSIsInZhbHVlIjoiUzQ4YTZQV2xWdlVkK1J3MDFZRHp1dHhOK1NKRlRHallBQXVpTGpyclpNSmtvTTA2b010SGJ1c3VucUxGMXBUMXJPWkRaKzNuamgzbGxqYUtvUWVEZzhyVVI4c0xPdmNyQklNQm1mc1dIQXNHVC9iYVU0c2dTUDlvNkFOb0NuMmNyVXAycXN3MWR1S1JaQ3RpMDMxaUt3PT0iLCJtYWMiOiI0M2Y0YmVkNmI3OTM5ODdjYjY2M2JmN2Q2YjQ1MjU5MWQ2MWE1ZTlhNDlkNjNhYzg2M2EyOTA1NjAxZjEwMGNmIiwidGFnIjoiIn0%3D&no-auth=1&signature=a4e2b54dccdef409af7f5fd821c54be5ceb454b234c377da8de70df822bfd0d1" alt="report">--}}
    {{--    <img src="{!! $image !!}"  alt="report">--}}
    {{--{!! $image !!}--}}
    </body>
</html>
